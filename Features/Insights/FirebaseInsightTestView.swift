//
//  FirebaseInsightTestView.swift
//  VybeMVP
//
//  Test view for Firebase Insights integration
//

import SwiftUI

/**
 * 🧪 TEST VIEW - Firebase Insights Integration
 *
 * Simple test interface to verify that your bulletproof insights
 * are loading correctly from Firestore.
 */
struct FirebaseInsightTestView: View {
    @StateObject private var repository = FirebaseInsightRepository()
    @State private var testInsight: SpiritualInsight?
    @State private var isTestRunning = false
    @State private var testResults: [String] = []

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack {
                    Text("🔥 Firebase Insights Test")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Testing your 2,200+ bulletproof insights")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Cache Stats
                VStack(alignment: .leading, spacing: 8) {
                    Text("📊 Cache Statistics")
                        .font(.headline)

                    let stats = repository.getCacheStats()
                    Text("Cache Size: \(stats["cacheSize"] as? Int ?? 0)")
                    Text("Hit Rate: \(String(format: "%.1f%%", (stats["hitRate"] as? Double ?? 0) * 100))")
                    Text("Total Requests: \(stats["totalRequests"] as? Int ?? 0)")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

                // Test Buttons
                VStack(spacing: 12) {
                    Button("🏠 Test Daily Card Insight") {
                        testDailyCard()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("🌌 Test Cosmic HUD Insight") {
                        testCosmicHUD()
                    }
                    .buttonStyle(.bordered)

                    Button("📸 Test Snapshot Insights") {
                        testSnapshots()
                    }
                    .buttonStyle(.bordered)

                    Button("🏛️ Test Sanctum Insights") {
                        testSanctum()
                    }
                    .buttonStyle(.bordered)
                }

                // Test Results
                if !testResults.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("📋 Test Results")
                            .font(.headline)

                        ScrollView {
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(testResults, id: \.self) { result in
                                    Text(result)
                                        .font(.caption)
                                        .foregroundColor(result.hasPrefix("✅") ? .green : result.hasPrefix("❌") ? .red : .primary)
                                }
                            }
                        }
                        .frame(maxHeight: 150)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }

                // Current Insight Display
                if let insight = testInsight {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("✨ Current Insight")
                            .font(.headline)

                        Text(insight.text)
                            .font(.body)
                            .multilineTextAlignment(.leading)

                        HStack {
                            Text("Number: \(insight.number)")
                            Spacer()
                            Text("Category: \(insight.category)")
                            Spacer()
                            Text("Quality: \(String(format: "%.1f", insight.qualityScore))")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)

                        if !insight.actions.isEmpty {
                            Text("Actions: \(insight.actions.joined(separator: ", "))")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }

                Spacer()

                // Loading Indicator
                if repository.isLoading || isTestRunning {
                    ProgressView("Loading insights...")
                }

                // Error Display
                if let error = repository.errorMessage {
                    Text("❌ Error: \(error)")
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .padding()
            .navigationBarHidden(true)
        }
    }

    // MARK: - Test Functions

    private func testDailyCard() {
        isTestRunning = true
        addTestResult("🏠 Testing Daily Card Insight for Number 5...")

        Task {
            do {
                let insight = try await repository.fetchDailyCardInsight(number: 5)
                await MainActor.run {
                    if let insight = insight {
                        testInsight = insight
                        addTestResult("✅ Daily Card: Loaded insight with \(insight.text.count) characters")
                        addTestResult("   Persona: \(insight.persona), Context: \(insight.context)")
                    } else {
                        addTestResult("❌ Daily Card: No insight returned")
                    }
                }
            } catch {
                await MainActor.run {
                    addTestResult("❌ Daily Card: Error - \(error.localizedDescription)")
                }
            }
            await MainActor.run {
                isTestRunning = false
            }
        }
    }

    private func testCosmicHUD() {
        isTestRunning = true
        addTestResult("🌌 Testing Cosmic HUD Insight for Number 3...")

        Task {
            do {
                let insight = try await repository.fetchCosmicHUDInsight(number: 3, category: .insight)
                await MainActor.run {
                    if let insight = insight {
                        testInsight = insight
                        addTestResult("✅ Cosmic HUD: Loaded insight (\(insight.length) words)")
                        addTestResult("   Quality Score: \(insight.qualityScore)")
                    } else {
                        addTestResult("❌ Cosmic HUD: No insight returned")
                    }
                }
            } catch {
                await MainActor.run {
                    addTestResult("❌ Cosmic HUD: Error - \(error.localizedDescription)")
                }
            }
            await MainActor.run {
                isTestRunning = false
            }
        }
    }

    private func testSnapshots() {
        isTestRunning = true
        addTestResult("📸 Testing Snapshot Insights for Number 7...")

        Task {
            do {
                let insights = try await repository.fetchSnapshotInsights(number: 7, count: 3)
                await MainActor.run {
                    addTestResult("✅ Snapshots: Loaded \(insights.count) insights")
                    if let first = insights.first {
                        testInsight = first
                        addTestResult("   First insight: \(first.length) words, checksum: \(first.checksum)")
                    }
                }
            } catch {
                await MainActor.run {
                    addTestResult("❌ Snapshots: Error - \(error.localizedDescription)")
                }
            }
            await MainActor.run {
                isTestRunning = false
            }
        }
    }

    private func testSanctum() {
        isTestRunning = true
        addTestResult("🏛️ Testing Sanctum Insights for Number 1...")

        Task {
            do {
                let insights = try await repository.fetchSanctumInsights(number: 1)
                await MainActor.run {
                    addTestResult("✅ Sanctum: Loaded \(insights.count) insights")
                    let categories = Set(insights.map { $0.category })
                    addTestResult("   Categories: \(categories.joined(separator: ", "))")
                    if let first = insights.first {
                        testInsight = first
                    }
                }
            } catch {
                await MainActor.run {
                    addTestResult("❌ Sanctum: Error - \(error.localizedDescription)")
                }
            }
            await MainActor.run {
                isTestRunning = false
            }
        }
    }

    private func addTestResult(_ result: String) {
        testResults.append("\(Date().formatted(.dateTime.hour().minute().second())) \(result)")

        // Keep only last 10 results
        if testResults.count > 10 {
            testResults.removeFirst()
        }
    }
}

// MARK: - Preview

struct FirebaseInsightTestView_Previews: PreviewProvider {
    static var previews: some View {
        FirebaseInsightTestView()
    }
}
