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
public struct InsightContext: Sendable, Codable {
    // MARK: - Core Numerology (from Sanctum)
    public let lifePath: Int
    public let expression: Int
    public let soulUrge: Int
    public let destiny: Int
    public let personality: Int
    public let maturity: Int

    // MARK: - Current Focus & Realm
    public let focus: Int
    public let realm: Int

    // MARK: - Planetary Context (SwiftAA snapshot)
    public let julianDay: Double               // Julian Day for astronomical calculations
    public let sunSign: String                  // Current sun sign (e.g., "Leo")
    public let moonPhase: String                // Current moon phase (e.g., "Waxing Crescent")
    public let moonSign: String                 // Current moon sign
    public let risingSign: String?              // Ascendant if birth time known
    public let aspects: [PlanetaryAspect]       // Active planetary aspects
    public let retrogrades: [String]            // Planets currently in retrograde

    // MARK: - User State (bounded, private)
    public let mode: UserMode                   // Current app mode (meditate, journal, home)
    public let localTime: Date                  // User's local time
    public let sessionDuration: TimeInterval?   // Duration if in active session
    public let recentActivity: [String]         // Last 3-5 user actions (privacy-safe)

    // MARK: - Optional Enhancement Data
    public let chakraStates: [ChakraBalance]?     // Current chakra balance if available
    public let consciousnessLevel: Int?         // Hawkins scale calibration if measured
    public let biometrics: BiometricSnapshot?   // Heart rate, HRV if available

    public init(lifePath: Int, expression: Int, soulUrge: Int, destiny: Int, personality: Int, maturity: Int, focus: Int, realm: Int, julianDay: Double, sunSign: String, moonPhase: String, moonSign: String, risingSign: String?, aspects: [PlanetaryAspect], retrogrades: [String], mode: UserMode, localTime: Date, sessionDuration: TimeInterval?, recentActivity: [String], chakraStates: [ChakraBalance]?, consciousnessLevel: Int?, biometrics: BiometricSnapshot?) {
        self.lifePath = lifePath
        self.expression = expression
        self.soulUrge = soulUrge
        self.destiny = destiny
        self.personality = personality
        self.maturity = maturity
        self.focus = focus
        self.realm = realm
        self.julianDay = julianDay
        self.sunSign = sunSign
        self.moonPhase = moonPhase
        self.moonSign = moonSign
        self.risingSign = risingSign
        self.aspects = aspects
        self.retrogrades = retrogrades
        self.mode = mode
        self.localTime = localTime
        self.sessionDuration = sessionDuration
        self.recentActivity = recentActivity
        self.chakraStates = chakraStates
        self.consciousnessLevel = consciousnessLevel
        self.biometrics = biometrics
    }
}

// MARK: - Compatibility Extensions for Legacy Code

extension InsightContext {
    /// Legacy compatibility - simulate primaryData dictionary
    public var primaryData: [String: Any] {
        return [
            "focusNumber": focus,
            "realmNumber": realm,
            "lifePath": lifePath,
            "mode": mode.rawValue
        ]
    }

    /// Legacy compatibility - simulate userQuery
    public var userQuery: String? {
        return "Generate spiritual insight for focus \(focus), realm \(realm)"
    }

    /// Legacy compatibility - provide default constraints
    var constraints: InsightConstraints? {
        return InsightConstraints(
            maxLength: 150,
            tone: "encouraging",
            includeEmojis: true
        )
    }

    /// Legacy constructor for backwards compatibility
    init(primaryData: [String: Any], userQuery: String? = nil, constraints: InsightConstraints? = nil) {
        // Extract values from legacy format with sensible defaults
        self.focus = primaryData["focusNumber"] as? Int ?? 1
        self.realm = primaryData["realmNumber"] as? Int ?? 1
        self.lifePath = primaryData["lifePath"] as? Int ?? 1
        self.expression = 1
        self.soulUrge = 1
        self.destiny = 1
        self.personality = 1
        self.maturity = 1
        self.julianDay = 2460000.0 // Current approximate Julian day
        self.sunSign = "Leo"
        self.moonPhase = "Waxing"
        self.moonSign = "Sagittarius"
        self.risingSign = nil
        self.aspects = []
        self.retrogrades = []
        self.mode = .home
        self.localTime = Date()
        self.sessionDuration = nil
        self.recentActivity = []
        self.chakraStates = nil
        self.consciousnessLevel = nil
        self.biometrics = nil
    }
}


// MARK: - Supporting Types

public enum UserMode: String, Codable, CaseIterable, Sendable {
    case home = "home"
    case meditate = "meditate"
    case journal = "journal"
    case timeline = "timeline"
    case sanctum = "sanctum"
    case explore = "explore"
    case reflect = "reflect"
}

public struct PlanetaryAspect: Codable, Sendable {
    public let planet1: String
    public let aspectType: String  // conjunction, square, trine, opposition, sextile
    public let planet2: String
    public let orb: Double        // Degrees of exactness
    public let applying: Bool     // Whether aspect is strengthening

    public var symbol: String {
        switch aspectType {
        case "conjunction": return "☌"
        case "opposition": return "☍"
        case "square": return "□"
        case "trine": return "△"
        case "sextile": return "⚹"
        default: return "◦"
        }
    }

    public var description: String {
        "\(planet1) \(symbol) \(planet2)"
    }

    public init(planet1: String, aspectType: String, planet2: String, orb: Double, applying: Bool) {
        self.planet1 = planet1
        self.aspectType = aspectType
        self.planet2 = planet2
        self.orb = orb
        self.applying = applying
    }
}

public struct ChakraBalance: Codable, Sendable {
    public let chakra: String
    public let balance: Double  // 0.0 to 1.0
    public let frequency: Double?

    public init(chakra: String, balance: Double, frequency: Double?) {
        self.chakra = chakra
        self.balance = balance
        self.frequency = frequency
    }
}

public struct BiometricSnapshot: Codable, Sendable {
    public let heartRate: Double?
    public let hrv: Double?
    public let respirationRate: Double?
    public let timestamp: Date

    public init(heartRate: Double?, hrv: Double?, respirationRate: Double?, timestamp: Date) {
        self.heartRate = heartRate
        self.hrv = hrv
        self.respirationRate = respirationRate
        self.timestamp = timestamp
    }
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

    nonisolated func cached() -> InsightContext? {
        // Need to hop to MainActor to read the cached value
        let context = MainActor.assumeIsolated {
            return lastContext
        }
        return context
    }
}

// MARK: - Placeholder Service Protocols

protocol NumerologyManager {
    func currentProfile() async -> NumerologyProfile
}

public protocol PlanetaryService {
    func currentSnapshot() async throws -> PlanetarySnapshot
}

public protocol UserStateManager {
    func currentState(mode: UserMode) async -> UserSession
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

public struct PlanetarySnapshot {
    public let julianDay: Double
    public let sunSign: String
    public let moonPhase: String
    public let moonSign: String
    public let risingSign: String?
    public let activeAspects: [PlanetaryAspect]
    public let retrogrades: [String]

    public init(julianDay: Double, sunSign: String, moonPhase: String, moonSign: String, risingSign: String?, activeAspects: [PlanetaryAspect], retrogrades: [String]) {
        self.julianDay = julianDay
        self.sunSign = sunSign
        self.moonPhase = moonPhase
        self.moonSign = moonSign
        self.risingSign = risingSign
        self.activeAspects = activeAspects
        self.retrogrades = retrogrades
    }
}

public struct UserSession {
    public let currentFocus: Int
    public let currentRealm: Int
    public let sessionDuration: TimeInterval?
    public let recentActivity: [String]
    public let chakraStates: [ChakraBalance]?
    public let consciousnessLevel: Int?
    public let biometrics: BiometricSnapshot?

    public init(currentFocus: Int, currentRealm: Int, sessionDuration: TimeInterval?, recentActivity: [String], chakraStates: [ChakraBalance]?, consciousnessLevel: Int?, biometrics: BiometricSnapshot?) {
        self.currentFocus = currentFocus
        self.currentRealm = currentRealm
        self.sessionDuration = sessionDuration
        self.recentActivity = recentActivity
        self.chakraStates = chakraStates
        self.consciousnessLevel = consciousnessLevel
        self.biometrics = biometrics
    }
}
