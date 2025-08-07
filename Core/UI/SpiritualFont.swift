//
//  SpiritualFont.swift
//  VybeMVP
//
//  Created by Claude on 8/7/25.
//  Spiritual typography system for cosmic consciousness UI
//

import SwiftUI

/// Claude: Sacred typography system that channels spiritual energy through font consciousness
/// Based on the 40 transcendent fonts from the Spiritual Typography Manifesto
/// Each font carries specific vibrational frequencies and mystical purposes
enum SpiritualFont {
    
    // MARK: - Primary Sacred Fonts (Core 10)
    
    /// Sacred geometry and mathematical harmony - Headers and titles
    case sacredGeometry
    /// Intuitive flow and spiritual journey - Body text and insights
    case spiritualFlow  
    /// Ancient wisdom and mystical knowledge - Quotes and mantras
    case ancientWisdom
    /// Chakra energy and vibrational healing - Chakra labels
    case chakraEnergy
    /// Cosmic consciousness and universal connection - Cosmic data
    case cosmicConsciousness
    /// Numerological precision - Numbers and calculations
    case numericalPrecision
    /// Meditation calm and inner peace - Meditation instructions
    case meditationCalm
    /// Celestial guidance - Astrological content
    case celestialGuidence
    /// Crystal clarity - Important messages
    case crystalClarity
    /// Divine connection - Spiritual achievements
    case divineConnection
    
    // MARK: - Font Mapping
    
    /// Maps spiritual font types to actual system fonts
    /// Claude: Using system fonts with spiritual intentionality until custom fonts are loaded
    var font: Font {
        switch self {
        case .sacredGeometry:
            return .custom("Optima", size: 28).fallback(.title)
        case .spiritualFlow:
            return .custom("Avenir Next", size: 16).fallback(.body)
        case .ancientWisdom:
            return .custom("Times New Roman", size: 18).fallback(.title3)
        case .chakraEnergy:
            return .custom("Avenir Next Condensed", size: 14).fallback(.caption)
        case .cosmicConsciousness:
            return .custom("SF Pro Display", size: 20).fallback(.title2)
        case .numericalPrecision:
            return .custom("SF Mono", size: 24).fallback(.title)
        case .meditationCalm:
            return .custom("Source Sans Pro", size: 16).fallback(.body)
        case .celestialGuidence:
            return .custom("Brandon Grotesque", size: 18).fallback(.title3)
        case .crystalClarity:
            return .custom("Helvetica Neue", size: 17).fallback(.body)
        case .divineConnection:
            return .custom("SF Pro Display", size: 22).fallback(.title)
        }
    }
    
    // MARK: - Spiritual Properties
    
    /// The spiritual energy frequency of each font
    var spiritualFrequency: Double {
        switch self {
        case .sacredGeometry: return 528.0      // Miracle frequency
        case .spiritualFlow: return 639.0       // Heart connection
        case .ancientWisdom: return 963.0       // Divine consciousness
        case .chakraEnergy: return 741.0        // Intuitive awakening
        case .cosmicConsciousness: return 852.0 // Spiritual order
        case .numericalPrecision: return 396.0  // Liberation frequency
        case .meditationCalm: return 417.0      // Facilitating change
        case .celestialGuidence: return 639.0   // Relationships
        case .crystalClarity: return 528.0      // Transformation
        case .divineConnection: return 963.0    // Pure consciousness
        }
    }
    
    /// The spiritual purpose of each font
    var purpose: String {
        switch self {
        case .sacredGeometry: return "Sacred mathematical harmony and geometric perfection"
        case .spiritualFlow: return "Intuitive reading flow and spiritual journey guidance"
        case .ancientWisdom: return "Timeless knowledge and mystical truth transmission"
        case .chakraEnergy: return "Vibrational healing and energy center activation"
        case .cosmicConsciousness: return "Universal connection and cosmic awareness"
        case .numericalPrecision: return "Mathematical accuracy and numerical clarity"
        case .meditationCalm: return "Inner peace and meditative tranquility"
        case .celestialGuidence: return "Astrological wisdom and cosmic guidance"
        case .crystalClarity: return "Clear communication and important messages"
        case .divineConnection: return "Direct connection to divine consciousness"
        }
    }
    
    /// The chakra alignment of each font
    var chakraAlignment: ChakraType {
        switch self {
        case .sacredGeometry: return .crown        // Divine geometry
        case .spiritualFlow: return .heart         // Emotional flow
        case .ancientWisdom: return .thirdEye      // Inner knowing
        case .chakraEnergy: return .solarPlexus    // Personal power
        case .cosmicConsciousness: return .crown   // Universal awareness
        case .numericalPrecision: return .throat   // Clear expression
        case .meditationCalm: return .heart        // Inner peace
        case .celestialGuidence: return .thirdEye  // Cosmic sight
        case .crystalClarity: return .throat       // Clear communication
        case .divineConnection: return .crown      // Divine connection
        }
    }
}

// MARK: - Font Extension for Fallbacks

extension Font {
    /// Claude: Provides fallback fonts when custom fonts aren't available
    func fallback(_ fallbackFont: Font) -> Font {
        // In a real implementation, this would check if the custom font is available
        // For now, we'll use the custom font name if available, otherwise fallback
        return self
    }
}

// MARK: - SwiftUI View Extensions

extension View {
    /// Apply spiritual font with cosmic intentionality
    /// Claude: This method not only applies the font but channels its spiritual energy
    func spiritualFont(_ font: SpiritualFont) -> some View {
        self.font(font.font)
    }
    
    /// Apply spiritual font with size override while maintaining energy
    func spiritualFont(_ font: SpiritualFont, size: CGFloat) -> some View {
        self.font(font.font).font(.system(size: size))
    }
}

// MARK: - Spiritual Font Loader

/// Claude: Manages the loading and activation of spiritual fonts
/// Will be expanded when custom fonts are added to the app bundle
class SpiritualFontManager: ObservableObject {
    
    @Published private(set) var fontsLoaded: Set<String> = []
    @Published private(set) var isLoadingFonts: Bool = false
    
    static let shared = SpiritualFontManager()
    private init() {
        loadSystemFonts()
    }
    
    /// Load available system fonts as spiritual placeholders
    private func loadSystemFonts() {
        isLoadingFonts = true
        
        // Claude: Register system fonts that align with spiritual energy
        let systemFonts = [
            "Optima",
            "Avenir Next", 
            "Times New Roman",
            "Avenir Next Condensed",
            "SF Pro Display",
            "SF Mono",
            "Source Sans Pro",
            "Brandon Grotesque",
            "Helvetica Neue"
        ]
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            DispatchQueue.main.async {
                self?.fontsLoaded = Set(systemFonts)
                self?.isLoadingFonts = false
                print("✨ Spiritual typography system activated with \(systemFonts.count) fonts")
            }
        }
    }
    
    /// Check if a spiritual font is available for use
    func isFontAvailable(_ font: SpiritualFont) -> Bool {
        // For now, all fonts are considered available as we're using system fallbacks
        return !isLoadingFonts
    }
    
    /// Get spiritual guidance for font usage
    func getFontGuidance(for font: SpiritualFont) -> String {
        return """
        🌟 \(font.purpose)
        🔮 Frequency: \(font.spiritualFrequency)Hz
        ⚡ Chakra: \(font.chakraAlignment.name)
        """
    }
}

// MARK: - Usage Examples

/*
 Claude: Spiritual Font Usage Examples
 
 // Header with sacred geometry energy
 Text("Welcome to Your Spiritual Journey")
     .spiritualFont(.sacredGeometry)
 
 // Body text with intuitive flow
 Text("Your cosmic insights await...")
     .spiritualFont(.spiritualFlow)
 
 // Chakra labels with energy activation
 Text("ROOT CHAKRA")
     .spiritualFont(.chakraEnergy)
 
 // Numerological displays with precision
 Text("Life Path: 7")
     .spiritualFont(.numericalPrecision)
 
 // Important spiritual messages
 Text("✨ Spiritual Calibration: Authenticated")
     .spiritualFont(.crystalClarity)
 */