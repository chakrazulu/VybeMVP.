//
//  SightingsView.swift
//  VybeMVP
//
//  Main view for displaying number sightings with filtering and statistics
//

import SwiftUI
import CoreData

struct SightingsView: View {
    @StateObject private var sightingsManager = SightingsManager.shared
    @State private var showingNewSighting = false
    @State private var selectedFilter: SightingFilter = .all
    @State private var animateIn = false

    private enum SightingFilter: String, CaseIterable {
        case all = "All"
        case recent = "Recent"
        case favorites = "Favorites"

        var filterDescription: String {
            switch self {
            case .all: return "All sightings"
            case .recent: return "Past 7 days"
            case .favorites: return "With photos"
            }
        }
    }

    private var filteredSightings: [Sighting] {
        let allSightings = sightingsManager.sightings

        switch selectedFilter {
        case .all:
            return allSightings
        case .recent:
            let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
            return allSightings.filter { sighting in
                sighting.timestamp ?? Date() >= weekAgo
            }
        case .favorites:
            return allSightings.filter { $0.imageData != nil }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Cosmic background
                CosmicBackgroundView()
                    .ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: 25) {
                        // Statistics section
                        statisticsSection

                        // Filter section
                        filterSection

                        // Sightings list
                        sightingsSection
                    }
                    .padding()
                }

                // Floating action button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        newSightingButton
                            .padding(.trailing, 25)
                            .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("Sightings Portal")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                // PERFORMANCE FIX: Defer heavy operations to prevent tab loading delays

                // Start animations immediately (lightweight)
                withAnimation(.easeOut(duration: 0.8)) {
                    animateIn = true
                }

                // Defer sightings loading by 0.8 seconds to prevent blocking
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    sightingsManager.loadSightings()
                    print("⚡ SightingsView: Sightings loading deferred for performance")
                }
            }
        }
        .sheet(isPresented: $showingNewSighting) {
            NewSightingView()
        }
    }

    // MARK: - View Sections

    private var statisticsSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Your Journey")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
            }

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                StatCard(
                    title: "Total Sightings",
                    value: "\(sightingsManager.sightings.count)",
                    icon: "eye.fill",
                    color: .blue
                )

                StatCard(
                    title: "This Week",
                    value: "\(getWeeklyCount())",
                    icon: "calendar.circle.fill",
                    color: .green
                )

                StatCard(
                    title: "With Photos",
                    value: "\(getPhotoCount())",
                    icon: "camera.fill",
                    color: .purple
                )
            }
        }
        .scaleEffect(animateIn ? 1.0 : 0.8)
        .opacity(animateIn ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.6).delay(0.2), value: animateIn)
    }

    private var filterSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Filter Sightings")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(SightingFilter.allCases, id: \.self) { filter in
                        FilterChip(
                            title: filter.rawValue,
                            isSelected: selectedFilter == filter,
                            color: .purple,
                            action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedFilter = filter
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 5)
            }
        }
        .scaleEffect(animateIn ? 1.0 : 0.8)
        .opacity(animateIn ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.6).delay(0.4), value: animateIn)
    }

    private var sightingsSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text(selectedFilter.filterDescription)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text("\(filteredSightings.count) sightings")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }

            if filteredSightings.isEmpty {
                emptyStateView
            } else {
                LazyVStack(spacing: 15) {
                    ForEach(filteredSightings, id: \.id) { sighting in
                        NavigationLink(destination: SightingDetailView(sighting: sighting)) {
                            SightingCard(sighting: sighting)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .scaleEffect(animateIn ? 1.0 : 0.8)
        .opacity(animateIn ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.6).delay(0.6), value: animateIn)
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "eye.slash")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.4))

            Text("No sightings yet")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Text("Start capturing the synchronicities around you")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)

            Button(action: {
                showingNewSighting = true
            }) {
                Text("Record Your First Sighting")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.purple, .blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(15)
            }
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private var newSightingButton: some View {
        VStack(spacing: 8) {
            Button(action: {
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
                        .frame(width: 66, height: 66)
                        .shadow(color: .purple.opacity(0.5), radius: 15, x: 0, y: 8)

                    Image(systemName: "plus")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }

            Text("Add Sighting")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
        }
        .scaleEffect(animateIn ? 1.0 : 0.0)
        .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.3), value: animateIn)
    }

    // MARK: - Helper Methods

    private func getWeeklyCount() -> Int {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return sightingsManager.sightings.filter { sighting in
            sighting.timestamp ?? Date() >= weekAgo
        }.count
    }

    private func getPhotoCount() -> Int {
        return sightingsManager.sightings.filter { $0.imageData != nil }.count
    }

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
