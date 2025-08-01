//
//  WidgetInsightTemplates.swift
//  CosmicHUDWidget
//
//  Created by Claude on 8/1/25.
//

import Foundation

/// Claude: Widget-specific insight templates to prevent text cutoff issues
/// Different character limits for different widget sizes ensure proper display
struct WidgetInsightTemplates {
    
    // MARK: - Character Limits by Widget Size
    static let smallWidgetLimit = 0     // No insights for small widget
    static let mediumWidgetLimit = 30   // Medium widget - brief insights (reduced to prevent cutoff)
    static let largeWidgetLimit = 120   // Large widget - comprehensive insights
    static let rectangularLimit = 20    // Lock screen - ultra brief
    
    // MARK: - Ruler Number Insights by Widget Size
    
    /// Small widget insights (not used - too small)
    static let smallRulerInsights: [Int: String] = [:]
    
    /// Medium widget insights (30 characters max)
    static let mediumRulerInsights: [Int: String] = [
        1: "Lead with confidence",
        2: "Seek harmony today", 
        3: "Express creativity",
        4: "Build foundations",
        5: "Embrace change",
        6: "Nurture with love",
        7: "Trust inner wisdom",
        8: "Manifest success",
        9: "Serve others"
    ]
    
    /// Large widget insights (120 characters max)
    static let largeRulerInsights: [Int: String] = [
        1: "Leadership energy peaks. Take initiative in personal projects. Your pioneering spirit opens new pathways.",
        2: "Harmony guides decisions. Balance opposing forces with grace. Cooperation brings unexpected opportunities.",
        3: "Creative expression flows. Share your artistic gifts boldly. Communication opens hearts and minds today.",
        4: "Foundation building strengthens. Focus on practical matters. Steady progress creates lasting security.",
        5: "Freedom calls for adventure. Break routine patterns safely. Change brings growth and fresh perspectives.",
        6: "Nurturing love transforms lives. Care for others and yourself. Healing energy radiates from your heart.",
        7: "Deep wisdom emerges clearly. Trust intuitive insights fully. Spiritual understanding illuminates your path.",
        8: "Manifestation power peaks strongly. Business ventures flourish now. Material goals align with effort.",
        9: "Service completes the cycle. Share wisdom generously today. Universal love guides every interaction."
    ]
    
    /// Rectangular widget insights (20 characters max)
    static let rectangularRulerInsights: [Int: String] = [
        1: "Lead boldly",
        2: "Find balance", 
        3: "Create freely",
        4: "Build steady",
        5: "Seek change",
        6: "Love deeply",
        7: "Trust wisdom",
        8: "Manifest goals",
        9: "Serve others"
    ]
    
    // MARK: - Aspect-Based Insights by Widget Size
    
    /// Medium widget aspect insights (40 characters max)
    static let mediumAspectInsights: [String: String] = [
        "conjunction": "Unified planetary energy flows",
        "opposition": "Balance opposing cosmic forces", 
        "trine": "Harmonious energy creates flow",
        "square": "Dynamic tension sparks growth",
        "sextile": "Gentle opportunities emerge",
        "quincunx": "Divine adjustments align you"
    ]
    
    /// Large widget aspect insights (120 characters max)
    static let largeAspectInsights: [String: String] = [
        "conjunction": "Planetary energies unite in powerful synthesis. This alignment amplifies shared qualities and creates focused intention.",
        "opposition": "Cosmic forces seek perfect balance and integration. Tension between polarities creates awareness and growth opportunities.", 
        "trine": "Harmonious planetary flow supports natural expression. Energy moves freely between aligned cosmic influences today.",
        "square": "Dynamic planetary tension creates transformative pressure. Challenge sparks innovation and breakthrough potential.",
        "sextile": "Gentle cosmic opportunities invite conscious participation. Supportive energy rewards focused intention and effort.",
        "quincunx": "Divine cosmic adjustment requires conscious adaptation. Flexibility transforms challenge into spiritual growth."
    ]
    
    /// Rectangular widget aspect insights (20 characters max)
    static let rectangularAspectInsights: [String: String] = [
        "conjunction": "Unity flows",
        "opposition": "Seek balance", 
        "trine": "Harmony flows",
        "square": "Growth sparks",
        "sextile": "Opportunity",
        "quincunx": "Adjust gently"
    ]
    
    // MARK: - Comprehensive Insight Generation
    
    /// Generate widget-appropriate insight combining ruler number and aspect
    static func generateInsight(
        rulerNumber: Int,
        aspectType: String,
        widgetSize: WidgetSize
    ) -> String {
        switch widgetSize {
        case .small:
            return "" // No insight for small widget
            
        case .medium:
            let rulerInsight = mediumRulerInsights[rulerNumber] ?? "Cosmic energy flows"
            let aspectInsight = mediumAspectInsights[aspectType] ?? "Energy aligns"
            // Combine and truncate to limit
            let combined = "\(rulerInsight). \(aspectInsight)."
            return String(combined.prefix(mediumWidgetLimit))
            
        case .large:
            let rulerInsight = largeRulerInsights[rulerNumber] ?? "Cosmic wisdom guides your spiritual journey with authentic purpose and divine timing."
            // Use full ruler insight for large widget
            return String(rulerInsight.prefix(largeWidgetLimit))
            
        case .accessoryRectangular:
            return rectangularRulerInsights[rulerNumber] ?? "Flow"
        }
    }
    
    /// Generate aspect-specific insight for different widget sizes
    static func generateAspectInsight(
        aspectType: String,
        planets: [String],
        widgetSize: WidgetSize
    ) -> String {
        let planet1 = planets.first?.capitalized ?? "Cosmic"
        let planet2 = planets.count > 1 ? planets[1].capitalized : "Energy"
        
        switch widgetSize {
        case .small:
            return ""
            
        case .medium:
            let template = mediumAspectInsights[aspectType] ?? "Energy flows"
            return String(template.prefix(mediumWidgetLimit))
            
        case .large:
            let template = largeAspectInsights[aspectType] ?? "Cosmic forces create dynamic interaction between \(planet1) and \(planet2) energies for spiritual growth."
            return String(template.prefix(largeWidgetLimit))
            
        case .accessoryRectangular:
            return rectangularAspectInsights[aspectType] ?? "Flow"
        }
    }
}

/// Widget size enumeration for template selection
enum WidgetSize {
    case small
    case medium  
    case large
    case accessoryRectangular
}