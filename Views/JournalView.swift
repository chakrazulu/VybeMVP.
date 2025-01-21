import SwiftUI

struct JournalView: View {
    @EnvironmentObject var journalManager: JournalManager
    @State private var showingNewEntry = false
    
    var body: some View {
        NavigationView {
            JournalListView()
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
        }
        .sheet(isPresented: $showingNewEntry) {
            NavigationView {
                NewJournalEntryView()
            }
        }
    }
}

#Preview {
    JournalView()
        .environmentObject(JournalManager())
} 