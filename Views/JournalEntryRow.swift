import SwiftUI

struct JournalEntryRow: View {
    @ObservedObject var entry: JournalEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.title ?? "Untitled")
                .font(.headline)
            
            HStack {
                if let moodEmoji = entry.moodEmoji {
                    Text(moodEmoji)
                }
                
                Text("Focus Number: \(entry.focusNumber)")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                
                Spacer()
                
                Text(entry.timestamp ?? Date(), style: .date)
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
} 