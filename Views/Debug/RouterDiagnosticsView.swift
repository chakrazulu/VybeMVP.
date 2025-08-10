//
//  RouterDiagnosticsView.swift
//  VybeMVP
//
//  Created by Claude on VybeOS Branch
//  VybeOS World Domination - System Intelligence Dashboard
//

import SwiftUI

/**
 * 🌌 VYBES ROUTER DIAGNOSTICS - SYSTEM INTELLIGENCE DASHBOARD
 *
 * **Purpose:** Real-time monitoring and diagnostics for KASPER MLX RuntimeBundle system
 * **Integration:** VybeOS Control Panel for spiritual content system health
 * **Architecture:** Direct observation of KASPERContentRouter.shared state
 *
 * **DIAGNOSTIC CAPABILITIES:**
 * - RuntimeBundle manifest loading status and version
 * - Content file counts (behavioral vs rich content)
 * - Fallback counter for monitoring content routing health
 * - Missing number detection for content coverage gaps
 * - System performance metrics and health indicators
 *
 * **VYBES SYSTEM INTELLIGENCE:**
 * This isn't just debugging - it's the foundation of VybeOS system awareness.
 * Real-time visibility into the spiritual content delivery engine that powers
 * the entire cosmic experience. Essential for world domination! 🌍⚡️
 *
 * **UI SPECIFICATIONS:**
 * - Clean diagnostic sections with spiritual color theming
 * - Real-time refresh capability for live system monitoring
 * - Color-coded health indicators (green=healthy, red=issues)
 * - Expandable sections for detailed technical analysis
 *
 * **INTEGRATION POINTS:**
 * - KASPERContentRouter.shared for all diagnostic data
 * - Settings -> Developer Tools -> Router Diagnostics
 * - Future: VybeOS Control Panel main dashboard component
 */
struct RouterDiagnosticsView: View {
    /// Claude: Direct observation of the KASPER content router singleton
    /// This provides real-time access to all system diagnostic information
    /// without requiring additional state management or data copying
    @ObservedObject private var router = KASPERContentRouter.shared

    /// Claude: Local state for diagnostic data snapshot
    /// Updated via router.getDiagnostics() to provide consistent view data
    /// during UI rendering and user interaction sessions
    @State private var diagnostics: [String: Any] = [:]

    /// Claude: Controls visibility of detailed technical information
    /// Enables progressive disclosure for both casual monitoring and
    /// deep technical analysis of the spiritual content system
    @State private var showDetailedInfo = false

    var body: some View {
        List {
            // MARK: - 🌟 VYBES SYSTEM STATUS OVERVIEW

            Section("🌌 VybeOS System Status") {
                systemStatusRows
            }

            // MARK: - 📊 RUNTIME BUNDLE HEALTH METRICS

            Section("📊 RuntimeBundle Health") {
                runtimeBundleRows
            }

            // MARK: - 🔄 CONTENT ROUTING ANALYTICS

            Section("🔄 Content Routing Analytics") {
                contentRoutingRows
            }

            // MARK: - ⚠️ SYSTEM ALERTS & MONITORING

            if hasSystemAlerts {
                Section("⚠️ System Alerts") {
                    systemAlertRows
                }
            }

            // MARK: - 🛠️ ADVANCED DIAGNOSTICS (EXPANDABLE)

            Section("🛠️ Advanced Diagnostics") {
                Toggle("Show Technical Details", isOn: $showDetailedInfo)
                    .foregroundColor(.blue)

                if showDetailedInfo {
                    advancedDiagnosticRows
                }

                Button("Refresh System Status") {
                    refreshDiagnostics()
                }
                .foregroundColor(.green)
            }
        }
        .navigationTitle("🌌 VybeOS Diagnostics")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            refreshDiagnostics()
        }
    }

    // MARK: - 🌟 SYSTEM STATUS COMPONENTS

    private var systemStatusRows: some View {
        Group {
            diagnosticRow(
                "System Status",
                isSystemHealthy ? "🟢 Operational" : "🔴 Issues Detected",
                color: isSystemHealthy ? .green : .red
            )

            diagnosticRow(
                "KASPER MLX Engine",
                "🚀 v2.1.2 RuntimeBundle",
                color: .blue
            )

            diagnosticRow(
                "Manifest Loaded",
                (diagnostics["manifestLoaded"] as? Bool == true) ? "✅ Yes" : "❌ No",
                color: (diagnostics["manifestLoaded"] as? Bool == true) ? .green : .red
            )

            if let version = diagnostics["version"] as? String {
                diagnosticRow("Bundle Version", version, color: .secondary)
            }
        }
    }

    private var runtimeBundleRows: some View {
        Group {
            diagnosticRow(
                "Behavioral Files",
                "\(diagnostics["behavioralFiles"] as? Int ?? 0)",
                color: .blue
            )

            diagnosticRow(
                "Rich Content Files",
                "\(diagnostics["richFiles"] as? Int ?? 0)",
                color: .purple
            )

            let totalFiles = (diagnostics["behavioralFiles"] as? Int ?? 0) + (diagnostics["richFiles"] as? Int ?? 0)
            diagnosticRow(
                "Total Content Files",
                "\(totalFiles)",
                color: .green
            )
        }
    }

    private var contentRoutingRows: some View {
        Group {
            let fallbackCount = diagnostics["fallbackCount"] as? Int ?? 0
            diagnosticRow(
                "Fallback Events",
                "\(fallbackCount)",
                color: fallbackCount == 0 ? .green : .orange
            )

            let routingHealth = fallbackCount == 0 ? "🎯 Perfect" : fallbackCount < 5 ? "✅ Good" : "⚠️ Review"
            diagnosticRow(
                "Routing Health",
                routingHealth,
                color: fallbackCount == 0 ? .green : fallbackCount < 5 ? .blue : .orange
            )
        }
    }

    private var systemAlertRows: some View {
        Group {
            if let missingNumbers = diagnostics["missingNumbers"] as? [String], !missingNumbers.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Missing Content Numbers")
                        .font(.headline)
                        .foregroundColor(.red)

                    Text(missingNumbers.joined(separator: ", "))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.red.opacity(0.1))
                        )
                }
            }

            let fallbackCount = diagnostics["fallbackCount"] as? Int ?? 0
            if fallbackCount > 0 {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text("Content fallbacks detected - system using backup content")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    private var advancedDiagnosticRows: some View {
        Group {
            // Show raw diagnostic data for development
            ForEach(Array(diagnostics.keys.sorted()), id: \.self) { key in
                if let value = diagnostics[key] {
                    diagnosticRow(
                        key.capitalized.replacingOccurrences(of: "([a-z])([A-Z])", with: "$1 $2", options: .regularExpression),
                        "\(value)",
                        color: .secondary
                    )
                }
            }
        }
    }

    // MARK: - 🛠️ HELPER METHODS

    private func diagnosticRow(_ title: String, _ value: String, color: Color = .secondary) -> some View {
        HStack {
            Text(title)
                .font(.body)
            Spacer()
            Text(value)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(color)
        }
    }

    private var isSystemHealthy: Bool {
        guard let manifestLoaded = diagnostics["manifestLoaded"] as? Bool else { return false }
        let fallbackCount = diagnostics["fallbackCount"] as? Int ?? 0
        let missingNumbers = diagnostics["missingNumbers"] as? [String] ?? []

        return manifestLoaded && fallbackCount == 0 && missingNumbers.isEmpty
    }

    private var hasSystemAlerts: Bool {
        let fallbackCount = diagnostics["fallbackCount"] as? Int ?? 0
        let missingNumbers = diagnostics["missingNumbers"] as? [String] ?? []
        return fallbackCount > 0 || !missingNumbers.isEmpty
    }

    private func refreshDiagnostics() {
        // Get latest diagnostic data from router
        diagnostics = router.getDiagnostics()
        print("🔄 VybeOS Diagnostics refreshed: \(diagnostics)")
    }
}

// MARK: - 🎨 PREVIEW CONFIGURATION

#Preview {
    NavigationStack {
        RouterDiagnosticsView()
    }
}
