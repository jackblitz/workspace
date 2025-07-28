#pragma once

#include <filesystem>
#include "interfaces/IEngineContext.h"
#include "interfaces/Logger.h"

#ifdef STATIC_BUILD
// For static builds, directly reference the function
extern "C" IEngineContext* get_engine_context_api();
#endif

// Export/import macros for Windows
#ifdef _WIN32
    #ifdef LOGGER_DLL_EXPORT
        #define HOST_API __declspec(dllexport)
    #else
        #define HOST_API __declspec(dllimport)
    #endif
#else
    #define HOST_API
#endif

class HOST_API GameLogicLoader {
private:
    void* engine_context_lib = nullptr;
    IEngineContext* engine_context = nullptr;
    
#ifndef STATIC_BUILD
    std::filesystem::path current_dll_full_path;
    std::filesystem::path temp_dll_full_path;
    std::filesystem::file_time_type last_write_time{};
#endif

public:
    GameLogicLoader() = default;
    ~GameLogicLoader() { unload(); }
    
    bool load(const std::filesystem::path& exe_dir, const std::string& dll_name);
    void unload();
    bool checkAndReload();
    
    IEngineContext* getContext() { return engine_context; }
    
private:
#ifndef STATIC_BUILD
    bool loadDynamicLibrary();
    void unloadDynamicLibrary();
    std::string getLastErrorMessage();
#endif
};