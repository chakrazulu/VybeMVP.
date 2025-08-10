/*
 * ========================================
 * 🏠 MAIN VIEW - SIMPLIFIED FOCUS NUMBER DISPLAY
 * ========================================
 *
 * CORE PURPOSE:
 * Simple view component for displaying the current focus number from FocusNumberManager.
 * Serves as a basic test interface and demonstration of reactive state management.
 *
 * TECHNICAL ARCHITECTURE:
 * - @EnvironmentObject: FocusNumberManager for reactive focus number updates
 * - VStack Layout: Simple vertical stack with title and optional controls
 * - Reactive Updates: Automatically updates when focus number changes
 *
 * INTEGRATION POINTS:
 * - FocusNumberManager: Source of truth for focus number state
 * - ContentView: Can be embedded in main app navigation
 * - TestingView: Used for focus number testing and validation
 *
 * USAGE:
 * - Development testing of focus number updates
 * - Simple focus number display without complex UI
 * - Demonstration of reactive SwiftUI state management
 *
 * DEPRECATED FEATURES:
 * - Restart Timer button: Removed as FocusNumberManager updates reactively
 * - Manual timer control: No longer needed with automatic updates
 */

import SwiftUI

/**
 * MainView: Simple focus number display component
 *
 * Displays the current focus number from FocusNumberManager in a clean,
 * minimal interface. Used for testing and demonstration purposes.
 *
 * Features:
 * - Reactive focus number display
 * - Clean, minimal UI design
 * - Environment object integration
 */
struct MainView: View {
    @EnvironmentObject var focusManager: FocusNumberManager

    var body: some View {
        VStack {
            Text("Main Focus Number: \(focusManager.selectedFocusNumber)")
                .font(.largeTitle)
                .padding()

            // REMOVE: Button is no longer needed as FocusNumberManager updates reactively.
            /*
            Button("Restart Timer") {
                focusManager.startUpdates()
                print("🟢 Timer restarted")
            }
            .padding()
            */
        }
    }
}
