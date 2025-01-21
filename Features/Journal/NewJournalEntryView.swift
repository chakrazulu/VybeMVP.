import SwiftUI

struct NewJournalEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var journalManager: JournalManager
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    
    @State private var title = ""
    @State private var content = ""
    @State private var selectedMoodEmoji = ""
    
    @FocusState private var focusedField: Field?
    
    private enum Field {
        case title, content, mood
    }
    
    private var currentFocusNumber: Int {
        return focusNumberManager.effectiveFocusNumber
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Entry Details")) {
                    TextField("Title", text: $title)
                        .focused($focusedField, equals: .title)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .content
                        }
                    
                    ZStack(alignment: .topLeading) {
                        if content.isEmpty {
                            Text("Write your thoughts...")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                        TextEditor(text: $content)
                            .frame(minHeight: 100)
                            .focused($focusedField, equals: .content)
                    }
                }
                
                Section(header: Text("Additional Info")) {
                    TextField("Mood (optional)", text: $selectedMoodEmoji)
                    Text("Focus Number: \(currentFocusNumber)")
                }
            }
            .navigationTitle("New Entry")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") { saveEntry() }
            )
            .onAppear {
                // Set initial focus to title field
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    focusedField = .title
                }
            }
        }
    }
    
    private func saveEntry() {
        guard !content.isEmpty else { return }
        
        _ = journalManager.createEntry(
            title: title.isEmpty ? "Untitled" : title,
            content: content,
            focusNumber: currentFocusNumber,
            moodEmoji: selectedMoodEmoji.isEmpty ? nil : selectedMoodEmoji
        )
        
        dismiss()
    }
} 
