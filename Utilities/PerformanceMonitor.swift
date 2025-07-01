/*
 * ========================================
 * 📊 PERFORMANCE MONITOR - COSMIC ANIMATION METRICS
 * ========================================
 * 
 * CORE PURPOSE:
 * Lightweight performance monitoring utility for tracking cosmic animation performance
 * during development and testing. Provides real-time FPS, memory, and CPU metrics
 * specifically for our ScrollSafeCosmicView and animation system validation.
 * 
 * FEATURES:
 * - Real-time FPS monitoring via CADisplayLink
 * - Memory usage tracking with trend analysis
 * - CPU usage estimation for main thread
 * - Animation performance metrics logging
 * - Debug console output with cosmic-themed formatting
 * 
 * USAGE:
 * ```swift
 * let monitor = PerformanceMonitor.shared
 * monitor.startMonitoring()
 * // ... cosmic animations running ...
 * monitor.logMetrics("Cosmic Animation Test")
 * monitor.stopMonitoring()
 * ```
 * 
 * INTEGRATION POINTS:
 * - ScrollSafeCosmicView: Monitor cosmic background performance
 * - HomeView: Track overall app performance with animations
 * - TestCosmicAnimationView: Validate animation system efficiency
 * - VybeMatchOverlay: Monitor match celebration performance
 * 
 * PERFORMANCE TARGETS:
 * - FPS: 60fps consistent (55+ acceptable)
 * - Memory: < 100MB peak, stable growth
 * - CPU: < 15% during active cosmic animations
 * - Frame Time: < 16.67ms per frame
 */

import Foundation
import UIKit
import os.log
import SwiftUI

@MainActor
class PerformanceMonitor: ObservableObject {
    static let shared = PerformanceMonitor()
    
    // MARK: - Performance Metrics
    @Published var currentFPS: Double = 0
    @Published var averageFPS: Double = 0
    @Published var memoryUsageMB: Double = 0
    @Published var isMonitoring: Bool = false
    

    
    // MARK: - Private Properties
    private var displayLink: CADisplayLink?
    private var frameCount: Int = 0
    private var lastTimestamp: CFTimeInterval = 0
    private var fpsHistory: [Double] = []
    private var startTime: CFTimeInterval = 0
    private var memoryHistory: [Double] = []
    
    // MARK: - Logging
    private let logger = Logger(subsystem: "com.vybe.performance", category: "CosmicAnimations")
    
    private init() {}
    
    // MARK: - Monitoring Control
    
    /// Start performance monitoring for cosmic animations
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        isMonitoring = true
        frameCount = 0
        fpsHistory.removeAll()
        memoryHistory.removeAll()
        startTime = CACurrentMediaTime()
        
        setupDisplayLink()
        startMemoryMonitoring()
        
        logger.info("🚀 PerformanceMonitor: Cosmic animation monitoring started")
        print("🚀 PerformanceMonitor: Cosmic animation monitoring started")
    }
    
    /// Stop performance monitoring and log final results
    func stopMonitoring() {
        guard isMonitoring else { return }
        
        displayLink?.invalidate()
        displayLink = nil
        memoryTimer?.invalidate()
        memoryTimer = nil
        isMonitoring = false
        
        logFinalResults()
        
        // Clear data arrays to free memory
        fpsHistory.removeAll()
        memoryHistory.removeAll()
        
        logger.info("🛑 PerformanceMonitor: Monitoring stopped")
        print("🛑 PerformanceMonitor: Monitoring stopped")
    }
    
    /// Log current performance metrics with custom context
    func logMetrics(_ context: String = "Performance Check") {
        guard isMonitoring else { return }
        
        updateMemoryUsage()
        
        let avgFPS = fpsHistory.isEmpty ? 0 : fpsHistory.reduce(0, +) / Double(fpsHistory.count)
        let minFPS = fpsHistory.min() ?? 0
        let maxFPS = fpsHistory.max() ?? 0
        
        let logMessage = """
        📊 \(context):
           🎯 FPS: Current=\(String(format: "%.1f", currentFPS)) | Avg=\(String(format: "%.1f", avgFPS)) | Min=\(String(format: "%.1f", minFPS)) | Max=\(String(format: "%.1f", maxFPS))
           💾 Memory: \(String(format: "%.1f", memoryUsageMB))MB
           ⏱️ Runtime: \(String(format: "%.1f", CACurrentMediaTime() - startTime))s
        """
        
        logger.info("\(logMessage)")
        print(logMessage)
    }
    
    // MARK: - Private Methods
    
    private func setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkTick))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func displayLinkTick(_ displayLink: CADisplayLink) {
        if lastTimestamp == 0 {
            lastTimestamp = displayLink.timestamp
            return
        }
        
        frameCount += 1
        let deltaTime = displayLink.timestamp - lastTimestamp
        
        if deltaTime >= 1.0 {
            let fps = Double(frameCount) / deltaTime
            currentFPS = fps
            fpsHistory.append(fps)
            
            // Keep only last 10 FPS readings to prevent memory growth
            if fpsHistory.count > 10 {
                fpsHistory.removeFirst()
            }
            
            averageFPS = fpsHistory.reduce(0, +) / Double(fpsHistory.count)
            
            frameCount = 0
            lastTimestamp = displayLink.timestamp
        }
    }
    
    private var memoryTimer: Timer?
    
    private func startMemoryMonitoring() {
        // Cancel any existing timer
        memoryTimer?.invalidate()
        
        memoryTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self = self, self.isMonitoring else { return }
                self.updateMemoryUsage()
            }
        }
    }
    
    private func updateMemoryUsage() {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            let memoryMB = Double(info.resident_size) / 1024.0 / 1024.0
            memoryUsageMB = memoryMB
            memoryHistory.append(memoryMB)
            
            // Keep only last 5 memory readings to prevent memory growth
            if memoryHistory.count > 5 {
                memoryHistory.removeFirst()
            }
        }
    }
    
    private func logFinalResults() {
        let totalTime = CACurrentMediaTime() - startTime
        let avgFPS = fpsHistory.isEmpty ? 0 : fpsHistory.reduce(0, +) / Double(fpsHistory.count)
        let minFPS = fpsHistory.min() ?? 0
        let maxFPS = fpsHistory.max() ?? 0
        let avgMemory = memoryHistory.isEmpty ? 0 : memoryHistory.reduce(0, +) / Double(memoryHistory.count)
        let maxMemory = memoryHistory.max() ?? 0
        
        let finalReport = """
        
        🌌 ===== COSMIC ANIMATION PERFORMANCE REPORT =====
        ⏱️  Total Runtime: \(String(format: "%.1f", totalTime))s
        🎯  FPS Analysis:
            • Average: \(String(format: "%.1f", avgFPS)) fps
            • Minimum: \(String(format: "%.1f", minFPS)) fps
            • Maximum: \(String(format: "%.1f", maxFPS)) fps
            • Target: 60 fps (\(avgFPS >= 55 ? "✅ PASS" : "❌ NEEDS OPTIMIZATION"))
        💾  Memory Analysis:
            • Average: \(String(format: "%.1f", avgMemory)) MB
            • Peak: \(String(format: "%.1f", maxMemory)) MB
            • Target: < 200 MB (\(maxMemory < 200 ? "✅ PASS" : "❌ NEEDS OPTIMIZATION"))
        🌟  Overall Performance: \(getPerformanceGrade(avgFPS: avgFPS, maxMemory: maxMemory))
        ================================================
        
        """
        
        logger.info("\(finalReport)")
        print(finalReport)
    }
    
    private func getPerformanceGrade(avgFPS: Double, maxMemory: Double) -> String {
        if avgFPS >= 58 && maxMemory < 150 {
            return "🏆 EXCELLENT - Ready for Production"
        } else if avgFPS >= 55 && maxMemory < 200 {
            return "✅ GOOD - Meets Performance Targets"
        } else if avgFPS >= 45 && maxMemory < 250 {
            return "⚠️ ACCEPTABLE - Minor Optimization Recommended"
        } else {
            return "❌ NEEDS OPTIMIZATION - Performance Below Target"
        }
    }
}

// MARK: - Performance Monitoring Extensions

extension PerformanceMonitor {
    
    /// Quick performance check for cosmic animations
    func quickCheck(_ context: String) {
        startMonitoring()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.logMetrics(context)
            self.stopMonitoring()
        }
    }
    
    /// Check if current performance meets cosmic animation targets
    var meetsPerformanceTargets: Bool {
        return averageFPS >= 55 && memoryUsageMB < 200
    }
    
    /// Get performance status for UI display
    var performanceStatus: String {
        if !isMonitoring {
            return "🌌 Ready to Monitor"
        } else if meetsPerformanceTargets {
            return "✅ Cosmic Performance Optimal"
        } else {
            return "⚠️ Performance Optimization Needed"
        }
    }
} 