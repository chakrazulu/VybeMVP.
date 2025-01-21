import SwiftUI

struct NumberMeaningView: View {
    @State private var selectedNumber: Int = 1
    private let manager = NumberMeaningManager.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Number Selector
                Picker("Select Number", selection: $selectedNumber) {
                    ForEach(0...9, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if let meaning = manager.getMeaning(for: selectedNumber) {
                    // Title
                    Text(meaning.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    // Essence
                    MeaningSection(title: "Essence", content: meaning.essence)
                    
                    // Symbolism
                    MeaningSection(title: "Symbolism", content: meaning.symbolism)
                    
                    // Application
                    MeaningSection(title: "Application", content: meaning.application)
                    
                    // Notes
                    if !meaning.notes.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Additional Notes")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            ForEach(meaning.notes, id: \.self) { note in
                                Text(note)
                                    .foregroundColor(.primary)
                                    .padding(.leading)
                            }
                        }
                        .padding(.top)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Number Meanings")
        .onAppear {
            // Initialize meanings if needed
            manager.setupInitialMeanings()
        }
    }
}

struct MeaningSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(content)
                .foregroundColor(.primary)
                .padding(.leading)
        }
    }
}

#Preview {
    NavigationView {
        NumberMeaningView()
    }
} 
