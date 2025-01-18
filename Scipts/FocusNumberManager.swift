import Foundation
import Combine
import CoreLocation

class FocusNumberManager: ObservableObject {
    @Published var currentFocusNumber: Int = 1
    @Published var userFocusNumber: Int = 0
    @Published var matchLogs: [String] = []
    
    private var timer: AnyCancellable?
    private let mockLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    private let mockBPM: Int = 70
    
    private var isTimerActive: Bool {
        timer != nil
    }
    
    func startUpdates() {
        stopUpdates()
        print("\n⏱️ TIMER SYSTEM")
        print("----------------------------------------")
        print("Starting new timer cycle")
        
        timer = Timer.publish(every: 10, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                print("\n⏰ TIMER FIRED")
                print("----------------------------------------")
                self?.updateFocusNumber()
            }
        
        print("Initial focus number calculation")
        updateFocusNumber() // Initial update
        print("----------------------------------------\n")
    }
    
    func stopUpdates() {
        timer?.cancel()
        timer = nil
        print("Timer stopped")
    }
    
    func updateFocusNumber() {
        print("\n📱 FOCUS NUMBER UPDATE TRIGGERED")
        print("========================================")
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .medium
        print("⏰ Current Time: \(dateFormatter.string(from: now))")
        print("📍 Using Location: \(mockLocation.latitude), \(mockLocation.longitude)")
        print("💓 Current BPM: \(mockBPM)")
        
        let newNumber = FocusNumberHelper.calculateFocusNumber(
            date: now,
            coordinates: mockLocation,
            bpm: mockBPM
        )
        
        print("\n📊 Focus Number Update:")
        print("   Previous: \(currentFocusNumber) → New: \(newNumber)")
        
        currentFocusNumber = newNumber
        checkMatch()
        
        print("========================================\n")
    }
    
    func userDidPickFocusNumber(_ number: Int) {
        print("\n👤 USER SELECTED NEW FOCUS NUMBER")
        print("----------------------------------------")
        print("Previous: \(userFocusNumber) → New: \(number)")
        
        userFocusNumber = number
        checkMatch()
        print("----------------------------------------\n")
    }
    
    func enableAutoFocusNumber() {
        print("\n🎯 AUTO FOCUS NUMBER ENABLED")
        print("----------------------------------------")
        print("Starting automatic updates")
        startUpdates()
        print("System ready for automatic updates")
        print("----------------------------------------\n")
    }
    
    private func checkMatch() {
        print("🎯 Checking for match:")
        print("   Current Focus Number: \(currentFocusNumber)")
        print("   User's Focus Number: \(userFocusNumber)")
        
        if currentFocusNumber == userFocusNumber {
            print("✨ MATCH FOUND!")
            let log = "Matched \(currentFocusNumber) at \(formattedTime())"
            matchLogs.append(log)
        } else {
            print("❌ No match")
        }
    }
    
    private func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
    
    func checkTimerStatus() {
        print("\n🔍 TIMER STATUS CHECK")
        print("----------------------------------------")
        print("Timer Active: \(isTimerActive)")
        if isTimerActive {
            print("Timer is running - Updates will occur every 60 seconds")
        } else {
            print("Timer is stopped - No automatic updates")
        }
        print("----------------------------------------\n")
    }
}
