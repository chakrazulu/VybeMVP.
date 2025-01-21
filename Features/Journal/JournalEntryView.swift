struct JournalEntryView: View {
    let entry: JournalEntry
    
    private var focusNumber: Int {
        max(1, min(Int(entry.focusNumber), 9))  // Ensure valid range
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {  // Changed to HStack for better layout
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.title ?? "")
                    .font(.headline)
                    .lineLimit(1)
                
                if let timestamp = entry.timestamp {
                    Text(timestamp, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .layoutPriority(1)  // Give title priority
            
            Spacer()  // Force metadata to trailing edge
            
            VStack(alignment: .trailing, spacing: 8) {
                Label("Focus: \(focusNumber)", 
                      systemImage: "number.circle.fill")
                    .foregroundColor(.accentColor)
                
                if let mood = entry.mood, !mood.isEmpty {
                    Label(mood, systemImage: "face.smiling")
                        .foregroundColor(.secondary)
                }
            }
            .font(.caption)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .contentShape(Rectangle())  // Make entire row tappable
    }
} 