import SwiftUI

struct EditJournalEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var entry: JournalEntry
    
    @State private var title: String
    @State private var content: String
    @State private var selectedMoodEmoji: String
    
    init(entry: JournalEntry) {
        self.entry = entry
        _title = State(initialValue: entry.title ?? "")
        _content = State(initialValue: entry.content ?? "")
        _selectedMoodEmoji = State(initialValue: entry.moodEmoji ?? "")
    }
    
    var body: some View {
        Form {
            Section(header: Text("Entry Details")) {
                TextField("Title", text: $title)
                TextEditor(text: $content)
                    .frame(height: 100)
            }
            
            Section(header: Text("Additional Info")) {
                TextField("Mood (optional)", text: $selectedMoodEmoji)
                Text("Focus Number: \(entry.focusNumber)")
            }
        }
        .navigationTitle("Edit Entry")
        .navigationBarItems(
            leading: Button("Cancel") { dismiss() },
            trailing: Button("Save") {
                saveChanges()
            }
        )
    }
    
    private func saveChanges() {
        entry.title = title
        entry.content = content
        entry.moodEmoji = selectedMoodEmoji.isEmpty ? nil : selectedMoodEmoji
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to save changes: \(error.localizedDescription)")
        }
        
        dismiss()
    }
} 