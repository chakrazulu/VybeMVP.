//
//  SacredGeometryView.swift
//  VybeMVP
//
//  Created by AI Assistant on 1/30/25.
//

import SwiftUI
import Foundation

/**
 * Sacred Geometry 2D Visualization System
 *
 * This view creates authentic, large-scale 2D sacred geometry patterns based on mystical traditions.
 * Each number generates unique geometric forms with precise mathematical relationships.
 *
 * Features:
 * - Large, impressive 2D sacred geometry patterns
 * - BPM-driven rotation effects
 * - Sacred color palettes for each number
 * - Mathematical precision based on ancient traditions
 * - Optimized for performance and visual impact
 */

// MARK: - Number Type Protocol
protocol SacredNumberType {
    var displayName: String { get }
    var geometryStyle: GeometryStyle { get }
}

struct FocusNumberType: SacredNumberType {
    let displayName = "Focus"
    let geometryStyle = GeometryStyle.mandala
}

struct RealmNumberType: SacredNumberType {
    let displayName = "Realm"
    let geometryStyle = GeometryStyle.spiral
}

// MARK: - Geometry Styles
enum GeometryStyle {
    case mandala    // Complex mandala patterns
    case spiral     // Golden ratio spirals and torus patterns
    case flower     // Flower of life patterns
    case crystal    // Crystalline structures
}

// MARK: - 2D Sacred Geometry View
struct SacredGeometryView<NumberType: SacredNumberType>: View {
    let numberType: NumberType
    let number: Int              // 1-9
    let bpm: Double             // Drive animation speed
    let realm: Int              // Extra parameter for complexity
    
    @State private var animationRotation: Double = 0
    
    var body: some View {
        ZStack {
            // Background energy field
            RadialGradient(
                gradient: Gradient(colors: [
                    getSacredColor(for: number).opacity(0.4),
                    getSacredColor(for: number).opacity(0.2),
                    Color.clear
                ]),
                center: .center,
                startRadius: 30,
                endRadius: 200
            )
            
            // Main Sacred Geometry Pattern
            getSacredGeometryShape(for: number)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            getSacredColor(for: number),
                            getSacredColor(for: number).opacity(0.8),
                            Color.white.opacity(0.6)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                )
                .shadow(color: getSacredColor(for: number).opacity(0.8), radius: 15)
                .shadow(color: getSacredColor(for: number).opacity(0.4), radius: 30)
                .rotationEffect(.degrees(animationRotation))
        }
        .onAppear {
            startAnimations()
        }
        .onChange(of: bpm) { _, _ in
            updateAnimationSpeed()
        }
    }
    
    // MARK: - Sacred Geometry Shapes
    
    private func getSacredGeometryShape(for number: Int) -> some Shape {
        switch number {
        case 1:
            return AnyShape(UnityCircleShape())
        case 2:
            return AnyShape(VesicaPiscisShape())
        case 3:
            return AnyShape(TriangleShape())
        case 4:
            return AnyShape(SquareShape())
        case 5:
            return AnyShape(PentagramShape())
        case 6:
            return AnyShape(MerkabaShape())
        case 7:
            return AnyShape(SeedOfLifeShape())
        case 8:
            return AnyShape(OctagonShape())
        case 9:
            return AnyShape(EnneagramShape())
        default:
            return AnyShape(UnityCircleShape())
        }
    }
    
    // MARK: - Animation System
    
    private func startAnimations() {
        // Smooth rotation based on BPM
        withAnimation(.linear(duration: 60.0 / max(bpm, 1.0)).repeatForever(autoreverses: false)) {
            animationRotation = 360
        }
    }
    
    private func updateAnimationSpeed() {
        startAnimations()
    }
    
    // MARK: - Sacred Color System
    
    private func getSacredColor(for number: Int) -> Color {
        switch number {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        case 6: return .indigo
        case 7: return .purple
        case 8: return Color(red: 1.0, green: 0.8, blue: 0.0) // gold
        case 9: return .white
        default: return .white
        }
    }
}

// MARK: - AnyShape Wrapper
struct AnyShape: Shape {
    private let _path: (CGRect) -> Path
    
    init<S: Shape>(_ shape: S) {
        _path = { rect in
            shape.path(in: rect)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        return _path(rect)
    }
}

// MARK: - Sacred Geometry Shape Definitions

// 1 - Unity Circle with concentric rings
struct UnityCircleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let maxRadius = min(rect.width, rect.height) / 2 * 0.9
        
        // Multiple concentric circles representing layers of creation
        for i in 1...7 {
            let radius = maxRadius * CGFloat(i) / 7.0
            path.addEllipse(in: CGRect(
                x: center.x - radius,
                y: center.y - radius,
                width: radius * 2,
                height: radius * 2
            ))
        }
        
        // Central zero-point
        path.addEllipse(in: CGRect(
            x: center.x - 2,
            y: center.y - 2,
            width: 4,
            height: 4
        ))
        
        return path
    }
}

// 2 - Vesica Piscis (two overlapping circles)
struct VesicaPiscisShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 3
        let offset = radius * 0.6
        
        // Left circle (feminine)
        path.addEllipse(in: CGRect(
            x: center.x - offset - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        ))
        
        // Right circle (masculine)
        path.addEllipse(in: CGRect(
            x: center.x + offset - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        ))
        
        // Connecting lines
        path.move(to: CGPoint(x: center.x - offset, y: center.y - radius))
        path.addLine(to: CGPoint(x: center.x + offset, y: center.y - radius))
        path.move(to: CGPoint(x: center.x - offset, y: center.y + radius))
        path.addLine(to: CGPoint(x: center.x + offset, y: center.y + radius))
        
        return path
    }
}

// 3 - Equilateral Triangle with nested trinities
struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 * 0.8
        
        // Outer triangle
        for i in 0..<3 {
            let angle = Double(i) * 2 * Double.pi / 3 - Double.pi / 2
            let x = center.x + radius * CGFloat(Foundation.cos(angle))
            let y = center.y + radius * CGFloat(Foundation.sin(angle))
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        
        // Inner triangle (inverted)
        let innerRadius = radius * 0.6
        for i in 0..<3 {
            let angle = Double(i) * 2 * Double.pi / 3 + Double.pi / 2
            let x = center.x + innerRadius * CGFloat(Foundation.cos(angle))
            let y = center.y + innerRadius * CGFloat(Foundation.sin(angle))
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        
        // Center lines to create trinity
        path.move(to: center)
        path.addLine(to: CGPoint(x: center.x, y: center.y - radius))
        path.move(to: center)
        path.addLine(to: CGPoint(x: center.x - radius * 0.866, y: center.y + radius * 0.5))
        path.move(to: center)
        path.addLine(to: CGPoint(x: center.x + radius * 0.866, y: center.y + radius * 0.5))
        
        return path
    }
}

// 4 - Square with rotated diamond and cardinal directions
struct SquareShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let size = min(rect.width, rect.height) * 0.7
        let halfSize = size / 2
        
        // Outer square
        path.addRect(CGRect(
            x: center.x - halfSize,
            y: center.y - halfSize,
            width: size,
            height: size
        ))
        
        // Inner rotated diamond
        let diamondSize = size * 0.7
        let diamondRadius = diamondSize / 2
        let diamondPoints = [
            CGPoint(x: center.x, y: center.y - diamondRadius),
            CGPoint(x: center.x + diamondRadius, y: center.y),
            CGPoint(x: center.x, y: center.y + diamondRadius),
            CGPoint(x: center.x - diamondRadius, y: center.y)
        ]
        
        path.move(to: diamondPoints[0])
        for i in 1..<diamondPoints.count {
            path.addLine(to: diamondPoints[i])
        }
        path.closeSubpath()
        
        // Cardinal direction lines
        path.move(to: CGPoint(x: center.x - halfSize, y: center.y))
        path.addLine(to: CGPoint(x: center.x + halfSize, y: center.y))
        path.move(to: CGPoint(x: center.x, y: center.y - halfSize))
        path.addLine(to: CGPoint(x: center.x, y: center.y + halfSize))
        
        return path
    }
}

// 5 - Perfect Pentagram with golden ratio
struct PentagramShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 * 0.8
        
        // Outer pentagon
        var outerPoints: [CGPoint] = []
        for i in 0..<5 {
            let angle = Double(i) * 2 * Double.pi / 5 - Double.pi / 2
            let x = center.x + radius * CGFloat(Foundation.cos(angle))
            let y = center.y + radius * CGFloat(Foundation.sin(angle))
            outerPoints.append(CGPoint(x: x, y: y))
        }
        
        // Draw pentagram (star)
        for i in 0..<5 {
            let startPoint = outerPoints[i]
            let endPoint = outerPoints[(i + 2) % 5]
            
            if i == 0 {
                path.move(to: startPoint)
            } else {
                path.move(to: startPoint)
            }
            path.addLine(to: endPoint)
        }
        
        // Inner pentagon (golden ratio)
        let innerRadius = radius * 0.382 // Golden ratio conjugate
        for i in 0..<5 {
            let angle = Double(i) * 2 * Double.pi / 5 - Double.pi / 2
            let x = center.x + innerRadius * CGFloat(Foundation.cos(angle))
            let y = center.y + innerRadius * CGFloat(Foundation.sin(angle))
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        
        return path
    }
}

// 6 - Star of David (Merkaba) with upper and lower triangles
struct MerkabaShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 * 0.8
        
        // Upper triangle (masculine, fire)
        for i in 0..<3 {
            let angle = Double(i) * 2 * Double.pi / 3 - Double.pi / 2
            let x = center.x + radius * CGFloat(Foundation.cos(angle))
            let y = center.y + radius * CGFloat(Foundation.sin(angle))
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        
        // Lower triangle (feminine, water) - inverted
        for i in 0..<3 {
            let angle = Double(i) * 2 * Double.pi / 3 + Double.pi / 2
            let x = center.x + radius * CGFloat(Foundation.cos(angle))
            let y = center.y + radius * CGFloat(Foundation.sin(angle))
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        
        // Inner hexagon
        let innerRadius = radius * 0.5
        for i in 0..<6 {
            let angle = Double(i) * Double.pi / 3
            let x = center.x + innerRadius * CGFloat(Foundation.cos(angle))
            let y = center.y + innerRadius * CGFloat(Foundation.sin(angle))
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        
        return path
    }
}

// 7 - Seed of Life (6 circles + 1 center) with heptagram
struct SeedOfLifeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 4
        
        // Central circle (the 7th, the mystery)
        path.addEllipse(in: CGRect(
            x: center.x - radius * 0.6,
            y: center.y - radius * 0.6,
            width: radius * 1.2,
            height: radius * 1.2
        ))
        
        // Six surrounding circles
        for i in 0..<6 {
            let angle = Double(i) * Double.pi / 3
            let x = center.x + radius * CGFloat(Foundation.cos(angle))
            let y = center.y + radius * CGFloat(Foundation.sin(angle))
            
            path.addEllipse(in: CGRect(
                x: x - radius * 0.5,
                y: y - radius * 0.5,
                width: radius,
                height: radius
            ))
        }
        
        // Heptagram overlay (7-pointed star)
        let starRadius = radius * 2.2
        for i in 0..<7 {
            let startAngle = Double(i) * 2 * Double.pi / 7 - Double.pi / 2
            let endAngle = Double((i + 3) % 7) * 2 * Double.pi / 7 - Double.pi / 2
            
            let startX = center.x + starRadius * CGFloat(Foundation.cos(startAngle))
            let startY = center.y + starRadius * CGFloat(Foundation.sin(startAngle))
            let endX = center.x + starRadius * CGFloat(Foundation.cos(endAngle))
            let endY = center.y + starRadius * CGFloat(Foundation.sin(endAngle))
            
            path.move(to: CGPoint(x: startX, y: startY))
            path.addLine(to: CGPoint(x: endX, y: endY))
        }
        
        return path
    }
}

// 8 - Octagon with 8-pointed star and infinity
struct OctagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 * 0.8
        
        // Octagon
        for i in 0..<8 {
            let angle = Double(i) * Double.pi / 4
            let x = center.x + radius * CGFloat(Foundation.cos(angle))
            let y = center.y + radius * CGFloat(Foundation.sin(angle))
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        
        // 8-pointed star
        let starRadius = radius * 1.2
        for i in 0..<8 {
            let innerAngle = Double(i) * Double.pi / 4
            let outerAngle = Double(i) * Double.pi / 4 + Double.pi / 8
            
            let innerX = center.x + radius * 0.4 * CGFloat(Foundation.cos(innerAngle))
            let innerY = center.y + radius * 0.4 * CGFloat(Foundation.sin(innerAngle))
            let outerX = center.x + starRadius * CGFloat(Foundation.cos(outerAngle))
            let outerY = center.y + starRadius * CGFloat(Foundation.sin(outerAngle))
            
            path.move(to: CGPoint(x: innerX, y: innerY))
            path.addLine(to: CGPoint(x: outerX, y: outerY))
        }
        
        // Infinity symbol at center
        let infinityWidth = radius * 0.6
        let infinityHeight = radius * 0.3
        
        // Left loop
        path.addEllipse(in: CGRect(
            x: center.x - infinityWidth * 0.75,
            y: center.y - infinityHeight / 2,
            width: infinityWidth / 2,
            height: infinityHeight
        ))
        
        // Right loop
        path.addEllipse(in: CGRect(
            x: center.x + infinityWidth * 0.25,
            y: center.y - infinityHeight / 2,
            width: infinityWidth / 2,
            height: infinityHeight
        ))
        
        return path
    }
}

// 9 - Enneagram with 9-point pattern and 3-6-9 triangle
struct EnneagramShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 * 0.8
        
        // Outer circle
        path.addEllipse(in: CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        ))
        
        // 9 points around the circle
        var points: [CGPoint] = []
        for i in 0..<9 {
            let angle = Double(i) * 2 * Double.pi / 9 - Double.pi / 2
            let x = center.x + radius * CGFloat(Foundation.cos(angle))
            let y = center.y + radius * CGFloat(Foundation.sin(angle))
            points.append(CGPoint(x: x, y: y))
            
            // Draw point
            path.addEllipse(in: CGRect(x: x - 3, y: y - 3, width: 6, height: 6))
        }
        
        // 3-6-9 triangle (positions 2, 5, 8 in 0-indexed array)
        let trianglePoints = [points[2], points[5], points[8]]
        path.move(to: trianglePoints[0])
        path.addLine(to: trianglePoints[1])
        path.addLine(to: trianglePoints[2])
        path.closeSubpath()
        
        // Enneagram inner connections (1-4-2-8-5-7-1)
        let connections = [0, 3, 1, 7, 4, 6, 0]
        for i in 0..<connections.count - 1 {
            path.move(to: points[connections[i]])
            path.addLine(to: points[connections[i + 1]])
        }
        
        // Central completion point
        path.addEllipse(in: CGRect(
            x: center.x - 4,
            y: center.y - 4,
            width: 8,
            height: 8
        ))
        
        return path
    }
}

// MARK: - Preview
struct SacredGeometryView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack(spacing: 20) {
                SacredGeometryView<FocusNumberType>(
                    numberType: FocusNumberType(),
                    number: 3,
                    bpm: 72.0,
                    realm: 4
                )
                .frame(width: 300, height: 300)
                
                SacredGeometryView<RealmNumberType>(
                    numberType: RealmNumberType(),
                    number: 7,
                    bpm: 72.0,
                    realm: 3
                )
                .frame(width: 300, height: 300)
            }
        }
        .background(Color.black)
    }
}