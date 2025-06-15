//
//  SightingsView.swift
//  VybeMVP
//
//  Main view for displaying and managing number sightings
//

import SwiftUI
import CoreLocation

struct SightingsView: View {
    @StateObject private var sightingsManager = SightingsManager.shared
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    @State private var showingNewSighting = false
    @State private var selectedSighting: Sighting?
    @State private var filterNumber: Int?
    @State private var animateIn = false
    
    var filteredSightings: [Sighting] {
        if let filter = filterNumber {
            return sightingsManager.sightings.filter { $0.numberSpotted == filter }
        }
        return sightingsManager.sightings
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Cosmic background
                CosmicBackgroundView()
                    .ignoresSafeArea()
                
                if sightingsManager.sightings.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Stats header
                            statsHeaderView
                            
                            // Filter chips
                            filterChipsView
                            
                            // Sightings list
                            sightingsListView
                        }
                        .padding()
                    }
                }
                
                // Floating action button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        floatingActionButton
                            .padding(.trailing, 20)
                            .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Sightings Portal")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        sightingsManager.loadSightings()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewSighting) {
            NewSightingView()
        }
        .sheet(item: $selectedSighting) { sighting in
            SightingDetailView(sighting: sighting)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                animateIn = true
            }
        }
    }
    
    // MARK: - View Components
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkle.magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.6))
            
            Text("No Sightings Yet")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Start capturing the magic!\nSpot your focus numbers in the wild.")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Button(action: {
                showingNewSighting = true
            }) {
                Text("Record First Sighting")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.purple, .blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
            }
            .padding(.top, 10)
        }
        .padding()
    }
    
    private var statsHeaderView: some View {
        HStack(spacing: 20) {
            StatCard(
                title: "Today",
                value: "\(sightingsManager.todaysSightingsCount)",
                icon: "sun.max.fill",
                color: .orange
            )
            
            StatCard(
                title: "Total",
                value: "\(sightingsManager.totalSightingsCount)",
                icon: "star.fill",
                color: .purple
            )
            
            if let topNumber = sightingsManager.mostFrequentNumbers(limit: 1).first {
                StatCard(
                    title: "Top #",
                    value: "\(topNumber.number)",
                    icon: "crown.fill",
                    color: .yellow
                )
            }
        }
        .scaleEffect(animateIn ? 1.0 : 0.8)
        .opacity(animateIn ? 1.0 : 0.0)
    }
    
    private var filterChipsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FilterChip(
                    title: "All",
                    isSelected: filterNumber == nil,
                    action: {
                        filterNumber = nil
                    }
                )
                
                ForEach(1...9, id: \.self) { number in
                    FilterChip(
                        title: "#\(number)",
                        isSelected: filterNumber == number,
                        color: getSacredColor(for: number),
                        action: {
                            filterNumber = filterNumber == number ? nil : number
                        }
                    )
                }
            }
        }
        .padding(.vertical, 5)
    }
    
    private var sightingsListView: some View {
        LazyVStack(spacing: 16) {
            ForEach(Array(filteredSightings.enumerated()), id: \.element.id) { index, sighting in
                SightingCard(sighting: sighting)
                    .onTapGesture {
                        selectedSighting = sighting
                    }
                    .scaleEffect(animateIn ? 1.0 : 0.8)
                    .opacity(animateIn ? 1.0 : 0.0)
                    .animation(
                        .easeOut(duration: 0.5)
                            .delay(Double(index) * 0.1),
                        value: animateIn
                    )
            }
        }
    }
    
    private var floatingActionButton: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            showingNewSighting = true
        }) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.purple, .blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 5)
                
                Image(systemName: "camera.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
        .scaleEffect(animateIn ? 1.0 : 0.0)
        .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.3), value: animateIn)
    }
    
    // MARK: - Helper Methods
    
    private func getSacredColor(for number: Int) -> Color {
        switch number {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        case 6: return .indigo
        case 7: return .purple
        case 8: return Color(red: 1.0, green: 0.8, blue: 0.0) // gold
        case 9: return .white
        default: return .gray
        }
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    var color: Color = .blue
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : .white.opacity(0.8))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? color.opacity(0.8) : Color.white.opacity(0.2))
                        .overlay(
                            Capsule()
                                .stroke(isSelected ? color : Color.white.opacity(0.3), lineWidth: 1)
                        )
                )
        }
    }
}

struct SightingCard: View {
    let sighting: Sighting
    
    private var sacredColor: Color {
        switch sighting.numberSpotted {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        case 6: return .indigo
        case 7: return .purple
        case 8: return Color(red: 1.0, green: 0.8, blue: 0.0)
        case 9: return .white
        default: return .gray
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Number badge
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                sacredColor.opacity(0.8),
                                sacredColor.opacity(0.4)
                            ]),
                            center: .center,
                            startRadius: 5,
                            endRadius: 25
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Text("\(sighting.numberSpotted)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(sighting.title ?? "Sighting")
                    .font(.headline)
                    .foregroundColor(.white)
                
                if let note = sighting.note, !note.isEmpty {
                    Text(note)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(2)
                }
                
                HStack(spacing: 12) {
                    if sighting.imageData != nil {
                        Label("Photo", systemImage: "camera.fill")
                            .font(.caption)
                            .foregroundColor(sacredColor.opacity(0.8))
                    }
                    
                    if let timestamp = sighting.timestamp {
                        Text(timestamp, style: .relative)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    if sighting.locationName != nil {
                        Label(sighting.locationName ?? "", systemImage: "location.fill")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                            .lineLimit(1)
                    }
                }
            }
            
            Spacer()
            
            // Arrow
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.white.opacity(0.5))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(sacredColor.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    SightingsView()
        .environmentObject(FocusNumberManager.shared)
} 