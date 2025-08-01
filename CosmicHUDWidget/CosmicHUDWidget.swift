//
//  CosmicHUDWidget.swift
//  CosmicHUDWidget
//
//  Created by Corey Davis on 7/30/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
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
                Text("2") // Claude: This would be dynamic ruler number
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            Text("Ruler")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Divider()
            
            Text("🔮 2")
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
                        Text("2")
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
                        Text("2")
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
                    Text("☉ ☍ ☿")
                        .font(.body)
                        .fontWeight(.medium)
                    Text("Aspect")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            // Brief insight for medium widget - optimized to prevent cutoff
            Text(getInsightText(rulerNumber: 2, aspectType: "opposition", widgetSize: .medium))
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
                        Text("2")
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
                        Text("2")
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
                    Text("🔥")
                        .font(.title3)
                    Text("Fire")
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
                Text("☉ ☍ ☿")
                    .font(.title3)
                    .fontWeight(.medium)
                Text("Sun opposite Mercury")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Comprehensive insight using template system
            VStack(spacing: 6) {
                Text(getInsightTitle(for: 2))
                    .font(.body)
                    .fontWeight(.semibold)
                
                Text(getInsightText(rulerNumber: 2, aspectType: "opposition", widgetSize: .large))
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
            Text("👑2")
                .font(.body)
                .fontWeight(.semibold)
            
            Text("🔮2")
                .font(.body)
                .fontWeight(.semibold)
            
            Spacer()
            
            Text("☉☍☿")
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
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}

#Preview("Medium Widget", as: .systemMedium) {
    CosmicHUDWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}

#Preview("Large Widget", as: .systemLarge) {
    CosmicHUDWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}

#Preview("Lock Screen Widget", as: .accessoryRectangular) {
    CosmicHUDWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
