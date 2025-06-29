/*
 * ========================================
 * 📊 RULING NUMBER CHART DETAIL VIEW - SACRED PATTERN ANALYTICS
 * ========================================
 * 
 * CORE PURPOSE:
 * Advanced sacred pattern visualization system providing comprehensive ruling number
 * analytics with time-range controls, mystical percentage calculations, and deep
 * spiritual insights through interactive charts and cosmic pattern recognition.
 * Core component for understanding numerical synchronicities and sacred cycles.
 * 
 * UI SPECIFICATIONS:
 * - Background: Multi-layer cosmic gradient with animated particles
 * - Header: 80×80pt ruling number circle with radial gradient and crown icon
 * - Time Range Picker: 4-button segmented control (1D, 7D, 14D, 30D)
 * - Chart Area: 320pt height with rounded 16pt corners and gradient borders
 * - Sacred Pattern Cards: 20pt padding with percentage bars and cosmic icons
 * 
 * CHART VISUALIZATION SYSTEM:
 * - Daily Histogram: Horizontal scrolling bars for numbers 1-9
 * - Time Series: Multi-day ruling number progression charts
 * - Progress Bars: Animated height-based visualization with sacred colors
 * - Interactive Selection: Tap-to-select with haptic feedback and detail overlays
 * - Animation System: 1.0s ease-in-out with staggered chart animations
 * 
 * SACRED PATTERN ANALYSIS:
 * - Seven-Day Harmony: Spiritual completion cycle tracking (7-day patterns)
 * - Golden Flow: Divine proportion (1.618) alignment analysis
 * - Fibonacci Spiral: Sacred sequence emergence in numerical patterns
 * - Trinity Flow: Tesla's 3-6-9 universal energy key detection
 * - Lunar Sync: 28-day mystical rhythm synchronization (30-day view only)
 * 
 * PERCENTAGE CALCULATION SYSTEM:
 * - Pattern Values: Pre-calculated sacred pattern percentages (0-100%)
 * - Intensity Scoring: 0.0-1.0 range with 0.5 minimum threshold
 * - Strength Labels: "COSMIC MASTERY" (80%+), "STRONG ALIGNMENT" (60-80%), etc.
 * - Progress Visualization: Geometric width-based percentage bars
 * - Real-time Updates: Dynamic recalculation based on time range selection
 * 
 * STATE MANAGEMENT:
 * - @StateObject sampleManager: RealmSampleManager.shared for data access
 * - @State patternValues: Pre-calculated sacred pattern percentages cache
 * - @State patternsCalculated: Boolean flag for calculation completion
 * - @State selectedTimeRange: Current chart time range (1D/7D/14D/30D)
 * - @State selectedSacredPattern: Current pattern for detail overlay
 * 
 * PERFORMANCE OPTIMIZATIONS:
 * - Pattern Pre-calculation: Background calculation prevents UI blocking
 * - Animation Phases: chartAnimationPhase controls staggered animations
 * - Cached Values: patternValues dictionary prevents repeated calculations
 * - Lazy Loading: Patterns calculated only when needed
 * - Memory Management: Proper cleanup and resource management
 * 
 * INTEGRATION POINTS:
 * - RealmSampleManager: Core data source for ruling number calculations
 * - FocusNumberManager: Focus number highlighting and interaction
 * - RealmNumberManager: Real-time realm number integration
 * - NumberDetailOverlay: Full-screen number analysis with statistics
 * - UltraMinimalPatternOverlay: Sacred pattern detail exploration
 * 
 * CHART INTERACTION SYSTEM:
 * - Number Selection: Tap individual bars for detailed analysis
 * - Pattern Exploration: Tap sacred pattern cards for full-screen details
 * - Time Range Control: Segmented picker for temporal analysis
 * - Haptic Feedback: Medium impact feedback on interactions
 * - Visual Feedback: Scale effects and color changes on selection
 * 
 * SACRED COLOR MAPPING:
 * - Number 1: Red (Creation/Fire)
 * - Number 2: Orange (Partnership/Balance)
 * - Number 3: Yellow (Expression/Joy)
 * - Number 4: Green (Foundation/Earth)
 * - Number 5: Blue (Freedom/Sky)
 * - Number 6: Indigo (Harmony/Love)
 * - Number 7: Purple (Spirituality/Wisdom)
 * - Number 8: Gold (#FFD700) (Abundance/Prosperity)
 * - Number 9: White (Completion/Universal)
 * 
 * CHART TYPES:
 * - Daily Histogram: Vertical bars showing number frequency distribution
 * - Time Series: Multi-day ruling number progression over time
 * - Progress Bars: Height-animated bars with sacred color gradients
 * - Interactive Elements: Crown icons for ruling numbers, target for focus
 * - Statistics Summary: Total count, ruling number, and frequency display
 * 
 * SACRED PATTERN CARD DESIGN:
 * - Left Section: 60×60pt pattern icon circle with sacred color
 * - Percentage Display: Large percentage text with pattern color
 * - Right Section: Pattern title, description, and progress bar
 * - Progress Bar: Geometric width calculation based on pattern value
 * - Gradient Borders: Pattern-specific color gradients with opacity
 * 
 * ANIMATION SPECIFICATIONS:
 * - Chart Animation: 1.0s ease-in-out for initial load
 * - Sacred Cycle Highlight: 3.0s repeat forever with auto-reverse
 * - Ruling Bar Pulse: 2.5s repeat forever for crown highlighting
 * - Selection Animation: 0.4s spring response with 0.8 damping
 * - Pattern Animation: 2.5s ease-out with 0.5s delay
 * 
 * TIME RANGE ANALYSIS:
 * - One Day: Detailed hourly distribution histogram
 * - Seven Days: Weekly spiritual completion cycle analysis
 * - Fourteen Days: Bi-weekly trend analysis with spiritual/material balance
 * - Thirty Days: Monthly cosmic pattern recognition with lunar sync
 * 
 * PATTERN DETAIL OVERLAY SYSTEM:
 * - Ultra-Minimal Design: Zero-delay fullscreen presentation
 * - Pre-calculated Data: Uses cached values for instant display
 * - Scrollable Content: Full pattern descriptions with sacred wisdom
 * - Strength Indicators: Visual dot indicators for pattern intensity
 * - Educational Content: Complete spiritual meaning and guidance
 * 
 * ERROR HANDLING & RESILIENCE:
 * - Empty Data Handling: Graceful fallbacks for missing chart data
 * - Calculation Guards: Prevents division by zero and invalid ranges
 * - Animation Safety: Proper cleanup prevents memory leaks
 * - State Validation: Ensures consistent UI state across interactions
 * - Background Calculation: Non-blocking pattern analysis
 * 
 * TECHNICAL SPECIFICATIONS:
 * - Chart Height: 320pt for all chart types
 * - Bar Width: 20pt for progress bars, 40pt for histogram bars
 * - Animation Duration: 1.0s for charts, 2.5s for patterns
 * - Percentage Range: 0-100% display with 0.0-1.0 internal calculation
 * - Color Opacity: 0.9 primary, 0.6 secondary for gradient effects
 * 
 * DEBUGGING & MONITORING:
 * - Pattern Calculation Logging: Detailed background calculation tracking
 * - Selection Feedback: Console logging for user interaction validation
 * - Performance Metrics: Animation phase and calculation timing
 * - State Validation: Pattern calculation completion monitoring
 * - User Interaction: Tap gesture and selection state tracking
 */

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
    @State private var selectedSacredPattern: SacredPatternType?
    
    // PERFORMANCE FIX: Pre-calculate all pattern values once to prevent simultaneous expensive calculations
    @State private var patternValues: [SacredPatternType: Double] = [:]
    @State private var patternsCalculated = false
    
    @Binding var isPresented: Bool
    
    // State for number selection and detail view
    @State private var selectedNumber: Int? = nil
    @State private var showingNumberDetail = false
    
    var chartData: [ChartDataPoint] {
        sampleManager.getChartData(for: selectedTimeRange)
    }
    
    // Access to today's samples for enhanced functionality
    private var todaySamples: [RealmSample] {
        sampleManager.todaySamples
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
            
            // Check if patterns are already pre-calculated from app startup
            if !patternsCalculated {
                // If not calculated yet, start calculation immediately
                calculatePatternsInBackground()
            }
        }
        .task {
            // PERFORMANCE FIX: Start pattern calculation immediately when view is created (even before onAppear)
            if !patternsCalculated {
                calculatePatternsInBackground()
            }
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
            .frame(height: 320)
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
    
    // MARK: - Daily Histogram (1D view) - ENHANCED with horizontal scrolling and interaction
    
    private var dailyHistogramChart: some View {
        VStack(spacing: 16) {
            // Enhanced horizontal scrolling histogram - clean and focused
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 6) {
                ForEach(1...9, id: \.self) { number in
                        individualNumberBar(for: number)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
            }
            .frame(height: 220)
            .clipped()
            
            // Compact stats summary
            HStack(spacing: 16) {
                VStack(spacing: 1) {
                    Text("\(todaySamples.count)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Total")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Divider()
                    .frame(height: 20)
                    .background(Color.white.opacity(0.3))
                
                VStack(spacing: 1) {
                    Text("\(sampleManager.rulingNumber)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                    Text("Ruling")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Divider()
                    .frame(height: 20)
                    .background(Color.white.opacity(0.3))
                
                VStack(spacing: 1) {
                    Text("\(sampleManager.getCount(for: sampleManager.rulingNumber))")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                    Text("Count")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .padding(.bottom, 8)
        }
        .fullScreenCover(isPresented: $showingNumberDetail) {
            if let selectedNum = selectedNumber {
                NumberDetailOverlay(
                    number: selectedNum,
                    sampleManager: sampleManager,
                    focusNumberManager: focusNumberManager,
                    isPresented: $showingNumberDetail
                )
            }
        }
        }
    
    // Individual number bar component with enhanced interactivity
    private func individualNumberBar(for number: Int) -> some View {
                    let count = sampleManager.getCount(for: number)
        let maxCount = max(todaySamples.isEmpty ? 1 : sampleManager.histogram.max() ?? 1, 1)
                    let barProgress = count > 0 ? CGFloat(count) / CGFloat(maxCount) : 0
                    let isRuling = number == sampleManager.rulingNumber && count > 0
                    let isFocus = number == focusNumberManager.selectedFocusNumber
        let isSelected = selectedNumber == number
                    
        return VStack(spacing: 6) {
            // Number circle with enhanced visual feedback
                        ZStack {
                            Circle()
                    .fill(getSacredColor(for: number).opacity(isSelected ? 1.0 : 0.8))
                    .frame(width: isSelected ? 42 : 38, height: isSelected ? 42 : 38)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            isRuling ? Color.yellow : 
                                isFocus ? Color.cyan :
                                isSelected ? Color.white : Color.clear,
                                lineWidth: isRuling || isFocus || isSelected ? 3 : 0
                                        )
                                )
                    .shadow(
                        color: getSacredColor(for: number).opacity(isSelected ? 0.8 : 0.5),
                        radius: isSelected ? 10 : 6
                    )
                            
                            Text("\(number)")
                    .font(.system(size: isSelected ? 18 : 16, weight: .bold))
                                .foregroundColor(.white)
                        }
            .scaleEffect(isSelected ? 1.1 : (isRuling && sacredCycleHighlight ? 1.05 : 1.0))
                        
            // Vertical progress bar
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                                // Background track
                     RoundedRectangle(cornerRadius: 6)
                         .fill(Color.white.opacity(0.2))
                         .frame(width: 20, height: 80)
                                
                                // Progress bar
                    RoundedRectangle(cornerRadius: 6)
                                    .fill(
                                        LinearGradient(
                                            colors: isRuling ? [
                                    .yellow.opacity(0.9),
                                    getSacredColor(for: number).opacity(0.8)
                                            ] : [
                                    getSacredColor(for: number).opacity(0.9),
                                    getSacredColor(for: number).opacity(0.6)
                                            ],
                                startPoint: .top,
                                endPoint: .bottom
                                        )
                                    )
                                    .frame(
                             width: 20,
                             height: max((80 * barProgress) * chartAnimationPhase, count > 0 ? 8 : 0)
                                    )
                                    .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                            .stroke(isRuling ? Color.yellow.opacity(0.8) : Color.clear,
                                                lineWidth: isRuling ? 2 : 0
                                            )
                                    )
                                    .shadow(
                                        color: isRuling ? .yellow.opacity(0.4) : getSacredColor(for: number).opacity(0.3),
                            radius: isRuling ? 6 : 3
                                    )
                }
                            }
                            
            // Count label
                                Text("\(count)")
                .font(.system(size: 14, weight: isRuling ? .bold : .medium))
                                    .foregroundColor(isRuling ? .yellow : .white)
                .frame(minWidth: 22)
                                
            // Status indicators
            HStack(spacing: 2) {
                                    if isRuling {
                                        Image(systemName: "crown.fill")
                        .font(.caption2)
                                            .foregroundColor(.yellow)
                                    }
                                    if isFocus {
                                        Image(systemName: "target")
                        .font(.caption2)
                                            .foregroundColor(.cyan)
                                    }
                                }
            .frame(height: 12)
        }
        .frame(width: 50)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.white.opacity(0.1) : Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isSelected ? getSacredColor(for: number).opacity(0.5) : Color.clear,
                            lineWidth: 1
                        )
                )
        )
                    .onTapGesture {
            handleEnhancedNumberTap(number)
            }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isRuling)
    }
    
    // Enhanced number tap handler with detailed information
    private func handleEnhancedNumberTap(_ number: Int) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Set selection and show detail
        selectedNumber = number
        showingNumberDetail = true
        
        print("📊 Enhanced: User selected number \(number) for detailed analysis")
    }
    
    // MARK: - Time Series Chart (7D, 14D, 30D views)
    
    // Extract complex calculations to avoid compiler issues
    private var processedChartData: (dates: [Date], maxValue: Int) {
        let sortedData = chartData.sorted { $0.date < $1.date }
        let uniqueDates = Array(Set(sortedData.map { Calendar.current.startOfDay(for: $0.date) })).sorted()
        let maxValue = max(chartData.map { $0.value }.max() ?? 1, 1)
        return (uniqueDates, maxValue)
    }
    
    private func getDayData(for date: Date) -> [ChartDataPoint] {
        let sortedData = chartData.sorted { $0.date < $1.date }
        return sortedData.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    private func getRulingNumber(for dayData: [ChartDataPoint]) -> Int {
        return dayData.max(by: { $0.value < $1.value })?.number ?? 1
    }
    
    private func getMaxDayValue(for dayData: [ChartDataPoint]) -> Int {
        return dayData.map { $0.value }.max() ?? 0
    }
    
    private var timeSeriesChart: some View {
        let processedData = processedChartData
        
        return VStack(spacing: 16) {
            // Synchronized scrollable bar chart
            ScrollView(.horizontal, showsIndicators: true) {
                VStack(spacing: 12) {
                    // Number labels that scroll with the data
                    chartHeaderView(dates: processedData.dates)
                    
                    // Vertical bar chart
                    chartBarsView(dates: processedData.dates, maxValue: processedData.maxValue)
                }
                .padding(.vertical, 16)
            }
            .frame(height: 220)
            
            // Legend for number colors
            chartLegendView
        }
    }
    
    private func chartHeaderView(dates: [Date]) -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(dates.indices, id: \.self) { dateIndex in
                let date = dates[dateIndex]
                let dayData = getDayData(for: date)
                let rulingNumber = getRulingNumber(for: dayData)
                
                VStack(spacing: 8) {
                    // Date label
                    Text(formatDateLabel(date))
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.6))
                    
                    // Ruling number circle
                    ZStack {
                            Circle()
                            .fill(getSacredColor(for: rulingNumber).opacity(0.8))
                            .frame(width: 24, height: 24)
                        
                        Text("\(rulingNumber)")
                                .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        }
                }
                .frame(width: 60)
                    }
                }
                .padding(.horizontal, 20)
            }
            
    private func chartBarsView(dates: [Date], maxValue: Int) -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(dates.indices, id: \.self) { dateIndex in
                let date = dates[dateIndex]
                let dayData = getDayData(for: date)
                let rulingNumber = getRulingNumber(for: dayData)
                let maxDayValue = getMaxDayValue(for: dayData)
                
                individualBarView(
                    rulingNumber: rulingNumber,
                    maxDayValue: maxDayValue,
                    maxValue: maxValue,
                    dayData: dayData
                )
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func individualBarView(rulingNumber: Int, maxDayValue: Int, maxValue: Int, dayData: [ChartDataPoint]) -> some View {
        VStack(spacing: 4) {
            // Bar
            ZStack(alignment: .bottom) {
                // Background bar
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 40, height: 140)
                    
                // Data bar
                RoundedRectangle(cornerRadius: 6)
                    .fill(
                        LinearGradient(
                            colors: [
                                getSacredColor(for: rulingNumber).opacity(0.9),
                                getSacredColor(for: rulingNumber).opacity(0.6)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(
                        width: 40,
                        height: max(((CGFloat(maxDayValue) / CGFloat(maxValue)) * CGFloat(140)) * CGFloat(chartAnimationPhase), CGFloat(4))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(getSacredColor(for: rulingNumber).opacity(0.8), lineWidth: 1)
                            )
                    .shadow(color: getSacredColor(for: rulingNumber).opacity(0.4), radius: 4)
                    }
                    
            // Value label
            Text("\(maxDayValue)")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(width: 60)
        .onTapGesture {
            if let selectedData = dayData.max(by: { $0.value < $1.value }) {
                selectedDataPoint = selectedData
                showingTooltip = true
            }
        }
    }
    
    private var chartLegendView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(1...9, id: \.self) { number in
                    HStack(spacing: 4) {
                            Circle()
                            .fill(getSacredColor(for: number))
                                .frame(width: 6, height: 6)
                        Text("\(number)")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.05))
                    )
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    // Helper function to format date labels
    private func formatDateLabel(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
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
                if patternsCalculated {
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
                } else {
                    // Loading state for pattern calculations
                    VStack(spacing: 16) {
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                            Text("⚡ Calculating sacred patterns...")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.black.opacity(0.4))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
            }
            .padding(.horizontal, 8)
        }
        .fullScreenCover(isPresented: $showingSacredPatternDetail) {
            // PERFORMANCE FIX: Ultra-minimal fullscreen overlay - zero UI delays!
            if let selectedPattern = selectedSacredPattern {
                UltraMinimalPatternOverlay(
                    pattern: selectedPattern,
                    sampleManager: sampleManager,
                    isPresented: $showingSacredPatternDetail,
                    precalculatedValue: patternValues[selectedPattern] ?? 0.0
                )
            }
        }
    }
    
    private func enhancedSacredPatternCard(_ patternType: SacredPatternType) -> some View {
        // PERFORMANCE FIX: Use pre-calculated values instead of calculating individually
        let value = patternValues[patternType] ?? 0.0  // Use cached value or default to 0
        let percentage = Int(value * 100)
        
        return HStack(spacing: 16) {
            // Left side - Icon and percentage
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(patternType.color.opacity(0.3))
                        .frame(width: 60, height: 60)
                        .scaleEffect(showingSacredPatternDetail ? 1.0 : (sacredCycleHighlight ? 1.05 : 1.0))
                    
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
                                .fill(patternType.color.opacity(0.7))
                                .frame(width: geometry.size.width * value, height: 8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(patternType.color.opacity(0.6), lineWidth: 1)
                                )
                                .shadow(color: patternType.color.opacity(0.4), radius: 4)
                                .animation(
                                    showingSacredPatternDetail ? .none : .easeOut(duration: 2.5).delay(0.5),
                                    value: chartAnimationPhase
                                )
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
            // PERFORMANCE FIX: Pause expensive animations before showing overlay
            chartAnimationPhase = 1.0  // Complete any pending animations
            
            print("⚡ Sacred Pattern Tapped: \(patternType.title) - Requesting overlay...")
            
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
        // PERFORMANCE FIX: Reduce animation complexity to prevent UI blocking
        withAnimation(.easeInOut(duration: 1.0)) {
            chartAnimationPhase = 1.0
        }
        
        // Gentler animations that won't block Sacred Pattern overlays
        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
            sacredCycleHighlight = true
        }
        
        withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
            rulingBarPulse = true
        }
    }
    
    // MARK: - Legacy method - replaced by handleEnhancedNumberTap
    
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
    
    // PERFORMANCE: Extract pattern calculation into reusable function
    private func calculatePatternsInBackground() {
        DispatchQueue.global(qos: .userInitiated).async {
            let allPatterns: [SacredPatternType] = [.sevenDay, .goldenFlow, .fibonacciSpiral, .trinityFlow, .lunarSync]
            var calculatedValues: [SacredPatternType: Double] = [:]
            
            print("🚀 EARLY PATTERN CALCULATION: Starting background calculation...")
            
            for pattern in allPatterns {
                calculatedValues[pattern] = pattern.getValue(from: sampleManager)
                print("✅ Calculated \(pattern.title): \(Int(calculatedValues[pattern]! * 100))%")
            }
            
            DispatchQueue.main.async {
                self.patternValues = calculatedValues
                self.patternsCalculated = true
                print("🚀 Sacred Patterns: All values pre-calculated and cached EARLY!")
            }
        }
    }
}

// MARK: - Ultra-Minimal Sacred Pattern Overlay (Zero Delays)

struct UltraMinimalPatternOverlay: View {
    let pattern: SacredPatternType
    let sampleManager: RealmSampleManager
    @Binding var isPresented: Bool
    let precalculatedValue: Double // PERFORMANCE: Pre-calculated data - no delays!
    
    var body: some View {
        // PERFORMANCE: Ultra-minimal fullscreen overlay with ScrollView for text
            ZStack {
            // Instant black background
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Fixed header - instant load
                HStack {
                    Spacer()
                    Button("✕") {
                        isPresented = false
                    }
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                }
                
                // SCROLLABLE CONTENT - Fixed scrolling issue
                ScrollView {
                    VStack(spacing: 20) {
                        // Top spacing
                        Spacer(minLength: 40)
                        
                        // Core content - minimal but complete
                        VStack(spacing: 20) {
                            // Pattern icon
                Image(systemName: pattern.icon)
                                .font(.system(size: 60, weight: .bold))
                    .foregroundColor(pattern.color)
            
                            // PERFORMANCE: Use pre-calculated value - instant display
                            let percentage = Int(precalculatedValue * 100)
            Text("\(percentage)%")
                                .font(.system(size: 50, weight: .bold, design: .rounded))
                .foregroundColor(pattern.color)
            
                            Text(pattern.title)
                                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
                            // Essential content in minimal layout
                            VStack(spacing: 16) {
                                Text(pattern.shortDescription)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 30)
            
                                // Minimal progress indicator
                                HStack(spacing: 3) {
                                    ForEach(0..<10, id: \.self) { index in
                                        Circle()
                                            .fill(index < Int(precalculatedValue * 10) ? pattern.color : Color.white.opacity(0.3))
                                            .frame(width: 8, height: 8)
                                    }
                                }
                                
                                Text(getStrengthLabel(for: precalculatedValue))
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(pattern.color)
                                    .padding(.top, 8)
    }
                        }
                        
                        // Sacred wisdom section - now properly scrollable
                        VStack(spacing: 12) {
            Text("✧ Sacred Wisdom ✧")
                                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                                .padding(.top, 20)
            
            Text(pattern.fullDescription)
                .font(.body)
                                .foregroundColor(.white.opacity(0.8))
                                .lineSpacing(4)
                                .padding(.horizontal, 20)
                                .multilineTextAlignment(.leading)
                        }
                        
                        // Bottom spacing
                        Spacer(minLength: 60)
                    }
                }
            }
        }
        .onAppear {
            print("🔍 Sacred Pattern Debug:")
            print("   Pattern: \(pattern.title)")
            print("   Percentage: \(Int(precalculatedValue * 100))%")
            print("   SCROLLABLE OVERLAY - PERFORMANCE OPTIMIZED!")
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

// MARK: - Number Detail Overlay

struct NumberDetailOverlay: View {
    let number: Int
    let sampleManager: RealmSampleManager
    let focusNumberManager: FocusNumberManager
    @Binding var isPresented: Bool
    
    private var todayCount: Int {
        sampleManager.getCount(for: number)
    }
    
    private var weeklyCount: Int {
        let weeklyData = sampleManager.getChartData(for: .sevenDays)
        return weeklyData.filter { $0.number == number }.map { $0.value }.reduce(0, +)
    }
    
    private var monthlyCount: Int {
        let monthlyData = sampleManager.getChartData(for: .thirtyDays)
        return monthlyData.filter { $0.number == number }.map { $0.value }.reduce(0, +)
    }
    
    private var isRuling: Bool {
        number == sampleManager.rulingNumber && todayCount > 0
    }
    
    private var isFocus: Bool {
        number == focusNumberManager.selectedFocusNumber
    }
    
    var body: some View {
        ZStack {
            // Cosmic background
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with close button
                HStack {
                    Spacer()
                    Button("✕") {
                        isPresented = false
                    }
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                }
                
                // Scrollable content
                ScrollView {
                    VStack(spacing: 24) {
                        // Top spacing
                        Spacer(minLength: 20)
                        
                        // Number header
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [
                                                getSacredColor(for: number).opacity(0.8),
                                                getSacredColor(for: number).opacity(0.4)
                                            ],
                                            center: .center,
                                            startRadius: 20,
                                            endRadius: 60
                                        )
                                    )
                                    .frame(width: 120, height: 120)
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                isRuling ? Color.yellow :
                                                isFocus ? Color.cyan : Color.white.opacity(0.3),
                                                lineWidth: isRuling || isFocus ? 4 : 2
                                            )
                                    )
                                    .shadow(color: getSacredColor(for: number).opacity(0.6), radius: 20)
                                
                                Text("\(number)")
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            
                            // Status badges
                                                         HStack(spacing: 12) {
                                 if isRuling {
                                     NumberStatusBadge(
                                         icon: "crown.fill",
                                         text: "Today's Ruler",
                                         color: .yellow
                                     )
                                 }
                                 if isFocus {
                                     NumberStatusBadge(
                                         icon: "target",
                                         text: "Focus Number",
                                         color: .cyan
                                     )
                                 }
                             }
                        }
                        
                        // Statistics section
                        VStack(spacing: 16) {
                            Text("✧ Statistics ✧")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                                                         HStack(spacing: 16) {
                                 NumberStatCard(
                                     title: "Today",
                                     value: "\(todayCount)",
                                     subtitle: todayCount == 1 ? "occurrence" : "occurrences",
                                     color: getSacredColor(for: number)
                                 )
                                 
                                 NumberStatCard(
                                     title: "This Week",
                                     value: "\(weeklyCount)",
                                     subtitle: "total appearances",
                                     color: getSacredColor(for: number).opacity(0.8)
                                 )
                                 
                                 NumberStatCard(
                                     title: "This Month",
                                     value: "\(monthlyCount)",
                                     subtitle: "cosmic manifestations",
                                     color: getSacredColor(for: number).opacity(0.6)
                                 )
                             }
                        }
                        
                        // Sacred insights
                        VStack(spacing: 16) {
                            Text("✧ Sacred Wisdom ✧")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                                                         VStack(spacing: 12) {
                                 NumberInsightCard(
                                     title: "Numerical Essence",
                                     content: getNumericalEssence(for: number),
                                     icon: "sparkles",
                                     color: getSacredColor(for: number)
                                 )
                                 
                                 NumberInsightCard(
                                     title: "Spiritual Meaning",
                                     content: getSpiritualMeaning(for: number),
                                     icon: "star.circle",
                                     color: getSacredColor(for: number)
                                 )
                                 
                                 NumberInsightCard(
                                     title: "Life Guidance",
                                     content: getLifeGuidance(for: number),
                                     icon: "heart.circle",
                                     color: getSacredColor(for: number)
                                 )
                             }
                        }
                        
                        // Frequency analysis
                        if todayCount > 0 {
                            VStack(spacing: 16) {
                                Text("✧ Today's Pattern ✧")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                                                 NumberFrequencyCard(
                                     number: number,
                                     count: todayCount,
                                     totalSamples: sampleManager.todaySamples.count,
                                     isRuling: isRuling
                                 )
                            }
                        }
                        
                        // Bottom spacing
                        Spacer(minLength: 60)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .onAppear {
            print("📊 Number Detail: Showing analysis for number \(number)")
            print("   Today: \(todayCount) | Week: \(weeklyCount) | Month: \(monthlyCount)")
        }
    }
    
    // Helper function to get sacred color (if not defined in main view)
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
    
    // Sacred wisdom content
    private func getNumericalEssence(for number: Int) -> String {
        switch number {
        case 1: return "The number of new beginnings, independence, and leadership. You are the alpha point of creation, the spark that ignites infinite potential."
        case 2: return "The number of balance, cooperation, and harmony. Sacred duality teaches us that opposites create wholeness and partnerships manifest dreams."
        case 3: return "The number of creativity, expression, and divine trinity. Mind, body, and spirit unite in perfect creative flow and joyful manifestation."
        case 4: return "The number of stability, foundation, and sacred geometry. Four elements, four directions, and solid structure anchor dreams into reality."
        case 5: return "The number of freedom, adventure, and change. The pentagram's protection guides your journey through transformation and discovery."
        case 6: return "The number of love, nurturing, and harmony. The hexagon's perfect geometry reflects the flower of life's infinite beauty and compassion."
        case 7: return "The number of mystery, spirituality, and wisdom. Seven chakras, seven heavens - the mystical gateway to higher consciousness and inner knowing."
        case 8: return "The number of abundance, power, and infinite cycles. The ouroboros symbol of eternal renewal and material mastery in perfect balance."
        case 9: return "The number of completion, wisdom, and universal love. The enneagram's nine points encompass all human experience and divine understanding."
        default: return "Each number carries sacred frequency and divine purpose in the cosmic symphony of existence."
        }
    }
    
    private func getSpiritualMeaning(for number: Int) -> String {
        switch number {
        case 1: return "Divine unity consciousness. You are both the creator and the created, holding the power to manifest reality through focused intention and will."
        case 2: return "Sacred partnership with the divine feminine. Balance your inner masculine and feminine energies to achieve harmonious co-creation."
        case 3: return "Trinity activation and creative expression. Your thoughts, words, and actions align to bring forth divine inspiration into the material world."
        case 4: return "Earth element mastery and foundation building. You are anchoring celestial wisdom into practical form through disciplined, methodical action."
        case 5: return "Freedom through spiritual transformation. Release limiting beliefs and embrace the adventure of conscious evolution and soul expansion."
        case 6: return "Heart chakra opening and unconditional love. You are called to be a healer, teacher, and beacon of compassion in the world."
        case 7: return "Crown chakra illumination and mystical wisdom. Deep meditation, spiritual study, and inner knowing guide your path to enlightenment."
        case 8: return "Material and spiritual abundance integration. You master the art of manifesting prosperity while maintaining spiritual integrity and service."
        case 9: return "Christ consciousness and universal service. Your soul's mission involves healing, teaching, and uplifting humanity through divine love."
        default: return "Every number contains sacred frequencies that guide us toward our highest spiritual potential and divine purpose."
        }
    }
    
    private func getLifeGuidance(for number: Int) -> String {
        switch number {
        case 1: return "Trust your instincts and take initiative. Leadership opportunities are presenting themselves. Your original ideas and pioneering spirit are needed now."
        case 2: return "Seek collaboration and practice patience. Diplomatic solutions and emotional intelligence will serve you. Focus on building supportive relationships."
        case 3: return "Express your creativity and communicate openly. Your artistic talents and joyful energy inspire others. Share your gifts with confidence and enthusiasm."
        case 4: return "Build solid foundations and work methodically. Organization and practical planning lead to lasting success. Stay committed to your long-term goals."
        case 5: return "Embrace change and seek new experiences. Your adventurous spirit and adaptability are assets. Freedom comes through embracing diversity and growth."
        case 6: return "Focus on family, community, and service. Your nurturing abilities and aesthetic sense create harmony. Take care of others while honoring your own needs."
        case 7: return "Deepen your spiritual practice and seek inner wisdom. Research, meditation, and solitude provide answers. Trust your intuitive insights over external noise."
        case 8: return "Pursue material goals with ethical integrity. Your business acumen and organizational skills create abundance. Balance ambition with generosity and fairness."
        case 9: return "Serve the greater good and practice forgiveness. Your wisdom and compassion heal others. Release what no longer serves and embrace your humanitarian calling."
        default: return "Each moment offers guidance when we align with the sacred numerical frequencies that surround us in divine perfect timing."
        }
    }
}

// Supporting UI Components

struct NumberStatusBadge: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(color)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.5), lineWidth: 1)
                )
        )
    }
}

struct NumberStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.8))
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct NumberInsightCard: View {
    let title: String
    let content: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            Text(content)
                .font(.body)
                .foregroundColor(.white.opacity(0.85))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
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
    }
}

struct NumberFrequencyCard: View {
    let number: Int
    let count: Int
    let totalSamples: Int
    let isRuling: Bool
    
    private var percentage: Double {
        guard totalSamples > 0 else { return 0 }
        return Double(count) / Double(totalSamples) * 100
    }
    
    private var frequencyDescription: String {
        switch percentage {
        case 30...: return "Dominant cosmic influence - exceptionally strong presence"
        case 20..<30: return "Strong manifestation - significant spiritual energy"
        case 15..<20: return "Balanced presence - harmonious cosmic flow"
        case 10..<15: return "Gentle influence - subtle but meaningful"
        case 5..<10: return "Emerging pattern - building cosmic momentum"
        default: return "Rare appearance - precious spiritual moment"
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Frequency Today")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("\(String(format: "%.1f", percentage))% of all manifestations")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("\(count)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(isRuling ? .yellow : .white)
                    Text("of \(totalSamples)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [
                                    getSacredColor(for: number).opacity(0.9),
                                    getSacredColor(for: number).opacity(0.6)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * (percentage / 100), height: 8)
                }
            }
            .frame(height: 8)
            
            Text(frequencyDescription)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .italic()
                .multilineTextAlignment(.center)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(getSacredColor(for: number).opacity(0.4), lineWidth: 1)
                )
        )
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
        case 8: return Color(red: 1.0, green: 0.8, blue: 0.0)
        case 9: return .white
        default: return .white
        }
    }
} 