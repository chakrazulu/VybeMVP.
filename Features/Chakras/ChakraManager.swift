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
    private var reverbNode: AVAudioUnitReverb?
    private var eqNode: AVAudioUnitEQ?
    
    // MARK: - Haptic Properties
    private var hapticEngine: CHHapticEngine?
    private var hapticPlayers: [ChakraType: CHHapticPatternPlayer] = [:]
    private var currentHeartRate: Double = 72.0 // Default BPM
    
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
        
        // Configure audio session first
        configureAudioSession()
        
        // Create and attach all nodes first
        setupAudioNodes(audioEngine)
        
        // Connect all nodes
        connectAudioNodes(audioEngine)
        
        // Generate tone buffers
        generateToneBuffers()
        
        // Prepare the engine
        audioEngine.prepare()
        
        // Subscribe to heart rate updates if available
        subscribeToHeartRate()
    }
    
    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("❌ Failed to configure audio session: \(error)")
        }
    }
    
    private func setupAudioNodes(_ audioEngine: AVAudioEngine) {
        // Add reverb for spaciousness
        reverbNode = AVAudioUnitReverb()
        if let reverb = reverbNode {
            reverb.loadFactoryPreset(.mediumHall)
            reverb.wetDryMix = 25 // Subtle reverb
            audioEngine.attach(reverb)
        }
        
        // Add EQ for lofi warmth
        eqNode = AVAudioUnitEQ(numberOfBands: 2)
        if let eq = eqNode {
            // Low shelf boost for warmth
            eq.bands[0].filterType = .lowShelf
            eq.bands[0].frequency = 200
            eq.bands[0].gain = 3
            eq.bands[0].bypass = false
            
            // High cut for lofi character
            eq.bands[1].filterType = .highShelf
            eq.bands[1].frequency = 4000
            eq.bands[1].gain = -12
            eq.bands[1].bypass = false
            
            audioEngine.attach(eq)
        }
        
        // Create and attach tone generators for each chakra
        for chakraType in ChakraType.allCases {
            let playerNode = AVAudioPlayerNode()
            audioEngine.attach(playerNode)
            toneGenerators[chakraType] = playerNode
        }
    }
    
    private func connectAudioNodes(_ audioEngine: AVAudioEngine) {
        // Connect effects chain
        if let reverb = reverbNode, let eq = eqNode {
            audioEngine.connect(reverb, to: eq, format: nil)
            audioEngine.connect(eq, to: audioEngine.mainMixerNode, format: nil)
        }
        
        // Connect player nodes
        for (chakraType, playerNode) in toneGenerators {
            // Connect to reverb for spacious sound
            if let reverb = reverbNode {
                audioEngine.connect(playerNode, to: reverb, format: nil)
            } else {
                audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: nil)
            }
        }
    }
    
    private func generateToneBuffers() {
        // Generate tone buffer for each chakra
        for chakraType in ChakraType.allCases {
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
        
        // Create a warm, lofi tone
        for frame in 0..<frameCount {
            let time = Double(frame) / sampleRate
            
            // Much softer attack for meditation (200ms attack time)
            let attackTime = 0.2
            let releaseTime = 0.2
            let attack = min(1.0, time / attackTime)
            let release = min(1.0, (duration - time) / releaseTime)
            let envelope = attack * release
            
            // Fundamental frequency with very subtle vibrato
            let vibrato = 1.0 + (sin(time * 0.3) * 0.001) // Very subtle
            let fundamental = sin(2.0 * .pi * frequency * vibrato * time)
            
            // Reduced harmonics for softer sound
            let harmonic2 = sin(2.0 * .pi * frequency * 2.0 * time) * 0.05
            let harmonic3 = sin(2.0 * .pi * frequency * 3.0 * time) * 0.02
            
            // Add subtle noise for analog warmth
            let noise = (Double.random(in: -1...1) * 0.002)
            
            // Combine with reduced amplitude for gentleness
            let value = (fundamental + harmonic2 + harmonic3 + noise) * envelope * 0.2
            
            // Soft limiting to prevent any harshness
            let limited = tanh(value * 0.8)
            
            buffer.floatChannelData?[0][frame] = Float(limited) // Left channel
            buffer.floatChannelData?[1][frame] = Float(limited) // Right channel
        }
        
        return buffer
    }
    
    /// Subscribe to heart rate updates
    private func subscribeToHeartRate() {
        // Subscribe to heart rate from HealthKitManager
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(heartRateDidUpdate(_:)),
            name: Notification.Name("HeartRateDidUpdate"),
            object: nil
        )
    }
    
    @objc private func heartRateDidUpdate(_ notification: Notification) {
        if let heartRate = notification.userInfo?["heartRate"] as? Double {
            currentHeartRate = heartRate
        }
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
        
        // Ensure we're on the main thread for audio operations
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.playTone(for: type, continuous: continuous)
            }
            return
        }
        
        // Stop any existing playback first
        if playerNode.isPlaying {
            playerNode.stop()
        }
        
        // Start engine if needed
        if !audioEngine.isRunning {
            do {
                // Prepare the engine first
                audioEngine.prepare()
                try audioEngine.start()
                isAudioEngineRunning = true
                
                // Small delay to ensure engine is ready
                Thread.sleep(forTimeInterval: 0.1)
            } catch {
                print("❌ Failed to start audio engine: \(error)")
                return
            }
        }
        
        // Check if the player node is properly attached and connected
        guard audioEngine.attachedNodes.contains(playerNode) else {
            print("❌ Player node not attached to engine")
            return
        }
        
        // Set volume from chakra state
        if let chakraState = chakraStates.first(where: { $0.type == type }) {
            playerNode.volume = chakraState.volume * configuration.volumeLevel
        } else {
            playerNode.volume = configuration.volumeLevel
        }
        
        // Reset the player before scheduling
        playerNode.reset()
        
        // Schedule buffer
        if continuous {
            playerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
        } else {
            playerNode.scheduleBuffer(buffer, at: nil, options: .interrupts, completionHandler: nil)
        }
        
        // Play with error handling
        do {
            playerNode.play()
        } catch {
            print("❌ Failed to play audio: \(error)")
        }
    }
    
    private func stopTone(for type: ChakraType) {
        // Ensure we're on the main thread
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.stopTone(for: type)
            }
            return
        }
        
        toneGenerators[type]?.stop()
        
        // Check if any nodes are still playing
        let anyPlaying = toneGenerators.values.contains { $0.isPlaying }
        
        // Stop the engine if no nodes are playing
        if !anyPlaying && audioEngine?.isRunning == true {
            audioEngine?.stop()
            isAudioEngineRunning = false
        }
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
        
        // Create haptic pattern based on heart rate BPM
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4) // Gentler
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2) // Softer
        
        // Calculate pulse interval based on heart rate (60 / BPM = seconds per beat)
        let pulseInterval = 60.0 / currentHeartRate
        
        var events: [CHHapticEvent] = []
        
        if continuous {
            // Create heartbeat-like pattern
            for i in 0..<30 { // About 30 beats
                // Main beat
                let mainBeat = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [intensity, sharpness],
                    relativeTime: Double(i) * pulseInterval
                )
                events.append(mainBeat)
                
                // Subtle second beat (like lub-dub)
                let secondBeat = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.2),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.1)
                    ],
                    relativeTime: Double(i) * pulseInterval + 0.1
                )
                events.append(secondBeat)
            }
        } else {
            // Single gentle pulse
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
    
    // Add tanh function for soft limiting
    private func tanh(_ x: Double) -> Double {
        return (exp(x) - exp(-x)) / (exp(x) + exp(-x))
    }
} 