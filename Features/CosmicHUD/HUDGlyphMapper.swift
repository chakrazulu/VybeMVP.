import Foundation
import SwiftAA

// MARK: - HUD Glyph Mapper
/// Claude: Revolutionary zero-asset glyph mapping system for Cosmic HUD
/// Combines SwiftAA astronomical symbols with universal emojis for crisp, authentic spiritual display
/// No downloads, no memory overhead, no performance cost - just pure symbolic power

struct HUDGlyphMapper {

    // MARK: - Element Mapping
    /// Maps spiritual elements to their universal emoji representations
    static func element(for element: CosmicElement) -> String {
        switch element {
        case .fire:
            return "🔥"
        case .water:
            return "💧"
        case .earth:
            return "🌱"
        case .air:
            return "💨"
        }
    }

    /// Gets element color for visual theming
    static func elementColor(for element: CosmicElement) -> String {
        switch element {
        case .fire:
            return "red"
        case .water:
            return "blue"
        case .earth:
            return "brown"
        case .air:
            return "cyan"
        }
    }

    // MARK: - Planet Mapping
    /// Returns authentic astrological planet symbols from SwiftAA
    /// These are text-based and scale perfectly at any size
    static func planet(for planet: HUDPlanet) -> String {
        // Claude: Map HUDPlanet enum to astrological symbols
        switch planet {
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

    /// Emoji fallbacks for planets (if needed for theming)
    static func planetEmoji(for planet: HUDPlanet) -> String {
        switch planet {
        case .sun:
            return "☀️"
        case .moon:
            return "🌙"
        case .mercury:
            return "☿️"
        case .venus:
            return "♀️"
        case .mars:
            return "♂️"
        case .jupiter:
            return "♃"
        case .saturn:
            return "♄"
        case .uranus:
            return "♅"
        case .neptune:
            return "♆"
        case .pluto:
            return "♇"
        }
    }

    // MARK: - Aspect Mapping
    /// Returns authentic astrological aspect symbols from SwiftAA
    static func aspect(for aspect: CosmicAspect) -> String {
        switch aspect {
        case .conjunction:
            return "☌"  // Conjunction symbol
        case .sextile:
            return "⚹"  // Sextile symbol
        case .square:
            return "□"  // Square symbol
        case .trine:
            return "△"  // Trine symbol
        case .opposition:
            return "☍"  // Opposition symbol
        case .quincunx:
            return "⚻"  // Quincunx symbol
        }
    }

    /// Emoji fallbacks for aspects
    static func aspectEmoji(for aspect: CosmicAspect) -> String {
        switch aspect {
        case .conjunction:
            return "⭕"
        case .sextile:
            return "✴️"
        case .square:
            return "⬜"
        case .trine:
            return "🔺"
        case .opposition:
            return "↔️"
        default:
            return "◯"
        }
    }

    // MARK: - App Intent Icons
    /// Maps HUD App Intent actions to their visual representations
    static func intentIcon(for intent: HUDIntent) -> String {
        switch intent {
        case .sighting:
            return "👁"
        case .journal:
            return "📓"
        case .composer:
            return "💬"
        case .rulerGraph:
            return "📊"
        case .focusSelector:
            return "🔢"
        case .cosmicSnapshot:
            return "✨"
        }
    }

    // MARK: - Ruler Number Styling
    /// Creates crowned ruler number display
    static func rulerNumber(_ number: Int) -> String {
        return "👑 \(number)"
    }

    /// Alternative mystical backgrounds for ruler number
    static func rulerNumberWithHalo(_ number: Int, style: HaloStyle = .star) -> String {
        let halo = style.symbol
        return "\(halo) \(number)"
    }

    // MARK: - Aspect Chain Formatting
    /// Formats complete aspect chain for HUD display
    /// Example: "♀ △ ♃" (Venus trine Jupiter)
    static func aspectChain(planet1: HUDPlanet, aspect: CosmicAspect, planet2: HUDPlanet) -> String {
        let p1 = planet(for: planet1)
        let asp = HUDGlyphMapper.aspect(for: aspect)
        let p2 = planet(for: planet2)
        return "\(p1) \(asp) \(p2)"
    }

    /// Formatted aspect chain with spacing for readability
    static func aspectChainSpaced(planet1: HUDPlanet, aspect: CosmicAspect, planet2: HUDPlanet) -> String {
        let p1 = planet(for: planet1)
        let asp = HUDGlyphMapper.aspect(for: aspect)
        let p2 = planet(for: planet2)
        return "\(p1)  \(asp)  \(p2)"
    }
}

// MARK: - Supporting Types

// MARK: - Supporting Types
// Claude: All shared types moved to CosmicHUDTypes.swift

// MARK: - Preview Helper
#if DEBUG
extension HUDGlyphMapper {
    /// Claude: Preview helper for testing glyph combinations
    static func previewExample() -> String {
        let ruler = rulerNumber(7)
        let aspect = aspectChain(planet1: .venus, aspect: .trine, planet2: .jupiter)
        let elem = element(for: .fire)

        return "\(ruler)   \(aspect)   \(elem)"
    }
}
#endif
