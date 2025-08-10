/*
 * ========================================
 * 📖 JOURNAL ENTRY DETAIL VIEW - SACRED REFLECTION DISPLAY
 * ========================================
 *
 * CORE PURPOSE:
 * Comprehensive display interface for viewing journal entries with voice playback,
 * numerology integration, and mystical aesthetics. Provides a sacred space for
 * reflecting on past spiritual insights and experiences.
 *
 * SCREEN LAYOUT (iPhone 14 Pro Max: 430×932 points):
 * • NavigationView: "Sacred Reflection" title with inline display
 * • CosmicBackgroundView: Full-screen space travel animation
 * • Cosmic Number Overlay: Animated focus number display
 * • ScrollView: Main content with 24pt spacing
 * • Multiple Sections: Header, badges, voice, content, metadata
 *
 * UI COMPONENTS:
 * • Sacred Header: Entry title with gradient styling and timestamp
 * • Numerology Badges: Focus and Realm number displays
 * • Voice Playback: Audio playback interface with controls
 * • Content Display: Journal entry text content
 * • Metadata Section: Entry details and mood information
 * • Action Menu: Edit and delete options
 *
 * FEATURES:
 * • Voice Playback: Audio recording playback with VoiceRecordingManager
 * • Numerology Display: Focus and Realm number badges
 * • Cosmic Aesthetics: Space background with floating numbers
 * • Entry Management: Edit and delete capabilities
 * • Timestamp Display: Creation date and time information
 * • Mood Tracking: Emotional state display
 *
 * STATE MANAGEMENT:
 * • Environment Objects: JournalManager for data access
 * • State Objects: VoiceRecordingManager, UI state
 * • Entry Data: JournalEntry model with all entry information
 * • Animation State: Pulse animations for mystical effects
 *
 * INTEGRATION POINTS:
 * • JournalManager: Entry data access and deletion
 * • VoiceRecordingManager: Audio playback functionality
 * • EditJournalEntryView: Modal editing interface
 * • CosmicBackgroundView: Space travel animation
 * • Navigation system: Standard iOS navigation patterns
 *
 * USER EXPERIENCE:
 * • Immersive cosmic environment for reflection
 * • Voice and text content display
 * • Numerology integration for spiritual context
 * • Smooth animations and transitions
 * • Comprehensive entry management options
 */

import SwiftUI
import AVFoundation

/**
 * JournalEntryDetailView: Sacred journal entry display interface
 *
 * Provides a comprehensive, mystical interface for viewing
 * journal entries with voice playback, numerology integration,
 * and cosmic aesthetics for spiritual reflection.
 */
struct JournalEntryDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var journalManager: JournalManager
    @StateObject private var voiceManager = VoiceRecordingManager.shared

    // MARK: - Properties

    /// Journal entry to display
    let entry: JournalEntry

    // MARK: - State Properties

    /// Controls delete confirmation alert visibility
    @State private var showingDeleteAlert = false

    /// Controls edit sheet modal visibility
    @State private var showingEditSheet = false

    /// Controls pulse animation for mystical effects
    @State private var pulseAnimation = false

    // MARK: - Body

    var body: some View {
        ZStack {
            // MARK: - Cosmic Background Layer
            CosmicBackgroundView()
                .ignoresSafeArea()

            // MARK: - Sacred Floating Number Overlay
            cosmicNumberOverlay

            // MARK: - Main Content ScrollView
            ScrollView {
                VStack(spacing: 24) {
                    // MARK: - Sacred Header Section
                    sacredHeaderSection

                    // MARK: - Numerology Badges Section
                    numerologyBadgesSection

                    // MARK: - Voice Recording Section (if exists)
                    if let voiceFilename = entry.voiceRecordingFilename {
                        voicePlaybackSection(filename: voiceFilename)
                    }

                    // MARK: - Content Section
                    contentSection

                    // MARK: - Metadata Section
                    metadataSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
        .navigationTitle("Sacred Reflection")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // MARK: - Action Menu
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
                        showingEditSheet = true
                    }) {
                        Label("Edit", systemImage: "pencil")
                    }

                    Divider()

                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.white)
                }
            }
        }
        // MARK: - Edit Sheet Modal
        .sheet(isPresented: $showingEditSheet) {
            NavigationView {
                EditJournalEntryView(entry: entry)
            }
        }
        // MARK: - Delete Confirmation Alert
        .alert("Delete Sacred Entry?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                deleteEntry()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This sacred reflection will be permanently removed.")
        }
        .onAppear {
            // MARK: - Initialize Pulse Animation
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                pulseAnimation = true
            }
        }
    }

    // MARK: - Cosmic Number Overlay

    private var cosmicNumberOverlay: some View {
        ZStack {
            Text("\(entry.focusNumber)")
                .font(.system(size: 120, weight: .ultraLight, design: .rounded))
                .foregroundColor(sacredNumberColor(for: Int(entry.focusNumber)))
                .opacity(0.08)
                .scaleEffect(pulseAnimation ? 1.05 : 0.95)
                .animation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true), value: pulseAnimation)
                .offset(x: -100, y: -150)
        }
    }

    // MARK: - Sacred Header Section

    private var sacredHeaderSection: some View {
        VStack(spacing: 12) {
            Text("✨ \(entry.title ?? "Sacred Reflection") ✨")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [.white, .purple.opacity(0.9)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .multilineTextAlignment(.center)

            if let timestamp = entry.timestamp {
                Text("Captured on \(timestamp, style: .date) at \(timestamp, style: .time)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .italic()
            }
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
                number: Int(entry.focusNumber),
                title: "Focus",
                subtitle: "Your chosen path",
                color: sacredNumberColor(for: Int(entry.focusNumber))
            )

            // Realm Number Badge (if available)
            if entry.realmNumber > 0 {
                NumerologyBadge(
                    number: Int(entry.realmNumber),
                    title: "Realm",
                    subtitle: "Cosmic frequency",
                    color: sacredNumberColor(for: Int(entry.realmNumber))
                )
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Voice Playback Section

    private func voicePlaybackSection(filename: String) -> some View {
        VStack(spacing: 16) {
            Text("🎙️ Sacred Voice")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 16) {
                // Play/Pause Button
                Button(action: {
                    if voiceManager.isPlaying {
                        voiceManager.stopPlayback()
                    } else {
                        voiceManager.playRecording(filename: filename)
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [.green, .teal]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 60, height: 60)

                        Image(systemName: voiceManager.isPlaying ? "pause.fill" : "play.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(PlainButtonStyle())

                VStack(alignment: .leading, spacing: 4) {
                    Text("Sacred Voice Reflection")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)

                    if let duration = voiceManager.getRecordingDuration(filename: filename) {
                        Text(formatDuration(duration))
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
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.green.opacity(0.5), lineWidth: 1)
                    )
            )
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

    // MARK: - Content Section

    private var contentSection: some View {
        VStack(spacing: 16) {
            Text("📝 Sacred Words")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let content = entry.content, !content.isEmpty {
                Text(content)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.3))
                    )
            } else {
                Text("This reflection contains only voice content")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.6))
                    .italic()
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.2))
                    )
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

    // MARK: - Metadata Section

    private var metadataSection: some View {
        VStack(spacing: 12) {
            if let mood = entry.moodEmoji, !mood.isEmpty {
                HStack(spacing: 12) {
                    Text("🌙 Sacred Mood:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)

                    Text(mood)
                        .font(.title2)

                    Spacer()
                }
            }

            // Location info if available
            if entry.latitude != 0 && entry.longitude != 0 {
                HStack(spacing: 12) {
                    Image(systemName: "location.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Sacred Location")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)

                        Text("Lat: \(entry.latitude, specifier: "%.4f"), Lon: \(entry.longitude, specifier: "%.4f")")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }

                    Spacer()
                }
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

    // MARK: - Helper Methods

    private func deleteEntry() {
        // Clean up voice recording if it exists
        if let voiceFilename = entry.voiceRecordingFilename {
            voiceManager.deleteRecording(filename: voiceFilename)
        }

        journalManager.deleteEntry(entry)
        dismiss()
    }

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

    private func formatDuration(_ duration: TimeInterval) -> String {
        guard duration.isFinite && !duration.isNaN else { return "0:00" }
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
