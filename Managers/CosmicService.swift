/*
 * ========================================
 * 🌌 COSMIC SERVICE - CELESTIAL DATA ORCHESTRATION
 * ========================================
 * 
 * CORE PURPOSE:
 * Central service managing all cosmic data operations including Firebase Firestore
 * integration, local calculation fallbacks, caching strategies, and real-time
 * celestial updates. Provides unified access to moon phases, planetary positions,
 * and astrological information throughout the app.
 * 
 * PHASE 10 INTEGRATION:
 * - Primary Component: Phase 10C iOS App Integration
 * - Singleton Pattern: Follows VybeMVP manager architecture
 * - Firebase Integration: Firestore cosmic data collection
 * - Offline Support: Local calculation fallback
 * 
 * ARCHITECTURE PATTERN:
 * - ObservableObject: SwiftUI state management
 * - @Published Properties: Reactive UI updates
 * - Combine Framework: Async data flow
 * - Error Handling: Comprehensive error management
 * 
 * INTEGRATION POINTS:
 * - VybeMVPApp: Initialize as @StateObject
 * - RealmNumberView: Display cosmic snapshot
 * - KASPERManager: Provide cosmic context
 * - NotificationManager: Cosmic event alerts
 * 
 * CACHING STRATEGY:
 * - Memory Cache: Current day's cosmic data
 * - UserDefaults: Persistent offline backup
 * - TTL: 24-hour cache validity
 * - Automatic Refresh: Daily at midnight
 * 
 * PERFORMANCE TARGETS:
 * - Local Calculation: < 10ms
 * - Firestore Fetch: < 500ms
 * - Cache Hit: 0ms
 * - Memory Overhead: < 1MB
 */

import Foundation
import FirebaseFirestore
import Combine
import os.log

/// Cosmic service managing celestial data and calculations
@MainActor
class CosmicService: ObservableObject {
    
    // MARK: - Singleton Instance
    static let shared = CosmicService()
    
    // MARK: - Published Properties
    
    /// Today's cosmic data (moon phase, planetary positions, etc.)
    @Published var todaysCosmic: CosmicData?
    
    /// Loading state for UI feedback
    @Published var isLoading = false
    
    /// Error message for user display
    @Published var errorMessage: String?
    
    /// Last successful update timestamp
    @Published var lastUpdated: Date?
    
    // MARK: - Private Properties
    
    /// Firestore database reference
    private let db = Firestore.firestore()
    
    /// Combine cancellables
    private var cancellables = Set<AnyCancellable>()
    
    /// Cache key for UserDefaults
    private let cacheKey = "com.vybemvp.cosmicData.cache"
    private let cacheTimestampKey = "com.vybemvp.cosmicData.timestamp"
    
    /// Logger for debugging
    private let logger = Logger(subsystem: "com.vybemvp", category: "CosmicService")
    
    /// Timer for automatic daily updates
    private var dailyUpdateTimer: Timer?
    
    // MARK: - Initialization
    
    private init() {
        logger.info("🌌 CosmicService initialized")
        
        // Load cached data on init
        loadCachedData()
        
        // Fetch fresh data
        Task {
            await fetchTodaysCosmicData()
        }
        
        // Schedule daily updates
        scheduleDailyUpdate()
        
        // Listen for app becoming active to refresh data
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                Task {
                    await self?.fetchTodaysCosmicData()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    
    /**
     * Fetch today's cosmic data from Firestore or calculate locally
     */
    func fetchTodaysCosmicData() async {
        logger.info("🌌 Fetching today's cosmic data")
        
        // Check cache first
        if let cached = todaysCosmic, cached.isToday {
            logger.info("🌌 Using cached cosmic data from today")
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // Try to fetch from Firestore
            let todayString = dateString(for: Date())
            let document = try await db.collection("cosmicData")
                .document(todayString)
                .getDocument()
            
            if document.exists {
                let cosmic = try document.data(as: CosmicData.self)
                logger.info("🌌 Successfully fetched cosmic data from Firestore")
                
                await MainActor.run {
                    self.todaysCosmic = cosmic
                    self.lastUpdated = Date()
                    self.cacheCosmicData(cosmic)
                    self.isLoading = false
                }
            } else {
                // Fallback to local calculations
                logger.info("🌌 No Firestore data, using local calculations")
                await useLocalCalculations()
            }
        } catch {
            logger.error("🌌 Error fetching cosmic data: \(error.localizedDescription)")
            errorMessage = "Unable to fetch cosmic data"
            
            // Fallback to local calculations
            await useLocalCalculations()
        }
    }
    
    /**
     * Force refresh cosmic data
     */
    func refreshCosmicData() async {
        logger.info("🌌 Force refreshing cosmic data")
        clearCache()
        await fetchTodaysCosmicData()
    }
    
    /**
     * Get cosmic data for a specific date (if available)
     */
    func cosmicData(for date: Date) async -> CosmicData? {
        let dateString = self.dateString(for: date)
        
        do {
            let document = try await db.collection("cosmicData")
                .document(dateString)
                .getDocument()
            
            if document.exists {
                return try document.data(as: CosmicData.self)
            }
        } catch {
            logger.error("🌌 Error fetching cosmic data for date \(dateString): \(error)")
        }
        
        // Fallback to local calculation for the date
        return CosmicData.fromLocalCalculations(for: date)
    }
    
    // MARK: - Private Methods
    
    /**
     * Use local calculations as fallback
     */
    private func useLocalCalculations() async {
        logger.info("🌌 Generating cosmic data from local calculations")
        
        let localCosmic = CosmicData.fromLocalCalculations()
        
        await MainActor.run {
            self.todaysCosmic = localCosmic
            self.lastUpdated = Date()
            self.cacheCosmicData(localCosmic)
            self.isLoading = false
        }
    }
    
    /**
     * Cache cosmic data to UserDefaults
     */
    private func cacheCosmicData(_ data: CosmicData) {
        do {
            let encoded = try JSONEncoder().encode(data)
            UserDefaults.standard.set(encoded, forKey: cacheKey)
            UserDefaults.standard.set(Date(), forKey: cacheTimestampKey)
            logger.info("🌌 Cached cosmic data successfully")
        } catch {
            logger.error("🌌 Failed to cache cosmic data: \(error)")
        }
    }
    
    /**
     * Load cached cosmic data
     */
    private func loadCachedData() {
        guard let data = UserDefaults.standard.data(forKey: cacheKey),
              let timestamp = UserDefaults.standard.object(forKey: cacheTimestampKey) as? Date else {
            logger.info("🌌 No cached cosmic data found")
            return
        }
        
        // Check if cache is from today
        if Calendar.current.isDateInToday(timestamp) {
            do {
                let cosmic = try JSONDecoder().decode(CosmicData.self, from: data)
                self.todaysCosmic = cosmic
                self.lastUpdated = timestamp
                logger.info("🌌 Loaded cached cosmic data from today")
            } catch {
                logger.error("🌌 Failed to decode cached cosmic data: \(error)")
                clearCache()
            }
        } else {
            logger.info("🌌 Cached cosmic data is outdated")
            clearCache()
        }
    }
    
    /**
     * Clear cached data
     */
    private func clearCache() {
        UserDefaults.standard.removeObject(forKey: cacheKey)
        UserDefaults.standard.removeObject(forKey: cacheTimestampKey)
    }
    
    /**
     * Schedule daily update at midnight
     */
    func scheduleDailyUpdate() {
        // Cancel existing timer
        dailyUpdateTimer?.invalidate()
        
        // Calculate time until next midnight
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
        let midnight = calendar.startOfDay(for: tomorrow)
        let timeInterval = midnight.timeIntervalSince(Date())
        
        // Schedule timer
        dailyUpdateTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
            Task { @MainActor in
                await CosmicService.shared.fetchTodaysCosmicData()
                // Reschedule for next day
                CosmicService.shared.scheduleDailyUpdate()
            }
        }
        
        logger.info("🌌 Scheduled next cosmic update for \(midnight)")
    }
    
    /**
     * Convert date to YYYY-MM-DD string for Firestore document ID
     */
    private func dateString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: date)
    }
    
    // MARK: - Cosmic Event Detection
    
    /**
     * Check for notable cosmic events
     */
    func checkForCosmicEvents() -> [String] {
        guard let cosmic = todaysCosmic else { return [] }
        
        var events: [String] = []
        
        // Full moon detection
        if cosmic.moonPhase.lowercased().contains("full") {
            events.append("🌕 Full Moon - Time for culmination and release")
        }
        
        // New moon detection
        if cosmic.moonPhase.lowercased().contains("new") {
            events.append("🌑 New Moon - Perfect for setting intentions")
        }
        
        // Mercury retrograde (placeholder - needs historical data)
        if let _ = cosmic.position(for: "Mercury"),
           cosmic.isRetrograde("Mercury") {
            events.append("☿ Mercury Retrograde - Review and revise communications")
        }
        
        return events
    }
    
    // MARK: - Testing Support
    
    #if DEBUG
    /// Force set cosmic data for testing
    func setTestCosmicData(_ data: CosmicData) {
        self.todaysCosmic = data
        self.lastUpdated = Date()
    }
    #endif
}

// MARK: - Convenience Extensions

extension CosmicService {
    /// Quick access to current moon phase
    var currentMoonPhase: String? {
        return todaysCosmic?.moonPhase
    }
    
    /// Quick access to current sun sign
    var currentSunSign: String? {
        return todaysCosmic?.sunSign
    }
    
    /// Check if cosmic data is available
    var hasCosmicData: Bool {
        return todaysCosmic != nil
    }
} 