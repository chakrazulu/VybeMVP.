/*
 * ========================================
 * 🌌 SANCTUM DATA STRUCTURES
 * ========================================
 * 
 * SHARED PURPOSE:
 * Centralized data structures for the Sanctum view and its components
 * to avoid duplication and maintain consistency across the codebase.
 *
 * INCLUDED STRUCTURES:
 * - SanctumViewMode: Enum for birth chart vs live transits
 * - PlanetaryPosition: Planet position data with sign and degree
 * - NatalAspect: Astrological aspect data with orb and interpretation
 * - IdentifiableInt: Wrapper for Int values requiring Identifiable
 *
 * ARCHITECTURAL BENEFITS:
 * - Single source of truth for shared data types
 * - Eliminates ambiguous type lookup errors
 * - Consistent data structures across components
 * - Clean separation of concerns
 */

import SwiftUI

// MARK: - Sanctum View Mode

/// Claude: View mode for Sanctum display
enum SanctumViewMode: String, CaseIterable {
    case birthChart = "Birth Chart"
    case liveTransits = "Live Transits"
    
    var icon: String {
        switch self {
        case .birthChart: return "person.circle.fill"
        case .liveTransits: return "globe.americas.fill"
        }
    }
    
    var description: String {
        switch self {
        case .birthChart: return "Your natal chart at birth"
        case .liveTransits: return "Current planetary positions"
        }
    }
}

// MARK: - Astrological Data Structures

// Claude: Removed duplicate AspectType enum - now using SwiftData version from AstrologicalAspect.swift
// This prevents "AspectType is ambiguous for type lookup" errors
// enum AspectType: String, CaseIterable { ... }

/// Claude: Planetary position data structure
struct PlanetaryPosition: Identifiable {
    let id = UUID()
    let planet: String
    let sign: String
    let degree: Int
    let houseNumber: Int? // Placidus house number (1-12), nil for transits
    
    /// Formatted display with house number (like Co-Star)
    var formattedWithHouse: String {
        if let house = houseNumber {
            return "in \(sign), House \(house)"
        }
        return "in \(sign)"
    }
}

/// Claude: Natal aspect data structure
struct NatalAspect: Identifiable {
    let id = UUID()
    let planet1: String
    let planet2: String
    let type: AspectType
    let orb: Double
    let maxOrb: Double
    let interpretation: String
}

// MARK: - Utility Structures

/// Claude: Identifiable wrapper for Int values
struct IdentifiableInt: Identifiable {
    let id = UUID()
    let value: Int
}