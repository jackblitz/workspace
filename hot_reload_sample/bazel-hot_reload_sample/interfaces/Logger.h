#ifndef POLARIS_LOGGER_H
#define POLARIS_LOGGER_H

#include <memory>
#include <string>

// DLL export/import macros for Windows
#ifdef _WIN32
    #ifdef LOGGER_DLL_EXPORT
        #define LOGGER_API __declspec(dllexport)
    #else
        #define LOGGER_API __declspec(dllimport)
    #endif
#else
    #define LOGGER_API
#endif

namespace polaris {

enum class LogLevel {
    TRACE = 0,
    DEBUG_LEVEL = 1,
    INFO = 2,
    WARN = 3,
    ERROR_LOG = 4,
    CRITICAL = 5
};

// The Logger class is now exported from the host.
class LOGGER_API Logger {
public:
    Logger();
    ~Logger();

    void initialize(const std::string& logFile = "vega42.log");
    void shutdown();
    void setLogLevel(LogLevel level);
    
    void trace(const std::string& message);
    void debug(const std::string& message);
    void info(const std::string& message);
    void warn(const std::string& message);
    void error(const std::string& message);
    void critical(const std::string& message);
    
    void logToConsole(const std::string& message, LogLevel level);
    void logToFile(const std::string& message, LogLevel level);
    
private:
    Logger(const Logger&) = delete;
    Logger& operator=(const Logger&) = delete;
    
    class Impl;
    std::unique_ptr<Impl> m_impl;
    
    bool m_initialized = false;
    LogLevel m_currentLevel;
};

// This is the new, exported factory function that replaces getInstance().
extern "C" LOGGER_API Logger& polaris_get_logger();

// Convenience macros now use the factory function.
#define LOG_TRACE(msg) polaris::polaris_get_logger().trace(msg)
#define LOG_DEBUG(msg) polaris::polaris_get_logger().debug(msg)
#define LOG_INFO(msg)  polaris::polaris_get_logger().info(msg)
#define LOG_WARN(msg)  polaris::polaris_get_logger().warn(msg)
#define LOG_ERROR(msg) polaris::polaris_get_logger().error(msg)
#define LOG_CRITICAL(msg) polaris::polaris_get_logger().critical(msg)

} // namespace polaris

#endif // POLARIS_LOGGER_H
