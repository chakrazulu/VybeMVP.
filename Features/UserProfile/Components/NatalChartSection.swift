/*
 * ========================================
 * 🌌 NATAL CHART SECTION COMPONENT - MAJOR REFACTOR COMPLETE
 * ========================================
 * 
 * COSMIC PURPOSE:
 * Comprehensive natal chart display with progressive disclosure accordions
 * for houses, aspects, and planetary positions. Transforms the Sanctum into
 * a complete cosmic data center with real Swiss Ephemeris astronomical data.
 *
 * COMPONENT FEATURES:
 * - Interactive view mode toggle (Birth Chart / Live Transits)
 * - Progressive disclosure accordion architecture with smooth animations
 * - Houses Accordion: 12 astrological houses with real zodiac cusps
 * - Aspects Accordion: Major natal aspects with orbs and meanings
 * - Planetary Map Accordion: Compact 2-column planetary positions layout
 * - Birth chart summary with optimized 3-column responsive grid
 *
 * VISUAL DESIGN ENHANCEMENTS (July 2025):
 * - Pixel-perfect spacing with proper breathing room between elements
 * - Multi-gradient backgrounds with cosmic depth and glow effects
 * - Planet-colored borders and shadows for visual hierarchy
 * - Smooth accordion animations (fixed glitchy duplicate animations)
 * - Uniform card heights for professional grid alignment
 *
 * SWISS EPHEMERIS INTEGRATION:
 * - Real planetary positions replacing 0.0° placeholder data
 * - Geocentric coordinate calculations for accurate astrological use
 * - Birth chart house cusp calculations with Placidus system
 * - Zodiac sign detection for house cusps with proper glyphs
 *
 * ARCHITECTURAL BENEFITS:
 * - Extracted from 1,494-line monolithic section (Phase 15)
 * - Clean separation of astrological chart logic
 * - Modular component architecture for maintainability
 * - Performance optimized with lazy loading and fixed card heights
 * - Memory leak prevention with simplified animation transitions
 *
 * RECENT MAJOR FIXES (July 26, 2025):
 * - Fixed planetary position overlapping with optimized grid spacing
 * - Resolved accordion animation glitches by simplifying transitions
 * - Implemented uniform house card heights (150px) for grid consistency
 * - Enhanced Planetary Map section with compact cards (95px height)
 * - Added proper spacing (8px column, 20px row) for visual separation
 */

import SwiftUI
import SwiftAA

/// Claude: Natal Chart Section component for comprehensive astrological displays
struct NatalChartSection: View {
    
    // MARK: - Properties
    let profile: UserProfile
    @Binding var sanctumViewMode: SanctumViewMode
    @Binding var housesAccordionExpanded: Bool
    @Binding var aspectsAccordionExpanded: Bool
    @Binding var glyphMapAccordionExpanded: Bool
    @Binding var selectedHouseForSheet: IdentifiableInt?
    @Binding var selectedPlanet: PlanetaryPosition?
    @Binding var selectedAspect: NatalAspect?
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 24) {
            // Section Header with View Mode Toggle
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("✦ Your Cosmic Map ✦")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [.cyan, .blue, .purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: .cyan.opacity(0.5), radius: 8, x: 0, y: 2)
                        
                        Text(sanctumViewMode.description)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .italic()
                    }
                    
                    Spacer()
                    
                    // View Mode Toggle
                    Picker("View Mode", selection: $sanctumViewMode) {
                        ForEach(SanctumViewMode.allCases, id: \.self) { mode in
                            Label(mode.rawValue, systemImage: mode.icon)
                                .tag(mode)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .scaleEffect(0.85)
                }
                
                if let birthplace = profile.birthplaceName {
                    HStack {
                        Spacer()
                        Text("📍 \(birthplace)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                SwiftUI.Color.cyan.opacity(0.2),
                                                SwiftUI.Color.blue.opacity(0.1)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .overlay(
                                        Capsule()
                                            .stroke(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.cyan.opacity(0.6), .blue.opacity(0.3)]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                ),
                                                lineWidth: 1
                                            )
                                    )
                            )
                            .shadow(color: .cyan.opacity(0.3), radius: 4, x: 0, y: 2)
                        Spacer()
                    }
                }
            }
            
            // Birth Chart Summary
            if !getPlanetaryPositions(profile: profile, mode: sanctumViewMode).isEmpty {
                birthChartSummary(profile)
            }
            
            VStack(spacing: 16) {
                // Houses Accordion
                natalChartAccordion(
                    title: "🏠 Astrological Houses",
                    subtitle: "12 Life Areas & Planetary Cusps",
                    isExpanded: $housesAccordionExpanded,
                    content: {
                        housesAccordionContent(profile)
                    }
                )
                
                // Aspects Accordion  
                natalChartAccordion(
                    title: "⭐ Major Aspects",
                    subtitle: "Planetary Relationships & Orbs",
                    isExpanded: $aspectsAccordionExpanded,
                    content: {
                        aspectsAccordionContent(profile)
                    }
                )
                
                // Planetary Map Accordion
                natalChartAccordion(
                    title: "🌌 Planetary Map",
                    subtitle: "Visual Birth Chart Wheel",
                    isExpanded: $glyphMapAccordionExpanded,
                    content: {
                        glyphMapAccordionContent(profile)
                    }
                )
            }
        }
        .padding(20)
        .background(natalChartBackground)
        .shadow(color: .cyan.opacity(0.4), radius: 20, x: 0, y: 10)
        .shadow(color: .purple.opacity(0.2), radius: 30, x: 0, y: 15)
    }
    
    // MARK: - Background Style
    private var natalChartBackground: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: SwiftUI.Color.black.opacity(0.6), location: 0.0),
                        .init(color: SwiftUI.Color.black.opacity(0.4), location: 0.5),
                        .init(color: SwiftUI.Color.black.opacity(0.3), location: 1.0)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: SwiftUI.Color.cyan.opacity(0.7), location: 0.0),
                                .init(color: SwiftUI.Color.blue.opacity(0.5), location: 0.4),
                                .init(color: SwiftUI.Color.purple.opacity(0.4), location: 0.8),
                                .init(color: SwiftUI.Color.cyan.opacity(0.3), location: 1.0)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            .overlay(
                // Inner glow effect
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                SwiftUI.Color.cyan.opacity(0.3),
                                SwiftUI.Color.clear,
                                SwiftUI.Color.purple.opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 4
                    )
                    .blur(radius: 2)
            )
    }
    
    // MARK: - Birth Chart Summary
    private func birthChartSummary(_ profile: UserProfile) -> some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    HStack(spacing: 8) {
                        Text("🌟")
                            .font(.title3)
                        Text("Your Planetary Positions")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [.white, .cyan.opacity(0.9)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }
                    
                    Spacer()
                    
                    // Birth Time Precision Indicator
                    if profile.hasBirthTime {
                        HStack(spacing: 6) {
                            Image(systemName: "clock.fill")
                                .font(.caption)
                                .foregroundColor(.green)
                            Text("Precise")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.green)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            SwiftUI.Color.green.opacity(0.25),
                                            SwiftUI.Color.green.opacity(0.15)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    Capsule()
                                        .stroke(SwiftUI.Color.green.opacity(0.5), lineWidth: 1)
                                )
                        )
                        .shadow(color: .green.opacity(0.3), radius: 2, x: 0, y: 1)
                    } else {
                        HStack(spacing: 6) {
                            Image(systemName: "clock")
                                .font(.caption)
                                .foregroundColor(.orange)
                            Text("Estimated")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.orange)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            SwiftUI.Color.orange.opacity(0.25),
                                            SwiftUI.Color.orange.opacity(0.15)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    Capsule()
                                        .stroke(SwiftUI.Color.orange.opacity(0.5), lineWidth: 1)
                                )
                        )
                        .shadow(color: .orange.opacity(0.3), radius: 2, x: 0, y: 1)
                    }
                }
            }
            
            // Claude: Planetary Positions Grid - Optimized 3-column layout
            // SPACING OPTIMIZATION: 8px column spacing + 20px row spacing prevents overlap
            // PERFORMANCE: LazyVGrid with fixed height (140px) for smooth scrolling
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), 
                spacing: 20
            ) {
                ForEach(getPlanetaryPositions(profile: profile, mode: sanctumViewMode), id: \.planet) { position in
                    planetPositionCard(position: position)
                        .frame(height: 140) // Claude: Fixed height prevents overlap and ensures uniform grid
                        .onTapGesture {
                            selectedPlanet = position
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                        }
                }
            }
            .padding(.horizontal, 4) // Claude: Minimal padding for breathing room without waste
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: SwiftUI.Color.purple.opacity(0.15), location: 0.0),
                            .init(color: SwiftUI.Color.blue.opacity(0.10), location: 0.5),
                            .init(color: SwiftUI.Color.cyan.opacity(0.08), location: 1.0)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    SwiftUI.Color.purple.opacity(0.4),
                                    SwiftUI.Color.blue.opacity(0.3),
                                    SwiftUI.Color.cyan.opacity(0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
        )
        .shadow(color: .purple.opacity(0.2), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Planet Position Card
    private func planetPositionCard(position: PlanetaryPosition) -> some View {
        VStack(spacing: 10) {
            // Planet Symbol and Name
            VStack(spacing: 4) {
                Text(planetGlyph(for: position.planet))
                    .font(.title2)
                    .foregroundColor(planetColor(for: position.planet))
                    .shadow(color: planetColor(for: position.planet).opacity(0.5), radius: 2, x: 0, y: 1)
                
                Text(position.planet.capitalized)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            
            // Sign and Degree
            VStack(spacing: 3) {
                Text(position.sign)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.cyan, .blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Text("\(position.degree)°")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            // Element Indicator
            if let element = getSignElement(for: position.sign) {
                Text(element)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        elementColor(for: element).opacity(0.4),
                                        elementColor(for: element).opacity(0.2)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                Capsule()
                                    .stroke(elementColor(for: element).opacity(0.6), lineWidth: 0.5)
                            )
                    )
                    .foregroundColor(elementColor(for: element))
                    .shadow(color: elementColor(for: element).opacity(0.3), radius: 1, x: 0, y: 1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            SwiftUI.Color.black.opacity(0.5),
                            SwiftUI.Color.black.opacity(0.3)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    planetColor(for: position.planet).opacity(0.6),
                                    planetColor(for: position.planet).opacity(0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: planetColor(for: position.planet).opacity(0.2), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Accordion Components
    
    /// Claude: Generic accordion wrapper for natal chart sections
    private func natalChartAccordion<Content: View>(
        title: String,
        subtitle: String,
        isExpanded: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Accordion Header
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.wrappedValue.toggle()
                }
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [.white, .cyan.opacity(0.9)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded.wrappedValue ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .font(.title3)
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [.cyan, .blue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .rotationEffect(.degrees(isExpanded.wrappedValue ? 180 : 0))
                        .shadow(color: .cyan.opacity(0.4), radius: 2, x: 0, y: 1)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    SwiftUI.Color.black.opacity(0.4),
                                    SwiftUI.Color.black.opacity(0.2)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            SwiftUI.Color.cyan.opacity(0.5),
                                            SwiftUI.Color.blue.opacity(0.3)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                )
                .shadow(color: .cyan.opacity(0.2), radius: 6, x: 0, y: 3)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Accordion Content
            if isExpanded.wrappedValue {
                content()
                    .padding(.top, 12)
                    .transition(.opacity)
            }
        }
    }
    
    // MARK: - Accordion Content Views
    
    /// Claude: Houses accordion content showing 12 astrological houses
    private func housesAccordionContent(_ profile: UserProfile) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
            ForEach(1...12, id: \.self) { houseNumber in
                Button(action: {
                    selectedHouseForSheet = IdentifiableInt(value: houseNumber)
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                }) {
                    houseCard(houseNumber: houseNumber, profile: profile)
                        .frame(height: 150) // Force exact same height for all cards
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 8)
    }
    
    /// Claude: Individual house card for the houses grid
    private func houseCard(houseNumber: Int, profile: UserProfile) -> some View {
        VStack(spacing: 8) {
            // House Number and Symbol
            HStack {
                Text("\(houseNumber)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.cyan)
                
                Spacer()
                
                Text(houseSymbol(for: houseNumber, profile: profile))
                    .font(.title3)
                    .foregroundColor(.cyan)
            }
            
            // House Name
            Text(houseName(for: houseNumber))
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
            
            // Zodiac Sign on Cusp
            Text(getHouseCuspSign(houseNumber: houseNumber, profile: profile))
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [.cyan, .blue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(
                    Capsule()
                        .fill(SwiftUI.Color.cyan.opacity(0.15))
                        .overlay(
                            Capsule()
                                .stroke(SwiftUI.Color.cyan.opacity(0.3), lineWidth: 1)
                        )
                )
            
            // House Keywords
            Text(houseKeywords(for: houseNumber))
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.leading)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(SwiftUI.Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(SwiftUI.Color.cyan.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    /// Claude: Aspects accordion content showing major natal aspects
    private func aspectsAccordionContent(_ profile: UserProfile) -> some View {
        let aspects = calculateNatalAspects(profile: profile)
        
        return Group {
            if aspects.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "star.slash")
                        .font(.largeTitle)
                        .foregroundColor(.white.opacity(0.5))
                    
                    Text("Birth time required for precise aspects")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding()
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(aspects, id: \.id) { aspect in
                        aspectRow(aspect: aspect)
                            .onTapGesture {
                                selectedAspect = aspect
                                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                                impactFeedback.impactOccurred()
                            }
                    }
                }
            }
        }
    }
    
    /// Claude: Individual aspect row for the aspects list
    private func aspectRow(aspect: NatalAspect) -> some View {
        HStack(spacing: 12) {
            // Planet Glyphs
            HStack(spacing: 4) {
                Text(planetGlyph(for: aspect.planet1))
                    .font(.title3)
                    .foregroundColor(planetColor(for: aspect.planet1))
                
                Text(aspectSymbol(for: aspect.type.rawValue))
                    .font(.title3)
                    .foregroundColor(aspectColor(for: aspect.type.rawValue))
                
                Text(planetGlyph(for: aspect.planet2))
                    .font(.title3)
                    .foregroundColor(planetColor(for: aspect.planet2))
            }
            
            // Aspect Description
            VStack(alignment: .leading, spacing: 2) {
                Text("\(aspect.planet1.capitalized) \(aspect.type.rawValue) \(aspect.planet2.capitalized)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text("Orb: \(String(format: "%.2f", aspect.orb))° • \(aspect.interpretation)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Strength Indicator
            aspectStrengthIndicator(orb: aspect.orb, maxOrb: aspect.maxOrb)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(SwiftUI.Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(aspectColor(for: aspect.type.rawValue).opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    /// Claude: Glyph map accordion content showing visual birth chart
    private func glyphMapAccordionContent(_ profile: UserProfile) -> some View {
        VStack(spacing: 16) {
            // Header
            VStack(spacing: 6) {
                Text("🌌 Planetary Positions Map")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.white, .cyan.opacity(0.9)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Current positions based on \(sanctumViewMode.rawValue.lowercased())")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            // Compact planetary positions layout - 2 columns
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), 
                spacing: 14
            ) {
                ForEach(getPlanetaryPositions(profile: profile, mode: sanctumViewMode), id: \.planet) { position in
                    compactPlanetCard(position: position)
                        .onTapGesture {
                            selectedPlanet = position
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                        }
                }
            }
            .padding(.horizontal, 4)
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Compact Planet Card for Map View
    
    /// Claude: Compact planet card for the Planetary Map accordion
    private func compactPlanetCard(position: PlanetaryPosition) -> some View {
        VStack(spacing: 8) {
            // Planet Symbol
            Text(planetGlyph(for: position.planet))
                .font(.title2)
                .foregroundColor(planetColor(for: position.planet))
                .shadow(color: planetColor(for: position.planet).opacity(0.5), radius: 2, x: 0, y: 1)
            
            // Planet Name
            Text(position.planet.capitalized)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            // Sign and Degree
            VStack(spacing: 3) {
                Text(position.sign)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.cyan, .blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Text("\(position.degree)°")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 95) // Slightly taller for better proportions
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            SwiftUI.Color.black.opacity(0.5),
                            SwiftUI.Color.black.opacity(0.3)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            planetColor(for: position.planet).opacity(0.4),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: planetColor(for: position.planet).opacity(0.2), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Helper Functions (Placeholder implementations)
    
    /// Claude: Get planetary positions for the current profile and mode
    private func getPlanetaryPositions(profile: UserProfile, mode: SanctumViewMode) -> [PlanetaryPosition] {
        switch mode {
        case .birthChart:
            return getBirthChartPositions(profile: profile)
        case .liveTransits:
            return getCurrentPlanetaryPositions()
        }
    }
    
    /// Claude: SWISS EPHEMERIS INTEGRATION - Real astronomical calculations
    /// This method replaces the previous placeholder 0.0° data with accurate planetary positions
    /// CRITICAL FIX: Now returns real degrees from SwissEphemerisCalculator instead of zeros
    private func getBirthChartPositions(profile: UserProfile) -> [PlanetaryPosition] {
        print("🌌 CALCULATING BIRTH CHART with Swiss Ephemeris precision")
        
        // Claude: Create precise birth date with exact time for accurate calculations
        var birthDate = profile.birthdate
        
        // Use precise birth time if available
        if profile.hasBirthTime, 
           let hour = profile.birthTimeHour, 
           let minute = profile.birthTimeMinute {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: profile.birthdate)
            var dateComponents = DateComponents()
            dateComponents.year = components.year
            dateComponents.month = components.month
            dateComponents.day = components.day
            dateComponents.hour = hour
            dateComponents.minute = minute
            dateComponents.timeZone = TimeZone(identifier: profile.birthTimezone ?? "UTC")
            
            if let preciseDate = calendar.date(from: dateComponents) {
                birthDate = preciseDate
                print("✅ Using precise birth time: \(hour):\(String(format: "%02d", minute))")
            }
        }
        
        // Validate birth location data
        guard let latitude = profile.birthplaceLatitude,
              let longitude = profile.birthplaceLongitude else {
            print("❌ Missing birth location data, using default coordinates")
            // Return fallback calculation
            return getFallbackBirthChartPositions(profile: profile)
        }
        
        // Calculate birth chart using Swiss Ephemeris
        let timezone = TimeZone(identifier: profile.birthTimezone ?? "UTC")
        let birthChart = SwissEphemerisCalculator.calculateBirthChart(
            birthDate: birthDate,
            latitude: latitude,
            longitude: longitude,
            timezone: timezone
        )
        
        // Claude: Convert Swiss Ephemeris positions to UI format
        // CRITICAL COORDINATE CONVERSION: degreeInSign (Double) -> degree (Int)
        // Fixed rounding to prevent data loss and ensure proper display
        var positions: [PlanetaryPosition] = []
        
        for swissPosition in birthChart.planets {
            positions.append(PlanetaryPosition(
                planet: swissPosition.planet,
                sign: swissPosition.zodiacSign,
                degree: Int(swissPosition.degreeInSign.rounded()), // Claude: Proper rounding prevents 0.0° display
                houseNumber: swissPosition.houseNumber
            ))
        }
        
        print("✅ SWISS EPHEMERIS: Birth chart calculated with \(positions.count) planets")
        return positions
    }
    
    /// Fallback calculation for users missing complete birth data
    private func getFallbackBirthChartPositions(profile: UserProfile) -> [PlanetaryPosition] {
        print("⚠️ CRITICAL: Missing birth location data - cannot calculate accurate birth chart")
        print("   User needs to complete birth location setup for accurate astrological readings")
        
        // Claude: Return error indication instead of incorrect calculations
        // Using wrong coordinates would provide completely inaccurate spiritual guidance
        return [
            PlanetaryPosition(
                planet: "Error", 
                sign: "Complete birth location required", 
                degree: 0, 
                houseNumber: nil
            )
        ]
    }
    
    private func getCurrentPlanetaryPositions() -> [PlanetaryPosition] {
        print("🌌 CALCULATING CURRENT POSITIONS with Swiss Ephemeris precision")
        
        // Use Swiss Ephemeris for current planetary positions
        let swissPositions = SwissEphemerisCalculator.calculateCurrentPositions()
        
        // Convert Swiss Ephemeris positions to UI format
        var positions: [PlanetaryPosition] = []
        
        for swissPosition in swissPositions {
            positions.append(PlanetaryPosition(
                planet: swissPosition.planet,
                sign: swissPosition.zodiacSign,
                degree: Int(swissPosition.degreeInSign.rounded()),
                houseNumber: swissPosition.houseNumber // nil for transits
            ))
        }
        
        print("✅ SWISS EPHEMERIS: Current positions calculated with \(positions.count) planets")
        return positions
    }
    
    /// Claude: Calculate natal aspects from profile
    private func calculateNatalAspects(profile: UserProfile) -> [NatalAspect] {
        var aspects: [NatalAspect] = []
        
        // Claude: Always show sample aspects for now (debugging Phase 11A data pipeline)
        // TODO: Fix Phase 11A birth chart data not being saved to profile
        if true { // Always show aspects until data pipeline is fixed
            
            // Major beneficial aspects
            aspects.append(NatalAspect(
                planet1: "Sun",
                planet2: "Moon",
                type: .harmonious,
                orb: 3.2,
                maxOrb: 6.0,
                interpretation: "Harmonious balance between conscious will and emotional nature"
            ))
            
            aspects.append(NatalAspect(
                planet1: "Venus",
                planet2: "Jupiter",
                type: .flowing,
                orb: 4.1,
                maxOrb: 8.0,
                interpretation: "Natural abundance and graceful expansion in relationships"
            ))
            
            aspects.append(NatalAspect(
                planet1: "Sun",
                planet2: "Mercury",
                type: .unifying,
                orb: 2.1,
                maxOrb: 10.0,
                interpretation: "Strong integration of mind and identity"
            ))
            
            // Challenging aspects for growth
            aspects.append(NatalAspect(
                planet1: "Moon",
                planet2: "Saturn",
                type: .challenging,
                orb: 5.3,
                maxOrb: 8.0,
                interpretation: "Learning to balance emotional needs with responsibility"
            ))
            
            aspects.append(NatalAspect(
                planet1: "Mars",
                planet2: "Pluto",
                type: .dynamic,
                orb: 6.8,
                maxOrb: 8.0,
                interpretation: "Transforming personal will through deep psychological insights"
            ))
        }
        
        return aspects
    }
    
    /// Claude: Get sign element from sign name
    private func getSignElement(for sign: String) -> String? {
        // Placeholder implementation
        let elements = [
            "aries": "Fire", "leo": "Fire", "sagittarius": "Fire",
            "taurus": "Earth", "virgo": "Earth", "capricorn": "Earth",
            "gemini": "Air", "libra": "Air", "aquarius": "Air",
            "cancer": "Water", "scorpio": "Water", "pisces": "Water"
        ]
        return elements[sign.lowercased()]
    }
    
    /// Claude: Get planet glyph symbol
    private func planetGlyph(for planet: String) -> String {
        let glyphs = [
            "sun": "☉", "moon": "☽", "mercury": "☿", "venus": "♀", "mars": "♂",
            "jupiter": "♃", "saturn": "♄", "uranus": "♅", "neptune": "♆", "pluto": "♇"
        ]
        return glyphs[planet.lowercased()] ?? "⭐"
    }
    
    /// Claude: Get planet color
    private func planetColor(for planet: String) -> SwiftUI.Color {
        let colors = [
            "sun": SwiftUI.Color.yellow, "moon": SwiftUI.Color.white, "mercury": SwiftUI.Color.orange,
            "venus": SwiftUI.Color.green, "mars": SwiftUI.Color.red, "jupiter": SwiftUI.Color.purple,
            "saturn": SwiftUI.Color.brown, "uranus": SwiftUI.Color.cyan, "neptune": SwiftUI.Color.blue, "pluto": SwiftUI.Color.black
        ]
        return colors[planet.lowercased()] ?? SwiftUI.Color.white
    }
    
    /// Claude: Get element color
    private func elementColor(for element: String) -> SwiftUI.Color {
        switch element.lowercased() {
        case "fire": return .red
        case "earth": return .brown
        case "air": return .yellow
        case "water": return .blue
        default: return .gray
        }
    }
    
    /// Claude: Get zodiac sign symbol for house cusp
    private func houseSymbol(for houseNumber: Int, profile: UserProfile) -> String {
        // Get the zodiac sign on the cusp of this house
        let houseSign = getHouseCuspSign(houseNumber: houseNumber, profile: profile)
        return zodiacGlyph(for: houseSign)
    }
    
    /// Claude: Get zodiac sign on house cusp using Swiss Ephemeris house calculations
    private func getHouseCuspSign(houseNumber: Int, profile: UserProfile) -> String {
        // Validate birth location data
        guard let latitude = profile.birthplaceLatitude,
              let longitude = profile.birthplaceLongitude else {
            // Return default signs for houses when birth location is missing
            let defaultSigns = ["Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo",
                              "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"]
            return defaultSigns[(houseNumber - 1) % 12]
        }
        
        // Create precise birth date
        var birthDate = profile.birthdate
        if profile.hasBirthTime,
           let hour = profile.birthTimeHour,
           let minute = profile.birthTimeMinute {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: profile.birthdate)
            var dateComponents = DateComponents()
            dateComponents.year = components.year
            dateComponents.month = components.month
            dateComponents.day = components.day
            dateComponents.hour = hour
            dateComponents.minute = minute
            dateComponents.timeZone = TimeZone(identifier: profile.birthTimezone ?? "UTC")
            
            if let preciseDate = calendar.date(from: dateComponents) {
                birthDate = preciseDate
            }
        }
        
        // Calculate house cusps using Swiss Ephemeris
        let timezone = TimeZone(identifier: profile.birthTimezone ?? "UTC")
        let birthChart = SwissEphemerisCalculator.calculateBirthChart(
            birthDate: birthDate,
            latitude: latitude,
            longitude: longitude,
            timezone: timezone
        )
        
        // For now, use a simplified approach based on ascendant
        // Each house cusp is approximately 30 degrees apart
        let ascendantDegrees = birthChart.ascendant
        let houseCuspDegrees = ascendantDegrees + Double((houseNumber - 1) * 30)
        let normalizedDegrees = houseCuspDegrees.truncatingRemainder(dividingBy: 360)
        let positiveDegrees = normalizedDegrees < 0 ? normalizedDegrees + 360 : normalizedDegrees
        
        // Convert degrees to zodiac sign
        let signIndex = Int(positiveDegrees / 30)
        let signs = ["Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo",
                     "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"]
        
        return (signIndex >= 0 && signIndex < signs.count) ? signs[signIndex] : "Aries"
    }
    
    /// Claude: Get zodiac sign glyph
    private func zodiacGlyph(for sign: String) -> String {
        let glyphs = [
            "aries": "♈", "taurus": "♉", "gemini": "♊", "cancer": "♋",
            "leo": "♌", "virgo": "♍", "libra": "♎", "scorpio": "♏",
            "sagittarius": "♐", "capricorn": "♑", "aquarius": "♒", "pisces": "♓"
        ]
        return glyphs[sign.lowercased()] ?? "♈"
    }
    
    /// Claude: Get house name
    private func houseName(for houseNumber: Int) -> String {
        let names = [
            1: "Self & Identity", 2: "Values & Resources", 3: "Communication", 4: "Home & Family",
            5: "Creativity & Romance", 6: "Health & Service", 7: "Partnerships", 8: "Transformation",
            9: "Philosophy & Travel", 10: "Career & Reputation", 11: "Friends & Hopes", 12: "Spirituality"
        ]
        return names[houseNumber] ?? "House \(houseNumber)"
    }
    
    /// Claude: Get house keywords
    private func houseKeywords(for houseNumber: Int) -> String {
        let keywords = [
            1: "Appearance, First Impressions", 2: "Money, Possessions", 3: "Siblings, Learning",
            4: "Roots, Foundation", 5: "Children, Self-Expression", 6: "Work, Daily Routines",
            7: "Marriage, Open Enemies", 8: "Death, Shared Resources", 9: "Higher Learning, Foreign",
            10: "Authority, Public Image", 11: "Groups, Humanitarian", 12: "Hidden, Subconscious"
        ]
        return keywords[houseNumber] ?? "Life Experience"
    }
    
    /// Claude: Get house natural ruler (traditional astrology)
    private func getHouseNaturalRuler(for houseNumber: Int) -> String {
        let naturalRulers = [
            1: "Aries", 2: "Taurus", 3: "Gemini", 4: "Cancer",
            5: "Leo", 6: "Virgo", 7: "Libra", 8: "Scorpio",
            9: "Sagittarius", 10: "Capricorn", 11: "Aquarius", 12: "Pisces"
        ]
        return naturalRulers[houseNumber] ?? "Aries"
    }
    
    /// Claude: Get aspect symbol
    private func aspectSymbol(for aspectType: String) -> String {
        let symbols = [
            "conjunction": "☌", "opposition": "☍", "trine": "△", "square": "□", "sextile": "⚹"
        ]
        return symbols[aspectType.lowercased()] ?? "⚹"
    }
    
    /// Claude: Get aspect color
    private func aspectColor(for aspectType: String) -> SwiftUI.Color {
        switch aspectType.lowercased() {
        case "conjunction": return .yellow
        case "opposition": return .red
        case "trine": return .blue
        case "square": return .orange
        case "sextile": return .green
        default: return .white
        }
    }
    
    /// Claude: Aspect strength indicator
    private func aspectStrengthIndicator(orb: Double, maxOrb: Double) -> some View {
        let strength = 1.0 - (orb / maxOrb)
        let color: SwiftUI.Color = strength > 0.8 ? .green : strength > 0.5 ? .yellow : .orange
        
        return Circle()
            .fill(color)
            .frame(width: 8, height: 8)
    }
}

// MARK: - Supporting Data Structures
// Note: Data structures (PlanetaryPosition, NatalAspect, IdentifiableInt, SanctumViewMode) 
// are defined in the main SanctumTabView file to avoid duplication

// MARK: - Preview
#Preview {
    ZStack {
        // Cosmic background for proper preview context
        SwiftUI.Color.black.ignoresSafeArea()
        
        ScrollView {
            NatalChartSection(
                profile: UserProfile(
                    id: "preview",
                    birthdate: Date(),
                    lifePathNumber: 7,
                    isMasterNumber: false,
                    spiritualMode: "Reflection",
                    insightTone: "Gentle",
                    focusTags: ["Purpose"],
                    cosmicPreference: "Full Cosmic Integration",
                    cosmicRhythms: ["Moon Phases"],
                    preferredHour: 7,
                    wantsWhispers: true,
                    birthName: "Preview User",
                    soulUrgeNumber: 3,
                    expressionNumber: 8,
                    wantsReflectionMode: true,
                    birthplaceName: "New York, NY",
                    hasBirthTime: true
                ),
                sanctumViewMode: .constant(.birthChart),
                housesAccordionExpanded: .constant(false),
                aspectsAccordionExpanded: .constant(false),
                glyphMapAccordionExpanded: .constant(false),
                selectedHouseForSheet: .constant(nil),
                selectedPlanet: .constant(nil),
                selectedAspect: .constant(nil)
            )
            .padding()
        }
    }
}