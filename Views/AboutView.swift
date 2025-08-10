/*
 * ========================================
 * ℹ️ ABOUT VIEW - APP INFORMATION & HELP
 * ========================================
 *
 * CORE PURPOSE:
 * Displays comprehensive information about the Vybe app, including its purpose,
 * how it works, and version information. Serves as a help and information
 * resource for users to understand the app's spiritual functionality.
 *
 * SCREEN LAYOUT (iPhone 14 Pro Max: 430×932 points):
 * • NavigationView: Standard iOS navigation with "About" title
 * • ScrollView: Vertical scrolling for content
 * • VStack: Main content container with 20pt spacing
 * • GroupBox: Three main sections with system icons
 *
 * CONTENT SECTIONS:
 * 1. About Vybe: App description and purpose
 * 2. How It Works: Step-by-step user guide
 * 3. Version: App version information
 *
 * UI COMPONENTS:
 * • GroupBox: System-styled containers with labels
 * • Label: System icons with descriptive text
 * • Text: Descriptive content with proper spacing
 * • VStack: Content organization and spacing
 *
 * STYLING:
 * • Standard iOS navigation styling
 * • System GroupBox appearance
 * • Consistent padding (20pt horizontal, 10pt vertical)
 * • Leading alignment for text content
 *
 * INTEGRATION POINTS:
 * • SettingsView: Typically accessed from settings
 * • Navigation system: Standard iOS navigation
 * • No data dependencies: Static content only
 *
 * ACCESSIBILITY:
 * • System icons provide visual context
 * • Clear text hierarchy and spacing
 * • Standard iOS navigation patterns
 */

import SwiftUI

/**
 * AboutView: Information and help interface for the Vybe app
 *
 * Provides users with comprehensive information about the app's purpose,
 * functionality, and usage instructions in a clean, organized format.
 */
struct AboutView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // MARK: - App Description Section
                    GroupBox(
                        label: Label("About Vybe", systemImage: "info.circle")
                    ) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Vybe helps you align with your daily focus number through real-time calculations based on your location and time.")
                                .padding(.vertical, 5)

                            Text("Your focus number is dynamically calculated using:")
                                .padding(.top, 5)

                            VStack(alignment: .leading, spacing: 8) {
                                Label("Current Location", systemImage: "location.circle")
                                Label("Time of Day", systemImage: "clock")
                                Label("Date", systemImage: "calendar")
                            }
                            .padding(.leading)
                        }
                    }
                    .padding(.horizontal)

                    // MARK: - How It Works Section
                    GroupBox(
                        label: Label("How It Works", systemImage: "gear")
                    ) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("1. Choose your focus number")
                            Text("2. Enable auto-updates")
                            Text("3. Get notified when your current focus number matches your chosen number")
                            Text("4. Track your matches in the log")
                        }
                        .padding(.vertical, 5)
                    }
                    .padding(.horizontal)

                    // MARK: - Version Information Section
                    GroupBox(
                        label: Label("Version", systemImage: "doc.text")
                    ) {
                        Text("Vybe MVP 1.0")
                            .padding(.vertical, 5)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("About")
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
