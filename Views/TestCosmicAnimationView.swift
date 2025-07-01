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

// TODO: FUTURE IMPROVEMENT - DYNAMIC DEVELOPER TEST HARNESS
// ----------------------------------------------------------
// This test view is currently used for FPS, animation, and sacred geometry debugging.
// In the future, refactor this into a dynamic, parameterized developer test harness.
// - Motivation: Avoid creating a new SwiftUI view for every test scenario. Streamline development, debugging, and AI troubleshooting.
// - Benefits: Rapidly switch between test cases (e.g., Cosmic Animations, Sacred Geometry, etc.) using a Picker/SegmentedControl.
// - Approach: Use an enum for test types, parameterize the harness, and add controls for live tweaking (FPS overlay, animation speed, etc.).
// - Context: Previous issues with AI restoring the wrong view and the need for rapid debugging highlighted the value of a flexible, always-accessible test harness.
// - Action: Keep this improvement in mind for future sprints. See VYBE_MASTER_TASKFLOW_LOG.md for full details.
// ----------------------------------------------------------

import SwiftUI

struct TestCosmicAnimationView: View {
    @ObservedObject private var performanceMonitor = PerformanceMonitor.shared
    
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
                        
                        // Performance Monitor Display
                        VStack(spacing: 8) {
                            Text(performanceMonitor.performanceStatus)
                                .font(.caption)
                                .foregroundColor(.cyan)
                            
                            if performanceMonitor.isMonitoring {
                                HStack {
                                    Text("FPS: \(String(format: "%.1f", performanceMonitor.currentFPS))")
                                        .font(.caption)
                                        .foregroundColor(performanceMonitor.currentFPS >= 55 ? .green : .orange)
                                    
                                    Text("Memory: \(String(format: "%.1f", performanceMonitor.memoryUsageMB))MB")
                                        .font(.caption)
                                        .foregroundColor(performanceMonitor.memoryUsageMB < 100 ? .green : .orange)
                                }
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(8)
                        
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
                                        performanceMonitor.logMetrics("Button Tap Test")
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
            .onAppear {
                performanceMonitor.startMonitoring()
                print("🧪 TestCosmicAnimationView: Performance monitoring started")
            }
            .onDisappear {
                performanceMonitor.stopMonitoring()
                print("🧪 TestCosmicAnimationView: Performance monitoring stopped")
            }
        }
    }
}

// MARK: - Color Extensions removed (already defined in project)

// MARK: - Preview
struct TestCosmicAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        TestCosmicAnimationView()
    }
} 