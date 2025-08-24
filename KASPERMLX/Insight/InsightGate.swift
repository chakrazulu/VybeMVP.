//
//  InsightGate.swift
//  VybeMVP
//
//  Created by Claude on 1/24/25.
//  Purpose: Debouncing and rate limiting for insight generation
//  Prevents insight fatigue and manages API/compute costs
//

import Foundation
import SwiftUI

/// Triggers that can request insight generation
public enum InsightTrigger: String, CaseIterable {
    case homeRefresh = "home_refresh"
    case homeAutomatic = "home_automatic"
    case journalSaved = "journal_saved"
    case meditationEnded = "meditation_ended"
    case sanctumEntered = "sanctum_entered"
    case timelineView = "timeline_view"
    case chakraBalance = "chakra_balance"
    case manualRequest = "manual_request"

    /// Default cooldown period for each trigger type
    var defaultCooldown: TimeInterval {
        switch self {
        case .homeRefresh:
            return 300 // 5 minutes
        case .homeAutomatic:
            return 21600 // 6 hours
        case .journalSaved:
            return 43200 // 12 hours
        case .meditationEnded:
            return 3600 // 1 hour
        case .sanctumEntered:
            return 7200 // 2 hours
        case .timelineView:
            return 86400 // 24 hours (once per day)
        case .chakraBalance:
            return 10800 // 3 hours
        case .manualRequest:
            return 60 // 1 minute
        }
    }

    /// Priority for rate limiting (higher = more important)
    var priority: Int {
        switch self {
        case .manualRequest:
            return 100
        case .meditationEnded, .journalSaved:
            return 75
        case .homeRefresh:
            return 50
        case .sanctumEntered, .chakraBalance:
            return 40
        case .homeAutomatic:
            return 25
        case .timelineView:
            return 10
        }
    }
}

/// Gate for managing insight generation frequency
@MainActor
public final class InsightGate: ObservableObject {

    // MARK: - Singleton

    public static let shared = InsightGate()

    // MARK: - Published Properties

    @Published private(set) var lastGenerated: [InsightTrigger: Date] = [:]
    @Published private(set) var dailyCount = 0
    @Published private(set) var isRateLimited = false

    // MARK: - Private Properties

    private let userDefaults = UserDefaults.standard
    private let dailyLimit = 20 // Maximum insights per day
    private let globalCooldown: TimeInterval = 30 // Minimum time between any insights
    private var lastGlobalGeneration: Date?
    private let dateFormatter = ISO8601DateFormatter()

    // Keys for persistence
    private let lastGeneratedKey = "com.vybe.insights.lastGenerated"
    private let dailyCountKey = "com.vybe.insights.dailyCount"
    private let dailyCountDateKey = "com.vybe.insights.dailyCountDate"

    // MARK: - Initialization

    private init() {
        loadPersistedState()
        resetDailyCountIfNeeded()
    }

    // MARK: - Public API

    /// Check if insight generation should proceed for a given trigger
    public func shouldFire(_ trigger: InsightTrigger, customInterval: TimeInterval? = nil) -> Bool {
        // Check global cooldown first
        if let lastGlobal = lastGlobalGeneration,
           Date().timeIntervalSince(lastGlobal) < globalCooldown {
            return false
        }

        // Check daily limit
        if dailyCount >= dailyLimit && trigger != .manualRequest {
            isRateLimited = true
            return false
        }

        // Check trigger-specific cooldown
        let cooldown = customInterval ?? trigger.defaultCooldown

        if let lastTime = lastGenerated[trigger] {
            let elapsed = Date().timeIntervalSince(lastTime)
            return elapsed >= cooldown
        }

        // First time for this trigger
        return true
    }

    /// Record that an insight was generated
    public func recordGeneration(for trigger: InsightTrigger) {
        let now = Date()

        lastGenerated[trigger] = now
        lastGlobalGeneration = now
        dailyCount += 1

        persistState()

        // Check if we're rate limited
        isRateLimited = dailyCount >= dailyLimit
    }

    /// Get time until next allowed generation for a trigger
    public func timeUntilNext(for trigger: InsightTrigger, customInterval: TimeInterval? = nil) -> TimeInterval? {
        guard let lastTime = lastGenerated[trigger] else { return nil }

        let cooldown = customInterval ?? trigger.defaultCooldown
        let elapsed = Date().timeIntervalSince(lastTime)
        let remaining = cooldown - elapsed

        return remaining > 0 ? remaining : nil
    }

    /// Get a human-readable time until next generation
    public func formattedTimeUntilNext(for trigger: InsightTrigger) -> String? {
        guard let remaining = timeUntilNext(for: trigger) else { return nil }

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated

        return formatter.string(from: remaining)
    }

    /// Reset cooldown for a specific trigger (e.g., for premium users)
    public func resetCooldown(for trigger: InsightTrigger) {
        lastGenerated.removeValue(forKey: trigger)
        persistState()
    }

    /// Reset all cooldowns and counters
    public func resetAll() {
        lastGenerated.removeAll()
        lastGlobalGeneration = nil
        dailyCount = 0
        isRateLimited = false

        userDefaults.removeObject(forKey: lastGeneratedKey)
        userDefaults.removeObject(forKey: dailyCountKey)
        userDefaults.removeObject(forKey: dailyCountDateKey)
    }

    // MARK: - Context Awareness

    /// Check if context has changed significantly enough to warrant new insight
    public func hasContextChanged(_ newContext: InsightContext, from oldContext: InsightContext?) -> Bool {
        guard let oldContext = oldContext else { return true }

        // Check for significant changes
        if newContext.focus != oldContext.focus { return true }
        if newContext.realm != oldContext.realm { return true }
        if newContext.mode != oldContext.mode { return true }

        // Check for new planetary aspects
        if newContext.aspects.count != oldContext.aspects.count { return true }

        // Check for meditation streak milestones
        if let newStreak = extractStreakDays(newContext),
           let oldStreak = extractStreakDays(oldContext) {
            // Trigger on milestones: 3, 7, 14, 30, 100 days
            let milestones = [3, 7, 14, 30, 100]
            for milestone in milestones {
                if oldStreak < milestone && newStreak >= milestone {
                    return true
                }
            }
        }

        return false
    }

    // MARK: - Private Methods

    private func loadPersistedState() {
        // Load last generated times
        if let data = userDefaults.data(forKey: lastGeneratedKey),
           let decoded = try? JSONDecoder().decode([String: Date].self, from: data) {

            // Convert string keys back to enum
            for (key, value) in decoded {
                if let trigger = InsightTrigger(rawValue: key) {
                    lastGenerated[trigger] = value
                }
            }
        }

        // Load daily count
        dailyCount = userDefaults.integer(forKey: dailyCountKey)
    }

    private func persistState() {
        // Save last generated times
        let stringKeyed = Dictionary(
            uniqueKeysWithValues: lastGenerated.map { ($0.key.rawValue, $0.value) }
        )

        if let encoded = try? JSONEncoder().encode(stringKeyed) {
            userDefaults.set(encoded, forKey: lastGeneratedKey)
        }

        // Save daily count
        userDefaults.set(dailyCount, forKey: dailyCountKey)
        userDefaults.set(Date(), forKey: dailyCountDateKey)
    }

    private func resetDailyCountIfNeeded() {
        guard let lastCountDate = userDefaults.object(forKey: dailyCountDateKey) as? Date else {
            // First run
            userDefaults.set(Date(), forKey: dailyCountDateKey)
            return
        }

        // Check if it's a new day
        let calendar = Calendar.current
        if !calendar.isDateInToday(lastCountDate) {
            dailyCount = 0
            isRateLimited = false
            userDefaults.set(Date(), forKey: dailyCountDateKey)
        }
    }

    private func extractStreakDays(_ context: InsightContext) -> Int? {
        // Extract meditation streak from context
        // This would connect to your actual meditation tracking
        return context.sessionDuration.map { Int($0 / 86400) } // Convert seconds to days
    }
}

// MARK: - Premium Features Extension

extension InsightGate {

    /// Apply premium benefits (reduced cooldowns, higher limits)
    public func applyPremiumBenefits() {
        // Premium users get 2x the daily limit
        // This would be implemented based on your subscription system
    }

    /// Check if user has priority access
    public func hasPriorityAccess(for trigger: InsightTrigger) -> Bool {
        // Premium users bypass certain cooldowns
        // Connect to your subscription manager
        return false // Placeholder
    }
}

// MARK: - SwiftUI View Modifier

/// View modifier for automatic insight triggering
struct InsightTriggerModifier: ViewModifier {
    let trigger: InsightTrigger
    let engine: HybridInsightEngine
    @StateObject private var gate = InsightGate.shared
    @State private var lastContext: InsightContext?

    func body(content: Content) -> some View {
        content
            .task(id: trigger) {
                await checkAndGenerate()
            }
    }

    private func checkAndGenerate() async {
        guard gate.shouldFire(trigger) else { return }

        // Get current context
        guard let context = await getCurrentContext() else { return }

        // Check if context changed significantly
        guard gate.hasContextChanged(context, from: lastContext) else { return }

        // Generate insight
        do {
            _ = try await engine.generate(from: context)
            gate.recordGeneration(for: trigger)
            lastContext = context
        } catch {
            // Handle error silently
        }
    }

    private func getCurrentContext() async -> InsightContext? {
        // This would get the current context from your providers
        // Placeholder implementation
        return nil
    }
}

extension View {
    /// Automatically trigger insight generation when view appears
    public func insightTrigger(_ trigger: InsightTrigger, engine: HybridInsightEngine) -> some View {
        modifier(InsightTriggerModifier(trigger: trigger, engine: engine))
    }
}
