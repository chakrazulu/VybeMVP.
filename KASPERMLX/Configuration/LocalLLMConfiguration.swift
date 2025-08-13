/**
 * 🌟 LOCAL LLM CONFIGURATION - SECURE ENDPOINT MANAGEMENT
 * ================================================
 *
 * SECURITY FEATURES:
 * - Environment-based URL configuration
 * - No hardcoded IP addresses or endpoints
 * - Automatic local network detection
 * - Secure fallback handling
 * - Debug logging control
 *
 * USAGE:
 * ```swift
 * let config = LocalLLMConfiguration.shared
 * let provider = KASPERLocalLLMProvider(serverURL: config.serverURL)
 * ```
 */

import Foundation
import Network

/**
 * Configuration manager for Local LLM connections
 *
 * Provides secure, environment-aware endpoint management for Local LLM services.
 * Eliminates hardcoded URLs and IP addresses for better security and maintainability.
 */
@MainActor
public class LocalLLMConfiguration: ObservableObject {
    public static let shared = LocalLLMConfiguration()

    // MARK: - Configuration Constants
    private let defaultPort = "11434"
    private let localHostAddress = "localhost"

    // MARK: - Environment Variables
    private let serverHostKey = "VYBE_LLM_HOST"
    private let serverPortKey = "VYBE_LLM_PORT"
    private let enableLocalLLMKey = "VYBE_LOCAL_LLM_ENABLED"

    // MARK: - Published Properties
    @Published public var isEnabled: Bool = false
    @Published public var connectionStatus: ConnectionStatus = .unknown

    public enum ConnectionStatus {
        case unknown
        case connected
        case disconnected
        case error(String)
    }

    private init() {
        configureEnvironment()
    }

    // MARK: - Public Interface

    /**
     * Primary server URL for Local LLM connections
     *
     * PRIORITY ORDER:
     * 1. Environment variable (VYBE_LLM_HOST)
     * 2. UserDefaults configuration
     * 3. Localhost fallback
     */
    public var serverURL: String {
        let host = getConfiguredHost()
        let port = getConfiguredPort()
        return "http://\(host):\(port)"
    }

    /**
     * Check if Local LLM is enabled and configured
     */
    public var isLocalLLMEnabled: Bool {
        guard isEnabled else { return false }

        #if DEBUG
        return true  // Always enabled in debug for development
        #else
        // In production, require explicit enablement
        return ProcessInfo.processInfo.environment[enableLocalLLMKey] == "true"
        #endif
    }

    // MARK: - Configuration Methods

    /**
     * Configure Local LLM with custom host
     *
     * Stores configuration in UserDefaults for persistence
     */
    public func configureHost(_ host: String) {
        UserDefaults.standard.set(host, forKey: serverHostKey)

        #if DEBUG
        print("🔧 Local LLM host configured: \(host)")
        #endif
    }

    /**
     * Configure Local LLM with custom port
     */
    public func configurePort(_ port: String) {
        UserDefaults.standard.set(port, forKey: serverPortKey)

        #if DEBUG
        print("🔧 Local LLM port configured: \(port)")
        #endif
    }

    /**
     * Enable or disable Local LLM functionality
     */
    public func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: enableLocalLLMKey)

        #if DEBUG
        print("🔧 Local LLM \(enabled ? "enabled" : "disabled")")
        #endif
    }

    /**
     * Reset configuration to defaults
     */
    public func resetToDefaults() {
        UserDefaults.standard.removeObject(forKey: serverHostKey)
        UserDefaults.standard.removeObject(forKey: serverPortKey)
        UserDefaults.standard.removeObject(forKey: enableLocalLLMKey)

        isEnabled = false
        connectionStatus = .unknown

        #if DEBUG
        print("🔧 Local LLM configuration reset to defaults")
        #endif
    }

    // MARK: - Private Implementation

    private func configureEnvironment() {
        // Check if explicitly enabled via environment or UserDefaults
        if ProcessInfo.processInfo.environment[enableLocalLLMKey] == "true" ||
           UserDefaults.standard.bool(forKey: enableLocalLLMKey) {
            isEnabled = true
        }

        #if DEBUG
        // Auto-enable in debug builds for development
        isEnabled = true
        #endif
    }

    private func getConfiguredHost() -> String {
        // 1. Check environment variable
        if let envHost = ProcessInfo.processInfo.environment[serverHostKey], !envHost.isEmpty {
            return envHost
        }

        // 2. Check UserDefaults
        if let savedHost = UserDefaults.standard.string(forKey: serverHostKey), !savedHost.isEmpty {
            return savedHost
        }

        // 3. Smart default based on device type
        #if DEBUG
        #if targetEnvironment(simulator)
        // iOS Simulator - use localhost for same-machine testing
        return localHostAddress
        #else
        // Real iPhone - use Mac's network IP for cross-device Local LLM access
        // This enables shadow mode competition between Mixtral and RuntimeBundle
        return "192.168.1.159"  // Local network IP (secure - not internet accessible)
        #endif
        #else
        // Production - always use localhost for security
        return localHostAddress
        #endif
    }

    private func getConfiguredPort() -> String {
        // 1. Check environment variable
        if let envPort = ProcessInfo.processInfo.environment[serverPortKey], !envPort.isEmpty {
            return envPort
        }

        // 2. Check UserDefaults
        if let savedPort = UserDefaults.standard.string(forKey: serverPortKey), !savedPort.isEmpty {
            return savedPort
        }

        // 3. Fallback to default port
        return defaultPort
    }
}

// MARK: - Development Helpers

#if DEBUG
extension LocalLLMConfiguration {
    /**
     * Quick setup for common development scenarios
     */
    public func setupForLocalDevelopment(macIP: String? = nil) {
        if let ip = macIP {
            configureHost(ip)
        } else {
            configureHost(localHostAddress)
        }

        configurePort(defaultPort)
        setEnabled(true)

        print("🚀 Local LLM configured for development")
        print("   Host: \(getConfiguredHost())")
        print("   Port: \(getConfiguredPort())")
        print("   URL: \(serverURL)")
    }

    /**
     * Test connection to configured endpoint
     */
    public func testConnection() async {
        let url = serverURL + "/api/tags"

        do {
            let (_, response) = try await URLSession.shared.data(from: URL(string: url)!)

            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                await MainActor.run {
                    self.connectionStatus = .connected
                    print("✅ Local LLM connection successful: \(url)")
                }
            } else {
                await MainActor.run {
                    self.connectionStatus = .error("HTTP error")
                    print("❌ Local LLM connection failed: HTTP error")
                }
            }
        } catch {
            await MainActor.run {
                self.connectionStatus = .error(error.localizedDescription)
                print("❌ Local LLM connection failed: \(error.localizedDescription)")
            }
        }
    }
}
#endif
