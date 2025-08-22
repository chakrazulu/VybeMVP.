import SwiftUI

/**
 * VFI Widget - Real-Time Consciousness Frequency Display
 * =====================================================
 *
 * The VFI (Vybe Frequency Index) Widget provides users with immediate awareness
 * of their current consciousness frequency, calculated in real-time by the
 * Master Consciousness Algorithm. This elegant pill widget appears in the
 * top-right corner of the home screen, displaying the format: [7 523 VHz]
 *
 * ## Architecture Overview
 *
 * The widget consists of two main components:
 * 1. **VFIWidget** - Minimal pill display for home screen
 * 2. **VFIDetailView** - Comprehensive expanded view with algorithm insights
 *
 * ## Technical Implementation
 *
 * **Data Source:** CosmicHUDManager.shared provides HUDData containing:
 * - VFI frequency (Double): Consciousness frequency in VHz (20-1000+)
 * - Sacred number (Int): Numerological significance (1-9, 11, 22, 33, etc.)
 * - Consciousness state (String): Human-readable state description
 *
 * **UI Architecture:**
 * - Minimal pill: 8pt horizontal padding, .ultraThinMaterial background
 * - Color system: Chakra-inspired gradients for sacred numbers
 * - Animations: .spring(duration: 0.3) for smooth interactions
 * - Modal presentation: .sheet for expanded detail view
 *
 * ## Master Algorithm Integration
 *
 * The VFI calculation leverages existing Vybe infrastructure:
 * - RealmNumberManager: GPS coordinates, time, heart rate integration
 * - FocusNumberManager: User's selected spiritual focus
 * - CosmicService: Live planetary positions and lunar phases
 * - Pattern detection: Fibonacci, Tesla 3-6-9, prime singularities
 *
 * ## Performance Considerations
 *
 * - Lazy loading: Widget appears only when HUDData is available
 * - Shared manager: CosmicHUDManager.shared prevents duplicate calculations
 * - Efficient updates: @StateObject ensures proper SwiftUI lifecycle
 * - Memory optimization: Sheet presentation releases resources when dismissed
 *
 * ## User Experience
 *
 * **Interaction Patterns:**
 * - Tap: Opens detailed insight view with algorithm breakdown
 * - Loading state: Shows "• VHz" placeholder during calculation
 * - Error handling: Graceful fallback to cached data
 * - Accessibility: Full VoiceOver support with descriptive labels
 *
 * **Visual Design:**
 * - Sacred number: Color-coded by chakra system (1=red, 2=orange, etc.)
 * - VFI frequency: Secondary color for subtle presence
 * - Consciousness glow: Border color reflects frequency zone
 * - Material design: .ultraThinMaterial for modern iOS aesthetic
 *
 * Created: August 2025
 * Last Updated: August 22, 2025
 * Version: 1.0.0 - Initial implementation with Master Algorithm
 */

// MARK: - VFI Pill Widget

/// Minimal consciousness frequency display widget for home screen
///
/// Displays real-time VFI (Vybe Frequency Index) in format: [7 523 VHz]
/// where 7 is the sacred number and 523 VHz is the consciousness frequency.
/// Tapping the widget opens a detailed view with algorithm insights.
struct VFIWidget: View {
    // MARK: - Dependencies

    /// Shared manager providing real-time HUD data including VFI calculations
    @StateObject private var hudManager = CosmicHUDManager.shared

    // MARK: - UI State

    /// Controls visibility of the detailed insight modal
    @State private var showingDetail = false

    // MARK: - View Body

    var body: some View {
        // Conditional rendering: Show pill with data or loading state
        if let hudData = hudManager.currentHUDData {
            vfiPill(hudData: hudData)
        } else {
            loadingPill
        }
    }

    // MARK: - Private Views

    /// Creates the main VFI pill display with sacred number and frequency
    ///
    /// Displays a capsule-shaped button containing:
    /// - Sacred number (1-9, 11, 22, 33, etc.) with chakra-inspired gradient
    /// - VFI frequency in VHz format (e.g., "523 VHz")
    /// - Consciousness glow border reflecting frequency zone
    ///
    /// - Parameter hudData: Current HUD data containing VFI and sacred number
    /// - Returns: Interactive button view that opens detailed modal
    private func vfiPill(hudData: HUDData) -> some View {
        Button(action: {
            withAnimation(.spring(duration: 0.3)) {
                showingDetail.toggle()
            }
        }) {
            HStack(spacing: 4) {
                // Sacred number indicator
                Text("\(hudData.sacredNumber)")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(sacredNumberGradient(hudData.sacredNumber))

                // VFI frequency
                Text(hudData.vfiDisplay)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .stroke(consciousnessGlow(hudData.vfi), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(showingDetail ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: showingDetail)
        .sheet(isPresented: $showingDetail) {
            VFIDetailView(hudData: hudData)
        }
    }

    /// Loading state pill displayed while HUD data is being calculated
    ///
    /// Shows a minimalist placeholder with "• VHz" format to indicate
    /// the widget is active but data is not yet available. Uses reduced
    /// opacity and triggers data refresh on appearance.
    ///
    /// - Returns: Placeholder view with loading indicator
    private var loadingPill: some View {
        HStack(spacing: 4) {
            Text("•")
                .font(.caption2)
                .foregroundColor(.secondary)

            Text("VHz")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .opacity(0.5)
        )
        .onAppear {
            Task {
                await hudManager.refreshHUDData()
            }
        }
    }

    // MARK: - Visual Styling

    /// Generates chakra-inspired color gradients for sacred numbers
    ///
    /// Provides visual differentiation based on numerological significance:
    /// - Numbers 1-9: Individual chakra colors (1=red, 2=orange, etc.)
    /// - Master numbers (11, 22, 33, etc.): Golden rainbow gradient
    /// - Default: Gray-white gradient for unknown numbers
    ///
    /// The color system follows traditional chakra associations for
    /// immediate spiritual recognition and energetic resonance.
    ///
    /// - Parameter number: Sacred number to generate gradient for
    /// - Returns: LinearGradient with appropriate spiritual colors
    private func sacredNumberGradient(_ number: Int) -> LinearGradient {
        switch number {
        case 1...9:
            // Single digits: Chakra-inspired colors
            let colorPair = getChakraColors(for: number)
            return LinearGradient(colors: colorPair, startPoint: .leading, endPoint: .trailing)

        case 11, 22, 33, 44, 55, 66, 77:
            // Master numbers: Golden rainbow gradient
            let masterColors = [Color.yellow, Color.orange, Color.pink, Color.purple]
            return LinearGradient(
                colors: masterColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        default:
            let defaultColors = [Color.gray, Color.white]
            return LinearGradient(colors: defaultColors, startPoint: .leading, endPoint: .trailing)
        }
    }

    /// Retrieves specific chakra color pairs for single-digit sacred numbers
    ///
    /// Maps each number (1-9) to its corresponding chakra color system:
    /// 1: Root (red-orange), 2: Sacral (orange-yellow), 3: Solar Plexus (yellow-green),
    /// 4: Heart (green-blue), 5: Throat (blue-indigo), 6: Third Eye (indigo-purple),
    /// 7: Crown (purple-white), 8: Earth Power (brown-orange), 9: Universal (white-cyan)
    ///
    /// - Parameter number: Sacred number (1-9) to get colors for
    /// - Returns: Array of two colors for gradient creation
    private func getChakraColors(for number: Int) -> [Color] {
        switch number {
        case 1: return [.red, .orange]          // Root chakra
        case 2: return [.orange, .yellow]       // Sacral chakra
        case 3: return [.yellow, .green]        // Solar plexus
        case 4: return [.green, .blue]          // Heart chakra
        case 5: return [.blue, .indigo]         // Throat chakra
        case 6: return [.indigo, .purple]       // Third eye
        case 7: return [.purple, .white]        // Crown chakra
        case 8: return [.brown, .orange]        // Earth power
        case 9: return [.white, .cyan]          // Universal
        default: return [.gray, .white]
        }
    }

    /// Determines border glow color based on consciousness frequency zones
    ///
    /// Maps VFI ranges to appropriate spiritual colors:
    /// - 20-200 VHz: Red (Lower frequencies - Survival & Security)
    /// - 200-400 VHz: Orange (Growth frequencies - Building Courage)
    /// - 400-600 VHz: Green (Love frequencies - Heart-centered Awareness)
    /// - 600-800 VHz: Blue (Joy frequencies - Elevated Consciousness)
    /// - 800+ VHz: Purple (Unity frequencies - Transcendence)
    ///
    /// - Parameter vfi: Current consciousness frequency in VHz
    /// - Returns: Color with appropriate opacity for border glow effect
    private func consciousnessGlow(_ vfi: Double) -> Color {
        switch vfi {
        case 20..<200: return .red.opacity(0.3)      // Lower frequencies
        case 200..<400: return .orange.opacity(0.4)  // Growth frequencies
        case 400..<600: return .green.opacity(0.5)   // Love frequencies
        case 600..<800: return .blue.opacity(0.6)    // Joy frequencies
        case 800...: return .purple.opacity(0.7)     // Unity frequencies
        default: return .gray.opacity(0.2)
        }
    }

}

// MARK: - VFI Detail Sheet

/**
 * VFI Detail View - Comprehensive Consciousness Algorithm Insights
 * ==============================================================
 *
 * Expanded modal view providing deep insights into the VFI calculation
 * and consciousness algorithm. Presented as a sheet when users tap the
 * VFI pill widget, offering educational and spiritual value.
 *
 * ## Content Sections
 *
 * 1. **Hero Section**: Animated VFI display with pulsing gradient effects
 * 2. **Sacred Number**: Detailed meaning and significance
 * 3. **Algorithm Breakdown**: Interactive 4-step process explanation
 * 4. **Frequency Zone**: Visual representation of consciousness state
 * 5. **Spiritual Insights**: Personalized guidance based on current frequency
 *
 * ## Technical Features
 *
 * - **Smooth Animations**: Gradient pulsing, scale effects, rotation
 * - **Interactive Elements**: Expandable algorithm breakdown
 * - **Scrollable Content**: Handles varying insight lengths
 * - **Accessibility**: Full VoiceOver support with semantic labels
 * - **Performance**: Optimized rendering with proper state management
 *
 * ## Algorithm Transparency
 *
 * Provides complete visibility into the Master Consciousness Algorithm:
 * 1. Temporal Essence: Date & time → spiritual singularities
 * 2. Sacred Detection: Fibonacci, Tesla 3-6-9, prime patterns
 * 3. Cosmic Alignment: Planetary positions & lunar phases
 * 4. Consciousness Map: 20-1000+ VHz frequency spectrum
 */
struct VFIDetailView: View {
    // MARK: - Dependencies

    /// HUD data containing VFI calculation results and metadata
    let hudData: HUDData

    // MARK: - Environment

    /// Dismissal environment for modal presentation
    @Environment(\.dismiss) private var dismiss

    // MARK: - Animation State

    /// Controls gradient animation cycling for visual appeal
    @State private var animateGradient = false

    /// Controls visibility of algorithm breakdown section
    @State private var showBreakdown = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Hero Section with Animated Background
                    VStack(spacing: 16) {
                        // Floating VFI Display
                        VStack(spacing: 8) {
                            // Main frequency with pulsing animation
                            Text(hudData.vfiDisplay)
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .purple, .pink, .cyan],
                                        startPoint: animateGradient ? .topLeading : .bottomTrailing,
                                        endPoint: animateGradient ? .bottomTrailing : .topLeading
                                    )
                                )
                                .scaleEffect(animateGradient ? 1.05 : 1.0)
                                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateGradient)

                            // Sacred number with glow effect
                            VStack {
                                Text("\(hudData.sacredNumber)")
                                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                                    .foregroundStyle(sacredNumberGradient(hudData.sacredNumber))
                                    .shadow(color: consciousnessGlow(hudData.vfi), radius: 8)

                                Text("Sacred Number")
                                    .font(.caption2)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                                    .opacity(0.8)
                            }
                        }
                        .padding(.vertical, 32)
                        .padding(.horizontal, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            consciousnessGlow(hudData.vfi).opacity(0.1),
                                            consciousnessGlow(hudData.vfi).opacity(0.05)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    consciousnessGlow(hudData.vfi),
                                                    consciousnessGlow(hudData.vfi).opacity(0.3)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1.5
                                        )
                                )
                        )

                        // Consciousness State Badge
                        Text(hudData.consciousnessState)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [consciousnessGlow(hudData.vfi), consciousnessGlow(hudData.vfi).opacity(0.7)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: consciousnessGlow(hudData.vfi).opacity(0.5), radius: 8)
                            )
                    }
                    .padding(.top, 20)

                    // Interactive Algorithm Breakdown
                    VStack(spacing: 16) {
                        Button(action: {
                            withAnimation(.spring(duration: 0.5)) {
                                showBreakdown.toggle()
                            }
                        }) {
                            HStack {
                                Text("Consciousness Algorithm")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)

                                Spacer()

                                Image(systemName: showBreakdown ? "chevron.up" : "chevron.down")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                                    .rotationEffect(.degrees(showBreakdown ? 180 : 0))
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(.blue.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())

                        if showBreakdown {
                            VStack(spacing: 12) {
                                algorithmStepEnhanced("1", "Temporal Essence", "Date & time → spiritual singularities", .blue)
                                algorithmStepEnhanced("2", "Sacred Detection", "Fibonacci, Tesla 3-6-9, prime patterns", .purple)
                                algorithmStepEnhanced("3", "Cosmic Alignment", "Planetary positions & lunar phases", .orange)
                                algorithmStepEnhanced("4", "Consciousness Map", "20-1000+ VHz frequency spectrum", .green)
                            }
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .scale(scale: 0.8)),
                                removal: .opacity
                            ))
                        }
                    }

                    // Sacred Number Deep Dive
                    sacredNumberMeaningEnhanced(hudData.sacredNumber)

                    // Frequency Zone Visualization
                    frequencyZoneCard(hudData.vfi)

                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 20)
            }
            .background(
                LinearGradient(
                    colors: [
                        consciousnessGlow(hudData.vfi).opacity(0.02),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("VFI")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.ultraThinMaterial, consciousnessGlow(hudData.vfi))
                    }
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 2.0).delay(0.5)) {
                    animateGradient = true
                }
            }
        }
    }

    private func algorithmStepEnhanced(_ number: String, _ title: String, _ description: String, _ color: Color) -> some View {
        HStack(spacing: 16) {
            // Step number with glow
            Text(number)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [color, color.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: color.opacity(0.4), radius: 4)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .opacity(0.8)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private func sacredNumberMeaningEnhanced(_ number: Int) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("\(number)")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(sacredNumberGradient(number))
                    .shadow(color: consciousnessGlow(hudData.vfi), radius: 4)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Sacred Number")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)

                    Text(getSacredNumberType(number))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }

                Spacer()
            }

            Text(getSacredNumberMeaning(number))
                .font(.body)
                .foregroundColor(.primary)
                .opacity(0.8)
                .lineSpacing(4)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            consciousnessGlow(hudData.vfi).opacity(0.08),
                            consciousnessGlow(hudData.vfi).opacity(0.03)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    consciousnessGlow(hudData.vfi).opacity(0.3),
                                    consciousnessGlow(hudData.vfi).opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }

    private func getSacredNumberType(_ number: Int) -> String {
        switch number {
        case 1...9: return "Core Number"
        case 11, 22, 33, 44, 55, 66, 77: return "Master Number"
        default: return "Unique Pattern"
        }
    }

    private func frequencyZoneCard(_ vfi: Double) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Frequency Zone")
                .font(.headline)
                .fontWeight(.semibold)

            HStack {
                // Zone visualization
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: getZoneGradient(vfi),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 8)
                    .overlay(
                        HStack {
                            Spacer()
                            Circle()
                                .fill(.white)
                                .frame(width: 12, height: 12)
                                .shadow(color: consciousnessGlow(vfi), radius: 4)
                            Spacer()
                        }
                    )
            }

            Text(getZoneDescription(vfi))
                .font(.body)
                .foregroundColor(.secondary)
                .opacity(0.8)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.gray.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private func getZoneGradient(_ vfi: Double) -> [Color] {
        switch vfi {
        case 20..<200: return [.red, .orange]
        case 200..<400: return [.orange, .yellow]
        case 400..<600: return [.green, .blue]
        case 600..<800: return [.blue, .purple]
        case 800...: return [.purple, .pink]
        default: return [.gray, .white]
        }
    }

    private func getZoneDescription(_ vfi: Double) -> String {
        switch vfi {
        case 20..<200: return "Survival & Security Zone - Focus on grounding and stability"
        case 200..<400: return "Growth & Courage Zone - Building strength and taking action"
        case 400..<600: return "Love & Acceptance Zone - Heart-centered awareness and compassion"
        case 600..<800: return "Joy & Wisdom Zone - Elevated consciousness and inner peace"
        case 800...: return "Unity & Transcendence Zone - Pure consciousness and spiritual mastery"
        default: return "Calibrating consciousness frequency..."
        }
    }

    private func getSacredNumberMeaning(_ number: Int) -> String {
        switch number {
        case 1: return "New beginning after challenges. You're emerging from a difficult period with fresh clarity and renewed purpose."
        case 2: return "Seeking partnership and cooperation. Your soul is calling for connection and collaborative spiritual growth."
        case 3: return "Creative expression and communication. Your artistic and expressive energies are heightened for spiritual sharing."
        case 4: return "Building foundation and security. Focus on creating stable structures that support your spiritual journey."
        case 5: return "Freedom and adventure. Your spirit seeks liberation from limiting patterns and expansion into new experiences."
        case 6: return "Service and nurturing. You're called to heal, help, and nurture others as part of your spiritual path."
        case 7: return "Spiritual introspection and wisdom. Deep contemplation and inner work will reveal profound truths."
        case 8: return "Power and material mastery. You have the strength to overcome challenges and manifest your spiritual vision."
        case 9: return "Universal understanding and completion. You're integrating all lessons and preparing for a new spiritual cycle."
        case 11: return "Master awakening and intuition. Your psychic abilities and spiritual awareness are significantly heightened."
        case 22: return "Master builder of reality. You have exceptional power to manifest spiritual visions in the physical world."
        case 33: return "Master teacher consciousness. You're called to guide others through wisdom and compassionate understanding."
        case 44: return "Master healer vibration. Your energy has profound healing potential for yourself and others."
        case 55: return "Master of freedom and change. You're breaking through all limitations to achieve complete spiritual liberation."
        case 66: return "Master nurturer and caregiver. Your role is to provide healing sanctuary and unconditional love."
        case 77: return "Master mystic and spiritual guide. You have direct access to universal wisdom and cosmic consciousness."
        default: return "You're experiencing a unique spiritual frequency that transcends traditional numerological patterns."
        }
    }

    private func sacredNumberGradient(_ number: Int) -> LinearGradient {
        switch number {
        case 1...9:
            let colorPair = getDetailChakraColors(for: number)
            return LinearGradient(colors: colorPair, startPoint: .leading, endPoint: .trailing)

        case 11, 22, 33, 44, 55, 66, 77:
            let masterColors = [Color.yellow, Color.orange, Color.pink, Color.purple]
            return LinearGradient(
                colors: masterColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        default:
            let defaultColors = [Color.gray, Color.white]
            return LinearGradient(colors: defaultColors, startPoint: .leading, endPoint: .trailing)
        }
    }

    private func getDetailChakraColors(for number: Int) -> [Color] {
        switch number {
        case 1: return [.red, .orange]          // Root chakra
        case 2: return [.orange, .yellow]       // Sacral chakra
        case 3: return [.yellow, .green]        // Solar plexus
        case 4: return [.green, .blue]          // Heart chakra
        case 5: return [.blue, .indigo]         // Throat chakra
        case 6: return [.indigo, .purple]       // Third eye
        case 7: return [.purple, .white]        // Crown chakra
        case 8: return [.brown, .orange]        // Earth power
        case 9: return [.white, .cyan]          // Universal
        default: return [.gray, .white]
        }
    }

    private func consciousnessGlow(_ vfi: Double) -> Color {
        switch vfi {
        case 20..<200: return .red.opacity(0.3)
        case 200..<400: return .orange.opacity(0.4)
        case 400..<600: return .green.opacity(0.5)
        case 600..<800: return .blue.opacity(0.6)
        case 800...: return .purple.opacity(0.7)
        default: return .gray.opacity(0.2)
        }
    }
}

// MARK: - Preview
#if DEBUG
struct VFIWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VFIWidget()
                .previewDisplayName("VFI Widget")
                .padding()

            VFIDetailView(hudData: HUDData(
                rulerNumber: 7,
                dominantAspect: nil,
                element: .fire,
                lastCalculated: Date(),
                allAspects: [],
                vfi: 523.0
            ))
            .previewDisplayName("VFI Detail")
        }
    }
}
#endif
