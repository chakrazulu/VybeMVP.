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
 * 2. Shows a beautifully styled "Today's Insight" section
 * 3. Shows a horizontal scrollable list of recent matches
 * 4. Provides quick access to change the focus number
 *
 * Design pattern: MVVM view component
 * Dependencies: FocusNumberManager for data
 */
import SwiftUI

struct HomeView: View {
    /// Access to the focus number manager for displaying the selected number and match history
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    @EnvironmentObject var realmNumberManager: RealmNumberManager
    @EnvironmentObject var signInViewModel: SignInViewModel
    @ObservedObject var aiInsightManager = AIInsightManager.shared
    
    /// Controls visibility of the focus number picker sheet
    @State private var showingPicker = false
    @State private var showingInsightHistory = false
    
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
                
                // Enhanced Today's Insight Section
                todaysInsightSection
                
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
        .sheet(isPresented: $showingInsightHistory) {
            InsightHistoryView()
        }
        .onAppear {
            focusNumberManager.loadMatchLogs()
        }
    }
    
    // MARK: - Today's Insight Section
    
    private var todaysInsightSection: some View {
        VStack(spacing: 20) {
            // Header with date
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Today's Insight")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(Date(), style: .date)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Button(action: {
                    showingInsightHistory = true
                }) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            // Insight Content
            VStack(spacing: 16) {
                if aiInsightManager.isInsightReady {
                    if let insight = aiInsightManager.personalizedDailyInsight {
                        Text(insight.text)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.leading)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        // Alignment context with beautiful styling
                        if let userID = signInViewModel.userID,
                           let userProfile = UserProfileService.shared.getCurrentUserProfileFromUserDefaults(for: userID) {
                            HStack(spacing: 8) {
                                Image(systemName: "sparkles")
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                                
                                Text("Aligned to your Life Path \(userProfile.lifePathNumber) & \(userProfile.spiritualMode) energy")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                    .italic()
                                
                                Spacer()
                            }
                            .padding(.top, 8)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.1))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "leaf.circle")
                                .font(.title)
                                .foregroundColor(.green.opacity(0.8))
                            
                            Text("Your personalized insight is growing...")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                            
                            Text("Return soon for your daily wisdom")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                                .italic()
                        }
                    }
                } else {
                    VStack(spacing: 12) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.2)
                        
                        Text("Cultivating your insight...")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.purple.opacity(0.8),
                    Color.indigo.opacity(0.6),
                    Color.blue.opacity(0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [.white.opacity(0.3), .purple.opacity(0.3)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .cornerRadius(16)
        .shadow(color: .purple.opacity(0.3), radius: 15, x: 0, y: 8)
        .padding(.horizontal)
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
