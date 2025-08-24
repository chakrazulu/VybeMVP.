//
//  SwiftAAPlanetaryService.swift
//  VybeMVP
//
//  Created by Claude on 1/24/25.
//  Purpose: SwiftAA integration for Living Insight Engine planetary data
//  Provides real-time astronomical calculations for personalized insights
//

import Foundation
import SwiftUI
import CoreLocation
import os.log

/// Service for computing real-time planetary positions and aspects
/// Integrates with SwiftAA for astronomical calculations
@MainActor
final class SwiftAAPlanetaryService: ObservableObject {

    // MARK: - Types

    struct PlanetarySnapshot {
        let julianDay: Double
        let date: Date
        let location: CLLocation?

        // Solar & Lunar
        let sunSign: String
        let sunDegree: Double
        let moonSign: String
        let moonDegree: Double
        let moonPhase: MoonPhase

        // Personal Points (if birth time known)
        let ascendant: String?
        let midheaven: String?

        // Planetary Positions
        let planetaryPositions: [Planet: PlanetPosition]

        // Active Aspects
        let aspects: [PlanetaryAspect]

        // Retrogrades
        let retrogradeplanets: [Planet]

        // Cached for performance
        let computeTime: TimeInterval
        let cacheKey: String
    }

    struct PlanetPosition {
        let planet: Planet
        let sign: String
        let degree: Double
        let house: Int?
        let isRetrograde: Bool
    }

    struct MoonPhase {
        let name: String
        let percentage: Double // 0.0 to 1.0
        let emoji: String

        static func from(percentage: Double) -> MoonPhase {
            switch percentage {
            case 0..<0.0625:
                return MoonPhase(name: "New Moon", percentage: percentage, emoji: "🌑")
            case 0.0625..<0.1875:
                return MoonPhase(name: "Waxing Crescent", percentage: percentage, emoji: "🌒")
            case 0.1875..<0.3125:
                return MoonPhase(name: "First Quarter", percentage: percentage, emoji: "🌓")
            case 0.3125..<0.4375:
                return MoonPhase(name: "Waxing Gibbous", percentage: percentage, emoji: "🌔")
            case 0.4375..<0.5625:
                return MoonPhase(name: "Full Moon", percentage: percentage, emoji: "🌕")
            case 0.5625..<0.6875:
                return MoonPhase(name: "Waning Gibbous", percentage: percentage, emoji: "🌖")
            case 0.6875..<0.8125:
                return MoonPhase(name: "Last Quarter", percentage: percentage, emoji: "🌗")
            case 0.8125...1.0:
                return MoonPhase(name: "Waning Crescent", percentage: percentage, emoji: "🌘")
            default:
                return MoonPhase(name: "New Moon", percentage: 0, emoji: "🌑")
            }
        }
    }

    enum Planet: String, CaseIterable {
        case sun = "Sun"
        case moon = "Moon"
        case mercury = "Mercury"
        case venus = "Venus"
        case mars = "Mars"
        case jupiter = "Jupiter"
        case saturn = "Saturn"
        case uranus = "Uranus"
        case neptune = "Neptune"
        case pluto = "Pluto"

        var symbol: String {
            switch self {
            case .sun: return "☉"
            case .moon: return "☽"
            case .mercury: return "☿"
            case .venus: return "♀"
            case .mars: return "♂"
            case .jupiter: return "♃"
            case .saturn: return "♄"
            case .uranus: return "♅"
            case .neptune: return "♆"
            case .pluto: return "♇"
            }
        }
    }

    struct PlanetaryAspect: Codable, Sendable {
        let planet1: String
        let planet2: String
        let type: AspectType
        let orb: Double
        let isApplying: Bool
        let exactAt: Date?

        enum AspectType: String, Codable {
            case conjunction = "conjunction"
            case opposition = "opposition"
            case trine = "trine"
            case square = "square"
            case sextile = "sextile"
            case quincunx = "quincunx"

            var symbol: String {
                switch self {
                case .conjunction: return "☌"
                case .opposition: return "☍"
                case .trine: return "△"
                case .square: return "□"
                case .sextile: return "⚹"
                case .quincunx: return "⚻"
                }
            }

            var maxOrb: Double {
                switch self {
                case .conjunction, .opposition: return 10.0
                case .trine, .square: return 8.0
                case .sextile: return 6.0
                case .quincunx: return 3.0
                }
            }
        }
    }

    // MARK: - Singleton

    static let shared = SwiftAAPlanetaryService()

    // MARK: - Published Properties

    @Published private(set) var currentSnapshot: PlanetarySnapshot?
    @Published private(set) var isComputing = false
    @Published private(set) var lastComputeTime: Date?

    // MARK: - Private Properties

    private let logger = Logger(subsystem: "com.vybe.planetary", category: "SwiftAAPlanetaryService")
    private var snapshotCache = NSCache<NSString, SnapshotWrapper>()
    private let cacheTimeout: TimeInterval = 900 // 15 minutes
    private let computeQueue = DispatchQueue(label: "com.vybe.planetary.compute", qos: .userInitiated)

    // MARK: - Initialization

    private init() {
        configureCaching()
    }

    // MARK: - Public API

    /// Compute current planetary snapshot
    func computeSnapshot(for date: Date = Date(), location: CLLocation? = nil) async throws -> PlanetarySnapshot {
        let cacheKey = "\(date.timeIntervalSince1970)_\(location?.coordinate.latitude ?? 0)_\(location?.coordinate.longitude ?? 0)"

        // Check cache first
        if let cached = getCachedSnapshot(for: cacheKey) {
            logger.debug("Using cached planetary snapshot")
            return cached
        }

        isComputing = true
        defer { isComputing = false }

        let startTime = Date()

        // For now, return mock data until SwiftAA is integrated
        // In production, this would call SwiftAA calculations
        let snapshot = try await computeMockSnapshot(for: date, location: location)

        let computeTime = Date().timeIntervalSince(startTime)
        logger.info("Computed planetary snapshot in \(String(format: "%.3f", computeTime))s")

        // Cache the result
        cacheSnapshot(snapshot, for: cacheKey)

        currentSnapshot = snapshot
        lastComputeTime = Date()

        return snapshot
    }

    /// Get aspects between two planets
    func getAspect(between planet1: Planet, and planet2: Planet, on date: Date = Date()) async throws -> PlanetaryAspect? {
        let snapshot = try await computeSnapshot(for: date)

        return snapshot.aspects.first { aspect in
            (aspect.planet1 == planet1.rawValue && aspect.planet2 == planet2.rawValue) ||
            (aspect.planet1 == planet2.rawValue && aspect.planet2 == planet1.rawValue)
        }
    }

    /// Check if a planet is retrograde
    func isRetrograde(_ planet: Planet, on date: Date = Date()) async throws -> Bool {
        let snapshot = try await computeSnapshot(for: date)
        return snapshot.retrogradeplanets.contains(planet)
    }

    // MARK: - Private Methods

    private func configureCaching() {
        snapshotCache.countLimit = 10
        snapshotCache.totalCostLimit = 5 * 1024 * 1024 // 5MB
    }

    private func getCachedSnapshot(for key: String) -> PlanetarySnapshot? {
        guard let wrapper = snapshotCache.object(forKey: key as NSString) else { return nil }

        // Check if cache is still valid
        if Date().timeIntervalSince(wrapper.cachedAt) > cacheTimeout {
            snapshotCache.removeObject(forKey: key as NSString)
            return nil
        }

        return wrapper.snapshot
    }

    private func cacheSnapshot(_ snapshot: PlanetarySnapshot, for key: String) {
        let wrapper = SnapshotWrapper(snapshot: snapshot, cachedAt: Date())
        snapshotCache.setObject(wrapper, forKey: key as NSString)
    }

    // MARK: - Mock Implementation (Replace with SwiftAA)

    private func computeMockSnapshot(for date: Date, location: CLLocation?) async throws -> PlanetarySnapshot {
        // This is a mock implementation for testing
        // In production, integrate with SwiftAA for real calculations

        let jd = julianDay(from: date)

        // Mock planetary positions
        let positions: [Planet: PlanetPosition] = [
            .sun: PlanetPosition(planet: .sun, sign: "Leo", degree: 15.5, house: nil, isRetrograde: false),
            .moon: PlanetPosition(planet: .moon, sign: "Pisces", degree: 22.3, house: nil, isRetrograde: false),
            .mercury: PlanetPosition(planet: .mercury, sign: "Virgo", degree: 8.7, house: nil, isRetrograde: false),
            .venus: PlanetPosition(planet: .venus, sign: "Libra", degree: 12.1, house: nil, isRetrograde: false),
            .mars: PlanetPosition(planet: .mars, sign: "Aries", degree: 28.9, house: nil, isRetrograde: true)
        ]

        // Mock aspects
        let aspects = [
            PlanetaryAspect(
                planet1: "Moon",
                planet2: "Mars",
                type: .square,
                orb: 2.3,
                isApplying: true,
                exactAt: date.addingTimeInterval(3600)
            ),
            PlanetaryAspect(
                planet1: "Sun",
                planet2: "Jupiter",
                type: .trine,
                orb: 1.5,
                isApplying: false,
                exactAt: nil
            )
        ]

        return PlanetarySnapshot(
            julianDay: jd,
            date: date,
            location: location,
            sunSign: "Leo",
            sunDegree: 15.5,
            moonSign: "Pisces",
            moonDegree: 22.3,
            moonPhase: MoonPhase.from(percentage: 0.25),
            ascendant: location != nil ? "Scorpio" : nil,
            midheaven: location != nil ? "Leo" : nil,
            planetaryPositions: positions,
            aspects: aspects,
            retrogradeplanets: [.mars],
            computeTime: 0.05,
            cacheKey: "\(date.timeIntervalSince1970)"
        )
    }

    private func julianDay(from date: Date) -> Double {
        // Simplified Julian Day calculation
        // In production, use SwiftAA's precise calculation
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)

        let year = Double(components.year ?? 2025)
        let month = Double(components.month ?? 1)
        let day = Double(components.day ?? 1)
        let hour = Double(components.hour ?? 0)
        let minute = Double(components.minute ?? 0)
        let second = Double(components.second ?? 0)

        let a = floor((14 - month) / 12)
        let y = year + 4800 - a
        let m = month + 12 * a - 3

        var jd = day + floor((153 * m + 2) / 5) + 365 * y + floor(y / 4) - floor(y / 100) + floor(y / 400) - 32045
        jd += (hour - 12) / 24 + minute / 1440 + second / 86400

        return jd
    }
}

// MARK: - Supporting Types

private final class SnapshotWrapper {
    let snapshot: SwiftAAPlanetaryService.PlanetarySnapshot
    let cachedAt: Date

    init(snapshot: SwiftAAPlanetaryService.PlanetarySnapshot, cachedAt: Date) {
        self.snapshot = snapshot
        self.cachedAt = cachedAt
    }
}

// MARK: - Protocol Conformance

extension SwiftAAPlanetaryService: PlanetaryService {
    func currentSnapshot() async throws -> PlanetarySnapshot {
        // Convert to InsightContext PlanetarySnapshot type
        let snapshot = try await computeSnapshot()

        return PlanetarySnapshot(
            julianDay: snapshot.julianDay,
            sunSign: snapshot.sunSign,
            moonPhase: snapshot.moonPhase.name,
            moonSign: snapshot.moonSign,
            risingSign: snapshot.ascendant,
            activeAspects: snapshot.aspects.map { aspect in
                InsightContext.PlanetaryAspect(
                    planet1: aspect.planet1,
                    aspectType: aspect.type.rawValue,
                    planet2: aspect.planet2,
                    orb: aspect.orb,
                    applying: aspect.isApplying
                )
            },
            retrogrades: snapshot.retrogradeplanets.map { $0.rawValue }
        )
    }
}
