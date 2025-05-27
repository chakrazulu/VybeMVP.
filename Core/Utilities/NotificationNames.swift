//
//  NotificationNames.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//

import Foundation

/**
 * Centralized notification names for the VybeMVP app.
 *
 * This extension provides type-safe notification names used throughout
 * the app for inter-component communication.
 */
extension NSNotification.Name {
    /// Posted when a user archetype has been calculated and stored
    static let archetypeCalculated = NSNotification.Name("archetypeCalculated")
    
    /// Posted when user completes onboarding
    static let onboardingCompleted = NSNotification.Name("onboardingCompleted")
    
    /// Posted when focus number changes
    static let focusNumberChanged = NSNotification.Name("focusNumberChanged")
    
    /// Posted when realm number changes
    static let realmNumberChanged = NSNotification.Name("realmNumberChanged")
    
    /// Posted when a resonance match is detected
    static let resonanceMatchDetected = NSNotification.Name("resonanceMatchDetected")
    
    /// Posted when user signs out
    static let userSignedOut = NSNotification.Name("userSignedOut")
} 