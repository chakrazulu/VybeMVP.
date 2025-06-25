/**
 * Filename: EnhancedLoadingView.swift
 * 
 * Purpose: Enhanced loading view with timeout and retry mechanisms
 * Fixes cold-start splash screen hanging issues
 */

import SwiftUI

/**
 * Enhanced loading view that prevents infinite loading states
 * Provides timeout, retry, and fallback mechanisms
 */
struct EnhancedLoadingView: View {
    let title: String
    let subtitle: String
    let timeoutDuration: TimeInterval
    let onTimeout: () -> Void
    let onRetry: () -> Void
    
    @State private var hasTimedOut = false
    @State private var showRetryOption = false
    @State private var pulseAnimation = false
    @State private var rotationAnimation = false
    
    init(
        title: String = "Vybe",
        subtitle: String = "Checking authentication...",
        timeoutDuration: TimeInterval = 10.0,
        onTimeout: @escaping () -> Void = {},
        onRetry: @escaping () -> Void = {}
    ) {
        self.title = title
        self.subtitle = subtitle
        self.timeoutDuration = timeoutDuration
        self.onTimeout = onTimeout
        self.onRetry = onRetry
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // App icon with animation
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.purple.opacity(0.3),
                                    Color.blue.opacity(0.2)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(.purple)
                        .rotationEffect(.degrees(rotationAnimation ? 360 : 0))
                }
                
                // Title and subtitle
                VStack(spacing: 12) {
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    if !hasTimedOut {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                
                // Loading indicator or timeout message
                if hasTimedOut {
                    timeoutContent
                } else {
                    loadingContent
                }
            }
        }
        .onAppear {
            startAnimations()
            startTimeout()
        }
    }
    
    // MARK: - Loading Content
    
    private var loadingContent: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
                .progressViewStyle(CircularProgressViewStyle(tint: .purple))
            
            Text("Initializing cosmic systems...")
                .font(.caption2)
                .foregroundColor(.secondary)
                .opacity(0.7)
        }
    }
    
    // MARK: - Timeout Content
    
    private var timeoutContent: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.orange)
            
            VStack(spacing: 8) {
                Text("Loading Taking Longer Than Expected")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text("The cosmic alignment may be experiencing interference. You can wait a bit longer or try refreshing.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            HStack(spacing: 16) {
                Button("Wait Longer") {
                    hasTimedOut = false
                    startTimeout()
                }
                .buttonStyle(SecondaryButtonStyle())
                
                Button("Retry") {
                    hasTimedOut = false
                    onRetry()
                    startTimeout()
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
    }
    
    // MARK: - Animation and Timeout Logic
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            pulseAnimation = true
        }
        
        withAnimation(.linear(duration: 8.0).repeatForever(autoreverses: false)) {
            rotationAnimation = true
        }
    }
    
    private func startTimeout() {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeoutDuration) {
            if !hasTimedOut {
                withAnimation(.easeInOut(duration: 0.5)) {
                    hasTimedOut = true
                }
                onTimeout()
            }
        }
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.body, design: .rounded))
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.purple)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.body, design: .rounded))
            .fontWeight(.medium)
            .foregroundColor(.purple)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.purple, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Specialized Loading Views

extension EnhancedLoadingView {
    /// Authentication loading view
    static func authentication(onTimeout: @escaping () -> Void = {}, onRetry: @escaping () -> Void = {}) -> EnhancedLoadingView {
        EnhancedLoadingView(
            title: "Vybe",
            subtitle: "Checking authentication...",
            timeoutDuration: 8.0,
            onTimeout: onTimeout,
            onRetry: onRetry
        )
    }
    
    /// Profile loading view
    static func profile(onTimeout: @escaping () -> Void = {}, onRetry: @escaping () -> Void = {}) -> EnhancedLoadingView {
        EnhancedLoadingView(
            title: "Cosmic Profile",
            subtitle: "Loading your spiritual blueprint...",
            timeoutDuration: 12.0,
            onTimeout: onTimeout,
            onRetry: onRetry
        )
    }
    
    /// Archetype calculation loading view
    static func archetype(onTimeout: @escaping () -> Void = {}, onRetry: @escaping () -> Void = {}) -> EnhancedLoadingView {
        EnhancedLoadingView(
            title: "Spiritual Archetype",
            subtitle: "Aligning zodiac, element, and planetary influences...",
            timeoutDuration: 15.0,
            onTimeout: onTimeout,
            onRetry: onRetry
        )
    }
}

// MARK: - Preview

struct EnhancedLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Default loading
            EnhancedLoadingView()
            
            // Authentication loading
            EnhancedLoadingView.authentication()
            
            // With timeout triggered
            EnhancedLoadingView()
                .onAppear {
                    // This would simulate immediate timeout for preview
                }
        }
    }
} 