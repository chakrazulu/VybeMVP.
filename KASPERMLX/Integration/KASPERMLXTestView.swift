/**
 * KASPER MLX Test View
 * 
 * A development view for testing KASPER MLX functionality.
 * This view demonstrates the new async insight generation
 * and can be used to validate the architecture.
 */

import SwiftUI

struct KASPERMLXTestView: View {
    @EnvironmentObject private var kasperMLX: KASPERMLXManager
    @State private var insight: KASPERInsight?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var selectedFeature: KASPERFeature = .journalInsight
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Engine Status
                VStack(alignment: .leading, spacing: 8) {
                    Text("KASPER MLX Engine")
                        .font(.headline)
                    
                    HStack {
                        Circle()
                            .fill(kasperMLX.isReady ? .green : .red)
                            .frame(width: 12, height: 12)
                        
                        Text(kasperMLX.getEngineStatus())
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                
                // Feature Selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Feature")
                        .font(.headline)
                    
                    Picker("Feature", selection: $selectedFeature) {
                        ForEach(KASPERFeature.allCases, id: \.self) { feature in
                            Text(feature.rawValue.capitalized)
                                .tag(feature)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                
                // Generate Button
                Button(action: generateInsight) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "sparkles")
                        }
                        Text(isLoading ? "Generating..." : "Generate Insight")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(kasperMLX.isReady ? .blue : .gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(!kasperMLX.isReady || isLoading)
                
                // Insight Display
                if let insight = insight {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("✨ Insight")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text(String(format: "%.2fs", insight.inferenceTime))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(insight.content)
                            .font(.body)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                        
                        HStack {
                            Label("Confidence", systemImage: "gauge.medium")
                            Text("\\(Int(insight.confidence * 100))%")
                            
                            Spacer()
                            
                            Label("Feature", systemImage: "tag")
                            Text(insight.feature.rawValue)
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                }
                
                // Error Display
                if let error = errorMessage {
                    Text("❌ \\(error)")
                        .foregroundColor(.red)
                        .padding()
                        .background(.red.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Spacer()
                
                // Quick Actions
                VStack(spacing: 12) {
                    Text("Quick Tests")
                        .font(.headline)
                    
                    HStack(spacing: 12) {
                        Button("Clear Cache") {
                            Task {
                                await kasperMLX.clearCache()
                            }
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Journal Test") {
                            testJournalInsight()
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Daily Card") {
                            testDailyCard()
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
            }
            .padding()
            .navigationTitle("KASPER MLX Test")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func generateInsight() {
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                insight = try await kasperMLX.generateQuickInsight(
                    for: selectedFeature,
                    query: "Test insight generation"
                )
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    private func testJournalInsight() {
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                insight = try await kasperMLX.generateJournalInsight(
                    entryText: "Today I felt a deep connection to the cosmic energies around me...",
                    tone: "reflective"
                )
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    private func testDailyCard() {
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                insight = try await kasperMLX.generateDailyCardInsight(
                    cardType: "guidance"
                )
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
}

#Preview {
    KASPERMLXTestView()
        .environmentObject(KASPERMLXManager.shared)
}