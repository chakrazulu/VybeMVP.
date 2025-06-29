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

// MARK: - Import for Chart Support

// Import statement for the ChartTimeRange enum from the detail view
// This ensures compatibility between the data model and the UI
enum ChartTimeRange: String, CaseIterable {
    case oneDay = "1D"
    case sevenDays = "7D"
    case fourteenDays = "14D"
    case thirtyDays = "30D"
    
    var days: Int {
        switch self {
        case .oneDay: return 1
        case .sevenDays: return 7
        case .fourteenDays: return 14
        case .thirtyDays: return 30
        }
    }
    
    var title: String {
        switch self {
        case .oneDay: return "Today"
        case .sevenDays: return "This Week"
        case .fourteenDays: return "2 Weeks"
        case .thirtyDays: return "This Month"
        }
    }
}

// Supporting data structure for chart visualization
struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let number: Int
    let value: Int
    let isRuling: Bool
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
    private let historicalSamplesKey = "historicalRealmSamples"
    private let lastSampleKey = "lastRealmSampleTime"
    
    // Cache for historical data
    private var allSamples: [RealmSample] = []
    
    // PERFORMANCE: Cache for pattern calculations (expires after 5 minutes)
    private var patternCache: [String: (value: Double, timestamp: Date)] = [:]
    private let cacheExpiryInterval: TimeInterval = 300 // 5 minutes
    
    private init() {
        loadAllSamples()
        loadTodaySamples()
        calculateRulingNumber()
        
        // PERFORMANCE FIX: Start pattern pre-calculation immediately during app startup
        startEarlyPatternCalculation()
    }
    
    // GLOBAL EARLY PATTERN CALCULATION
    private func startEarlyPatternCalculation() {
        DispatchQueue.global(qos: .utility).async {
            // Wait a brief moment for app to fully initialize
            Thread.sleep(forTimeInterval: 2.0)
            
            print("🚀 GLOBAL EARLY PATTERN CALCULATION: Starting immediate background calculation...")
            
            // Calculate all patterns while user is still in onboarding/home
            let patterns = ["sevenDay", "goldenFlow", "fibonacciSpiral", "trinityFlow", "lunarSync"]
            
            for patternName in patterns {
                switch patternName {
                case "sevenDay":
                    let value = self.getSevenDayPattern()
                    print("✅ Early calculated 7-Day Harmony: \(Int(value * 100))%")
                case "goldenFlow":
                    let value = self.getGoldenRatioAlignment()
                    print("✅ Early calculated Golden Flow: \(Int(value * 100))%")
                case "fibonacciSpiral":
                    let value = self.getFibonacciPattern()
                    print("✅ Early calculated Fibonacci Spiral: \(Int(value * 100))%")
                case "trinityFlow":
                    let value = self.getTrinityPattern()
                    print("✅ Early calculated Trinity Flow: \(Int(value * 100))%")
                case "lunarSync":
                    let value = self.getLunarAlignment()
                    print("✅ Early calculated Lunar Sync: \(Int(value * 100))%")
                default:
                    break
                }
            }
            
            print("🚀 GLOBAL EARLY PATTERN CALCULATION: All patterns cached in advance!")
        }
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
        allSamples.append(sample)
        setLastSampleTime(now)
        saveSamples()
        calculateRulingNumber()
        
        print("📊 Recorded realm sample: \(realmDigit) (\(source.rawValue))")
    }
    
    /**
     * Load all samples from storage (up to 30 days)
     */
    private func loadAllSamples() {
        guard let data = userDefaults.data(forKey: historicalSamplesKey),
              let samples = try? JSONDecoder().decode([RealmSample].self, from: data) else {
            allSamples = []
            return
        }
        
        // Keep only last 30 days
        let calendar = Calendar.current
        let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        
        allSamples = samples.filter { $0.timestamp >= thirtyDaysAgo }
        print("📊 Loaded \(allSamples.count) historical samples")
    }
    
    /**
     * Get samples for today only
     */
    private func loadTodaySamples() {
        let calendar = Calendar.current
        let today = Date()
        
        todaySamples = allSamples.filter { sample in
            calendar.isDate(sample.timestamp, inSameDayAs: today)
        }
        
        print("📊 Loaded \(todaySamples.count) samples for today")
    }
    
    /**
     * Save all samples to UserDefaults
     */
    private func saveSamples() {
        // Save today's samples (legacy key for compatibility)
        if let data = try? JSONEncoder().encode(todaySamples) {
            userDefaults.set(data, forKey: samplesKey)
        }
        
        // Save all historical samples (new enhanced storage)
        if let data = try? JSONEncoder().encode(allSamples) {
            userDefaults.set(data, forKey: historicalSamplesKey)
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
    
    // MARK: - Enhanced Chart Data Methods
    
    /**
     * Get chart data for different time ranges
     */
    func getChartData(for timeRange: ChartTimeRange) -> [ChartDataPoint] {
        let calendar = Calendar.current
        let now = Date()
        let startDate = calendar.date(byAdding: .day, value: -timeRange.days, to: now) ?? now
        
        switch timeRange {
        case .oneDay:
            return getTodayChartData()
        case .sevenDays, .fourteenDays, .thirtyDays:
            return getHistoricalChartData(startDate: startDate, endDate: now)
        }
    }
    
    /**
     * Get today's chart data (hourly breakdown)
     */
    private func getTodayChartData() -> [ChartDataPoint] {
        var chartData: [ChartDataPoint] = []
        
        for number in 1...9 {
            let count = getCount(for: number)
            chartData.append(ChartDataPoint(
                date: Date(),
                number: number,
                value: count,
                isRuling: number == rulingNumber
            ))
        }
        
        return chartData
    }
    
    /**
     * Get historical chart data (daily ruling numbers)
     */
    private func getHistoricalChartData(startDate: Date, endDate: Date) -> [ChartDataPoint] {
        let calendar = Calendar.current
        var chartData: [ChartDataPoint] = []
        
        var currentDate = startDate
        var loopCount = 0
        let maxLoops = 31 // Safety limit for maximum days to prevent infinite loops
        
        while currentDate <= endDate && loopCount < maxLoops {
            let dayStart = calendar.startOfDay(for: currentDate)
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) ?? dayStart
            
            // Get samples for this day
            let daySamples = allSamples.filter { sample in
                sample.timestamp >= dayStart && sample.timestamp < dayEnd
            }
            
            // Calculate ruling number for this day
            if !daySamples.isEmpty {
                let dayHistogram = Array(repeating: 0, count: 9)
                var mutableHistogram = dayHistogram
                
                for sample in daySamples {
                    if sample.realmDigit >= 1 && sample.realmDigit <= 9 {
                        mutableHistogram[sample.realmDigit - 1] += 1
                    }
                }
                
                if let maxIndex = mutableHistogram.enumerated().max(by: { $0.element < $1.element })?.offset {
                    let dayRulingNumber = maxIndex + 1
                    let maxCount = mutableHistogram[maxIndex]
                    
                    chartData.append(ChartDataPoint(
                        date: currentDate,
                        number: dayRulingNumber,
                        value: maxCount,
                        isRuling: true
                    ))
                }
            }
            
            // Safety check for date advancement
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
            loopCount += 1
        }
        
        return chartData.sorted { $0.date < $1.date }
    }
    
    // MARK: - Sacred Pattern Analysis
    
    /**
     * PERFORMANCE: Check cache for pattern value
     */
    private func getCachedPatternValue(for key: String) -> Double? {
        guard let cached = patternCache[key] else { return nil }
        
        // Check if cache is still valid (5 minutes)
        if Date().timeIntervalSince(cached.timestamp) < cacheExpiryInterval {
            return cached.value
        } else {
            // Remove expired cache entry
            patternCache.removeValue(forKey: key)
            return nil
        }
    }
    
    /**
     * PERFORMANCE: Cache pattern value
     */
    private func cachePatternValue(_ value: Double, for key: String) {
        patternCache[key] = (value: value, timestamp: Date())
    }
    
    /**
     * Analyze seven-day spiritual completion pattern
     */
    func getSevenDayPattern() -> Double {
        let cacheKey = "sevenDayPattern"
        
        // Check cache first
        if let cachedValue = getCachedPatternValue(for: cacheKey) {
            return cachedValue
        }
        
        let calendar = Calendar.current
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let recentSamples = allSamples.filter { $0.timestamp >= sevenDaysAgo }
        
        guard !recentSamples.isEmpty else { 
            cachePatternValue(0.0, for: cacheKey)
            return 0.0 
        }
        
        // Check for number 7 (spiritual completion) frequency
        let sevenCount = recentSamples.filter { $0.realmDigit == 7 }.count
        let spiritualNumbers = recentSamples.filter { [3, 6, 7, 9].contains($0.realmDigit) }.count
        
        // Calculate spiritual completion ratio
        let spiritualRatio = Double(spiritualNumbers) / Double(recentSamples.count)
        let sevenRatio = Double(sevenCount) / Double(recentSamples.count)
        
        let result = min((spiritualRatio * 0.7) + (sevenRatio * 0.3), 1.0)
        cachePatternValue(result, for: cacheKey)
        return result
    }
    
    /**
     * Analyze golden ratio alignment (1.618 divine proportion)
     */
    func getGoldenRatioAlignment() -> Double {
        let cacheKey = "goldenRatioAlignment"
        
        // Check cache first
        if let cachedValue = getCachedPatternValue(for: cacheKey) {
            return cachedValue
        }
        
        let calendar = Calendar.current
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let recentSamples = allSamples.filter { $0.timestamp >= sevenDaysAgo }
        
        guard !recentSamples.isEmpty else { 
            cachePatternValue(0.0, for: cacheKey)
            return 0.0 
        }
        
        // Numbers that resonate with golden ratio: 1, 8 (infinity), 5 (pentagram)
        let goldenNumbers = recentSamples.filter { [1, 5, 8].contains($0.realmDigit) }.count
        
        // Check for Fibonacci sequence presence: 1, 1, 2, 3, 5, 8
        let fibonacciNumbers = recentSamples.filter { [1, 2, 3, 5, 8].contains($0.realmDigit) }.count
        
        let goldenRatio = Double(goldenNumbers) / Double(recentSamples.count)
        let fibonacciRatio = Double(fibonacciNumbers) / Double(recentSamples.count)
        
        let result = min((goldenRatio * 0.6) + (fibonacciRatio * 0.4), 1.0)
        cachePatternValue(result, for: cacheKey)
        return result
    }
    
    /**
     * Analyze lunar cycle alignment (28-day rhythm)
     */
    func getLunarAlignment() -> Double {
        let cacheKey = "lunarAlignment"
        
        // Check cache first
        if let cachedValue = getCachedPatternValue(for: cacheKey) {
            return cachedValue
        }
        
        let calendar = Calendar.current
        let twentyEightDaysAgo = calendar.date(byAdding: .day, value: -28, to: Date()) ?? Date()
        let lunarSamples = allSamples.filter { $0.timestamp >= twentyEightDaysAgo }
        
        guard !lunarSamples.isEmpty else { 
            cachePatternValue(0.0, for: cacheKey)
            return 0.0 
        }
        
        // Numbers associated with lunar energy: 2 (duality), 6 (harmony), 9 (completion)
        let lunarNumbers = lunarSamples.filter { [2, 6, 9].contains($0.realmDigit) }.count
        
        // Simplified cyclical pattern check (less expensive than original)
        let lunarRatio = Double(lunarNumbers) / Double(lunarSamples.count)
        
        let result = min(lunarRatio, 1.0)
        cachePatternValue(result, for: cacheKey)
        return result
    }
    
    /**
     * Analyze Tesla's 3-6-9 trinity pattern
     */
    func getTrinityPattern() -> Double {
        let cacheKey = "trinityPattern"
        
        // Check cache first
        if let cachedValue = getCachedPatternValue(for: cacheKey) {
            return cachedValue
        }
        
        let calendar = Calendar.current
        let fourteenDaysAgo = calendar.date(byAdding: .day, value: -14, to: Date()) ?? Date()
        let trinitySamples = allSamples.filter { $0.timestamp >= fourteenDaysAgo }
        
        guard !trinitySamples.isEmpty else { 
            cachePatternValue(0.0, for: cacheKey)
            return 0.0 
        }
        
        // Tesla's divine numbers: 3, 6, 9
        let trinityNumbers = trinitySamples.filter { [3, 6, 9].contains($0.realmDigit) }.count
        let trinityRatio = Double(trinityNumbers) / Double(trinitySamples.count)
        
        let result = min(trinityRatio, 1.0)
        cachePatternValue(result, for: cacheKey)
        return result
    }
    
    /**
     * Analyze Fibonacci sequence patterns in realm samples (SIMPLIFIED for performance)
     */
    func getFibonacciPattern() -> Double {
        let cacheKey = "fibonacciPattern"
        
        // Check cache first
        if let cachedValue = getCachedPatternValue(for: cacheKey) {
            return cachedValue
        }
        
        let calendar = Calendar.current
        let tenDaysAgo = calendar.date(byAdding: .day, value: -10, to: Date()) ?? Date()
        let fibonacciSamples = allSamples.filter { $0.timestamp >= tenDaysAgo }
        
        guard fibonacciSamples.count >= 3 else { 
            cachePatternValue(0.0, for: cacheKey)
            return 0.0 
        }
        
        // Fibonacci numbers within 1-9: 1, 1, 2, 3, 5, 8
        let fibonacciNumbers = fibonacciSamples.filter { [1, 2, 3, 5, 8].contains($0.realmDigit) }.count
        let fibonacciRatio = Double(fibonacciNumbers) / Double(fibonacciSamples.count)
        
        // SIMPLIFIED: Just check fibonacci number frequency (removed expensive sequence analysis)
        let result = min(fibonacciRatio, 1.0)
        cachePatternValue(result, for: cacheKey)
        return result
    }
    
    // MARK: - Insights and Analysis
    
    /**
     * Get trend analysis for different time ranges
     */
    func getTrendAnalysis(for timeRange: ChartTimeRange) -> String {
        let chartData = getChartData(for: timeRange)
        
        switch timeRange {
        case .oneDay:
            return getDailyTrendAnalysis()
        case .sevenDays:
            return getWeeklyTrendAnalysis(chartData)
        case .fourteenDays:
            return getBiWeeklyTrendAnalysis(chartData)
        case .thirtyDays:
            return getMonthlyTrendAnalysis(chartData)
        }
    }
    
    private func getDailyTrendAnalysis() -> String {
        guard !todaySamples.isEmpty else { return "Begin your cosmic journey by observing your realm numbers." }
        
        let predominantNumbers = getPredominantNumbers()
        
        if predominantNumbers.count == 1 {
            return "Strong \(predominantNumbers.first!) energy dominates today. Deep focus and singular purpose."
        } else if predominantNumbers.count <= 3 {
            return "Balanced energy flow between \(predominantNumbers.map(String.init).joined(separator: ", ")). Harmony in diversity."
        } else {
            return "Dynamic energy spectrum active. Multiple cosmic influences creating rich complexity."
        }
    }
    
    private func getWeeklyTrendAnalysis(_ chartData: [ChartDataPoint]) -> String {
        guard chartData.count >= 5 else { return "Building cosmic data patterns. Continue your mystical observations." }
        
        let recentData = Array(chartData.suffix(3))
        let earlierData = Array(chartData.prefix(3))
        
        let recentAvg = recentData.map { $0.number }.reduce(0, +) / recentData.count
        let earlierAvg = earlierData.map { $0.number }.reduce(0, +) / earlierData.count
        
        if recentAvg > earlierAvg {
            return "Ascending numerological energy. Movement toward higher consciousness and completion."
        } else if recentAvg < earlierAvg {
            return "Grounding into foundation energy. Return to core principles and new beginnings."
        } else {
            return "Stable cosmic rhythm established. Consistent energy flow supports sustained growth."
        }
    }
    
    private func getBiWeeklyTrendAnalysis(_ chartData: [ChartDataPoint]) -> String {
        guard chartData.count >= 10 else { return "Expanding cosmic awareness. Two-week patterns emerging." }
        
        let spiritualNumbers = chartData.filter { [3, 6, 7, 9].contains($0.number) }.count
        let materialNumbers = chartData.filter { [1, 4, 8].contains($0.number) }.count
        let dynamicNumbers = chartData.filter { [2, 5].contains($0.number) }.count
        
        if spiritualNumbers > materialNumbers && spiritualNumbers > dynamicNumbers {
            return "Spiritual awakening phase. Higher consciousness and mystical insights dominate."
        } else if materialNumbers > spiritualNumbers && materialNumbers > dynamicNumbers {
            return "Manifestation cycle active. Material realm focus and practical achievements."
        } else {
            return "Dynamic transformation period. Balance between spiritual and material realms."
        }
    }
    
    private func getMonthlyTrendAnalysis(_ chartData: [ChartDataPoint]) -> String {
        guard chartData.count >= 20 else { return "Monthly cosmic pattern developing. Sacred cycles emerging." }
        
        let sevenDayPattern = getSevenDayPattern()
        let goldenRatio = getGoldenRatioAlignment()
        let trinityPattern = getTrinityPattern()
        
        if sevenDayPattern > 0.7 {
            return "Sacred seven-day completion cycle mastered. Spiritual evolution accelerating."
        } else if goldenRatio > 0.6 {
            return "Divine proportion alignment achieved. Golden ratio harmony in cosmic flow."
        } else if trinityPattern > 0.5 {
            return "Tesla's 3-6-9 pattern activated. Universal energy keys unlocking."
        } else {
            return "Comprehensive cosmic exploration. All numerical energies integrating holistically."
        }
    }
    
    /**
     * Get sacred number insight based on current patterns
     */
    func getSacredNumberInsight() -> String {
        let currentRuling = rulingNumber
        
        switch currentRuling {
        case 1:
            return "Unity consciousness awakening. You are the alpha point of infinite potential."
        case 2:
            return "Sacred duality balance. Harmony emerges from embracing opposites."
        case 3:
            return "Trinity expression activating. Mind, body, spirit alignment accelerating."
        case 4:
            return "Foundation mastery anchored. Sacred geometry principles stabilizing your reality."
        case 5:
            return "Quintessential freedom flowing. Pentagram protection and adventure calling."
        case 6:
            return "Hexagonal harmony perfected. Flower of Life patterns beautifying existence."
        case 7:
            return "Mystical seven wisdom unlocked. Crown chakra illumination and spiritual mastery."
        case 8:
            return "Infinite abundance manifesting. Ouroboros cycle of eternal renewal completed."
        case 9:
            return "Universal completion achieved. Enneagram wisdom and humanitarian service awakened."
        default:
            return "Sacred numerical mysteries revealing themselves through your cosmic journey."
        }
    }
    
    // MARK: - Helper Methods
    
    private func getPredominantNumbers() -> [Int] {
        let threshold = max(1, todaySamples.count / 4) // At least 25% frequency
        
        return histogram.enumerated().compactMap { index, count in
            count >= threshold ? index + 1 : nil
        }
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
        loadAllSamples()
        loadTodaySamples()
        calculateRulingNumber()
    }
} 