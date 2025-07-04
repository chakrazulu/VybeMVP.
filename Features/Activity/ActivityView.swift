import SwiftUI
import CoreData // Import CoreData

/**
 * ActivityView: Cosmic activity feed showing persisted insight logs
 * 
 * 🎯 PIXEL-PERFECT UI REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
 * 
 * === SCREEN LAYOUT (iPhone 14 Pro Max: 430×932 points) ===
 * • NavigationView: Standard iOS navigation
 * • Title: "Cosmic Activity" - navigation title style
 * • Background: Full screen CosmicBackgroundView
 * • ScrollView: Vertical, full width
 * • Content padding: 20pts all sides
 * 
 * === EMPTY STATE ===
 * • Text: "No activity or insights recorded yet."
 * • Font: Headline (~17pt)
 * • Color: Secondary (system gray)
 * • Alignment: Center horizontally and vertically
 * • Padding: Standard system padding
 * 
 * === INSIGHT LIST ===
 * • Container: LazyVStack for performance
 * • Spacing: 20pts between cards
 * • Sort order: Newest first (by timestamp)
 * • Animation: Default Core Data animation
 * 
 * === FULL INSIGHT CARD ===
 * • Container padding: 20pts all sides
 * • Corner radius: 16pts
 * • Border: 2pt gradient stroke
 * • Shadow 1: Sacred color 30%, 15pt blur, 8pt Y offset
 * • Shadow 2: Black 20%, 5pt blur, 2pt Y offset
 * 
 * === CARD HEADER ===
 * • Title font: Title2 (~22pt), bold
 * • Title gradient: White→Sacred color(90%)
 * • Title shadow: Sacred color 40%, 3pt blur
 * • Date/time: Caption font (~12pt), 80% white
 * • Number badge: 50×50pt circle
 * • Badge gradient: Radial, sacred color 80%→40%
 * • Badge number: 24pt bold rounded, white
 * 
 * === CARD CONTENT ===
 * • Divider: 2pt height, gradient sacred color
 * • Body text: Body font (~17pt), 95% white
 * • Line spacing: 6pts
 * • Text alignment: Leading (left)
 * 
 * === TAGS SECTION ===
 * • Icon: tag.fill, caption size
 * • Tag text: Caption2 font (~11pt)
 * • Tag padding: 8pt horizontal, 4pt vertical
 * • Tag background: Capsule, sacred color 20%
 * • Tag border: 1pt, sacred color 40%
 * • Section margin: 8pt top
 * 
 * === SACRED COLOR SYSTEM ===
 * 1. Red - Creation/Fire 🔥
 * 2. Orange - Partnership/Balance ⚖️
 * 3. Yellow - Expression/Joy ☀️
 * 4. Green - Foundation/Earth 🌍
 * 5. Blue - Freedom/Sky 🌌
 * 6. Indigo - Harmony/Love 💜
 * 7. Purple - Spirituality/Wisdom 🔮
 * 8. Gold (#FFD700) - Abundance/Prosperity 💰
 * 9. White - Completion/Universal ⚪
 * 
 * === GRADIENT SYSTEM ===
 * • Card background: 4 stops
 *   - Sacred color 80%
 *   - Sacred color 50%
 *   - Sacred color 30%
 *   - Black 40%
 * • Direction: Top-left to bottom-right
 * 
 * === PERFORMANCE OPTIMIZATIONS ===
 * • LazyVStack: Only renders visible cards
 * • Core Data fetch: Automatic batching
 * • AI refresh: Deferred by 1.0s on appear
 * • Navigation highlight: Efficient filtering
 * 
 * === STATE MANAGEMENT ===
 * • managedObjectContext: Core Data context
 * • insightLogs: FetchedResults from Core Data
 * • activityNavigationManager: For deep linking
 * • aiInsightManager: For refresh triggers
 */
struct ActivityView: View {
    @Environment(\.managedObjectContext) private var viewContext // Access managed object context
    @StateObject private var activityNavigationManager = ActivityNavigationManager.shared
    @StateObject private var aiInsightManager = AIInsightManager.shared

    // FetchRequest to load PersistedInsightLog entries, sorted by timestamp descending
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PersistedInsightLog.timestamp, ascending: false)],
        animation: .default) // Optional: add animation for list changes
    private var insightLogs: FetchedResults<PersistedInsightLog>

    var body: some View {
        NavigationView { 
            ScrollView {
                if insightLogs.isEmpty {
                    Text("No activity or insights recorded yet.")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Center if empty
                } else {
                    LazyVStack(alignment: .leading, spacing: 20) { // Use LazyVStack for performance
                        // If activityNavigationManager has an insightToView, try to find and show it first
                        // Otherwise, list all insights
                        // This logic can be refined later if we want to highlight a navigated insight within the list
                        if let specificInsightID = activityNavigationManager.insightToView?.id,
                           let specificLog = insightLogs.first(where: { $0.id == specificInsightID }) {
                            FullInsightCard(logEntry: specificLog)
                            // Optionally add a divider or different styling for the navigated item
                            ForEach(insightLogs.filter { $0.id != specificInsightID }) { log in
                                FullInsightCard(logEntry: log)
                            }
                        } else {
                            ForEach(insightLogs) { log in
                                FullInsightCard(logEntry: log)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Cosmic Activity")
            .background(CosmicBackgroundView())
        }
        .onAppear {
            // PERFORMANCE FIX: Defer heavy AI insights refresh to prevent tab loading delays
            
            // Clear any previously set insightToView when the tab appears
            // activityNavigationManager.insightToView = nil
            
            // Defer AI insights refresh by 1 second to prevent blocking
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            aiInsightManager.refreshInsightIfNeeded()
                print("⚡ ActivityView: AI insights refresh deferred for performance")
            }
        }
    }
}

struct FullInsightCard: View {
    let logEntry: PersistedInsightLog // Changed from MatchedInsightData to PersistedInsightLog
    
    // Get the sacred color for this number
    private var primaryColor: Color {
        switch logEntry.number {
        case 1: return .red          // Creation/Fire 🔥
        case 2: return .orange       // Partnership/Balance ⚖️
        case 3: return .yellow       // Expression/Joy ☀️
        case 4: return .green        // Foundation/Earth 🌍
        case 5: return .blue         // Freedom/Sky 🌌
        case 6: return .indigo       // Harmony/Love 💜
        case 7: return .purple       // Spirituality/Wisdom 🔮
        case 8: return Color(red: 1.0, green: 0.84, blue: 0.0) // Gold - Abundance/Prosperity 💰
        case 9: return .white        // Completion/Universal ⚪
        default: return .white
        }
    }
    
    // Create complementary gradient colors
    private var gradientColors: [Color] {
        [
            primaryColor.opacity(0.8),
            primaryColor.opacity(0.5),
            primaryColor.opacity(0.3),
            Color.black.opacity(0.4)
        ]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Resonance: Focus #\(logEntry.number) Aligned")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [.white, primaryColor.opacity(0.9)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: primaryColor.opacity(0.4), radius: 3, x: 0, y: 1)
                    
                    Text("Received: \(logEntry.timestamp ?? Date(), style: .date) at \(logEntry.timestamp ?? Date(), style: .time)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                Spacer()
                
                // Number badge with sacred color
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [primaryColor.opacity(0.8), primaryColor.opacity(0.4)]),
                                center: .center,
                                startRadius: 5,
                                endRadius: 25
                            )
                        )
                        .frame(width: 50, height: 50)
                        .shadow(color: primaryColor.opacity(0.6), radius: 8, x: 0, y: 0)
                    
                    Text("\(logEntry.number)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                }
            }
            
            Divider()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [primaryColor.opacity(0.7), primaryColor.opacity(0.3)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 2)
            
            Text(logEntry.text ?? "Insight text not available.")
                .font(.body)
                .foregroundColor(.white.opacity(0.95))
                .lineSpacing(6)
                .multilineTextAlignment(.leading)
            
            if let tags = logEntry.tags, !tags.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "tag.fill")
                        .font(.caption)
                        .foregroundColor(primaryColor.opacity(0.8))
                        .shadow(color: primaryColor.opacity(0.4), radius: 2)
                    
                    Text(tags)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(primaryColor.opacity(0.2))
                                .overlay(
                                    Capsule()
                                        .stroke(primaryColor.opacity(0.4), lineWidth: 1)
                                )
                        )
                }
                .padding(.top, 8)
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [primaryColor.opacity(0.6), primaryColor.opacity(0.2)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .cornerRadius(16)
        .shadow(color: primaryColor.opacity(0.3), radius: 15, x: 0, y: 8)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        // For preview, we need to inject the managed object context
        let persistenceController = PersistenceController.preview // Use your preview controller
        ActivityView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(FocusNumberManager.shared) // Keep for any indirect dependencies if any
            .environmentObject(ActivityNavigationManager.shared) // Add if ActivityView uses it directly in preview
            .onAppear {
                // Create some sample PersistedInsightLog data for the preview
                let context = persistenceController.container.viewContext
                for i in 0..<3 {
                    let newLog = PersistedInsightLog(context: context)
                    newLog.id = UUID()
                    newLog.timestamp = Date().addingTimeInterval(Double(-i * 3600)) // Offset timestamps
                    newLog.number = Int16(5 + i)
                    newLog.category = "insight"
                    newLog.text = "This is a sample preview insight for number \\(5+i). It's designed to test the display of persisted logs in the ActivityView. This text can be quite long to check wrapping and layout."
                    newLog.tags = i % 2 == 0 ? "FocusMatch, RealmTouch" : "TestInsight"
                }
                do {
                    try context.save()
                } catch {
                    // Simplified fatalError for preview
                    fatalError("Unresolved error during ActivityView preview setup: \(error.localizedDescription)")
                }
            }
    }
} 