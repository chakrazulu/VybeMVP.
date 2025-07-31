import Foundation
import ActivityKit

// MARK: - Cosmic HUD Shared Types
/// Claude: Self-contained types for the Cosmic HUD system
/// These are independent of the main app's cosmic calculation types

// MARK: - Core HUD Enums (Available to both targets)

/// HUD-specific planet enum
enum HUDPlanet: String, CaseIterable {
    case sun = "sun"
    case moon = "moon"
    case mercury = "mercury"
    case venus = "venus"
    case mars = "mars"
    case jupiter = "jupiter"
    case saturn = "saturn"
    case uranus = "uranus"
    case neptune = "neptune"
    case pluto = "pluto"
    
    var name: String {
        return rawValue.capitalized
    }
    
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

/// HUD-specific aspect enum
enum HUDAspect: String, CaseIterable {
    case conjunction = "conjunction"
    case opposition = "opposition"
    case trine = "trine"
    case square = "square"
    case sextile = "sextile"
    case quincunx = "quincunx"
    
    var name: String {
        return rawValue.capitalized
    }
    
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
}

/// HUD-specific element enum
enum HUDElement: String, CaseIterable {
    case fire = "fire"
    case earth = "earth"
    case air = "air"
    case water = "water"
    
    var name: String {
        return rawValue.capitalized
    }
    
    var emoji: String {
        switch self {
        case .fire: return "🔥"
        case .earth: return "🌱"
        case .air: return "💨"
        case .water: return "💧"
        }
    }
}

// MARK: - Type Aliases (Available to both Main App and Widget Extension)
/// These provide compatibility with the main app's existing cosmic types
typealias CosmicElement = HUDElement
typealias CosmicAspect = HUDAspect

// MARK: - Live Activity Attributes
/// Claude: Shared Live Activity attributes that both main app and Widget Extension can use
struct CosmicHUDWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        /// Current ruler number (1-9)
        var rulerNumber: Int
        /// Current realm number from RealmNumberManager
        var realmNumber: Int
        /// Formatted planetary aspect display (e.g., "♀ △ ♃")
        var aspectDisplay: String
        /// Current elemental energy emoji
        var element: String
        /// Last update timestamp
        var lastUpdate: Date
    }
    
    // Fixed attributes (don't change during the Live Activity)
    // Currently empty - all our data is dynamic
}

// MARK: - HUD-Specific Data Structures (Main App Only)
/// These types are only used by the main app for internal HUD calculations
/// The Widget Extension only receives the simple strings above

#if !WIDGET_EXTENSION

/// Complete HUD data structure
struct HUDData {
    let rulerNumber: Int
    let dominantAspect: AspectData?
    let element: HUDElement
    let lastCalculated: Date
    let allAspects: [AspectData]
    
    /// Formatted display string for compact HUD
    var compactDisplay: String {
        let ruler = "👑\(rulerNumber)"
        let elem = element.emoji
        
        guard let aspect = dominantAspect else {
            return "\(ruler)   No aspects   \(elem)"
        }
        
        let aspectChain = "\(aspect.planet1.symbol) \(aspect.aspect.symbol) \(aspect.planet2.symbol)"
        
        return "\(ruler)   \(aspectChain)   \(elem)"
    }
}

/// Individual aspect data
struct AspectData {
    let planet1: HUDPlanet
    let planet2: HUDPlanet
    let aspect: HUDAspect
    let orb: Double
    let isApplying: Bool
    
    var description: String {
        return "\(planet1.name) \(aspect.name) \(planet2.name)"
    }
}

/// Halo style for ruler number display
enum HaloStyle: String, CaseIterable {
    case star = "star"
    case crown = "crown"
    case sparkles = "sparkles"
    
    var symbol: String {
        switch self {
        case .star: return "⭐"
        case .crown: return "👑"
        case .sparkles: return "✨"
        }
    }
}

/// HUD Intent types
enum HUDIntent: String, CaseIterable {
    case sighting = "sighting"
    case journal = "journal"
    case composer = "composer"
    case rulerGraph = "rulerGraph"
    case focusSelector = "focusSelector"
    case cosmicSnapshot = "cosmicSnapshot"
    
    // Alternative case names for backward compatibility
    static var addSighting: HUDIntent { return .sighting }
    static var addJournalEntry: HUDIntent { return .journal }
    static var postStatus: HUDIntent { return .composer }
    static var changeFocusNumber: HUDIntent { return .focusSelector }
    
    var displayName: String {
        switch self {
        case .sighting:
            return "Add Sighting"
        case .journal:
            return "Journal Entry"
        case .composer:
            return "Post Status"
        case .rulerGraph:
            return "Ruler Graph"
        case .focusSelector:
            return "Change Focus"
        case .cosmicSnapshot:
            return "Cosmic Snapshot"
        }
    }
    
    var icon: String {
        switch self {
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
}

#endif

/// Insight generation types for tracking
enum InsightType {
    case kasper
    case template
    case wisdom
    
    var displayName: String {
        switch self {
        case .kasper:
            return "KASPER AI Insight"
        case .template:
            return "Cosmic Template"
        case .wisdom:
            return "Universal Wisdom"
        }
    }
    
    var icon: String {
        switch self {
        case .kasper:
            return "✨"
        case .template:
            return "📜"
        case .wisdom:
            return "🌌"
        }
    }
}

// MARK: - Conversion Extensions (Main App Only)
#if !WIDGET_EXTENSION

/// Claude: Helper extensions for converting between existing CosmicData types and HUD types
extension HUDPlanet {
    static func from(string: String) -> HUDPlanet? {
        switch string.lowercased() {
        case "sun": return .sun
        case "moon": return .moon
        case "mercury": return .mercury
        case "venus": return .venus
        case "mars": return .mars
        case "jupiter": return .jupiter
        case "saturn": return .saturn
        case "uranus": return .uranus
        case "neptune": return .neptune
        case "pluto": return .pluto
        default: return nil
        }
    }
}

/// Claude: Helper extensions for converting between existing CosmicData types and HUD types
extension HUDAspect {
    static func from(aspectType: String) -> HUDAspect {
        // Convert CosmicData aspect type strings to HUDAspect
        switch aspectType.lowercased() {
        case "conjunction":
            return .conjunction
        case "opposition":
            return .opposition
        case "trine":
            return .trine
        case "square":
            return .square
        case "sextile":
            return .sextile
        case "quincunx":
            return .quincunx
        default:
            return .conjunction // fallback
        }
    }
}

// Claude: Planet conversion removed to prevent Widget Extension compilation issues

#endif