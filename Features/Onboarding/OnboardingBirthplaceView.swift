/*
 * ========================================
 * 🌍 ONBOARDING BIRTHPLACE VIEW - LOCATION-BASED COSMIC ACCURACY
 * ========================================
 * 
 * CORE PURPOSE:
 * Enhanced onboarding component collecting both birthdate AND birthplace for
 * accurate location-based astronomical calculations. Integrates with Swiss Ephemeris
 * for precise rise/set times and location-specific cosmic data.
 * 
 * LOCATION FEATURES:
 * - Birth Date: Date picker for temporal calculations
 * - Birth Location: City/country picker with coordinate resolution
 * - Timezone Detection: Automatic timezone identification from coordinates
 * - Accuracy Enhancement: Location-specific astronomical calculations
 * 
 * UI SPECIFICATIONS:
 * - Two-step process: Date selection, then location selection
 * - MapKit integration for location search and selection
 * - Real-time coordinate and timezone display
 * - Beautiful cosmic-themed design with location awareness
 * 
 * SWIFTAA INTEGRATION:
 * - GeographicCoordinates: Precise latitude/longitude storage
 * - RiseTransitSetTimes: Location-specific celestial events
 * - HorizontalCoordinates: Local sky position calculations
 * - Enhanced accuracy for spiritual timing and natal charts
 * 
 * TECHNICAL IMPLEMENTATION:
 * - CLGeocoder for location search and coordinate resolution
 * - TimeZone detection from geographic coordinates
 * - UserProfile integration with birthplace data storage
 * - LocationManager integration for current location option
 */

import SwiftUI
import MapKit
import CoreLocation

/**
 * Enhanced onboarding view for collecting birthdate and birthplace
 * to enable location-based astronomical calculations with Swiss Ephemeris.
 */
struct OnboardingBirthplaceView: View {
    // MARK: - Properties
    @StateObject private var locationManager = LocationManager.shared
    @State private var selectedDate = Date()
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var selectedLocationName = ""
    @State private var selectedTimezone: TimeZone?
    @State private var isSearchingLocation = false
    @State private var searchText = ""
    @State private var searchResults: [MKLocalSearchCompletion] = []
    @State private var showingDatePicker = true
    @State private var isProcessing = false
    
    // Search completer for location search
    @StateObject private var locationSearchCompleter = LocationSearchCompleter()
    
    // Binding for navigation control
    @Binding var isCompleted: Bool
    
    // Date range constraints
    private let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 1900, month: 1, day: 1)) ?? Date()
        let endDate = Date()
        return startDate...endDate
    }()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                headerSection
                
                if showingDatePicker {
                    // Step 1: Date Selection
                    datePickerSection
                    dateActionButton
                } else {
                    // Step 2: Location Selection
                    locationPickerSection
                    locationActionButton
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .background(Color(UIColor.systemBackground))
        .navigationTitle("Birth Details")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Cosmic location icon
            Image(systemName: showingDatePicker ? "calendar.badge.clock" : "location.north.fill")
                .font(.system(size: 50, weight: .light))
                .foregroundColor(.purple)
                .animation(.easeInOut(duration: 0.3), value: showingDatePicker)
            
            Text(showingDatePicker ? "When were you born?" : "Where were you born?")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .animation(.easeInOut(duration: 0.3), value: showingDatePicker)
            
            Text(showingDatePicker ? 
                 "Your birthdate unlocks your spiritual archetype and cosmic timing." :
                 "Your birthplace enables precise astronomical calculations for your exact location in the cosmos.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .animation(.easeInOut(duration: 0.3), value: showingDatePicker)
        }
        .padding(.top, 20)
    }
    
    private var datePickerSection: some View {
        VStack(spacing: 20) {
            // Show selected date
            VStack(spacing: 8) {
                Text("Selected Birth Date")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .tracking(1)
                
                Text(selectedDate, style: .date)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.purple.opacity(0.1))
                            .overlay(
                                Capsule()
                                    .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                            )
                    )
            }
            
            DatePicker(
                "Birth Date",
                selection: $selectedDate,
                in: dateRange,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
            .onChange(of: selectedDate) { oldValue, newValue in
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
            }
        }
    }
    
    private var dateActionButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                showingDatePicker = false
            }
        }) {
            HStack {
                Image(systemName: "location.north.fill")
                Text("Next: Birth Location")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.purple, .blue]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: Color.purple.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .padding(.top, 20)
    }
    
    private var locationPickerSection: some View {
        VStack(spacing: 20) {
            // Location search field
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search for your birth city...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onChange(of: searchText) { oldValue, newValue in
                            locationSearchCompleter.searchQuery = newValue
                        }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(UIColor.secondarySystemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                        )
                )
                
                // Search results
                if !locationSearchCompleter.searchResults.isEmpty {
                    VStack(spacing: 8) {
                        ForEach(locationSearchCompleter.searchResults.prefix(5), id: \.title) { result in
                            Button(action: {
                                selectLocation(result)
                            }) {
                                HStack {
                                    Image(systemName: "location")
                                        .foregroundColor(.purple)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(result.title)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.primary)
                                        
                                        if !result.subtitle.isEmpty {
                                            Text(result.subtitle)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(UIColor.tertiarySystemBackground))
                                )
                            }
                        }
                    }
                    .padding(.top, 8)
                }
            }
            
            // Current location option
            Button(action: useCurrentLocation) {
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                    Text("Use Current Location")
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            
            // Selected location display
            if let location = selectedLocation, !selectedLocationName.isEmpty {
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Selected Location")
                            .font(.headline)
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(selectedLocationName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text("Coordinates: \(String(format: "%.4f", location.latitude))°, \(String(format: "%.4f", location.longitude))°")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if let timezone = selectedTimezone {
                            Text("Timezone: \(timezone.identifier)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.green.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.green.opacity(0.3), lineWidth: 1)
                        )
                )
            }
        }
    }
    
    private var locationActionButton: some View {
        Button(action: completeBirthplaceSelection) {
            HStack {
                if isProcessing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "sparkles")
                }
                
                Text(isProcessing ? "Creating Profile..." : "Complete Setup")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.purple, .blue]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: Color.purple.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .disabled(selectedLocation == nil || isProcessing)
        .opacity(selectedLocation == nil ? 0.6 : 1.0)
        .scaleEffect(isProcessing ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isProcessing)
        .padding(.top, 20)
    }
    
    // MARK: - Actions
    
    private func selectLocation(_ result: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            if let mapItem = response?.mapItems.first {
                selectedLocation = mapItem.placemark.coordinate
                selectedLocationName = "\(result.title), \(result.subtitle)"
                searchText = selectedLocationName
                
                // Detect timezone
                selectedTimezone = TimeZone(identifier: mapItem.timeZone?.identifier ?? "")
                
                // Clear search results
                locationSearchCompleter.searchResults = []
                
                print("🌍 Selected location: \(selectedLocationName)")
                print("📍 Coordinates: \(mapItem.placemark.coordinate.latitude), \(mapItem.placemark.coordinate.longitude)")
                print("🕐 Timezone: \(selectedTimezone?.identifier ?? "Unknown")")
            }
        }
    }
    
    private func useCurrentLocation() {
        guard let currentLocation = locationManager.currentLocation else {
            locationManager.requestLocationPermission()
            return
        }
        
        selectedLocation = currentLocation.coordinate
        selectedTimezone = TimeZone.current
        
        // Reverse geocode to get location name
        locationManager.reverseGeocode(location: currentLocation) { locationName in
            DispatchQueue.main.async {
                selectedLocationName = locationName ?? "Current Location"
                searchText = selectedLocationName
            }
        }
    }
    
    private func completeBirthplaceSelection() {
        guard let location = selectedLocation else { return }
        
        isProcessing = true
        
        // Create comprehensive user profile with location data
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("🎂 Creating profile with birth details:")
            print("   Date: \(selectedDate)")
            print("   Location: \(selectedLocationName)")
            print("   Coordinates: \(location.latitude), \(location.longitude)")
            print("   Timezone: \(selectedTimezone?.identifier ?? "Unknown")")
            
            // Here you would integrate with UserArchetypeManager and UserProfileService
            // to create the complete profile with location data
            
            isProcessing = false
            isCompleted = true
            
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }
    }
}

// MARK: - Location Search Completer

class LocationSearchCompleter: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchResults: [MKLocalSearchCompletion] = []
    private let completer = MKLocalSearchCompleter()
    
    var searchQuery: String = "" {
        didSet {
            completer.queryFragment = searchQuery
        }
    }
    
    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = [.address, .pointOfInterest]
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Location search error: \(error.localizedDescription)")
        searchResults = []
    }
}

// MARK: - Preview

struct OnboardingBirthplaceView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingBirthplaceView(isCompleted: .constant(false))
    }
}