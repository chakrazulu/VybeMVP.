//
//  InsightContext.swift
//  VybeMVP
//
//  Created by Claude on 1/24/25.
//  Purpose: Unified context fabric for Living Insight Engine
//  Part of Phase 2B LLM Integration
//

import Foundation
import SwiftUI

// MARK: - Core Context Structure

/// Unified context for generating personalized spiritual insights
/// Combines numerology, planetary data, and user state
struct InsightContext: Sendable, Codable {
    // MARK: - Core Numerology (from Sanctum)
    let lifePath: Int
    let expression: Int
    let soulUrge: Int
    let destiny: Int
    let personality: Int
    let maturity: Int

    // MARK: - Current Focus & Realm
    let focus: Int
    let realm: Int

    // MARK: - Planetary Context (SwiftAA snapshot)
    let julianDay: Double               // Julian Day for astronomical calculations
    let sunSign: String                  // Current sun sign (e.g., "Leo")
    let moonPhase: String                // Current moon phase (e.g., "Waxing Crescent")
    let moonSign: String                 // Current moon sign
    let risingSign: String?              // Ascendant if birth time known
    let aspects: [PlanetaryAspect]       // Active planetary aspects
    let retrogrades: [String]            // Planets currently in retrograde

    // MARK: - User State (bounded, private)
    let mode: UserMode                   // Current app mode (meditate, journal, home)
    let localTime: Date                  // User's local time
    let sessionDuration: TimeInterval?   // Duration if in active session
    let recentActivity: [String]         // Last 3-5 user actions (privacy-safe)

    // MARK: - Optional Enhancement Data
    let chakraStates: [ChakraState]?     // Current chakra balance if available
    let consciousnessLevel: Int?         // Hawkins scale calibration if measured
    let biometrics: BiometricSnapshot?   // Heart rate, HRV if available
}

// MARK: - Supporting Types

enum UserMode: String, Codable, CaseIterable {
    case home = "home"
    case meditate = "meditate"
    case journal = "journal"
    case timeline = "timeline"
    case sanctum = "sanctum"
    case explore = "explore"
    case reflect = "reflect"
}

struct PlanetaryAspect: Codable, Sendable {
    let planet1: String
    let aspectType: String  // conjunction, square, trine, opposition, sextile
    let planet2: String
    let orb: Double        // Degrees of exactness
    let applying: Bool     // Whether aspect is strengthening

    var symbol: String {
        switch aspectType {
        case "conjunction": return "☌"
        case "opposition": return "☍"
        case "square": return "□"
        case "trine": return "△"
        case "sextile": return "⚹"
        default: return "◦"
        }
    }

    var description: String {
        "\(planet1) \(symbol) \(planet2)"
    }
}

struct ChakraState: Codable, Sendable {
    let chakra: String
    let balance: Double  // 0.0 to 1.0
    let frequency: Double?
}

struct BiometricSnapshot: Codable, Sendable {
    let heartRate: Double?
    let hrv: Double?
    let respirationRate: Double?
    let timestamp: Date
}

// MARK: - Selection Request/Response

struct SelectionRequest {
    let context: InsightContext
    let persona: String         // Which voice/perspective to use
    let maxLines: Int          // How many content lines to retrieve
    let intent: SelectionIntent // What kind of insight is needed
}

enum SelectionIntent: String {
    case general = "general"
    case meditation = "meditation"
    case reflection = "reflection"
    case guidance = "guidance"
    case affirmation = "affirmation"
    case shadow = "shadow"
    case growth = "growth"
}

struct SelectionResult {
    let lines: [String]        // Selected content lines
    let tags: [String]         // Explanation tags (why selected)
    let confidence: Double     // Selection confidence score
    let metadata: [String: Any]
}

// MARK: - Context Provider Protocol

protocol ContextProvider {
    func current(for mode: UserMode) async throws -> InsightContext
    func refresh() async throws
    func cached() -> InsightContext?
}

// MARK: - Default Context Provider

@MainActor
final class DefaultContextProvider: ContextProvider, ObservableObject {
    @Published private(set) var lastContext: InsightContext?
    private let numerologyManager: NumerologyManager
    private let planetaryService: PlanetaryService
    private let userStateManager: UserStateManager

    init(
        numerologyManager: NumerologyManager,
        planetaryService: PlanetaryService,
        userStateManager: UserStateManager
    ) {
        self.numerologyManager = numerologyManager
        self.planetaryService = planetaryService
        self.userStateManager = userStateManager
    }

    func current(for mode: UserMode) async throws -> InsightContext {
        // Gather numerology data (cached, fast)
        let numerology = await numerologyManager.currentProfile()

        // Get planetary snapshot (may compute or use cache)
        let planetary = try await planetaryService.currentSnapshot()

        // Get user state
        let userState = await userStateManager.currentState(mode: mode)

        // Assemble context
        let context = InsightContext(
            lifePath: numerology.lifePath,
            expression: numerology.expression,
            soulUrge: numerology.soulUrge,
            destiny: numerology.destiny,
            personality: numerology.personality,
            maturity: numerology.maturity,
            focus: userState.currentFocus,
            realm: userState.currentRealm,
            julianDay: planetary.julianDay,
            sunSign: planetary.sunSign,
            moonPhase: planetary.moonPhase,
            moonSign: planetary.moonSign,
            risingSign: planetary.risingSign,
            aspects: planetary.activeAspects,
            retrogrades: planetary.retrogrades,
            mode: mode,
            localTime: Date(),
            sessionDuration: userState.sessionDuration,
            recentActivity: userState.recentActivity,
            chakraStates: userState.chakraStates,
            consciousnessLevel: userState.consciousnessLevel,
            biometrics: userState.biometrics
        )

        self.lastContext = context
        return context
    }

    func refresh() async throws {
        _ = try await current(for: .home)
    }

    func cached() -> InsightContext? {
        lastContext
    }
}

// MARK: - Placeholder Service Protocols

protocol NumerologyManager {
    func currentProfile() async -> NumerologyProfile
}

protocol PlanetaryService {
    func currentSnapshot() async throws -> PlanetarySnapshot
}

protocol UserStateManager {
    func currentState(mode: UserMode) async -> UserState
}

// MARK: - Placeholder Data Types

struct NumerologyProfile {
    let lifePath: Int
    let expression: Int
    let soulUrge: Int
    let destiny: Int
    let personality: Int
    let maturity: Int
}

struct PlanetarySnapshot {
    let julianDay: Double
    let sunSign: String
    let moonPhase: String
    let moonSign: String
    let risingSign: String?
    let activeAspects: [PlanetaryAspect]
    let retrogrades: [String]
}

struct UserState {
    let currentFocus: Int
    let currentRealm: Int
    let sessionDuration: TimeInterval?
    let recentActivity: [String]
    let chakraStates: [ChakraState]?
    let consciousnessLevel: Int?
    let biometrics: BiometricSnapshot?
}
