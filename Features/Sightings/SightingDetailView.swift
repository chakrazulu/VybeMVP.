//
//  SightingDetailView.swift
//  VybeMVP
//
//  Detail view for displaying a single sighting with all its information
//

import SwiftUI
import MapKit
import CoreLocation

struct SightingDetailView: View {
    let sighting: Sighting
    @Environment(\.dismiss) private var dismiss
    @StateObject private var sightingsManager = SightingsManager.shared
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var showingShareSheet = false
    @State private var cameraPosition = MapCameraPosition.automatic
    @State private var animateIn = false

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

    private var hasLocation: Bool {
        sighting.locationLatitude != 0 && sighting.locationLongitude != 0
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Cosmic background
                CosmicBackgroundView()
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 25) {
                        // Number header
                        numberHeaderSection

                        // Photo section
                        if sighting.imageData != nil {
                            photoSection
                        }

                        // Details section
                        detailsSection

                        // Location section
                        if hasLocation {
                            locationSection
                        }

                        // Metadata section
                        metadataSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Sighting Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            showingShareSheet = true
                        }) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }

                        Button(action: {
                            showingEditSheet = true
                        }) {
                            Label("Edit", systemImage: "pencil")
                        }

                        Button(role: .destructive, action: {
                            showingDeleteAlert = true
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear {
            setupMapCamera()
            withAnimation(.easeOut(duration: 0.5)) {
                animateIn = true
            }
        }
        .alert("Delete Sighting?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                deleteSighting()
            }
        } message: {
            Text("This action cannot be undone.")
        }
        .sheet(isPresented: $showingShareSheet) {
            if let image = sightingsManager.getImage(for: sighting) {
                ShareSheet(items: [image, generateShareText()])
            } else {
                ShareSheet(items: [generateShareText()])
            }
        }
    }

    // MARK: - View Sections

    private var numberHeaderSection: some View {
        VStack(spacing: 20) {
            // Large number display
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                sacredColor.opacity(0.8),
                                sacredColor.opacity(0.4),
                                Color.black.opacity(0.2)
                            ]),
                            center: .center,
                            startRadius: 20,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .shadow(color: sacredColor.opacity(0.6), radius: 20, x: 0, y: 10)
                    .overlay(
                        Circle()
                            .stroke(sacredColor, lineWidth: 2)
                    )

                Text("\(sighting.numberSpotted)")
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
            }
            .scaleEffect(animateIn ? 1.0 : 0.5)
            .opacity(animateIn ? 1.0 : 0.0)

            // Title
            Text(sighting.title ?? "Number \(sighting.numberSpotted) Sighting")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }

    private var photoSection: some View {
        VStack(spacing: 15) {
            if let image = sightingsManager.getImage(for: sighting) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 400)
                    .cornerRadius(20)
                    .shadow(color: sacredColor.opacity(0.3), radius: 10, x: 0, y: 5)
                    .onTapGesture {
                        // Could implement full screen photo viewer
                    }
            }
        }
        .padding(.horizontal)
    }

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let note = sighting.note, !note.isEmpty {
                DetailCard(
                    icon: "note.text",
                    title: "Note",
                    content: note,
                    color: sacredColor
                )
            }

            if let significance = sighting.significance, !significance.isEmpty {
                DetailCard(
                    icon: "sparkles",
                    title: "Significance",
                    content: significance,
                    color: .purple
                )
            }
        }
    }

    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(sacredColor)
                Text("Location")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }

            if let locationName = sighting.locationName {
                Text(locationName)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, 5)
            }

            // Updated Map view for iOS 17+
            Map(position: $cameraPosition) {
                Annotation("Number \(sighting.numberSpotted)",
                          coordinate: CLLocationCoordinate2D(
                            latitude: sighting.locationLatitude,
                            longitude: sighting.locationLongitude
                          )) {
                    ZStack {
                        Circle()
                            .fill(sacredColor)
                            .frame(width: 30, height: 30)
                        Text("\(sighting.numberSpotted)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(height: 200)
            .cornerRadius(15)
            .disabled(true) // Disable interaction for detail view
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private var metadataSection: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.white.opacity(0.6))
                Text("Spotted on")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                Spacer()
                Text(formatDate(sighting.timestamp ?? Date()))
                    .font(.subheadline)
                    .foregroundColor(.white)
            }

            if sighting.locationLatitude != 0 || sighting.locationLongitude != 0 {
                HStack {
                    Image(systemName: "location")
                        .foregroundColor(.white.opacity(0.6))
                    Text("Coordinates")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    Spacer()
                    Text("\(String(format: "%.4f", sighting.locationLatitude)), \(String(format: "%.4f", sighting.locationLongitude))")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }

    // MARK: - Helper Methods

    private func setupMapCamera() {
        if hasLocation {
            let coordinate = CLLocationCoordinate2D(
                latitude: sighting.locationLatitude,
                longitude: sighting.locationLongitude
            )
            cameraPosition = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            )
        }
    }

    private func deleteSighting() {
        sightingsManager.deleteSighting(sighting)
        dismiss()
    }

    private func generateShareText() -> String {
        var shareText = "I spotted the number \(sighting.numberSpotted)"

        if let title = sighting.title, !title.isEmpty {
            shareText += " - \(title)"
        }

        if let note = sighting.note, !note.isEmpty {
            shareText += "\n\n\(note)"
        }

        shareText += "\n\nShared from VybeMVP ✨"
        return shareText
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Supporting Views

struct DetailCard: View {
    let icon: String
    let title: String
    let content: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }

            Text(content)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
        }
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

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Preview

struct SightingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample sighting for preview
        let context = PersistenceController.preview.container.viewContext
        let sighting = Sighting(context: context)
        sighting.id = UUID()
        sighting.numberSpotted = 7
        sighting.title = "Lucky Number Seven"
        sighting.note = "Saw this on a license plate right when I was thinking about my career goals!"
        sighting.significance = "This felt like a sign about my upcoming job interview"
        sighting.timestamp = Date()
        sighting.locationLatitude = 37.7749
        sighting.locationLongitude = -122.4194
        sighting.locationName = "San Francisco, CA"

        return SightingDetailView(sighting: sighting)
            .environment(\.managedObjectContext, context)
    }
}
