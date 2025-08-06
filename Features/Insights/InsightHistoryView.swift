/*
 * ========================================
 * 🔮 INSIGHT HISTORY VIEW - SACRED TIMELINE
 * ========================================
 * 
 * CORE PURPOSE:
 * Comprehensive spiritual insight timeline displaying chronological personalized
 * wisdom based on user's archetypal profile, focus numbers, and cosmic alignment.
 * Creates sacred space for reflection tracking with deep spiritual context and
 * interactive insight exploration with detailed view capabilities.
 * 
 * UI SPECIFICATIONS:
 * - Background: Black → Purple(80%) → Blue(60%) → Black cosmic gradient
 * - Header: 40pt sparkles icon in purple/blue gradient circle
 * - Timeline Cards: 16pt radius with white 10% background, 20% border
 * - Timeline Indicator: 12pt circles (yellow for today, white 60% for past)
 * - Loading State: 1.5x scaled progress view with cosmic messaging
 * 
 * INSIGHT TIMELINE SYSTEM:
 * - Chronological Display: Newest insights first with temporal organization
 * - Today Highlighting: Special "TODAY" badge with yellow accent
 * - Timeline Visual: Connected dots with vertical lines for continuity
 * - Card Layout: Preview text (3 lines), tags, and navigation chevron
 * - Interactive Navigation: Tap cards to open detailed insight views
 * 
 * SPIRITUAL DATA INTEGRATION:
 * - UserProfileService: Profile-based insight personalization
 * - InsightFilterService: Advanced insight matching and generation
 * - UserArchetypeManager: Archetypal profile integration for relevance
 * - Personalized Generation: Custom insights based on spiritual preferences
 * - Focus Number Alignment: Insights aligned with user's current focus
 * 
 * STATE MANAGEMENT:
 * - @StateObject insightService: InsightFilterService for data operations
 * - @StateObject archetypeManager: User archetype integration
 * - @State insights: PersonalizedInsight collection for timeline display
 * - @State isLoading: Loading state for data fetching operations
 * - @State selectedInsight: Current insight for detail view presentation
 * 
 * INSIGHT GENERATION SYSTEM:
 * - Today's Insight: generateTodaysInsight() for current spiritual guidance
 * - Historical Insights: 7-day retrospective with generateInsightForDate()
 * - Profile-Based Filtering: Insights tailored to user's spiritual preferences
 * - Temporal Sorting: Chronological organization with timestamp comparison
 * - Dynamic Content: Real-time insight generation based on current profile
 * 
 * INTEGRATION POINTS:
 * - AIInsightManager: Core insight generation and personalization engine
 * - UserProfileService: Profile data for personalized content creation
 * - InsightFilterService: Advanced filtering and matching algorithms
 * - ActivityView: Insight integration in spiritual activity feed
 * - NavigationView: Modal presentation with toolbar navigation
 * 
 * VISUAL DESIGN ELEMENTS:
 * - Cosmic Background: Multi-layer gradient for mystical atmosphere
 * - Timeline Design: Connected dots with visual flow indicators
 * - Card Styling: Glass morphism with subtle borders and backgrounds
 * - Tag System: Purple-accented tags for insight categorization
 * - Sacred Symbols: Sparkles, moon.stars for spiritual iconography
 * 
 * INSIGHT CARD COMPONENTS:
 * - Timeline Indicator: Visual connection between chronological entries
 * - Date Display: Formatted date with "TODAY" special highlighting
 * - Title/Preview: Headline and 3-line content preview
 * - Tag Collection: Spiritual categories and focus areas
 * - Navigation Cue: Chevron right for interaction affordance
 * 
 * EMPTY STATE HANDLING:
 * - Spiritual Messaging: "Your Journey Begins" with moon.stars icon
 * - Guidance Text: Instructions for receiving personalized insights
 * - Encouraging Design: Mystical empty state with cosmic styling
 * - User Education: Explains how to unlock spiritual insights
 * - Progressive Disclosure: Guides users toward insight generation
 * 
 * DETAIL VIEW SYSTEM:
 * - Sheet Presentation: Full-screen insight detail with navigation
 * - Complete Content: Full insight text with enhanced formatting
 * - Tag Display: Grid layout for spiritual categories and themes
 * - Cosmic Styling: Consistent background and typography theming
 * - Navigation Control: Done button for modal dismissal
 * 
 * PERFORMANCE OPTIMIZATIONS:
 * - LazyVStack: Efficient rendering for large insight collections
 * - Task-based Loading: Async insight generation with proper threading
 * - MainActor Updates: UI-safe property updates for state changes
 * - Efficient Filtering: Optimized insight matching algorithms
 * - Memory Management: Proper state cleanup and resource management
 * 
 * SPIRITUAL PERSONALIZATION:
 * - Archetypal Alignment: Insights matched to user's spiritual archetype
 * - Focus Number Integration: Content aligned with selected focus numbers
 * - Temporal Context: Date-specific insights for spiritual timing
 * - Profile Adaptation: Dynamic content based on spiritual preferences
 * - Growth Tracking: Timeline reveals spiritual development patterns
 * 
 * TECHNICAL SPECIFICATIONS:
 * - Card Spacing: 16pt between timeline cards for visual separation
 * - Timeline Width: 2pt connector lines with 12pt circle indicators
 * - Content Limits: 3-line preview text with multiline support
 * - Tag Layout: 2-column grid for efficient tag presentation
 * - Navigation: Sheet-based detail view with toolbar controls
 * 
 * DEBUGGING & MONITORING:
 * - Profile Validation: Checks for valid user profile before generation
 * - Insight Tracking: Monitors successful insight generation
 * - Loading States: Clear feedback during data operations
 * - Error Handling: Graceful fallbacks for missing data
 * - Development Support: Console logging for insight generation flow
 */

import SwiftUI

/**
 * InsightHistoryView - Sacred Timeline of Spiritual Insights
 * 
 * Purpose:
 * - Displays a chronological timeline of personalized insights
 * - Filters insights based on user's spiritual profile and focus numbers
 * - Provides deep archetypal context for each insight
 * - Creates a sacred space for reflection and growth tracking
 * 
 * Design Pattern: MVVM with spiritual data integration
 * Dependencies: InsightFilterService, UserArchetypeManager
 */
struct InsightHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var insightService = InsightFilterService()
    @StateObject private var archetypeManager = UserArchetypeManager.shared
    @State private var insights: [PersonalizedInsight] = []
    @State private var isLoading = true
    @State private var selectedInsight: PersonalizedInsight?
    @State private var showingInsightDetail = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Cosmic background
                cosmicBackground
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        // Header section
                        headerSection
                        
                        // Insights timeline
                        if isLoading {
                            loadingSection
                        } else if insights.isEmpty {
                            emptyStateSection
                        } else {
                            insightTimelineSection
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Insight Timeline")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            loadInsights()
        }
        .sheet(isPresented: $showingInsightDetail) {
            if let insight = selectedInsight {
                InsightDetailView(insight: insight)
            }
        }
    }
    
    // MARK: - View Components
    
    private var cosmicBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.black,
                Color.purple.opacity(0.8),
                Color.blue.opacity(0.6),
                Color.black
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea(.all)
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Sacred symbol
            Image(systemName: "sparkles")
                .font(.system(size: 40))
                .foregroundColor(.yellow)
                .padding()
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                )
            
            VStack(spacing: 8) {
                Text("Sacred Timeline")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Your personalized spiritual insights")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.bottom, 10)
    }
    
    private var loadingSection: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)
            
            Text("Channeling your insights...")
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.top, 50)
    }
    
    private var emptyStateSection: some View {
        VStack(spacing: 20) {
            Image(systemName: "moon.stars")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("Your Journey Begins")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Focus on numbers and explore the app to receive personalized spiritual insights tailored to your archetypal profile.")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
        }
        .padding(.top, 50)
    }
    
    private var insightTimelineSection: some View {
        LazyVStack(spacing: 16) {
            ForEach(insights.indices, id: \.self) { index in
                InsightTimelineCard(
                    insight: insights[index],
                    isFirst: index == 0,
                    onTap: {
                        selectedInsight = insights[index]
                        showingInsightDetail = true
                    }
                )
            }
        }
    }
    
    // MARK: - Data Loading
    
    private func loadInsights() {
        // Claude: SWIFT 6 COMPLIANCE - Removed [weak self] from struct (value type)
        Task {
            await insightService.loadInsightTemplates()
            
            // Generate sample insights based on user's profile
            let sampleInsights = generatePersonalizedInsights()
            
            await MainActor.run {
                insights = sampleInsights
                self.isLoading = false
            }
        }
    }
    
    private func generatePersonalizedInsights() -> [PersonalizedInsight] {
        var generatedInsights: [PersonalizedInsight] = []
        
        // Get current user ID and load their profile
        guard let userID = UserDefaults.standard.string(forKey: "userID"),
              let userProfile = UserProfileService.shared.getCurrentUserProfileFromUserDefaults(for: userID) else {
            print("⚠️ Cannot generate insights: No user profile found")
            return generatedInsights
        }
        
        // Generate today's insight
        if let todayInsight = insightService.generateTodaysInsight(for: userProfile) {
            generatedInsights.append(todayInsight)
        }
        
        // Generate recent insights (last 7 days)
        for dayOffset in 1...7 {
            if let date = Calendar.current.date(byAdding: .day, value: -dayOffset, to: Date()) {
                if let insight = insightService.generateInsightForDate(date, userProfile: userProfile) {
                    generatedInsights.append(insight)
                }
            }
        }
        
        return generatedInsights.sorted { $0.timestamp > $1.timestamp }
    }
}

// MARK: - Supporting Views

struct InsightTimelineCard: View {
    let insight: PersonalizedInsight
    let isFirst: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Timeline indicator
                VStack {
                    Circle()
                        .fill(isFirst ? Color.yellow : Color.white.opacity(0.6))
                        .frame(width: 12, height: 12)
                    
                    if !isFirst {
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 2, height: 40)
                    }
                }
                
                // Card content
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(insight.formattedDate)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Spacer()
                        
                        if isFirst {
                            Text("TODAY")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.yellow.opacity(0.2))
                                .foregroundColor(.yellow)
                                .cornerRadius(8)
                        }
                    }
                    
                    Text(insight.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    Text(insight.preview)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        ForEach(insight.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.purple.opacity(0.3))
                                .foregroundColor(.white.opacity(0.9))
                                .cornerRadius(4)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
                .padding(.leading, 4)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct InsightDetailView: View {
    let insight: PersonalizedInsight
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 12) {
                        Text(insight.formattedDate)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text(insight.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    // Content
                    Text(insight.content)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .lineSpacing(6)
                    
                    // Tags
                    if !insight.tags.isEmpty {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                            ForEach(insight.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.purple.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding(20)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black,
                        Color.purple.opacity(0.8),
                        Color.blue.opacity(0.6)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all)
            )
            .navigationTitle("Insight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    InsightHistoryView()
} 