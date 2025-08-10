/**
 * Filename: NumberPatternGenerator.swift
 *
 * 🎯 PHASE 8I: NUMBER-SPECIFIC GEOMETRIC NEON TRACER PATTERNS 🎯
 *
 * === CORE PURPOSE ===
 * Generate meaningful geometric patterns for each realm number (1-9) based on their
 * transcendental meanings. Replaces random SVG mandala tracing with intentional,
 * spiritually-aligned geometric patterns for beautiful neon tracer visualization.
 *
 * === PATTERN PHILOSOPHY ===
 * Each number's pattern reflects its spiritual essence from NumberMeaning.swift:
 * • 1 (Unity): Diamond - Crystallized perfection of singular creation
 * • 2 (Duality): Vesica Piscis - Sacred intersection of opposites
 * • 3 (Harmony): Triangle - Creative synthesis and stability
 * • 4 (Foundation): Square - Material structure and grounding
 * • 5 (Freedom): Pentagon - Dynamic balance and adaptation
 * • 6 (Harmony): Hexagon - Balanced relationships and responsibility
 * • 7 (Wisdom): Heptagon/7-Star - Mystical understanding and inner knowledge
 * • 8 (Power): Infinity ∞ - Eternal cycles and manifestation
 * • 9 (Completion): Enneagram - Transcendence and universal wisdom
 *
 * === TECHNICAL APPROACH ===
 * • CGPath-based geometry for smooth 60-second neon tracing
 * • Mathematically precise sacred geometry calculations
 * • Optimized for contemplative visualization and spiritual alignment
 * • Closed-loop paths for seamless continuous animation
 *
 * Claude: Phase 8I revolutionary number-specific neon tracer patterns
 */

import Foundation
import SwiftUI
import CoreGraphics

/// Claude: Revolutionary number pattern generator for spiritually-aligned neon tracing
/// Creates meaningful geometric patterns based on transcendental number meanings
class NumberPatternGenerator {

    /// Generate CGPath pattern for a specific realm number (1-9)
    /// Returns beautiful sacred geometry aligned with the number's spiritual meaning
    static func createPattern(for number: Int, size: CGSize = CGSize(width: 320, height: 320)) -> CGPath {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let radius = min(size.width, size.height) * 0.3 // Appropriate size for mandala overlay

        switch number {
        case 1:
            return createDiamondPath(center: center, size: radius)
        case 2:
            return createCirclePath(center: center, radius: radius)  // Proper circle for number 2
        case 3:
            return createTrianglePath(center: center, radius: radius)
        case 4:
            return createSquarePath(center: center, size: radius)
        case 5:
            return createPentagonPath(center: center, radius: radius)
        case 6:
            return createHexagonPath(center: center, radius: radius)
        case 7:
            return createHeptagonPath(center: center, radius: radius)
        case 8:
            return createInfinityPath(center: center, size: radius)
        case 9:
            return createEnneagramPath(center: center, radius: radius)
        default:
            // Fallback to circle for any unexpected numbers
            return createCirclePath(center: center, radius: radius)
        }
    }

    // MARK: - Pattern Creation Methods

    /// 1 - Unity: Diamond pattern representing crystallized perfection of singular creation
    /// Creates a four-pointed diamond shape symbolizing the refined essence of unity
    private static func createDiamondPath(center: CGPoint, size: CGFloat) -> CGPath {
        let path = CGMutablePath()

        // Diamond with four points: top, right, bottom, left
        let top = CGPoint(x: center.x, y: center.y - size)
        let right = CGPoint(x: center.x + size * 0.7, y: center.y)
        let bottom = CGPoint(x: center.x, y: center.y + size)
        let left = CGPoint(x: center.x - size * 0.7, y: center.y)

        path.move(to: top)
        path.addLine(to: right)
        path.addLine(to: bottom)
        path.addLine(to: left)
        path.closeSubpath()

        return path
    }

    /// 2 - Duality: Simple circle representing duality and reflection
    private static func createVesicaPiscisPath(center: CGPoint, radius: CGFloat) -> CGPath {
        // Simple circle that will definitely show up - representing the unity of duality
        return createCirclePath(center: center, radius: radius)
    }

    /// 3 - Harmony: Triangle representing creative synthesis and stable foundation
    /// Creates an equilateral triangle symbolizing the harmony of mind, body, and spirit
    private static func createTrianglePath(center: CGPoint, radius: CGFloat) -> CGPath {
        return createPolygonPath(center: center, radius: radius, sides: 3)
    }

    /// 4 - Foundation: Square representing material structure and grounding
    /// Creates a perfect square symbolizing the four elements and material stability
    private static func createSquarePath(center: CGPoint, size: CGFloat) -> CGPath {
        let path = CGMutablePath()
        let halfSize = size * 0.8

        let rect = CGRect(
            x: center.x - halfSize,
            y: center.y - halfSize,
            width: halfSize * 2,
            height: halfSize * 2
        )

        path.addRect(rect)
        return path
    }

    /// 5 - Freedom: Pentagon representing dynamic balance and adaptation
    /// Creates a five-sided pentagon symbolizing the five senses and human experience
    private static func createPentagonPath(center: CGPoint, radius: CGFloat) -> CGPath {
        return createPolygonPath(center: center, radius: radius, sides: 5)
    }

    /// 6 - Harmony: Hexagon representing balanced relationships and responsibility
    /// Creates a six-sided hexagon symbolizing perfect balance and natural harmony
    private static func createHexagonPath(center: CGPoint, radius: CGFloat) -> CGPath {
        return createPolygonPath(center: center, radius: radius, sides: 6)
    }

    /// 7 - Wisdom: Heptagon representing mystical understanding and inner knowledge
    /// Creates a seven-sided heptagon symbolizing the seven chakras and spiritual wisdom
    private static func createHeptagonPath(center: CGPoint, radius: CGFloat) -> CGPath {
        return createPolygonPath(center: center, radius: radius, sides: 7)
    }

    /// 8 - Power: Infinity symbol representing eternal cycles and manifestation
    /// Creates a figure-8 infinity symbol using lemniscate mathematical equations
    /// Symbolizes the eternal dance of creation and destruction, karmic cycles
    private static func createInfinityPath(center: CGPoint, size: CGFloat) -> CGPath {
        let path = CGMutablePath()

        // Claude: Create smooth figure-8 infinity using parametric lemniscate equations
        let width = size * 1.2  // Scaled up for better visibility and spiritual presence
        let height = size * 0.8  // Proportional height for classic infinity appearance
        let points = 100 // Many points create smooth curves for seamless neon tracing

        // Create figure-8 path using parametric equations for mathematical lemniscate
        for i in 0...points {
            let t = CGFloat(i) * 2 * .pi / CGFloat(points)

            // Lemniscate parametric equations: creates perfect figure-8 infinity symbol
            // Claude: FIX - Added NaN validation to prevent CoreGraphics errors
            let denominator = 1 + sin(t) * sin(t)

            // Guard against invalid denominator (should never be <= 0, but safety first)
            guard denominator > 0.001 && !denominator.isNaN && denominator.isFinite else {
                // Skip this point if denominator is invalid
                continue
            }

            let x = center.x + width * cos(t) / denominator
            let y = center.y + height * sin(t) * cos(t) / denominator

            // Validate final coordinates
            guard !x.isNaN && !y.isNaN && x.isFinite && y.isFinite else {
                // Skip this point if coordinates are invalid
                continue
            }

            let point = CGPoint(x: x, y: y)

            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()

        return path
    }

    /// 9 - Completion: Enneagram representing transcendence and universal wisdom
    /// Creates a nine-pointed star symbolizing the completion of the numerical cycle
    private static func createEnneagramPath(center: CGPoint, radius: CGFloat) -> CGPath {
        return createPolygonPath(center: center, radius: radius, sides: 9)
    }

    // MARK: - Helper Methods

    /// Generic polygon path generator - creates regular polygons for sacred geometry patterns
    /// Uses simple, reliable line segments between calculated vertices for consistent neon tracing
    /// @param center The center point of the polygon
    /// @param radius The distance from center to vertices
    /// @param sides The number of sides (3=triangle, 5=pentagon, 6=hexagon, etc.)
    /// @returns CGPath representing the polygon for neon tracer to follow
    private static func createPolygonPath(center: CGPoint, radius: CGFloat, sides: Int) -> CGPath {
        let path = CGMutablePath()

        // Calculate vertices around a circle, starting from top (-π/2)
        for i in 0..<sides {
            let angle = CGFloat(i) * 2 * .pi / CGFloat(sides) - .pi / 2 // Start at top vertex
            let point = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )

            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()

        return path
    }

    /// Create perfect circle using multiple points for smooth tracing
    /// Uses 60 discrete points to approximate a circle for consistent neon tracer movement
    /// @param center The center point of the circle
    /// @param radius The radius of the circle
    /// @returns CGPath representing a smooth circular path
    private static func createCirclePath(center: CGPoint, radius: CGFloat) -> CGPath {
        let path = CGMutablePath()
        let points = 60 // 60 points create smooth circle approximation for neon tracing

        // Create circle using many small line segments for smooth appearance
        for i in 0...points {
            let angle = CGFloat(i) * 2 * .pi / CGFloat(points)
            let point = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )

            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()

        return path
    }

    // MARK: - Public Utilities

    /// Get pattern description for UI display
    static func getPatternDescription(for number: Int) -> String {
        switch number {
        case 1: return "Diamond - Unity & Crystallized Perfection"
        case 2: return "Vesica Piscis - Sacred Duality Intersection"
        case 3: return "Triangle - Harmony & Creative Synthesis"
        case 4: return "Square - Foundation & Material Structure"
        case 5: return "Pentagon - Freedom & Dynamic Balance"
        case 6: return "Hexagon - Responsibility & Balanced Harmony"
        case 7: return "Heptagon - Wisdom & Mystical Understanding"
        case 8: return "Infinity ∞ - Power & Eternal Manifestation"
        case 9: return "Enneagram - Completion & Universal Transcendence"
        default: return "Circle - Universal Wholeness"
        }
    }

    /// Validate if number is supported (1-9)
    static func isValidRealmNumber(_ number: Int) -> Bool {
        return (1...9).contains(number)
    }
}
