/**
 * Filename: MatchAnalyticsView.swift
 * 
 * Purpose: Displays analytical information about a user's focus number matches,
 * providing insights into patterns, frequency, and distribution of matches.
 *
 * Key components:
 * - MatchAnalyticsViewModel: Contains logic for analytics calculations
 * - TimeFrame enum: Defines time periods for data analysis
 * - Various chart and statistics components
 * 
 * This view serves as the central analytics dashboard for the app,
 * helping users understand their match patterns and trends.
 */

import SwiftUI
import Charts
import CoreData

/**
 * View model that handles the analytics calculations for match data.
 *
 * This class processes the raw match data and provides derived metrics 
 * such as match counts, frequencies, and patterns. It encapsulates all
 * the business logic for analytics, keeping the view focused on presentation.
 *
 * Design pattern: MVVM (Model-View-ViewModel)
 * Dependencies: CoreData for match history access
 */
// Claude: SWIFT 6 COMPLIANCE - Added @MainActor for UI state management
@MainActor
class MatchAnalyticsViewModel: ObservableObject {
    /// The selected time range for analytics display
    @Published var selectedTimeFrame: TimeFrame = .day
    
    /// Collection of match records from Core Data
    var matchLogs: [FocusMatch] = []
    
    /// Managed object context for database operations
    var managedObjectContext: NSManagedObjectContext?
    
    /**
     * Time periods for filtering and grouping analytics data.
     *
     * These define the scope of analytics calculations and chart displays:
     * - day: Shows match data for the previous 24 hours
     * - week: Shows match data for the past week
     * - month: Shows match data for the past month
     */
    enum TimeFrame: String, CaseIterable {
        case day = "24 Hours"
        case week = "Week"
        case month = "Month"
    }
    
    /**
     * Counts matches that occurred today.
     *
     * This method:
     * 1. Gets the start of the current day
     * 2. Filters matches to only include those from today
     * 3. Returns the count as a formatted string
     *
     * - Returns: String representation of today's match count
     */
    func getTodayMatchCount() -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let count = matchLogs.filter { match in
            calendar.isDate(match.timestamp, inSameDayAs: today)
        }.count
        return String(count)
    }
    
    /**
     * Determines the most frequently matched focus number.
     *
     * This method:
     * 1. Groups matches by the chosen focus number
     * 2. Counts occurrences of each number
     * 3. Finds the number with the highest count
     * 4. Returns the number and count as a formatted string
     *
     * - Returns: String describing the most common focus number and its frequency
     */
    func getMostCommonFocusNumber() -> String {
        let matchCounts = Dictionary(grouping: matchLogs) { $0.chosenNumber }
            .mapValues { $0.count }
        
        if let maxCount = matchCounts.values.max(),
           let mostCommonNumber = matchCounts.first(where: { $0.value == maxCount })?.key {
            return "\(mostCommonNumber) (\(maxCount) times)"
        }
        
        return "No matches yet"
    }
    
    /**
     * Determines the most frequently matched realm number.
     *
     * REALM NUMBER ANALYTICS ENHANCEMENT:
     * This method provides insights into which spiritual states (realm numbers)
     * coincide most often with synchronicity events, enabling users to understand
     * optimal timing for spiritual practices and manifestation work.
     *
     * This method:
     * 1. Groups matches by the realm number active during the match
     * 2. Counts occurrences of each realm number  
     * 3. Finds the realm number with the highest count
     * 4. Returns the number and count as a formatted string
     *
     * - Returns: String describing the most common realm number and its frequency
     */
    func getMostCommonRealmNumber() -> String {
        let realmCounts = Dictionary(grouping: matchLogs) { $0.realmNumber }
            .mapValues { $0.count }
        
        if let maxCount = realmCounts.values.max(),
           let mostCommonRealm = realmCounts.first(where: { $0.value == maxCount })?.key {
            return "\(mostCommonRealm) (\(maxCount) times)"
        }
        
        return "No matches yet"
    }
    
    /**
     * Identifies the hour of day when matches most frequently occur.
     *
     * This method:
     * 1. Groups matches by the hour they occurred
     * 2. Counts matches in each hour
     * 3. Finds the hour with the highest count
     * 4. Returns the time as a formatted string (HH:MM)
     *
     * - Returns: String representation of the peak match time
     */
    func getPeakMatchTime() -> String {
        let calendar = Calendar.current
        let matchesByHour = Dictionary(grouping: matchLogs) { match in
            calendar.component(.hour, from: match.timestamp)
        }
        
        if let maxCount = matchesByHour.values.map({ $0.count }).max(),
           let peakHour = matchesByHour.first(where: { $0.value.count == maxCount })?.key {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let date = calendar.date(bySettingHour: peakHour, minute: 0, second: 0, of: Date()) ?? Date()
            return dateFormatter.string(from: date)
        }
        
        return "No matches yet"
    }
    
    /**
     * Calculates the average frequency of matches over time.
     *
     * This method:
     * 1. Determines the time span between first and last match
     * 2. Calculates the average matches per day
     * 3. Returns the frequency as a formatted string
     *
     * For matches all occurring today, returns a count instead of an average.
     *
     * - Returns: String representation of match frequency (per day)
     */
    func getMatchFrequency() -> String {
        let matchCount = matchLogs.count
        let calendar = Calendar.current
        
        if matchCount == 0 {
            return "No matches yet"
        }
        
        // Get the earliest and latest match timestamps
        guard !matchLogs.isEmpty else {
            return "No matches yet"
        }
        
        // Claude: DORMANT BUG FIX - Replace force unwraps with safe optional handling
        guard let firstMatch = matchLogs.last?.timestamp,
              let lastMatch = matchLogs.first?.timestamp else {
            return "No valid match data"
        }
        
        let daysBetween = calendar.dateComponents([.day], from: firstMatch, to: lastMatch).day ?? 0
        
        if daysBetween == 0 {
            return "\(matchCount) today"
        } else {
            let average = Double(matchCount) / Double(daysBetween + 1)
            return String(format: "%.1f per day", average)
        }
    }
    
    /**
     * Generates data for match distribution charts.
     *
     * This method:
     * 1. Creates time slots based on the selected time frame (day, week, month)
     * 2. Counts matches in each time slot
     * 3. Returns an array of MatchData objects for display in charts
     *
     * The time slot granularity varies by time frame:
     * - Day: 6-hour slots
     * - Week: Daily slots
     * - Month: Weekly slots
     *
     * - Returns: Array of MatchData objects for chart rendering
     */
    func getMatchData() -> [MatchData] {
        let calendar = Calendar.current
        var timeSlots: [MatchData] = []
        let now = Date()
        
        switch selectedTimeFrame {
        case .day:
            // Create 6-hour slots for the day
            let slots = ["12 AM", "6 AM", "12 PM", "6 PM"]
            let dayStart = calendar.startOfDay(for: now)
            
            for (index, slot) in slots.enumerated() {
                let slotStart = addHours(index * 6, to: dayStart)
                let slotEnd = addHours(6, to: slotStart)
                
                let count = matchLogs.filter { match in
                    match.timestamp >= slotStart && match.timestamp < slotEnd
                }.count
                
                timeSlots.append(MatchData(time: slot, count: count))
            }
            
        case .week:
            // Create daily slots for the week
            let weekStart = addDays(-6, to: now)
            
            for dayOffset in 0...6 {
                let dayDate = addDays(dayOffset, to: weekStart)
                let nextDay = addDays(1, to: dayDate)
                let dayString = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: dayDate) - 1]
                
                let count = matchLogs.filter { match in
                    match.timestamp >= dayDate && match.timestamp < nextDay
                }.count
                
                timeSlots.append(MatchData(time: dayString, count: count))
            }
            
        case .month:
            // Create weekly slots for the month
            let monthStart = addDays(-30, to: now)
            
            for weekOffset in 0...4 {
                let weekStart = addDays(weekOffset * 7, to: monthStart)
                let weekEnd = addDays(7, to: weekStart)
                
                let count = matchLogs.filter { match in
                    match.timestamp >= weekStart && match.timestamp < weekEnd
                }.count
                
                timeSlots.append(MatchData(time: "Week \(weekOffset + 1)", count: count))
            }
        }
        
        return timeSlots
    }
    
    // Helper functions for date calculations
    /**
     * Adds a specified number of days to a date.
     *
     * - Parameters:
     *   - days: Number of days to add (negative for past dates)
     *   - date: Base date to add days to
     * - Returns: New date with days added
     */
    private func addDays(_ days: Int, to date: Date) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: date) ?? date
    }
    
    /**
     * Adds a specified number of hours to a date.
     *
     * - Parameters:
     *   - hours: Number of hours to add
     *   - date: Base date to add hours to
     * - Returns: New date with hours added
     */
    private func addHours(_ hours: Int, to date: Date) -> Date {
        Calendar.current.date(byAdding: .hour, value: hours, to: date) ?? date
    }
}

/**
 * Data structure for representing time-based match counts.
 *
 * This struct encapsulates a time period (as a string) and the number of matches
 * that occurred during that period. Used for chart data generation.
 */
struct MatchData: Identifiable {
    /// Unique identifier for this data point
    let id = UUID()
    
    /// String representation of the time period (e.g., "12 AM", "Monday", "Week 1")
    let time: String
    
    /// Number of matches that occurred during this time period
    let count: Int
}

/**
 * Enhanced data structure for representing time-based match counts with realm and focus numbers.
 *
 * This struct extends MatchData to include realm and focus number tracking for better analytics.
 */
struct EnhancedMatchData: Identifiable {
    /// Unique identifier for this data point
    let id = UUID()
    
    /// String representation of the time period
    let time: String
    
    /// Number of matches that occurred during this time period
    let count: Int
    
    /// Current realm number at this time
    let realmNumber: Int
    
    /// Current focus number at this time
    let focusNumber: Int
}

/**
 * Main analytics view displaying match data insights.
 *
 * This view presents a comprehensive dashboard of analytics including:
 * - Summary statistics (total matches, today's matches)
 * - Time-based distribution charts
 * - Pattern analysis (most common numbers, peak times, frequency)
 *
 * The view uses cards to organize information and provides time frame selection
 * to adjust the scope of the analytics display.
 */
struct MatchAnalyticsView: View {
    /// Access to the focus number manager for match data
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    
    /// Access to realm number manager for current realm number
    @EnvironmentObject var realmNumberManager: RealmNumberManager
    
    /// View model containing analytics logic
    @StateObject private var viewModel = MatchAnalyticsViewModel()
    
    /// UI state for chart series toggles
    @State private var showRealmNumbers = true
    @State private var showFocusNumbers = true
    
    var body: some View {
        NavigationView {
            ZStack {
                // Cosmic Background
                ScrollSafeCosmicView {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            // Time frame selector
                            timeFrameSelector
                            
                            // Summary statistics
                            cardSummary
                            
                            // Chart controls
                            chartControls
                            
                            // Match distribution chart
                            cardDistribution
                            
                            // Pattern analysis
                            cardPatterns
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Analytics")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                viewModel.matchLogs = focusNumberManager.matchLogs
            }
        }
    }
    
    /// Segmented control for selecting the analytics time frame
    private var timeFrameSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Time Frame")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            Picker(selection: $viewModel.selectedTimeFrame, label: Text("Time Frame")) {
                ForEach(MatchAnalyticsViewModel.TimeFrame.allCases, id: \.self) { timeFrame in
                    Text(timeFrame.rawValue).tag(timeFrame)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    /// Summary statistics card with cosmic neon glow effects
    /// 
    /// PHASE 3C-1 ENHANCEMENT: Added neon glow effects for floating space appearance
    /// - Multi-layer shadow system (cyan, purple, blue)
    /// - Gradient stroke borders for cosmic aesthetic
    /// - Enhanced visual hierarchy with "Cosmic Insights" title
    private var cardSummary: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Cosmic Insights")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            LazyHGrid(rows: [GridItem(.flexible())], spacing: 16) {
                Group {
                    HStack(spacing: 12) {
                        // Total matches
                        let totalCount = String(focusNumberManager.matchLogs.count)
                        CosmicStatCard(
                            title: "Total Matches",
                            value: totalCount,
                            icon: "checkmark.circle.fill",
                            color: .purple
                        )
                        .layoutPriority(1)
                        
                        // Today's matches
                        let todayCount = viewModel.getTodayMatchCount()
                        CosmicStatCard(
                            title: "Today's Matches",
                            value: todayCount,
                            icon: "clock.fill",
                            color: .cyan
                        )
                        .layoutPriority(1)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
        }
        .padding(.vertical)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.cyan.opacity(0.8),
                                    Color.purple.opacity(0.6),
                                    Color.blue.opacity(0.4)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                // PHASE 3C-1 ENHANCEMENT: Multi-layer shadow system for neon glow effect
                // Creates "floating in space" appearance with cosmic energy
                .shadow(color: .cyan.opacity(0.5), radius: 10, x: 0, y: 0)    // Inner glow
                .shadow(color: .purple.opacity(0.3), radius: 18, x: 0, y: 0)  // Outer glow
        )
    }
    
    /// Match distribution chart card with enhanced cosmic neon glow effects
    /// 
    /// PHASE 3C-1 ENHANCEMENT: "Today's Pattern" with neon glow effects
    /// - Triple-layer shadow system (purple, blue, cyan) for floating appearance
    /// - Gradient stroke borders with cosmic color progression
    /// - Enhanced container theming for "floating in space" effect
    /// - Renamed to "Today's Pattern" for better user comprehension
    private var cardDistribution: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Today's Pattern")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            if #available(iOS 16.0, *) {
                let matchData = viewModel.getMatchData()
                let enhancedData = enhanceMatchData(matchData)
                
                Chart(enhancedData) { data in
                    // Realm Numbers Line
                    if showRealmNumbers {
                        createRealmLineMark(data: data)
                    }
                    
                    // Focus Numbers Line  
                    if showFocusNumbers {
                        createFocusLineMark(data: data)
                    }
                }
                .frame(height: 200)
                .padding()
                .chartYScale(domain: 1...9) // Realm/Focus numbers are 1-9
                .chartXAxis {
                    AxisMarks { _ in
                        AxisValueLabel()
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
                .chartYAxis {
                    AxisMarks { _ in
                        AxisValueLabel()
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
            } else {
                Text("Charts require iOS 16.0 or later")
                    .foregroundColor(.white.opacity(0.7))
                    .padding()
            }
        }
        .padding(.vertical)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.purple.opacity(0.8),
                                    Color.blue.opacity(0.6),
                                    Color.cyan.opacity(0.4)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                // PHASE 3C-1 ENHANCEMENT: Triple-layer shadow system for maximum neon glow
                // Creates most prominent "floating in space" effect for primary chart
                .shadow(color: .purple.opacity(0.6), radius: 12, x: 0, y: 0)  // Inner glow
                .shadow(color: .blue.opacity(0.4), radius: 20, x: 0, y: 0)    // Mid glow  
                .shadow(color: .cyan.opacity(0.3), radius: 28, x: 0, y: 0)    // Outer glow
        )
    }
    
    /// Pattern analysis card with cosmic neon glow effects
    /// 
    /// PHASE 3C-1 ENHANCEMENT: "Sacred Patterns" with neon glow effects
    /// - Dual-layer shadow system (yellow, orange) for warm cosmic glow
    /// - Gradient stroke borders with sacred color progression
    /// - Enhanced spiritual terminology with "Sacred Patterns" title
    /// - Consistent floating space aesthetic across all analytics cards
    private var cardPatterns: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Sacred Patterns")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 16) {
                // Most common focus number
                let commonNumber = viewModel.getMostCommonFocusNumber()
                CosmicPatternRow(
                    title: "Most Common Focus Number",
                    value: commonNumber,
                    icon: "number.circle.fill",
                    color: .cyan
                )
                
                Divider()
                    .background(Color.white.opacity(0.2))
                
                // REALM NUMBER ANALYTICS ENHANCEMENT: Most common realm number
                let commonRealm = viewModel.getMostCommonRealmNumber()
                CosmicPatternRow(
                    title: "Most Common Realm Number",
                    value: commonRealm,
                    icon: "crown.circle.fill",
                    color: .purple
                )
                
                Divider()
                    .background(Color.white.opacity(0.2))
                
                // Peak match time
                let peakTime = viewModel.getPeakMatchTime()
                CosmicPatternRow(
                    title: "Peak Match Time",
                    value: peakTime,
                    icon: "clock.circle.fill",
                    color: .yellow
                )
                
                Divider()
                    .background(Color.white.opacity(0.2))
                
                // Match frequency
                let frequency = viewModel.getMatchFrequency()
                CosmicPatternRow(
                    title: "Match Frequency",
                    value: frequency,
                    icon: "chart.line.uptrend.xyaxis.circle.fill",
                    color: .purple
                )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .padding(.vertical)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.yellow.opacity(0.8),
                                    Color.orange.opacity(0.6),
                                    Color.purple.opacity(0.4)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                // PHASE 3C-1 ENHANCEMENT: Dual-layer shadow system for warm cosmic glow
                // Creates sacred energy appearance with warm color palette
                .shadow(color: .yellow.opacity(0.4), radius: 10, x: 0, y: 0)   // Inner warm glow
                .shadow(color: .orange.opacity(0.3), radius: 16, x: 0, y: 0)   // Outer warm glow
        )
    }
}

/**
 * Component for displaying pattern analysis data.
 *
 * This row displays information about patterns in the match data, such as:
 * - Time-based patterns (hour of day, day of week)
 * - Match frequency information
 * - Common focus numbers
 */
struct PatternRow: View {
    /// Title describing what pattern this row analyzes
    var title: String
    
    /// The pattern value or result to display
    var value: String
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        VStack(alignment: .leading, spacing: dynamicTypeSize.isAccessibilitySize ? 8 : 4) {
            Text(title)
                .foregroundColor(.secondary)
                .font(.subheadline)
                .lineLimit(dynamicTypeSize.isAccessibilitySize ? nil : 2)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(value)
                .fontWeight(.medium)
                .lineLimit(dynamicTypeSize.isAccessibilitySize ? nil : 2)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading, dynamicTypeSize.isAccessibilitySize ? 12 : 8)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, dynamicTypeSize.isAccessibilitySize ? 12 : 6)
    }
}

// MARK: - Cosmic-Themed Components

/**
 * Cosmic-themed stat card for analytics display.
 *
 * This component displays statistics with Vybe's cosmic aesthetic,
 * featuring purple/blue gradients and cosmic styling.
 */
struct CosmicStatCard: View {
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
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

/**
 * Cosmic-themed pattern row for analytics display.
 *
 * This component displays pattern analysis with cosmic styling and icons.
 */
struct CosmicPatternRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                
                Text(value)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Chart Controls Extension

extension MatchAnalyticsView {
    /// Realm number button background
    var realmNumberButtonBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(showRealmNumbers ? Color.purple.opacity(0.2) : Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(showRealmNumbers ? Color.purple.opacity(0.5) : Color.white.opacity(0.2), lineWidth: 1)
            )
    }
    
    /// Focus number button background
    var focusNumberButtonBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(showFocusNumbers ? Color.cyan.opacity(0.2) : Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(showFocusNumbers ? Color.cyan.opacity(0.5) : Color.white.opacity(0.2), lineWidth: 1)
            )
    }
    
    /// Chart controls for toggling series
    var chartControls: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Chart Series")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            HStack(spacing: 16) {
                // Realm Numbers Toggle
                Button(action: {
                    showRealmNumbers.toggle()
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                }) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(showRealmNumbers ? Color.purple : Color.gray)
                            .frame(width: 12, height: 12)
                        
                        Text("Realm Numbers")
                            .font(.subheadline)
                            .foregroundColor(showRealmNumbers ? .white : .white.opacity(0.6))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(realmNumberButtonBackground)
                }
                
                // Focus Numbers Toggle
                Button(action: {
                    showFocusNumbers.toggle()
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                }) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(showFocusNumbers ? Color.cyan : Color.gray)
                            .frame(width: 12, height: 12)
                        
                        Text("Focus Numbers")
                            .font(.subheadline)
                            .foregroundColor(showFocusNumbers ? .white : .white.opacity(0.6))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(focusNumberButtonBackground)
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    /// Enhance match data with realm and focus numbers
    func enhanceMatchData(_ matchData: [MatchData]) -> [EnhancedMatchData] {
        return matchData.map { data in
            EnhancedMatchData(
                time: data.time,
                count: data.count,
                realmNumber: realmNumberManager.currentRealmNumber,
                focusNumber: focusNumberManager.selectedFocusNumber
            )
        }
    }
    
    /// Create realm number line mark for chart
    @available(iOS 16.0, *)
    func createRealmLineMark(data: EnhancedMatchData) -> some ChartContent {
        LineMark(
            x: .value("Time", data.time),
            y: .value("Realm Number", data.realmNumber)
        )
        .foregroundStyle(Color.purple)
    }
    
    /// Create focus number line mark for chart
    @available(iOS 16.0, *)
    func createFocusLineMark(data: EnhancedMatchData) -> some ChartContent {
        LineMark(
            x: .value("Time", data.time),
            y: .value("Focus Number", data.focusNumber)
        )
        .foregroundStyle(Color.cyan)
    }
}

// Preview provider isn't necessary for runtime - comment out to reduce complexity
/*
#Preview {
    MatchAnalyticsView()
        .environmentObject(FocusNumberManager.shared)
        .environmentObject(RealmNumberManager())
}
*/ 