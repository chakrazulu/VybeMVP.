import SwiftUI
import CoreData
import os

// Add logger at the top level
private let logger = os.Logger(subsystem: "com.vybemvp", category: "journal")

struct JournalListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    @State private var searchText = ""
    @State private var selectedMood: JournalMood?
    @State private var selectedFocusNumber: Int?

    var body: some View {
        NavigationView {
            List {
                // Filter Options Section
                Section {
                    Button("All Entries") {
                        selectedMood = nil
                        selectedFocusNumber = nil
                    }

                    NavigationLink("By Focus Number") {
                        List(1...9, id: \.self) { number in
                            Button {
                                selectedFocusNumber = number
                                selectedMood = nil
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("\(number)")
                            }
                        }
                        .navigationTitle("Focus Numbers")
                    }

                    NavigationLink("By Mood") {
                        List(JournalMood.allCases, id: \.rawValue) { mood in
                            Button {
                                selectedMood = mood
                                selectedFocusNumber = nil
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                HStack {
                                    Text(mood.rawValue)
                                    Text(mood.description)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .navigationTitle("Moods")
                    }
                }

                // Entries Section
                Section {
                    ForEach(filteredEntries) { entry in
                        NavigationLink {
                            JournalEntryView(entry: entry)
                        } label: {
                            JournalEntryRow(entry: entry)
                        }
                    }
                }
            }
            .navigationTitle("Journal")
        }
        .searchable(text: $searchText)
    }

    private var filteredEntries: [JournalEntry] {
        let request = JournalEntry.fetchRequest()
        var predicates: [NSPredicate] = []

        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "title CONTAINS[cd] %@ OR content CONTAINS[cd] %@",
                                       searchText, searchText))
        }

        if let mood = selectedMood {
            predicates.append(NSPredicate(format: "moodEmoji == %@", mood.rawValue))
        }

        if let focusNumber = selectedFocusNumber {
            predicates.append(NSPredicate(format: "focusNumber == %d", focusNumber))
        }

        if !predicates.isEmpty {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }

        do {
            return try viewContext.fetch(request)
        } catch {
            logger.error("Failed to fetch entries: \(error)")
            return []
        }
    }
}

// FilterView can stay in this file
struct FilterView: View {
    enum FilterType {
        case focusNumber
        case mood
    }

    let type: FilterType
    @Binding var selectedNumber: Int?
    @Binding var selectedMood: JournalMood?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext

    init(type: FilterType, selectedNumber: Binding<Int?> = .constant(nil), selectedMood: Binding<JournalMood?> = .constant(nil)) {
        self.type = type
        _selectedNumber = selectedNumber
        _selectedMood = selectedMood
    }

    var body: some View {
        List {
            switch type {
            case .focusNumber:
                ForEach(1...9, id: \.self) { number in
                    Button {
                        selectedNumber = number
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("\(number)")
                    }
                }

            case .mood:
                ForEach(JournalMood.allCases, id: \.self) { mood in
                    Button {
                        selectedMood = mood
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Text(mood.rawValue)
                            Text(mood.description)
                        }
                    }
                }
            }
        }
        .navigationTitle(type == .focusNumber ? "Focus Numbers" : "Moods")
    }
}
