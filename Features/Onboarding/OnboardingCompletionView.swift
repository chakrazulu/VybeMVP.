import SwiftUI

struct OnboardingCompletionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @Binding var hasCompletedOnboarding: Bool // To dismiss onboarding flow
    @State private var sparkleAnimation = false
    @State private var profileAnimation = false
    @State private var archetypeRevealAnimation = false
    @State private var lifePathGlow = false
    @State private var pulsatingGlow = false
    @StateObject private var archetypeManager = UserArchetypeManager.shared

    var body: some View {
        ScrollView {
        VStack(spacing: 30) {
                // Animated Header
                headerSection
                
                // HERO: Life Path Number - Bold, Glowing, Animated
                if let profile = viewModel.userProfile {
                    heroLifePathSection(profile)
                }
                
                // PRIMARY ARCHETYPAL INFORMATION - Right after Life Path
                // if let userArchetype = archetypeManager.storedArchetype {
                //     primaryArchetypeSection(userArchetype)
                // }
                
                // Complete Spiritual Codex
                if let userArchetype = archetypeManager.storedArchetype {
                    completeArchetypeCodex(userArchetype)
                }
                
                // Comprehensive Spiritual Profile
                if let profile = viewModel.userProfile {
                    comprehensiveProfileSection(profile)
                } else {
                    loadingSection
                }
                
                // Completion Button
                completionButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 40)
            .padding(.bottom, 40)
        }
        .onAppear {
            startAnimations()
            // Haptic feedback for completion
            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback.impactOccurred()
        }
    }
    
    private func startAnimations() {
        sparkleAnimation = true
        withAnimation(.easeInOut(duration: 1.2).delay(0.3)) {
            profileAnimation = true
        }
        withAnimation(.easeInOut(duration: 1.5).delay(0.8)) {
            archetypeRevealAnimation = true
        }
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(1.0)) {
            lifePathGlow = true
        }
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(1.2)) {
            pulsatingGlow = true
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Enhanced cosmic icon with animation
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.purple.opacity(0.6),
                                Color.blue.opacity(0.4),
                                Color.indigo.opacity(0.3)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 140)
                    .scaleEffect(sparkleAnimation ? 1.15 : 1.0)
                    .shadow(color: .purple.opacity(0.5), radius: 20)
                    .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: sparkleAnimation)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(sparkleAnimation ? 360 : 0))
                    .animation(.linear(duration: 10.0).repeatForever(autoreverses: false), value: sparkleAnimation)
            }
            
            VStack(spacing: 12) {
                Text("Your Complete Cosmic Codex")
                .font(.largeTitle)
                .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.white, .purple.opacity(0.9)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Welcome to the sacred knowledge of your complete spiritual blueprint")
                .font(.title2)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
        }
        .scaleEffect(profileAnimation ? 1.0 : 0.8)
        .opacity(profileAnimation ? 1.0 : 0.0)
    }
    
    // HERO SECTION: Life Path Number
    private func heroLifePathSection(_ profile: UserProfile) -> some View {
        VStack(spacing: 20) {
            Text("Your Sacred Life Path")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.9))
            
            // MASSIVE Life Path Number - Bold, Glowing, Animated
            ZStack {
                // Outer glow ring
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.gold.opacity(lifePathGlow ? 0.8 : 0.4),
                                Color.yellow.opacity(lifePathGlow ? 0.6 : 0.2),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 20,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .scaleEffect(pulsatingGlow ? 1.2 : 1.0)
                
                // Inner circle
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.gold,
                                Color.yellow.opacity(0.8),
                                Color.orange.opacity(0.6)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 160, height: 160)
                    .shadow(color: .gold.opacity(0.8), radius: 25)
                
                // Life Path Number
                Text("\(profile.lifePathNumber)")
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10)
                
                // Master number indicator
                if profile.isMasterNumber {
                    VStack {
                        Spacer()
                        Text("MASTER")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.9))
                            .tracking(2)
                    }
                    .frame(width: 160, height: 160)
                }
            }
            
            // Life Path Description
            Text(lifePathDescription(for: profile.lifePathNumber, isMaster: profile.isMasterNumber))
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.gold.opacity(0.8), .yellow.opacity(0.6)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                )
        )
        .shadow(color: .gold.opacity(0.4), radius: 20, x: 0, y: 10)
        .scaleEffect(archetypeRevealAnimation ? 1.0 : 0.8)
        .opacity(archetypeRevealAnimation ? 1.0 : 0.0)
    }
    
    // PRIMARY ARCHETYPAL INFORMATION - Right after Life Path
    private func primaryArchetypeSection(_ archetype: UserArchetype) -> some View {
        VStack(spacing: 25) {
            Text("Primary Archetypal Information")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [.white, .purple.opacity(0.9)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .padding(.bottom, 10)
            
            VStack(spacing: 25) {
                // Zodiac & Element Row - Enhanced
                enhancedZodiacElementSection(archetype)
                
                // Planetary Influences Row - Enhanced
                enhancedPlanetarySection(archetype)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.black.opacity(0.4))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [.purple.opacity(0.7), .blue.opacity(0.7)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
            )
            .shadow(color: .purple.opacity(0.5), radius: 25, x: 0, y: 15)
        }
        .scaleEffect(archetypeRevealAnimation ? 1.0 : 0.8)
        .opacity(archetypeRevealAnimation ? 1.0 : 0.0)
    }
    
    // COMPLETE ARCHETYPAL CODEX
    private func completeArchetypeCodex(_ archetype: UserArchetype) -> some View {
        VStack(spacing: 25) {
            Text("Complete Spiritual Archetype")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [.white, .purple.opacity(0.9)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .padding(.bottom, 10)
            
            VStack(spacing: 25) {
                // Zodiac & Element Row - Enhanced
                enhancedZodiacElementSection(archetype)
                
                // Planetary Influences Row - Enhanced
                enhancedPlanetarySection(archetype)
                
                // Numerology Breakdown - NEW
                numerologyBreakdownSection()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.black.opacity(0.4))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [.purple.opacity(0.7), .blue.opacity(0.7)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
            )
            .shadow(color: .purple.opacity(0.5), radius: 25, x: 0, y: 15)
        }
        .scaleEffect(archetypeRevealAnimation ? 1.0 : 0.8)
        .opacity(archetypeRevealAnimation ? 1.0 : 0.0)
    }
    
    private func enhancedZodiacElementSection(_ archetype: UserArchetype) -> some View {
        HStack(spacing: 25) {
            // Zodiac Sign - Enhanced with full description
            VStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue.opacity(0.4), .cyan.opacity(0.3)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 90, height: 90)
                        .shadow(color: .blue.opacity(0.3), radius: 10)
                    
                    Text(zodiacSymbol(for: archetype.zodiacSign))
                        .font(.system(size: 40))
                }
                
                VStack(spacing: 6) {
                    Text("Zodiac Sign")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .textCase(.uppercase)
                        .tracking(0.5)
                    
                    Text(archetype.zodiacSign.rawValue)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text(conciseZodiacDescription(for: archetype.zodiacSign))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity)
            
            // Element - Enhanced with full description  
            VStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.green.opacity(0.4), .teal.opacity(0.3)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 90, height: 90)
                        .shadow(color: .green.opacity(0.3), radius: 10)
                    
                    Text(elementSymbol(for: archetype.element))
                        .font(.system(size: 40))
                }
                
                VStack(spacing: 6) {
                    Text("Element")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .textCase(.uppercase)
                        .tracking(0.5)
                    
                    Text(archetype.element.rawValue.capitalized)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text(conciseElementDescription(for: archetype.element))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func enhancedPlanetarySection(_ archetype: UserArchetype) -> some View {
        HStack(spacing: 25) {
            // Primary Planet - Enhanced with full description
            VStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.orange.opacity(0.4), .yellow.opacity(0.3)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 90, height: 90)
                        .shadow(color: .orange.opacity(0.3), radius: 10)
                    
                    Text(planetSymbol(for: archetype.primaryPlanet))
                        .font(.system(size: 35))
                }
                
                VStack(spacing: 6) {
                    Text("Primary Planet")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .textCase(.uppercase)
                        .tracking(0.5)
                    
                    Text(archetype.primaryPlanet.rawValue.capitalized)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    Text(concisePrimaryPlanetDescription(for: archetype.primaryPlanet))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity)
            
            // Shadow Planet - Enhanced with full description
            VStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.red.opacity(0.4), .purple.opacity(0.3)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 90, height: 90)
                        .shadow(color: .red.opacity(0.3), radius: 10)
                    
                    Text(planetSymbol(for: archetype.subconsciousPlanet))
                        .font(.system(size: 35))
                }
                
                VStack(spacing: 6) {
                    Text("Shadow Planet")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .textCase(.uppercase)
                        .tracking(0.5)
                    
                    Text(archetype.subconsciousPlanet.rawValue.capitalized)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.red.opacity(0.9))
                    
                    Text(conciseShadowPlanetDescription(for: archetype.subconsciousPlanet))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // NEW: Numerology Breakdown Section with enhanced Soul Urge and Expression
    private func numerologyBreakdownSection() -> some View {
        VStack(spacing: 15) {
            Text("Complete Numerology Profile")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.9))

            if let profile = viewModel.userProfile {
                VStack(spacing: 15) {
                    // Soul Urge Number - Enhanced
                    if let soulUrge = profile.soulUrgeNumber {
                        EnhancedNumerologyRow(
                            icon: "🎵",
                            title: "Soul Urge Number",
                            value: "\(soulUrge)",
                            description: "Your heart's deepest desires and motivation",
                            detailedDescription: conciseSoulUrgeDescription(for: soulUrge),
                            color: .pink
                        )
                    }
                    
                    // Expression Number - Enhanced
                    if let expression = profile.expressionNumber {
                        EnhancedNumerologyRow(
                            icon: "✨",
                            title: "Expression Number",
                            value: "\(expression)",
                            description: "Your natural talents and life's work",
                            detailedDescription: conciseExpressionDescription(for: expression),
                            color: .yellow
                        )
                    }
                    
                    // Birth name info
                    if let birthName = profile.birthName {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.indigo)
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Sacred Name")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                    .textCase(.uppercase)
                                    .tracking(0.5)
                                Text(birthName)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                Text("The foundation for Soul Urge & Expression")
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.indigo.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.indigo.opacity(0.4), lineWidth: 1)
                                )
                        )
                    }
                }
                    }
                }
                .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.indigo.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.indigo.opacity(0.4), lineWidth: 1)
                )
        )
    }
    
    // COMPREHENSIVE Spiritual Profile Section
    private func comprehensiveProfileSection(_ profile: UserProfile) -> some View {
        VStack(spacing: 25) {
            Text("Your Complete Spiritual Profile")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 10)

            VStack(spacing: 20) {
                // Spiritual Modes (now multiple)
                if !profile.spiritualMode.isEmpty {
                    ProfileCard(
                        title: "Spiritual Alignment",
                        content: profile.spiritualMode,
                        icon: "heart.circle.fill",
                        color: .pink,
                        description: "Your chosen spiritual energy and mode of growth"
                    )
                }
                
                // Insight Tone
                ProfileCard(
                    title: "Communication Style",
                    content: profile.insightTone,
                    icon: "message.circle.fill",
                    color: .blue,
                    description: "How Vybe will speak to your soul"
                )
                
                // Focus Areas
                if !profile.focusTags.isEmpty {
                    ProfileCard(
                        title: "Focus Areas",
                        content: profile.focusTags.joined(separator: " • "),
                        icon: "target",
                        color: .green,
                        description: "Your current life priorities and growth areas"
                    )
                }
                
                // Cosmic Preferences
                ProfileCard(
                    title: "Cosmic Integration",
                    content: profile.cosmicPreference,
                    icon: "sparkles.rectangle.stack.fill",
                    color: .purple,
                    description: "Your openness to cosmic influences beyond numerology"
                )
                
                // Cosmic Rhythms
                if !profile.cosmicRhythms.isEmpty {
                    ProfileCard(
                        title: "Attuned Rhythms",
                        content: profile.cosmicRhythms.joined(separator: " • "),
                        icon: "moon.stars.fill",
                        color: .cyan,
                        description: "Cosmic cycles that resonate with your spirit"
                    )
                }
                
                // Notification Preferences
                if profile.wantsWhispers {
                    ProfileCard(
                        title: "Sacred Timing",
                        content: "Daily whispers at \(formattedTime(for: profile.preferredHour))",
                        icon: "bell.circle.fill",
                        color: .mint,
                        description: "When you receive your spiritual insights"
                    )
                }
                
                // Reflection Mode
                if profile.wantsReflectionMode {
                    ProfileCard(
                        title: "Inner Journey",
                        content: "Reflection & mood tracking enabled",
                        icon: "heart.text.square.fill",
                        color: .teal,
                        description: "Deep inner work and emotional awareness"
                    )
                }
            }
        }
        .scaleEffect(profileAnimation ? 1.0 : 0.8)
        .opacity(profileAnimation ? 1.0 : 0.0)
    }
    
    private var loadingSection: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
            
            Text("Finalizing your cosmic profile...")
                .foregroundColor(.white.opacity(0.8))
                .font(.body)
        }
        .padding()
    }
    
    private var completionButton: some View {
            Button(action: {
            // Enhanced haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback.impactOccurred()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let secondFeedback = UIImpactFeedbackGenerator(style: .medium)
                secondFeedback.impactOccurred()
            }
            
                // IMMEDIATE onboarding completion to prevent state loss during crashes
                hasCompletedOnboarding = true
                
                // Also immediately save to UserDefaults as backup
                if let userID = viewModel.currentUserID {
                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding" + userID)
                    UserDefaults.standard.synchronize() // Force immediate save
                    print("🔒 IMMEDIATE onboarding state saved for user \(userID)")
                }
            }) {
            HStack(spacing: 4) {
                Image(systemName: "sparkles")
                    .font(.body)
                
                Text("Begin Your Sacred Journey")
                    .fontWeight(.bold)
                    .font(.callout)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .allowsTightening(true)
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.body)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 8)
            .frame(height: 64)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.purple, .blue, .indigo, .purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(20)
            .shadow(color: .purple.opacity(0.6), radius: 15, x: 0, y: 8)
            .scaleEffect(pulsatingGlow ? 1.05 : 1.0)
        }
        .scaleEffect(profileAnimation ? 1.0 : 0.8)
        .opacity(profileAnimation ? 1.0 : 0.0)
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    // Helper functions for symbols
    private func zodiacSymbol(for sign: ZodiacSign) -> String {
        switch sign {
        case .aries: return "♈"
        case .taurus: return "♉"
        case .gemini: return "♊"
        case .cancer: return "♋"
        case .leo: return "♌"
        case .virgo: return "♍"
        case .libra: return "♎"
        case .scorpio: return "♏"
        case .sagittarius: return "♐"
        case .capricorn: return "♑"
        case .aquarius: return "♒"
        case .pisces: return "♓"
        }
    }
    
    private func elementSymbol(for element: Element) -> String {
        switch element {
        case .fire: return "🔥"
        case .earth: return "🌍"
        case .air: return "💨"
        case .water: return "🌊"
        }
    }
    
    private func planetSymbol(for planet: Planet) -> String {
        switch planet {
        case .sun: return "☉"
        case .moon: return "☽"
        case .mercury: return "☿"
        case .venus: return "♀"
        case .mars: return "♂"
        case .jupiter: return "♃"
        case .saturn: return "♄"
        case .uranus: return "♅"
        case .neptune: return "♆"
        case .pluto: return "♇"
        case .earth: return "🌍"
        }
    }
    
    // Enhanced Description helper functions
    private func lifePathDescription(for number: Int, isMaster: Bool) -> String {
        if isMaster {
            switch number {
            case 11: return "The Intuitive Illuminator • Master of Spiritual Insight • Channel for Divine Wisdom"
            case 22: return "The Master Builder • Architect of Dreams • Creator of Lasting Legacy"
            case 33: return "The Master Teacher • Embodiment of Universal Love • Healer of Hearts"
            default: return "Master Number • Divine Spiritual Mission • Sacred Soul Purpose"
            }
        } else {
            switch number {
            case 1: return "The Pioneer • Independent Leader & Innovator • Initiator of New Beginnings"
            case 2: return "The Harmonizer • Diplomat of Balance & Partnership • Bridge Between Worlds"
            case 3: return "The Creative Communicator • Artist of Expression • Bringer of Joy"
            case 4: return "The Master Builder • Foundation of Stability • Sacred Structure Creator"
            case 5: return "The Freedom Seeker • Explorer of Possibility • Agent of Change"
            case 6: return "The Nurturer • Guardian of Love & Responsibility • Healer of Hearts"
            case 7: return "The Mystic Seeker • Bridge to Higher Wisdom • Keeper of Sacred Knowledge"
            case 8: return "The Material Master • Authority & Achievement • Builder of Legacy"
            case 9: return "The Universal Humanitarian • Completion & Service • Wise Elder Soul"
            default: return "Sacred Path of Divine Purpose • Unique Soul Mission"
            }
        }
    }
    
    private func zodiacDescription(for sign: ZodiacSign) -> String {
        switch sign {
        case .aries: return "Bold pioneer with natural leadership abilities • Courageously initiates new ventures • Passionate fire that ignites action in others • Learns through direct experience and trial by fire"
        case .taurus: return "Grounded builder with deep appreciation for beauty • Steady strength that endures all storms • Sensual nature that finds joy in life's pleasures • Creates lasting value through patient persistence"
        case .gemini: return "Curious communicator with lightning-quick mind • Social connector who bridges different worlds • Adaptable spirit that thrives on variety • Masters the art of information and exchange"
        case .cancer: return "Emotional nurturer with powerful intuitive gifts • Protective soul who creates safe havens • Deep connection to family and ancestral wisdom • Healing presence that comforts wounded hearts"
        case .leo: return "Creative performer with generous, radiant heart • Natural leader who inspires through example • Dramatic flair that brings color to life • Teaches others to embrace their inner royalty"
        case .virgo: return "Practical healer with analytical, perfectionist mind • Service-oriented soul devoted to improvement • Earth wisdom that grounds spiritual insights • Creates order from chaos through loving attention"
        case .libra: return "Harmonious diplomat seeking balance in all things • Beauty-conscious soul who creates aesthetic pleasure • Natural mediator who sees all sides • Teaches the art of fair and graceful relationships"
        case .scorpio: return "Intense transformer who masters life's mysteries • Deep soul unafraid of shadow work • Phoenix energy that rises from destruction • Penetrating insight that sees hidden truths"
        case .sagittarius: return "Wise explorer seeking truth and meaning • Philosophical wanderer who expands horizons • Optimistic teacher who shares cosmic wisdom • Adventure-seeking spirit that questions everything"
        case .capricorn: return "Ambitious architect who builds lasting monuments • Steady climber who reaches the mountain top • Responsible elder who shoulders great burdens • Master of time and earthly achievement"
        case .aquarius: return "Innovative rebel who champions humanity's future • Visionary soul who breaks outdated patterns • Independent spirit that values freedom above all • Brings revolutionary healing to collective consciousness"
        case .pisces: return "Mystical dreamer with boundless compassion • Intuitive healer who feels everything deeply • Spiritual artist who channels divine beauty • Dissolves boundaries between self and universe"
        }
    }
    
    private func elementDescription(for element: Element) -> String {
        switch element {
        case .fire: return "Passionate, creative, inspiring energy • Spirit of action, enthusiasm, and courage • Natural leader who ignites others • Learns through bold experience and intuitive leaps • Transforms ideas into dynamic reality"
        case .earth: return "Practical, grounded, material mastery • Foundation of stability, growth, and abundance • Patient builder who creates lasting value • Learns through sensory experience and careful observation • Transforms visions into tangible form"
        case .air: return "Intellectual, communicative, social energy • Mind of ideas, connection, and innovation • Natural teacher who shares knowledge • Learns through mental exploration and social exchange • Transforms thoughts into meaningful communication"
        case .water: return "Emotional, intuitive, healing flow • Heart of empathy, depth, and psychic sensitivity • Natural healer who feels everything • Learns through emotional experience and spiritual surrender • Transforms feelings into wisdom and compassion"
        }
    }
    
    private func primaryPlanetDescription(for planet: Planet) -> String {
        switch planet {
        case .sun: return "Core identity and life purpose • Creative force and vital energy • Radiant essence that illuminates your path • Divine spark of consciousness expressing through you • Leadership through authentic self-expression"
        case .moon: return "Emotional nature and inner world • Intuitive wisdom and subconscious patterns • Nurturing force that sustains your soul • Connection to cycles, rhythms, and feminine wisdom • Security through emotional authenticity"
        case .mercury: return "Communication and mental agility • Quick wit and learning capacity • Messenger energy that connects ideas • Adaptability in thought and expression • Intelligence expressed through words and movement"
        case .venus: return "Love, beauty, and magnetic attraction • Values and aesthetic sensibility • Heart's capacity for pleasure and connection • Creative expression of harmony • Relationships as mirrors of self-worth"
        case .mars: return "Action, drive, and warrior spirit • Courage to pursue desires and goals • Passionate energy that fuels achievement • Assertiveness in claiming your space • Initiative that breaks through obstacles"
        case .jupiter: return "Expansion, wisdom, and abundant growth • Philosophical understanding of life's meaning • Optimism that sees possibilities everywhere • Teaching gifts that share knowledge • Prosperity consciousness and generous spirit"
        case .saturn: return "Structure, discipline, and lasting achievement • Master teacher of responsibility and limits • Authority earned through dedication • Wisdom gained through life's challenges • Building something permanent and meaningful"
        case .uranus: return "Innovation, rebellion, and sudden awakening • Revolutionary spirit that breaks old patterns • Genius insights that come like lightning • Freedom-seeking independence • Divine inspiration that transforms everything"
        case .neptune: return "Dreams, spirituality, and mystical connection • Imagination that dissolves boundaries • Compassion that embraces all suffering • Psychic sensitivity to unseen realms • Art as pathway to the divine"
        case .pluto: return "Transformation, power, and deep regeneration • Phoenix nature that rises from ashes • Ability to penetrate life's mysteries • Healing through shadow integration • Soul power that catalyzes profound change"
        case .earth: return "Grounding energy and material wisdom • Stability that anchors spiritual insights • Connection to body and physical realm • Practical magic that manifests visions • Foundation energy for all other expressions"
        }
    }
    
    private func shadowPlanetDescription(for planet: Planet) -> String {
        switch planet {
        case .sun: return "Ego challenges and pride patterns • Learning humility while maintaining confidence • Balancing self-expression with service to others • Healing wounds around visibility and recognition • Shadow work: 'I am enough without needing to prove it'"
        case .moon: return "Emotional patterns and hidden fears • Healing inner child wounds and family karma • Learning emotional boundaries and self-care • Integrating feminine wisdom and cyclical nature • Shadow work: 'I am safe to feel deeply and trust my intuition'"
        case .mercury: return "Mental confusion and communication blocks • Clearing limiting beliefs and thought patterns • Learning to speak truth with compassion • Healing wounds around being heard and understood • Shadow work: 'My voice matters and my thoughts are valuable'"
        case .venus: return "Relationship patterns and self-worth issues • Learning unconditional love starting with self • Healing wounds around beauty, pleasure, and worthiness • Integrating healthy boundaries in love • Shadow work: 'I am lovable exactly as I am'"
        case .mars: return "Anger, impatience, and aggressive patterns • Learning to channel warrior energy wisely • Healing wounds around power and assertion • Integrating healthy anger and boundary-setting • Shadow work: 'I can be strong without being harmful'"
        case .jupiter: return "Overindulgence and false optimism patterns • Learning discernment alongside expansion • Balancing growth with grounding and limits • Healing wounds around excess and spiritual bypassing • Shadow work: 'True wisdom includes healthy boundaries'"
        case .saturn: return "Limitation beliefs and harsh self-criticism • Transforming inner taskmaster into wise teacher • Healing wounds around authority and structure • Learning self-compassion within discipline • Shadow work: 'I can be responsible while being kind to myself'"
        case .uranus: return "Rebellious destruction and chaotic change • Learning revolutionary responsibility and timing • Healing wounds around feeling different or outcast • Integrating innovation with consideration for others • Shadow work: 'I can be unique without rejecting all connection'"
        case .neptune: return "Illusion, escapism, and confusion patterns • Grounding spiritual gifts in practical reality • Healing wounds around disappointment and disillusionment • Learning healthy boundaries with empathy • Shadow work: 'I can be spiritual while staying grounded'"
        case .pluto: return "Control issues and destructive power patterns • Mastering transformation without domination • Healing wounds around powerlessness and betrayal • Learning to use depth without manipulation • Shadow work: 'I can be powerful while honoring others' autonomy'"
        case .earth: return "Materialism, rigidity, and stagnation patterns • Balancing form with spirit and flow • Healing wounds around scarcity and survival • Learning to honor body while nurturing soul • Shadow work: 'I can enjoy material life while staying spiritually connected'"
        }
    }
    
    private func soulUrgeDescription(for number: Int) -> String {
        switch number {
        case 1: return "Deep desire for independence and leadership • Soul craves pioneering new paths • Heart yearns to be first and make unique impact • Inner calling to initiate and innovate"
        case 2: return "Deep desire for harmony and partnership • Soul craves cooperation and peace • Heart yearns for emotional connection • Inner calling to bridge and unite others"
        case 3: return "Deep desire for creative self-expression • Soul craves artistic and communicative outlet • Heart yearns for joy and inspiration • Inner calling to entertain and uplift others"
        case 4: return "Deep desire for security and stability • Soul craves order and systematic progress • Heart yearns for practical achievement • Inner calling to build lasting foundations"
        case 5: return "Deep desire for freedom and adventure • Soul craves variety and new experiences • Heart yearns for exploration and change • Inner calling to break limitations and expand horizons"
        case 6: return "Deep desire for love and family harmony • Soul craves nurturing and caregiving • Heart yearns for beauty and service • Inner calling to heal and create sanctuary for others"
        case 7: return "Deep desire for wisdom and spiritual understanding • Soul craves solitude and inner development • Heart yearns for truth and mystical connection • Inner calling to seek and share sacred knowledge"
        case 8: return "Deep desire for achievement and material success • Soul craves recognition and authority • Heart yearns for prosperity and influence • Inner calling to build empire and leave lasting legacy"
        case 9: return "Deep desire for humanitarian service • Soul craves universal love and compassion • Heart yearns for global healing • Inner calling to serve humanity's highest good"
        case 11: return "Deep desire for spiritual illumination • Soul craves channeling divine wisdom • Heart yearns for intuitive mastery • Inner calling to inspire and enlighten others through example"
        case 22: return "Deep desire for master building • Soul craves creating lasting institutions • Heart yearns for combining vision with practical achievement • Inner calling to manifest large-scale positive change"
        case 33: return "Deep desire for master teaching • Soul craves healing through unconditional love • Heart yearns for uplifting global consciousness • Inner calling to embody Christ-like compassion"
        default: return "Deep soul desires seeking expression through your heart's calling"
        }
    }
    
    private func expressionDescription(for number: Int) -> String {
        switch number {
        case 1: return "Natural talents for leadership and innovation • Life's work involves pioneering and initiating • Gift for inspiring others to take action • Meant to create original solutions and blaze new trails"
        case 2: return "Natural talents for diplomacy and cooperation • Life's work involves bringing people together • Gift for creating harmony from conflict • Meant to serve as mediator and peaceful bridge-builder"
        case 3: return "Natural talents for communication and creativity • Life's work involves inspiring through art • Gift for bringing joy and beauty to the world • Meant to express divine inspiration through various creative mediums"
        case 4: return "Natural talents for organization and building • Life's work involves creating lasting structures • Gift for turning visions into practical reality • Meant to establish solid foundations others can build upon"
        case 5: return "Natural talents for freedom and progressive change • Life's work involves breaking limitations • Gift for adapting to new situations quickly • Meant to be agent of positive change and expansion"
        case 6: return "Natural talents for nurturing and healing • Life's work involves service to others • Gift for creating beauty and harmony • Meant to be caretaker, counselor, and creator of sanctuary"
        case 7: return "Natural talents for research and spiritual insight • Life's work involves seeking deeper truths • Gift for penetrating life's mysteries • Meant to be teacher, analyst, and spiritual guide"
        case 8: return "Natural talents for business and material mastery • Life's work involves managing resources • Gift for organizing large-scale enterprises • Meant to be successful executive and community leader"
        case 9: return "Natural talents for healing and humanitarian service • Life's work involves uplifting humanity • Gift for seeing the bigger picture • Meant to be philanthropist, healer, and universal servant"
        case 11: return "Natural talents for intuitive guidance and inspiration • Life's work involves channeling higher wisdom • Gift for illuminating truth for others • Meant to be spiritual teacher and enlightened leader"
        case 22: return "Natural talents for master building and organizing • Life's work involves creating lasting institutions • Gift for combining spiritual vision with practical skill • Meant to be architect of positive global change"
        case 33: return "Natural talents for unconditional love and healing • Life's work involves teaching through example • Gift for uplifting others through compassionate service • Meant to be master teacher and healer of hearts"
        default: return "Natural talents and life work expressing through your unique gifts"
        }
    }
    
    private func formattedTime(for hour: Int) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h a"
        let time = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: Date()) ?? Date()
        return timeFormatter.string(from: time)
    }
    
    // Helper functions for concise descriptions
    private func conciseZodiacDescription(for sign: ZodiacSign) -> String {
        switch sign {
        case .aries: return "Bold pioneer • Natural leader • Passionate fire energy"
        case .taurus: return "Grounded builder • Sensual strength • Steady endurance"
        case .gemini: return "Curious communicator • Quick mind • Social connector"
        case .cancer: return "Emotional nurturer • Intuitive healer • Protective soul"
        case .leo: return "Creative performer • Generous heart • Radiant leader"
        case .virgo: return "Practical healer • Analytical mind • Service-oriented"
        case .libra: return "Harmonious diplomat • Beauty-conscious • Fair mediator"
        case .scorpio: return "Intense transformer • Deep soul • Phoenix energy"
        case .sagittarius: return "Wise explorer • Truth seeker • Optimistic teacher"
        case .capricorn: return "Ambitious architect • Steady climber • Responsible elder"
        case .aquarius: return "Innovative rebel • Visionary soul • Future champion"
        case .pisces: return "Mystical dreamer • Boundless compassion • Intuitive artist"
        }
    }
    
    private func conciseElementDescription(for element: Element) -> String {
        switch element {
        case .fire: return "Passionate • Creative • Inspiring • Spirit of action and courage"
        case .earth: return "Practical • Grounded • Stable • Foundation of growth and abundance"
        case .air: return "Intellectual • Communicative • Social • Mind of ideas and connection"
        case .water: return "Emotional • Intuitive • Healing • Heart of empathy and depth"
        }
    }
    
    private func concisePrimaryPlanetDescription(for planet: Planet) -> String {
        switch planet {
        case .sun: return "Core identity • Life purpose • Creative force • Radiant essence"
        case .moon: return "Emotional nature • Inner world • Intuitive wisdom • Nurturing force"
        case .mercury: return "Communication • Mental agility • Quick wit • Messenger energy"
        case .venus: return "Love • Beauty • Magnetic attraction • Heart's values"
        case .mars: return "Action • Drive • Warrior spirit • Courage and passion"
        case .jupiter: return "Expansion • Wisdom • Abundant growth • Optimistic vision"
        case .saturn: return "Structure • Discipline • Achievement • Master teacher"
        case .uranus: return "Innovation • Rebellion • Awakening • Revolutionary spirit"
        case .neptune: return "Dreams • Spirituality • Mystical connection • Divine imagination"
        case .pluto: return "Transformation • Power • Regeneration • Phoenix nature"
        case .earth: return "Grounding • Material wisdom • Stability • Physical foundation"
        }
    }
    
    private func conciseShadowPlanetDescription(for planet: Planet) -> String {
        switch planet {
        case .sun: return "Ego challenges • Pride patterns • Learning humility with confidence"
        case .moon: return "Emotional patterns • Hidden fears • Healing inner child wounds"
        case .mercury: return "Mental confusion • Communication blocks • Speaking truth with compassion"
        case .venus: return "Relationship patterns • Self-worth issues • Learning unconditional love"
        case .mars: return "Anger patterns • Impatience • Channeling warrior energy wisely"
        case .jupiter: return "Overindulgence • False optimism • Learning discernment with expansion"
        case .saturn: return "Limitation beliefs • Harsh criticism • Transforming inner taskmaster"
        case .uranus: return "Rebellious destruction • Chaotic change • Revolutionary responsibility"
        case .neptune: return "Illusion • Escapism • Grounding spiritual gifts in reality"
        case .pluto: return "Control issues • Destructive power • Mastering transformation wisely"
        case .earth: return "Materialism • Rigidity • Balancing form with spirit and flow"
        }
    }
    
    private func conciseSoulUrgeDescription(for number: Int) -> String {
        switch number {
        case 1: return "Deep desire for independence and leadership • Soul craves pioneering new paths"
        case 2: return "Deep desire for harmony and partnership • Soul craves cooperation and peace"
        case 3: return "Deep desire for creative self-expression • Soul craves artistic outlet and joy"
        case 4: return "Deep desire for security and stability • Soul craves order and achievement"
        case 5: return "Deep desire for freedom and adventure • Soul craves variety and exploration"
        case 6: return "Deep desire for love and family harmony • Soul craves nurturing and service"
        case 7: return "Deep desire for wisdom and understanding • Soul craves spiritual connection"
        case 8: return "Deep desire for achievement and success • Soul craves recognition and authority"
        case 9: return "Deep desire for humanitarian service • Soul craves universal love and healing"
        case 11: return "Deep desire for spiritual illumination • Soul craves channeling divine wisdom"
        case 22: return "Deep desire for master building • Soul craves creating lasting institutions"
        case 33: return "Deep desire for master teaching • Soul craves healing through love"
        default: return "Deep soul desires seeking expression through your heart's calling"
        }
    }
    
    private func conciseExpressionDescription(for number: Int) -> String {
        switch number {
        case 1: return "Natural talents for leadership and innovation • Life's work involves pioneering"
        case 2: return "Natural talents for diplomacy and cooperation • Life's work involves harmony"
        case 3: return "Natural talents for communication and creativity • Life's work involves inspiration"
        case 4: return "Natural talents for organization and building • Life's work involves structure"
        case 5: return "Natural talents for freedom and change • Life's work involves adaptation"
        case 6: return "Natural talents for nurturing and healing • Life's work involves service"
        case 7: return "Natural talents for research and insight • Life's work involves seeking truth"
        case 8: return "Natural talents for business and mastery • Life's work involves leadership"
        case 9: return "Natural talents for healing and service • Life's work involves uplifting humanity"
        case 11: return "Natural talents for intuitive guidance • Life's work involves spiritual teaching"
        case 22: return "Natural talents for master building • Life's work involves global change"
        case 33: return "Natural talents for unconditional love • Life's work involves healing hearts"
        default: return "Natural talents and life work expressing through your unique gifts"
        }
    }
}

// MARK: - Supporting Views

struct EnhancedNumerologyRow: View {
    let icon: String
    let title: String
    let value: String
    let description: String
    let detailedDescription: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Text(icon)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(value)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(color)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(color.opacity(0.2))
                                    .overlay(
                                        Capsule()
                                            .stroke(color.opacity(0.4), lineWidth: 1)
                                    )
                            )
                    }
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .fontWeight(.medium)
                }
            }
            
            // Detailed description in a styled container
            Text(detailedDescription)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(color.opacity(0.2), lineWidth: 1)
                        )
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct NumerologyRow: View {
    let icon: String
    let title: String
    let value: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Text(icon)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(value)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(color.opacity(0.2))
                        )
                }
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(.vertical, 4)
    }
}

struct ProfileCard: View {
    let title: String
    let content: String
    let icon: String
    let color: Color
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
        HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            Text(content)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(color)
                .multilineTextAlignment(.leading)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.4), lineWidth: 1)
                )
        )
    }
}

// Color extension for gold
extension Color {
    static let gold = Color(red: 1.0, green: 0.843, blue: 0.0)
}

// Preview
struct OnboardingCompletionView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = OnboardingViewModel()
        // Populate with some sample data for preview
        viewModel.userProfile = UserProfile(
            id: "previewUser",
            birthdate: Date(),
            lifePathNumber: 7,
            isMasterNumber: false,
            spiritualMode: "Reflection, Healing",
            insightTone: "Gentle",
            focusTags: ["Growth", "Purpose"],
            cosmicPreference: "Numerology + Moon Phases",
            cosmicRhythms: ["Moon Phases"],
            preferredHour: 8,
            wantsWhispers: true,
            wantsReflectionMode: true
        )
        
        return OnboardingCompletionView(viewModel: viewModel, hasCompletedOnboarding: .constant(false))
    }
} 
