//
//  MainView.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//
import SwiftUI
import CoreLocation

struct MainView: View, Hashable, Equatable {
    // MARK: - Equatable and Hashable Conformance
    static func == (lhs: MainView, rhs: MainView) -> Bool {
        return true
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine("MainView")
    }

    // MARK: - State Properties
    @State private var focusNumber: Int = 0 // Placeholder for the focus number
    @State private var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0) // Mock location
    @State private var bpm: Int = 70 // Mock BPM value for now

    // MARK: - Body
    var body: some View {
        TabView {
            // Home Tab
            VStack {
                Text("Welcome to Vybe")
                    .font(.largeTitle)
                    .padding()

                Text("Your Focus Number: \(focusNumber)")
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding()

                Button(action: {
                    calculateFocusNumber()
                }) {
                    Text("Recalculate Focus Number")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            // Profile Tab
            VStack {
                Text("Profile")
                    .font(.largeTitle)
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }

            // Settings Tab
            VStack {
                Text("Settings")
                    .font(.largeTitle)
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
        }
        .onAppear {
            debugLogInfo() // Debugging info for console
            getCurrentLocation()
            calculateFocusNumber()
        }
    }

    // MARK: - Functions
    private func calculateFocusNumber() {
        let currentDate = Date()
        focusNumber = FocusNumberHelper.calculateFocusNumber(date: currentDate, coordinates: currentLocation, bpm: bpm)
        debugLogInfo()
    }

    private func getCurrentLocation() {
        // Placeholder: Mock location
        currentLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // San Francisco coordinates
    }

    private func debugLogInfo() {
        print("DEBUG: Current Date: \(Date())")
        print("DEBUG: Current Location: \(currentLocation.latitude), \(currentLocation.longitude)")
        print("DEBUG: BPM: \(bpm)")
        print("DEBUG: Calculated Focus Number: \(focusNumber)")
    }
}
