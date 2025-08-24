//
//  ModelStore.swift
//  VybeMVP
//
//  Model capability gating and memory management for local LLM
//  Integrates with AdvancedMemoryManager for automatic unloading
//

import Foundation
import SwiftUI
import os.log

/// Feature flags for LLM functionality
public struct LLMFeatureFlags {
    @AppStorage("local_llm_available") public static var isLocalLLMAvailable: Bool = false
    @AppStorage("local_composer_enabled") public static var isLocalComposerEnabled: Bool = false
    @AppStorage("shadow_mode_enabled") public static var shadowModeEnabled: Bool = false
    @AppStorage("max_context_tokens") public static var maxContextTokens: Int = 2048
    @AppStorage("max_latency_seconds") public static var maxLatencySeconds: Double = 2.0
    @AppStorage("min_quality_threshold") public static var minQualityThreshold: Double = 0.70
}

/// Model capability and loading manager
@MainActor
public final class ModelStore: ObservableObject {

    // MARK: - Published Properties

    @Published private(set) var isModelLoaded = false
    @Published private(set) var currentModelPath: String?
    @Published private(set) var deviceCapability: DeviceCapability = .unknown
    @Published private(set) var memoryPressureLevel: MemoryPressureLevel = .normal

    // MARK: - Private Properties

    private let logger = Logger(subsystem: "com.vybe.models", category: "ModelStore")
    private var pressureObserver: NSObjectProtocol?
    private var thermalObserver: NSObjectProtocol?

    // MARK: - Device Capability

    public enum DeviceCapability {
        case unknown
        case incompatible  // < 3GB RAM
        case basic        // 3-6GB RAM - can run 2B models
        case enhanced     // 6-8GB RAM - can run 3B models
        case premium      // > 8GB RAM - can run 7B models

        var maxModelSize: String {
            switch self {
            case .premium: return "7B"
            case .enhanced: return "3B"
            case .basic: return "2B"
            default: return "none"
            }
        }

        var recommendedEnabled: Bool {
            switch self {
            case .basic, .enhanced, .premium: return true
            default: return false
            }
        }
    }

    public enum MemoryPressureLevel {
        case normal, warning, critical
    }

    // MARK: - Initialization

    public init() {
        Task {
            await determineDeviceCapability()
            await setupMemoryPressureMonitoring()
            await updateLLMAvailability()
        }
    }

    // MARK: - Public API

    /// Check if local LLM is available and enabled
    public var isLocalLLMReady: Bool {
        return LLMFeatureFlags.isLocalLLMAvailable &&
               LLMFeatureFlags.isLocalComposerEnabled &&
               memoryPressureLevel != .critical &&
               deviceCapability != .incompatible
    }

    /// Load model if available and device capable
    public func loadModelIfNeeded() async throws {
        guard isLocalLLMReady else {
            throw ModelStoreError.modelNotAvailable
        }

        guard !isModelLoaded else {
            logger.debug("Model already loaded")
            return
        }

        // Check available memory
        let availableMemory = await getAvailableMemoryMB()
        let requiredMemory = getRequiredMemoryMB()

        guard availableMemory >= requiredMemory else {
            throw ModelStoreError.insufficientMemory(required: requiredMemory, available: availableMemory)
        }

        logger.info("🤖 Loading local model for \(self.deviceCapability.maxModelSize) capability")

        // STUB: In production, this would load actual model
        // For now, simulate loading time
        try await simulateModelLoading()

        isModelLoaded = true
        currentModelPath = "stub_model_\(deviceCapability.maxModelSize).bin"

        logger.info("✅ Model loaded successfully")
    }

    /// Unload model to free memory
    public func unloadModel() async {
        guard isModelLoaded else { return }

        logger.info("🗑️ Unloading model due to memory pressure")

        // STUB: In production, actually unload model from memory
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1s simulation

        isModelLoaded = false
        currentModelPath = nil

        logger.info("✅ Model unloaded")
    }

    /// Force unload for critical memory situations
    public func forceUnloadModel() async {
        await unloadModel()
        logger.warning("🚨 Force unloaded model due to critical memory pressure")
    }

    /// Get model generation capabilities
    public var generationCapabilities: GenerationCapabilities {
        return GenerationCapabilities(
            maxTokens: LLMFeatureFlags.maxContextTokens,
            maxLatency: LLMFeatureFlags.maxLatencySeconds,
            qualityThreshold: LLMFeatureFlags.minQualityThreshold,
            deviceCapability: deviceCapability,
            memoryPressure: memoryPressureLevel
        )
    }

    // MARK: - Private Methods

    private func determineDeviceCapability() async {
        let totalMemoryGB = Double(ProcessInfo.processInfo.physicalMemory) / 1_000_000_000

        deviceCapability = switch totalMemoryGB {
        case 0..<3: DeviceCapability.incompatible
        case 3..<6: DeviceCapability.basic
        case 6..<8: DeviceCapability.enhanced
        default: DeviceCapability.premium
        }

        let capability: DeviceCapability = self.deviceCapability
        let memoryString: String = String(format: "%.1f", totalMemoryGB)
        let capabilityString: String = String(describing: capability)
        logger.info("📱 Device capability: \(capabilityString) (\(memoryString)GB RAM)")
    }

    private func setupMemoryPressureMonitoring() async {
        // Monitor memory pressure notifications from AdvancedMemoryManager
        pressureObserver = NotificationCenter.default.addObserver(
            forName: .memoryPressureWarning,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.handleMemoryPressure(.warning)
            }
        }

        thermalObserver = NotificationCenter.default.addObserver(
            forName: .memoryPressureCritical,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.handleMemoryPressure(.critical)
            }
        }
    }

    private func handleMemoryPressure(_ level: MemoryPressureLevel) {
        memoryPressureLevel = level

        Task {
            switch level {
            case .warning:
                if isModelLoaded {
                    logger.warning("⚠️ Memory pressure warning - unloading model")
                    await unloadModel()
                }
            case .critical:
                logger.error("🚨 Critical memory pressure - force unloading model")
                await forceUnloadModel()
            case .normal:
                break
            }
        }
    }

    private func updateLLMAvailability() async {
        // Update availability based on device capability
        let shouldBeAvailable = deviceCapability.recommendedEnabled

        if LLMFeatureFlags.isLocalLLMAvailable != shouldBeAvailable {
            LLMFeatureFlags.isLocalLLMAvailable = shouldBeAvailable
            logger.info("📝 Updated LLM availability to: \(shouldBeAvailable)")
        }
    }

    private func getAvailableMemoryMB() async -> Int {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4

        let result = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }

        let usedBytes = result == KERN_SUCCESS ? Int64(info.resident_size) : 0
        let totalBytes = Int64(ProcessInfo.processInfo.physicalMemory)
        let availableBytes = max(0, totalBytes - usedBytes)

        return Int(availableBytes / (1024 * 1024))
    }

    private func getRequiredMemoryMB() -> Int {
        return switch deviceCapability {
        case .basic: 1500      // 1.5GB for 2B model
        case .enhanced: 2500   // 2.5GB for 3B model
        case .premium: 6000    // 6GB for 7B model
        default: Int.max       // Incompatible
        }
    }

    private func simulateModelLoading() async throws {
        let loadingTime = switch deviceCapability {
        case .basic: 0.8
        case .enhanced: 1.2
        case .premium: 2.0
        default: 0.1
        }

        try await Task.sleep(nanoseconds: UInt64(loadingTime * 1_000_000_000))
    }

    deinit {
        if let observer = pressureObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = thermalObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

// MARK: - Supporting Types

public struct GenerationCapabilities {
    public let maxTokens: Int
    public let maxLatency: TimeInterval
    public let qualityThreshold: Double
    public let deviceCapability: ModelStore.DeviceCapability
    public let memoryPressure: ModelStore.MemoryPressureLevel

    public var isOptimal: Bool {
        return memoryPressure == .normal &&
               deviceCapability != .incompatible &&
               deviceCapability != .unknown
    }
}

public enum ModelStoreError: LocalizedError {
    case modelNotAvailable
    case insufficientMemory(required: Int, available: Int)
    case loadingFailed(String)
    case deviceNotSupported

    public var errorDescription: String? {
        switch self {
        case .modelNotAvailable:
            return "Local LLM not available or disabled"
        case .insufficientMemory(let required, let available):
            return "Need \(required)MB RAM, have \(available)MB available"
        case .loadingFailed(let reason):
            return "Model loading failed: \(reason)"
        case .deviceNotSupported:
            return "Device does not support local LLM"
        }
    }
}
