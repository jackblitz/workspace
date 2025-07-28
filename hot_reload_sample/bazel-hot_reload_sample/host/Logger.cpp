#include "interfaces/Logger.h"
#include <iostream>
#include <fstream>
#include <sstream>
#include <chrono>
#include <iomanip>
#include <mutex>
#include <ctime>

#ifdef _WIN32
#include <windows.h>
#elif defined(__APPLE__)
#include <os/log.h>
#elif defined(__ANDROID__)
#include <android/log.h>
#endif

namespace polaris {

// The full implementation of the Logger's private details.
class Logger::Impl {
public:
    std::ofstream logFile;
    std::mutex logMutex;

    std::string getTimestamp() {
        auto now = std::chrono::system_clock::now();
        auto time_t = std::chrono::system_clock::to_time_t(now);
        auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(
            now.time_since_epoch()) % 1000;

        std::stringstream ss;
        ss << std::put_time(std::localtime(&time_t), "%Y-%m-%d %H:%M:%S");
        ss << '.' << std::setfill('0') << std::setw(3) << ms.count();
        return ss.str();
    }
    
    std::string getLevelString(LogLevel level) {
        switch (level) {
            case LogLevel::TRACE: return "TRACE";
            case LogLevel::DEBUG_LEVEL: return "DEBUG";
            case LogLevel::INFO: return "INFO";
            case LogLevel::WARN: return "WARN";
            case LogLevel::CRITICAL: return "CRITICAL";
            case LogLevel::ERROR_LOG: return "ERROR";
            default: return "UNKNOWN";
        }
    }
};

// Constructor and Destructor implementations
Logger::Logger() : m_currentLevel(LogLevel::INFO) {
    m_impl = std::make_unique<Impl>();
}
Logger::~Logger() = default;

// Factory function implementation
Logger& polaris_get_logger() {
    static Logger instance;
    return instance;
}

void Logger::initialize(const std::string& logFile) {
    if (m_initialized) return;
    m_impl->logFile.open(logFile, std::ios::app);
    if (!m_impl->logFile.is_open()) {
        std::cerr << "Failed to open log file: " << logFile << std::endl;
    }
    m_initialized = true;
    info("Logger initialized");
}

void Logger::shutdown() {
    if (!m_initialized) return;
    info("Logger shutting down");
    if (m_impl->logFile.is_open()) {
        m_impl->logFile.close();
    }
    m_impl.reset();
    m_initialized = false;
}

void Logger::setLogLevel(LogLevel level) {
    m_currentLevel = level;
}

void Logger::logToFile(const std::string& message, LogLevel level) {
    if (!m_impl->logFile.is_open()) return;
    std::lock_guard<std::mutex> lock(m_impl->logMutex);
    std::string timestamp = m_impl->getTimestamp();
    std::string levelStr = m_impl->getLevelString(level);
    m_impl->logFile << "[" + timestamp + "] [" + levelStr + "] " + message << std::endl;
    m_impl->logFile.flush();
}

void Logger::logToConsole(const std::string& message, LogLevel level) {
    std::lock_guard<std::mutex> lock(m_impl->logMutex);
    std::string timestamp = m_impl->getTimestamp();
    std::string levelStr = m_impl->getLevelString(level);
    std::cout << "[" << timestamp << "] [" << levelStr << "] " << message << std::endl;
    std::cout.flush();
}

void Logger::trace(const std::string& message) {
    if (m_currentLevel <= LogLevel::TRACE) {
        logToConsole(message, LogLevel::TRACE);
        logToFile(message, LogLevel::TRACE);
    }
}
void Logger::debug(const std::string& message) {
    if (m_currentLevel <= LogLevel::DEBUG_LEVEL) {
        logToConsole(message, LogLevel::DEBUG_LEVEL);
        logToFile(message, LogLevel::DEBUG_LEVEL);
    }
}
void Logger::info(const std::string& message) {
    if (m_currentLevel <= LogLevel::INFO) {
        logToConsole(message, LogLevel::INFO);
        logToFile(message, LogLevel::INFO);
    }
}
void Logger::warn(const std::string& message) {
    if (m_currentLevel <= LogLevel::WARN) {
        logToConsole(message, LogLevel::WARN);
        logToFile(message, LogLevel::WARN);
    }
}
void Logger::error(const std::string& message) {
    if (m_currentLevel <= LogLevel::ERROR_LOG) {
        logToConsole(message, LogLevel::ERROR_LOG);
        logToFile(message, LogLevel::ERROR_LOG);
    }
}
void Logger::critical(const std::string& message) {
    if (m_currentLevel <= LogLevel::CRITICAL) {
        logToConsole(message, LogLevel::CRITICAL);
        logToFile(message, LogLevel::CRITICAL);
    }
}

} // namespace polaris