/**
 * KASPER MLX Professional Test Interface
 * 
 * World-class testing environment for Apple Intelligence MLX framework validation.
 * Features comprehensive diagnostics, real-time performance metrics, and
 * beautiful insight display with full professional debugging capabilities.
 */

import SwiftUI
import Combine
import Foundation

struct KASPERMLXTestView: View {
    @EnvironmentObject private var kasperMLX: KASPERMLXManager
    @State private var insight: KASPERInsight?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var selectedFeature: KASPERFeature = .journalInsight
    @State private var lastInferenceTime: Double = 0.0
    @State private var totalInsightsGenerated: Int = 0
    @State private var showingFullInsight = false
    @State private var loadingProgress: Double = 0.0
    @State private var currentStatus: String = "Ready"
    @State private var providersStatus: [String: Bool] = [:]
    @State private var performanceMetrics: [String: Any] = [:]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    featureSelectionSection
                    generateButtonSection
                    
                    if let insight = insight {
                        insightDisplaySection(insight)
                    }
                    
                    if let errorMessage = errorMessage {
                        errorDisplaySection(errorMessage)
                    }
                    
                    developerToolsSection
                }
                .padding(20)
            }
            .navigationTitle("KASPER MLX")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                updateEngineStatus()
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("KASPER MLX")
                        .font(.title.bold())
                        .foregroundColor(.primary)
                    
                    Text("Apple Intelligence Test Suite")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(kasperMLX.isReady ? .green : .orange)
                            .frame(width: 12, height: 12)
                            .scaleEffect(kasperMLX.isReady ? 1.0 : 0.8)
                            .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: kasperMLX.isReady)
                        
                        Text(currentStatus)
                            .font(.caption.weight(.medium))
                            .foregroundColor(kasperMLX.isReady ? .green : .orange)
                    }
                    
                    Text("v1.0.0-beta")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack(spacing: 16) {
                MetricCard(title: "Generated", value: "\(totalInsightsGenerated)", icon: "sparkles")
                MetricCard(title: "Last Time", value: String(format: "%.2fs", lastInferenceTime), icon: "timer")
                MetricCard(title: "Engine", value: kasperMLX.getEngineStatus(), icon: "cpu")
            }
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.quaternary, lineWidth: 1)
        )
    }
    
    private var featureSelectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Test Configuration")
                .font(.headline.weight(.semibold))
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(KASPERFeature.allCases, id: \.self) { feature in
                    FeatureCard(
                        feature: feature,
                        isSelected: selectedFeature == feature,
                        action: { 
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedFeature = feature
                            }
                        }
                    )
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.quaternary, lineWidth: 1)
        )
    }
    
    private var generateButtonSection: some View {
        VStack(spacing: 16) {
            Button(action: generateInsight) {
                HStack(spacing: 12) {
                    ZStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.9)
                        } else {
                            Image(systemName: "sparkles")
                                .font(.title3.weight(.semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 24, height: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(isLoading ? "Generating Insight..." : "Generate Insight")
                            .font(.headline.weight(.semibold))
                            .foregroundColor(.white)
                        
                        if isLoading {
                            Text(currentStatus)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        } else {
                            Text("Test \(selectedFeature.rawValue) feature")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    
                    Spacer()
                    
                    if !isLoading {
                        Image(systemName: "arrow.right")
                            .font(.title3.weight(.medium))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: kasperMLX.isReady ? [.blue, .purple] : [.gray, .gray.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: kasperMLX.isReady ? .blue.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
            }
            .disabled(!kasperMLX.isReady || isLoading)
            .scaleEffect(isLoading ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isLoading)
            
            if isLoading {
                ProgressView(value: loadingProgress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .scaleEffect(y: 2)
                    .animation(.easeInOut(duration: 0.3), value: loadingProgress)
            }
        }
    }
    
    private func insightDisplaySection(_ insight: KASPERInsight) -> some View {
        VStack(spacing: 20) {
            insightHeaderView(insight)
            insightContentView(insight)
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.quaternary, lineWidth: 1)
        )
    }
    
    private func insightHeaderView(_ insight: KASPERInsight) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Generated Insight")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.primary)
                
                Text("ID: \(insight.id.uuidString.prefix(8))")
                    .font(.caption.monospaced())
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 8) {
                    Image(systemName: "timer")
                        .font(.caption.weight(.medium))
                        .foregroundColor(.blue)
                    Text(String(format: "%.3fs", insight.inferenceTime))
                        .font(.caption.weight(.medium).monospacedDigit())
                        .foregroundColor(.blue)
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "gauge.medium")
                        .font(.caption.weight(.medium))
                        .foregroundColor(.green)
                    Text("\(Int(insight.confidence * 100))%")
                        .font(.caption.weight(.medium).monospacedDigit())
                        .foregroundColor(.green)
                }
            }
        }
    }
    
    private func insightContentView(_ insight: KASPERInsight) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            insightTextView(insight)
            insightMetadataGrid(insight)
        }
    }
    
    private func insightTextView(_ insight: KASPERInsight) -> some View {
        Button(action: { showingFullInsight = true }) {
            VStack(alignment: .leading, spacing: 12) {
                Text(insight.content)
                    .font(.body)
                    .lineSpacing(4)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(showingFullInsight ? nil : 3)
                
                if insight.content.count > 150 && !showingFullInsight {
                    HStack {
                        Text("Tap to read full insight")
                            .font(.caption.weight(.medium))
                            .foregroundColor(.blue)
                        
                        Image(systemName: "chevron.down")
                            .font(.caption.weight(.medium))
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(16)
            .background(Color.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.blue.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func insightMetadataGrid(_ insight: KASPERInsight) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
            MetadataCard(title: "Feature", value: insight.feature.rawValue, icon: "tag")
            MetadataCard(title: "Type", value: insight.type.rawValue, icon: "lightbulb")
            MetadataCard(title: "Model", value: insight.metadata.modelVersion, icon: "cpu")
            MetadataCard(title: "Cached", value: insight.metadata.cacheHit ? "Yes" : "No", icon: "memorychip")
        }
    }
    
    private func errorDisplaySection(_ errorMessage: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title3)
                .foregroundColor(.red)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Generation Failed")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(.red)
                
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(16)
        .background(.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.red.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var developerToolsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Developer Tools")
                .font(.headline.weight(.semibold))
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                KASPERActionButton(
                    title: "Clear Cache",
                    icon: "trash.circle",
                    color: .orange,
                    action: { 
                        Task {
                            await kasperMLX.clearCache()
                            totalInsightsGenerated = 0
                        }
                    }
                )
                
                KASPERActionButton(
                    title: "Journal Test",
                    icon: "book.circle",
                    color: .green,
                    action: testJournalInsight
                )
                
                KASPERActionButton(
                    title: "Daily Card",
                    icon: "star.circle",
                    color: .purple,
                    action: testDailyCard
                )
            }
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.quaternary, lineWidth: 1)
        )
    }
    
    // MARK: - Methods
    
    private func generateInsight() {
        Task {
            do {
                await MainActor.run {
                    isLoading = true
                    errorMessage = nil
                    currentStatus = "Initializing..."
                    loadingProgress = 0.0
                }
                
                await updateProgress(0.2, status: "Loading providers...")
                try await Task.sleep(nanoseconds: 200_000_000)
                
                await updateProgress(0.5, status: "Gathering context...")
                try await Task.sleep(nanoseconds: 300_000_000)
                
                await updateProgress(0.8, status: "Generating insight...")
                
                let startTime = Date()
                let generatedInsight = try await kasperMLX.generateQuickInsight(
                    for: selectedFeature,
                    query: "Professional test insight generation"
                )
                let inferenceTime = Date().timeIntervalSince(startTime)
                
                await updateProgress(1.0, status: "Complete!")
                
                await MainActor.run {
                    insight = generatedInsight
                    lastInferenceTime = inferenceTime
                    totalInsightsGenerated += 1
                    isLoading = false
                    currentStatus = "Ready"
                    showingFullInsight = true
                }
                
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                    currentStatus = "Error"
                    loadingProgress = 0.0
                }
            }
        }
    }
    
    private func updateProgress(_ progress: Double, status: String) async {
        await MainActor.run {
            loadingProgress = progress
            currentStatus = status
        }
    }
    
    private func updateEngineStatus() {
        currentStatus = kasperMLX.isReady ? "Ready" : "Initializing"
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

// MARK: - Supporting UI Components

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption.weight(.medium))
                .foregroundColor(.blue)
            
            Text(value)
                .font(.caption.weight(.semibold).monospacedDigit())
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
    }
}

struct FeatureCard: View {
    let feature: KASPERFeature
    let isSelected: Bool
    let action: () -> Void
    
    private var featureInfo: (icon: String, color: Color) {
        switch feature {
        case .journalInsight: return ("book.fill", .blue)
        case .dailyCard: return ("star.fill", .purple)
        case .sanctumGuidance: return ("building.columns.fill", .indigo)
        case .matchCompatibility: return ("heart.fill", .pink)
        case .cosmicTiming: return ("clock.fill", .orange)
        case .focusIntention: return ("target", .green)
        case .realmInterpretation: return ("globe", .teal)
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: featureInfo.icon)
                    .font(.title3.weight(.medium))
                    .foregroundColor(isSelected ? .white : featureInfo.color)
                
                Text(feature.rawValue.capitalized)
                    .font(.caption.weight(.medium))
                    .foregroundColor(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                isSelected ? featureInfo.color : Color.secondary.opacity(0.1),
                in: RoundedRectangle(cornerRadius: 12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? featureInfo.color : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MetadataCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption.weight(.medium))
                .foregroundColor(.blue)
                .frame(width: 16)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.caption.weight(.medium))
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding(8)
        .background(Color.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
    }
}

struct KASPERActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title3.weight(.medium))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption.weight(.medium))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationView {
        KASPERMLXTestView()
            .environmentObject(KASPERMLXManager.shared)
    }
}