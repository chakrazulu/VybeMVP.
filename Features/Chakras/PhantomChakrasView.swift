//
//  PhantomChakrasView.swift
//  VybeMVP
//
//  🎯 PIXEL-PERFECT UI REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
//
//  === SCREEN LAYOUT (iPhone 14 Pro Max: 430×932 points) ===
//  • Background: Full screen CosmicBackgroundView
//  • Main VStack: Full height with header, content, controls
//  • Header section: ~100pt height with title and subtitle
//  • ScrollView: Flexible height, 10pt horizontal padding
//  • Bottom controls: ~150pt height with indicators and button
//
//  === HEADER SECTION ===
//  • Title: "Phantom of the Chakras" - Large Title font (~34pt)
//  • Title gradient: White→Purple(80%)
//  • Subtitle: Subheadline font (~15pt), 70% white opacity
//  • Top padding: 20pts from safe area
//  • Animation: Scale 0.8→1.0, opacity 0→1
//
//  === CHAKRA STACK ===
//  • Vertical spacing: 35pts between chakras
//  • Chakra order: Reversed (Crown at top, Root at bottom)
//  • Vertical padding: 30pts top and bottom
//  • Animation: Staggered entrance, 0.1s delay per chakra
//  • Scale animation: 0.8→1.0 with 0.5s ease-out
//
//  === CHAKRA SYMBOLS (via ChakraSymbolView) ===
//  • See ChakraSymbolView.swift for detailed specifications
//  • Tap handling: Single tap for detail, long press for harmonize
//  • Disabled state: During initialization or processing
//
//  === ACTIVE CHAKRAS INDICATOR ===
//  • Dot size: 8×8pt circles
//  • Spacing: 15pts between dots
//  • Container: Capsule with 10pt vertical, 20pt horizontal padding
//  • Background: 10% white opacity
//  • Only visible when chakras are active
//
//  === MEDITATION BUTTON ===
//  • Width: Full width minus 80pts (40pt margins)
//  • Height: 56pts
//  • Corner radius: 28pts (pill shape)
//  • Gradient: Purple→Blue horizontal
//  • Shadow: Purple 30% opacity, 8pt blur, 4pt Y offset
//  • Icon: "sparkles" system image
//  • Text: Semibold font weight
//  • Bottom padding: 30pts from safe area
//
//  === MEDITATION VIEW MODAL ===
//  • Presentation: Full screen sheet
//  • Background gradient: Purple(30%)→Blue(20%)→Black
//  • Om symbol: 80pt font size
//  • Pulsing circle: 300×300pt, 1.0→1.2 scale animation
//  • Animation duration: 4.0s ease-in-out, repeat forever
//  • Control buttons: 60pt system icons
//  • Button spacing: 40pts horizontal
//
//  === ANIMATION TIMINGS ===
//  • Initial delay: 1.0s for UI initialization
//  • Chakra entrance: 0.5s duration, 0.1s stagger
//  • Audio timeout: 3.0s fallback
//  • Tap processing: 0.5s activation + 0.2s cooldown
//  • Meditation pulse: 4.0s cycle
//
//  === STATE MANAGEMENT ===
//  • selectedChakra: Currently selected for detail view
//  • showingDetail: Sheet presentation state
//  • showingMeditation: Meditation sheet state
//  • animateIn: Entrance animation trigger
//  • isTapProcessing: Prevents multiple simultaneous taps
//  • isInitialized: UI ready state (independent of audio)
//
//  Main view for the Phantom of the Chakras feature
//

import SwiftUI

/// Main view displaying all seven chakras in a vertical arrangement
struct PhantomChakrasView: View {
    @StateObject private var chakraManager = ChakraManager.shared
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    @EnvironmentObject var realmNumberManager: RealmNumberManager
    @State private var selectedChakra: ChakraType?
    @State private var showingDetail = false
    @State private var showingMeditation = false
    @State private var animateIn = false
    @State private var isTapProcessing = false
    @State private var isInitialized = false
    
    var body: some View {
        ZStack {
            // Cosmic background
            CosmicBackgroundView()
                .allowsHitTesting(false)
            
            VStack {
                // Header
                headerSection
                
                // 🎯 CHAKRA STACK: 35pt spacing, reversed order (Crown→Root)
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 35) { // 35pt vertical spacing between chakras
                        ForEach(chakraManager.chakraStates.reversed()) { chakraState in
                            ChakraSymbolView(
                                chakraState: chakraState,
                                onTap: {
                                    if isInitialized && !isTapProcessing {
                                        handleChakraTap(chakraState.type)
                                    }
                                },
                                onLongPress: {
                                    if isInitialized && !isTapProcessing {
                                        handleChakraLongPress(chakraState.type)
                                    }
                                },
                                onVolumeChange: { volume in
                                    chakraManager.updateVolume(for: chakraState.type, volume: volume)
                                }
                            )
                            .disabled(!isInitialized || isTapProcessing)
                            .scaleEffect(animateIn ? 1.0 : 0.8)
                            .opacity(animateIn ? 1.0 : 0.0)
                            .animation(
                                .easeOut(duration: 0.5)
                                .delay(Double(chakraState.type.rawValue) * 0.1),
                                value: animateIn
                            )
                        }
                    }
                    .padding(.vertical, 30)
                }
                .padding(.horizontal, 10)
                
                // Audio status indicator (temporary for debugging)
                if !chakraManager.isAudioEngineRunning {
                    Text("Audio engine initializing...")
                        .font(.caption)
                        .foregroundColor(.yellow)
                        .padding(.horizontal)
                }
                
                // Bottom controls
                bottomControls
            }
            
            // Affirmation overlay
            if chakraManager.isShowingAffirmation {
                affirmationOverlay
            }
        }
        .sheet(isPresented: $showingDetail) {
            if let chakra = selectedChakra {
                ChakraDetailView(chakraType: chakra)
            }
        }
        .sheet(isPresented: $showingMeditation) {
            MeditationView()
                .environmentObject(chakraManager)
        }
        .onAppear {
            // PERFORMANCE FIX: Defer heavy operations to prevent tab loading delays
            
            // Step 1: Start lightweight animations immediately
            startAnimations()
            
            // Step 2: Initialize audio engine after delay to prevent blocking
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                // Enable UI first, even without audio
                isInitialized = true
                print("⚡ Chakras UI initialized (audio loading in background)")
            }
            
            // Step 3: Update resonance after animations start
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            updateChakraResonance()
            }
            
            // Step 4: Audio engine timeout fallback
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                if !chakraManager.isAudioEngineRunning {
                    print("⚠️ Audio engine timeout - UI enabled anyway for performance")
                }
            }
        }
        .onReceive(focusNumberManager.$selectedFocusNumber) { _ in
            updateChakraResonance()
        }
        .onReceive(realmNumberManager.$currentRealmNumber) { _ in
            updateChakraResonance()
        }
        .onDisappear {
            // Clean up any active audio when leaving
            for chakraType in ChakraType.allCases {
                chakraManager.deactivateChakra(chakraType)
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: 10) {
            Text("Phantom of the Chakras")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [.white, .purple.opacity(0.8)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .scaleEffect(animateIn ? 1.0 : 0.8)
                .opacity(animateIn ? 1.0 : 0.0)
            
            Text("Tap to explore • Hold to harmonize • Double-tap for affirmation")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .opacity(animateIn ? 1.0 : 0.0)
        }
        .padding(.top, 20)
    }
    
    private var bottomControls: some View {
        VStack(spacing: 20) {
            // Active chakras indicator
            if hasActiveChakras {
                HStack(spacing: 15) {
                    ForEach(activeChakras, id: \.self) { chakraType in
                        Circle()
                            .fill(chakraType.color)
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                )
            }
            
            // Meditation button
            Button(action: {
                showingMeditation = true
            }) {
                HStack {
                    Image(systemName: "sparkles")
                    Text("Begin Meditation")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.purple, .blue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(28)
                .shadow(color: Color.purple.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 40)
            .scaleEffect(animateIn ? 1.0 : 0.8)
            .opacity(animateIn ? 1.0 : 0.0)
        }
        .padding(.bottom, 30)
    }
    
    private var affirmationOverlay: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                // Affirmation text
                if let affirmationText = chakraManager.currentAffirmationText {
                    Text(affirmationText)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.black.opacity(0.8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.purple.opacity(0.8),
                                                    Color.blue.opacity(0.8)
                                                ]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ),
                                            lineWidth: 2
                                        )
                                )
                        )
                        .shadow(color: Color.purple.opacity(0.3), radius: 20, x: 0, y: 10)
                        .accessibilityLabel("Chakra Affirmation")
                        .accessibilityValue(affirmationText)
                }
                
                // Meditation instruction
                Text("Double-tap any chakra to hear its affirmation")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .transition(.opacity.combined(with: .scale(scale: 0.9)))
        .zIndex(1)
    }
    
    // MARK: - Computed Properties
    
    private var hasActiveChakras: Bool {
        chakraManager.chakraStates.contains { $0.isActive || $0.isHarmonizing }
    }
    
    private var activeChakras: [ChakraType] {
        chakraManager.chakraStates
            .filter { $0.isActive || $0.isHarmonizing }
            .map { $0.type }
    }
    
    // MARK: - Methods
    
    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.5)) {
            animateIn = true
        }
    }
    
    private func updateChakraResonance() {
        chakraManager.updateResonance(
            focusNumber: focusNumberManager.selectedFocusNumber,
            realmNumber: realmNumberManager.currentRealmNumber
        )
    }
    
    private func handleChakraTap(_ type: ChakraType) {
        guard !isTapProcessing else { return }
        
        isTapProcessing = true
        selectedChakra = type
        showingDetail = true
        
        // Quick activation feedback
        chakraManager.activateChakra(type)
        
        // Deactivate after a moment
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            chakraManager.deactivateChakra(type)
            // Allow new taps after a brief delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isTapProcessing = false
            }
        }
    }
    
    private func handleChakraLongPress(_ type: ChakraType) {
        guard !isTapProcessing else { return }
        chakraManager.toggleHarmonizing(type)
    }
}

// MARK: - Meditation View

/// Placeholder meditation view
struct MeditationView: View {
    @EnvironmentObject var chakraManager: ChakraManager
    @Environment(\.dismiss) private var dismiss
    @State private var meditationProgress: Double = 0
    @State private var pulseAnimation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.purple.opacity(0.3),
                        Color.blue.opacity(0.2),
                        Color.black
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 40) {
                    // Title
                    Text("Chakra Meditation")
                        .font(.largeTitle)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Central meditation visual
                    ZStack {
                        // Pulsing circle
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color.purple.opacity(0.3),
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: 50,
                                    endRadius: 150
                                )
                            )
                            .frame(width: 300, height: 300)
                            .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                            .animation(
                                Animation.easeInOut(duration: 4.0)
                                    .repeatForever(autoreverses: true),
                                value: pulseAnimation
                            )
                        
                        // Om symbol
                        Text("ॐ")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                    }
                    
                    // Progress
                    if chakraManager.isMeditating {
                        VStack(spacing: 10) {
                            Text(formattedTime)
                                .font(.title2)
                                .foregroundColor(.white)
                                .monospacedDigit()
                            
                            ProgressView(value: meditationProgress)
                                .progressViewStyle(LinearProgressViewStyle(tint: .purple))
                                .frame(width: 200)
                        }
                    }
                    
                    Spacer()
                    
                    // Controls
                    HStack(spacing: 40) {
                        Button(action: {
                            if chakraManager.isMeditating {
                                chakraManager.endMeditation()
                            } else {
                                chakraManager.startMeditation()
                            }
                        }) {
                            Image(systemName: chakraManager.isMeditating ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                        }
                        
                        Button(action: {
                            chakraManager.endMeditation()
                            dismiss()
                        }) {
                            Image(systemName: "stop.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                pulseAnimation = true
            }
            .onReceive(chakraManager.$currentMeditationTime) { time in
                meditationProgress = time / chakraManager.configuration.meditationDuration
            }
        }
    }
    
    private var formattedTime: String {
        let minutes = Int(chakraManager.currentMeditationTime) / 60
        let seconds = Int(chakraManager.currentMeditationTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Preview

#Preview {
    PhantomChakrasView()
        .environmentObject(FocusNumberManager.shared)
        .environmentObject(RealmNumberManager())
} 