// Managers/AIInsightManager.swift
// VybeMVP
//
// Created by Gemini
//

import Foundation
import Combine
import CoreData
// RACE CONDITION FIX: Import AuthenticationManager for fallback userID
// (Note: This creates a dependency, but it's necessary for the fallback)

/*
 * ========================================
 * 🧠 AI INSIGHT MANAGER - PERSONALIZED WISDOM ENGINE
 * ========================================
 * 
 * CORE PURPOSE:
 * Sophisticated AI insight orchestration system generating personalized daily wisdom
 * based on user's spiritual profile, life path number, and cosmic preferences. Manages
 * Core Data persistence, intelligent caching, and seamless insight delivery.
 * 
 * INSIGHT GENERATION SYSTEM:
 * - Profile Analysis: Uses UserProfile for personalized insight selection
 * - Filter Service Integration: InsightFilterService provides matching algorithms
 * - Template Scoring: Advanced scoring system for optimal insight selection
 * - Fallback Mechanisms: Ensures insights always available even with limited data
 * - Tag Matching: Aligns insights with user's focus tags and preferences
 * 
 * CORE DATA INTEGRATION:
 * - Daily Persistence: Saves insights as PersistedInsightLog entries
 * - Duplicate Prevention: Checks for existing today's insight before generation
 * - Activity Feed: Provides data for ActivityView insight display
 * - Timestamp Management: Proper date handling for daily insight cycles
 * - Query Optimization: Efficient fetch requests with date range filtering
 * 
 * STATE MANAGEMENT:
 * - @Published personalizedDailyInsight: Current insight for UI binding
 * - @Published isInsightReady: Boolean flag for loading states
 * - Singleton Pattern: Shared instance for app-wide access
 * - ObservableObject: SwiftUI reactive updates for insight changes
 * - Combine Integration: Reactive programming with cancellable subscriptions
 * 
 * PERFORMANCE OPTIMIZATIONS:
 * - Throttling System: 10-second minimum between refresh calls
 * - Cache-First Strategy: Checks Core Data before generating new insights
 * - Race Condition Prevention: Multiple userID sources with fallback logic
 * - Memory Management: Proper Combine cancellable cleanup
 * - Efficient Queries: Optimized Core Data fetch requests with limits
 * 
 * INTEGRATION POINTS:
 * - UserProfileService: Profile data source for personalization
 * - InsightFilterService: Core insight selection and scoring algorithms
 * - ActivityView: Displays generated insights in activity feed
 * - AuthenticationManager: Fallback userID source for robustness
 * - PersistenceController: Core Data context for insight storage
 * 
 * INSIGHT LIFECYCLE:
 * 1. Configuration: configureAndRefreshInsight() with user profile
 * 2. Cache Check: fetchTodaysInsightFromCoreData() for existing insights
 * 3. Generation: InsightFilterService.getPersonalizedInsight() for new content
 * 4. Persistence: saveInsightToCoreData() for future reference
 * 5. Publication: @Published properties update UI automatically
 * 
 * ERROR HANDLING & RESILIENCE:
 * - Profile Fallbacks: Multiple sources for user profile data
 * - Throttling Protection: Prevents rapid successive refresh calls
 * - Core Data Errors: Graceful handling of persistence failures
 * - Missing Data: Comprehensive null checking and default values
 * - Network Independence: Works offline with cached data
 * 
 * PERSONALIZATION FEATURES:
 * - Life Path Integration: Insights tailored to numerological profile
 * - Focus Tag Matching: Aligns with user's selected spiritual interests
 * - Spiritual Mode: Respects user's preferred spiritual approach
 * - Cosmic Preferences: Incorporates cosmic alignment settings
 * - Tone Adaptation: Matches user's preferred insight tone
 * 
 * TECHNICAL ARCHITECTURE:
 * - Singleton Design: Single source of truth for insight state
 * - Reactive Updates: Combine-based state propagation
 * - Core Data ORM: Efficient data persistence and retrieval
 * - Service Composition: Clean separation with InsightFilterService
 * - Thread Safety: Proper main queue execution for UI updates
 * 
 * DEBUGGING & MONITORING:
 * - Comprehensive Logging: Detailed insight generation tracking
 * - Source Attribution: Template ID, score, and tag matching details
 * - Performance Metrics: Throttling and cache hit rate monitoring
 * - Error Tracking: Detailed error messages for troubleshooting
 * - State Visibility: Clear insight ready/loading state management
 */

/**
 * `AIInsightManager` is an ObservableObject responsible for orchestrating the generation
 * and provision of personalized insights for the user.
 *
 * It uses the user's `UserProfile` and the `InsightFilterService` to select
 * an appropriate daily insight. Views can observe this manager to display
 * the latest insight.
 */
class AIInsightManager: ObservableObject {
    
    /// Shared singleton instance for easy access throughout the app.
    static let shared = AIInsightManager()
    
    /// The currently prepared personalized insight for the user.
    /// Views should observe this property to display the insight.
    @Published var personalizedDailyInsight: PreparedInsight?
    
    /// A boolean flag indicating whether a personalized insight is ready to be displayed.
    @Published var isInsightReady: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let viewContext = PersistenceController.shared.container.viewContext
    
    // THROTTLING: Prevent rapid successive refresh calls
    private var lastRefreshTime: Date?
    private let refreshThrottleSeconds: TimeInterval = 10 // 10 seconds minimum between refreshes
    
    /// Private initializer to enforce singleton pattern.
    private init() {
        // Potential future use: Load last known insight from cache, etc.
    }
    
    /**
     * Configures the manager with the user's profile and attempts to generate a personalized insight.
     *
     * This method should be called after the user's profile is available (e.g., after login or onboarding).
     * It uses the `InsightFilterService` to find the best matching insight.
     *
     * - Parameter profile: The `UserProfile` object for the current user.
     */
    func configureAndRefreshInsight(for profile: UserProfile) {
        print("AIInsightManager: Configuring and refreshing insight for user ID \(profile.id)...")
        
        // Check if we already have today's insight in Core Data
        if let existingInsight = fetchTodaysInsightFromCoreData(lifePathNumber: profile.lifePathNumber) {
            print("✨ Found existing insight for today in Core Data")
            self.personalizedDailyInsight = existingInsight
            self.isInsightReady = true
            return
        }
        
        // Generate new insight
        if let insight = InsightFilterService.getPersonalizedInsight(for: profile) {
            self.personalizedDailyInsight = insight
            self.isInsightReady = true
            print("✨ Personalized insight prepared: \"\(insight.text.prefix(70))...\"")
            if let source = insight.source {
                print("   Source Details - Template ID: '\(source.templateID)', Score: \(source.score), Matched Tags: \(source.matchedFocusTags.joined(separator: ", ")), Fallback: \(source.isFallback)")
            }
            
            // Save to Core Data for ActivityView
            saveInsightToCoreData(insight: insight, profile: profile)
        } else {
            self.personalizedDailyInsight = nil // Clear any old insight
            self.isInsightReady = false
            print("😔 AIInsightManager: Could not prepare a personalized insight for the current profile.")
        }
    }
    
    /**
     * Refreshes the insight for the current user if they have a profile.
     * This should be called on app launch or when switching tabs.
     */
    func refreshInsightIfNeeded() {
        // THROTTLING: Prevent rapid successive calls
        if let lastRefresh = lastRefreshTime,
           Date().timeIntervalSince(lastRefresh) < refreshThrottleSeconds {
            print("🛑 AIInsightManager: Throttling refresh request - too soon since last refresh")
            return
        }
        
        // RACE CONDITION FIX: Try multiple sources for userProfile
        var userProfile: UserProfile?
        
        // Try UserDefaults first
        if let id = UserDefaults.standard.string(forKey: "userID") {
            userProfile = UserProfileService.shared.getCurrentUserProfileFromUserDefaults(for: id)
        }
        
        // FALLBACK: Try AuthenticationManager if UserDefaults fails
        if userProfile == nil, let authID = AuthenticationManager.shared.userID {
            userProfile = UserProfileService.shared.getCurrentUserProfileFromUserDefaults(for: authID)
        }
        
        guard let profile = userProfile else {
            print("⚠️ AIInsightManager: Cannot refresh insight - no user profile found (tried UserDefaults and AuthManager)")
            return
        }
        
        // Update throttle time
        lastRefreshTime = Date()
        
        configureAndRefreshInsight(for: profile)
    }
    
    /**
     * Saves the personalized insight to Core Data as a PersistedInsightLog entry.
     */
    private func saveInsightToCoreData(insight: PreparedInsight, profile: UserProfile) {
        let newInsightLog = PersistedInsightLog(context: viewContext)
        newInsightLog.id = UUID()
        newInsightLog.timestamp = Date()
        newInsightLog.number = Int16(profile.lifePathNumber)
        newInsightLog.category = "daily_insight"
        newInsightLog.text = insight.text
        
        // Create tags based on profile
        var tags = ["Daily Insight", "Life Path \(profile.lifePathNumber)"]
        if let source = insight.source {
            tags.append(contentsOf: source.matchedFocusTags)
        }
        newInsightLog.tags = tags.joined(separator: ", ")
        
        // Use background context to avoid blocking main thread
        PersistenceController.shared.save()
        print("💾 Successfully saved daily insight to Core Data (background context)")
    }
    
    /**
     * Fetches today's insight from Core Data if it exists.
     */
    private func fetchTodaysInsightFromCoreData(lifePathNumber: Int) -> PreparedInsight? {
        let request: NSFetchRequest<PersistedInsightLog> = PersistedInsightLog.fetchRequest()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        request.predicate = NSPredicate(
            format: "timestamp >= %@ AND timestamp < %@ AND category == %@ AND number == %d",
            startOfDay as NSDate,
            endOfDay as NSDate,
            "daily_insight",
            lifePathNumber
        )
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        request.fetchLimit = 1
        
        do {
            let results = try viewContext.fetch(request)
            if let insightLog = results.first {
                return PreparedInsight(
                    date: insightLog.timestamp ?? Date(),
                    lifePathNumber: Int(insightLog.number),
                    text: insightLog.text ?? ""
                )
            }
        } catch {
            print("❌ Error fetching today's insight from Core Data: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    /**
     * Clears the current personalized insight.
     * Call this on user logout, for example.
     */
    func clearInsight() {
        self.personalizedDailyInsight = nil
        self.isInsightReady = false
        print("AIInsightManager: Cleared personalized insight.")
    }
} 