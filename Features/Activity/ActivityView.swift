import SwiftUI
import CoreData // Import CoreData

struct ActivityView: View {
    @Environment(\.managedObjectContext) private var viewContext // Access managed object context
    @StateObject private var activityNavigationManager = ActivityNavigationManager.shared

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
            // Clear any previously set insightToView when the tab appears,
            // unless we want to keep it highlighted.
            // For now, let's clear it so the list always shows fresh.
            // activityNavigationManager.insightToView = nil
        }
    }
}

struct FullInsightCard: View {
    let logEntry: PersistedInsightLog // Changed from MatchedInsightData to PersistedInsightLog
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Resonance: Focus #\(logEntry.number) Aligned")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                    Text("Received: \(logEntry.timestamp ?? Date(), style: .date) at \(logEntry.timestamp ?? Date(), style: .time)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                Spacer()
            }
            
            Divider().background(Color.yellow.opacity(0.5))
            
            Text(logEntry.text ?? "Insight text not available.")
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(5)
                .multilineTextAlignment(.leading)
            
            if let tags = logEntry.tags, !tags.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "tag.fill")
                        .font(.caption)
                        .foregroundColor(.yellow.opacity(0.8))
                    Text(tags)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.top, 8)
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.orange.opacity(0.6), 
                    Color.red.opacity(0.4),
                    Color.purple.opacity(0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(color: .orange.opacity(0.2), radius: 10, x: 0, y: 5)
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