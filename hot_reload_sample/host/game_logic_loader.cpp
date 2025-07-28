#include "game_logic_loader.h"
#include <iostream>
#include <thread>
#include <filesystem>
#include <chrono>

#ifdef _WIN32
#include <windows.h>
#include <libloaderapi.h>
#else
#include <dlfcn.h>
#include <unistd.h>
#include <limits.h>
#endif

bool GameLogicLoader::load(const std::filesystem::path& exe_dir, const std::string& dll_name) {
#ifdef STATIC_BUILD
    // For static builds, directly get the engine context
    engine_context = get_engine_context_api();
    if (engine_context) {
        engine_context->set_logger(&polaris::polaris_get_logger());
        LOG_INFO("Successfully obtained IEngineContext API (static build)");
        engine_context->on_load();
        return true;
    } else {
        LOG_ERROR("get_engine_context_api returned a null pointer!");
        return false;
    }
#else
    // For dynamic builds, set up paths and load the DLL
    std::string dll_extension = ".dll";
#ifndef _WIN32
    dll_extension = ".so";
#endif

    std::string current_dll_path_relative = dll_name + dll_extension;
    std::string temp_dll_path_relative = "temp_" + dll_name + dll_extension;
    
    current_dll_full_path = exe_dir / current_dll_path_relative;
    temp_dll_full_path = exe_dir / temp_dll_path_relative;
    
#ifdef _WIN32
    SetDllDirectoryA(exe_dir.string().c_str());
#endif
    
    return loadDynamicLibrary();
#endif
}

void GameLogicLoader::unload() {
#ifdef STATIC_BUILD
    if (engine_context) {
        engine_context->on_unload();
        engine_context = nullptr;
    }
#else
    unloadDynamicLibrary();
#endif
}

bool GameLogicLoader::checkAndReload() {
#ifdef STATIC_BUILD
    // No hot reloading in static builds
    return true;
#else
    std::filesystem::file_time_type current_dll_write_time{};
    
    // Retry logic for when file is temporarily missing during rebuild
    int retries = 5;
    while (retries > 0) {
        try {
            current_dll_write_time = std::filesystem::last_write_time(current_dll_full_path);
            break; // Success, exit retry loop
        } catch (const std::filesystem::filesystem_error& e) {
            retries--;
            if (retries == 0) {
                LOG_ERROR("Error getting file time after retries: " + std::string(e.what()));
                return false;
            }
            // File might be temporarily missing during rebuild, wait a bit
            std::this_thread::sleep_for(std::chrono::milliseconds(200));
        }
    }
    
    if (current_dll_write_time != last_write_time) {
        LOG_INFO("\n--- DLL Change Detected! Reloading... ---");
        if (engine_context) {
            engine_context->on_reload_begin();
        }
        unloadDynamicLibrary();
        
        // Give a moment for the OS to release file locks
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
        
        if (loadDynamicLibrary()) {
            if (engine_context) {
                engine_context->on_reload_end();
            }
            LOG_INFO("--- Reload Complete! ---\n");
            return true;
        } else {
            LOG_ERROR("--- Failed to reload DLL! ---\n");
            return false;
        }
    }
    return true;
#endif
}

#ifndef STATIC_BUILD
bool GameLogicLoader::loadDynamicLibrary() {
    LOG_INFO("Attempting to load DLL from: " + current_dll_full_path.string());
    LOG_INFO("Using temporary path: " + temp_dll_full_path.string());

#ifdef _WIN32
    // Give a moment for any lingering locks to clear before initial copy
    std::this_thread::sleep_for(std::chrono::milliseconds(50));

    // Wait for file to be available with retry logic
    int file_retries = 10;
    bool file_exists = false;
    while (file_retries > 0 && !file_exists) {
        try {
            file_exists = std::filesystem::exists(current_dll_full_path);
            if (!file_exists) {
                file_retries--;
                if (file_retries > 0) {
                    std::this_thread::sleep_for(std::chrono::milliseconds(200));
                }
            }
        } catch (const std::filesystem::filesystem_error& e) {
            file_retries--;
            if (file_retries > 0) {
                std::this_thread::sleep_for(std::chrono::milliseconds(200));
            }
        }
    }
    
    if (!file_exists) {
        LOG_ERROR("DLL file not found after retries: " + current_dll_full_path.string());
        return false;
    }

    // Try to delete the temp file if it exists from a previous run
    if (std::filesystem::exists(temp_dll_full_path)) {
        try {
            std::filesystem::remove(temp_dll_full_path);
        } catch (const std::filesystem::filesystem_error& e) {
            LOG_WARN("Could not remove old temp DLL: " + temp_dll_full_path.string() + ". Error: " + std::string(e.what()));
        }
    }

    LOG_INFO("Copying " + current_dll_full_path.string() + " to " + temp_dll_full_path.string());
    
    // Retry copy operation
    int copy_retries = 5;
    bool copy_success = false;
    while (copy_retries > 0 && !copy_success) {
        if (CopyFileA(current_dll_full_path.string().c_str(), temp_dll_full_path.string().c_str(), FALSE)) {
            copy_success = true;
        } else {
            copy_retries--;
            if (copy_retries > 0) {
                std::this_thread::sleep_for(std::chrono::milliseconds(200));
            }
        }
    }
    
    if (!copy_success) {
        LOG_ERROR("Failed to copy DLL after retries: " + getLastErrorMessage());
        return false;
    }
    
    if (!std::filesystem::exists(temp_dll_full_path)) {
        LOG_ERROR("Temporary DLL file does not exist after copy: " + temp_dll_full_path.string());
        return false;
    }
    
    engine_context_lib = LoadLibraryA(temp_dll_full_path.string().c_str());
#else
    engine_context_lib = dlopen(current_dll_full_path.string().c_str(), RTLD_LAZY);
#endif

    if (!engine_context_lib) {
        LOG_ERROR("Failed to load library. Error: " + getLastErrorMessage());
#ifndef _WIN32
        LOG_ERROR("Error: " + std::string(dlerror()));
#endif
        return false;
    }

    using get_engine_context_api_func = IEngineContext* (*)();
    get_engine_context_api_func get_api = nullptr;

#ifdef _WIN32
    get_api = (get_engine_context_api_func)GetProcAddress((HMODULE)engine_context_lib, "get_engine_context_api");
#else
    get_api = (get_engine_context_api_func)dlsym(engine_context_lib, "get_engine_context_api");
#endif

    if (!get_api) {
        LOG_ERROR("Failed to get 'get_engine_context_api' function");
        return false;
    }

    engine_context = get_api();
    if (engine_context) {
        // Inject the host's logger instance into the DLL
        engine_context->set_logger(&polaris::polaris_get_logger());
        LOG_INFO("Successfully obtained IEngineContext API at address: " + std::to_string((uintptr_t)engine_context));
        engine_context->on_load();
    } else {
        LOG_ERROR("get_engine_context_api returned a null pointer!");
        return false;
    }
    last_write_time = std::filesystem::last_write_time(current_dll_full_path);
    return true;
}

void GameLogicLoader::unloadDynamicLibrary() {
    if (engine_context) {
        engine_context->on_unload();
        engine_context = nullptr;
    }
    if (engine_context_lib) {
#ifdef _WIN32
        FreeLibrary((HMODULE)engine_context_lib);
        // After unloading, delete the temporary DLL
        if (std::filesystem::exists(temp_dll_full_path)) {
            try {
                std::filesystem::remove(temp_dll_full_path);
            } catch (const std::filesystem::filesystem_error& e) {
                LOG_ERROR("Filesystem error during temp DLL removal: " + std::string(e.what()));
            }
        }
#else
        dlclose(engine_context_lib);
#endif
        engine_context_lib = nullptr;
    }
}

std::string GameLogicLoader::getLastErrorMessage() {
#ifdef _WIN32
    DWORD error_code = GetLastError();
    if (error_code == 0) return std::string();

    LPSTR message_buffer = nullptr;
    size_t size = FormatMessageA(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
                                 NULL, error_code, MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), (LPSTR)&message_buffer, 0, NULL);
    std::string message(message_buffer, size);
    LocalFree(message_buffer);
    return message;
#else
    return std::string();
#endif
}
#endif