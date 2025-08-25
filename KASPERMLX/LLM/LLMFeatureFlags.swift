//
//  LLMFeatureFlags.swift
//  VybeMVP
//
//  Created by Claude on 1/24/25.
//  Purpose: Feature flag system for Phase 2C LLM rollout control
//
//  ROLLOUT STRATEGY:
//  1. Shadow mode: Generate but don't surface (log quality only)
//  2. Dev mode: Surface to internal team
//  3. TestFlight: Gradual rollout to beta users
//  4. Production: Full rollout with fallback ladder
//

import Foundation
import Combine

/// Centralized feature flag management for LLM capabilities
/// Controls rollout, A/B testing, and graceful degradation
@MainActor
public final class LLMFeatureFlags: ObservableObject {

    // MARK: - Types

    /// LLM runtime backend options
    public enum LLMRuntime: String, CaseIterable {
        case llamaCpp = "llamacpp"    // Primary: Metal-optimized llama.cpp
        case mlc = "mlc"              // Alternative: MLC-LLM
        case disabled = "disabled"    // Fully disabled

        var displayName: String {
            switch self {
            case .llamaCpp: return "Llama.cpp (Metal)"
            case .mlc: return "MLC-LLM"
            case .disabled: return "Disabled"
            }
        }
    }

    /// Rollout stage for gradual enablement
    public enum RolloutStage: String, CaseIterable {
        case disabled = "disabled"          // Completely off
        case shadow = "shadow"              // Generate but don't show
        case development = "development"    // Internal team only
        case testflight = "testflight"      // Beta users
        case production = "production"      // All users

        var isEnabled: Bool {
            self != .disabled
        }

        var shouldSurface: Bool {
            switch self {
            case .disabled, .shadow: return false
            case .development, .testflight, .production: return true
            }
        }
    }

    /// Device tier for capability-based enablement
    public enum DeviceTier: String {
        case pro = "pro"              // iPhone 13 Pro+
        case standard = "standard"    // iPhone 12+
        case legacy = "legacy"        // Below iPhone 12

        static func current() -> DeviceTier {
            // TODO: Implement actual device detection
            // For now, check for Pro in device name
            let deviceName = UIDevice.current.name
            if deviceName.contains("Pro") {
                return .pro
            } else if deviceName.contains("iPhone 1[2-9]") || deviceName.contains("iPhone [2-9][0-9]") {
                return .standard
            } else {
                return .legacy
            }
        }
    }

    // MARK: - Singleton

    public static let shared = LLMFeatureFlags()

    // MARK: - Published Flags

    /// Master switch for LLM features
    @Published public var isLLMEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isLLMEnabled, forKey: "llm.local.enabled")
            logFlagChange("llm.local.enabled", value: isLLMEnabled)
        }
    }

    /// Current rollout stage
    @Published public var rolloutStage: RolloutStage {
        didSet {
            UserDefaults.standard.set(rolloutStage.rawValue, forKey: "llm.rollout.stage")
            logFlagChange("llm.rollout.stage", value: rolloutStage.rawValue)
        }
    }

    /// Selected runtime backend
    @Published public var runtime: LLMRuntime {
        didSet {
            UserDefaults.standard.set(runtime.rawValue, forKey: "llm.runtime")
            logFlagChange("llm.runtime", value: runtime.rawValue)
        }
    }

    /// Maximum tokens for generation
    @Published public var maxTokens: Int {
        didSet {
            UserDefaults.standard.set(maxTokens, forKey: "llm.maxTokens")
            logFlagChange("llm.maxTokens", value: maxTokens)
        }
    }

    /// Temperature for creativity control
    @Published public var temperature: Float {
        didSet {
            UserDefaults.standard.set(temperature, forKey: "llm.temperature")
            logFlagChange("llm.temperature", value: temperature)
        }
    }

    /// Quality gate threshold (0.0-1.0)
    @Published public var qualityThreshold: Float {
        didSet {
            UserDefaults.standard.set(qualityThreshold, forKey: "llm.qualityThreshold")
            logFlagChange("llm.qualityThreshold", value: qualityThreshold)
        }
    }

    /// Preload model on app start (Pro devices only)
    @Published public var shouldPreloadModel: Bool {
        didSet {
            UserDefaults.standard.set(shouldPreloadModel, forKey: "llm.preload")
            logFlagChange("llm.preload", value: shouldPreloadModel)
        }
    }

    /// Enable telemetry collection
    @Published public var collectTelemetry: Bool {
        didSet {
            UserDefaults.standard.set(collectTelemetry, forKey: "llm.telemetry")
            logFlagChange("llm.telemetry", value: collectTelemetry)
        }
    }

    // MARK: - Computed Properties

    /// Whether to actually run LLM inference
    public var shouldRunInference: Bool {
        isLLMEnabled && rolloutStage.isEnabled && runtime != .disabled
    }

    /// Whether to show LLM results to user
    public var shouldSurfaceResults: Bool {
        shouldRunInference && rolloutStage.shouldSurface
    }

    /// Whether in shadow mode (generate but don't show)
    public var isInShadowMode: Bool {
        shouldRunInference && rolloutStage == .shadow
    }

    /// Check if device is capable
    public var isDeviceCapable: Bool {
        let tier = DeviceTier.current()
        return tier != .legacy
    }

    /// Check if should preload based on all conditions
    public var shouldAutoPreload: Bool {
        guard shouldPreloadModel && isDeviceCapable else { return false }

        let tier = DeviceTier.current()
        let isCharging = ProcessInfo.processInfo.isLowPowerModeEnabled == false

        return tier == .pro || isCharging
    }

    // MARK: - Initialization

    private init() {
        // Load from UserDefaults with safe defaults
        self.isLLMEnabled = UserDefaults.standard.bool(forKey: "llm.local.enabled")

        let stageRaw = UserDefaults.standard.string(forKey: "llm.rollout.stage") ?? "disabled"
        self.rolloutStage = RolloutStage(rawValue: stageRaw) ?? .disabled

        let runtimeRaw = UserDefaults.standard.string(forKey: "llm.runtime") ?? "llamacpp"
        self.runtime = LLMRuntime(rawValue: runtimeRaw) ?? .llamaCpp

        self.maxTokens = UserDefaults.standard.integer(forKey: "llm.maxTokens")
        if self.maxTokens == 0 { self.maxTokens = 50 } // Default

        self.temperature = UserDefaults.standard.float(forKey: "llm.temperature")
        if self.temperature == 0 { self.temperature = 0.7 } // Default

        self.qualityThreshold = UserDefaults.standard.float(forKey: "llm.qualityThreshold")
        if self.qualityThreshold == 0 { self.qualityThreshold = 0.70 } // Default

        self.shouldPreloadModel = UserDefaults.standard.bool(forKey: "llm.preload")
        self.collectTelemetry = UserDefaults.standard.bool(forKey: "llm.telemetry")

        print("🎛 LLM Feature Flags initialized:")
        print("  - Enabled: \(isLLMEnabled)")
        print("  - Stage: \(rolloutStage.rawValue)")
        print("  - Runtime: \(runtime.rawValue)")
        print("  - Device Capable: \(isDeviceCapable)")
    }

    // MARK: - Public Methods

    /// Enable shadow mode for testing
    public func enableShadowMode() {
        isLLMEnabled = true
        rolloutStage = .shadow
        collectTelemetry = true
        print("🔬 Shadow mode enabled - generating but not surfacing")
    }

    /// Enable for development team
    public func enableForDevelopment() {
        isLLMEnabled = true
        rolloutStage = .development
        collectTelemetry = true
        print("🛠 Development mode enabled - surfacing to internal team")
    }

    /// Reset all flags to defaults
    public func resetToDefaults() {
        isLLMEnabled = false
        rolloutStage = .disabled
        runtime = .llamaCpp
        maxTokens = 50
        temperature = 0.7
        qualityThreshold = 0.70
        shouldPreloadModel = false
        collectTelemetry = false
        print("🔄 Feature flags reset to defaults")
    }

    /// Check if user is in experiment cohort
    public func isInExperiment(name: String) -> Bool {
        // Simple hash-based bucketing for A/B tests
        let userId = UserDefaults.standard.string(forKey: "user_id") ?? UUID().uuidString
        let hash = (userId + name).hashValue
        let bucket = abs(hash) % 100

        // Put 10% of users in each experiment
        return bucket < 10
    }

    /// Get configuration for LlamaRunner
    public func getLLMConfig() -> LlamaRunner.InferenceConfig {
        LlamaRunner.InferenceConfig(
            maxTokens: maxTokens,
            temperature: temperature,
            topP: 0.9,
            repeatPenalty: 1.1,
            stopSequences: PromptTemplate.stopSequences,
            timeoutSeconds: 2.0
        )
    }

    // MARK: - Private Helpers

    private func logFlagChange(_ flag: String, value: Any) {
        if collectTelemetry {
            print("🎛 Flag changed: \(flag) = \(value)")
            // TODO: Send to analytics
        }
    }
}

// MARK: - Debug Menu Support

#if DEBUG
extension LLMFeatureFlags {

    /// Debug menu options for testing
    public var debugMenuOptions: [(String, () -> Void)] {
        [
            ("Enable Shadow Mode", { self.enableShadowMode() }),
            ("Enable Development", { self.enableForDevelopment() }),
            ("Enable Production", {
                self.isLLMEnabled = true
                self.rolloutStage = .production
            }),
            ("Switch to MLC", { self.runtime = .mlc }),
            ("Switch to Llama.cpp", { self.runtime = .llamaCpp }),
            ("Increase Temperature", {
                self.temperature = min(1.0, self.temperature + 0.1)
            }),
            ("Decrease Temperature", {
                self.temperature = max(0.1, self.temperature - 0.1)
            }),
            ("Toggle Preload", { self.shouldPreloadModel.toggle() }),
            ("Reset to Defaults", { self.resetToDefaults() })
        ]
    }

    /// Current status for debug display
    public var debugStatus: String {
        """
        🎛 LLM Feature Status:
        Enabled: \(isLLMEnabled)
        Stage: \(rolloutStage.rawValue)
        Runtime: \(runtime.rawValue)
        Should Run: \(shouldRunInference)
        Should Surface: \(shouldSurfaceResults)
        Shadow Mode: \(isInShadowMode)
        Device Tier: \(DeviceTier.current().rawValue)
        Max Tokens: \(maxTokens)
        Temperature: \(String(format: "%.1f", temperature))
        Quality Gate: \(String(format: "%.0f%%", qualityThreshold * 100))
        """
    }
}
#endif

// MARK: - SwiftUI Preview Support

#if DEBUG
import SwiftUI

struct LLMFeatureFlagsDebugView: View {
    @ObservedObject var flags = LLMFeatureFlags.shared

    var body: some View {
        Form {
            Section("Master Controls") {
                Toggle("LLM Enabled", isOn: $flags.isLLMEnabled)

                Picker("Rollout Stage", selection: $flags.rolloutStage) {
                    ForEach(LLMFeatureFlags.RolloutStage.allCases, id: \.self) { stage in
                        Text(stage.rawValue).tag(stage)
                    }
                }

                Picker("Runtime", selection: $flags.runtime) {
                    ForEach(LLMFeatureFlags.LLMRuntime.allCases, id: \.self) { runtime in
                        Text(runtime.displayName).tag(runtime)
                    }
                }
            }

            Section("Parameters") {
                HStack {
                    Text("Max Tokens: \(flags.maxTokens)")
                    Slider(value: .init(
                        get: { Double(flags.maxTokens) },
                        set: { flags.maxTokens = Int($0) }
                    ), in: 10...200, step: 10)
                }

                HStack {
                    Text("Temperature: \(String(format: "%.1f", flags.temperature))")
                    Slider(value: $flags.temperature, in: 0.1...1.0, step: 0.1)
                }

                HStack {
                    Text("Quality: \(String(format: "%.0f%%", flags.qualityThreshold * 100))")
                    Slider(value: $flags.qualityThreshold, in: 0.5...1.0, step: 0.05)
                }
            }

            Section("Status") {
                Text(flags.debugStatus)
                    .font(.system(.caption, design: .monospaced))
            }
        }
        .navigationTitle("LLM Feature Flags")
    }
}
#endif
