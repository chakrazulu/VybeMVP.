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
        
        let firstMatch = matchLogs.last!.timestamp
        let lastMatch = matchLogs.first!.timestamp
        
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
     *   - hours: Number of hours to add (negative for past times)
     *   - date: Base date to add hours to
     * - Returns: New date with hours added
     */
    private func addHours(_ hours: Int, to date: Date) -> Date {
        Calendar.current.date(byAdding: .hour, value: hours, to: date) ?? date
    }
}

/**
 * Data model for match distribution chart entries.
 *
 * This struct represents a single data point for charts, containing:
 * - A time label (varies based on the selected time frame)
 * - A count of matches in that time period
 */
struct MatchData: Identifiable {
    /// Unique identifier for SwiftUI List/ForEach
    var id = UUID()
    
    /// Time label (e.g., "12 PM", "Mon", "Week 2")
    var time: String
    
    /// Number of matches in this time slot
    var count: Int
}

/**
 * View that displays analytics for focus number matches.
 *
 * This view displays several visualizations and statistics:
 * 1. Heart rate data and analytics
 * 2. Match count statistics
 * 3. Match distribution charts
 * 4. Pattern analysis
 *
 * It allows filtering data by different time frames (day, week, month)
 * and automatically updates when new match data is available.
 */
struct MatchAnalyticsView: View {
    /// Access to the focus number manager for match data
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    
    /// Core Data context for database operations
    @Environment(\.managedObjectContext) private var viewContext
    
    /// Access to heart rate data for analytics
    @StateObject private var healthKitManager = HealthKitManager.shared
    
    /// View model containing analytics calculation logic
    @StateObject private var viewModel = MatchAnalyticsViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Heart Rate Analytics Card
                    cardHeart
                    
                    // Time Frame Selector
                    Picker("Time Frame", selection: $viewModel.selectedTimeFrame) {
                        ForEach(MatchAnalyticsViewModel.TimeFrame.allCases, id: \.self) { timeFrame in
                            Text(timeFrame.rawValue).tag(timeFrame)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    // Match Statistics Card
                    cardMatchStats
                    
                    // Match Distribution Chart
                    cardDistribution
                    
                    // Pattern Analysis Card
                    cardPatterns
                }
                .padding()
            }
            .navigationTitle("Match Analytics")
            .background(Color(.systemGroupedBackground))
            .onAppear {
                // Update the view model with the data from FocusNumberManager when the view appears
                viewModel.matchLogs = focusNumberManager.matchLogs
                viewModel.managedObjectContext = viewContext
            }
            .onChange(of: focusNumberManager.matchLogs) { oldValue, newValue in
                viewModel.matchLogs = newValue
            }
        }
    }
    
    // MARK: - Card Components
    
    /// Heart rate analytics component
    private var cardHeart: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Heart Rate Analytics")
                .font(.headline)
                .padding(.horizontal)
            
            HeartRateView()
                .frame(height: 200)
                .padding(.horizontal)
            
            if healthKitManager.authorizationStatus == .sharingAuthorized {
                heartRateStats
            }
        }
        .padding(.vertical)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    /// Heart rate statistics (BPM values)
    private var heartRateStats: some View {
        HStack {
            // Current BPM
            let currentRate = String(healthKitManager.currentHeartRate)
            StatCard(
                icon: "heart.fill",
                title: "Current BPM",
                value: currentRate
            )
            
            // Last valid BPM
            let lastRate = String(healthKitManager.lastValidBPM)
            StatCard(
                icon: "heart.circle.fill",
                title: "Last Valid BPM",
                value: lastRate
            )
        }
        .padding(.horizontal)
    }
    
    /// Match statistics card
    private var cardMatchStats: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Match Statistics")
                .font(.headline)
                .padding(.horizontal)
            
            HStack {
                // Total matches
                let totalCount = String(focusNumberManager.matchLogs.count)
                StatCard(
                    icon: "checkmark.circle.fill",
                    title: "Total Matches", 
                    value: totalCount
                )
                
                // Today's matches
                let todayCount = viewModel.getTodayMatchCount()
                StatCard(
                    icon: "clock.fill",
                    title: "Today's Matches",
                    value: todayCount
                )
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    /// Match distribution chart card
    private var cardDistribution: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Match Distribution")
                .font(.headline)
                .padding(.horizontal)
            
            if #available(iOS 16.0, *) {
                let matchData = viewModel.getMatchData()
                Chart(matchData) { matchData in
                    BarMark(
                        x: .value("Time", matchData.time),
                        y: .value("Matches", matchData.count)
                    )
                    .foregroundStyle(Color.blue.gradient)
                }
                .frame(height: 200)
                .padding()
            } else {
                Text("Charts require iOS 16.0 or later")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .padding(.vertical)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    /// Pattern analysis card
    private var cardPatterns: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Pattern Analysis")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                // Most common focus number
                let commonNumber = viewModel.getMostCommonFocusNumber()
                PatternRow(
                    title: "Most Common Focus Number",
                    value: commonNumber
                )
                
                // Peak match time
                let peakTime = viewModel.getPeakMatchTime()
                PatternRow(
                    title: "Peak Match Time",
                    value: peakTime
                )
                
                // Match frequency
                let frequency = viewModel.getMatchFrequency()
                PatternRow(
                    title: "Match Frequency",
                    value: frequency
                )
            }
            .padding()
        }
        .padding(.vertical)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

/**
 * Component for displaying a statistical metric with title and icon.
 *
 * This reusable card component displays:
 * - An icon representing the statistic
 * - A title describing what the statistic measures
 * - The value of the statistic
 * 
 * Used throughout the analytics view to present various metrics consistently.
 */
struct StatCard: View {
    /// The Font Awesome icon name to display
    var icon: String
    
    /// Title describing what this statistic represents
    var title: String
    
    /// The actual statistic value to display
    var value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
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
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
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