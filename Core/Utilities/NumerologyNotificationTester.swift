/**
 * Filename: NumerologyNotificationTester.swift
 * 
 * Purpose: Provides utility methods for testing the numerology notification system
 * during development. This allows developers to trigger different types of
 * numerology notifications to verify the integration works correctly.
 *
 * Key features:
 * - Test methods for different notification types
 * - Debug information for notification content
 *
 * Dependencies: Foundation, SwiftUI
 */

import Foundation
import SwiftUI

/**
 * A utility class for testing numerology notifications
 *
 * This class provides methods to test the integration between the numerology
 * JSON data files and the notification system. It's intended for development
 * and testing purposes only.
 */
class NumerologyNotificationTester: ObservableObject {
    /// Shared singleton instance
    static let shared = NumerologyNotificationTester()
    
    /// Flag to track if test notifications have been sent
    @Published var testNotificationsSent = false
    
    /// Last test results
    @Published var testResults: String = ""
    
    /// Private initializer to enforce singleton pattern
    private init() {}
    
    /**
     * Tests sending a notification for a specific number and category
     *
     * @param number The numerology number (0-9) to test
     * @param category The category of message to send
     */
    func testNumerologyNotification(forNumber number: Int, category: NumerologyCategory) {
        // Reset test results
        testResults = "Starting test for number \(number), category \(category.rawValue)...\n"
        
        // Check if notifications are authorized
        if !NotificationManager.shared.notificationsAuthorized {
            testResults += "⚠️ Notifications are not authorized. Test may fail.\n"
        }
        
        // Check if messages for this number and category exist
        let messages = NumerologyMessageManager.shared.getMessages(forNumber: number, category: category)
        if messages.isEmpty {
            testResults += "⚠️ No messages found for number \(number), category \(category.rawValue)\n"
        } else {
            testResults += "✅ Found \(messages.count) messages for number \(number), category \(category.rawValue)\n"
        }
        
        // Schedule the test notification
        NotificationManager.shared.scheduleNumerologyNotification(
            forNumber: number,
            category: category,
            delaySeconds: 2
        )
        
        testResults += "📱 Notification scheduled to appear in 2 seconds\n"
        testNotificationsSent = true
    }
    
    /**
     * Tests sending a random numerology notification for each number (0-9)
     *
     * This method schedules 10 notifications, one for each number 0-9,
     * with a delay between each to avoid overwhelming the user.
     */
    func testAllNumbers() {
        // Reset test results
        testResults = "Starting test for all numbers (0-9)...\n"
        
        // Check if notifications are authorized
        if !NotificationManager.shared.notificationsAuthorized {
            testResults += "⚠️ Notifications are not authorized. Test may fail.\n"
        }
        
        // Schedule a notification for each number with increasing delays
        for number in 0...9 {
            // Get a random category for variety
            guard let randomCategory = NumerologyCategory.allCases.randomElement() else {
                continue
            }
            
            // Schedule with increasing delays to see each notification
            let delay = TimeInterval(number * 3 + 2) // 2, 5, 8, 11, 14, 17, 20, 23, 26, 29 seconds
            
            NotificationManager.shared.scheduleNumerologyNotification(
                forNumber: number,
                category: randomCategory,
                delaySeconds: delay
            )
            
            testResults += "📱 Scheduled notification for number \(number), category \(randomCategory.rawValue) with \(delay)s delay\n"
        }
        
        testResults += "✅ All test notifications scheduled\n"
        testNotificationsSent = true
    }
    
    /**
     * Tests sending notifications for all categories using a specific number
     *
     * @param number The numerology number to use for all category tests
     */
    func testAllCategories(forNumber number: Int) {
        // Reset test results
        testResults = "Starting test for all categories using number \(number)...\n"
        
        // Check if notifications are authorized
        if !NotificationManager.shared.notificationsAuthorized {
            testResults += "⚠️ Notifications are not authorized. Test may fail.\n"
        }
        
        // Schedule a notification for each category with increasing delays
        for (index, category) in NumerologyCategory.allCases.enumerated() {
            // Schedule with increasing delays to see each notification
            let delay = TimeInterval(index * 3 + 2) // 2, 5, 8, 11, ... seconds
            
            NotificationManager.shared.scheduleNumerologyNotification(
                forNumber: number,
                category: category,
                delaySeconds: delay
            )
            
            testResults += "📱 Scheduled notification for category \(category.rawValue) with \(delay)s delay\n"
        }
        
        testResults += "✅ All category test notifications scheduled\n"
        testNotificationsSent = true
    }
    
    /**
     * Tests the daily numerology message feature
     *
     * @param focusNumber The focus number to use for the test
     */
    func testDailyNumerologyMessage(forFocusNumber focusNumber: Int) {
        // Reset test results
        testResults = "Testing daily numerology message for focus number \(focusNumber)...\n"
        
        // Check if notifications are authorized
        if !NotificationManager.shared.notificationsAuthorized {
            testResults += "⚠️ Notifications are not authorized. Test may fail.\n"
        }
        
        // Schedule the test notification
        NotificationManager.shared.scheduleDailyNumerologyMessage(
            forFocusNumber: focusNumber,
            delaySeconds: 2
        )
        
        testResults += "📱 Daily message notification scheduled to appear in 2 seconds\n"
        testNotificationsSent = true
    }
    
    /**
     * Resets the test state
     */
    func resetTestState() {
        testNotificationsSent = false
        testResults = ""
    }
} 