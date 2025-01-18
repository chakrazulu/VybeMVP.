//
//  FocusNumberHelper.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//

import Foundation
import CoreLocation

struct FocusNumberHelper {
    
    /// Calculates a single-digit "focus number" from the given date, coordinates, and BPM.
    static func calculateFocusNumber(date: Date, coordinates: CLLocationCoordinate2D, bpm: Int) -> Int {
        print("\n🔢 FOCUS NUMBER CALCULATION STARTED")
        print("----------------------------------------")
        
        // Extract date components
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        print("📅 Date Components:")
        print("   Year: \(components.year!)")
        print("   Month: \(components.month!)")
        print("   Day: \(components.day!)")
        print("   Military Time: \(String(format: "%02d%02d", components.hour!, components.minute!))")  // Shows as HHMM format
        
        // Break down the calculation step by step
        let dateOnlySum = components.year! + components.month! + components.day!
        let militaryTime = Int(String(format: "%02d%02d", components.hour!, components.minute!))!
        let timeDigits = String(militaryTime).compactMap { Int(String($0)) }
        let timeSum = timeDigits.reduce(0, +)
        let dateSum = dateOnlySum + timeSum
        
        print("📊 Sum Breakdown:")
        print("   Date Only: \(components.year!) + \(components.month!) + \(components.day!) = \(dateOnlySum)")
        print("   Time (Military \(militaryTime)): \(timeDigits.map(String.init).joined(separator: " + ")) = \(timeSum)")
        print("   Total Date+Time Sum: \(dateOnlySum) + \(timeSum) = \(dateSum)")
        
        // Process coordinates - using all digits
        let latitudeDigits = String(format: "%.4f", abs(coordinates.latitude))
            .replacingOccurrences(of: ".", with: "")
            .compactMap { Int(String($0)) }
        
        let longitudeDigits = String(format: "%.4f", abs(coordinates.longitude))
            .replacingOccurrences(of: ".", with: "")
            .compactMap { Int(String($0)) }
        
        print("\n📍 Location Components:")
        print("   Latitude: \(coordinates.latitude)")
        print("   → Digits: \(latitudeDigits.map(String.init).joined(separator: " "))")
        print("   Longitude: \(coordinates.longitude)")
        print("   → Digits: \(longitudeDigits.map(String.init).joined(separator: " "))")
        
        // Sum the coordinate digits
        let latSum = latitudeDigits.reduce(0, +)
        let longSum = longitudeDigits.reduce(0, +)
        
        // Combine all numbers
        let totalSum = dateSum + latSum + longSum + bpm
        print("\n🧮 Total Sum Calculation:")
        print("   Date Sum (\(dateSum)) + Latitude Sum (\(latSum)) + Longitude Sum (\(longSum)) + BPM (\(bpm)) = \(totalSum)")
        
        let finalNumber = reduceToSingleDigit(totalSum)
        print("\n✨ Final Number: \(finalNumber)")

        // Make zero to nine conversion more explicit
        if finalNumber == 0 {
            print("⚠️ Zero detected - converting to 9")
            print("   0 → 9")
        }

        let result = finalNumber == 0 ? 9 : finalNumber
        print("----------------------------------------")
        print("🎯 FINAL FOCUS NUMBER: \(result)\n")
        
        return result
    }
    
    /// Repeatedly sums the digits of an integer until it becomes a single digit (0–9).
    private static func reduceToSingleDigit(_ number: Int) -> Int {
        var num = abs(number)
        print("\n🔄 Reducing \(num) to single digit:")
        
        while num > 9 {
            let digits = String(num).compactMap { Int(String($0)) }
            print("   \(num) → \(digits.map(String.init).joined(separator: " + ")) = \(digits.reduce(0, +))")
            num = digits.reduce(0, +)
        }
        
        return num
    }
}
