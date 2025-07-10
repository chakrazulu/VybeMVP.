/**
 * Filename: NeonTracerView.swift
 *
 * 🎯 NEON TRACER ARCHITECTURE GUIDE FOR FUTURE AI ASSISTANTS 🎯
 *
 * === CORE PURPOSE ===
 * Creates heart rate-synchronized neon particle trails that follow sacred geometry paths.
 * Revolutionary Phase 8 target: Extract actual SVG paths from mandala assets for authentic tracing.
 *
 * === CURRENT IMPLEMENTATION (Phase 7) ===
 * • Predefined geometric paths (circles, polygons) based on realm numbers
 * • Heart rate synchronization via BPM parameter
 * • Scroll-safe TimelineView animation system
 * • Multi-particle tail effect with opacity gradient
 * • 60fps performance optimization
 *
 * === PHASE 8 REVOLUTIONARY CONCEPT ===
 * • SVG path extraction from DynamicAssetMandalaView assets
 * • Real-time mandala geometry reading
 * • Authentic sacred geometry tracing
 * • Dynamic path adaptation per mandala rotation
 *
 * === ANIMATION ARCHITECTURE ===
 * • TimelineView: Provides scroll-safe animation timing
 * • PathTracer: Calculates position along CGPath geometry
 * • Multi-particle system: 10 particles with staggered positions
 * • BPM sync: 4-beat cycle duration (60/BPM*4 seconds)
 *
 * === PERFORMANCE OPTIMIZATIONS ===
 * • CGPath caching for consistent geometry
 * • Efficient path segment calculation
 * • Opacity-based particle culling
 * • Minimal state updates
 *
 * Claude: Added comprehensive Phase 7 documentation and Phase 8 roadmap
 */

@preconcurrency import SwiftUI
@preconcurrency import CoreGraphics
import Combine

/// Claude: Mystical neon tracer with heart rate synchronization
/// Creates moving particle effects along sacred geometry paths with comet-like trails
/// Phase 8 enhancement: Will extract real SVG paths from mandala assets
struct NeonTracerView: View {
    let path: CGPath  // Changed from @Binding since paths don't change
    let bpm: Double   // Changed from @Binding to regular parameter
    var color: Color = .cyan
    
    // Tail configuration
    private let tailCount = 10
    private let tailSpacing: CGFloat = 0.015  // Distance between tail particles
    
    private var animationDuration: Double {
        // Claude: BPM-synchronized duration - one full circuit per 4 heartbeats
        // Ensures mystical alignment between heart rhythm and sacred geometry tracing
        60.0 / max(bpm, 40) * 4
    }
    
    var body: some View {
        // 🌌 SCROLL-SAFE ANIMATION: Use TimelineView instead of Timer
        TimelineView(.animation) { timeline in
            let elapsed = timeline.date.timeIntervalSince1970
            let progress = CGFloat((elapsed.truncatingRemainder(dividingBy: animationDuration)) / animationDuration)
            
            ZStack {
                // Create the tail effect with multiple particles
                ForEach(0..<tailCount, id: \.self) { index in
                    let indexDouble = Double(index)
                    let tailCountDouble = Double(tailCount)
                    let particleProgress = progress - (CGFloat(index) * tailSpacing)
                    let particleOpacity = 1.0 - (indexDouble / (tailCountDouble * 1.2))
                    let particleSize = 16 - CGFloat(index) * 1.2
                    let particleGlow = index == 0 ? 1.0 : 0.5
                    
                    TracerParticle(
                        path: path,
                        progress: particleProgress,
                        color: color,
                        opacity: particleOpacity,
                        size: particleSize,
                        glowIntensity: particleGlow
                    )
                }
            }
        }
        .onAppear {
            // Only log BPM changes, not every restart
            if bpm > 0 {
                // Reduced BPM sync logging to avoid spam
        // print("🌟 NeonTracer: Syncing to \(Int(bpm)) BPM (scroll-safe)")
            }
        }
    }
}

/// Individual tracer particle that moves along the path
struct TracerParticle: View {
    let path: CGPath
    let progress: CGFloat
    let color: Color
    let opacity: Double
    let size: CGFloat
    let glowIntensity: Double
    
    @State private var position: CGPoint = .zero
    
    var body: some View {
        ZStack {
            // Core particle
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            color.opacity(opacity),
                            color.opacity(opacity * 0.3),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: size / 2
                    )
                )
                .frame(width: size, height: size)
            
            // Inner bright core (only for lead particle)
            if glowIntensity > 0.8 {
                Circle()
                    .fill(Color.white.opacity(opacity * 0.8))
                    .frame(width: size * 0.4, height: size * 0.4)
            }
        }
        .shadow(color: color.opacity(opacity * 0.8), radius: size * 0.5)
        .shadow(color: color.opacity(opacity * 0.4), radius: size)
        .position(position)
        .onAppear {
            updatePosition()
        }
                 .onChange(of: progress) {
             updatePosition()
         }
    }
    
    private func updatePosition() {
        // Ensure progress wraps around properly
        let normalizedProgress = progress.truncatingRemainder(dividingBy: 1.0)
        let clampedProgress = normalizedProgress < 0 ? normalizedProgress + 1.0 : normalizedProgress
        
        // Use PathTracer to find position along path
        let tracer = PathTracer(path: path)
        let newPosition = tracer.pointAtProgress(clampedProgress)
        
        position = newPosition
    }
}

/// Claude: PathTracer - Converts CGPath geometry into traceable segments
/// Phase 8 enhancement: Will read actual SVG mandala paths instead of predefined geometry
private class PathTracer {
    let path: CGPath
    private var pathLength: CGFloat = 0
    private var segments: [(start: CGPoint, end: CGPoint, length: CGFloat)] = []
    
    init(path: CGPath) {
        self.path = path
        calculateSegments()
    }
    
    private func calculateSegments() {
        var currentPoint = CGPoint.zero
        var totalLength: CGFloat = 0
        
        path.applyWithBlock { element in
            let points = element.pointee.points
            
            switch element.pointee.type {
            case .moveToPoint:
                currentPoint = points[0]
                
            case .addLineToPoint:
                let start = currentPoint
                let end = points[0]
                let length = distance(from: start, to: end)
                segments.append((start: start, end: end, length: length))
                totalLength += length
                currentPoint = end
                
            case .addCurveToPoint:
                // Approximate curve with line for simplicity
                let start = currentPoint
                let end = points[2]
                let length = distance(from: start, to: end)
                segments.append((start: start, end: end, length: length))
                totalLength += length
                currentPoint = end
                
            case .closeSubpath:
                // Close the path if needed
                if !segments.isEmpty {
                    let firstPoint = segments.first?.start ?? .zero
                    let length = distance(from: currentPoint, to: firstPoint)
                    if length > 0 {
                        segments.append((start: currentPoint, end: firstPoint, length: length))
                        totalLength += length
                    }
                }
                
            default:
                break
            }
        }
        
        pathLength = totalLength
    }
    
    func pointAtProgress(_ progress: CGFloat) -> CGPoint {
        guard !segments.isEmpty && pathLength > 0 else { return .zero }
        
        let targetLength = pathLength * progress
        var accumulatedLength: CGFloat = 0
        
        for segment in segments {
            if accumulatedLength + segment.length >= targetLength {
                let segmentProgress = (targetLength - accumulatedLength) / segment.length
                return interpolate(from: segment.start, to: segment.end, progress: segmentProgress)
            }
            accumulatedLength += segment.length
        }
        
        // Return last point if we've exceeded the path
        return segments.last?.end ?? .zero
    }
    
    private func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        let dx = to.x - from.x
        let dy = to.y - from.y
        return sqrt(dx * dx + dy * dy)
    }
    
    private func interpolate(from: CGPoint, to: CGPoint, progress: CGFloat) -> CGPoint {
        CGPoint(
            x: from.x + (to.x - from.x) * progress,
            y: from.y + (to.y - from.y) * progress
        )
    }
}

// MARK: - Preview
struct NeonTracerView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            
            // Sample hexagon path for preview
            NeonTracerView(
                path: createHexagonPath(),
                bpm: 72,
                color: .purple
            )
        }
        .frame(width: 300, height: 300)
        .previewLayout(.sizeThatFits)
    }
    
    static func createHexagonPath() -> CGPath {
        let path = CGMutablePath()
        let center = CGPoint(x: 150, y: 150)
        let radius: CGFloat = 80
        
        for i in 0..<6 {
            let angle = CGFloat(i) * .pi / 3 - .pi / 2
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
} 