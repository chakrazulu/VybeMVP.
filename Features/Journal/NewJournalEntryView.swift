/*
 * ========================================
 * ✨ NEW JOURNAL ENTRY VIEW - SACRED REFLECTION CREATION
 * ========================================
 * 
 * CORE PURPOSE:
 * Comprehensive journal entry creation interface with voice recording,
 * text input, mood selection, and sacred numerology integration.
 * Provides a mystical, immersive experience for spiritual reflection.
 * 
 * SCREEN LAYOUT (iPhone 14 Pro Max: 430×932 points):
 * • NavigationView: "Sacred Reflection" title with inline display
 * • CosmicBackgroundView: Full-screen space travel animation
 * • Floating Sacred Numbers: Subtle animated numerology overlay
 * • ScrollView: Main content with 24pt spacing
 * • Multiple Sections: Header, badges, voice, text, mood, privacy
 * 
 * UI COMPONENTS:
 * • Sacred Header: Gradient title with mystical styling
 * • Numerology Badges: Focus and Realm number displays
 * • Voice Recording: Audio capture with visual feedback
 * • Text Entry: Title and content input fields
 * • Mood Selection: Emoji-based mood tracking
 * • Privacy Notice: Data security assurance
 * 
 * FEATURES:
 * • Voice Recording: Audio capture with VoiceRecordingManager
 * • Text Input: Title and content with focus management
 * • Mood Tracking: Emoji selection for emotional state
 * • Numerology Integration: Real-time focus and realm numbers
 * • Cosmic Aesthetics: Space background with floating numbers
 * • Privacy Focus: Clear data security messaging
 * 
 * STATE MANAGEMENT:
 * • Environment Objects: JournalManager, FocusNumberManager, RealmNumberManager
 * • State Objects: VoiceRecordingManager, form fields, UI state
 * • Focus State: Field focus management for keyboard handling
 * • Animation State: Pulse animations for mystical effects
 * 
 * INTEGRATION POINTS:
 * • JournalManager: Entry creation and persistence
 * • VoiceRecordingManager: Audio capture and playback
 * • FocusNumberManager: Current focus number display
 * • RealmNumberManager: Current realm number display
 * • CosmicBackgroundView: Space travel animation
 * • Core Data: Entry persistence via managed object context
 * 
 * USER EXPERIENCE:
 * • Immersive cosmic environment for reflection
 * • Voice and text input options for different preferences
 * • Real-time numerology integration
 * • Smooth animations and transitions
 * • Clear privacy and security messaging
 */

import SwiftUI
import AVFoundation

/**
 * NewJournalEntryView: Sacred journal entry creation interface
 * 
 * Provides a comprehensive, mystical interface for creating
 * journal entries with voice recording, text input, and
 * numerology integration in a cosmic environment.
 */
struct NewJournalEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var journalManager: JournalManager
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    @EnvironmentObject var realmNumberManager: RealmNumberManager
    @StateObject private var voiceManager = VoiceRecordingManager.shared
    
    // Claude: KASPER MLX Journal Integration
    @StateObject private var kasperMLX = KASPERMLXManager.shared
    @StateObject private var kasperFeedback = KASPERFeedbackManager.shared
    
    // MARK: - State Properties
    
    /// Journal entry title input
    @State private var title = ""
    
    /// Journal entry content input
    @State private var content = ""
    
    /// Selected mood emoji for emotional tracking
    @State private var selectedMoodEmoji = ""
    
    /// Filename of recorded voice memo
    @State private var voiceRecordingFilename: String?
    
    /// Controls voice recording interface visibility
    @State private var showingVoiceInterface = false
    
    /// Controls pulse animation for mystical effects
    @State private var pulseAnimation = false
    
    // Claude: KASPER MLX Journal States
    /// Controls visibility of KASPER MLX insight section
    @State private var showKasperInsight = false
    
    /// Stores the generated KASPER insight for this journal entry
    @State private var kasperInsight: KASPERInsight?
    
    // MARK: - Focus Management
    
    /// Manages keyboard focus for text input fields
    @FocusState private var focusedField: Field?
    
    /// Text field focus enumeration
    enum Field {
        case title, content, mood
    }
    
    // MARK: - Computed Properties
    
    /// Current effective focus number for numerology display
    private var focusNumber: Int {
        focusNumberManager.effectiveFocusNumber
    }
    
    /// Current realm number for numerology display
    private var realmNumber: Int {
        realmNumberManager.currentRealmNumber
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                // MARK: - Cosmic Background Layer
                CosmicBackgroundView()
                    .ignoresSafeArea()
                
                // MARK: - Floating Sacred Numbers Overlay
                cosmicNumbersOverlay
                
                // MARK: - Main Content ScrollView
                ScrollView {
                    VStack(spacing: 24) {
                        // MARK: - Sacred Header Section
                        sacredHeaderSection
                        
                        // MARK: - Sacred Numbers Display
                        numerologyBadgesSection
                        
                        // MARK: - Voice Recording Section
                        voiceRecordingSection
                        
                        // MARK: - Text Entry Section
                        textEntrySection
                        
                        // MARK: - Mood Selection Section
                        moodSelectionSection
                        
                        // Claude: KASPER MLX Journal Insight Section
                        if showKasperInsight {
                            kasperMLXInsightSection
                        }
                        
                        // MARK: - Privacy Notice Section
                        privacyNoticeSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Sacred Reflection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // MARK: - Cancel Button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { 
                        cleanupAndDismiss()
                    }
                    .foregroundColor(.purple)
                }
                // Claude: KASPER MLX Insight Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        // KASPER MLX Insight Button
                        Button(action: {
                            showKasperInsight = true
                            if kasperInsight == nil {
                                generateJournalInsight()
                            }
                        }) {
                            Image(systemName: "sparkles")
                                .font(.title3)
                                .foregroundColor(.purple)
                        }
                        .disabled(content.isEmpty && title.isEmpty)
                        
                        // Save Button
                        Button("Save") { 
                            saveEntry() 
                        }
                        .foregroundColor(.purple)
                        .fontWeight(.semibold)
                        .disabled(content.isEmpty && voiceRecordingFilename == nil)
                    }
                }
            }
            .onAppear {
                // MARK: - Initialize Pulse Animation
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    pulseAnimation = true
                }
                // MARK: - Set Initial Focus to Title Field
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    focusedField = .title
                }
            }
        }
    }
    
    // MARK: - Cosmic Numbers Overlay
    
    private var cosmicNumbersOverlay: some View {
        ZStack {
            ForEach(0..<2, id: \.self) { index in
                Text(getFloatingNumber(for: index))
                    .font(.system(size: 100, weight: .ultraLight, design: .rounded))
                    .foregroundColor(getFloatingNumberColor(for: index))
                    .opacity(0.12)
                    .scaleEffect(pulseAnimation ? 1.08 : 0.92)
                    .animation(.easeInOut(duration: 4.0 + Double(index)).repeatForever(autoreverses: true), value: pulseAnimation)
                    .offset(x: getFloatingOffset(index: index).x, y: getFloatingOffset(index: index).y)
            }
        }
    }
    
    // MARK: - Sacred Header Section
    
    private var sacredHeaderSection: some View {
        VStack(spacing: 12) {
            Text("✨ Sacred Space ✨")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [.white, .purple.opacity(0.9)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            Text("This space is sacred. Only you can access these reflections.")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .italic()
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.purple.opacity(0.6), .blue.opacity(0.4)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Numerology Badges Section
    
    private var numerologyBadgesSection: some View {
        HStack(spacing: 20) {
            // Focus Number Badge
            NumerologyBadge(
                number: focusNumber,
                title: "Focus",
                subtitle: "Your chosen path",
                color: sacredNumberColor(for: focusNumber)
            )
            
            // Realm Number Badge
            NumerologyBadge(
                number: realmNumber,
                title: "Realm",
                subtitle: "Cosmic frequency",
                color: sacredNumberColor(for: realmNumber)
            )
        }
        .padding(.horizontal)
    }
    
    // MARK: - Voice Recording Section
    
    private var voiceRecordingSection: some View {
        VStack(spacing: 16) {
            Text("🎙️ Voice Reflection")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Show recording interface when actively recording OR when no recording exists
            if voiceManager.isRecording || voiceRecordingFilename == nil {
                voiceRecordingInterface
            } else if let filename = voiceRecordingFilename {
                // Only show existing recording view when we have a completed recording
                existingVoiceRecordingView(filename: filename)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.cyan.opacity(0.5), lineWidth: 1)
                )
        )
        .shadow(color: .cyan.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    private var voiceRecordingInterface: some View {
        VStack(spacing: 12) {
            if voiceManager.isRecording {
                // Recording in progress - show red waveform interface
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(RadialGradient(
                                gradient: Gradient(colors: [.red.opacity(0.6), .red.opacity(0.2)]),
                                center: .center,
                                startRadius: 10,
                                endRadius: 30
                            ))
                            .frame(width: 60, height: 60)
                            .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: pulseAnimation)
                        
                        Image(systemName: "mic.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Text(formatDuration(voiceManager.recordingDuration))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("Recording your sacred words...")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                    // Stop Recording Button
                    Button(action: stopRecording) {
                        HStack(spacing: 8) {
                            Image(systemName: "stop.circle.fill")
                                .font(.title2)
                            Text("Stop Recording")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.red.opacity(0.8))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            } else {
                // Not recording - show start recording button
                Button(action: startRecording) {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [.blue, .cyan]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 60, height: 60)
                            
                            Image(systemName: "mic.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        
                        Text("Record Voice Reflection")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        Text("Tap to begin recording")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(voiceManager.isRecording) // Prevent multiple taps
            }
        }
        .animation(.easeInOut(duration: 0.3), value: voiceManager.isRecording)
    }
    
    private func existingVoiceRecordingView(filename: String) -> some View {
        HStack(spacing: 16) {
            // Play/Pause Button
            Button(action: {
                if voiceManager.isPlaying {
                    voiceManager.stopPlayback()
                } else {
                    // Verify file exists and is ready before attempting playback
                    if voiceManager.recordingExists(filename: filename) && !voiceManager.recordingJustCompleted {
                        voiceManager.playRecording(filename: filename)
                    } else if !voiceManager.recordingExists(filename: filename) {
                        // File no longer exists, reset state
                        voiceRecordingFilename = nil
                    }
                    // If recordingJustCompleted, do nothing - wait for processing
                }
            }) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.green, .teal]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 50, height: 50)
                    
                    if voiceManager.recordingJustCompleted {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: voiceManager.isPlaying ? "pause.fill" : "play.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(!voiceManager.recordingExists(filename: filename) || voiceManager.recordingJustCompleted)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Voice Recording")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                if voiceManager.recordingJustCompleted {
                    Text("Processing...")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                } else if let duration = voiceManager.getRecordingDuration(filename: filename) {
                    Text(formatDuration(duration))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                } else {
                    Text("Processing...")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                if voiceManager.isPlaying {
                    ProgressView(value: voiceManager.playbackProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .cyan))
                        .frame(height: 4)
                }
            }
            
            Spacer()
            
            // Delete Recording Button
            Button(action: deleteVoiceRecording) {
                Image(systemName: "trash.circle.fill")
                    .font(.title2)
                    .foregroundColor(.red.opacity(0.8))
            }
            .disabled(voiceManager.recordingJustCompleted) // Disable during processing
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
        )
    }
    
    // MARK: - Text Entry Section
    
    private var textEntrySection: some View {
        VStack(spacing: 16) {
            Text("📝 Written Reflection")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                // Title Field
                CosmicTextField(
                    text: $title,
                    placeholder: "Give your reflection a sacred title...",
                    focusState: $focusedField,
                    focusValue: .title
                ) {
                    focusedField = .content
                }
                
                // Content Field
                CosmicTextEditor(
                    text: $content,
                    placeholder: "Share your deepest thoughts and sacred insights..."
                )
                .focused($focusedField, equals: .content)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                )
        )
        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Mood Selection Section
    
    private var moodSelectionSection: some View {
        VStack(spacing: 16) {
            Text("🌙 Sacred Mood")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(JournalMood.allCases, id: \.rawValue) { mood in
                        MoodSelectionButton(
                            mood: mood,
                            isSelected: selectedMoodEmoji == mood.rawValue
                        ) {
                            selectedMoodEmoji = selectedMoodEmoji == mood.rawValue ? "" : mood.rawValue
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.orange.opacity(0.5), lineWidth: 1)
                )
        )
        .shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Privacy Notice Section
    
    private var privacyNoticeSection: some View {
        HStack(spacing: 12) {
            Image(systemName: "lock.shield.fill")
                .font(.title2)
                .foregroundColor(.green)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Sacred Privacy")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text("Your reflections are encrypted and stored only on your device")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.green.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Helper Methods
    
    private func startRecording() {
        // Reset any previous recording state
        if let existingFilename = voiceRecordingFilename {
            voiceManager.deleteRecording(filename: existingFilename)
            voiceRecordingFilename = nil
        }
        
        // Start new recording and track filename
        if let filename = voiceManager.startRecording() {
            voiceRecordingFilename = filename
            pulseAnimation = true
        }
    }
    
    private func stopRecording() {
        if let filename = voiceManager.stopRecording() {
            voiceRecordingFilename = filename
        }
        pulseAnimation = false
    }
    
    private func deleteVoiceRecording() {
        if let filename = voiceRecordingFilename {
            voiceManager.deleteRecording(filename: filename)
            voiceRecordingFilename = nil
        }
    }
    
    private func cleanupAndDismiss() {
        // Clean up any unsaved voice recording
        if let filename = voiceRecordingFilename {
            voiceManager.deleteRecording(filename: filename)
        }
        dismiss()
    }
    
    private func saveEntry() {
        guard !content.isEmpty || voiceRecordingFilename != nil else { return }
        
        _ = journalManager.createEntry(
            title: title.isEmpty ? "Sacred Reflection" : title,
            content: content,
            focusNumber: focusNumber,
            realmNumber: realmNumber,
            moodEmoji: selectedMoodEmoji.isEmpty ? nil : selectedMoodEmoji,
            voiceRecordingFilename: voiceRecordingFilename
        )
        
        dismiss()
    }
    
    // MARK: - Sacred Number Helpers
    
    private func sacredNumberColor(for number: Int) -> Color {
        switch number {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        case 6: return .indigo
        case 7: return .purple
        case 8: return Color(red: 1.0, green: 0.84, blue: 0.0) // Gold
        case 9: return .white
        default: return .gray
        }
    }
    
    private func getFloatingNumber(for index: Int) -> String {
        let numbers = [focusNumber, realmNumber, (focusNumber + realmNumber) % 10]
        return "\(numbers[index % numbers.count])"
    }
    
    private func getFloatingNumberColor(for index: Int) -> Color {
        let numbers = [focusNumber, realmNumber, (focusNumber + realmNumber) % 10]
        return sacredNumberColor(for: numbers[index % numbers.count])
    }
    
    private func getFloatingOffset(index: Int) -> CGPoint {
        let positions = [
            CGPoint(x: -120, y: -180),
            CGPoint(x: 100, y: -120)
        ]
        return positions[index % positions.count]
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        guard duration.isFinite && !duration.isNaN else { return "0:00" }
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    // MARK: - KASPER MLX Journal Insight Section
    
    /// Claude: KASPER MLX Journal Integration
    /// Generates personalized insights based on journal content for spiritual reflection
    private var kasperMLXInsightSection: some View {
        VStack(spacing: 16) {
            kasperMLXHeader
            kasperMLXContent
        }
    }
    
    /// Claude: Header section for KASPER MLX insights
    private var kasperMLXHeader: some View {
        HStack {
            Text("🔮 AI Spiritual Insight")
                .font(.headline)
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: { showKasperInsight = false }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
    }
    
    /// Claude: Content section for KASPER MLX insights
    private var kasperMLXContent: some View {
        VStack(spacing: 12) {
            if kasperMLX.isGeneratingInsight {
                kasperMLXLoadingState
            } else if let insight = kasperInsight {
                kasperMLXInsightDisplay(insight)
            } else {
                kasperMLXGenerateButton
            }
        }
    }
    
    /// Claude: Loading state for insight generation
    private var kasperMLXLoadingState: some View {
        VStack(spacing: 8) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                .scaleEffect(0.8)
            
            Text("Analyzing your sacred reflection...")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .italic()
        }
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.purple.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    /// Claude: Display generated insight with actions
    private func kasperMLXInsightDisplay(_ insight: KASPERInsight) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(insight.content)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.leading)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
            
            kasperMLXInsightMetadata(insight)
            kasperMLXActionButtons
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.purple.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    /// Claude: Insight metadata display
    private func kasperMLXInsightMetadata(_ insight: KASPERInsight) -> some View {
        HStack {
            Text("Confidence: \(Int(insight.confidence * 100))%")
                .font(.caption2)
                .foregroundColor(.green.opacity(0.8))
            
            Spacer()
            
            Text("Generated \(insight.generatedAt, style: .relative) ago")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
    
    /// Claude: Action buttons for insights
    private var kasperMLXActionButtons: some View {
        HStack(spacing: 16) {
            kasperMLXRegenerateButton
            Spacer()
            kasperMLXFeedbackButtons
        }
        .padding(.top, 8)
    }
    
    /// Claude: Regenerate insight button
    private var kasperMLXRegenerateButton: some View {
        Button(action: generateJournalInsight) {
            HStack(spacing: 4) {
                Image(systemName: "arrow.clockwise")
                    .font(.caption)
                Text("New Insight")
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(.purple)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.purple.opacity(0.1))
                    .overlay(
                        Capsule()
                            .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .disabled(kasperMLX.isGeneratingInsight)
    }
    
    /// Claude: Feedback buttons for insights
    private var kasperMLXFeedbackButtons: some View {
        HStack(spacing: 12) {
            Button(action: { provideJournalFeedback(positive: true) }) {
                Image(systemName: "hand.thumbsup.fill")
                    .font(.caption)
                    .foregroundColor(.green)
                    .scaleEffect(1.1)
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: { provideJournalFeedback(positive: false) }) {
                Image(systemName: "hand.thumbsdown.fill")
                    .font(.caption)
                    .foregroundColor(.red)
                    .scaleEffect(1.1)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    /// Claude: Generate insight button
    private var kasperMLXGenerateButton: some View {
        Button(action: generateJournalInsight) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.caption)
                    .foregroundColor(.purple)
                
                Text("Generate Spiritual Insight")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "arrow.right.circle")
                    .font(.caption)
                    .foregroundColor(.purple)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.purple.opacity(0.4), lineWidth: 1)
                    )
            )
        }
        .disabled(!kasperMLX.isReady)
    }
    
    // MARK: - KASPER MLX Journal Methods
    
    /// Claude: Generates a journal insight using KASPER MLX based on current content
    private func generateJournalInsight() {
        Task {
            do {
                print("🔮 KASPER MLX: Generating journal insight")
                
                // Configure KASPER MLX if needed
                await kasperMLX.configure(
                    realmManager: realmNumberManager,
                    focusManager: focusNumberManager,
                    healthManager: HealthKitManager.shared // Use shared instance
                )
                
                // Clear cache for fresh insight
                await kasperMLX.clearCache()
                
                // Generate insight with current journal content
                let insight = try await kasperMLX.generateJournalInsight(
                    entryText: content.isEmpty ? title : content,
                    tone: selectedMoodEmoji.isEmpty ? nil : selectedMoodEmoji
                )
                
                kasperInsight = insight
                print("🔮 KASPER MLX: Journal insight generated: \(insight.content)")
                
            } catch {
                print("🔮 KASPER MLX: Failed to generate journal insight: \(error)")
            }
        }
    }
    
    /// Claude: Provides feedback on journal insights for future AI training
    private func provideJournalFeedback(positive: Bool) {
        let rating: FeedbackRating = positive ? .positive : .negative
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: positive ? .light : .soft)
        impactFeedback.impactOccurred()
        
        // Record feedback persistently
        if let insight = kasperInsight {
            kasperFeedback.recordFeedback(
                for: insight,
                rating: rating,
                contextData: [
                    "journalTitle": title,
                    "journalContentLength": "\(content.count)",
                    "mood": selectedMoodEmoji,
                    "hasVoiceRecording": voiceRecordingFilename != nil ? "true" : "false"
                ]
            )
            
            print("🔮 KASPER MLX: Journal feedback \(rating.emoji) recorded persistently")
        }
    }
}

// MARK: - Supporting Views

struct NumerologyBadge: View {
    let number: Int
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [color.opacity(0.6), color.opacity(0.2)]),
                            center: .center,
                            startRadius: 10,
                            endRadius: 30
                        )
                    )
                    .frame(width: 60, height: 60)
                
                Text("\(number)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                    .textCase(.uppercase)
                    .tracking(0.5)
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct CosmicTextField: View {
    @Binding var text: String
    let placeholder: String
    @FocusState.Binding var focusState: NewJournalEntryView.Field?
    let focusValue: NewJournalEntryView.Field
    let onSubmit: () -> Void
    
    var body: some View {
        TextField(placeholder, text: $text)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                focusState == focusValue ? Color.cyan : Color.white.opacity(0.3),
                                lineWidth: focusState == focusValue ? 2 : 1
                            )
                    )
            )
            .focused($focusState, equals: focusValue)
            .submitLabel(.next)
            .onSubmit(onSubmit)
    }
}

struct CosmicTextEditor: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.top, 8)
                    .padding(.leading, 4)
            }
            
            TextEditor(text: $text)
                .font(.body)
                .foregroundColor(.white)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 120)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct MoodSelectionButton: View {
    let mood: JournalMood
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(mood.rawValue)
                    .font(.title2)
                
                Text(mood.description)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.orange.opacity(0.3) : Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? Color.orange : Color.white.opacity(0.2),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
} 
