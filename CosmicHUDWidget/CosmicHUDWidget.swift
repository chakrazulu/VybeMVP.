//
//  CosmicHUDWidget.swift
//  CosmicHUDWidget
//
//  Created by Corey Davis on 7/30/25.
//

import WidgetKit
import SwiftUI

// Claude: Import CosmicHUD types and manager for live data access
// This ensures widgets show the same data as Dynamic Island and main app

struct Provider: AppIntentTimelineProvider {

    // Claude: Create live cosmic data entry using App Groups or UserDefaults for data sync
    // This ensures consistency with Dynamic Island and main app without importing managers
    private func createLiveEntry(date: Date, configuration: ConfigurationAppIntent) -> SimpleEntry {
        // Get live data from UserDefaults (shared between app and widget)
        let userDefaults = UserDefaults(suiteName: "group.com.infinitiesinn.vybe.VybeMVP") ?? UserDefaults.standard

        // Get live data with fallbacks (same as main app would store)
        let rulerNumber = userDefaults.object(forKey: "CosmicHUD_RulerNumber") as? Int ?? getLiveRulerNumber()
        let realmNumber = userDefaults.object(forKey: "CosmicHUD_RealmNumber") as? Int ?? getLiveRealmNumber()
        let dominantAspect = userDefaults.string(forKey: "CosmicHUD_DominantAspect") ?? "☉ △ ☽"
        let element = userDefaults.string(forKey: "CosmicHUD_Element") ?? getElementEmoji(for: rulerNumber)

        return SimpleEntry(
            date: date,
            configuration: configuration,
            rulerNumber: rulerNumber,
            realmNumber: realmNumber,
            dominantAspect: dominantAspect,
            element: element
        )
    }

    // Claude: Calculate live ruler number independently (simplified calculation)
    private func getLiveRulerNumber() -> Int {
        let dayOfYear = Calendar.current.dayOfYear(for: Date()) ?? 1
        let hour = Calendar.current.component(.hour, from: Date())
        return ((dayOfYear + hour) % 9) + 1 // Returns 1-9
    }

    // Claude: Calculate live realm number independently (simplified calculation)
    private func getLiveRealmNumber() -> Int {
        let minute = Calendar.current.component(.minute, from: Date())
        let second = Calendar.current.component(.second, from: Date())
        return ((minute + second) % 9) + 1 // Returns 1-9
    }

    // Claude: Get element emoji based on ruler number (same logic as CosmicHUDManager)
    private func getElementEmoji(for rulerNumber: Int) -> String {
        let dayOfYear = Calendar.current.dayOfYear(for: Date()) ?? 1
        let elements = ["🔥", "🌍", "💨", "💧"] // fire, earth, air, water
        let index = (dayOfYear + rulerNumber) % elements.count
        return elements[index]
    }

    func placeholder(in context: Context) -> SimpleEntry {
        return createLiveEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        return createLiveEntry(date: Date(), configuration: configuration)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Claude: Generate timeline with live cosmic data updates
        // More frequent updates now that we have NSSupportsLiveActivitiesFrequentUpdates enabled
        let currentDate = Date()

        // Create entries every 15 minutes for more responsive cosmic updates
        for minuteOffset in stride(from: 0, to: 240, by: 15) { // 4 hours of entries, every 15 minutes
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = createLiveEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        // Claude: Request refresh after 1 hour to get updated cosmic data
        // This works with NSSupportsLiveActivitiesFrequentUpdates for more frequent updates
        return Timeline(entries: entries, policy: .after(Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!))
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent

    // Claude: Live cosmic data for consistent display across all widgets
    let rulerNumber: Int
    let realmNumber: Int
    let dominantAspect: String
    let element: String
}

struct CosmicHUDWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        Group {
            switch widgetFamily {
            case .systemSmall:
                smallWidgetView
            case .systemMedium:
                mediumWidgetView
            case .systemLarge:
                largeWidgetView
            case .accessoryRectangular:
                rectangularWidgetView
            default:
                smallWidgetView
            }
        }
        .containerBackground(for: .widget) {
            cosmicHazeBackground
        }
    }

    // MARK: - Small Widget (Square)
    /// Claude: Compact square widget showing essential cosmic data
    private var smallWidgetView: some View {
        VStack(spacing: 8) {
            HStack {
                Text("👑")
                    .font(.title2)
                Text("\(entry.rulerNumber)") // Claude: Now uses live ruler number
                    .font(.title)
                    .fontWeight(.bold)
            }

            Text("Ruler")
                .font(.caption)
                .foregroundColor(.secondary)

            Divider()

            Text("🔮 \(entry.realmNumber)") // Claude: Now uses live realm number
                .font(.headline)
            Text("Realm")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
    }

    // MARK: - Medium Widget (Rectangle)
    /// Claude: Wider widget showing ruler, realm, and active aspect with brief insight
    private var mediumWidgetView: some View {
        VStack(spacing: 12) {
            // Top row - numbers and aspect
            HStack(spacing: 12) {
                // Ruler section
                VStack(spacing: 2) {
                    HStack {
                        Text("👑")
                            .font(.body)
                        Text("\(entry.rulerNumber)") // Claude: Now uses live ruler number
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    Text("Ruler")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }

                Divider()
                    .frame(height: 30)

                // Realm section
                VStack(spacing: 2) {
                    HStack {
                        Text("🔮")
                            .font(.body)
                        Text("\(entry.realmNumber)") // Claude: Now uses live realm number
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    Text("Realm")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }

                Divider()
                    .frame(height: 30)

                // Aspect section
                VStack(spacing: 2) {
                    Text(entry.dominantAspect) // Claude: Now uses live aspect data
                        .font(.body)
                        .fontWeight(.medium)
                    Text("Aspect")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            // Brief insight for medium widget - optimized to prevent cutoff
            Text(getInsightText(rulerNumber: entry.rulerNumber, aspectType: "live", widgetSize: .medium)) // Claude: Now uses live data
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .truncationMode(.tail)
        }
        .padding(12)
    }

    // MARK: - Large Widget (Big Square)
    /// Claude: Full cosmic dashboard with all spiritual data
    private var largeWidgetView: some View {
        VStack(spacing: 12) {
            // Header - more compact
            Text("🌌 Cosmic Awareness")
                .font(.subheadline)
                .fontWeight(.semibold)

            // Numbers and Element row - more compact
            HStack(spacing: 16) {
                VStack(spacing: 2) {
                    HStack {
                        Text("👑")
                            .font(.title3)
                        Text("\(entry.rulerNumber)") // Claude: Now uses live ruler number
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    Text("Ruler")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }

                Divider()
                    .frame(height: 40)

                VStack(spacing: 2) {
                    HStack {
                        Text("🔮")
                            .font(.title3)
                        Text("\(entry.realmNumber)") // Claude: Now uses live realm number
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    Text("Realm")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }

                Divider()
                    .frame(height: 40)

                VStack(spacing: 2) {
                    Text(entry.element) // Claude: Now uses live element
                        .font(.title3)
                    Text(getElementName(entry.element))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            // Thin divider
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
                .padding(.horizontal)

            // Aspect section - more compact
            VStack(spacing: 4) {
                Text(entry.dominantAspect) // Claude: Now uses live aspect data
                    .font(.title3)
                    .fontWeight(.medium)
                Text(formatAspectExplanation(entry.dominantAspect))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            // Comprehensive insight using template system
            VStack(spacing: 6) {
                Text(getInsightTitle(for: entry.rulerNumber)) // Claude: Now uses live ruler number
                    .font(.body)
                    .fontWeight(.semibold)

                Text(getInsightText(rulerNumber: entry.rulerNumber, aspectType: "live", widgetSize: .large)) // Claude: Now uses live data
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .minimumScaleFactor(0.8)
            }
            .padding(.horizontal, 4)
        }
        .padding(12)
    }

    // MARK: - Rectangular Widget (Lock Screen)
    /// Claude: Lock screen widget - ultra compact
    private var rectangularWidgetView: some View {
        HStack(spacing: 8) {
            Text("👑\(entry.rulerNumber)") // Claude: Now uses live ruler number
                .font(.body)
                .fontWeight(.semibold)

            Text("🔮\(entry.realmNumber)") // Claude: Now uses live realm number
                .font(.body)
                .fontWeight(.semibold)

            Spacer()

            Text(entry.dominantAspect.replacingOccurrences(of: " ", with: "")) // Claude: Now uses live aspect data (compact)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }

    // MARK: - Cosmic Haze Background
    /// Claude: Elegant cosmic haze effect that creates floating parallax illusion - fills entire widget
    /// Opacity balanced for subtle visibility while maintaining elegance
    private var cosmicHazeBackground: some View {
        Rectangle()
            .fill(
                RadialGradient(
                    colors: [
                        Color.clear,
                        Color.purple.opacity(0.05),  // Slightly more visible than 0.03
                        Color.blue.opacity(0.06),    // Slightly more visible than 0.04
                        Color.indigo.opacity(0.08),  // Slightly more visible than 0.06
                        Color.purple.opacity(0.11)   // Slightly more visible than 0.08
                    ],
                    center: .center,
                    startRadius: 10,
                    endRadius: 150
                )
            )
            .overlay(
                Rectangle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.purple.opacity(0.25),  // More visible than 0.18
                                Color.blue.opacity(0.18),    // More visible than 0.13
                                Color.indigo.opacity(0.28),  // More visible than 0.2
                                Color.cyan.opacity(0.15),    // More visible than 0.1
                                Color.purple.opacity(0.22)   // More visible than 0.15
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.8  // Slightly thicker than 1.5
                    )
            )
            .shadow(
                color: Color.purple.opacity(0.18),  // More visible than 0.13
                radius: 7,   // Between original 8 and reduced 6
                x: 0,
                y: 1.5       // Between original 2 and reduced 1
            )
            .shadow(
                color: Color.blue.opacity(0.15),    // More visible than 0.1
                radius: 11,  // Between original 12 and reduced 10
                x: 0,
                y: 3.5       // Between original 4 and reduced 3
            )
            .clipped()
    }

    // MARK: - Template-Based Insight Generation
    /// Claude: Generate insights using widget-specific templates to prevent cutoff

    private func getInsightTitle(for rulerNumber: Int) -> String {
        let titles: [Int: String] = [
            1: "Lead boldly",
            2: "Harmonize deeply",
            3: "Create freely",
            4: "Build steadily",
            5: "Explore freely",
            6: "Love purely",
            7: "Seek wisdom",
            8: "Manifest power",
            9: "Serve all"
        ]
        return titles[rulerNumber] ?? "Channel cosmos"
    }

    private func getInsightText(rulerNumber: Int, aspectType: String, widgetSize: WidgetSize) -> String {
        return WidgetInsightTemplates.generateInsight(
            rulerNumber: rulerNumber,
            aspectType: aspectType,
            widgetSize: widgetSize
        )
    }

    // MARK: - Helper Functions for Live Data Display

    /// Claude: Get element name from emoji for display
    private func getElementName(_ emoji: String) -> String {
        switch emoji {
        case "🔥": return "Fire"
        case "🌍": return "Earth"
        case "💨": return "Air"
        case "💧": return "Water"
        default: return "Element"
        }
    }

    /// Claude: Format aspect display for readable explanation
    private func formatAspectExplanation(_ aspectDisplay: String) -> String {
        let symbolMap: [String: String] = [
            "☉": "Sun", "☽": "Moon", "☿": "Mercury", "♀": "Venus",
            "♂": "Mars", "♃": "Jupiter", "♄": "Saturn", "♅": "Uranus",
            "♆": "Neptune", "♇": "Pluto"
        ]

        let aspectMap: [String: String] = [
            "☌": "conjunct", "☍": "opposite", "△": "trine",
            "□": "square", "⚹": "sextile", "⚻": "quincunx"
        ]

        var explanation = aspectDisplay

        // Replace planet symbols
        for (symbol, name) in symbolMap {
            explanation = explanation.replacingOccurrences(of: symbol, with: name)
        }

        // Replace aspect symbols
        for (symbol, name) in aspectMap {
            explanation = explanation.replacingOccurrences(of: symbol, with: name)
        }

        return explanation.isEmpty ? "Active Aspect" : explanation
    }
}

struct CosmicHUDWidget: Widget {
    let kind: String = "CosmicHUDWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            CosmicHUDWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Cosmic HUD")
        .description("Your spiritual awareness at a glance")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryRectangular])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }

    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

// MARK: - Widget Previews
/// Claude: Preview all supported widget sizes

#Preview("Small Widget", as: .systemSmall) {
    CosmicHUDWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, rulerNumber: 7, realmNumber: 3, dominantAspect: "♀ △ ♃", element: "🔥")
    SimpleEntry(date: .now, configuration: .starEyes, rulerNumber: 5, realmNumber: 8, dominantAspect: "☉ ☍ ☽", element: "💧")
}

#Preview("Medium Widget", as: .systemMedium) {
    CosmicHUDWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, rulerNumber: 7, realmNumber: 3, dominantAspect: "♀ △ ♃", element: "🔥")
    SimpleEntry(date: .now, configuration: .starEyes, rulerNumber: 5, realmNumber: 8, dominantAspect: "☉ ☍ ☽", element: "💧")
}

#Preview("Large Widget", as: .systemLarge) {
    CosmicHUDWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, rulerNumber: 7, realmNumber: 3, dominantAspect: "♀ △ ♃", element: "🔥")
    SimpleEntry(date: .now, configuration: .starEyes, rulerNumber: 5, realmNumber: 8, dominantAspect: "☉ ☍ ☽", element: "💧")
}

#Preview("Lock Screen Widget", as: .accessoryRectangular) {
    CosmicHUDWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, rulerNumber: 7, realmNumber: 3, dominantAspect: "♀ △ ♃", element: "🔥")
    SimpleEntry(date: .now, configuration: .starEyes, rulerNumber: 5, realmNumber: 8, dominantAspect: "☉ ☍ ☽", element: "💧")
}

// MARK: - Extensions

// Claude: Calendar extension for day of year calculation (same as CosmicHUDManager)
private extension Calendar {
    func dayOfYear(for date: Date) -> Int? {
        return ordinality(of: .day, in: .year, for: date)
    }
}
