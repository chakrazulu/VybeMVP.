import SwiftUI
import Charts

struct MatchAnalyticsView: View {
    @ObservedObject var focusNumberManager: FocusNumberManager
    @State private var selectedTimeFrame: TimeFrame = .day
    
    init(focusNumberManager: FocusNumberManager = FocusNumberManager()) {
        self.focusNumberManager = focusNumberManager
    }
    
    enum TimeFrame: String, CaseIterable {
        case day = "24 Hours"
        case week = "Week"
        case month = "Month"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Time Frame Selector
                    Picker("Time Frame", selection: $selectedTimeFrame) {
                        ForEach(TimeFrame.allCases, id: \.self) { timeFrame in
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
                                   value: "\(getTodayMatchCount())",
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
                            Chart(getMatchData()) { matchData in
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
                                     value: getMostCommonFocusNumber())
                            PatternRow(title: "Peak Match Time",
                                     value: getPeakMatchTime())
                            PatternRow(title: "Match Frequency",
                                     value: getMatchFrequency())
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
        }
    }
    
    // Helper functions for analytics
    func getTodayMatchCount() -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let count = focusNumberManager.matchLogs.filter { match in
            calendar.isDate(match.timestamp, inSameDayAs: today)
        }.count
        return String(count)
    }
    
    func getMostCommonFocusNumber() -> String {
        let numberCounts: [Int: Int] = focusNumberManager.matchLogs.reduce(into: [:]) { counts, match in
            counts[Int(match.chosenNumber), default: 0] += 1
        }
        
        if let (number, count) = numberCounts.max(by: { $0.value < $1.value }) {
            return "\(number) (\(count) times)"
        }
        
        return "No matches yet"
    }
    
    func getPeakMatchTime() -> String {
        let calendar = Calendar.current
        let hourCounts: [Int: Int] = focusNumberManager.matchLogs.reduce(into: [:]) { counts, match in
            let hour = calendar.component(.hour, from: match.timestamp)
            counts[hour, default: 0] += 1
        }
        
        if let (hour, _) = hourCounts.max(by: { $0.value < $1.value }) {
            let hourString = hour == 0 ? "12 AM" : 
                            hour < 12 ? "\(hour) AM" : 
                            hour == 12 ? "12 PM" : 
                            "\(hour-12) PM"
            return hourString
        }
        
        return "Not enough data"
    }
    
    func getMatchFrequency() -> String {
        guard focusNumberManager.matchLogs.count > 1 else { return "Not enough data" }
        
        let sortedMatches = focusNumberManager.matchLogs.sorted { $0.timestamp < $1.timestamp }
        guard let firstMatch = sortedMatches.first?.timestamp,
              let lastMatch = sortedMatches.last?.timestamp else {
            return "Calculating..."
        }
        
        let totalHours = lastMatch.timeIntervalSince(firstMatch) / 3600
        let intervals = Double(sortedMatches.count - 1) // Number of gaps between matches
        
        guard intervals > 0 else { return "Just started" }
        
        let hoursPerMatch = totalHours / intervals
        
        if hoursPerMatch < 1 {
            let minutesPerMatch = hoursPerMatch * 60
            return "Every \(Int(round(minutesPerMatch))) minutes"
        } else {
            return String(format: "Every %.1f hours", hoursPerMatch)
        }
    }
    
    private func getMatchData() -> [MatchData] {
        let calendar = Calendar.current
        var timeSlots: [MatchData] = []
        
        switch selectedTimeFrame {
        case .day:
            // Create 6-hour slots for the day
            let slots = ["12 AM", "6 AM", "12 PM", "6 PM"]
            let now = Date()
            let dayStart = calendar.startOfDay(for: now)
            
            for (index, slot) in slots.enumerated() {
                let slotStart = calendar.date(byAdding: .hour, value: index * 6, to: dayStart)!
                let slotEnd = calendar.date(byAdding: .hour, value: 6, to: slotStart)!
                
                let count = focusNumberManager.matchLogs.filter { match in
                    match.timestamp >= slotStart && match.timestamp < slotEnd
                }.count
                
                timeSlots.append(MatchData(time: slot, count: count))
            }
            
        case .week:
            // Create daily slots for the week
            let weekStart = calendar.date(byAdding: .day, value: -6, to: Date())!
            for dayOffset in 0...6 {
                let dayDate = calendar.date(byAdding: .day, value: dayOffset, to: weekStart)!
                let dayString = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: dayDate) - 1]
                
                let nextDay = calendar.date(byAdding: .day, value: 1, to: dayDate)!
                let count = focusNumberManager.matchLogs.filter { match in
                    match.timestamp >= dayDate && match.timestamp < nextDay
                }.count
                
                timeSlots.append(MatchData(time: dayString, count: count))
            }
            
        case .month:
            // Create weekly slots for the month
            let monthStart = calendar.date(byAdding: .day, value: -30, to: Date())!
            for weekOffset in 0...4 {
                let weekStart = calendar.date(byAdding: .day, value: weekOffset * 7, to: monthStart)!
                let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart)!
                
                let count = focusNumberManager.matchLogs.filter { match in
                    match.timestamp >= weekStart && match.timestamp < weekEnd
                }.count
                
                timeSlots.append(MatchData(time: "Week \(weekOffset + 1)", count: count))
            }
        }
        
        return timeSlots
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
        .environmentObject(FocusNumberManager())
} 