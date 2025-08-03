/**
 * KASPER MLX Feedback Analytics View
 * 
 * Professional analytics interface for KASPER MLX user feedback.
 * Provides insights into user satisfaction, feature performance,
 * and data export capabilities for AI training.
 */

import SwiftUI
import Charts

struct KASPERFeedbackAnalyticsView: View {
    @StateObject private var feedbackManager = KASPERFeedbackManager.shared
    @State private var showingExportSheet = false
    @State private var exportedData: Data?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    overviewStatsSection
                    featureBreakdownSection
                    recentFeedbackSection
                    exportSection
                }
                .padding(20)
            }
            .navigationTitle("Feedback Analytics")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.black)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Refresh") {
                        // Refresh will trigger automatic update via @StateObject
                    }
                    .foregroundColor(.purple)
                }
            }
        }
        .sheet(isPresented: $showingExportSheet) {
            exportDataSheet
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("KASPER MLX Analytics")
                        .font(.title.bold())
                        .foregroundColor(.white)
                    
                    Text("User Feedback & Satisfaction Metrics")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Circle()
                        .fill(.green)
                        .frame(width: 12, height: 12)
                    
                    Text("Live Data")
                        .font(.caption2)
                        .foregroundColor(.green)
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
    
    private var overviewStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview Statistics")
                .font(.headline.weight(.semibold))
                .foregroundColor(.white)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                StatCard(
                    title: "Total Feedback",
                    value: "\(feedbackManager.stats.totalFeedback)",
                    icon: "chart.bar.fill",
                    color: .blue
                )
                
                StatCard(
                    title: "Satisfaction Rate",
                    value: String(format: "%.1f%%", feedbackManager.stats.positivePercentage),
                    icon: "heart.fill",
                    color: .green
                )
                
                StatCard(
                    title: "Positive Feedback",
                    value: "\(feedbackManager.stats.positiveCount)",
                    icon: "hand.thumbsup.fill",
                    color: .green
                )
                
                StatCard(
                    title: "Needs Improvement",
                    value: "\(feedbackManager.stats.negativeCount)",
                    icon: "hand.thumbsdown.fill",
                    color: .red
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
    
    private var featureBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Feature Performance")
                .font(.headline.weight(.semibold))
                .foregroundColor(.white)
            
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 12) {
                ForEach(KASPERFeature.allCases, id: \.self) { feature in
                    let breakdown = feedbackManager.stats.featureBreakdown[feature] ?? (positive: 0, negative: 0)
                    let total = breakdown.positive + breakdown.negative
                    let positiveRate = total > 0 ? Double(breakdown.positive) / Double(total) * 100 : 0
                    
                    FeatureBreakdownCard(
                        feature: feature,
                        positiveCount: breakdown.positive,
                        negativeCount: breakdown.negative,
                        positiveRate: positiveRate
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
    
    private var recentFeedbackSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Feedback")
                .font(.headline.weight(.semibold))
                .foregroundColor(.white)
            
            let recentFeedback = feedbackManager.getRecentFeedback(limit: 5)
            
            if recentFeedback.isEmpty {
                Text("No feedback yet")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(recentFeedback) { feedback in
                        FeedbackCard(feedback: feedback)
                    }
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
    
    private var exportSection: some View {
        VStack(spacing: 16) {
            Button(action: exportFeedbackData) {
                HStack(spacing: 12) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Export Training Data")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("Download feedback for AI training")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .font(.title3)
                        .foregroundColor(.white)
                }
                .padding(20)
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
            }
            .disabled(feedbackManager.stats.totalFeedback == 0)
            
            if feedbackManager.stats.totalFeedback > 0 {
                Button("Clear All Feedback Data") {
                    feedbackManager.clearAllFeedback()
                }
                .foregroundColor(.red)
                .font(.caption)
            }
        }
    }
    
    private var exportDataSheet: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let data = exportedData {
                    Text("Export Successful!")
                        .font(.title2.weight(.bold))
                        .foregroundColor(.green)
                    
                    Text("Feedback data exported successfully")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("\(data.count) bytes of training data")
                        .font(.caption.monospaced())
                        .foregroundColor(.blue)
                        .padding()
                        .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                    
                    // In a real app, you'd implement sharing here
                    Button("Share Data") {
                        // Implement sharing functionality
                    }
                    .foregroundColor(.blue)
                    .padding()
                    .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                } else {
                    Text("Preparing export...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    ProgressView()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Export Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showingExportSheet = false
                        exportedData = nil
                    }
                }
            }
        }
    }
    
    // MARK: - Methods
    
    private func exportFeedbackData() {
        showingExportSheet = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            exportedData = feedbackManager.exportFeedbackData()
        }
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3.weight(.bold).monospacedDigit())
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }
}

struct FeatureBreakdownCard: View {
    let feature: KASPERFeature
    let positiveCount: Int
    let negativeCount: Int
    let positiveRate: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(feature.rawValue.capitalized)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.white)
                
                Text("\(positiveCount + negativeCount) total responses")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "%.1f%%", positiveRate))
                    .font(.headline.weight(.bold).monospacedDigit())
                    .foregroundColor(positiveRate >= 70 ? .green : positiveRate >= 50 ? .orange : .red)
                
                HStack(spacing: 8) {
                    Text("👍 \(positiveCount)")
                        .font(.caption2)
                        .foregroundColor(.green)
                    
                    Text("👎 \(negativeCount)")
                        .font(.caption2)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }
}

struct FeedbackCard: View {
    let feedback: KASPERFeedback
    
    var body: some View {
        HStack(spacing: 12) {
            Text(feedback.rating.emoji)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(feedback.feature.rawValue.capitalized)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.white)
                
                Text(feedback.insightContent.prefix(50) + "...")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text(feedback.timestamp, style: .relative)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    KASPERFeedbackAnalyticsView()
}