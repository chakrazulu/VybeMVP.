/**
 * Filename: RulingNumberChartDetailView.swift
 * 
 * Purpose: Full-screen detailed view of the ruling number chart with time-range controls
 * Provides deep insights into ruling number patterns and sacred cycles
 */

import SwiftUI

/**
 * Full-screen detailed ruling number chart with time-range controls and enhanced analytics
 */
struct RulingNumberChartDetailView: View {
    @StateObject private var sampleManager = RealmSampleManager.shared
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    @EnvironmentObject var realmNumberManager: RealmNumberManager
    
    @State private var selectedTimeRange: ChartTimeRange = .oneDay
    @State private var selectedDataPoint: ChartDataPoint? = nil
    @State private var showingTooltip = false
    @State private var chartAnimationPhase = 0.0
    @State private var sacredCycleHighlight = false
    @State private var rulingBarPulse = false
    @State private var showingSacredPatternDetail = false
    @State private var selectedSacredPattern: SacredPatternType? = nil
    
    @Binding var isPresented: Bool
    
    var chartData: [ChartDataPoint] {
        sampleManager.getChartData(for: selectedTimeRange)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Cosmic background
                cosmicBackground
                
                ScrollView {
                    VStack(spacing: selectedTimeRange == .oneDay ? 40 : 32) {
                        // Header with time range picker
                        headerSection
                        
                        // Main chart area
                        chartSection
                        
                        // Sacred cycles section
                        if selectedTimeRange != .oneDay {
                            sacredCyclesSection
                        }
                        
                        // Insights section
                        insightsSection
                        
                        Spacer(minLength: 120)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("✧ Ruling Number ✧")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                    .foregroundColor(.white)
                    .font(.headline)
                }
            }
        }
        .onAppear {
            startChartAnimations()
            configureNavigationAppearance()
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Background
    
    private var cosmicBackground: some View {
        ZStack {
            // Base cosmic background
            LinearGradient(
                colors: [
                    Color.black,
                    Color.purple.opacity(0.3),
                    Color.blue.opacity(0.2),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Subtle moving particles
            ForEach(0..<20, id: \.self) { _ in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 2, height: 2)
                    .offset(
                        x: CGFloat.random(in: -200...200),
                        y: CGFloat.random(in: -400...400)
                    )
                    .animation(
                        .linear(duration: Double.random(in: 10...20))
                        .repeatForever(autoreverses: false),
                        value: chartAnimationPhase
                    )
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 28) {
            // Current ruling number display
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    getSacredColor(for: sampleManager.rulingNumber).opacity(0.8),
                                    getSacredColor(for: sampleManager.rulingNumber).opacity(0.3)
                                ],
                                center: .center,
                                startRadius: 10,
                                endRadius: 40
                            )
                        )
                        .frame(width: 80, height: 80)
                        .scaleEffect(sacredCycleHighlight ? 1.1 : 1.0)
                        .shadow(color: getSacredColor(for: sampleManager.rulingNumber).opacity(0.6), radius: 15)
                    
                    Text("\(sampleManager.rulingNumber)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current Ruling Number")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(getRulingDescription(sampleManager.rulingNumber))
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                // Trophy if it's the ruling number
                if sampleManager.getCount(for: sampleManager.rulingNumber) > 0 {
                    Image(systemName: "crown.fill")
                        .font(.title2)
                        .foregroundColor(.yellow)
                        .shadow(color: .yellow.opacity(0.6), radius: 5)
                        .scaleEffect(sacredCycleHighlight ? 1.1 : 1.0)
                }
            }
            .padding(.horizontal, 8)
            
            // Time range picker
            VStack(alignment: .leading, spacing: 12) {
                Text("Time Range")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 8)
                
                HStack(spacing: 4) {
                    ForEach(ChartTimeRange.allCases, id: \.self) { range in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTimeRange = range
                            }
                        }) {
                            VStack(spacing: 6) {
                                Text(range.rawValue)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(selectedTimeRange == range ? .black : .white.opacity(0.7))
                                
                                Text(range.title)
                                    .font(.caption)
                                    .foregroundColor(selectedTimeRange == range ? .black.opacity(0.7) : .white.opacity(0.5))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selectedTimeRange == range ? 
                                          Color.white.opacity(0.9) : 
                                          Color.white.opacity(0.1))
                            )
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal, 4)
            }
        }
    }
    
    // MARK: - Chart Section
    
    private var chartSection: some View {
        VStack(spacing: 24) {
            Text("✧ \(selectedTimeRange.title) Pattern ✧")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Group {
                switch selectedTimeRange {
                case .oneDay:
                    dailyHistogramChart
                case .sevenDays, .fourteenDays, .thirtyDays:
                    timeSeriesChart
                }
            }
            .frame(height: selectedTimeRange == .oneDay ? 480 : 340)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.4))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [.purple.opacity(0.5), .blue.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.5), radius: 10)
        }
        .padding(.horizontal, 4)
        .padding(.bottom, 16)
    }
    
    // MARK: - Daily Histogram (1D view)
    
    private var dailyHistogramChart: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width - 48 // Increased padding for right-side content
            let barTrackWidth = availableWidth * 0.58 // Reduced to leave more space for badges
            
            VStack(spacing: 12) {
                // Enhanced version of existing histogram
                ForEach(1...9, id: \.self) { number in
                    let count = sampleManager.getCount(for: number)
                    let maxCount = max(chartData.map { $0.value }.max() ?? 1, 1)
                    let barProgress = count > 0 ? CGFloat(count) / CGFloat(maxCount) : 0
                    let barWidth = barProgress * barTrackWidth
                    let isRuling = number == sampleManager.rulingNumber && count > 0
                    let isFocus = number == focusNumberManager.selectedFocusNumber
                    
                    HStack(alignment: .center, spacing: 14) {
                        // Number circle - fixed position, no scaling
                        ZStack {
                            Circle()
                                .fill(getSacredColor(for: number).opacity(0.8))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            isRuling ? Color.yellow : 
                                            isFocus ? Color.cyan : Color.clear,
                                            lineWidth: isRuling || isFocus ? 2 : 0
                                        )
                                )
                                .shadow(color: getSacredColor(for: number).opacity(0.5), radius: 6)
                                .opacity(isRuling && sacredCycleHighlight ? 0.9 : 0.8) // Opacity pulse instead of scale
                            
                            Text("\(number)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        // Progress bar container - fixed alignment
                        HStack(spacing: 0) {
                            ZStack(alignment: .leading) {
                                // Background track
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white.opacity(0.1))
                                    .frame(width: barTrackWidth, height: 16)
                                
                                // Progress bar
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        LinearGradient(
                                            colors: isRuling ? [
                                                getSacredColor(for: number).opacity(0.9),
                                                getSacredColor(for: number).opacity(0.6),
                                                .yellow.opacity(0.3)
                                            ] : [
                                                getSacredColor(for: number).opacity(0.7),
                                                getSacredColor(for: number).opacity(0.4)
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(
                                        width: max(barWidth * chartAnimationPhase, count > 0 ? 20 : 0),
                                        height: 16
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(
                                                isRuling ? Color.yellow.opacity(0.8) : Color.clear,
                                                lineWidth: isRuling ? 2 : 0
                                            )
                                    )
                                    .shadow(
                                        color: isRuling ? .yellow.opacity(0.4) : getSacredColor(for: number).opacity(0.3),
                                        radius: isRuling ? 8 : 4
                                    )
                                    .scaleEffect(
                                        isRuling && rulingBarPulse ? 1.02 : 1.0
                                    )
                            }
                            
                            Spacer(minLength: 16)
                            
                            // Count and badges - fixed width area
                            HStack(spacing: 8) {
                                Text("\(count)")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(isRuling ? .yellow : .white)
                                    .frame(minWidth: 20, alignment: .trailing)
                                
                                HStack(spacing: 4) {
                                    if isRuling {
                                        Image(systemName: "crown.fill")
                                            .font(.caption)
                                            .foregroundColor(.yellow)
                                            .opacity(sacredCycleHighlight ? 1.0 : 0.8) // Opacity pulse
                                    }
                                    
                                    if isFocus {
                                        Image(systemName: "target")
                                            .font(.caption)
                                            .foregroundColor(.cyan)
                                    }
                                }
                                .frame(minWidth: 28, alignment: .leading)
                            }
                        }
                    }
                    .onTapGesture {
                        handleNumberTap(number)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
    }
    
    // MARK: - Time Series Chart (7D, 14D, 30D views)
    
    private var timeSeriesChart: some View {
        VStack(spacing: 16) {
            // Chart legend
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(1...9, id: \.self) { number in
                        HStack(spacing: 6) {
                            Circle()
                                .fill(getSacredColor(for: number))
                                .frame(width: 8, height: 8)
                            Text("\(number)")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.white.opacity(0.1))
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
            
            // Line chart visualization
            GeometryReader { geometry in
                let chartWidth = geometry.size.width - 40
                let chartHeight = geometry.size.height - 40
                
                ZStack {
                    // Grid lines
                    Path { path in
                        for i in 0...5 {
                            let y = 20 + (chartHeight / 5) * CGFloat(i)
                            path.move(to: CGPoint(x: 20, y: y))
                            path.addLine(to: CGPoint(x: 20 + chartWidth, y: y))
                        }
                    }
                    .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                    
                    // Data lines for each number
                    ForEach(1...9, id: \.self) { number in
                        let numberData = chartData.filter { $0.number == number }
                        
                        if !numberData.isEmpty {
                            Path { path in
                                for (index, dataPoint) in numberData.enumerated() {
                                    let x = 20 + (chartWidth / CGFloat(max(chartData.count - 1, 1))) * CGFloat(index)
                                    let y = 20 + chartHeight - (chartHeight * CGFloat(dataPoint.value) / 10.0)
                                    
                                    if index == 0 {
                                        path.move(to: CGPoint(x: x, y: y))
                                    } else {
                                        path.addLine(to: CGPoint(x: x, y: y))
                                    }
                                }
                            }
                            .trim(from: 0, to: chartAnimationPhase)
                            .stroke(
                                getSacredColor(for: number).opacity(0.8),
                                style: StrokeStyle(lineWidth: 2, lineCap: .round)
                            )
                            .shadow(color: getSacredColor(for: number).opacity(0.3), radius: 2)
                        }
                    }
                    
                    // Data points
                    ForEach(Array(chartData.enumerated()), id: \.offset) { index, dataPoint in
                        if chartData.count > 1 {
                            let x = 20 + (chartWidth / CGFloat(chartData.count - 1)) * CGFloat(index)
                            let y = 20 + chartHeight - (chartHeight * CGFloat(dataPoint.value) / 10.0)
                            
                            Circle()
                                .fill(getSacredColor(for: dataPoint.number))
                                .frame(width: 6, height: 6)
                                .position(x: x, y: y)
                                .scaleEffect(chartAnimationPhase)
                                .onTapGesture {
                                    selectedDataPoint = dataPoint
                                    showingTooltip = true
                                }
                        }
                    }
                }
            }
        }
        .padding(20)
    }
    
    // MARK: - Sacred Cycles Section
    
    private var sacredCyclesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("✧ Sacred Patterns ✧")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
            
            VStack(spacing: 12) {
                // Seven-day harmony
                enhancedSacredPatternCard(.sevenDay)
                
                // Golden flow (divine proportion)
                enhancedSacredPatternCard(.goldenFlow)
                
                // Fibonacci spiral (always show for multi-day views)
                enhancedSacredPatternCard(.fibonacciSpiral)
                
                // Trinity flow (3-6-9 pattern)
                enhancedSacredPatternCard(.trinityFlow)
                
                // Lunar sync (only for 30-day view)
                if selectedTimeRange == .thirtyDays {
                    enhancedSacredPatternCard(.lunarSync)
                }
            }
            .padding(.horizontal, 8)
        }
        .sheet(isPresented: $showingSacredPatternDetail) {
            if let pattern = selectedSacredPattern {
                SacredPatternDetailView(
                    pattern: pattern,
                    sampleManager: sampleManager,
                    isPresented: $showingSacredPatternDetail
                )
            }
        }
    }
    
    private func enhancedSacredPatternCard(_ patternType: SacredPatternType) -> some View {
        let value = patternType.getValue(from: sampleManager)
        let percentage = Int(value * 100)
        
        return HStack(spacing: 16) {
            // Left side - Icon and percentage
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    patternType.color.opacity(0.3),
                                    patternType.color.opacity(0.1)
                                ],
                                center: .center,
                                startRadius: 20,
                                endRadius: 40
                            )
                        )
                        .frame(width: 60, height: 60)
                        .scaleEffect(sacredCycleHighlight ? 1.05 : 1.0)
                    
                    Image(systemName: patternType.icon)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(patternType.color)
                        .shadow(color: patternType.color.opacity(0.6), radius: 4)
                }
                
                Text("\(percentage)%")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(patternType.color)
            }
            .frame(width: 80)
            
            // Right side - Content
            VStack(alignment: .leading, spacing: 12) {
                // Title and description
                VStack(alignment: .leading, spacing: 4) {
                    Text(patternType.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(patternType.shortDescription)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.85))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                // Progress bar
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(getStrengthLabel(for: value))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(patternType.color)
                        Spacer()
                        Text("Tap for details")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.5))
                            .italic()
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 8)
                            
                            RoundedRectangle(cornerRadius: 6)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            patternType.color.opacity(0.9),
                                            patternType.color.opacity(0.6),
                                            patternType.color.opacity(0.3)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * value, height: 8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(patternType.color.opacity(0.6), lineWidth: 1)
                                )
                                .shadow(color: patternType.color.opacity(0.4), radius: 4)
                                .animation(.easeOut(duration: 2.5).delay(0.5), value: chartAnimationPhase)
                        }
                    }
                    .frame(height: 8)
                }
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.4),
                            Color.black.opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    patternType.color.opacity(0.4),
                                    patternType.color.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
        )
        .shadow(color: patternType.color.opacity(0.2), radius: 8)
        .scaleEffect(sacredCycleHighlight ? 1.02 : 1.0)
        .onTapGesture {
            selectedSacredPattern = patternType
            showingSacredPatternDetail = true
            
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }
    }
    
    // Helper function for strength labels
    private func getStrengthLabel(for value: Double) -> String {
        switch value {
        case 0.8...: return "COSMIC MASTERY"
        case 0.6..<0.8: return "STRONG ALIGNMENT"
        case 0.4..<0.6: return "EMERGING PATTERN"
        case 0.2..<0.4: return "SUBTLE INFLUENCE"
        default: return "DORMANT POTENTIAL"
        }
    }
    
    // MARK: - Insights Section
    
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("✧ Mystical Insights ✧")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
            
            VStack(spacing: 16) {
                // Trend analysis
                insightCard(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Current Trend",
                    description: sampleManager.getTrendAnalysis(for: selectedTimeRange),
                    color: .blue
                )
                
                // Focus alignment
                if focusNumberManager.selectedFocusNumber == sampleManager.rulingNumber {
                    insightCard(
                        icon: "target",
                        title: "Perfect Alignment",
                        description: "Your focus number (\(focusNumberManager.selectedFocusNumber)) is currently ruling. This is a powerful time for manifestation.",
                        color: .green
                    )
                }
                
                // Sacred number emergence
                insightCard(
                    icon: "sparkles",
                    title: "Sacred Emergence",
                    description: sampleManager.getSacredNumberInsight(),
                    color: .purple
                )
            }
            .padding(.horizontal, 8)
        }
        .padding(.top, 16)
    }
    
    private func insightCard(icon: String, title: String, description: String, color: Color) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(nil)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: color.opacity(0.2), radius: 5)
    }
    
    // MARK: - Helper Methods
    
    private func startChartAnimations() {
        withAnimation(.easeInOut(duration: 2.0)) {
            chartAnimationPhase = 1.0
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            sacredCycleHighlight = true
        }
        
        withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
            rulingBarPulse = true
        }
    }
    
    private func handleNumberTap(_ number: Int) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // Navigation to number meaning can be implemented here
        print("🔍 Detailed view: User tapped number \(number)")
    }
    
    private func getRulingDescription(_ number: Int) -> String {
        let descriptions = [
            "Genesis energy dominates your cosmic field. New beginnings and leadership emerge.",
            "Duality and balance create harmony. Cooperation and partnerships flourish.", 
            "Creative expression flows freely. Communication and artistic endeavors prosper.",
            "Foundation energy anchors your reality. Stability and systematic growth prevail.",
            "Freedom and change surge through your experience. Adventure and liberation call.",
            "Harmony and love resonate deeply. Nurturing and healing energies abound.",
            "Mystery and wisdom emerge from the depths. Spiritual insights and intuition peak.",
            "Abundance and infinite cycles manifest. Material success and karmic completion arrive.",
            "Universal completion and unity reign supreme. Highest wisdom and humanitarian service."
        ]
        
        let index = max(0, min(number - 1, descriptions.count - 1))
        return descriptions[index]
    }
    
    private func getSacredColor(for number: Int) -> Color {
        switch number {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        case 6: return .indigo
        case 7: return .purple
        case 8: return Color(red: 1.0, green: 0.8, blue: 0.0) // gold
        case 9: return .white
        default: return .white
        }
    }
    
    private func configureNavigationAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

// MARK: - Sacred Pattern Detail View

struct SacredPatternDetailView: View {
    let pattern: SacredPatternType
    let sampleManager: RealmSampleManager
    @Binding var isPresented: Bool
    
    @State private var animationPhase = 0.0
    @State private var isDataLoaded = false
    @State private var patternValue: Double = 0.0
    
    var body: some View {
        NavigationView {
            ZStack {
                // Cosmic background
                LinearGradient(
                    colors: [
                        Color.black,
                        pattern.color.opacity(0.2),
                        Color.black
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Always show content - no loading state needed
                ScrollView {
                    VStack(spacing: 24) {
                        // Pattern Header
                        patternHeader
                        
                        // Pattern Analysis
                        patternAnalysis
                        
                        // Full Description
                        patternDescription
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(pattern.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                    .foregroundColor(.white)
                    .font(.headline)
                }
            }
        }
        .onAppear {
            // Load pattern data immediately on appear
            patternValue = pattern.getValue(from: sampleManager)
            isDataLoaded = true
            
            // Start very subtle animation after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
                    animationPhase = 0.6
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    

    
    private var patternHeader: some View {
        VStack(spacing: 16) {
            // Large icon with glow
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                pattern.color.opacity(0.3),
                                pattern.color.opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 30,
                            endRadius: 80
                        )
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(animationPhase)
                
                Image(systemName: pattern.icon)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(pattern.color)
                    .shadow(color: pattern.color.opacity(0.6), radius: 10)
            }
            
            // Pattern percentage
            let percentage = Int(patternValue * 100)
            Text("\(percentage)%")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(pattern.color)
                .shadow(color: pattern.color.opacity(0.4), radius: 5)
                .opacity(animationPhase)
            
            Text("Pattern Strength")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.8))
        }
    }
    
    private var patternAnalysis: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("✧ Current Analysis ✧")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            let analysisText = getAnalysisText(for: patternValue)
            
            Text(analysisText)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
            
            // Strength indicator
            strengthIndicator(value: patternValue)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(pattern.color.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: pattern.color.opacity(0.2), radius: 8)
    }
    
    private var patternDescription: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("✧ Sacred Wisdom ✧")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(pattern.fullDescription)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(6)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(pattern.color.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: pattern.color.opacity(0.2), radius: 8)
    }
    
    private func strengthIndicator(value: Double) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Strength Level")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Spacer()
                Text(getStrengthLabel(for: value))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(pattern.color)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 12)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [
                                    pattern.color.opacity(0.9),
                                    pattern.color.opacity(0.5)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * value * animationPhase, height: 12)
                        .shadow(color: pattern.color.opacity(0.4), radius: 4)
                        .animation(.easeOut(duration: 2.5), value: animationPhase)
                }
            }
            .frame(height: 12)
        }
    }
    
    private func getStrengthLabel(for value: Double) -> String {
        switch value {
        case 0.8...: return "COSMIC MASTERY"
        case 0.6..<0.8: return "STRONG ALIGNMENT"
        case 0.4..<0.6: return "EMERGING PATTERN"
        case 0.2..<0.4: return "SUBTLE INFLUENCE"
        default: return "DORMANT POTENTIAL"
        }
    }
    
    private func getAnalysisText(for value: Double) -> String {
        let baseText = pattern.shortDescription
        
        switch value {
        case 0.8...:
            return "\(baseText)\n\nYou have achieved profound mastery of this sacred pattern. This is a time of peak spiritual alignment and manifestation power."
            
        case 0.6..<0.8:
            return "\(baseText)\n\nThis pattern is strongly active in your cosmic field. You're in harmony with these sacred frequencies and can leverage their power."
            
        case 0.4..<0.6:
            return "\(baseText)\n\nThis pattern is emerging and gaining strength. Pay attention to its influence and nurture its development through conscious alignment."
            
        case 0.2..<0.4:
            return "\(baseText)\n\nSubtle influences of this pattern are present. With focused intention, you can strengthen this sacred connection."
            
        default:
            return "\(baseText)\n\nThis pattern holds dormant potential in your field. Consider meditation and conscious practice to awaken its sacred frequencies."
        }
    }
}

// MARK: - Sacred Pattern Types

enum SacredPatternType: String, CaseIterable {
    case sevenDay = "7-Day Harmony"
    case goldenFlow = "Golden Flow"
    case lunarSync = "Lunar Sync"
    case trinityFlow = "Trinity Flow"
    case fibonacciSpiral = "Fibonacci Spiral"
    
    var title: String { rawValue }
    
    var shortDescription: String {
        switch self {
        case .sevenDay:
            return "Spiritual completion through divine seven cycles"
        case .goldenFlow:
            return "Divine proportion (1.618) harmony in cosmic flow"
        case .lunarSync:
            return "28-day mystical rhythm synchronization"
        case .trinityFlow:
            return "Tesla's 3-6-9 universal energy keys"
        case .fibonacciSpiral:
            return "Sacred sequence emergence in nature's design"
        }
    }
    
    var fullDescription: String {
        switch self {
        case .sevenDay:
            return """
            The sacred seven represents spiritual completion and divine perfection. This pattern tracks your alignment with the seven-day creation cycle, seven chakras, and seven heavenly bodies known to ancient wisdom. 
            
            When this pattern is strong, you're experiencing spiritual completion cycles that enhance your connection to higher consciousness and divine timing.
            
            Numbers 3, 6, 7, and 9 carry the highest spiritual frequencies in this pattern.
            """
            
        case .goldenFlow:
            return """
            The Golden Ratio (φ = 1.618) is nature's perfect proportion, found in galaxies, flowers, shells, and human DNA. This divine proportion creates harmony and beauty throughout the universe.
            
            Your alignment with this pattern indicates natural flow and organic growth in your life. When strong, manifestations unfold with divine timing and perfect proportions.
            
            Numbers 1, 5, and 8 resonate most powerfully with this golden frequency.
            """
            
        case .lunarSync:
            return """
            The lunar cycle governs tides, emotions, and mystical rhythms across 28 days. This pattern tracks your synchronization with lunar wisdom and feminine divine energy.
            
            Strong lunar alignment enhances intuition, emotional balance, and receptive wisdom. Your cycles become harmonized with natural rhythms.
            
            Numbers 2, 6, and 9 carry the strongest lunar resonance and feminine divine frequencies.
            """
            
        case .trinityFlow:
            return """
            Nikola Tesla declared: "If you only knew the magnificence of 3, 6, and 9, then you would have a key to the universe." These numbers form the divine triangle of creation.
            
            3 = Creative expression and divine trinity
            6 = Perfect harmony and divine love  
            9 = Universal completion and highest wisdom
            
            When this pattern activates, you access universal energy keys and accelerated manifestation power.
            """
            
        case .fibonacciSpiral:
            return """
            The Fibonacci sequence (1,1,2,3,5,8,13...) appears throughout nature: flower petals, pine cones, nautilus shells, and galaxy spirals. Each number is the sum of the two preceding ones.
            
            This pattern reveals natural growth, organic expansion, and divine mathematical harmony in your realm samples. When active, your life unfolds with natural perfection.
            
            Sequences like 1→2→3, 2→3→5, or 3→5→8 indicate powerful Fibonacci activation in your cosmic field.
            """
        }
    }
    
    var color: Color {
        switch self {
        case .sevenDay: return .purple
        case .goldenFlow: return .yellow
        case .lunarSync: return .blue
        case .trinityFlow: return .green
        case .fibonacciSpiral: return .orange
        }
    }
    
    var icon: String {
        switch self {
        case .sevenDay: return "star.fill"
        case .goldenFlow: return "infinity"
        case .lunarSync: return "moon.fill"
        case .trinityFlow: return "triangle.fill"
        case .fibonacciSpiral: return "tornado"
        }
    }
    
    func getValue(from manager: RealmSampleManager) -> Double {
        switch self {
        case .sevenDay: return manager.getSevenDayPattern()
        case .goldenFlow: return manager.getGoldenRatioAlignment()
        case .lunarSync: return manager.getLunarAlignment()
        case .trinityFlow: return manager.getTrinityPattern()
        case .fibonacciSpiral: return manager.getFibonacciPattern()
        }
    }
}

// MARK: - Preview

struct RulingNumberChartDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RulingNumberChartDetailView(isPresented: .constant(true))
            .environmentObject(FocusNumberManager.shared)
            .environmentObject(RealmNumberManager())
    }
} 