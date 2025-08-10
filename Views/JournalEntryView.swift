import SwiftUI
import os

// Fix the Logger by using os instead of os.log
private let logger = os.Logger(subsystem: "com.vybemvp", category: "journal")

struct JournalEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var entry: JournalEntry
    @FocusState private var focusedField: Field?

    private enum Field: Hashable {
        case title
        case content
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Mood Selection at the top
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(JournalMood.allCases, id: \.rawValue) { mood in
                            Button {
                                entry.moodEmoji = mood.rawValue
                                try? viewContext.save()
                            } label: {
                                VStack {
                                    Text(mood.rawValue)
                                        .font(.title)
                                    Text(mood.description)
                                        .font(.caption)
                                }
                                .padding(8)
                                .background(entry.moodEmoji == mood.rawValue ? Color.accentColor : Color.secondary.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Title field
                TextField("Title", text: Binding(
                    get: { entry.title ?? "" },
                    set: { newValue in
                        entry.title = newValue
                        saveIfNeeded()
                    }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($focusedField, equals: .title)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .content
                }

                // Content field
                TextEditor(text: Binding(
                    get: { entry.content ?? "" },
                    set: { newValue in
                        entry.content = newValue
                        saveIfNeeded()
                    }
                ))
                .frame(minHeight: 200)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary.opacity(0.2))
                )
                .focused($focusedField, equals: .content)
            }
            .padding()
        }
        .navigationTitle(entry.title ?? "New Entry")
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusedField = nil
                }
            }
        }
    }

    private func saveIfNeeded() {
        guard viewContext.hasChanges else { return }

        do {
            try viewContext.save()
        } catch {
            logger.error("Failed to save entry: \(error.localizedDescription)")
        }
    }
}

// Preview provider
struct JournalEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let entry = JournalEntry(context: context)
        entry.title = "Sample Entry"
        entry.content = "Sample content"
        entry.timestamp = Date()

        return NavigationView {
            JournalEntryView(entry: entry)
        }
        .environment(\.managedObjectContext, context)
    }
}
