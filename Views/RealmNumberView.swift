import SwiftUI

struct RealmNumberView: View {
    @EnvironmentObject var realmNumberManager: RealmNumberManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Realm Number")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            ZStack {
                // Background circle with gradient
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.purple.opacity(0.8),
                                Color.blue.opacity(0.6)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 160, height: 160)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                
                // Number display
                Text("\(realmNumberManager.currentRealmNumber)")
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 2)
            }
            
            // Realm description
            Text(getRealmDescription())
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Additional info card
            VStack(alignment: .leading, spacing: 12) {
                Text("About Realm Numbers")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Your Realm Number is calculated using:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 20) {
                    VStack {
                        Image(systemName: "clock")
                            .foregroundColor(.blue)
                        Text("Time")
                            .font(.caption)
                    }
                    
                    VStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.purple)
                        Text("Date")
                            .font(.caption)
                    }
                    
                    VStack {
                        Image(systemName: "location")
                            .foregroundColor(.green)
                        Text("Location")
                            .font(.caption)
                    }
                    
                    VStack {
                        Image(systemName: "heart")
                            .foregroundColor(.red)
                        Text("BPM")
                            .font(.caption)
                    }
                }
                .padding(.top, 4)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top, 40)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
    
    private func getRealmDescription() -> String {
        let descriptions = [
            "Realm of Creation",
            "Realm of Partnership",
            "Realm of Expression",
            "Realm of Foundation",
            "Realm of Freedom",
            "Realm of Harmony",
            "Realm of Spirituality",
            "Realm of Abundance",
            "Realm of Completion"
        ]
        
        let index = max(0, min(realmNumberManager.currentRealmNumber - 1, descriptions.count - 1))
        return descriptions[index]
    }
}

#Preview {
    RealmNumberView()
        .environmentObject(RealmNumberManager())
} 
