/*
 * ========================================
 * 🧪 TESTING VIEW - MATCH DETECTION VALIDATION
 * ========================================
 *
 * CORE PURPOSE:
 * Development and testing interface for validating cosmic match detection system.
 * Provides manual controls for testing focus number changes, realm number updates,
 * and match history tracking. Essential for debugging and validating match logic.
 *
 * TESTING FEATURES:
 * - Focus Number Display: Shows current selected focus number
 * - Realm Number Display: Shows current calculated realm number
 * - Manual Controls: Force focus number changes and realm number updates
 * - Match History: Displays all recorded cosmic matches with timestamps
 * - Match Simulation: Force matches for testing celebration effects
 *
 * INTEGRATION POINTS:
 * - FocusNumberManager: Source of truth for focus number state and match logs
 * - RealmNumberManager: Current realm number calculations and updates
 * - VybeMatchManager: Match detection and celebration system
 * - SettingsView: Accessible via Settings → Testing → Match Testing
 *
 * TESTING CONTROLS:
 * - Change Focus Number: Cycles through numbers 1-9 for testing
 * - Force Realm Number Match: Sets realm to match focus for instant match
 * - Set Random Realm Number: Generates random realm number 1-9
 * - Match History: Shows all recorded matches with timestamps
 *
 * USAGE SCENARIOS:
 * - Development: Testing match detection algorithms
 * - Debugging: Validating cosmic match celebration effects
 * - QA Testing: Manual validation of number synchronization
 * - User Testing: Demonstrating cosmic match system functionality
 *
 * TECHNICAL ARCHITECTURE:
 * - @EnvironmentObject: Reactive binding to managers
 * - List Layout: Organized sections for different testing features
 * - Date Formatting: Custom formatter for match timestamps
 * - Navigation: Embedded in SettingsView navigation structure
 *
 * MATCH LOGGING:
 * - Timestamp: Precise time of match occurrence
 * - Focus Number: User's selected focus number
 * - Realm Number: Calculated realm number at match time
 * - Persistence: Match logs stored in FocusNumberManager
 * - Display: Chronological list with formatted timestamps
 */

//
//  TestingView.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/28/25.
//

import SwiftUI

/**
 * TestingView: Cosmic match detection testing and validation interface
 *
 * Provides comprehensive testing tools for the cosmic match detection system,
 * including manual controls, match history, and real-time number display.
 * Essential for development, debugging, and user testing of match functionality.
 *
 * Features:
 * - Real-time number display and updates
 * - Manual testing controls for match simulation
 * - Complete match history with timestamps
 * - Integration with cosmic match celebration system
 */
struct TestingView: View {
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    @EnvironmentObject var realmNumberManager: RealmNumberManager
    @State private var showingCosmicValidation = false
    @State private var cosmicValidationReport = ""

    var body: some View {
        List {
            Section(header: Text("Your Numbers")) {
                HStack {
                    Text("Focus Number:")
                    Spacer()
                    Text("\(focusNumberManager.selectedFocusNumber)")
                        .bold()
                }

                HStack {
                    Text("Realm Number:")
                    Spacer()
                    Text("\(realmNumberManager.currentRealmNumber)")
                        .bold()
                }

                Button("Change Focus Number") {
                    // Cycle through 1-9
                    let next = (focusNumberManager.selectedFocusNumber % 9) + 1
                    focusNumberManager.userDidPickFocusNumber(next)
                }
            }

            Section(header: Text("Testing Controls")) {
                Button("Force Realm Number Match") {
                    // Set realm number to match focus number
                    focusNumberManager.updateRealmNumber(focusNumberManager.selectedFocusNumber)
                }

                Button("Set Random Realm Number") {
                    // Set to a random number 1-9
                    let random = Int.random(in: 1...9)
                    focusNumberManager.updateRealmNumber(random)
                }
            }

            /// Claude: Swiss Ephemeris Planetary Validation Section
            ///
            /// Comprehensive testing suite for Swiss Ephemeris planetary calculations.
            /// Shows professional-grade accuracy across multiple time periods and
            /// validates against known astronomical events.
            ///
            /// Testing Features:
            /// - Real-time planetary positions for any date/time
            /// - Historical event validation (conjunctions, solstices)
            /// - Cross-time period consistency checking
            /// - Professional astronomy software comparison guides
            Section(header: Text("Swiss Ephemeris Validation")) {
                /// Claude: Multi-time period planetary accuracy test
                /// Shows planetary positions across different dates to demonstrate
                /// consistent professional accuracy for any moment in time
                Button("Test Planetary Accuracy") {
                    cosmicValidationReport = CosmicData.validatePlanetaryAccuracy()
                    showingCosmicValidation = true
                }
                .foregroundColor(.purple)

                /// Claude: Historical astronomical events validation
                /// Tests Swiss Ephemeris against known events like the 2020 Great Conjunction
                /// and solstices to prove professional-grade accuracy
                Button("Validate Historical Events") {
                    cosmicValidationReport = CosmicData.validateHistoricalEvents()
                    showingCosmicValidation = true
                }
                .foregroundColor(.orange)

                /// Claude: Legacy cosmic engine test (for comparison)
                Button("Test Enhanced Cosmic Engine") {
                    cosmicValidationReport = CosmicData.validateEnhancedCalculations()
                    showingCosmicValidation = true
                }
                .foregroundColor(.blue)

                Text("Swiss Ephemeris provides professional astronomy accuracy for any date/time. Test across multiple periods to verify consistency.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Section(header: Text("Match History")) {
                if focusNumberManager.matchLogs.isEmpty {
                    Text("No matches yet")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(focusNumberManager.matchLogs, id: \.timestamp) { match in
                        VStack(alignment: .leading) {
                            Text("Match at \(match.timestamp, formatter: itemFormatter)")
                            Text("Focus: \(match.chosenNumber) = Realm: \(match.matchedNumber)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Match Testing")
        /// Claude: Cosmic Engine Validation Results Sheet
        ///
        /// Presents detailed validation results in a scrollable sheet format.
        /// Uses monospaced font for proper alignment of tabular comparison data.
        ///
        /// Features:
        /// - Full-screen scrollable content for comprehensive reports
        /// - Monospaced font ensures proper column alignment in data tables
        /// - Navigation bar with inline title and Done button for dismissal
        /// - Responsive to cosmicValidationReport updates from test functions
        ///
        /// Data Display:
        /// - Sky Guide vs Our Engine comparison tables
        /// - Accuracy percentages and status indicators
        /// - Current cosmic state information
        /// - System operational status and deployment readiness
        .sheet(isPresented: $showingCosmicValidation) {
            NavigationView {
                ScrollView {
                    /// Claude: Validation report display
                    /// Uses monospaced font for proper table formatting and data alignment
                    /// Content updates dynamically based on test results
                    Text(cosmicValidationReport)
                        .font(.system(.caption, design: .monospaced))
                        .padding()
                }
                .navigationTitle("Cosmic Engine Validation")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        /// Claude: Sheet dismissal button
                        /// Provides clean exit from validation results view
                        Button("Done") {
                            showingCosmicValidation = false
                        }
                    }
                }
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    TestingView()
        .environmentObject(FocusNumberManager.shared)
        .environmentObject(RealmNumberManager())
}
