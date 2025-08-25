//
//  LaunchMetrics.swift
//  VybeMVP
//
//  Performance profiling for Phase 2A optimization
//  DEBUG-only lightweight startup and timing instrumentation
//

import Foundation
import os.log

#if DEBUG
/// Lightweight launch performance tracking (DEBUG builds only)
enum LaunchMetrics {
    private static let logger = Logger(subsystem: "com.vybe.performance", category: "LaunchMetrics")
    static var t0 = CFAbsoluteTimeGetCurrent()

    /// Mark a performance milestone with elapsed time since app launch
    static func mark(_ label: String) {
        let dt = (CFAbsoluteTimeGetCurrent() - t0) * 1000
        logger.info("⏱ \(label): \(Int(dt))ms")
    }

    /// Reset timing baseline (useful for testing)
    static func reset() {
        t0 = CFAbsoluteTimeGetCurrent()
        logger.info("🔄 LaunchMetrics reset")
    }

    /// Get current elapsed time without logging
    static func currentElapsed() -> Int {
        return Int((CFAbsoluteTimeGetCurrent() - t0) * 1000)
    }
}

/// Memory tracking utilities for performance analysis
struct MemoryTracker {
    private static let logger = Logger(subsystem: "com.vybe.performance", category: "MemoryTracker")

    /// Get current RSS (Resident Set Size) memory usage in MB
    static func currentRSS() -> Int {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4

        let result = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }

        guard result == KERN_SUCCESS else {
            logger.warning("Failed to get memory info")
            return 0
        }

        return Int(info.resident_size) / (1024 * 1024) // Convert to MB
    }

    /// Report memory usage with label
    static func reportMem(_ label: String) {
        let rss = currentRSS()
        logger.info("🧠 \(label): \(rss) MB")
    }
}

/// File I/O performance tracking
struct FileIOTracker {
    private static let logger = Logger(subsystem: "com.vybe.performance", category: "FileIOTracker")

    /// Track file load performance with size and timing
    static func tracedLoad(path: String, data: Data, loadTime: TimeInterval) {
        let ms = Int(loadTime * 1000)
        let sizeKB = data.count / 1024
        logger.debug("📄 \(path): \(sizeKB)KB in \(ms)ms")
    }
}

#else
// Production builds - no-op implementations
enum LaunchMetrics {
    static func mark(_ label: String) {}
    static func reset() {}
    static func currentElapsed() -> Int { return 0 }
}

struct MemoryTracker {
    static func currentRSS() -> Int { return 0 }
    static func reportMem(_ label: String) {}
}

struct FileIOTracker {
    static func tracedLoad(path: String, data: Data, loadTime: TimeInterval) {}
}
#endif
