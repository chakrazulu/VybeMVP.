/*
 * ========================================
 * 🧪 TEST COSMIC ANIMATION VIEW
 * ========================================
 * 
 * TESTING PURPOSE:
 * Simple test view to validate ScrollSafeCosmicView component works properly
 * on real device before integrating into HomeView. This allows us to verify:
 * - Cosmic animations run smoothly during scroll
 * - 60fps performance maintained
 * - No UI interference or lag
 * - Proper layering and visual effects
 */

import SwiftUI

struct TestCosmicAnimationView: View {
    var body: some View {
        NavigationView {
            ScrollSafeCosmicView {
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        Text("🌌 Cosmic Animation Test")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 20)
                        
                        Text("Scroll up and down to test cosmic animations")
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        // Test Content Cards
                        ForEach(0..<10) { index in
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Test Card \(index + 1)")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Text("Sacred Number: \(index + 1)")
                                        .font(.caption)
                                        .foregroundColor(.gold)
                                }
                                
                                Text("This is test content to validate that cosmic animations continue running smoothly while scrolling. The background should show rotating sacred geometry and pulsing cosmic effects.")
                                    .font(.body)
                                    .foregroundColor(.gray)
                                    .lineLimit(nil)
                                
                                // Simulate some interactive elements
                                HStack {
                                    Button("Test Button") {
                                        print("🧪 Test button tapped - animations should continue")
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.blue.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    
                                    Spacer()
                                    
                                    Text("ID: \(index)")
                                        .font(.caption)
                                        .foregroundColor(.purple)
                                }
                            }
                            .padding()
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                        
                        // Footer
                        Text("🌟 End of Test Content")
                            .font(.title2)
                            .foregroundColor(.gold)
                            .padding(.vertical, 40)
                    }
                }
            }
            .navigationTitle("Cosmic Test")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
        }
    }
}

// MARK: - Color Extensions (if not already defined)
extension Color {
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.0)
}

// MARK: - Preview
struct TestCosmicAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        TestCosmicAnimationView()
    }
} 