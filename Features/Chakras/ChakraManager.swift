//
//  ChakraManager.swift
//  VybeMVP
//
//  Manages chakra audio synthesis, haptics, and state synchronization
//

import Foundation
import AVFoundation
import CoreHaptics
import Combine

/// Manages all chakra-related functionality including audio, haptics, and state
class ChakraManager: ObservableObject {
    
    // MARK: - Singleton
    static let shared = ChakraManager()
    
    // MARK: - Published Properties
    @Published var chakraStates: [ChakraState] = []
    @Published var configuration = ChakraConfiguration()
    @Published var isAudioEngineRunning = false
    @Published var currentMeditationTime: TimeInterval = 0
    @Published var isMeditating = false
    
    // MARK: - Audio Properties
    private var audioEngine: AVAudioEngine?
    private var toneGenerators: [ChakraType: AVAudioPlayerNode] = [:]
    private var audioBuffers: [ChakraType: AVAudioPCMBuffer] = [:]
    
    // MARK: - Haptic Properties
    private var hapticEngine: CHHapticEngine?
    private var hapticPlayers: [ChakraType: CHHapticPatternPlayer] = [:]
    
    // MARK: - Timer Properties
    private var meditationTimer: Timer?
    
    // MARK: - Cancellables
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    private init() {
        setupChakraStates()
        setupAudioEngine()
        setupHapticEngine()
    }
    
    // MARK: - Setup Methods
    
    /// Initialize all chakra states
    private func setupChakraStates() {
        chakraStates = ChakraType.allCases.map { type in
            ChakraState(type: type)
        }
    }
    
    /// Setup the audio engine and tone generators
    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        
        guard let audioEngine = audioEngine else { return }
        
        // Configure audio session
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("❌ Failed to configure audio session: \(error)")
        }
        
        // Create tone generators for each chakra
        for chakraType in ChakraType.allCases {
            let playerNode = AVAudioPlayerNode()
            audioEngine.attach(playerNode)
            audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: nil)
            toneGenerators[chakraType] = playerNode
            
            // Generate tone buffer
            if let buffer = createToneBuffer(frequency: chakraType.frequency) {
                audioBuffers[chakraType] = buffer
            }
        }
    }
    
    /// Create a tone buffer for a specific frequency with improved sound quality
    private func createToneBuffer(frequency: Double, duration: Double = 1.0) -> AVAudioPCMBuffer? {
        let sampleRate = 44100.0
        let frameCount = Int(sampleRate * duration)
        
        guard let buffer = AVAudioPCMBuffer(
            pcmFormat: AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 2)!,
            frameCapacity: AVAudioFrameCount(frameCount)
        ) else { return nil }
        
        buffer.frameLength = AVAudioFrameCount(frameCount)
        
        // Create a richer tone with harmonics and envelope
        for frame in 0..<frameCount {
            let time = Double(frame) / sampleRate
            
            // Envelope for smooth attack and release
            let envelope = min(1.0, time * 20.0) * min(1.0, (duration - time) * 20.0)
            
            // Fundamental frequency with slight detuning for warmth
            let detune = 1.0 + (sin(time * 0.5) * 0.002) // Subtle vibrato
            let fundamental = sin(2.0 * .pi * frequency * detune * time)
            
            // Add subtle harmonics for richness
            let harmonic2 = sin(2.0 * .pi * frequency * 2.0 * time) * 0.15
            let harmonic3 = sin(2.0 * .pi * frequency * 3.0 * time) * 0.08
            let harmonic4 = sin(2.0 * .pi * frequency * 4.0 * time) * 0.04
            
            // Combine harmonics
            let value = (fundamental + harmonic2 + harmonic3 + harmonic4) * envelope * 0.3
            
            buffer.floatChannelData?[0][frame] = Float(value) // Left channel
            buffer.floatChannelData?[1][frame] = Float(value) // Right channel
        }
        
        return buffer
    }
    
    /// Setup the haptic engine
    private func setupHapticEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            hapticEngine = try CHHapticEngine()
            
            // Set up handlers for engine lifecycle
            hapticEngine?.resetHandler = { [weak self] in
                print("🔄 Haptic engine reset")
                do {
                    try self?.hapticEngine?.start()
                } catch {
                    print("❌ Failed to restart haptic engine: \(error)")
                }
            }
            
            hapticEngine?.stoppedHandler = { [weak self] reason in
                print("⏹ Haptic engine stopped: \(reason)")
                do {
                    try self?.hapticEngine?.start()
                } catch {
                    print("❌ Failed to restart haptic engine: \(error)")
                }
            }
            
            try hapticEngine?.start()
        } catch {
            print("❌ Failed to start haptic engine: \(error)")
        }
    }
    
    // MARK: - Public Methods
    
    /// Activate a chakra (play tone and haptics)
    func activateChakra(_ type: ChakraType) {
        guard let index = chakraStates.firstIndex(where: { $0.type == type }) else { return }
        
        // Update state
        chakraStates[index].isActive = true
        chakraStates[index].glowIntensity = 1.0
        
        // Play audio if enabled
        if configuration.enableSound {
            playTone(for: type)
        }
        
        // Play haptics if enabled
        if configuration.enableHaptics {
            playHapticPattern(for: type)
        }
    }
    
    /// Deactivate a chakra
    func deactivateChakra(_ type: ChakraType) {
        guard let index = chakraStates.firstIndex(where: { $0.type == type }) else { return }
        
        // Update state
        chakraStates[index].isActive = false
        chakraStates[index].glowIntensity = 0.3
        
        // Stop audio
        stopTone(for: type)
        
        // Stop haptics
        stopHapticPattern(for: type)
    }
    
    /// Toggle harmonizing state for multi-chakra playback
    func toggleHarmonizing(_ type: ChakraType) {
        guard let index = chakraStates.firstIndex(where: { $0.type == type }) else { return }
        
        chakraStates[index].isHarmonizing.toggle()
        
        if chakraStates[index].isHarmonizing {
            chakraStates[index].isActive = true
            playTone(for: type, continuous: true)
            playHapticPattern(for: type, continuous: true)
        } else {
            chakraStates[index].isActive = false
            stopTone(for: type)
            stopHapticPattern(for: type)
        }
    }
    
    /// Update chakra resonance based on user's numerology
    func updateResonance(focusNumber: Int, realmNumber: Int) {
        for index in chakraStates.indices {
            let resonates = chakraStates[index].resonatesWith(number: focusNumber) ||
                          chakraStates[index].resonatesWith(number: realmNumber)
            
            if resonates {
                chakraStates[index].glowIntensity = 0.7
                chakraStates[index].pulseRate = 1.5
            } else {
                chakraStates[index].glowIntensity = 0.3
                chakraStates[index].pulseRate = 1.0
            }
        }
    }
    
    /// Update volume for a specific chakra
    func updateVolume(for type: ChakraType, volume: Float) {
        guard let index = chakraStates.firstIndex(where: { $0.type == type }) else { return }
        chakraStates[index].volume = volume
        
        // Update volume if currently playing
        if let playerNode = toneGenerators[type], playerNode.isPlaying {
            playerNode.volume = volume
        }
    }
    
    /// Start meditation session
    func startMeditation() {
        isMeditating = true
        currentMeditationTime = 0
        
        // Start playing all harmonizing chakras at low volume for meditation
        for (index, chakraState) in chakraStates.enumerated() {
            if chakraState.isHarmonizing {
                // Temporarily reduce volume for meditation
                let meditationVolume = chakraState.volume * 0.5
                chakraStates[index].volume = meditationVolume
                updateVolume(for: chakraState.type, volume: meditationVolume)
            }
        }
        
        meditationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.currentMeditationTime += 1
            
            if self.currentMeditationTime >= self.configuration.meditationDuration {
                self.endMeditation()
            }
        }
    }
    
    /// End meditation session
    func endMeditation() {
        isMeditating = false
        meditationTimer?.invalidate()
        meditationTimer = nil
        
        // Restore original volumes
        for chakraState in chakraStates {
            updateVolume(for: chakraState.type, volume: 0.7) // Default volume
        }
        
        // Deactivate all chakras
        for chakraType in ChakraType.allCases {
            if chakraStates.first(where: { $0.type == chakraType })?.isHarmonizing == true {
                toggleHarmonizing(chakraType)
            }
        }
    }
    
    // MARK: - Audio Methods
    
    private func playTone(for type: ChakraType, continuous: Bool = false) {
        guard let playerNode = toneGenerators[type],
              let buffer = audioBuffers[type],
              let audioEngine = audioEngine else { return }
        
        // Start engine if needed
        if !audioEngine.isRunning {
            do {
                try audioEngine.start()
                isAudioEngineRunning = true
            } catch {
                print("❌ Failed to start audio engine: \(error)")
                return
            }
        }
        
        // Stop any existing playback
        playerNode.stop()
        
        // Schedule buffer
        if continuous {
            playerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
        } else {
            playerNode.scheduleBuffer(buffer, at: nil, options: .interrupts, completionHandler: nil)
        }
        
        // Set volume from chakra state
        if let chakraState = chakraStates.first(where: { $0.type == type }) {
            playerNode.volume = chakraState.volume * configuration.volumeLevel
        } else {
            playerNode.volume = configuration.volumeLevel
        }
        
        // Play
        playerNode.play()
    }
    
    private func stopTone(for type: ChakraType) {
        toneGenerators[type]?.stop()
    }
    
    // MARK: - Haptic Methods
    
    private func playHapticPattern(for type: ChakraType, continuous: Bool = false) {
        guard configuration.enableHaptics,
              let hapticEngine = hapticEngine else { return }
        
        // Ensure engine is running
        if hapticEngine.currentTime == 0 {
            do {
                try hapticEngine.start()
            } catch {
                print("❌ Failed to start haptic engine for playback: \(error)")
                return
            }
        }
        
        // Create haptic pattern based on chakra frequency
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.6)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.4)
        
        // Calculate haptic pulse rate based on chakra frequency (scaled down)
        let pulseInterval = 1.0 / (type.frequency / 1000.0)
        
        var events: [CHHapticEvent] = []
        
        if continuous {
            // Create repeating pattern
            for i in 0..<10 {
                let event = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [intensity, sharpness],
                    relativeTime: Double(i) * pulseInterval
                )
                events.append(event)
            }
        } else {
            // Single pulse
            let event = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: 0
            )
            events.append(event)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine.makePlayer(with: pattern)
            hapticPlayers[type] = player
            try player.start(atTime: 0)
        } catch {
            print("❌ Failed to play haptic pattern: \(error)")
        }
    }
    
    private func stopHapticPattern(for type: ChakraType) {
        do {
            try hapticPlayers[type]?.stop(atTime: 0)
        } catch {
            print("❌ Failed to stop haptic pattern: \(error)")
        }
    }
    
    // MARK: - Cleanup
    
    deinit {
        audioEngine?.stop()
        hapticEngine?.stop()
        meditationTimer?.invalidate()
    }
} 