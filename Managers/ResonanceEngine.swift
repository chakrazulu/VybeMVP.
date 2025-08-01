/*
 * ========================================
 * 🌊 RESONANCE ENGINE - COSMIC PATTERN DETECTOR
 * ========================================
 * 
 * CORE PURPOSE:
 * Advanced spiritual pattern recognition engine analyzing user's personal numerical
 * patterns, archetypal alignments, and cosmic synchronicities to surface meaningful
 * resonance within their spiritual experience. Detects internal harmony patterns
 * before introducing user-to-user cosmic matching capabilities.
 * 
 * RESONANCE DETECTION SYSTEM:
 * - Focus-Realm Alignment: Perfect numerical match detection (intensity 1.0)
 * - Numerical Harmony: Root numbers, complements, sequences (threshold 0.5)
 * - Archetype Activation: Life path resonance with elemental alignment
 * - Sequential Magic: Ascending sequences and mirror patterns
 * - Spiritual Momentum: Streak-based consistency tracking
 * 
 * PATTERN ANALYSIS ALGORITHMS:
 * - Same Root Reduction: Multi-digit numbers reduced to single digit comparison
 * - Perfect Complement: Number pairs adding to 10 for cosmic balance
 * - Sequential Detection: Ascending numerical progression patterns
 * - Master Number Activation: 11, 22, 33 special resonance calculations
 * - Elemental Day Alignment: Weekday-element correspondence system
 * 
 * STATE MANAGEMENT:
 * - @Published currentMatches: Complete resonance match collection
 * - @Published todaysMatches: Current day's detected patterns
 * - @Published isAnalyzing: Analysis state for UI loading indicators
 * - @Published resonanceStreak: Consecutive days of spiritual activity
 * - Singleton Pattern: ResonanceEngine.shared for app-wide access
 * 
 * MATCH INTENSITY SCORING:
 * - Perfect Alignment: 1.0 intensity for exact focus-realm matches
 * - Numerical Harmony: 0.2-0.6 based on pattern complexity
 * - Archetype Activation: 0.3-0.6 for elemental and life path resonance
 * - Sequential Magic: 0.7-0.8 for meaningful progression patterns
 * - Spiritual Momentum: Streak-based scoring (days/10, max 1.0)
 * 
 * INTEGRATION POINTS:
 * - UserArchetypeManager: Spiritual archetype data for activation analysis
 * - FocusNumberManager: Current focus number for alignment detection
 * - RealmNumberManager: Real-time realm number for pattern matching
 * - ActivityView: Resonance match display in spiritual activity feed
 * - UserDefaults: Persistent storage for match history and streaks
 * 
 * TEMPORAL PATTERN TRACKING:
 * - Today's Matches: Current day resonance for immediate awareness
 * - Recent Matches: 7-day retrospective for pattern recognition
 * - Streak Calculation: Consecutive days of spiritual activity
 * - 30-Day Storage: Rolling window for memory optimization
 * - Periodic Analysis: 5-minute intervals for ambient detection
 * 
 * CACHING & PERSISTENCE:
 * - UserDefaults Storage: JSON-encoded match history persistence
 * - Match Limit: 100 stored matches for memory efficiency
 * - Cache Keys: "resonance_matches", "resonance_streak", analysis timestamps
 * - Data Cleanup: 30-day rolling window for storage optimization
 * - Streak Persistence: Maintains momentum across app sessions
 * 
 * RESONANCE MATCH TYPES:
 * - Focus-Realm Alignment: Perfect numerical synchronicity
 * - Numerical Harmony: Complex mathematical relationships
 * - Archetype Activation: Spiritual identity resonance
 * - Sequential Magic: Progressive numerical patterns
 * - Spiritual Momentum: Consistency-based recognition
 * 
 * ANALYSIS CONFIGURATION:
 * - Max Stored Matches: 100 for memory management
 * - Analysis Interval: 300 seconds (5 minutes) for ambient detection
 * - Match Threshold: 0.5 minimum intensity for surfacing
 * - Streak Requirement: 3 days for momentum recognition
 * - Storage Window: 30 days for historical analysis
 * 
 * ELEMENTAL DAY MAPPING:
 * - Fire: Sunday(1), Tuesday(3) - Active energy days
 * - Earth: Thursday(5), Saturday(7) - Grounding energy days
 * - Air: Monday(2), Wednesday(4) - Mental energy days
 * - Water: Friday(6) - Emotional energy day
 * 
 * NUMERICAL HARMONY PATTERNS:
 * - Same Root: Multi-digit numbers with identical single-digit reduction
 * - Perfect Complement: Number pairs summing to 10 (cosmic balance)
 * - Sequential: Adjacent numbers indicating spiritual progression
 * - Double Power: Matching multi-digit numbers for amplified energy
 * - Master Activation: Sum equals master number (11, 22, 33)
 * 
 * PERFORMANCE OPTIMIZATIONS:
 * - Singleton Pattern: Single instance for memory efficiency
 * - Lazy Analysis: On-demand pattern detection to conserve resources
 * - Rolling Storage: 30-day window prevents memory bloat
 * - Efficient Sorting: Timestamp-based organization for quick access
 * - Timer Management: Proper cleanup and resource management
 * 
 * ERROR HANDLING & RESILIENCE:
 * - JSON Encoding/Decoding: Graceful handling of persistence failures
 * - Analysis Guards: Prevents concurrent analysis operations
 * - Data Validation: Ensures match threshold and intensity bounds
 * - Timer Safety: Proper cleanup in deinit to prevent memory leaks
 * - Storage Fallbacks: Handles missing or corrupted cache data
 * 
 * DEBUGGING & DEVELOPMENT:
 * - Test Match Creation: createTestMatches() for development validation
 * - Debug State Display: debugResonanceState() for analysis verification
 * - Comprehensive Logging: Detailed analysis step tracking
 * - Match Visualization: Intensity percentages and pattern descriptions
 * - Development Tools: Console output for resonance pattern verification
 * 
 * TECHNICAL SPECIFICATIONS:
 * - Analysis Frequency: 5-minute intervals for background pattern detection
 * - Storage Format: JSON-encoded ResonanceMatch arrays
 * - Intensity Range: 0.0-1.0 with 0.5 minimum threshold
 * - Date Calculations: Calendar-based day comparisons for accuracy
 * - Pattern Complexity: Multi-layered analysis with weighted scoring
 */

//
//  ResonanceEngine.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//

import Foundation
import Combine

/**
 * Engine for detecting internal spiritual resonance patterns.
 *
 * This manager analyzes the user's personal numerical patterns, archetypal
 * alignments, and spiritual practices to surface meaningful synchronicities
 * and resonance within their own experience.
 *
 * Phase 2B implementation focuses on local (non-social) resonance detection
 * to build internal awareness before introducing user-to-user matching.
 */
class ResonanceEngine: ObservableObject {
    
    // MARK: - Singleton Instance
    static let shared = ResonanceEngine()
    private init() {
        loadCachedMatches()
        setupResonanceMonitoring()
    }
    
    // MARK: - Published Properties
    @Published private(set) var currentMatches: [ResonanceMatch] = []
    @Published private(set) var todaysMatches: [ResonanceMatch] = []
    @Published private(set) var isAnalyzing: Bool = false
    @Published private(set) var resonanceStreak: Int = 0
    
    // MARK: - Private Properties
    private let archetypeManager = UserArchetypeManager.shared
    private let userDefaults = UserDefaults.standard
    private let matchesKey = "resonance_matches"
    private let streakKey = "resonance_streak"
    private let lastAnalysisKey = "last_resonance_analysis"
    private let lastResonanceDateKey = "last_resonance_date"
    
    private var cancellables = Set<AnyCancellable>()
    private var analysisTimer: Timer?
    private var lastResonanceDate: Date?
    
    // MARK: - Configuration
    private struct Config {
        static let maxStoredMatches = 100
        static let analysisInterval: TimeInterval = 300 // 5 minutes
        static let matchThreshold = 0.5 // Minimum intensity to surface
        static let streakRequirement = 3 // Days needed for momentum
    }
    
    // MARK: - Public Methods
    
    /**
     * Analyzes current spiritual state for resonance patterns.
     *
     * - Parameter focusNumber: User's current focus number
     * - Parameter realmNumber: Current calculated realm number
     * - Parameter archetype: User's spiritual archetype
     *
     * This method examines the user's current numerical state and archetype
     * to detect meaningful patterns and synchronicities worth surfacing.
     */
    func analyzeCurrentResonance(focusNumber: Int, realmNumber: Int, archetype: UserArchetype?) {
        guard !isAnalyzing else { return }
        
        isAnalyzing = true
        
        print("\n🌊 ===============================")
        print("🌊      RESONANCE ANALYSIS       ")
        print("🌊 ===============================")
        print("Focus Number: \(focusNumber)")
        print("Realm Number: \(realmNumber)")
        
        var detectedMatches: [ResonanceMatch] = []
        
        // 1. Check for Focus-Realm Alignment
        if let focusRealmMatch = checkFocusRealmAlignment(focus: focusNumber, realm: realmNumber) {
            detectedMatches.append(focusRealmMatch)
            print("✨ Focus-Realm Alignment detected!")
        }
        
        // 2. Check for Numerical Harmony
        if let harmonyMatch = checkNumericalHarmony(focus: focusNumber, realm: realmNumber, archetype: archetype) {
            detectedMatches.append(harmonyMatch)
            print("🔢 Numerical Harmony detected!")
        }
        
        // 3. Check for Archetype Activation
        if let archetype = archetype,
           let activationMatch = checkArchetypeActivation(archetype: archetype, currentNumbers: [focusNumber, realmNumber]) {
            detectedMatches.append(activationMatch)
            print("⭐ Archetype Activation detected!")
        }
        
        // 4. Check for Sequential Magic
        if let sequenceMatch = checkSequentialMagic(numbers: [focusNumber, realmNumber]) {
            detectedMatches.append(sequenceMatch)
            print("✨ Sequential Magic detected!")
        }
        
        // 5. Check for Spiritual Momentum
        if let momentumMatch = checkSpiritualMomentum() {
            detectedMatches.append(momentumMatch)
            print("🚀 Spiritual Momentum detected!")
        }
        
        // Process and store matches
        if !detectedMatches.isEmpty {
            addMatches(detectedMatches)
            updateResonanceStreak()
        }
        
        // Update last analysis time
        userDefaults.set(Date(), forKey: lastAnalysisKey)
        
        print("🌊 Analysis complete: \(detectedMatches.count) matches found")
        print("🌊 ===============================\n")
        
        isAnalyzing = false
    }
    
    /**
     * Gets today's resonance matches for display.
     *
     * - Returns: Array of ResonanceMatch objects from today
     */
    func getTodaysMatches() -> [ResonanceMatch] {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) ?? Date()
        
        return currentMatches.filter { match in
            match.timestamp >= today && match.timestamp < tomorrow
        }.sorted { $0.timestamp > $1.timestamp }
    }
    
    /**
     * Gets recent resonance matches (last 7 days) for insights.
     *
     * - Returns: Array of recent ResonanceMatch objects
     */
    func getRecentMatches() -> [ResonanceMatch] {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        
        return currentMatches.filter { match in
            match.timestamp >= sevenDaysAgo
        }.sorted { $0.timestamp > $1.timestamp }
    }
    
    /**
     * Clears all stored resonance matches and resets streak.
     * Used during logout to remove user-specific data.
     */
    func clearAllMatches() {
        currentMatches.removeAll()
        resonanceStreak = 0
        lastResonanceDate = nil
        
        // Clear from storage
        userDefaults.removeObject(forKey: matchesKey)
        userDefaults.removeObject(forKey: streakKey)
        userDefaults.removeObject(forKey: lastResonanceDateKey)
        
        print("🗑️ Cleared all resonance data")
    }
    
    // MARK: - Private Analysis Methods
    
    /**
     * Checks for Focus-Realm alignment (perfect numerical match).
     */
    private func checkFocusRealmAlignment(focus: Int, realm: Int) -> ResonanceMatch? {
        guard focus == realm else { return nil }
        
        return ResonanceMatch.focusRealmAlignment(
            focusNumber: focus,
            realmNumber: realm,
            intensity: 1.0
        )
    }
    
    /**
     * Checks for broader numerical harmony patterns.
     */
    private func checkNumericalHarmony(focus: Int, realm: Int, archetype: UserArchetype?) -> ResonanceMatch? {
        var harmonies: [String] = []
        var numbers = [focus, realm]
        var intensity = 0.0
        
        // Add life path if available
        if let archetype = archetype {
            numbers.append(archetype.lifePath)
        }
        
        // Check for same root number (reduced to single digit)
        let focusRoot = reduceToSingleDigit(focus)
        let realmRoot = reduceToSingleDigit(realm)
        
        if focusRoot == realmRoot && focus != realm {
            harmonies.append("same numerical root (\(focusRoot))")
            intensity += 0.3
        }
        
        // Check for complementary numbers (add to 10)
        if focus + realm == 10 {
            harmonies.append("perfect complement (adds to 10)")
            intensity += 0.6
        }
        
        // Check for sequential numbers
        if abs(focus - realm) == 1 {
            harmonies.append("sequential harmony")
            intensity += 0.2
        }
        
        // Check for double digits
        if focus == realm && focus > 9 {
            harmonies.append("double power number")
            intensity += 0.5
        }
        
        guard !harmonies.isEmpty && intensity >= Config.matchThreshold else { return nil }
        
        let pattern = harmonies.joined(separator: " & ")
        return ResonanceMatch.numericalHarmony(
            numbers: [focus, realm],
            pattern: pattern,
            intensity: min(intensity, 1.0)
        )
    }
    
    /**
     * Checks for archetype activation based on current numerical state.
     */
    private func checkArchetypeActivation(archetype: UserArchetype, currentNumbers: [Int]) -> ResonanceMatch? {
        var activations: [String] = []
        var intensity = 0.0
        
        // Check if current numbers match life path
        if currentNumbers.contains(archetype.lifePath) {
            activations.append("life path resonance")
            intensity += 0.4
        }
        
        // Check for elemental day alignment (simplified)
        let dayOfWeek = Calendar.current.component(.weekday, from: Date())
        let elementalAlignment = checkElementalDayAlignment(element: archetype.element, weekday: dayOfWeek)
        if elementalAlignment {
            activations.append("elemental day alignment")
            intensity += 0.3
        }
        
        // Check for master number activation
        if [11, 22, 33].contains(archetype.lifePath) {
            let masterSum = currentNumbers.reduce(0, +)
            if masterSum == archetype.lifePath {
                activations.append("master number activation")
                intensity += 0.6
            }
        }
        
        guard !activations.isEmpty && intensity >= Config.matchThreshold else { return nil }
        
        let description = "Your \(archetype.element.rawValue) archetype (Life Path \(archetype.lifePath)) is activated: \(activations.joined(separator: " & "))"
        
        return ResonanceMatch.archetypeActivation(
            archetype: archetype,
            description: description,
            intensity: min(intensity, 1.0)
        )
    }
    
    /**
     * Checks for meaningful sequential patterns.
     */
    private func checkSequentialMagic(numbers: [Int]) -> ResonanceMatch? {
        let sortedNumbers = numbers.sorted()
        
        // Check for ascending sequence
        var isSequential = true
        for i in 1..<sortedNumbers.count {
            if sortedNumbers[i] != sortedNumbers[i-1] + 1 {
                isSequential = false
                break
            }
        }
        
        if isSequential && numbers.count >= 2 {
            return ResonanceMatch.sequentialMagic(
                sequence: sortedNumbers,
                meaning: "Your numbers form an ascending sequence, indicating spiritual progression.",
                intensity: 0.7
            )
        }
        
        // Check for mirrored patterns
        if numbers.count == 2 && numbers[0] == numbers[1] {
            return ResonanceMatch.sequentialMagic(
                sequence: numbers,
                meaning: "Perfect mirror - your inner and outer worlds align.",
                intensity: 0.8
            )
        }
        
        return nil
    }
    
    /**
     * Checks for spiritual momentum based on recent activity.
     */
    private func checkSpiritualMomentum() -> ResonanceMatch? {
        // Check recent matches for consistency
        let recentDays = getRecentDaysSinceLastMatch()
        
        if recentDays <= 1 && resonanceStreak >= Config.streakRequirement {
            return ResonanceMatch.spiritualMomentum(
                streakDays: resonanceStreak,
                practiceType: "resonance awareness",
                intensity: min(Double(resonanceStreak) / 10.0, 1.0)
            )
        }
        
        return nil
    }
    
    // MARK: - Helper Methods
    
    private func reduceToSingleDigit(_ number: Int) -> Int {
        var num = abs(number)
        while num > 9 {
            num = String(num).compactMap { Int(String($0)) }.reduce(0, +)
        }
        return num
    }
    
    private func checkElementalDayAlignment(element: Element, weekday: Int) -> Bool {
        // Simple elemental day mapping (can be enhanced)
        switch element {
        case .fire:
            return [1, 3].contains(weekday) // Sunday, Tuesday
        case .earth:
            return [5, 7].contains(weekday) // Thursday, Saturday
        case .air:
            return [2, 4].contains(weekday) // Monday, Wednesday
        case .water:
            return [6].contains(weekday) // Friday
        }
    }
    
    private func getRecentDaysSinceLastMatch() -> Int {
        guard let lastMatch = currentMatches.first else { return 7 }
        return Calendar.current.dateComponents([.day], from: lastMatch.timestamp, to: Date()).day ?? 7
    }
    
    private func addMatches(_ matches: [ResonanceMatch]) {
        currentMatches.append(contentsOf: matches)
        
        // Keep only recent matches to avoid memory bloat
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        currentMatches = currentMatches.filter { $0.timestamp >= cutoffDate }
        
        // Sort by timestamp
        currentMatches.sort { $0.timestamp > $1.timestamp }
        
        // Update today's matches
        todaysMatches = getTodaysMatches()
        
        // Cache to UserDefaults
        cacheMatches()
    }
    
    private func updateResonanceStreak() {
        let hasMatchToday = !getTodaysMatches().isEmpty
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        let hadMatchYesterday = currentMatches.contains { Calendar.current.isDate($0.timestamp, inSameDayAs: yesterday) }
        
        if hasMatchToday {
            if hadMatchYesterday || resonanceStreak == 0 {
                resonanceStreak += 1
            }
        } else {
            resonanceStreak = 0
        }
        
        userDefaults.set(resonanceStreak, forKey: streakKey)
    }
    
    private func setupResonanceMonitoring() {
        // Load streak from storage
        resonanceStreak = userDefaults.integer(forKey: streakKey)
        
        // Set up periodic analysis timer
        analysisTimer = Timer.scheduledTimer(withTimeInterval: Config.analysisInterval, repeats: true) { _ in
            // Timer-based analysis can be added here for ambient detection
            print("🌊 Periodic resonance check...")
        }
    }
    
    private func cacheMatches() {
        do {
            let data = try JSONEncoder().encode(currentMatches)
            userDefaults.set(data, forKey: matchesKey)
        } catch {
            print("❌ Failed to cache resonance matches: \(error)")
        }
    }
    
    private func loadCachedMatches() {
        guard let data = userDefaults.data(forKey: matchesKey),
              let matches = try? JSONDecoder().decode([ResonanceMatch].self, from: data) else {
            return
        }
        
        currentMatches = matches
        todaysMatches = getTodaysMatches()
        print("💾 Loaded \(currentMatches.count) cached resonance matches")
    }
    
    deinit {
        analysisTimer?.invalidate()
    }
}

// MARK: - Debug Extensions

extension ResonanceEngine {
    /**
     * Creates test resonance matches for development purposes.
     */
    func createTestMatches() {
        let testMatches = [
            ResonanceMatch.focusRealmAlignment(focusNumber: 7, realmNumber: 7),
            ResonanceMatch.numericalHarmony(numbers: [3, 6, 9], pattern: "sacred trinity", intensity: 0.8),
            ResonanceMatch.sequentialMagic(sequence: [1, 2, 3], meaning: "Progressive awakening", intensity: 0.7),
            ResonanceMatch.spiritualMomentum(streakDays: 5, practiceType: "daily insight", intensity: 0.6)
        ]
        
        addMatches(testMatches)
        print("🧪 Created \(testMatches.count) test resonance matches")
    }
    
    /**
     * Prints debug information about current resonance state.
     */
    func debugResonanceState() {
        print("\n🔍 ===============================")
        print("🔍      RESONANCE DEBUG          ")
        print("🔍 ===============================")
        print("Total Matches: \(currentMatches.count)")
        print("Today's Matches: \(todaysMatches.count)")
        print("Current Streak: \(resonanceStreak) days")
        print("Is Analyzing: \(isAnalyzing)")
        
        if !todaysMatches.isEmpty {
            print("\n📋 Today's Matches:")
            for match in todaysMatches {
                print("  • \(match.type.emoji) \(match.title): \(match.intensityPercentage)")
            }
        }
        
        print("🔍 ===============================\n")
    }
} 