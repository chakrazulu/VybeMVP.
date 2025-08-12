/*
 * ========================================
 * 🔮 REALM NUMBER DETAIL VIEW - iOS NATIVE REDESIGN
 * ========================================
 *
 * RENAMED FROM: NumberMeaningView → RealmNumberDetailView (December 2024)
 *
 * NAVIGATION PATH:
 * RealmNumberView → Tap on realm number → NavigationLink → RealmNumberDetailView(initialSelectedNumber)
 *
 * iOS DESIGN PRINCIPLES:
 * - Clean, focused interface following Apple HIG
 * - Native components (List, Section, Label)
 * - Consistent with system typography and spacing
 * - Smooth, purposeful animations
 * - Accessibility-first design
 * - No text truncation
 */

import SwiftUI

struct RealmNumberDetailView: View {
    // MARK: - Properties

    let initialSelectedNumber: Int
    @State private var selectedNumber: Int
    @State private var richContent: [String: Any]? = nil
    @State private var isLoadingContent = false
    @State private var expandedSections: Set<String> = []
    @State private var selectedInsightIndex: Int? = nil

    // For smooth transitions
    @State private var contentOpacity: Double = 0
    @State private var headerScale: CGFloat = 0.95

    // Rich content loading
    @ObservedObject private var contentRouter = KASPERContentRouter.shared
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    init(initialSelectedNumber: Int = 1) {
        self.initialSelectedNumber = initialSelectedNumber
        self._selectedNumber = State(initialValue: initialSelectedNumber)
    }

    // MARK: - Sacred Color System (Simplified)

    private var sacredColor: Color {
        switch selectedNumber {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        case 6: return .indigo
        case 7: return .purple
        case 8: return Color(red: 1.0, green: 0.84, blue: 0)
        case 9: return .cyan
        case 11, 22, 33, 44: return .purple
        default: return .accentColor
        }
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            // Subtle background gradient (iOS-style)
            LinearGradient(
                colors: [
                    Color(uiColor: .systemBackground),
                    sacredColor.opacity(0.05)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            if isLoadingContent {
                loadingView
            } else if let content = richContent {
                contentView(content)
            } else {
                emptyStateView
            }
        }
        .navigationTitle("Number \(selectedNumber)")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                numberPickerButton
            }
        }
        .task {
            await loadRichContent()
            withAnimation(.easeInOut(duration: 0.5)) {
                contentOpacity = 1
                headerScale = 1
            }
        }
    }

    // MARK: - Loading View

    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(sacredColor)

            Text("Loading spiritual insights...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(sacredColor.opacity(0.6))
                .symbolEffect(.pulse)

            Text("No insights available")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Content for number \(selectedNumber) is being prepared")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button(action: { Task { await loadRichContent() } }) {
                Label("Try Again", systemImage: "arrow.clockwise")
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)
            .tint(sacredColor)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Main Content View

    private func contentView(_ content: [String: Any]) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header Section
                headerSection(content)
                    .scaleEffect(headerScale)
                    .opacity(contentOpacity)

                // Behavioral Insights
                if let insights = content["behavioral_insights"] as? [[String: Any]] {
                    behavioralInsightsSection(insights)
                        .opacity(contentOpacity)
                }

                // Intensity Scoring
                if let scoring = content["intensity_scoring"] as? [String: Any] {
                    intensityScoringSection(scoring)
                        .opacity(contentOpacity)
                }

                // Metadata Section
                if let meta = content["meta"] as? [String: Any] {
                    metadataSection(meta)
                        .opacity(contentOpacity)
                }
            }
        }
    }

    // MARK: - Header Section

    private func headerSection(_ content: [String: Any]) -> some View {
        VStack(spacing: 16) {
            // Large Number Display
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                sacredColor.opacity(0.15),
                                sacredColor.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)

                Text("\(selectedNumber)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(sacredColor)
            }
            .padding(.top, 20)

            // Title
            if let title = content["title"] as? String {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            // Persona Badge
            if let persona = content["persona"] as? String {
                HStack {
                    Image(systemName: "person.crop.circle")
                    Text(persona)
                }
                .font(.subheadline)
                .foregroundColor(sacredColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(sacredColor.opacity(0.1))
                        .overlay(
                            Capsule()
                                .strokeBorder(sacredColor.opacity(0.3), lineWidth: 1)
                        )
                )
            }

            // Category
            if let category = content["behavioral_category"] as? String {
                Text(category.replacingOccurrences(of: "_", with: " ").capitalized)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
            }
        }
        .padding(.bottom, 20)
    }

    // MARK: - Behavioral Insights Section

    private func behavioralInsightsSection(_ insights: [[String: Any]]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Section Header
            HStack {
                Label("Spiritual Insights", systemImage: "sparkles")
                    .font(.headline)
                    .foregroundColor(.primary)

                Spacer()

                Text("\(insights.count) insights")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color(uiColor: .secondarySystemBackground))

            // Insights List
            LazyVStack(spacing: 0) {
                ForEach(Array(insights.enumerated()), id: \.offset) { index, insight in
                    InsightRow(
                        insight: insight,
                        index: index,
                        sacredColor: sacredColor,
                        isExpanded: selectedInsightIndex == index,
                        onTap: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                if selectedInsightIndex == index {
                                    selectedInsightIndex = nil
                                } else {
                                    selectedInsightIndex = index
                                }
                            }
                        }
                    )

                    if index < insights.count - 1 {
                        Divider()
                            .padding(.leading, 16)
                    }
                }
            }
        }
    }

    // MARK: - Intensity Scoring Section

    private func intensityScoringSection(_ scoring: [String: Any]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Energy Intensity", systemImage: "waveform")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 20)

            VStack(alignment: .leading, spacing: 12) {
                if let minRange = scoring["min_range"] as? Double,
                   let maxRange = scoring["max_range"] as? Double {

                    // Range Display
                    HStack {
                        Text("Range")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(Int(minRange * 100))% - \(Int(maxRange * 100))%")
                            .fontWeight(.medium)
                            .foregroundColor(sacredColor)
                    }

                    // Visual Progress Bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(uiColor: .tertiarySystemFill))
                                .frame(height: 8)

                            // Filled Range
                            RoundedRectangle(cornerRadius: 4)
                                .fill(sacredColor)
                                .frame(
                                    width: geometry.size.width * CGFloat(maxRange - minRange),
                                    height: 8
                                )
                                .offset(x: geometry.size.width * CGFloat(minRange))
                        }
                    }
                    .frame(height: 8)
                }

                if let note = scoring["note"] as? String {
                    Text(note)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
            )
            .padding(.horizontal)
        }
    }

    // MARK: - Metadata Section

    private func metadataSection(_ meta: [String: Any]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Additional Information", systemImage: "info.circle")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 20)

            VStack(spacing: 0) {
                // Keywords
                if let keywords = meta["keywords"] as? [String], !keywords.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Keywords")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        FlowLayout(spacing: 8) {
                            ForEach(keywords, id: \.self) { keyword in
                                Text(keyword)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(sacredColor.opacity(0.1))
                                    )
                                    .foregroundColor(sacredColor)
                            }
                        }
                    }
                    .padding()

                    Divider()
                }

                // Compatibility
                if let compatibility = meta["compatibility"] as? [String: Any],
                   let mostCompatible = compatibility["most_compatible"] as? [Int] {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Most Compatible")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        HStack(spacing: 12) {
                            ForEach(mostCompatible, id: \.self) { number in
                                NumberBadge(number: number)
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
            )
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }

    // MARK: - Number Picker

    private var numberPickerButton: some View {
        Menu {
            ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33, 44], id: \.self) { number in
                Button(action: {
                    withAnimation(.easeInOut) {
                        selectedNumber = number
                        contentOpacity = 0
                    }
                    Task {
                        await loadRichContent()
                        withAnimation(.easeInOut) {
                            contentOpacity = 1
                        }
                    }
                }) {
                    Label("Number \(number)", systemImage: "\(number).circle")
                }
            }
        } label: {
            Image(systemName: "number.circle")
                .font(.title3)
                .symbolVariant(.fill)
                .foregroundColor(sacredColor)
        }
    }

    // MARK: - Data Loading

    private func loadRichContent() async {
        isLoadingContent = true
        defer { isLoadingContent = false }

        if let content = await contentRouter.getRichContent(for: selectedNumber) {
            await MainActor.run {
                richContent = content
                print("✅ Loaded rich content for number \(selectedNumber)")
            }
        } else {
            // Try fallback to behavioral content
            if let behavioral = await contentRouter.getBehavioralInsights(
                context: "lifePath",
                number: selectedNumber
            ) {
                await MainActor.run {
                    richContent = behavioral
                    print("⚠️ Using behavioral content as fallback for number \(selectedNumber)")
                }
            } else {
                await MainActor.run {
                    richContent = nil
                    print("❌ No content found for number \(selectedNumber)")
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct InsightRow: View {
    let insight: [String: Any]
    let index: Int
    let sacredColor: Color
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            Button(action: onTap) {
                HStack(alignment: .top, spacing: 12) {
                    // Number Badge
                    Text("\(index + 1)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .background(
                            Circle()
                                .fill(sacredColor)
                        )

                    VStack(alignment: .leading, spacing: 4) {
                        // Category
                        if let category = insight["category"] as? String {
                            Text(category.replacingOccurrences(of: "_", with: " ").capitalized)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }

                        // Insight Preview
                        if let insightText = insight["insight"] as? String {
                            Text(insightText)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineLimit(isExpanded ? nil : 2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    Spacer()

                    // Intensity
                    if let intensity = insight["intensity"] as? Double {
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(Int(intensity * 100))%")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(sacredColor)

                            Image(systemName: "chevron.down")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        }
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())

            // Expanded Content
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    // Triggers
                    if let triggers = insight["triggers"] as? [String], !triggers.isEmpty {
                        TagSection(
                            title: "Triggered by",
                            items: triggers,
                            color: sacredColor
                        )
                    }

                    // Supports
                    if let supports = insight["supports"] as? [String], !supports.isEmpty {
                        TagSection(
                            title: "Enhanced by",
                            items: supports,
                            color: .green
                        )
                    }

                    // Challenges
                    if let challenges = insight["challenges"] as? [String], !challenges.isEmpty {
                        TagSection(
                            title: "Challenged by",
                            items: challenges,
                            color: .orange
                        )
                    }
                }
                .padding(.leading, 36)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
    }
}

struct TagSection: View {
    let title: String
    let items: [String]
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(color.opacity(0.8))

            FlowLayout(spacing: 6) {
                ForEach(items.prefix(6), id: \.self) { item in
                    Text(item.replacingOccurrences(of: "_", with: " "))
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(color.opacity(0.1))
                        )
                        .foregroundColor(color)
                }
            }
        }
    }
}

struct NumberBadge: View {
    let number: Int

    private var color: Color {
        switch number {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        case 6: return .indigo
        case 7: return .purple
        case 8: return Color(red: 1.0, green: 0.84, blue: 0)
        case 9: return .cyan
        default: return .purple
        }
    }

    var body: some View {
        Text("\(number)")
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: 32, height: 32)
            .background(
                Circle()
                    .fill(color)
            )
    }
}

// MARK: - FlowLayout already exists in ChakraSymbolView.swift

// MARK: - Preview

#Preview {
    NavigationStack {
        RealmNumberDetailView(initialSelectedNumber: 7)
    }
}
