//
//  HomeView.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    @State private var showingPicker = false
    
    var body: some View {
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
        }
        .padding(.top, 50)
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
