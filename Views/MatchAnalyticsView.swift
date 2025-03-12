import SwiftUI
import Charts
import CoreData

// New ViewModel to contain analytics logic
class MatchAnalyticsViewModel: ObservableObject {
    @Published var selectedTimeFrame: TimeFrame = .day
    var matchLogs: [FocusMatch] = []
    var managedObjectContext: NSManagedObjectContext?
    
    enum TimeFrame: String, CaseIterable {
        case day = "24 Hours"
        case week = "Week"
        case month = "Month"
    }
    
    // Helper functions for analytics
    func getTodayMatchCount() -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let count = matchLogs.filter { match in
            calendar.isDate(match.timestamp, inSameDayAs: today)
        }.count
        return String(count)
    }
    
    func getMostCommonFocusNumber() -> String {
        let matchCounts = Dictionary(grouping: matchLogs) { $0.chosenNumber }
            .mapValues { $0.count }
        
        if let maxCount = matchCounts.values.max(),
           let mostCommonNumber = matchCounts.first(where: { $0.value == maxCount })?.key {
            return "\(mostCommonNumber) (\(maxCount) times)"
        }
        
        return "No matches yet"
    }
    
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
    private func addDays(_ days: Int, to date: Date) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: date) ?? date
    }
    
    private func addHours(_ hours: Int, to date: Date) -> Date {
        Calendar.current.date(byAdding: .hour, value: hours, to: date) ?? date
    }
}

struct MatchAnalyticsView: View {
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var healthKitManager = HealthKitManager.shared
    @StateObject private var viewModel = MatchAnalyticsViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Heart Rate Analytics Card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Heart Rate Analytics")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HeartRateView()
                            .frame(height: 200)
                            .padding(.horizontal)
                        
                        if healthKitManager.authorizationStatus == .sharingAuthorized {
                            HStack {
                                StatCard(title: "Current BPM", 
                                       value: "\(healthKitManager.currentHeartRate)",
                                       icon: "heart.fill")
                                
                                StatCard(title: "Last Valid BPM",
                                       value: "\(healthKitManager.lastValidBPM)",
                                       icon: "heart.circle.fill")
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    
                    // Time Frame Selector
                    Picker("Time Frame", selection: $viewModel.selectedTimeFrame) {
                        ForEach(MatchAnalyticsViewModel.TimeFrame.allCases, id: \.self) { timeFrame in
                            Text(timeFrame.rawValue).tag(timeFrame)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    // Match Statistics Card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Match Statistics")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack {
                            StatCard(title: "Total Matches", 
                                   value: "\(focusNumberManager.matchLogs.count)",
                                   icon: "checkmark.circle.fill")
                            
                            StatCard(title: "Today's Matches",
                                   value: "\(viewModel.getTodayMatchCount())",
                                   icon: "clock.fill")
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    
                    // Match Distribution Chart
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Match Distribution")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if #available(iOS 16.0, *) {
                            Chart(viewModel.getMatchData()) { matchData in
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
                    
                    // Pattern Analysis Card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Pattern Analysis")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            PatternRow(title: "Most Common Focus Number",
                                     value: viewModel.getMostCommonFocusNumber())
                            PatternRow(title: "Peak Match Time",
                                     value: viewModel.getPeakMatchTime())
                            PatternRow(title: "Match Frequency",
                                     value: viewModel.getMatchFrequency())
                        }
                        .padding()
                    }
                    .padding(.vertical)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
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
        }
    }
}

// Supporting Views
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
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

struct PatternRow: View {
    let title: String
    let value: String
    
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

struct MatchData: Identifiable {
    let id = UUID()
    let time: String
    let count: Int
}

#Preview {
    MatchAnalyticsView()
        .environmentObject(FocusNumberManager.shared)
        .environmentObject(RealmNumberManager())
} 