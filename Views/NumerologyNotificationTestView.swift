/**
 * Filename: NumerologyNotificationTestView.swift
 *
 * Purpose: Provides a developer test UI for verifying numerology notification functionality.
 * This view allows developers to trigger various types of numerology notifications
 * to test the integration between the JSON data files and notification system.
 *
 * Key components:
 * - UI controls for testing different notification types
 * - Debug information display
 *
 * Dependencies: SwiftUI, Core/Utilities/NumerologyNotificationTester
 */

import SwiftUI

/**
 * A test view for numerology notifications
 *
 * This view provides a developer interface to test the numerology notification system.
 * It's intended for development and testing purposes only and would typically
 * not be accessible in the production app.
 */
struct NumerologyNotificationTestView: View {
    /// Access to the notification tester singleton
    @ObservedObject private var tester = NumerologyNotificationTester.shared

    /// Selected number for testing (0-9)
    @State private var selectedNumber = 7

    /// Selected category for testing
    @State private var selectedCategory = NumerologyCategory.insight

    /// Current focus number for testing
    @State private var focusNumber = FocusNumberManager.shared.selectedFocusNumber

    /// Whether to show advanced options
    @State private var showAdvancedOptions = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    Text("Numerology Notification Testing")
                        .font(.headline)
                        .padding(.horizontal)

                    // Basic test section
                    Section {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Basic Test")
                                .font(.subheadline)
                                .fontWeight(.medium)

                            HStack {
                                Text("Number:")
                                Picker("Number", selection: $selectedNumber) {
                                    ForEach(0...9, id: \.self) { number in
                                        Text("\(number)").tag(number)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(width: 80)

                                Spacer()

                                Text("Category:")
                                Picker("Category", selection: $selectedCategory) {
                                    ForEach(NumerologyCategory.allCases, id: \.self) { category in
                                        Text(category.displayName).tag(category)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(width: 150)
                            }

                            Button(action: {
                                tester.testNumerologyNotification(
                                    forNumber: selectedNumber,
                                    category: selectedCategory
                                )
                            }) {
                                HStack {
                                    Image(systemName: "bell.fill")
                                    Text("Test Single Notification")
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(.top, 8)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    // Advanced tests section
                    DisclosureGroup("Advanced Tests", isExpanded: $showAdvancedOptions) {
                        VStack(spacing: 16) {
                            // Test all numbers
                            Button(action: {
                                tester.testAllNumbers()
                            }) {
                                HStack {
                                    Image(systemName: "123.rectangle")
                                    Text("Test All Numbers (0-9)")
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)

                            // Test all categories for selected number
                            Button(action: {
                                tester.testAllCategories(forNumber: selectedNumber)
                            }) {
                                HStack {
                                    Image(systemName: "list.bullet")
                                    Text("Test All Categories for \(selectedNumber)")
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)

                            // Focus number section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Focus Number Tests")
                                    .font(.subheadline)
                                    .fontWeight(.medium)

                                HStack {
                                    Text("Focus Number:")
                                    Picker("Focus Number", selection: $focusNumber) {
                                        ForEach(1...9, id: \.self) { number in
                                            Text("\(number)").tag(number)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(width: 80)

                                    Spacer()

                                    Button(action: {
                                        FocusNumberManager.shared.setFocusNumber(focusNumber, sendNotification: true)
                                    }) {
                                        Text("Set & Notify")
                                    }
                                    .buttonStyle(.bordered)
                                }

                                Button(action: {
                                    tester.testDailyNumerologyMessage(forFocusNumber: focusNumber)
                                }) {
                                    HStack {
                                        Image(systemName: "calendar")
                                        Text("Test Daily Message")
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal)

                    // Test results section
                    if !tester.testResults.isEmpty {
                        Section {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Test Results")
                                    .font(.subheadline)
                                    .fontWeight(.medium)

                                Text(tester.testResults)
                                    .font(.system(.body, design: .monospaced))
                                    .padding()
                                    .background(Color.black.opacity(0.05))
                                    .cornerRadius(8)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }

                    Spacer()
                }
                .padding(.vertical)
            }
            .navigationTitle("Notification Test")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        tester.resetTestState()
                    }) {
                        Text("Reset")
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct NumerologyNotificationTestView_Previews: PreviewProvider {
    static var previews: some View {
        NumerologyNotificationTestView()
    }
}
