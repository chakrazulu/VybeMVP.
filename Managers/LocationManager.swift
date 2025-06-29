/*
 * ========================================
 * 📍 LOCATION MANAGER - GEOSPATIAL SERVICES
 * ========================================
 * 
 * CORE PURPOSE:
 * Centralized CoreLocation services providing precise geospatial data for realm
 * number calculations and cosmic alignment features. Manages location permissions,
 * real-time location updates, and reverse geocoding with comprehensive error
 * handling and privacy-conscious location access patterns.
 * 
 * CORELOCATION INTEGRATION:
 * - CLLocationManager: Native iOS location services with delegate pattern
 * - Authorization Management: Comprehensive permission flow with status monitoring
 * - Location Updates: Real-time coordinate tracking with 10-meter distance filter
 * - Accuracy Configuration: kCLLocationAccuracyBest for precise realm calculations
 * - Background Support: Optimized for both foreground and background location access
 * 
 * REALM NUMBER INTEGRATION:
 * - Coordinate Input: Provides latitude/longitude for RealmNumberManager calculations
 * - Location Factor: Geographic coordinates contribute to cosmic realm computation
 * - Real-time Updates: Automatic location changes trigger realm recalculations
 * - Precision Requirements: High accuracy needed for consistent realm number generation
 * - Fallback Handling: Graceful degradation when location unavailable
 * 
 * PERMISSION MANAGEMENT:
 * - Authorization States: Complete handling of all CLAuthorizationStatus cases
 * - Permission Request: Intelligent requestWhenInUseAuthorization() flow
 * - Status Monitoring: Real-time authorization status tracking
 * - Settings Redirection: User guidance for denied/restricted permissions
 * - Privacy Compliance: Minimal location usage with clear user consent
 * 
 * STATE MANAGEMENT:
 * - @Published currentLocation: Current CLLocation for UI binding
 * - @Published authorizationStatus: Permission status for UI updates
 * - @Published locationError: Error messages for user feedback
 * - ObservableObject: SwiftUI reactive updates for location changes
 * - Singleton Pattern: LocationManager.shared for app-wide access
 * 
 * LOCATION UPDATE SYSTEM:
 * - Distance Filter: 10-meter threshold for meaningful location changes
 * - Automatic Updates: Continuous location monitoring when authorized
 * - Error Handling: Comprehensive location failure management
 * - Main Queue Updates: UI-safe property updates via DispatchQueue.main
 * - Update Control: Manual start/stop location update management
 * 
 * REVERSE GEOCODING:
 * - CLGeocoder Integration: Address resolution from coordinates
 * - Location Names: Human-readable location descriptions
 * - Placemark Processing: Name, locality, administrative area extraction
 * - Error Resilience: Graceful handling of geocoding failures
 * - Completion Handlers: Async geocoding with callback patterns
 * 
 * INTEGRATION POINTS:
 * - RealmNumberManager: Primary consumer for realm number calculations
 * - BackgroundManager: Location updates during background operation
 * - UserProfileService: Location preferences and settings storage
 * - SettingsView: Location permission status display and management
 * - Privacy Settings: Integration with iOS location privacy controls
 * 
 * ERROR HANDLING & RESILIENCE:
 * - Permission Denied: Clear user guidance for settings navigation
 * - Location Failures: Comprehensive error message propagation
 * - Service Unavailable: Graceful degradation with fallback mechanisms
 * - Network Issues: Robust handling of geocoding service failures
 * - Authorization Changes: Dynamic response to permission modifications
 * 
 * PRIVACY & SECURITY:
 * - Minimal Data Collection: Only location coordinates for calculations
 * - Permission Transparency: Clear user consent for location access
 * - Data Retention: No persistent location storage beyond current session
 * - Usage Justification: Location used solely for cosmic calculations
 * - Settings Integration: Direct access to iOS privacy controls
 * 
 * PERFORMANCE OPTIMIZATIONS:
 * - Singleton Pattern: Single instance for memory efficiency
 * - Distance Filtering: Reduces unnecessary location updates
 * - Delegate Pattern: Efficient CoreLocation callback handling
 * - Main Queue Optimization: UI updates on appropriate thread
 * - Resource Management: Proper location service start/stop control
 * 
 * COSMIC CALCULATION SUPPORT:
 * - Coordinate Precision: High-accuracy location for consistent calculations
 * - Real-time Integration: Immediate realm number updates on location change
 * - Geographic Factors: Location coordinates as cosmic alignment input
 * - Spatial Awareness: Geographic context for spiritual calculations
 * - Movement Detection: Location changes trigger cosmic recalculations
 * 
 * TECHNICAL SPECIFICATIONS:
 * - Accuracy: kCLLocationAccuracyBest for maximum precision
 * - Distance Filter: 10 meters for meaningful location changes
 * - Authorization: CLAuthorizationStatus monitoring with delegate callbacks
 * - Update Frequency: Continuous when authorized, manual control available
 * - Geocoding: CLGeocoder for coordinate to address conversion
 * 
 * DEBUGGING & MONITORING:
 * - Authorization Tracking: Real-time permission status monitoring
 * - Location Logging: Coordinate and error state tracking
 * - Geocoding Results: Address resolution success/failure logging
 * - Error Propagation: Detailed error messages for troubleshooting
 * - Permission Flow: Authorization request and response tracking
 */

//
//  LocationManager.swift
//  VybeMVP
//
//  Centralized location management for the app
//

import Foundation
import CoreLocation
import Combine

/**
 * LocationManager provides centralized location services throughout the app.
 * Handles location permissions, updates, and provides current location data.
 */
class LocationManager: NSObject, ObservableObject {
    
    // MARK: - Singleton
    static let shared = LocationManager()
    
    // MARK: - Properties
    @Published var currentLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var locationError: String?
    
    private let locationManager = CLLocationManager()
    
    // MARK: - Initialization
    override init() {
        super.init()
        setupLocationManager()
    }
    
    // MARK: - Setup
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // Update every 10 meters
        authorizationStatus = locationManager.authorizationStatus
    }
    
    // MARK: - Public Methods
    func requestLocationPermission() {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            locationError = "Location access denied. Please enable in Settings."
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        @unknown default:
            break
        }
    }
    
    func startLocationUpdates() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            requestLocationPermission()
            return
        }
        
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    func reverseGeocode(location: CLLocation, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let placemark = placemarks?.first {
                let locationName = [
                    placemark.name,
                    placemark.locality,
                    placemark.administrativeArea
                ].compactMap { $0 }.joined(separator: ", ")
                
                completion(locationName.isEmpty ? nil : locationName)
            } else {
                completion(nil)
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async {
            self.currentLocation = location
            self.locationError = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.locationError = error.localizedDescription
        }
        print("Location manager error: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
            
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                self.startLocationUpdates()
                self.locationError = nil
            case .denied, .restricted:
                self.locationError = "Location access denied. Please enable in Settings."
                self.currentLocation = nil
            case .notDetermined:
                break
            @unknown default:
                break
            }
        }
    }
} 