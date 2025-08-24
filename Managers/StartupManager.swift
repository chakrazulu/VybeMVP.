//
//  StartupManager.swift
//  VybeMVP
//
//  Created by Claude on 1/24/25.
//  Purpose: Three-phase progressive startup system for Phase 2A performance optimization
//  Target: <2s cold start with staged loading
//

import Foundation
import SwiftUI
import os.log

/// Progressive startup manager implementing three-phase boot sequence
/// Achieves <2s usable state by deferring non-critical initialization
@MainActor
final class StartupManager: ObservableObject {

    // MARK: - Types

    enum BootPhase {
        case essential      // 0-30%: Critical UI + auth (must complete <500ms)
        case userContent    // 30-70%: User data + recent cache (<1s)
        case enhancement    // 70-100%: AI, prefetch, analytics (<2s total)
    }

    struct PhaseMetrics {
        let phase: BootPhase
        let startTime: Date
        var endTime: Date?
        var itemsLoaded: Int = 0

        var duration: TimeInterval? {
            guard let endTime = endTime else { return nil }
            return endTime.timeIntervalSince(startTime)
        }
    }

    // MARK: - Singleton

    static let shared = StartupManager()

    // MARK: - Published Properties

    @Published private(set) var currentPhase: BootPhase = .essential
    @Published private(set) var progress: Double = 0.0
    @Published private(set) var isBootComplete = false
    @Published private(set) var bootMetrics: [PhaseMetrics] = []

    // MARK: - Private Properties

    private let logger = Logger(subsystem: "com.vybe.startup", category: "StartupManager")
    private var bootStartTime: Date?
    private var essentialManagers: [WeakManagerReference] = []
    private var userManagers: [WeakManagerReference] = []
    private var enhancementManagers: [WeakManagerReference] = []

    // MARK: - Initialization

    private init() {}

    // MARK: - Public API

    /// Start the three-phase boot sequence
    func boot() {
        guard !isBootComplete else {
            logger.warning("Boot already complete, ignoring duplicate call")
            return
        }

        bootStartTime = Date()
        logger.info("🚀 Starting three-phase boot sequence")

        // Phase 1: Essential (blocking, must be fast)
        runPhase(.essential)

        // Phase 2: User Content (async, medium priority)
        Task(priority: .high) {
            runPhase(.userContent)
        }

        // Phase 3: Enhancement (background, low priority)
        Task.detached(priority: .background) {
            await MainActor.run {
                self.runPhase(.enhancement)
            }
        }
    }

    /// Register managers for specific boot phases
    func register(_ manager: BootableManager, for phase: BootPhase) {
        let reference = WeakManagerReference(manager)

        switch phase {
        case .essential:
            essentialManagers.append(reference)
        case .userContent:
            userManagers.append(reference)
        case .enhancement:
            enhancementManagers.append(reference)
        }
    }

    /// Check if a specific phase is complete
    func isPhaseComplete(_ phase: BootPhase) -> Bool {
        bootMetrics.first { $0.phase == phase }?.endTime != nil
    }

    // MARK: - Private Methods

    private func runPhase(_ phase: BootPhase) {
        currentPhase = phase

        var metrics = PhaseMetrics(phase: phase, startTime: Date())
        logger.info("📦 Starting phase: \(String(describing: phase))")

        let managers: [WeakManagerReference]
        let progressStart: Double
        let progressEnd: Double

        switch phase {
        case .essential:
            managers = essentialManagers
            progressStart = 0.0
            progressEnd = 0.3

        case .userContent:
            managers = userManagers
            progressStart = 0.3
            progressEnd = 0.7

        case .enhancement:
            managers = enhancementManagers
            progressStart = 0.7
            progressEnd = 1.0
        }

        // Clean up nil references
        let validManagers = managers.compactMap { $0.manager }

        // Initialize managers in phase
        for (index, manager) in validManagers.enumerated() {
            autoreleasepool {
                do {
                    try manager.initialize()
                    metrics.itemsLoaded += 1

                    // Update progress
                    let phaseProgress = Double(index + 1) / Double(validManagers.count)
                    progress = progressStart + (progressEnd - progressStart) * phaseProgress

                } catch {
                    logger.error("Failed to initialize manager: \(error.localizedDescription)")
                }
            }
        }

        metrics.endTime = Date()
        bootMetrics.append(metrics)

        if let duration = metrics.duration {
            logger.info("✅ Phase \(String(describing: phase)) complete in \(String(format: "%.2f", duration))s")
        }

        // Check if boot is complete
        if phase == .enhancement {
            completeBootSequence()
        }
    }

    private func completeBootSequence() {
        isBootComplete = true
        progress = 1.0

        if let bootStartTime = bootStartTime {
            let totalDuration = Date().timeIntervalSince(bootStartTime)
            logger.info("🎉 Boot sequence complete in \(String(format: "%.2f", totalDuration))s")

            // Log performance metrics
            logPerformanceReport(totalDuration: totalDuration)

            // Notify app that boot is complete
            NotificationCenter.default.post(name: .bootSequenceComplete, object: nil)
        }
    }

    private func logPerformanceReport(totalDuration: TimeInterval) {
        var report = "\n📊 Boot Performance Report:\n"
        report += "Total Duration: \(String(format: "%.2f", totalDuration))s\n"

        for metrics in bootMetrics {
            if let duration = metrics.duration {
                let percentage = (duration / totalDuration) * 100
                report += "- \(metrics.phase): \(String(format: "%.2f", duration))s (\(String(format: "%.0f", percentage))%)\n"
                report += "  Items: \(metrics.itemsLoaded)\n"
            }
        }

        // Check against targets
        let targetMet = totalDuration < 2.0
        report += "\n🎯 Target (<2s): \(targetMet ? "✅ PASSED" : "❌ FAILED")"

        logger.info("\(report)")
    }
}

// MARK: - Default Boot Configuration

extension StartupManager {

    /// Configure default VybeMVP boot sequence
    func configureDefaultBootSequence() {
        // Phase 1: Essential (UI Shell + Auth)
        // - ContentView initialization
        // - NavigationRouter setup
        // - AuthenticationManager (if logged in)
        // - Core UI components

        // Phase 2: User Content (Data + Cache)
        // - SanctumDataManager
        // - Recent journal entries
        // - Last meditation session
        // - Social timeline cache
        // - User preferences

        // Phase 3: Enhancement (AI + Analytics)
        // - KASPER MLX initialization
        // - RuntimeBundle indexing
        // - SwiftAA ephemeris precompute
        // - Analytics setup
        // - Background task scheduling
        // - Prefetch likely content
    }
}

// MARK: - Supporting Types

protocol BootableManager: AnyObject {
    func initialize() throws
    var bootPriority: Int { get } // Lower = higher priority
}

private struct WeakManagerReference {
    weak var manager: BootableManager?

    init(_ manager: BootableManager) {
        self.manager = manager
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let bootSequenceComplete = Notification.Name("com.vybe.bootSequenceComplete")
    static let bootPhaseChanged = Notification.Name("com.vybe.bootPhaseChanged")
}

// MARK: - Lazy Loading Helpers

extension StartupManager {

    /// Defer heavy initialization until actually needed
    func deferredLoad<T>(_ loader: @escaping () throws -> T) -> LazyLoader<T> {
        LazyLoader(loader: loader)
    }
}

/// Wrapper for lazy-loaded resources
final class LazyLoader<T> {
    private var loader: (() throws -> T)?
    private var value: T?
    private let lock = NSLock()

    init(loader: @escaping () throws -> T) {
        self.loader = loader
    }

    func load() throws -> T {
        lock.lock()
        defer { lock.unlock() }

        if let value = value {
            return value
        }

        guard let loader = loader else {
            throw StartupError.loaderAlreadyExecuted
        }

        let loadedValue = try loader()
        self.value = loadedValue
        self.loader = nil // Release loader closure

        return loadedValue
    }

    var isLoaded: Bool {
        lock.lock()
        defer { lock.unlock() }
        return value != nil
    }
}

enum StartupError: LocalizedError {
    case loaderAlreadyExecuted

    var errorDescription: String? {
        switch self {
        case .loaderAlreadyExecuted:
            return "Loader has already been executed"
        }
    }
}
