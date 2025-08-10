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

                    // Moon Phase Testing Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("🌙 Moon Phase Calculator Test")
                            .font(.headline)
                            .foregroundColor(.white)

                        // Current Moon Phase
                        CurrentMoonPhaseView()

                        // Spiritual Meaning
                        SpiritualMeaningView()

                        // Test Known Dates
                        VStack(alignment: .leading, spacing: 10) {
                            Text("📅 Known Date Tests:")
                                .font(.subheadline)
                                .foregroundColor(.white)

                            // July 3, 2023 - Known Full Moon
                            if let fullMoonDate = Calendar.current.date(from: DateComponents(year: 2023, month: 7, day: 3)) {
                                let fullMoonInfo = MoonPhaseCalculator.moonInfo(for: fullMoonDate)
                                HStack {
                                    Text(fullMoonInfo.phase.emoji)
                                    Text("July 3, 2023: \(fullMoonInfo.phase.rawValue)")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("Age: \(String(format: "%.1f", fullMoonInfo.age))")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                }
                            }

                            // July 17, 2023 - Known New Moon
                            if let newMoonDate = Calendar.current.date(from: DateComponents(year: 2023, month: 7, day: 17)) {
                                let newMoonInfo = MoonPhaseCalculator.moonInfo(for: newMoonDate)
                                HStack {
                                    Text(newMoonInfo.phase.emoji)
                                    Text("July 17, 2023: \(newMoonInfo.phase.rawValue)")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("Age: \(String(format: "%.1f", newMoonInfo.age))")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                }
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(8)

                        // Utility Functions Test
                        VStack(alignment: .leading, spacing: 5) {
                            Text("🔮 Cosmic Timing:")
                                .font(.subheadline)
                                .foregroundColor(.white)

                            Text("Days until Full Moon: \(MoonPhaseCalculator.daysUntilFullMoon())")
                                .foregroundColor(.yellow)
                            Text("Days until New Moon: \(MoonPhaseCalculator.daysUntilNewMoon())")
                                .foregroundColor(.purple)
                        }
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(8)

                        // Run Console Tests Button
                        Button(action: {
                            print("\n" + String(repeating: "🌙", count: 25))
                            print("🔬 CONWAY'S MOON PHASE ALGORITHM TEST")
                            print(String(repeating: "🌙", count: 25))

                            MoonPhaseCalculator.runTests()

                            print(String(repeating: "🌙", count: 25) + "\n")
                        }) {
                            Text("🧪 Run Console Tests")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue.opacity(0.6))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(15)

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
                .padding()
            }
            .background(Color.black)
            .navigationTitle("Cosmic Test Lab")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
            .onAppear {
                performanceMonitor.startMonitoring()
                print("🧪 TestCosmicAnimationView: Performance monitoring started")
                // Auto-run tests on appear
                print("\n🌙 Auto-running Moon Phase Tests...")
                MoonPhaseCalculator.runTests()
            }
            .onDisappear {
                performanceMonitor.stopMonitoring()
                print("🧪 TestCosmicAnimationView: Performance monitoring stopped")
            }
        }
    }
}

// MARK: - Supporting Views

struct CurrentMoonPhaseView: View {
    var body: some View {
        let currentMoonInfo = MoonPhaseCalculator.moonInfo(for: Date())

        HStack {
            Text(currentMoonInfo.phase.emoji)
                .font(.largeTitle)
            VStack(alignment: .leading) {
                Text("Today: \(currentMoonInfo.phase.rawValue)")
                    .foregroundColor(.white)
                Text("Age: \(String(format: "%.1f", currentMoonInfo.age)) days")
                    .foregroundColor(.gray)
                Text("Illumination: \(String(format: "%.1f", currentMoonInfo.illumination))%")
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(10)
    }
}

struct SpiritualMeaningView: View {
    var body: some View {
        let currentMoonInfo = MoonPhaseCalculator.moonInfo(for: Date())

        Text("✨ \(currentMoonInfo.phase.spiritualMeaning)")
            .foregroundColor(.cyan)
            .font(.caption)
            .padding(.horizontal)
    }
}

// MARK: - Preview
struct TestCosmicAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        TestCosmicAnimationView()
    }
}
