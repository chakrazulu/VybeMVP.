//
//  KASPERProviderSettingsView.swift
//  VybeMVP
//
//  Created by KASPER MLX Team on August 2025.
//  Copyright © 2025 Vybe. All rights reserved.
//
//  PURPOSE:
//  Settings UI for selecting and monitoring KASPER AI providers.
//  Allows users to switch between different inference strategies
//  and view performance metrics.
//

import SwiftUI

struct KASPERProviderSettingsView: View {
    @StateObject private var orchestrator = KASPEROrchestrator.shared
    @State private var availableStrategies: [KASPERStrategy] = []
    @State private var showPerformanceReport = false
    @State private var performanceReport = ""

    var body: some View {
        ZStack {
            CosmicBackgroundView()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection

                    // Current Provider Status
                    currentProviderSection

                    // Strategy Selection
                    strategySelectionSection

                    // Performance Metrics
                    performanceSection

                    // Debug Options
                    debugSection
                }
                .padding()
            }
        }
        .navigationTitle("KASPER AI Providers")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadStrategies()
        }
        .sheet(isPresented: $showPerformanceReport) {
            performanceReportView
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.purple, .blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text("AI Provider Configuration")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("Select your preferred spiritual AI backend")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.3))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.purple.opacity(0.5), lineWidth: 1)
        )
    }

    // MARK: - Current Provider Section

    private var currentProviderSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Current Provider", systemImage: "checkmark.circle.fill")
                .font(.headline)
                .foregroundColor(.green)

            HStack {
                Text("Active:")
                    .foregroundColor(.white.opacity(0.7))

                Text(orchestrator.activeProvider)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Spacer()

                if orchestrator.isProcessing {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(.purple)
                }
            }

            HStack {
                Text("Strategy:")
                    .foregroundColor(.white.opacity(0.7))

                Text(orchestrator.currentStrategy.displayName)
                    .fontWeight(.semibold)
                    .foregroundColor(.purple)
            }

            if let error = orchestrator.lastError {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.orange)

                    Text(error.localizedDescription)
                        .font(.caption)
                        .foregroundColor(.orange.opacity(0.8))
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black.opacity(0.3))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.green.opacity(0.5), lineWidth: 1)
        )
    }

    // MARK: - Strategy Selection Section

    private var strategySelectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Select Strategy", systemImage: "cpu")
                .font(.headline)
                .foregroundColor(.white)

            ForEach(availableStrategies, id: \.self) { strategy in
                strategyButton(for: strategy)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black.opacity(0.3))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue.opacity(0.5), lineWidth: 1)
        )
    }

    private func strategyButton(for strategy: KASPERStrategy) -> some View {
        Button(action: {
            Task {
                await KASPERMLXEngine.shared.setProviderStrategy(strategy)
                await orchestrator.setStrategy(strategy)
            }
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(strategy.displayName)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    Text(strategy.description)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                if orchestrator.currentStrategy == strategy {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(
                orchestrator.currentStrategy == strategy
                    ? Color.purple.opacity(0.2)
                    : Color.white.opacity(0.05)
            )
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        orchestrator.currentStrategy == strategy
                            ? Color.purple.opacity(0.5)
                            : Color.white.opacity(0.2),
                        lineWidth: 1
                    )
            )
        }
    }

    // MARK: - Performance Section

    private var performanceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Performance", systemImage: "speedometer")
                .font(.headline)
                .foregroundColor(.white)

            if !orchestrator.providerMetrics.isEmpty {
                ForEach(orchestrator.providerMetrics.sorted(by: { $0.key < $1.key }), id: \.key) { provider, metrics in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(provider)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        HStack {
                            Label("\(metrics.totalRequests) requests", systemImage: "number")
                            Spacer()
                            Label(String(format: "%.1f%%", metrics.successRate * 100), systemImage: "checkmark")
                        }
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))

                        Text("Avg: \(String(format: "%.3fs", metrics.averageResponseTime))")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.vertical, 4)
                }
            } else {
                Text("No performance data yet")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }

            Button(action: {
                performanceReport = orchestrator.getPerformanceReport()
                showPerformanceReport = true
            }) {
                Label("View Full Report", systemImage: "chart.line.uptrend.xyaxis")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.purple.opacity(0.2))
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.purple.opacity(0.5), lineWidth: 1)
                    )
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black.opacity(0.3))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.orange.opacity(0.5), lineWidth: 1)
        )
    }

    // MARK: - Debug Section

    private var debugSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Debug Options", systemImage: "ant.circle")
                .font(.headline)
                .foregroundColor(.white)

            Toggle("Debug Mode", isOn: .constant(false))
                .tint(.purple)
                .onChange(of: false) { _, newValue in
                    orchestrator.setDebugMode(newValue)
                }

            Toggle("Allow Cloud Providers", isOn: .constant(false))
                .tint(.blue)
                .onChange(of: false) { _, newValue in
                    orchestrator.setCloudProvidersAllowed(newValue)
                }

            Text("Debug mode shows detailed logs. Cloud providers enable GPT integration (coming soon).")
                .font(.caption)
                .foregroundColor(.white.opacity(0.5))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black.opacity(0.3))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.red.opacity(0.5), lineWidth: 1)
        )
    }

    // MARK: - Performance Report View

    private var performanceReportView: some View {
        NavigationView {
            ZStack {
                CosmicBackgroundView()
                    .ignoresSafeArea()

                ScrollView {
                    Text(performanceReport)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .navigationTitle("Performance Report")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showPerformanceReport = false
                    }
                }
            }
        }
    }

    // MARK: - Helper Methods

    private func loadStrategies() async {
        availableStrategies = await orchestrator.getAvailableStrategies()
    }
}

#Preview {
    NavigationView {
        KASPERProviderSettingsView()
    }
}
