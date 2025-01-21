import Foundation
import os.log

struct Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.vybe.app"
    
    static let coreData = OSLog(subsystem: subsystem, category: "coredata")
    static let location = OSLog(subsystem: subsystem, category: "location")
    static let focus = OSLog(subsystem: subsystem, category: "focus")
    static let ui = OSLog(subsystem: subsystem, category: "ui")
    static let realm = OSLog(subsystem: subsystem, category: "realm")
    static let lifecycle = OSLog(subsystem: subsystem, category: "lifecycle")
    
    static func log(_ message: String, type: OSLogType = .default, log: OSLog = .default, file: String = #file, line: Int = #line) {
        #if DEBUG
        // Filter out unwanted messages
        if message.contains("Can't find or decode reasons") ||
           message.contains("Failed to get or decode") ||
           message.contains("CoreGraphics API") {
            return
        }
        os_log("%{public}@", log: log, type: type, message)
        #endif
    }
    
    // Convenience methods
    static func debug(_ message: String, category: OSLog = .default) {
        log(message, type: .debug, log: category)
    }
    
    static func error(_ message: String, category: OSLog = .default) {
        log(message, type: .error, log: category)
    }
} 