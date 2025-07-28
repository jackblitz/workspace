#include <iostream>
#include <string>
#include <chrono>
#include <thread>
#include <filesystem>

#ifdef _WIN32
#include <windows.h>
#else
#include <unistd.h>
#include <limits.h>
#endif

#include "game_logic_loader.h"
#include "interfaces/Logger.h"

// Function to get the directory of the current executable
std::filesystem::path get_executable_directory() {
#ifdef _WIN32
    char buffer[MAX_PATH];
    GetModuleFileNameA(NULL, buffer, MAX_PATH);
    return std::filesystem::path(buffer).parent_path();
#else
    char buffer[PATH_MAX];
    ssize_t len = readlink("/proc/self/exe", buffer, sizeof(buffer) - 1);
    if (len != -1) {
        buffer[len] = '\0';
        return std::filesystem::path(buffer).parent_path();
    }
    return std::filesystem::current_path(); // Fallback
#endif
}

int main() {
    polaris::polaris_get_logger().initialize("host.log");
    polaris::polaris_get_logger().setLogLevel(polaris::LogLevel::DEBUG_LEVEL);
    LOG_INFO("Host application started.");
    
#ifdef STATIC_BUILD
    LOG_INFO("Running in STATIC BUILD mode - no hot reloading available");
#else
    LOG_INFO("Running in DYNAMIC BUILD mode - hot reloading enabled");
#endif

    std::string dll_name = "game_logic"; // Base name for the library
    std::filesystem::path exe_dir = get_executable_directory();
    
    GameLogicLoader loader;
    
    // Initial load
    if (!loader.load(exe_dir, "game_logic")) {
        LOG_ERROR("Failed to load game logic module");
        polaris::polaris_get_logger().shutdown();
        std::this_thread::sleep_for(std::chrono::milliseconds(100)); // Small delay to ensure logs flush
        return 1;
    }

    // Main loop
    for (int i = 0; i < 20000; ++i) { // Run for a few seconds to demonstrate
        LOG_DEBUG("Main loop iteration: " + std::to_string(i));
        std::this_thread::sleep_for(std::chrono::milliseconds(500));

#ifndef STATIC_BUILD
        // Check for DLL changes only in dynamic builds
        if (!loader.checkAndReload()) {
            LOG_ERROR("Failed to reload DLL! Exiting...");
            break;
        }
#endif

        IEngineContext* engine_context = loader.getContext();
        if (engine_context) {
            engine_context->on_update(0.016f); // Simulate a frame update
            engine_context->draw_ui_element("MainUI", 100.0f, 200.0f);
        }
    }

    // Cleanup is handled by the loader's destructor
    polaris::polaris_get_logger().shutdown();

    LOG_INFO("Host application finished.");

    return 0;
}