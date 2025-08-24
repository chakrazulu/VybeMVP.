//
//  LivingInsightView.swift
//  VybeMVP
//
//  Created by Claude on 1/24/25.
//  Purpose: SwiftUI components for easy Living Insight integration
//  Drop-in replacements for existing insight displays
//

import SwiftUI

/// Drop-in Living Insight component for Home KASPER tile
struct LivingInsightView: View {
    let trigger: InsightTrigger
    @StateObject private var bridge = LivingInsightBridge.shared
    @State private var currentInsight: String = "Aligning with cosmic energies..."
    @State private var isLoading = false
    @State private var showingDetails = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text("KASPER Insight")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)

                Spacer()

                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    Button(action: refreshInsight) {
                        Image(systemName: "arrow.clockwise")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }

            // Insight Text
            Text(currentInsight)
                .font(.body)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .animation(.easeInOut(duration: 0.3), value: currentInsight)

            // Quality Indicator (debug only)
            #if DEBUG
            if let result = bridge.lastInsight {
                HStack {
                    Text("Method: \(result.method.rawValue)")
                    Spacer()
                    Text("Quality: \(String(format: "%.2f", result.quality))")
                }
                .font(.caption2)
                .foregroundColor(.secondary)
            }
            #endif
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
        .onAppear {
            loadInitialInsight()
        }
        .onChange(of: bridge.lastInsight) { _ in
            updateInsightText()
        }
    }

    private func loadInitialInsight() {
        // Use cached insight if available
        if let cached = bridge.getCachedInsight() {
            currentInsight = cached.text
        } else {
            currentInsight = bridge.homeInsightText()

            // Generate fresh insight in background
            generateInsightIfNeeded()
        }
    }

    private func refreshInsight() {
        isLoading = true

        Task {
            do {
                _ = try await bridge.generateInsight(trigger: .homeRefresh)
                await MainActor.run {
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    // Could show error state
                }
            }
        }
    }

    private func generateInsightIfNeeded() {
        guard !isLoading else { return }

        Task {
            _ = try? await bridge.generateInsight(trigger: trigger)
        }
    }

    private func updateInsightText() {
        guard let result = bridge.lastInsight else { return }
        currentInsight = result.text
    }
}

// MARK: - Compact Insight View

/// Compact version for smaller spaces
struct CompactLivingInsightView: View {
    let trigger: InsightTrigger
    @StateObject private var bridge = LivingInsightBridge.shared
    @State private var insight: String = "Cosmic alignment in progress..."

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "sparkles")
                .font(.caption)
                .foregroundColor(.purple)

            Text(insight)
                .font(.caption)
                .lineLimit(1)
                .truncationMode(.tail)
                .animation(.easeInOut(duration: 0.3), value: insight)

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.purple.opacity(0.1))
        .cornerRadius(8)
        .onAppear {
            loadInsight()
        }
        .onChange(of: bridge.lastInsight) { _ in
            loadInsight()
        }
    }

    private func loadInsight() {
        if let result = bridge.getCachedInsight() {
            // Truncate for compact display
            let truncated = result.text.components(separatedBy: ".").first ?? result.text
            insight = truncated
        } else {
            Task {
                _ = try? await bridge.generateInsight(trigger: trigger)
            }
        }
    }
}

// MARK: - Meditation Insight View

/// Specialized view for post-meditation insights
struct MeditationInsightView: View {
    @StateObject private var bridge = LivingInsightBridge.shared
    @State private var insight: String?
    @State private var isVisible = false

    var body: some View {
        if let insight = insight, isVisible {
            VStack(spacing: 16) {
                // Icon
                Image(systemName: "leaf.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.green)

                // Title
                Text("Post-Meditation Insight")
                    .font(.headline)
                    .fontWeight(.medium)

                // Insight
                Text(insight)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Dismiss
                Button("Continue") {
                    withAnimation(.easeOut(duration: 0.3)) {
                        isVisible = false
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(24)
            .background(.regularMaterial)
            .cornerRadius(16)
            .shadow(radius: 8)
            .scaleEffect(isVisible ? 1.0 : 0.8)
            .opacity(isVisible ? 1.0 : 0.0)
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isVisible)
        }
    }

    func showInsight() {
        Task {
            do {
                let result = try await bridge.generateInsight(trigger: .meditationEnded)
                await MainActor.run {
                    if let result = result {
                        insight = result.text
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            isVisible = true
                        }
                    }
                }
            } catch {
                // Handle silently
            }
        }
    }
}

// MARK: - Context-Aware Insight View

/// Automatically adapts to current context
struct AdaptiveInsightView: View {
    @StateObject private var bridge = LivingInsightBridge.shared
    @Environment(\.colorScheme) var colorScheme
    @State private var currentContext: UserMode = .home
    @State private var insight: String = "Gathering wisdom..."

    var body: some View {
        Group {
            switch currentContext {
            case .home:
                homeInsightCard
            case .meditate:
                meditationInsightCard
            case .journal:
                journalInsightCard
            case .sanctum:
                sanctumInsightCard
            default:
                generalInsightCard
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .contextChanged)) { notification in
            if let newContext = notification.object as? UserMode {
                updateContext(newContext)
            }
        }
    }

    private var homeInsightCard: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "house.fill")
                Text("Home Guidance")
                    .fontWeight(.medium)
                Spacer()
            }
            .font(.caption)
            .foregroundColor(.blue)

            Text(insight)
                .font(.body)
        }
        .insightCardStyle()
    }

    private var meditationInsightCard: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "leaf.fill")
                Text("Mindful Reflection")
                    .fontWeight(.medium)
                Spacer()
            }
            .font(.caption)
            .foregroundColor(.green)

            Text(insight)
                .font(.body)
        }
        .insightCardStyle()
    }

    private var journalInsightCard: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "book.fill")
                Text("Journaling Prompt")
                    .fontWeight(.medium)
                Spacer()
            }
            .font(.caption)
            .foregroundColor(.orange)

            Text(insight)
                .font(.body)
        }
        .insightCardStyle()
    }

    private var sanctumInsightCard: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "sparkles")
                Text("Sacred Wisdom")
                    .fontWeight(.medium)
                Spacer()
            }
            .font(.caption)
            .foregroundColor(.purple)

            Text(insight)
                .font(.body)
        }
        .insightCardStyle()
    }

    private var generalInsightCard: some View {
        VStack(alignment: .leading) {
            Text(insight)
                .font(.body)
        }
        .insightCardStyle()
    }

    private func updateContext(_ newContext: UserMode) {
        currentContext = newContext

        Task {
            let trigger: InsightTrigger = switch newContext {
            case .meditate: .meditationEnded
            case .journal: .journalSaved
            case .sanctum: .sanctumEntered
            default: .homeAutomatic
            }

            _ = try? await bridge.generateInsight(trigger: trigger)
        }
    }
}

// MARK: - View Extensions

extension View {
    func insightCardStyle() -> some View {
        self
            .padding()
            .background(.regularMaterial)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let contextChanged = Notification.Name("com.vybe.contextChanged")
}

// MARK: - Preview Helpers

#if DEBUG
struct LivingInsightView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LivingInsightView(trigger: .homeRefresh)
                .padding()
                .previewDisplayName("Full Insight")

            CompactLivingInsightView(trigger: .homeAutomatic)
                .padding()
                .previewDisplayName("Compact Insight")

            MeditationInsightView()
                .padding()
                .previewDisplayName("Meditation Insight")

            AdaptiveInsightView()
                .padding()
                .previewDisplayName("Adaptive Insight")
        }
    }
}
#endif
