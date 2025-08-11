import SwiftUI

/// NumberMeaningsView (PLURAL) - Grid browser for all number meanings
///
/// ⚠️ IMPORTANT NAVIGATION DISTINCTION:
/// - NumberMeaningsView (PLURAL) - THIS FILE - Accessed via ContentView → More tab → Meanings
/// - NumberMeaningView (SINGULAR) - Different file - Accessed by tapping Realm Number
///
/// NAVIGATION PATH TO THIS VIEW:
/// ContentView → Tab 9 (Meanings) → Shows grid of all numbers → Tap number → NumberRichContentView
///
/// PURPOSE:
/// Provides a grid browser interface for exploring all sacred numbers (1-9 and master numbers).
/// When a number is selected, navigates to NumberRichContentView for detailed content display.
struct NumberMeaningsView: View {
    let initialSelectedNumber: Int?

    init(initialSelectedNumber: Int? = nil) {
        self.initialSelectedNumber = initialSelectedNumber
    }

    var body: some View {
        // If we have an initial selected number, navigate directly to that number's rich content
        if let selectedNumber = initialSelectedNumber {
            NumberRichContentView(number: selectedNumber)
        } else {
            // Otherwise show the full number meanings browser
            NavigationView {
                ZStack {
                    CosmicBackgroundView().ignoresSafeArea()

                    ScrollView {
                        VStack(spacing: 30) {
                        // Header Section
                        VStack(alignment: .center, spacing: 16) {
                            Text("Number Meanings")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text("Explore the rich spiritual meanings and correspondences of each sacred number")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.purple.opacity(0.5), lineWidth: 1)
                        )

                        // Core Numbers Section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Core Numbers (1-9)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text("The fundamental building blocks of numerological wisdom, each carrying unique energetic signatures.")
                                .foregroundColor(.white.opacity(0.7))

                            NumberRichContentGrid(numbers: Array(1...9))
                        }
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.purple.opacity(0.5), lineWidth: 1)
                        )

                        // Master Numbers Section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Master Numbers")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text("Elevated spiritual frequencies that carry intensified power and responsibility. These numbers remain unreduced for their sacred significance.")
                                .foregroundColor(.white.opacity(0.7))

                            NumberRichContentGrid(numbers: [11, 22, 33, 44])
                        }
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gold.opacity(0.5), lineWidth: 1)
                        )
                    }
                    .padding()
                }
                .navigationTitle("Number Meanings")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        }
    }
}

struct NumberRichContentGrid: View {
    let numbers: [Int]

    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(numbers, id: \.self) { number in
                NumberCard(number: number)
            }
        }
    }
}

struct NumberCard: View {
    let number: Int

    // Sacred color system
    private var sacredColor: Color {
        switch number {
        case 0: return .white
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        case 6: return .indigo
        case 7: return .purple
        case 8: return Color(red: 1.0, green: 0.84, blue: 0) // Gold
        case 9: return .white
        case 11, 22, 33, 44: return .purple // Master numbers
        default: return .purple
        }
    }

    private var quickMeaning: String {
        switch number {
        case 1: return "Leadership & Independence"
        case 2: return "Cooperation & Balance"
        case 3: return "Creativity & Expression"
        case 4: return "Stability & Organization"
        case 5: return "Freedom & Change"
        case 6: return "Harmony & Responsibility"
        case 7: return "Wisdom & Understanding"
        case 8: return "Power & Abundance"
        case 9: return "Compassion & Completion"
        case 11: return "Spiritual Messenger"
        case 22: return "Master Builder"
        case 33: return "Master Teacher"
        case 44: return "Master Healer"
        default: return "Sacred Number"
        }
    }

    var body: some View {
        NavigationLink(destination: NumberRichContentView(number: number)) {
            VStack(spacing: 12) {
                // Number circle
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [sacredColor.opacity(0.3), sacredColor.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)

                    Circle()
                        .stroke(sacredColor, lineWidth: 2)
                        .frame(width: 60, height: 60)

                    Text("\(number)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(sacredColor)
                }

                // Quick meaning
                Text(quickMeaning)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(minHeight: 32)

                // Master number badge
                if [11, 22, 33, 44].contains(number) {
                    Text("MASTER")
                        .font(.system(size: 8, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(sacredColor.opacity(0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(sacredColor, lineWidth: 0.5)
                        )
                }
            }
            .padding(12)
            .background(Color.black.opacity(0.4))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(sacredColor.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NumberMeaningsView()
}
