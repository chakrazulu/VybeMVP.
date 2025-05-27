import SwiftUI

struct JournalView: View {
    @EnvironmentObject var journalManager: JournalManager
    @State private var showingNewEntrySheet = false
    @State private var searchText = ""
    @State private var selectedFocusNumber: Int? = nil
    @State private var selectedMood: JournalMood? = nil
    
    var filteredEntries: [JournalEntry] {
        var entries = journalManager.entries
        
        // Apply focus number filter
        if let focusNumber = selectedFocusNumber {
            entries = entries.filter { $0.focusNumber == focusNumber }
        }
        
        // Apply mood filter
        if let mood = selectedMood {
            entries = entries.filter { $0.moodEmoji == mood.rawValue }
        }
        
        // Apply search text filter
        if !searchText.isEmpty {
            entries = entries.filter { entry in
                (entry.title ?? "").localizedCaseInsensitiveContains(searchText) ||
                (entry.content ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return entries
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                CosmicBackgroundView().ignoresSafeArea()

                List {
                    ForEach(filteredEntries, id: \.id) { entry in
                        NavigationLink(destination: JournalEntryDetailView(entry: entry)) {
                            VStack(alignment: .leading) {
                                Text(entry.title ?? "Untitled")
                                    .font(.headline)
                                Text("Focus Number: \(entry.focusNumber)")
                                    .font(.subheadline)
                                if let timestamp = entry.timestamp {
                                    Text(timestamp, style: .date)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    .onDelete { indexSet in
                        for index in indexSet {
                            journalManager.deleteEntry(filteredEntries[index])
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Search journals...")
                .navigationTitle("Journal")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("New Entry") {
                            showingNewEntrySheet = true
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        filterMenu
                    }
                }
                .sheet(isPresented: $showingNewEntrySheet) {
                    NewJournalEntryView()
                }
                .background(Color.clear)
                .scrollContentBackground(.hidden)
            }
        }
    }
    
    var filterMenu: some View {
        Menu {
            Button("All Entries") {
                selectedFocusNumber = nil
                selectedMood = nil
            }
            
            Menu("By Focus Number") {
                ForEach(FocusNumberManager.validFocusNumbers, id: \.self) { number in
                    Button(action: {
                        selectedFocusNumber = number
                        selectedMood = nil
                    }) {
                        HStack {
                            Text("\(number)")
                            if selectedFocusNumber == number {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
            
            Menu("By Mood") {
                ForEach(JournalMood.allCases, id: \.self) { mood in
                    Button(action: {
                        selectedMood = mood
                        selectedFocusNumber = nil
                    }) {
                        HStack {
                            Text(mood.rawValue)
                            Text(mood.description)
                                .foregroundColor(.secondary)
                            if selectedMood == mood {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
        } label: {
            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
        }
    }
} 