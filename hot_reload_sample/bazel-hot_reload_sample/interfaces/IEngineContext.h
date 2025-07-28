#pragma once

#if defined(_WIN32) && defined(GAME_DLL_EXPORT)
    #define GAME_API __declspec(dllexport)
#elif defined(_WIN32) && defined(GAME_DLL_IMPORT)
    #define GAME_API __declspec(dllimport)
#else
    #define GAME_API
#endif

namespace polaris {
    class Logger; // Forward declaration
}

struct IEngineContext {
    virtual void on_load() = 0;
    virtual void on_update(float dt) = 0;
    virtual void on_unload() = 0;
    virtual void on_reload_begin() = 0;
    virtual void on_reload_end() = 0;

    // API for modules and packages
    virtual void register_module(const char* name, void* module_api) = 0;
    virtual void* get_module_api(const char* name) = 0;

    // API for UI (simplified for this example)
    virtual void draw_ui_element(const char* element_id, float x, float y) = 0;

    // Method to inject the logger instance from the host
    virtual void set_logger(polaris::Logger* logger) = 0;
};

extern "C" GAME_API IEngineContext* get_engine_context_api();
