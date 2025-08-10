/*
 * ========================================
 * 🌅 CELESTIAL TIMING VIEW - LOCATION-AWARE COSMIC EVENTS
 * ========================================
 *
 * CORE PURPOSE:
 * Professional display component for location-specific celestial event times including
 * sunrise/sunset, moonrise/moonset, and planetary visibility using Swiss Ephemeris
 * accuracy with SwiftAA integration for authentic cosmic timing.
 *
 * LOCATION-BASED FEATURES:
 * - Sunrise/Solar Noon/Sunset: Precise times for user's geographic location
 * - Moonrise/Lunar Transit/Moonset: Complete lunar cycle timing
 * - Planetary Visibility: Rise/set times for visible planets
 * - Timezone Integration: All times displayed in user's local timezone
 * - Real-time Updates: Dynamic calculations for current location
 *
 * SWISS EPHEMERIS INTEGRATION:
 * - SwiftAA RiseTransitSetTimes: Professional astronomical calculations
 * - Geographic Precision: Accounts for latitude, longitude, and altitude
 * - Atmospheric Refraction: Standard horizon calculations with refraction
 * - Professional Accuracy: Sub-minute precision for all celestial events
 *
 * UI DESIGN SPECIFICATIONS:
 * - Compact Display: Essential timing in minimal space
 * - Cosmic Theming: Consistent with app's spiritual aesthetic
 * - Location Indicator: Shows current observer location
 * - Event Highlighting: Emphasizes next upcoming celestial event
 * - Accessibility: Full VoiceOver support for timing information
 *
 * SPIRITUAL WELLNESS INTEGRATION:
 * - Optimal Timing: Highlights best times for meditation and manifestation
 * - Cosmic Synchronicity: Aligns spiritual practice with celestial rhythms
 * - Location Authenticity: Genuine cosmic connection for user's exact position
 * - Sacred Moments: Identifies spiritually significant celestial events
 */

import SwiftUI
import CoreLocation

/// Claude: Location-aware celestial timing display with Swiss Ephemeris accuracy
///
/// This component provides users with precise celestial event timing for their
/// exact geographic location, enabling authentic cosmic connection and optimal
/// spiritual timing. Integrates professional astronomical calculations with
/// beautiful, accessible UI design.
///
/// **🌍 Location-Based Features:**
/// - **Solar Events**: Sunrise, solar noon, sunset with exact timing
/// - **Lunar Events**: Moonrise, lunar transit, moonset calculations
/// - **Planetary Visibility**: Rise/set times for visible planets
/// - **Timezone Precision**: All times in user's actual timezone
/// - **Geographic Accuracy**: Uses exact coordinates for calculations
///
/// **🔬 Technical Implementation:**
/// - **SwiftAA Integration**: Professional RiseTransitSetTimes calculations
/// - **Swiss Ephemeris**: Observatory-grade astronomical accuracy
/// - **Real-time Updates**: Dynamic recalculation for location changes
/// - **Error Handling**: Graceful fallbacks when location unavailable
/// - **Performance Optimized**: Efficient celestial body calculations
///
/// **🎨 UI/UX Design:**
/// - **Compact Format**: Essential information in minimal space
/// - **Visual Hierarchy**: Next event prominently highlighted
/// - **Location Context**: Clear indication of observer position
/// - **Accessibility**: Complete VoiceOver and Dynamic Type support
/// - **Cosmic Theming**: Integrates with app's spiritual aesthetic
struct CelestialTimingView: View {

    // MARK: - Properties

    /// Cosmic data containing location-specific celestial events
    let cosmicData: CosmicData

    /// Display mode for different UI contexts
    let displayMode: DisplayMode

    /// User's timezone for proper time display
    @State private var userTimezone: TimeZone = .current

    // MARK: - Display Mode

    enum DisplayMode {
        case compact        // Essential timing in minimal space
        case detailed       // Complete timing information
        case nextEventOnly  // Only the next upcoming event
    }

    // MARK: - Body

    var body: some View {
        Group {
            switch displayMode {
            case .compact:
                compactTimingView
            case .detailed:
                detailedTimingView
            case .nextEventOnly:
                nextEventView
            }
        }
        .onAppear {
            updateTimezone()
        }
    }

    // MARK: - Compact Timing View

    private var compactTimingView: some View {
        VStack(spacing: 12) {
            // Location indicator
            locationHeader

            // Primary celestial events
            HStack(spacing: 16) {
                // Solar timing
                if let sunEvents = cosmicData.sunEvents {
                    solarEventCard(sunEvents)
                }

                // Lunar timing
                if let moonEvents = cosmicData.moonEvents {
                    lunarEventCard(moonEvents)
                }
            }

            // Next event highlight
            nextEventHighlight
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                )
        )
    }

    // MARK: - Location Header

    private var locationHeader: some View {
        HStack {
            Image(systemName: "location.north.circle.fill")
                .foregroundColor(.purple)
                .imageScale(.small)

            Text(cosmicData.observerLocation?.name ?? "Current Location")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)

            Spacer()

            Text(userTimezone.identifier)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }

    // MARK: - Solar Event Card

    private func solarEventCard(_ sunEvents: CelestialEventTimes) -> some View {
        VStack(spacing: 8) {
            // Sun icon with status
            HStack(spacing: 4) {
                Text("☀️")
                    .font(.title2)

                if sunEvents.isVisible {
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 6, height: 6)
                }
            }

            VStack(spacing: 4) {
                if let sunrise = sunEvents.rise {
                    eventTimeRow(
                        icon: "sunrise.fill",
                        label: "Rise",
                        time: sunrise,
                        color: .orange
                    )
                }

                if let sunset = sunEvents.set {
                    eventTimeRow(
                        icon: "sunset.fill",
                        label: "Set",
                        time: sunset,
                        color: .red
                    )
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.orange.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
        )
    }

    // MARK: - Lunar Event Card

    private func lunarEventCard(_ moonEvents: CelestialEventTimes) -> some View {
        VStack(spacing: 8) {
            // Moon icon with status
            HStack(spacing: 4) {
                Text(cosmicData.moonPhaseEmoji)
                    .font(.title2)

                if moonEvents.isVisible {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 6, height: 6)
                }
            }

            VStack(spacing: 4) {
                if let moonrise = moonEvents.rise {
                    eventTimeRow(
                        icon: "moonrise.fill",
                        label: "Rise",
                        time: moonrise,
                        color: .blue
                    )
                }

                if let moonset = moonEvents.set {
                    eventTimeRow(
                        icon: "moonset.fill",
                        label: "Set",
                        time: moonset,
                        color: .indigo
                    )
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
        )
    }

    // MARK: - Event Time Row

    private func eventTimeRow(
        icon: String,
        label: String,
        time: Date,
        color: Color
    ) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(color)
                .imageScale(.small)

            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)

            Spacer()

            Text(formatTime(time))
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }

    // MARK: - Next Event Highlight

    private var nextEventHighlight: some View {
        Group {
            if let nextEvent = getNextCelestialEvent() {
                HStack {
                    Text("Next:")
                        .font(.caption2)
                        .foregroundColor(.secondary)

                    Text(nextEvent.description)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.purple)

                    Spacer()

                    Text(formatTime(nextEvent.time))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 8)
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
        }
    }

    // MARK: - Detailed Timing View

    private var detailedTimingView: some View {
        VStack(spacing: 20) {
            locationHeader

            // Comprehensive celestial events
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {

                // Solar events
                if let sunEvents = cosmicData.sunEvents {
                    detailedEventCard(
                        title: "Solar Events",
                        icon: "☀️",
                        events: sunEvents,
                        color: .orange
                    )
                }

                // Lunar events
                if let moonEvents = cosmicData.moonEvents {
                    detailedEventCard(
                        title: "Lunar Events",
                        icon: cosmicData.moonPhaseEmoji,
                        events: moonEvents,
                        color: .blue
                    )
                }

                // Planetary events
                if let planetaryEvents = cosmicData.planetaryEvents,
                   !planetaryEvents.isEmpty {
                    ForEach(Array(planetaryEvents.prefix(4)), id: \.key) { planet, events in
                        detailedEventCard(
                            title: planet,
                            icon: planetIcon(for: planet),
                            events: events,
                            color: planetColor(for: planet)
                        )
                    }
                }
            }
        }
        .padding(20)
    }

    // MARK: - Detailed Event Card

    private func detailedEventCard(
        title: String,
        icon: String,
        events: CelestialEventTimes,
        color: Color
    ) -> some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Text(icon)
                    .font(.title3)
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                if events.isVisible {
                    Circle()
                        .fill(color)
                        .frame(width: 8, height: 8)
                }
            }

            // Event times
            VStack(spacing: 8) {
                if let rise = events.rise {
                    DetailedEventRow(label: "Rise", time: rise, icon: "arrow.up.circle", color: color)
                }

                if let transit = events.transit {
                    DetailedEventRow(label: "Transit", time: transit, icon: "circle.circle", color: color)
                }

                if let set = events.set {
                    DetailedEventRow(label: "Set", time: set, icon: "arrow.down.circle", color: color)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }

    // MARK: - Next Event View

    private var nextEventView: some View {
        Group {
            if let nextEvent = getNextCelestialEvent() {
                HStack(spacing: 12) {
                    Text(nextEvent.icon)
                        .font(.title2)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Next Event")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text(nextEvent.description)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text(formatTime(nextEvent.time))
                            .font(.subheadline)
                            .fontWeight(.medium)

                        Text(timeUntil(nextEvent.time))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                        )
                )
            } else {
                Text("No upcoming events")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
    }

    // MARK: - Helper Methods

    /// Claude: Update timezone based on cosmic data location
    private func updateTimezone() {
        if let location = cosmicData.observerLocation,
           let timezone = TimeZone(identifier: location.timezone) {
            userTimezone = timezone
        }
    }

    /// Claude: Format time for display in user's timezone
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = userTimezone
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    /// Claude: Calculate time until event
    private func timeUntil(_ date: Date) -> String {
        let interval = date.timeIntervalSinceNow
        if interval < 0 { return "Passed" }

        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60

        if hours > 0 {
            return "in \(hours)h \(minutes)m"
        } else {
            return "in \(minutes)m"
        }
    }

    /// Claude: Get the next upcoming celestial event
    private func getNextCelestialEvent() -> CelestialEvent? {
        var events: [CelestialEvent] = []
        let now = Date()

        // Add solar events
        if let sunEvents = cosmicData.sunEvents {
            if let rise = sunEvents.rise, rise > now {
                events.append(CelestialEvent(
                    description: "Sunrise",
                    time: rise,
                    icon: "☀️"
                ))
            }
            if let set = sunEvents.set, set > now {
                events.append(CelestialEvent(
                    description: "Sunset",
                    time: set,
                    icon: "🌅"
                ))
            }
        }

        // Add lunar events
        if let moonEvents = cosmicData.moonEvents {
            if let rise = moonEvents.rise, rise > now {
                events.append(CelestialEvent(
                    description: "Moonrise",
                    time: rise,
                    icon: cosmicData.moonPhaseEmoji
                ))
            }
            if let set = moonEvents.set, set > now {
                events.append(CelestialEvent(
                    description: "Moonset",
                    time: set,
                    icon: cosmicData.moonPhaseEmoji
                ))
            }
        }

        // Return the next event
        return events.min(by: { $0.time < $1.time })
    }

    /// Claude: Get icon for planet
    private func planetIcon(for planet: String) -> String {
        switch planet.lowercased() {
        case "mercury": return "☿️"
        case "venus": return "♀️"
        case "mars": return "♂️"
        case "jupiter": return "♃"
        case "saturn": return "♄"
        case "uranus": return "♅"
        case "neptune": return "♆"
        default: return "⭐"
        }
    }

    /// Claude: Get color for planet
    private func planetColor(for planet: String) -> Color {
        switch planet.lowercased() {
        case "mercury": return .gray
        case "venus": return .yellow
        case "mars": return .red
        case "jupiter": return .orange
        case "saturn": return .brown
        case "uranus": return .cyan
        case "neptune": return .blue
        default: return .purple
        }
    }
}

// MARK: - Supporting Types

/// Claude: Celestial event data structure
struct CelestialEvent {
    let description: String
    let time: Date
    let icon: String
}

/// Claude: Detailed event row component
struct DetailedEventRow: View {
    let label: String
    let time: Date
    let icon: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .imageScale(.small)

            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()

            Text(formatTime(time))
                .font(.caption)
                .fontWeight(.medium)
        }
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Preview

struct CelestialTimingView_Previews: PreviewProvider {
    static var previews: some View {
        let mockCosmicData = CosmicData(
            planetaryPositions: [:],
            moonAge: 14.5,
            moonPhase: "Full Moon",
            sunSign: "Aquarius",
            moonIllumination: 99.2,
            observerLocation: ObserverLocation(
                latitude: 35.2271,
                longitude: -80.8431,
                timezone: "America/New_York",
                name: "Charlotte, NC"
            ),
            sunEvents: CelestialEventTimes(
                rise: Date().addingTimeInterval(3600),
                transit: Date().addingTimeInterval(7200),
                set: Date().addingTimeInterval(10800),
                isVisible: true
            ),
            moonEvents: CelestialEventTimes(
                rise: Date().addingTimeInterval(1800),
                transit: Date().addingTimeInterval(5400),
                set: Date().addingTimeInterval(9000),
                isVisible: false
            )
        )

        VStack(spacing: 20) {
            CelestialTimingView(cosmicData: mockCosmicData, displayMode: .compact)
            CelestialTimingView(cosmicData: mockCosmicData, displayMode: .nextEventOnly)
        }
        .padding()
        .background(Color.black)
    }
}
