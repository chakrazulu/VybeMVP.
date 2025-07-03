/**
 * Filename: ActivityView.swift
 * 
 * 🎯 ENHANCED COSMIC ACTIVITY VIEW - UNIFIED SPIRITUAL TIMELINE
 *
 * === CORE PURPOSE ===
 * Unified activity feed displaying both AI insights and cosmic match events
 * in chronological order. Provides comprehensive view of user's spiritual journey.
 *
 * === MAJOR ENHANCEMENT (Phase 2.3) ===
 * • Cosmic Match Integration: VybeMatchManager.recentMatches displayed alongside insights
 * • Unified Timeline: Mixed feed of insights and cosmic matches sorted by timestamp
 * • Enhanced Filtering: Time-based filtering (Today, Week, Month, All Time)
 * • Improved UI: Cosmic-themed cards with enhanced visual hierarchy
 * • Performance: Lazy loading and efficient data management
 *
 * === DATA SOURCES ===
 * • PersistedInsightLog: AI-generated insights from Core Data
 * • VybeMatch: Cosmic alignment events from VybeMatchManager
 * • Unified display with consistent cosmic styling
 *
 * === CARD TYPES ===
 * • FullInsightCard: AI insights with sacred number theming
 * • CosmicMatchCard: Cosmic alignment celebrations with haptic patterns
 * • Mixed timeline sorted by timestamp for chronological flow
 *
 * === FILTERING SYSTEM ===
 * • Today: Last 24 hours of activity
 * • Week: Last 7 days of spiritual events
 * • Month: Last 30 days of cosmic activity
 * • All Time: Complete spiritual timeline
 *
 * === PERFORMANCE OPTIMIZATIONS ===
 * • LazyVStack: Only renders visible cards
 * • Core Data fetch: Automatic batching
 * • AI refresh: Deferred by 1.0s on appear
 * • Navigation highlight: Efficient filtering
 * • Cosmic match caching: In-memory optimization
 *
 * === LAYOUT SPECIFICATIONS ===
 * • Full screen NavigationView with cosmic background
 * • Card spacing: 20pt between timeline items
 * • Horizontal padding: 16pt for card containers
 * • Filter bar: Top-aligned with 12pt spacing
 * • Empty state: Centered message with cosmic styling
 *
 * === SACRED COLOR SYSTEM ===
 * 1. Red - Creation/Fire 🔥
 * 2. Orange - Partnership/Balance ⚖️
 * 3. Yellow - Expression/Joy ☀️
 * 4. Green - Foundation/Earth 🌍
 * 5. Blue - Freedom/Sky 🌌
 * 6. Indigo - Harmony/Love 💜
 * 7. Purple - Spirituality/Wisdom 🔮
 * 8. Gold (#FFD700) - Abundance/Prosperity 💰
 * 9. White - Completion/Universal ⚪
 *
 * === NAVIGATION INTEGRATION ===
 * • ActivityNavigationManager: Deep linking to specific insights
 * • Highlight system: Navigated insights shown prominently
 * • Badge navigation: Tappable elements throughout timeline
 *
 * Purpose: Enhanced activity feed showing comprehensive spiritual timeline
 * with both AI insights and cosmic match events in unified display.
 */

import SwiftUI
import CoreData

// MARK: - Time Filter Options

enum ActivityTimeFilter: String, CaseIterable {
    case today = "1D"
    case week = "7D"
    case month = "30D"
    case allTime = "All"
    
    var icon: String {
        switch self {
        case .today: return "sun.max.fill"
        case .week: return "calendar.circle.fill"
        case .month: return "moon.circle.fill"
        case .allTime: return "infinity.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .today: return .yellow
        case .week: return .blue
        case .month: return .purple
        case .allTime: return .white
        }
    }
    
    func filterDate() -> Date? {
        let calendar = Calendar.current
        switch self {
        case .today:
            return calendar.startOfDay(for: Date())
        case .week:
            return calendar.date(byAdding: .day, value: -7, to: Date())
        case .month:
            return calendar.date(byAdding: .day, value: -30, to: Date())
        case .allTime:
            return nil // No filter
        }
    }
}

// MARK: - Timeline Item Protocol

protocol TimelineItem {
    var timelineTimestamp: Date { get }
    var timelineId: UUID { get }
}

// MARK: - Timeline Item Implementations

extension PersistedInsightLog: TimelineItem {
    // PersistedInsightLog already has timestamp: Date? and id: UUID? properties from Core Data
    // We need to provide non-optional versions for the protocol
    var timelineTimestamp: Date {
        return self.timestamp ?? Date()
    }
    
    var timelineId: UUID {
        return self.id ?? UUID()
    }
}

extension VybeMatch: TimelineItem {
    // VybeMatch already has timestamp: Date and id: UUID
    var timelineTimestamp: Date {
        return self.timestamp
    }
    
    var timelineId: UUID {
        return self.id
    }
} // Import CoreData

/**
 * ActivityView: Cosmic activity feed showing persisted insight logs
 * 
 * 🎯 PIXEL-PERFECT UI REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
 * 
 * === SCREEN LAYOUT (iPhone 14 Pro Max: 430×932 points) ===
 * • NavigationView: Standard iOS navigation
 * • Title: "Cosmic Activity" - navigation title style
 * • Background: Full screen CosmicBackgroundView
 * • ScrollView: Vertical, full width
 * • Content padding: 20pts all sides
 * 
 * === EMPTY STATE ===
 * • Text: "No activity or insights recorded yet."
 * • Font: Headline (~17pt)
 * • Color: Secondary (system gray)
 * • Alignment: Center horizontally and vertically
 * • Padding: Standard system padding
 * 
 * === INSIGHT LIST ===
 * • Container: LazyVStack for performance
 * • Spacing: 20pts between cards
 * • Sort order: Newest first (by timestamp)
 * • Animation: Default Core Data animation
 * 
 * === FULL INSIGHT CARD ===
 * • Container padding: 20pts all sides
 * • Corner radius: 16pts
 * • Border: 2pt gradient stroke
 * • Shadow 1: Sacred color 30%, 15pt blur, 8pt Y offset
 * • Shadow 2: Black 20%, 5pt blur, 2pt Y offset
 * 
 * === CARD HEADER ===
 * • Title font: Title2 (~22pt), bold
 * • Title gradient: White→Sacred color(90%)
 * • Title shadow: Sacred color 40%, 3pt blur
 * • Date/time: Caption font (~12pt), 80% white
 * • Number badge: 50×50pt circle
 * • Badge gradient: Radial, sacred color 80%→40%
 * • Badge number: 24pt bold rounded, white
 * 
 * === CARD CONTENT ===
 * • Divider: 2pt height, gradient sacred color
 * • Body text: Body font (~17pt), 95% white
 * • Line spacing: 6pts
 * • Text alignment: Leading (left)
 * 
 * === TAGS SECTION ===
 * • Icon: tag.fill, caption size
 * • Tag text: Caption2 font (~11pt)
 * • Tag padding: 8pt horizontal, 4pt vertical
 * • Tag background: Capsule, sacred color 20%
 * • Tag border: 1pt, sacred color 40%
 * • Section margin: 8pt top
 * 
 * === SACRED COLOR SYSTEM ===
 * 1. Red - Creation/Fire 🔥
 * 2. Orange - Partnership/Balance ⚖️
 * 3. Yellow - Expression/Joy ☀️
 * 4. Green - Foundation/Earth 🌍
 * 5. Blue - Freedom/Sky 🌌
 * 6. Indigo - Harmony/Love 💜
 * 7. Purple - Spirituality/Wisdom 🔮
 * 8. Gold (#FFD700) - Abundance/Prosperity 💰
 * 9. White - Completion/Universal ⚪
 * 
 * === GRADIENT SYSTEM ===
 * • Card background: 4 stops
 *   - Sacred color 80%
 *   - Sacred color 50%
 *   - Sacred color 30%
 *   - Black 40%
 * • Direction: Top-left to bottom-right
 * 
 * === PERFORMANCE OPTIMIZATIONS ===
 * • LazyVStack: Only renders visible cards
 * • Core Data fetch: Automatic batching
 * • AI refresh: Deferred by 1.0s on appear
 * • Navigation highlight: Efficient filtering
 * 
 * === STATE MANAGEMENT ===
 * • managedObjectContext: Core Data context
 * • insightLogs: FetchedResults from Core Data
 * • activityNavigationManager: For deep linking
 * • aiInsightManager: For refresh triggers
 */
struct ActivityView: View {
    @Environment(\.managedObjectContext) private var viewContext // Access managed object context
    @StateObject private var activityNavigationManager = ActivityNavigationManager.shared
    @StateObject private var aiInsightManager = AIInsightManager.shared
    @StateObject private var vybeMatchManager = VybeMatchManager()

    // MARK: - State Properties
    
    @State private var selectedFilter: ActivityTimeFilter = .week

    // FetchRequest to load PersistedInsightLog entries, sorted by timestamp descending
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PersistedInsightLog.timestamp, ascending: false)],
        animation: .default) // Optional: add animation for list changes
    private var insightLogs: FetchedResults<PersistedInsightLog>

    var body: some View {
        NavigationView { 
            VStack(spacing: 0) {
                // MARK: - Filter Bar
                filterBar
                
                // MARK: - Timeline Content
                ScrollView {
                    if filteredTimelineItems.isEmpty {
                        emptyStateView
                    } else {
                        LazyVStack(alignment: .leading, spacing: 20) {
                            ForEach(filteredTimelineItems, id: \.timelineId) { item in
                                timelineItemView(for: item)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                    }
                }
                .refreshable {
                    // Pull-to-refresh functionality
                    await refreshActivityData()
                }
            }
            .navigationTitle("Cosmic Activity")
            .background(CosmicBackgroundView())

        }
        .onAppear {
            // PERFORMANCE FIX: Defer heavy AI insights refresh to prevent tab loading delays
            
            // Clear any previously set insightToView when the tab appears
            // activityNavigationManager.insightToView = nil
            
            // Defer AI insights refresh by 1 second to prevent blocking
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            aiInsightManager.refreshInsightIfNeeded()
                print("⚡ ActivityView: AI insights refresh deferred for performance")
            }
        }
    }
    
    // MARK: - Filter Bar
    
    private var filterBar: some View {
        HStack(spacing: 12) {
            ForEach(ActivityTimeFilter.allCases, id: \.self) { filter in
                Button(action: { selectedFilter = filter }) {
                    HStack(spacing: 6) {
                        Image(systemName: filter.icon)
                            .font(.caption)
                        Text(filter.rawValue)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(selectedFilter == filter ? filter.color.opacity(0.3) : Color.black.opacity(0.3))
                            .overlay(
                                Capsule()
                                    .stroke(selectedFilter == filter ? filter.color : Color.white.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .foregroundColor(selectedFilter == filter ? filter.color : .white.opacity(0.8))
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.black.opacity(0.2))
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles.rectangle.stack")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.6))
            
            Text("No Cosmic Activity")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Your spiritual journey will appear here as you align with cosmic frequencies and receive insights.")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.top, 100)
    }
    
    // MARK: - Timeline Data Processing
    
    private var filteredTimelineItems: [any TimelineItem] {
        var items: [any TimelineItem] = []
        
        // Add filtered insights
        let filteredInsights = insightLogs.filter { insight in
            guard let filterDate = selectedFilter.filterDate() else { return true }
            return insight.timestamp ?? Date() >= filterDate
        }
        items.append(contentsOf: filteredInsights)
        
        // Add filtered cosmic matches
        let filteredMatches = vybeMatchManager.recentMatches.filter { match in
            guard let filterDate = selectedFilter.filterDate() else { return true }
            return match.timestamp >= filterDate
        }
        items.append(contentsOf: filteredMatches)
        
        // Sort by timestamp (most recent first)
        return items.sorted { item1, item2 in
            item1.timelineTimestamp > item2.timelineTimestamp
        }
    }
    
    // MARK: - Timeline Item View Builder
    
    @ViewBuilder
    private func timelineItemView(for item: any TimelineItem) -> some View {
        if let insight = item as? PersistedInsightLog {
            FullInsightCard(logEntry: insight)
        } else if let match = item as? VybeMatch {
            CosmicMatchCard(match: match)
        }
    }
    
    // MARK: - Refresh Function
    
    private func refreshActivityData() async {
        // Refresh AI insights
        aiInsightManager.refreshInsightIfNeeded()
        
        // VybeMatchManager data is already live, no refresh needed
        print("🔄 Activity data refreshed")
    }
}

struct FullInsightCard: View {
    let logEntry: PersistedInsightLog // Changed from MatchedInsightData to PersistedInsightLog
    
    // Get the sacred color for this number
    private var primaryColor: Color {
        switch logEntry.number {
        case 1: return .red          // Creation/Fire 🔥
        case 2: return .orange       // Partnership/Balance ⚖️
        case 3: return .yellow       // Expression/Joy ☀️
        case 4: return .green        // Foundation/Earth 🌍
        case 5: return .blue         // Freedom/Sky 🌌
        case 6: return .indigo       // Harmony/Love 💜
        case 7: return .purple       // Spirituality/Wisdom 🔮
        case 8: return Color(red: 1.0, green: 0.84, blue: 0.0) // Gold - Abundance/Prosperity 💰
        case 9: return .white        // Completion/Universal ⚪
        default: return .white
        }
    }
    
    // Create complementary gradient colors
    private var gradientColors: [Color] {
        [
            primaryColor.opacity(0.8),
            primaryColor.opacity(0.5),
            primaryColor.opacity(0.3),
            Color.black.opacity(0.4)
        ]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Resonance: Focus #\(logEntry.number) Aligned")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [.white, primaryColor.opacity(0.9)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: primaryColor.opacity(0.4), radius: 3, x: 0, y: 1)
                    
                    Text("Received: \(logEntry.timestamp ?? Date(), style: .date) at \(logEntry.timestamp ?? Date(), style: .time)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                Spacer()
                
                // Number badge with sacred color
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [primaryColor.opacity(0.8), primaryColor.opacity(0.4)]),
                                center: .center,
                                startRadius: 5,
                                endRadius: 25
                            )
                        )
                        .frame(width: 50, height: 50)
                        .shadow(color: primaryColor.opacity(0.6), radius: 8, x: 0, y: 0)
                    
                    Text("\(logEntry.number)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                }
            }
            
            Divider()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [primaryColor.opacity(0.7), primaryColor.opacity(0.3)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 2)
            
            Text(logEntry.text ?? "Insight text not available.")
                .font(.body)
                .foregroundColor(.white.opacity(0.95))
                .lineSpacing(6)
                .multilineTextAlignment(.leading)
            
            if let tags = logEntry.tags, !tags.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "tag.fill")
                        .font(.caption)
                        .foregroundColor(primaryColor.opacity(0.8))
                        .shadow(color: primaryColor.opacity(0.4), radius: 2)
                    
                    Text(tags)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(primaryColor.opacity(0.2))
                                .overlay(
                                    Capsule()
                                        .stroke(primaryColor.opacity(0.4), lineWidth: 1)
                                )
                        )
                }
                .padding(.top, 8)
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [primaryColor.opacity(0.6), primaryColor.opacity(0.2)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .cornerRadius(16)
        .shadow(color: primaryColor.opacity(0.3), radius: 15, x: 0, y: 8)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct CosmicMatchCard: View {
    let match: VybeMatch
    
    // Get the sacred color for this number
    private var primaryColor: Color {
        switch match.number {
        case 1: return .red          // Creation/Fire 🔥
        case 2: return .orange       // Partnership/Balance ⚖️
        case 3: return .yellow       // Expression/Joy ☀️
        case 4: return .green        // Foundation/Earth 🌍
        case 5: return .blue         // Freedom/Sky 🌌
        case 6: return .indigo       // Harmony/Love 💜
        case 7: return .purple       // Spirituality/Wisdom 🔮
        case 8: return Color(red: 1.0, green: 0.84, blue: 0.0) // Gold - Abundance/Prosperity 💰
        case 9: return .white        // Completion/Universal ⚪
        default: return .white
        }
    }
    
    // Create complementary gradient colors
    private var gradientColors: [Color] {
        [
            primaryColor.opacity(0.9),
            primaryColor.opacity(0.6),
            primaryColor.opacity(0.4),
            Color.black.opacity(0.5)
        ]
    }
    
    // Sacred number meanings
    private var sacredMeaning: String {
        switch match.number {
        case 1: return "Leadership & New Beginnings"
        case 2: return "Harmony & Cooperation"
        case 3: return "Creativity & Expression"
        case 4: return "Stability & Foundation"
        case 5: return "Freedom & Adventure"
        case 6: return "Love & Nurturing"
        case 7: return "Spirituality & Wisdom"
        case 8: return "Power & Abundance"
        case 9: return "Completion & Universal Love"
        default: return "Sacred Alignment"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                VStack(alignment: .leading) {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.title2)
                            .foregroundColor(primaryColor)
                            .shadow(color: primaryColor.opacity(0.6), radius: 4)
                        
                        Text("Cosmic Alignment")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [.white, primaryColor.opacity(0.9)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: primaryColor.opacity(0.4), radius: 3, x: 0, y: 1)
                    }
                    
                    Text("Achieved: \(match.timestamp, style: .date) at \(match.timestamp, style: .time)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                Spacer()
                
                // Number badge with cosmic styling
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [primaryColor.opacity(0.9), primaryColor.opacity(0.5)]),
                                center: .center,
                                startRadius: 5,
                                endRadius: 30
                            )
                        )
                        .frame(width: 60, height: 60)
                        .shadow(color: primaryColor.opacity(0.8), radius: 12, x: 0, y: 0)
                        .overlay(
                            Circle()
                                .stroke(primaryColor.opacity(0.6), lineWidth: 2)
                        )
                    
                    Text("\(match.number)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                }
            }
            
            Divider()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [primaryColor.opacity(0.8), primaryColor.opacity(0.4)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 2)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "heart.circle.fill")
                        .font(.title3)
                        .foregroundColor(.pink.opacity(0.8))
                    
                    Text("Sacred Meaning: \(sacredMeaning)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.95))
                }
                
                Text("Focus Number and Realm Number achieved perfect cosmic alignment at \(Int(match.heartRate)) BPM. This synchronicity represents a moment of spiritual harmony where your chosen path aligns with universal frequencies.")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .lineSpacing(6)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 16) {
                    HStack(spacing: 6) {
                        Image(systemName: "heart.fill")
                            .font(.caption)
                            .foregroundColor(.pink.opacity(0.8))
                        
                        Text("\(Int(match.heartRate)) BPM")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.pink.opacity(0.2))
                            .overlay(
                                Capsule()
                                    .stroke(Color.pink.opacity(0.4), lineWidth: 1)
                            )
                    )
                    
                    HStack(spacing: 6) {
                        Image(systemName: "waveform.path.ecg")
                            .font(.caption)
                            .foregroundColor(primaryColor.opacity(0.8))
                        
                        Text("Cosmic Match")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(primaryColor.opacity(0.2))
                            .overlay(
                                Capsule()
                                    .stroke(primaryColor.opacity(0.4), lineWidth: 1)
                            )
                    )
                    
                    Spacer()
                }
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [primaryColor.opacity(0.7), primaryColor.opacity(0.3)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .cornerRadius(16)
        .shadow(color: primaryColor.opacity(0.4), radius: 20, x: 0, y: 10)
        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        // For preview, we need to inject the managed object context
        let persistenceController = PersistenceController.preview // Use your preview controller
        ActivityView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(FocusNumberManager.shared) // Keep for any indirect dependencies if any
            .environmentObject(ActivityNavigationManager.shared) // Add if ActivityView uses it directly in preview
            .onAppear {
                // Create some sample PersistedInsightLog data for the preview
                let context = persistenceController.container.viewContext
                for i in 0..<3 {
                    let newLog = PersistedInsightLog(context: context)
                    newLog.id = UUID()
                    newLog.timestamp = Date().addingTimeInterval(Double(-i * 3600)) // Offset timestamps
                    newLog.number = Int16(5 + i)
                    newLog.category = "insight"
                    newLog.text = "This is a sample preview insight for number \\(5+i). It's designed to test the display of persisted logs in the ActivityView. This text can be quite long to check wrapping and layout."
                    newLog.tags = i % 2 == 0 ? "FocusMatch, RealmTouch" : "TestInsight"
                }
                do {
                    try context.save()
                } catch {
                    // Simplified fatalError for preview
                    fatalError("Unresolved error during ActivityView preview setup: \(error.localizedDescription)")
                }
            }
    }
} 