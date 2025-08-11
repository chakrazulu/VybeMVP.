//
//  NumberRichContentView.swift
//  VybeMVP
//
//  Created by KASPER MLX Team on August 2025.
//  Copyright © 2025 Vybe. All rights reserved.
//
//  PURPOSE:
//  SwiftUI view for displaying rich number content from RuntimeBundle
//  with smooth loading states, error handling, and graceful fallbacks.
//  Integrates with KASPERContentRouter for manifest-driven content.
//
//  FEATURES:
//  - Displays 20+ behavioral insights per number with intensity visualizations
//  - Sacred color theming matching numerological traditions
//  - Persona-guided content with spiritual authority context
//  - Interactive trigger tags and intensity progress bars
//  - Backward compatibility with legacy content schema
//  - Smooth loading/error states with cosmic theming
//
//  UI COMPONENTS:
//  - behavioralInsightsView: Main insights display with cards and intensity bars
//  - intensityScoringView: Energy range visualization with progress bars
//  - behavioralInsightCard: Individual insight with category, text, and triggers
//

import SwiftUI

struct NumberRichContentView: View {
    let number: Int
    @StateObject private var vm = NumberMeaningViewModel()

    // Sacred color system from CLAUDE.md
    private var sacredColor: Color {
        switch number {
        case 0: return .white
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        case 6: return .indigo
        case 7: return .purple
        case 8: return Color(red: 1.0, green: 0.84, blue: 0) // Gold
        case 9: return .white
        case 11, 22, 33, 44: return .purple // Master numbers
        default: return .purple
        }
    }

    var body: some View {
        ZStack {
            CosmicBackgroundView()
                .ignoresSafeArea()

            Group {
                switch vm.state {
                case .idle, .loading:
                    loadingView

                case .empty:
                    emptyView

                case .error(let msg):
                    errorView(msg)

                case .loaded(let content):
                    loadedView(content)
                }
            }
        }
        .task {
            vm.load(number: number)
        }
        .navigationTitle("Number \(number)")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Loading State

    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(sacredColor)

            Text("Summoning rich content...")
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))

            Text("Number \(number)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(sacredColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Empty State

    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(sacredColor.opacity(0.6))

            Text("No rich content available")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Text("Number \(number)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(sacredColor)

            Text("Showing live insight templates instead")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.7))
                .padding(.top, 8)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Error State

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.orange)

            Text("Trouble loading Number \(number)")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Text(message)
                .font(.footnote)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: {
                vm.load(number: number)
            }) {
                Label("Retry", systemImage: "arrow.clockwise")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(sacredColor.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(sacredColor, lineWidth: 1)
                    )
            }
            .padding(.top)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Loaded Content Display

    /// Main content view when rich content has been successfully loaded
    /// Prioritizes new behavioral insights schema while maintaining legacy support
    /// Creates a scrollable layout with sacred color theming and cosmic background
    private func loadedView(_ content: NumberRichContent) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Sacred number header with title, persona, and category
                headerView(content)

                // MARK: Primary Content - Behavioral Insights (v2.1.5 Schema)
                // Displays 20+ rich insights with intensity scoring and trigger tags
                // This is the main content from KASPERMLXRuntimeBundle files
                if let insights = content.behavioral_insights, !insights.isEmpty {
                    behavioralInsightsView(insights)
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(sacredColor.opacity(0.5), lineWidth: 1)
                        )
                }

                // Intensity scoring section
                if let scoring = content.intensity_scoring {
                    intensityScoringView(scoring)
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(sacredColor.opacity(0.5), lineWidth: 1)
                        )
                }

                // MARK: Legacy Content Support (v1.0 Schema)
                // These sections are displayed only if behavioral_insights is empty
                // Maintains backward compatibility with older content format
                if let overview = content.overview {
                    sectionView(overview)
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(sacredColor.opacity(0.5), lineWidth: 1)
                        )
                }

                if let symbolism = content.symbolism {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Symbolism")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(sacredColor)

                        sectionView(symbolism)
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(sacredColor.opacity(0.5), lineWidth: 1)
                    )
                }

                if let correspondences = content.correspondences {
                    correspondencesView(correspondences)
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(sacredColor.opacity(0.5), lineWidth: 1)
                        )
                }

                if let practices = content.practices {
                    practicesView(practices)
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(sacredColor.opacity(0.5), lineWidth: 1)
                        )
                }
            }
            .padding()
        }
    }

    // MARK: - Content Components

    @ViewBuilder
    private func headerView(_ content: NumberRichContent) -> some View {
        VStack(alignment: .center, spacing: 16) {
            // Large number display
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [sacredColor.opacity(0.3), sacredColor.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)

                Circle()
                    .stroke(sacredColor, lineWidth: 2)
                    .frame(width: 120, height: 120)

                Text("\(number)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(sacredColor)
            }

            // Title and persona information
            VStack(spacing: 8) {
                if let title = content.title {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }

                if let persona = content.persona {
                    Text("Guided by \(persona)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(sacredColor.opacity(0.8))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(sacredColor.opacity(0.2))
                        .cornerRadius(8)
                }

                if let category = content.behavioral_category {
                    Text(category.replacingOccurrences(of: "_", with: " ").capitalized)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }

            // Legacy meta information (for backward compatibility)
            if let meta = content.meta {
                VStack(spacing: 8) {
                    if meta.type == "master" {
                        HStack(spacing: 12) {
                            Text("MASTER NUMBER")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(sacredColor.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(sacredColor, lineWidth: 1)
                                )

                            if let base = meta.base_number {
                                Text("Base: \(base)")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }

    @ViewBuilder
    private func sectionView(_ section: NumberRichContent.Section) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = section.title {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
            }

            if let body = section.body {
                Text(body)
                    .foregroundColor(.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let bullets = section.bullets, !bullets.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(bullets, id: \.self) { bullet in
                        HStack(alignment: .top, spacing: 12) {
                            Text("•")
                                .foregroundColor(sacredColor)
                            Text(bullet)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func correspondencesView(_ correspondences: [String: String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Correspondences")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(sacredColor)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(correspondences.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    HStack {
                        Text("\(key.capitalized):")
                            .fontWeight(.semibold)
                            .foregroundColor(sacredColor)

                        Text(value)
                            .foregroundColor(.white.opacity(0.9))

                        Spacer()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func practicesView(_ practices: [NumberRichContent.Section]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Practices")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(sacredColor)

            ForEach(Array(practices.enumerated()), id: \.offset) { _, practice in
                sectionView(practice)
                    .padding(.vertical, 4)
            }
        }
    }

    // MARK: - Behavioral Insights Content Views (v2.1.5 Schema)

    /// Displays the main collection of behavioral insights for this number
    /// Creates a vertical stack of insight cards with sacred color theming
    /// Each number typically has 20+ insights covering various spiritual categories
    @ViewBuilder
    private func behavioralInsightsView(_ insights: [NumberRichContent.BehavioralInsight]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header with sacred color theming
            Text("Spiritual Insights")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(sacredColor)

            // Create individual insight cards for each behavioral insight
            // Using enumerated to provide stable IDs for SwiftUI list performance
            ForEach(Array(insights.enumerated()), id: \.offset) { index, insight in
                behavioralInsightCard(insight, index: index)
            }
        }
    }

    /// Individual behavioral insight card with rich content display
    /// Shows category, intensity visualization, main insight text, and trigger tags
    /// Uses sacred color theming and responsive layout for optimal readability
    @ViewBuilder
    private func behavioralInsightCard(_ insight: NumberRichContent.BehavioralInsight, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {

            // MARK: Category Header with Intensity Visualization
            HStack {
                // Display insight category with proper formatting
                // Converts "core_essence" to "Core Essence" for better readability
                if let category = insight.category {
                    Text(category.replacingOccurrences(of: "_", with: " ").capitalized)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(sacredColor)
                }

                Spacer()

                // Intensity indicator with percentage and visual dots
                // Shows both numerical (88%) and visual (●●●●○) representations
                if let intensity = insight.intensity {
                    HStack(spacing: 4) {
                        // Percentage display (e.g., "88%")
                        Text("\(String(format: "%.0f", intensity * 100))%")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(sacredColor)

                        // Visual intensity bar using 5 circles
                        // Filled circles represent intensity level, empty circles show remaining capacity
                        HStack(spacing: 2) {
                            ForEach(0..<5, id: \.self) { i in
                                Circle()
                                    .fill(i < Int(intensity * 5) ? sacredColor : sacredColor.opacity(0.3))
                                    .frame(width: 6, height: 6)
                            }
                        }
                    }
                }
            }

            // MARK: Main Spiritual Insight Content
            // Display the rich insight text with proper text wrapping
            // Content often includes markdown formatting and deep spiritual wisdom
            if let insightText = insight.insight {
                Text(insightText)
                    .foregroundColor(.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true) // Allow vertical expansion, maintain horizontal constraints
            }

            // MARK: Trigger Tags Display
            // Show contextual triggers that activate this insight
            // Displayed as pill-shaped tags in an adaptive grid layout
            if let triggers = insight.triggers, !triggers.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    // Trigger section label
                    Text("Triggered by:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(sacredColor.opacity(0.8))

                    // Adaptive grid for trigger tags - automatically flows to new lines
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 6) {
                        ForEach(triggers, id: \.self) { trigger in
                            // Individual trigger tag with pill styling
                            Text(trigger.replacingOccurrences(of: "_", with: " "))
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(sacredColor.opacity(0.2))
                                .cornerRadius(8)
                                .foregroundColor(sacredColor)
                        }
                    }
                }
            }

            // MARK: Supportive Practices Display
            // Show activities, practices, and contexts that enhance this insight
            // Essential for providing actionable spiritual guidance to users
            if let supports = insight.supports, !supports.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    // Support section label with positive green theming
                    Text("Enhanced by:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.green.opacity(0.8))

                    // Adaptive grid for support tags with positive styling
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 6) {
                        ForEach(supports, id: \.self) { support in
                            // Individual support tag with positive green styling
                            Text(support.replacingOccurrences(of: "_", with: " "))
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(8)
                                .foregroundColor(.green)
                        }
                    }
                }
            }

            // MARK: Challenge Areas Display
            // Show obstacles and situations that can hinder this insight
            // Critical for helping users recognize and navigate spiritual challenges
            if let challenges = insight.challenges, !challenges.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    // Challenge section label with caution orange theming
                    Text("Challenged by:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.orange.opacity(0.8))

                    // Adaptive grid for challenge tags with caution styling
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 6) {
                        ForEach(challenges, id: \.self) { challenge in
                            // Individual challenge tag with caution orange styling
                            Text(challenge.replacingOccurrences(of: "_", with: " "))
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.orange.opacity(0.2))
                                .cornerRadius(8)
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
        }
        // Card styling with subtle background and sacred color border
        .padding()
        .background(Color.white.opacity(0.05)) // Subtle background for card definition
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(sacredColor.opacity(0.3), lineWidth: 1) // Sacred color border
        )
    }

    /// Displays the overall energy intensity scoring for this number
    /// Creates a visual progress bar showing the spiritual energy range (e.g., 70%-90%)
    /// Includes explanatory notes about the number's energetic characteristics
    @ViewBuilder
    private func intensityScoringView(_ scoring: NumberRichContent.IntensityScoring) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section header with sacred color theming
            Text("Energy Intensity")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(sacredColor)

            VStack(alignment: .leading, spacing: 8) {
                // MARK: Intensity Range Display
                // Shows numerical range (e.g., "70% - 90%") with visual progress bar
                if let minRange = scoring.min_range, let maxRange = scoring.max_range {
                    HStack {
                        Text("Intensity Range:")
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.9))

                        Spacer()

                        // Display percentage range (e.g., "70% - 90%")
                        Text("\(String(format: "%.0f", minRange * 100))% - \(String(format: "%.0f", maxRange * 100))%")
                            .fontWeight(.medium)
                            .foregroundColor(sacredColor)
                    }

                    // MARK: Visual Intensity Progress Bar
                    // Creates a horizontal bar showing the intensity range within a 0-100% spectrum
                    // Background bar represents full range, colored bar shows actual intensity window
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background track representing 0-100% range
                            Rectangle()
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 8)
                                .cornerRadius(4)

                            // Colored intensity bar showing actual range
                            // Width represents range span, offset represents starting point
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [sacredColor.opacity(0.6), sacredColor],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * CGFloat(maxRange - minRange), height: 8)
                                .offset(x: geometry.size.width * CGFloat(minRange))
                                .cornerRadius(4)
                        }
                    }
                    .frame(height: 8) // Fixed height for consistent visual appearance
                }

                // MARK: Explanatory Note
                // Display human-readable explanation of the intensity scoring
                // Provides context about the spiritual energy characteristics of this number
                if let note = scoring.note {
                    Text(note)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .italic() // Italic styling to distinguish as explanatory text
                        .padding(.top, 4)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        NumberRichContentView(number: 4)
    }
}
