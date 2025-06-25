/**
 * Filename: RealmSample.swift
 * 
 * Purpose: Data model for tracking realm number samples throughout the day
 * Used to calculate which number "ruled" the day for the ruling number chart feature
 */

import Foundation

/**
 * Represents a single sample of the realm number at a specific time
 */
struct RealmSample: Identifiable, Codable {
    let id = UUID()
    let realmDigit: Int
    let timestamp: Date
    let source: SampleSource
    
    enum SampleSource: String, Codable {
        case hourly = "hourly"
        case viewAppear = "view_appear"
        case manual = "manual"
        case background = "background"
    }
    
    // Exclude id from Codable since it's auto-generated
    enum CodingKeys: String, CodingKey {
        case realmDigit
        case timestamp
        case source
    }
}

/**
 * Manager for collecting and analyzing realm samples
 */
class RealmSampleManager: ObservableObject {
    static let shared = RealmSampleManager()
    
    @Published private(set) var todaySamples: [RealmSample] = []
    @Published private(set) var rulingNumber: Int = 1
    @Published private(set) var histogram: [Int] = Array(repeating: 0, count: 9)
    
    private let userDefaults = UserDefaults.standard
    private let samplesKey = "realmSamplesData"
    private let lastSampleKey = "lastRealmSampleTime"
    
    private init() {
        loadTodaySamples()
        calculateRulingNumber()
    }
    
    /**
     * Record a new realm sample
     */
    func recordSample(realmDigit: Int, source: RealmSample.SampleSource = .manual) {
        let now = Date()
        
        // Throttle samples - minimum 30 minutes between samples
        if let lastSample = getLastSampleTime(), 
           now.timeIntervalSince(lastSample) < 1800 { // 30 minutes
            return
        }
        
        let sample = RealmSample(
            realmDigit: realmDigit,
            timestamp: now,
            source: source
        )
        
        todaySamples.append(sample)
        setLastSampleTime(now)
        saveSamples()
        calculateRulingNumber()
        
        print("📊 Recorded realm sample: \(realmDigit) (\(source.rawValue))")
    }
    
    /**
     * Get samples for today only
     */
    private func loadTodaySamples() {
        guard let data = userDefaults.data(forKey: samplesKey),
              let allSamples = try? JSONDecoder().decode([RealmSample].self, from: data) else {
            todaySamples = []
            return
        }
        
        let calendar = Calendar.current
        let today = Date()
        
        todaySamples = allSamples.filter { sample in
            calendar.isDate(sample.timestamp, inSameDayAs: today)
        }
        
        print("📊 Loaded \(todaySamples.count) samples for today")
    }
    
    /**
     * Save samples to UserDefaults
     */
    private func saveSamples() {
        // Keep only last 7 days of samples
        let calendar = Calendar.current
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        
        let recentSamples = todaySamples.filter { $0.timestamp >= sevenDaysAgo }
        
        if let data = try? JSONEncoder().encode(recentSamples) {
            userDefaults.set(data, forKey: samplesKey)
        }
    }
    
    /**
     * Calculate the ruling number and histogram
     */
    private func calculateRulingNumber() {
        // Reset histogram
        histogram = Array(repeating: 0, count: 9)
        
        // Count occurrences of each number (1-9)
        for sample in todaySamples {
            if sample.realmDigit >= 1 && sample.realmDigit <= 9 {
                histogram[sample.realmDigit - 1] += 1
            }
        }
        
        // Find the ruling number (most frequent)
        if let maxIndex = histogram.enumerated().max(by: { $0.element < $1.element })?.offset {
            rulingNumber = maxIndex + 1
        } else {
            rulingNumber = 1 // Default if no samples
        }
        
        print("📊 Ruling number updated: \(rulingNumber) with \(histogram[rulingNumber - 1]) occurrences")
    }
    
    /**
     * Check if ruling number matches focus number and hasn't been awarded today
     */
    func checkForXPReward(focusNumber: Int) -> Bool {
        guard rulingNumber == focusNumber else { return false }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastAwardKey = "lastXPAward_\(calendar.dateInterval(of: .day, for: today)?.start.timeIntervalSince1970 ?? 0)"
        
        if userDefaults.bool(forKey: lastAwardKey) {
            return false // Already awarded today
        }
        
        // Award XP and mark as awarded
        userDefaults.set(true, forKey: lastAwardKey)
        return true
    }
    
    /**
     * Get count for a specific number
     */
    func getCount(for number: Int) -> Int {
        guard number >= 1 && number <= 9 else { return 0 }
        return histogram[number - 1]
    }
    
    /**
     * Get last sample time
     */
    private func getLastSampleTime() -> Date? {
        let timestamp = userDefaults.double(forKey: lastSampleKey)
        return timestamp > 0 ? Date(timeIntervalSince1970: timestamp) : nil
    }
    
    /**
     * Set last sample time
     */
    private func setLastSampleTime(_ date: Date) {
        userDefaults.set(date.timeIntervalSince1970, forKey: lastSampleKey)
    }
    
    /**
     * Force refresh (for testing)
     */
    func refreshData() {
        loadTodaySamples()
        calculateRulingNumber()
    }
} 