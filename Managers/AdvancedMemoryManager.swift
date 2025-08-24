//
//  AdvancedMemoryManager.swift
//  VybeMVP
//
//  Created by Claude on 1/24/25.
//  Purpose: Advanced memory management with pressure handling for Phase 2A performance optimization
//  Based on GPT recommendations for <50MB memory target
//

import Foundation
import SwiftUI
import os.log

/// Advanced memory management system with automatic pressure response
/// Monitors memory usage and automatically purges caches to maintain performance
@MainActor
final class AdvancedMemoryManager: ObservableObject {

    // MARK: - Types

    enum MemoryPressure {
        case normal     // <40MB - optimal performance
        case warning    // 40-50MB - start purging non-essential
        case critical   // >50MB - aggressive purging required
    }

    struct MemoryMetrics {
        let used: Int64         // Bytes
        let peak: Int64         // Peak usage this session
        let available: Int64    // System available
        let pressure: MemoryPressure
        let timestamp: Date
    }

    // MARK: - Singleton

    static let shared = AdvancedMemoryManager()

    // MARK: - Published Properties

    @Published private(set) var currentMetrics: MemoryMetrics?
    @Published private(set) var isMonitoring = false
    @Published private(set) var lastPurgeTime: Date?
    @Published private(set) var purgeCount = 0

    // MARK: - Private Properties

    private var memoryPressureSource: DispatchSourceMemoryPressure?
    private var monitoringTimer: Timer?
    private let logger = Logger(subsystem: "com.vybe.memory", category: "AdvancedMemoryManager")
    private var peakUsage: Int64 = 0

    // Cache references for targeted purging
    private weak var runtimeBundleCache: NSCache<NSString, AnyObject>?
    private weak var imageCache: NSCache<NSString, UIImage>?
    private var purgableManagers: [WeakPurgableReference] = []

    // MARK: - Initialization

    private init() {
        setupMemoryPressureListener()
        setupThermalStateMonitoring()
    }

    // MARK: - Public API

    /// Start active memory monitoring with 5-second intervals
    func startMonitoring() {
        guard !isMonitoring else { return }

        isMonitoring = true

        // Start memory pressure dispatch source
        memoryPressureSource?.resume()

        // Start periodic monitoring
        monitoringTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.updateMetrics()
            }
        }

        logger.info("Memory monitoring started")
    }

    /// Stop active memory monitoring
    func stopMonitoring() {
        isMonitoring = false
        monitoringTimer?.invalidate()
        monitoringTimer = nil
        memoryPressureSource?.suspend()

        logger.info("Memory monitoring stopped")
    }

    /// Register a purgable manager for memory pressure response
    func registerPurgable(_ purgable: Purgable) {
        purgableManagers.append(WeakPurgableReference(purgable))
        purgableManagers.removeAll { $0.purgable == nil } // Clean up dead references
    }

    /// Register cache instances for automatic purging
    func registerCache(_ cache: NSCache<NSString, AnyObject>, type: CacheType) {
        switch type {
        case .runtimeBundle:
            self.runtimeBundleCache = cache
        case .image:
            self.imageCache = cache as? NSCache<NSString, UIImage>
        }
    }

    /// Manually trigger memory pressure handling
    func handleMemoryPressure(_ pressure: MemoryPressure) {
        logger.warning("Handling memory pressure: \(String(describing: pressure))")

        switch pressure {
        case .normal:
            // No action needed
            break

        case .warning:
            purgeNonEssentialCache()

        case .critical:
            purgeAllNonActiveContent()
        }

        lastPurgeTime = Date()
        purgeCount += 1
    }

    // MARK: - Private Methods

    private func setupMemoryPressureListener() {
        // Create dispatch source for system memory pressure events
        memoryPressureSource = DispatchSource.makeMemoryPressureSource(
            eventMask: [.warning, .critical],
            queue: .main
        )

        memoryPressureSource?.setEventHandler { [weak self] in
            guard let self = self else { return }

            let event = self.memoryPressureSource?.data ?? []

            if event.contains(.critical) {
                self.logger.critical("System memory pressure: CRITICAL")
                self.handleMemoryPressure(.critical)
            } else if event.contains(.warning) {
                self.logger.warning("System memory pressure: WARNING")
                self.handleMemoryPressure(.warning)
            }
        }
    }

    private func setupThermalStateMonitoring() {
        // Monitor thermal state changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(thermalStateDidChange),
            name: ProcessInfo.thermalStateDidChangeNotification,
            object: nil
        )
    }

    @objc private func thermalStateDidChange(_ notification: Notification) {
        let thermalState = ProcessInfo.processInfo.thermalState

        switch thermalState {
        case .serious, .critical:
            logger.warning("Thermal state elevated: \(String(describing: thermalState))")
            // Reduce animation complexity and background work
            NotificationCenter.default.post(name: .reduceThermalLoad, object: nil)

        default:
            break
        }
    }

    private func updateMetrics() async {
        let metrics = await calculateCurrentMetrics()

        await MainActor.run {
            self.currentMetrics = metrics

            // Update peak usage
            if metrics.used > self.peakUsage {
                self.peakUsage = metrics.used
            }

            // Auto-handle pressure if needed
            if metrics.pressure != .normal && !ProcessInfo.processInfo.isLowPowerModeEnabled {
                handleMemoryPressure(metrics.pressure)
            }
        }
    }

    private func calculateCurrentMetrics() async -> MemoryMetrics {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4

        let result = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }

        let used = result == KERN_SUCCESS ? Int64(info.resident_size) : 0
        let usedMB = used / (1024 * 1024)

        // Determine pressure level based on targets
        let pressure: MemoryPressure
        if usedMB < 40 {
            pressure = .normal
        } else if usedMB < 50 {
            pressure = .warning
        } else {
            pressure = .critical
        }

        return MemoryMetrics(
            used: used,
            peak: peakUsage,
            available: Int64(ProcessInfo.processInfo.physicalMemory) - used,
            pressure: pressure,
            timestamp: Date()
        )
    }

    private func purgeNonEssentialCache() {
        logger.info("Purging non-essential caches")

        // Purge image cache first (usually largest)
        imageCache?.removeAllObjects()

        // Purge 50% of runtime bundle cache
        if let cache = runtimeBundleCache {
            let currentLimit = cache.countLimit
            cache.countLimit = max(1, currentLimit / 2)
            cache.countLimit = currentLimit // Restore limit
        }

        // Notify purgable managers
        purgableManagers.forEach { ref in
            ref.purgable?.purgeNonEssential()
        }

        // Clean up URL cache
        URLCache.shared.removeAllCachedResponses()
    }

    private func purgeAllNonActiveContent() {
        logger.warning("Purging all non-active content")

        // Clear all caches
        imageCache?.removeAllObjects()
        runtimeBundleCache?.removeAllObjects()

        // Notify all purgable managers for aggressive purging
        purgableManagers.forEach { ref in
            ref.purgable?.purgeAll()
        }

        // Clear URL cache completely
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.diskCapacity = 50 * 1024 * 1024 // Reset to 50MB

        // Force image system purge
        UIImage.perform(Selector(("_flushSharedImageCache")))
    }
}

// MARK: - Supporting Types

enum CacheType {
    case runtimeBundle
    case image
}

protocol Purgable: AnyObject {
    func purgeNonEssential()
    func purgeAll()
}

private struct WeakPurgableReference {
    weak var purgable: Purgable?

    init(_ purgable: Purgable) {
        self.purgable = purgable
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let reduceThermalLoad = Notification.Name("com.vybe.reduceThermalLoad")
    static let memoryPressureChanged = Notification.Name("com.vybe.memoryPressureChanged")
}

// MARK: - Debug Helpers

#if DEBUG
extension AdvancedMemoryManager {
    func simulatePressure(_ pressure: MemoryPressure) {
        handleMemoryPressure(pressure)
    }

    func printMemoryReport() {
        guard let metrics = currentMetrics else { return }

        let usedMB = metrics.used / (1024 * 1024)
        let peakMB = metrics.peak / (1024 * 1024)

        print("""
        📊 Memory Report:
        - Current: \(usedMB)MB
        - Peak: \(peakMB)MB
        - Pressure: \(metrics.pressure)
        - Purge Count: \(purgeCount)
        - Last Purge: \(lastPurgeTime?.formatted() ?? "Never")
        """)
    }
}
#endif
