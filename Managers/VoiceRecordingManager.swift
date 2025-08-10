//
//  VoiceRecordingManager.swift
//  VybeMVP
//
//  Created for Cosmic Journal Enhancement
//

import Foundation
import AVFoundation
import Combine
import os

/**
 * VoiceRecordingManager - Sacred Audio Recording Interface
 *
 * This manager handles voice recording and playback for journal entries,
 * creating a spiritual audio interface where users can record spoken reflections
 * and access them as part of their sacred journaling experience.
 */
class VoiceRecordingManager: NSObject, ObservableObject {

    // MARK: - Published Properties
    @Published var isRecording = false
    @Published var isPlaying = false
    @Published var currentRecordingLevel: Float = 0.0
    @Published var recordingDuration: TimeInterval = 0.0
    @Published var playbackProgress: Double = 0.0
    @Published var recordingJustCompleted = false // Track when a recording just finished

    // MARK: - Private Properties
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var recordingTimer: Timer?
    private var playbackTimer: Timer?
    private let logger = Logger(subsystem: "com.vybemvp", category: "voice-recording")

    // MARK: - Singleton
    static let shared = VoiceRecordingManager()

    override init() {
        super.init()
        setupAudioSession()
    }

    // MARK: - Audio Session Setup

    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try audioSession.setActive(true)
            logger.info("✅ Audio session configured for recording and playback")
        } catch {
            logger.error("❌ Failed to setup audio session: \(error)")
        }
    }

    // MARK: - Recording Methods

    /**
     * Starts recording a voice memo for a journal entry.
     * Creates a unique filename based on the current timestamp.
     */
    func startRecording() -> String? {
        guard !isRecording else {
            logger.warning("⚠️ Recording already in progress")
            return nil
        }

        let filename = generateRecordingFilename()
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioURL = documentsPath.appendingPathComponent(filename)

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()

            isRecording = true
            recordingDuration = 0.0
            startRecordingTimer()

            logger.info("🎙️ Started recording: \(filename)")
            return filename
        } catch {
            logger.error("❌ Failed to start recording: \(error)")
            return nil
        }
    }

    /**
     * Stops the current recording and returns the filename.
     */
    func stopRecording() -> String? {
        guard isRecording, let recorder = audioRecorder else {
            logger.warning("⚠️ No active recording to stop")
            return nil
        }

        recorder.stop()
        isRecording = false
        recordingTimer?.invalidate()

        let filename = recorder.url.lastPathComponent

        // Set flag to indicate recording just completed
        recordingJustCompleted = true

        // Wait a moment for the file to be properly written, then reset the flag
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.recordingJustCompleted = false
            self.logger.info("⏹️ Recording finalized: \(filename)")
        }

        logger.info("⏹️ Stopped recording: \(filename)")
        return filename
    }

    // MARK: - Playback Methods

    /**
     * Plays back a voice recording by filename.
     */
    func playRecording(filename: String) {
        guard !isPlaying else {
            logger.warning("⚠️ Already playing audio")
            return
        }

        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioURL = documentsPath.appendingPathComponent(filename)

        guard FileManager.default.fileExists(atPath: audioURL.path) else {
            logger.error("❌ Audio file not found: \(filename)")
            return
        }

        // Additional verification that file is readable
        guard FileManager.default.isReadableFile(atPath: audioURL.path) else {
            logger.error("❌ Audio file not readable: \(filename)")
            return
        }

        // Check file size to ensure it's not empty
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: audioURL.path)
            let fileSize = attributes[.size] as? NSNumber
            guard let size = fileSize, size.intValue > 0 else {
                logger.error("❌ Audio file is empty: \(filename)")
                return
            }
        } catch {
            logger.error("❌ Could not read file attributes: \(error)")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.delegate = self
            audioPlayer?.play()

            isPlaying = true
            playbackProgress = 0.0
            startPlaybackTimer()

            logger.info("▶️ Started playback: \(filename)")
        } catch {
            logger.error("❌ Failed to play recording: \(error)")
        }
    }

    /**
     * Stops the current playback.
     */
    func stopPlayback() {
        audioPlayer?.stop()
        isPlaying = false
        playbackProgress = 0.0
        playbackTimer?.invalidate()

        logger.info("⏹️ Stopped playback")
    }

    // MARK: - Utility Methods

    /**
     * Generates a unique filename for voice recordings.
     */
    private func generateRecordingFilename() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let timestamp = formatter.string(from: Date())
        return "voice_\(timestamp).m4a"
    }

    /**
     * Checks if a recording file exists for the given filename.
     */
    func recordingExists(filename: String) -> Bool {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioURL = documentsPath.appendingPathComponent(filename)
        return FileManager.default.fileExists(atPath: audioURL.path)
    }

    /**
     * Deletes a recording file.
     */
    func deleteRecording(filename: String) {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioURL = documentsPath.appendingPathComponent(filename)

        do {
            try FileManager.default.removeItem(at: audioURL)
            logger.info("🗑️ Deleted recording: \(filename)")
        } catch {
            logger.error("❌ Failed to delete recording: \(error)")
        }
    }

    /**
     * Gets the duration of a recording file.
     */
    func getRecordingDuration(filename: String) -> TimeInterval? {
        // If recording just completed, wait a moment for file to be finalized
        if recordingJustCompleted {
            return nil // Return nil to show "Processing..." in UI
        }

        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioURL = documentsPath.appendingPathComponent(filename)

        // Verify file exists and is accessible
        guard FileManager.default.fileExists(atPath: audioURL.path) else {
            logger.warning("⚠️ Audio file not found for duration check: \(filename)")
            return nil
        }

        // Additional check for file readability
        guard FileManager.default.isReadableFile(atPath: audioURL.path) else {
            logger.warning("⚠️ Audio file not readable: \(filename)")
            return nil
        }

        // Check file size to ensure it's not empty or incomplete
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: audioURL.path)
            let fileSize = attributes[.size] as? NSNumber
            guard let size = fileSize, size.intValue > 1000 else { // Require at least 1KB
                logger.warning("⚠️ Audio file too small, may be incomplete: \(filename)")
                return nil
            }
        } catch {
            logger.error("❌ Could not read file attributes: \(error)")
            return nil
        }

        do {
            let player = try AVAudioPlayer(contentsOf: audioURL)
            return player.duration
        } catch {
            logger.error("❌ Failed to get recording duration: \(error)")
            return nil
        }
    }

    // MARK: - Timer Management

    private func startRecordingTimer() {
        recordingTimer = Timer.scheduledTimer(withTimeInterval: VybeConstants.voiceRecordingMetricsInterval, repeats: true) { [weak self] _ in
            self?.updateRecordingMetrics()
        }
    }

    private func startPlaybackTimer() {
        playbackTimer = Timer.scheduledTimer(withTimeInterval: VybeConstants.voicePlaybackProgressInterval, repeats: true) { [weak self] _ in
            self?.updatePlaybackProgress()
        }
    }

    private func updateRecordingMetrics() {
        guard let recorder = audioRecorder else { return }

        recorder.updateMeters()
        recordingDuration = recorder.currentTime
        currentRecordingLevel = recorder.averagePower(forChannel: 0)
    }

    private func updatePlaybackProgress() {
        guard let player = audioPlayer else { return }

        playbackProgress = player.currentTime / player.duration
    }

    deinit {
        recordingTimer?.invalidate()
        playbackTimer?.invalidate()
    }
}

// MARK: - AVAudioRecorderDelegate

extension VoiceRecordingManager: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        isRecording = false
        recordingTimer?.invalidate()

        if flag {
            logger.info("✅ Recording completed successfully")
        } else {
            logger.error("❌ Recording failed")
        }
    }
}

// MARK: - AVAudioPlayerDelegate

extension VoiceRecordingManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        playbackProgress = 0.0
        playbackTimer?.invalidate()

        if flag {
            logger.info("✅ Playback completed successfully")
        } else {
            logger.error("❌ Playback failed")
        }
    }
}
