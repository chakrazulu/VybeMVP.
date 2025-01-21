struct JournalListView: View {
    @EnvironmentObject var journalManager: JournalManager
    @State private var showingNewEntry = false
    
    var body: some View {
        List {
            ForEach(journalManager.entries) { entry in
                NavigationLink(destination: JournalEntryDetailView(entry: entry)) {
                    JournalEntryView(entry: entry)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Journal")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingNewEntry = true
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .sheet(isPresented: $showingNewEntry) {
            NavigationView {
                NewJournalEntryView()
            }
        }
    }
} 