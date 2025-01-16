//
//  FocusNumberHelper.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//
import Foundation
import CoreLocation

struct FocusNumberHelper {
    static func calculateFocusNumber(date: Date, coordinates: CLLocationCoordinate2D, bpm: Int) -> Int {
        // Extract date components
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let year = components.year ?? 0
        let month = components.month ?? 0
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0

        // Debugging: Print extracted date components
        print("DEBUG: Date Components - Year: \(year), Month: \(month), Day: \(day), Hour: \(hour), Minute: \(minute)")

        // Process latitude and longitude as strings to extract individual digits (including decimals)
        let latitudeDigits = extractDigits(from: coordinates.latitude)
        let longitudeDigits = extractDigits(from: coordinates.longitude)

        // Debugging: Print extracted digits from coordinates
        print("DEBUG: Digits from Latitude (\(coordinates.latitude)): \(latitudeDigits)")
        print("DEBUG: Digits from Longitude (\(coordinates.longitude)): \(longitudeDigits)")

        // Combine all numbers
        var numbers = [year, month, day, hour, minute]
        numbers.append(contentsOf: latitudeDigits)
        numbers.append(contentsOf: longitudeDigits)
        numbers.append(bpm)

        // Debugging: Print combined numbers
        print("DEBUG: Combined Numbers Before Reduction: \(numbers)")

        // Reduce each number to a single digit
        let reducedNumbers = numbers.map { reduceToSingleDigit($0) }

        // Debugging: Print reduced numbers
        print("DEBUG: Reduced Numbers: \(reducedNumbers)")

        // Sum the reduced numbers
        let totalSum = reducedNumbers.reduce(0, +)

        // Debugging: Print total sum before reducing to single digit
        print("DEBUG: Total Sum Before Reduction: \(totalSum)")

        // Reduce the total sum to a single digit
        let focusNumber = reduceToSingleDigit(totalSum)

        // Debugging: Print the final focus number
        print("DEBUG: Final Focus Number: \(focusNumber)")

        return focusNumber
    }

    // Helper function to extract digits from a double (latitude or longitude)
    private static func extractDigits(from value: Double) -> [Int] {
        // Convert to string, remove the negative sign if present
        let numberString = String(value).replacingOccurrences(of: "-", with: "")
        // Extract individual digits
        let digits = numberString.compactMap { $0.wholeNumberValue }
        // Debugging: Log the digits extracted from the value
        print("DEBUG: Extracted Digits from \(value): \(digits)")
        return digits
    }

    // Helper function to reduce a number to a single digit
    private static func reduceToSingleDigit(_ number: Int) -> Int {
        var num = abs(number) // Ensure positive number
        while num >= 10 {
            num = String(num).compactMap { $0.wholeNumberValue }.reduce(0, +)
        }
        // Debugging: Log the reduced single digit
        print("DEBUG: Reduced to Single Digit: \(num)")
        return num
    }
}
