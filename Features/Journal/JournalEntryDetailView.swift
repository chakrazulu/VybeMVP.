import SwiftUI

struct JournalEntryDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var journalManager: JournalManager
    
    let entry: JournalEntry
    @State private var showingDeleteAlert = false
    @State private var isEditing = false
    @State private var editedTitle: String
    @State private var editedContent: String
    
    @FocusState private var focusedField: Field?
    
    private enum Field {
        case title, content
    }
    
    init(entry: JournalEntry) {
        self.entry = entry
        _editedTitle = State(initialValue: entry.title ?? "")
        _editedContent = State(initialValue: entry.content ?? "")
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if isEditing {
                    TextField("Title", text: $editedTitle)
                        .font(.title)
                        .focused($focusedField, equals: .title)
                    
                    TextEditor(text: $editedContent)
                        .frame(minHeight: 200)
                        .focused($focusedField, equals: .content)
                } else {
                    Text(entry.title ?? "")
                        .font(.title)
                        .bold()
                    
                    // Metadata
                    HStack {
                        Label("Focus: \(entry.focusNumber)", systemImage: "number.circle.fill")
                        Spacer()
                        if let timestamp = entry.timestamp {
                            Text(timestamp, style: .date)
                                .foregroundColor(.gray)
                        }
                    }
                    .font(.subheadline)
                    
                    Text(entry.content ?? "")
                        .padding(.top)
                    
                    if let mood = entry.moodEmoji {
                        Label("Mood: \(mood)", systemImage: "face.smiling")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    
                    Button {
                        isEditing = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .alert("Delete Entry?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                deleteEntry()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
        .sheet(isPresented: $isEditing) {
            NavigationView {
                EditJournalEntryView(entry: entry)
            }
        }
        .onChange(of: focusedField) { oldValue, newValue in
            if newValue == nil {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), 
                                             to: nil, 
                                             from: nil, 
                                             for: nil)
            }
        }
    }
    
    private func deleteEntry() {
        journalManager.deleteEntry(entry)
        dismiss()
    }
} 
