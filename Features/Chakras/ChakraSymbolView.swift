//
//  ChakraSymbolView.swift
//  VybeMVP
//
//  Individual chakra symbol with animations and interactions
//

import SwiftUI

/// Individual chakra symbol view with interactive animations
struct ChakraSymbolView: View {
    let chakraState: ChakraState
    let onTap: () -> Void
    let onLongPress: () -> Void
    let onVolumeChange: (Float) -> Void
    
    @State private var isPressed = false
    @State private var animationPhase = 0.0
    @State private var glowAnimation = false
    @State private var rippleScale: CGFloat = 1.0
    @State private var rippleOpacity: Double = 0.0
    @State private var showVolumeSlider = false
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                // Background glow layers
                glowLayers
                
                // Main chakra symbol
                chakraSymbol
                
                // Active state overlay
                if chakraState.isActive || chakraState.isHarmonizing {
                    activeOverlay
                }
                
                // Ripple effect
                rippleEffect
            }
            .frame(width: 80, height: 80)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
            .onTapGesture {
                triggerTapAnimation()
                onTap()
            }
            .onLongPressGesture(minimumDuration: 0.5, pressing: { pressing in
                isPressed = pressing
                if pressing {
                    triggerLongPressAnimation()
                }
            }) {
                onLongPress()
            }
            .onAppear {
                startContinuousAnimation()
            }
            
            // Volume control (shows when harmonizing)
            if chakraState.isHarmonizing {
                VolumeSlider(
                    volume: chakraState.volume,
                    color: chakraState.type.color,
                    onVolumeChange: onVolumeChange
                )
                .transition(.scale.combined(with: .opacity))
                .animation(.easeInOut(duration: 0.3), value: chakraState.isHarmonizing)
            }
        }
    }
    
    // MARK: - View Components
    
    private var glowLayers: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            chakraState.type.color.opacity(chakraState.glowIntensity * 0.3),
                            chakraState.type.color.opacity(0)
                        ]),
                        center: .center,
                        startRadius: 20,
                        endRadius: 60
                    )
                )
                .frame(width: 140, height: 140)
                .blur(radius: 10)
                .scaleEffect(glowAnimation ? 1.2 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 2.0 / chakraState.pulseRate)
                        .repeatForever(autoreverses: true),
                    value: glowAnimation
                )
            
            // Inner glow
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            chakraState.type.color.opacity(chakraState.glowIntensity * 0.5),
                            chakraState.type.color.opacity(0)
                        ]),
                        center: .center,
                        startRadius: 10,
                        endRadius: 40
                    )
                )
                .frame(width: 100, height: 100)
                .blur(radius: 5)
        }
    }
    
    private var chakraSymbol: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            chakraState.type.color.opacity(0.8),
                            chakraState.type.color.opacity(0.6)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 70, height: 70)
            
            // Chakra symbol
            Image(systemName: chakraState.type.symbolName)
                .font(.system(size: 30, weight: .light))
                .foregroundColor(.white)
                .rotationEffect(.degrees(animationPhase))
                .animation(
                    chakraState.isHarmonizing ?
                    Animation.linear(duration: 8.0).repeatForever(autoreverses: false) :
                    .default,
                    value: animationPhase
                )
            
            // Sanskrit name overlay
            Text(chakraState.type.sanskritName)
                .font(.system(size: 8, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .offset(y: 25)
        }
    }
    
    private var activeOverlay: some View {
        ZStack {
            // Pulsing ring
            Circle()
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            chakraState.type.color,
                            chakraState.type.color.opacity(0.5)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 2
                )
                .frame(width: 75, height: 75)
                .scaleEffect(glowAnimation ? 1.1 : 1.0)
                .opacity(glowAnimation ? 0.6 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 1.0)
                        .repeatForever(autoreverses: true),
                    value: glowAnimation
                )
            
            // Energy particles (simplified)
            ForEach(0..<6) { index in
                Circle()
                    .fill(chakraState.type.color)
                    .frame(width: 4, height: 4)
                    .offset(x: 35)
                    .rotationEffect(.degrees(Double(index) * 60 + animationPhase * 2))
                    .opacity(0.8)
            }
        }
    }
    
    private var rippleEffect: some View {
        Circle()
            .stroke(chakraState.type.color, lineWidth: 2)
            .frame(width: 70, height: 70)
            .scaleEffect(rippleScale)
            .opacity(rippleOpacity)
    }
    
    // MARK: - Animation Methods
    
    private func startContinuousAnimation() {
        glowAnimation = true
        if chakraState.isHarmonizing {
            withAnimation {
                animationPhase = 360
            }
        }
    }
    
    private func triggerTapAnimation() {
        // Ripple effect
        rippleScale = 1.0
        rippleOpacity = 1.0
        
        withAnimation(.easeOut(duration: 0.6)) {
            rippleScale = 1.5
            rippleOpacity = 0
        }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    private func triggerLongPressAnimation() {
        // Enhanced haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Visual feedback
        withAnimation(.easeInOut(duration: 0.3)) {
            // Animation handled by state change
        }
    }
}

// MARK: - Chakra Detail Sheet

/// Detail view showing full chakra information
struct ChakraDetailView: View {
    let chakraType: ChakraType
    @Environment(\.dismiss) private var dismiss
    @State private var animateIn = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Header with animated symbol
                    headerSection
                    
                    // Core information
                    coreInfoSection
                    
                    // Qualities and attributes
                    qualitiesSection
                    
                    // Numerological associations
                    numerologySection
                    
                    // Affirmation
                    affirmationSection
                }
                .padding()
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        chakraType.color.opacity(0.1),
                        Color.clear
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle(chakraType.name + " Chakra")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                animateIn = true
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            ZStack {
                // Animated background
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                chakraType.color.opacity(0.3),
                                chakraType.color.opacity(0.1)
                            ]),
                            center: .center,
                            startRadius: 50,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .scaleEffect(animateIn ? 1.0 : 0.5)
                    .opacity(animateIn ? 1.0 : 0.0)
                
                // Symbol
                Image(systemName: chakraType.symbolName)
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(chakraType.color)
                    .scaleEffect(animateIn ? 1.0 : 0.5)
                    .opacity(animateIn ? 1.0 : 0.0)
            }
            
            Text(chakraType.sanskritName)
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(chakraType.color)
        }
        .padding(.top, 20)
    }
    
    private var coreInfoSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            InfoRow(icon: "location.fill", title: "Location", value: chakraType.location)
            InfoRow(icon: "sparkles", title: "Element", value: chakraType.element)
            InfoRow(icon: "waveform", title: "Frequency", value: "\(Int(chakraType.frequency)) Hz")
            InfoRow(icon: "music.note", title: "Mantra", value: chakraType.mantra)
        }
        .padding(.horizontal)
    }
    
    private var qualitiesSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Qualities & Attributes")
                .font(.headline)
                .foregroundColor(.primary)
            
            FlowLayout(spacing: 10) {
                ForEach(chakraType.qualities, id: \.self) { quality in
                    Text(quality)
                        .font(.subheadline)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(chakraType.color.opacity(0.2))
                        .foregroundColor(chakraType.color)
                        .cornerRadius(20)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var numerologySection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Numerological Resonance")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("This chakra resonates with the following numbers:")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 15) {
                ForEach(chakraType.numerologicalResonance, id: \.self) { number in
                    ZStack {
                        Circle()
                            .fill(chakraType.color.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Text("\(number)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(chakraType.color)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var affirmationSection: some View {
        VStack(spacing: 15) {
            Text("Affirmation")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("\"" + chakraType.affirmation + "\"")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(chakraType.color)
                .multilineTextAlignment(.center)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(chakraType.color.opacity(0.1))
                )
        }
        .padding(.horizontal)
    }
}

// MARK: - Supporting Views

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.secondary)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
    }
}

// Simple flow layout for qualities
struct FlowLayout: Layout {
    var spacing: CGFloat = 10
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, spacing: spacing, subviews: subviews)
        return CGSize(width: proposal.width ?? 0, height: result.height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, spacing: spacing, subviews: subviews)
        for (index, frame) in result.frames.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY), proposal: ProposedViewSize(frame.size))
        }
    }
    
    struct FlowResult {
        var frames: [CGRect] = []
        var height: CGFloat = 0
        
        init(in width: CGFloat, spacing: CGFloat, subviews: Subviews) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var maxHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                if x + size.width > width && x > 0 {
                    x = 0
                    y += maxHeight + spacing
                    maxHeight = 0
                }
                frames.append(CGRect(x: x, y: y, width: size.width, height: size.height))
                x += size.width + spacing
                maxHeight = max(maxHeight, size.height)
            }
            height = y + maxHeight
        }
    }
}

// MARK: - Volume Slider Component

struct VolumeSlider: View {
    let volume: Float
    let color: Color
    let onVolumeChange: (Float) -> Void
    
    @State private var currentVolume: Float
    
    init(volume: Float, color: Color, onVolumeChange: @escaping (Float) -> Void) {
        self.volume = volume
        self.color = color
        self.onVolumeChange = onVolumeChange
        self._currentVolume = State(initialValue: volume)
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "speaker.fill")
                .font(.system(size: 10))
                .foregroundColor(color.opacity(0.7))
            
            Slider(value: $currentVolume, in: 0...1) { _ in
                onVolumeChange(currentVolume)
            }
            .accentColor(color)
            .frame(width: 60)
            
            Image(systemName: "speaker.wave.3.fill")
                .font(.system(size: 10))
                .foregroundColor(color.opacity(0.7))
        }
        .frame(width: 100)
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.3))
                .overlay(
                    Capsule()
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
} 