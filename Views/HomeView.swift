//
//  HomeView.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//

/**
 * HomeView: The primary landing screen of the application.
 *
 * Purpose: 
 * Provides a visual dashboard that displays the user's selected focus number and recent matches.
 * Serves as the central hub that users return to after navigating through other sections.
 *
 * Key features:
 * 1. Prominently displays the user's current focus number
 * 2. Shows a horizontal scrollable list of recent matches
 * 3. Provides quick access to change the focus number
 *
 * Design pattern: MVVM view component
 * Dependencies: FocusNumberManager for data
 */
import SwiftUI

struct HomeView: View {
    /// Access to the focus number manager for displaying the selected number and match history
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    
    /// Controls visibility of the focus number picker sheet
    @State private var showingPicker = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Vybe")
                    .font(.system(size: 40, weight: .bold))
                
                Text("Your Focus Number")
                    .font(.title)
                
                // Focus Number Display
                ZStack {
                    Circle()
                        .fill(Color.purple.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Text("\(focusNumberManager.selectedFocusNumber)")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.purple)
                }
                
                // Recent Matches Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Recent Matches")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if focusNumberManager.matchLogs.isEmpty {
                        Text("No matches yet")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(Array(focusNumberManager.matchLogs.prefix(5).enumerated()), id: \.offset) { index, match in
                                    VStack {
                                        Text("#\(match.matchedNumber)")
                                            .font(.title2)
                                            .bold()
                                        Text(match.timestamp, style: .time)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .background(Color.purple.opacity(0.1))
                                    .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                Spacer()
                
                // Change Number Button
                Button("Change Number") {
                    showingPicker = true
                }
                .font(.headline)
                .foregroundColor(.blue)
                .padding(.bottom, 20)
            }
            .padding(.top, 50)
        }
        .sheet(isPresented: $showingPicker) {
            FocusNumberPicker()
        }
        .onAppear {
            focusNumberManager.loadMatchLogs()
        }
    }
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(FocusNumberManager.shared)
    }
}
