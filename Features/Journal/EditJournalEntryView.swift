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
        ZStack {
            // Subtle Cosmic Background (non-interactive)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black,
                    Color.purple.opacity(0.2),
                    Color.indigo.opacity(0.1),
                    Color.black
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Sacred Header
                    sacredHeaderSection
                    
                    // Edit Form
                    editFormSection
                    
                    // Sacred Numbers Section
                    metadataSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
        .navigationTitle("Edit Sacred Reflection")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") { 
                    dismiss() 
                }
                .foregroundColor(.purple)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveChanges()
                }
                .foregroundColor(.purple)
                .fontWeight(.semibold)
            }
        }
    }
    
    // MARK: - Sacred Header Section
    
    private var sacredHeaderSection: some View {
        VStack(spacing: 12) {
            Text("✨ Edit Sacred Reflection ✨")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [.white, .purple.opacity(0.9)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .multilineTextAlignment(.center)
            
            if let timestamp = entry.timestamp {
                Text("Originally created on \(timestamp, style: .date)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .italic()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.purple.opacity(0.6), .blue.opacity(0.4)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Edit Form Section
    
    private var editFormSection: some View {
        VStack(spacing: 20) {
            Text("📝 Edit Your Sacred Words")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 16) {
                // Title Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("✨ Sacred Title")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    TextField("Give your reflection a sacred title...", text: $title)
                        .textFieldStyle(.roundedBorder)
                        .background(Color.white)
                        .cornerRadius(8)
                }
                
                // Content Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("📜 Sacred Content")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    TextEditor(text: $content)
                        .frame(minHeight: 150)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                        )
                }
                
                // Mood Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("🌙 Sacred Mood")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    TextField("Express your mood with an emoji...", text: $selectedMoodEmoji)
                        .textFieldStyle(.roundedBorder)
                        .background(Color.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue.opacity(0.5), .purple.opacity(0.3)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Sacred Numbers Section
    
    private var metadataSection: some View {
        VStack(spacing: 16) {
            Text("🔢 Your Sacred Numbers")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 20) {
                // Focus Number Badge
                VStack(spacing: 8) {
                    Text("Focus Number")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .fontWeight(.medium)
                    
                    ZStack {
                        Circle()
                            .fill(RadialGradient(
                                gradient: Gradient(colors: [sacredNumberColor(for: Int(entry.focusNumber)).opacity(0.8), sacredNumberColor(for: Int(entry.focusNumber)).opacity(0.3)]),
                                center: .center,
                                startRadius: 5,
                                endRadius: 30
                            ))
                            .frame(width: 60, height: 60)
                        
                        Text("\(entry.focusNumber)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    Text("Your chosen path")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                }
                
                if entry.realmNumber > 0 {
                    // Realm Number Badge
                    VStack(spacing: 8) {
                        Text("Realm Number")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                            .fontWeight(.medium)
                        
                        ZStack {
                            Circle()
                                .fill(RadialGradient(
                                    gradient: Gradient(colors: [sacredNumberColor(for: Int(entry.realmNumber)).opacity(0.8), sacredNumberColor(for: Int(entry.realmNumber)).opacity(0.3)]),
                                    center: .center,
                                    startRadius: 5,
                                    endRadius: 30
                                ))
                                .frame(width: 60, height: 60)
                            
                            Text("\(entry.realmNumber)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        
                        Text("Cosmic frequency")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.green.opacity(0.5), .cyan.opacity(0.3)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Helper Methods
    
    private func sacredNumberColor(for number: Int) -> Color {
        switch number {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        case 6: return .indigo
        case 7: return .purple
        case 8: return Color(red: 1.0, green: 0.84, blue: 0.0) // Gold
        case 9: return .white
        default: return .gray
        }
    }
    
    private func saveChanges() {
        entry.title = title
        entry.content = content
        entry.moodEmoji = selectedMoodEmoji.isEmpty ? nil : selectedMoodEmoji
        
        do {
            try viewContext.save()
            print("✅ Successfully updated journal entry")
        } catch {
            print("❌ Failed to save changes: \(error.localizedDescription)")
        }
        
        dismiss()
    }
} 