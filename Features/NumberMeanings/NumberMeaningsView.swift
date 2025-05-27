import SwiftUI

struct NumberMeaningsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                CosmicBackgroundView().ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 30) {
                        // Focus Numbers Section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Focus Numbers")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Your Focus Number is a personal number you choose to align with. Each number carries unique energetic properties and meanings.")
                                .foregroundColor(.secondary)
                            
                            NumberMeaningsList(type: .focus)
                        }
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.purple.opacity(0.5), lineWidth: 1)
                        )
                        
                        // Realm Numbers Section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Realm Numbers")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("The Realm Number represents the current vibrational frequency of your environment. It is calculated using time, location, and biometric data.")
                                .foregroundColor(.secondary)
                            
                            NumberMeaningsList(type: .realm)
                        }
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                        )
                    }
                    .padding()
                }
                .navigationTitle("Number Meanings")
            }
        }
    }
}

struct NumberMeaningsList: View {
    enum NumberType {
        case focus
        case realm
    }
    
    let type: NumberType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(1...9, id: \.self) { number in
                VStack(alignment: .leading, spacing: 8) {
                    Text("Number \(number)")
                        .font(.headline)
                    
                    Text(getMeaning(for: number, type: type))
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private func getMeaning(for number: Int, type: NumberType) -> String {
        switch type {
        case .focus:
            switch number {
            case 1: return "Leadership & Independence: The pioneer, initiator, and leader. Represents new beginnings and self-reliance."
            case 2: return "Cooperation & Balance: The mediator and peacemaker. Represents partnerships and diplomacy."
            case 3: return "Creativity & Expression: The artist and communicator. Represents joy and self-expression."
            case 4: return "Stability & Organization: The builder and manager. Represents order and foundation."
            case 5: return "Freedom & Change: The adventurer and explorer. Represents versatility and progress."
            case 6: return "Harmony & Responsibility: The nurturer and caretaker. Represents love and service."
            case 7: return "Wisdom & Understanding: The seeker and analyst. Represents spirituality and knowledge."
            case 8: return "Power & Abundance: The achiever and executive. Represents material success."
            case 9: return "Compassion & Completion: The humanitarian and teacher. Represents universal love."
            default: return ""
            }
            
        case .realm:
            switch number {
            case 1: return "Realm of Creation: A time for new beginnings, taking initiative, and starting fresh."
            case 2: return "Realm of Harmony: A time for cooperation, relationships, and finding balance."
            case 3: return "Realm of Expression: A time for creativity, communication, and joy."
            case 4: return "Realm of Foundation: A time for organization, building, and establishing order."
            case 5: return "Realm of Change: A time for adventure, freedom, and embracing change."
            case 6: return "Realm of Love: A time for nurturing, responsibility, and harmony."
            case 7: return "Realm of Wisdom: A time for learning, introspection, and spiritual growth."
            case 8: return "Realm of Power: A time for achievement, abundance, and material success."
            case 9: return "Realm of Completion: A time for letting go, universal love, and completion."
            default: return ""
            }
        }
    }
}

#Preview {
    NumberMeaningsView()
} 