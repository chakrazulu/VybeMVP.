/*
 * ========================================
 * 🎯 FOCUS NUMBER CONTENT - FOCUS NUMBER MANAGEMENT INTERFACE
 * ========================================
 * 
 * CORE PURPOSE:
 * Main interface for managing the user's focus number, including display,
 * selection, auto-update settings, and match history. Provides a comprehensive
 * view of the user's spiritual focus and cosmic alignment tracking.
 * 
 * SCREEN LAYOUT (iPhone 14 Pro Max: 430×932 points):
 * • NavigationView: Standard iOS navigation with "Vybe" title
 * • VStack: Main content container with 20pt spacing
 * • Focus Number Display: Large circular display with purple styling
 * • Auto-Update Toggle: System toggle for automatic updates
 * • Match Logs: Conditional list of recent cosmic matches
 * • Toolbar: "Change Number" button for focus number selection
 * 
 * UI COMPONENTS:
 * • Focus Number Circle: 120×120pt circle with 60pt bold rounded font
 * • Auto-Update Toggle: System toggle with change logging
 * • Match Logs List: Conditional display of recent matches
 * • Focus Number Picker: Modal sheet for number selection
 * 
 * STYLING:
 * • Purple color scheme for focus number display
 * • Circle background with opacity and shadow
 * • System fonts and standard iOS styling
 * • Conditional content based on match history
 * 
 * STATE MANAGEMENT:
 * • focusNumberManager: Environment object for focus number state
 * • showingPicker: Boolean for modal presentation
 * • Reactive updates based on manager state changes
 * 
 * INTEGRATION POINTS:
 * • FocusNumberManager: Primary data source and state management
 * • FocusNumberPicker: Modal interface for number selection
 * • Match logging system: Displays recent cosmic matches
 * • Auto-update system: Controls automatic focus number updates
 * 
 * USER INTERACTIONS:
 * • Focus number display: Read-only display of current selection
 * • Auto-update toggle: Enables/disables automatic updates
 * • Change Number button: Opens modal picker
 * • Match history: Scrollable list of recent matches
 */

import SwiftUI

/**
 * FocusNumberContent: Main interface for focus number management and display
 * 
 * Provides a comprehensive view of the user's spiritual focus number,
 * including selection, settings, and cosmic match history tracking.
 */
struct FocusNumberContent: View {
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    @State private var showingPicker = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // MARK: - Focus Number Display Section
                VStack {
                    Text("Your Focus Number")
                        .font(.title)
                        .padding()
                    
                    Text("\(focusNumberManager.selectedFocusNumber)")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(.purple)
                        .frame(width: 120, height: 120)
                        .background(Circle().fill(Color.purple.opacity(0.2)))
                        .shadow(radius: 5)
                }
                
                // MARK: - Auto-Update Settings Section
                Toggle("Auto Update", isOn: $focusNumberManager.isAutoUpdateEnabled)
                    .padding()
                    .onChange(of: focusNumberManager.isAutoUpdateEnabled) { _, newValue in
                        // Log the change or handle persistence if needed
                        print("Auto Update Toggled: \(newValue)")
                    }
                
                // MARK: - Match History Section
                if !focusNumberManager.matchLogs.isEmpty {
                    Section(header: Text("Recent Matches")) {
                        List(focusNumberManager.matchLogs, id: \.timestamp) { match in
                            VStack(alignment: .leading) {
                                Text("Match! Number \(match.matchedNumber)")
                                    .font(.headline)
                                Text(match.timestamp, style: .date)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Vybe")
            .toolbar {
                Button("Change Number") {
                    showingPicker = true
                }
            }
            .sheet(isPresented: $showingPicker) {
                FocusNumberPicker()
            }
        }
    }
} 