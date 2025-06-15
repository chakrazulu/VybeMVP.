//
//  PhantomChakrasView.swift
//  VybeMVP
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
                
                // Chakra stack
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        ForEach(chakraManager.chakraStates.reversed()) { chakraState in
                            ChakraSymbolView(
                                chakraState: chakraState,
                                onTap: {
                                    if isInitialized && !isTapProcessing && chakraManager.isAudioEngineRunning {
                                        handleChakraTap(chakraState.type)
                                    }
                                },
                                onLongPress: {
                                    if isInitialized && !isTapProcessing && chakraManager.isAudioEngineRunning {
                                        handleChakraLongPress(chakraState.type)
                                    }
                                },
                                onVolumeChange: { volume in
                                    chakraManager.updateVolume(for: chakraState.type, volume: volume)
                                }
                            )
                            .disabled(!isInitialized || isTapProcessing || !chakraManager.isAudioEngineRunning)
                            .scaleEffect(animateIn ? 1.0 : 0.8)
                            .opacity(animateIn ? 1.0 : 0.0)
                            .animation(
                                .easeOut(duration: 0.5)
                                .delay(Double(chakraState.type.rawValue) * 0.1),
                                value: animateIn
                            )
                        }
                    }
                    .padding(.vertical, 20)
                }
                
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
            // Delay initialization to ensure everything is ready
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isInitialized = true
            }
            startAnimations()
            updateChakraResonance()
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
            
            Text("Tap to explore • Hold to harmonize")
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