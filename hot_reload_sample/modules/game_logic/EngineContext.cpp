#include "interfaces/IEngineContext.h"
#include "interfaces/Logger.h" // Correct include path
#include <unordered_map>
#include <iostream>

// Use a global pointer for the injected logger within the DLL
// This will be set by the host
static polaris::Logger* g_dll_logger = nullptr;

// Redefine LOG_INFO and other macros to use the injected logger
// This must be done *after* including the original Logger.h
#undef LOG_TRACE
#undef LOG_DEBUG
#undef LOG_INFO
#undef LOG_WARN
#undef LOG_ERROR
#undef LOG_CRITICAL

#define LOG_TRACE(msg) if (g_dll_logger) g_dll_logger->trace(msg)
#define LOG_DEBUG(msg) if (g_dll_logger) g_dll_logger->debug(msg)
#define LOG_INFO(msg) if (g_dll_logger) g_dll_logger->info(msg)
#define LOG_WARN(msg) if (g_dll_logger) g_dll_logger->warn(msg)
#define LOG_ERROR(msg) if (g_dll_logger) g_dll_logger->error(msg)
#define LOG_CRITICAL(msg) if (g_dll_logger) g_dll_logger->critical(msg)

class EngineContext : public IEngineContext {
public:
    void on_load() override {
        std::cout << "DEBUG: on_load called, g_dll_logger = " << g_dll_logger << std::endl;
        LOG_INFO("  [EngineContext] Loaded");
    }

    void on_update(float dt) override {
        std::cout << "DEBUG: on_update called with dt = " << dt << ", g_dll_logger = " << g_dll_logger << std::endl;
        LOG_INFO("  [EngineContext] Updated with  dt:" + std::to_string(dt));
    }

    void on_unload() override {
        LOG_INFO("  [EngineContext] Unloaded");
    }

    void on_reload_begin() override {
        LOG_INFO("  [EngineContext] Reload Begin");
    }

    void on_reload_end() override {
        LOG_INFO("  [EngineContext] Reload End");
    }

    void register_module(const char* name, void* module_api) override {
        LOG_INFO("  [EngineContext] Registering module: " + std::string(name));
        modules_[name] = module_api;
    }

    void* get_module_api(const char* name) override {
        auto it = modules_.find(name);
        if (it != modules_.end()) {
            return it->second;
        }
        LOG_WARN("  [EngineContext] Module not found: " + std::string(name));
        return nullptr;
    }

    void draw_ui_element(const char* element_id, float x, float y) override {
        LOG_INFO("  [EngineContext] Drawing UI element: " + std::string(element_id) + " at (" + std::to_string(x) + ", " + std::to_string(y) + ")");
    }

    void set_logger(polaris::Logger* logger) override {
        std::cout << "DEBUG: set_logger called with logger = " << logger << std::endl;
        g_dll_logger = logger;
        LOG_INFO("  [EngineContext] Logger injected.");
    }

private:
    std::unordered_map<std::string, void*> modules_;
};

static EngineContext g_engine_context;

extern "C" GAME_API IEngineContext* get_engine_context_api() {
    std::cout << "DEBUG: get_engine_context_api called, returning " << &g_engine_context << std::endl;
    return &g_engine_context;
}
