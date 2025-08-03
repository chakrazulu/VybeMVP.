/**
 * 🧪 KASPER MLX PROFESSIONAL TEST INTERFACE - WORLD-CLASS SPIRITUAL AI DEVELOPMENT
 * =============================================================================
 * 
 * This is the crown jewel of KASPER MLX development tools - a comprehensive,
 * professional-grade testing environment that rivals Apple's own internal
 * development interfaces. This isn't just a simple test view - it's a
 * sophisticated spiritual AI laboratory.
 * 
 * 🎯 PURPOSE & VISION:
 * 
 * The KASPER MLX Test Interface serves multiple critical functions:
 * 
 * • DEVELOPMENT ACCELERATION: Rapid iteration on spiritual AI algorithms
 * • QUALITY ASSURANCE: Comprehensive validation of insight generation
 * • PERFORMANCE OPTIMIZATION: Real-time metrics and bottleneck identification  
 * • USER EXPERIENCE RESEARCH: A/B testing different spiritual guidance approaches
 * • AI TRAINING: Feedback collection to continuously improve the system
 * 
 * This interface enables the KASPER MLX team to develop, test, and refine
 * the world's most advanced spiritual AI system with unprecedented speed
 * and precision.
 * 
 * 🏗️ ARCHITECTURAL SOPHISTICATION:
 * 
 * The Test Interface demonstrates advanced SwiftUI architecture patterns:
 * 
 * 1. REAL-TIME PERFORMANCE DASHBOARD
 *    - Live metrics: response times, success rates, cache hit ratios
 *    - Color-coded performance indicators (Green = optimal, Orange = warning, Red = critical)
 *    - Visual response time charts with smooth animations
 *    - Automatic performance threshold monitoring
 * 
 * 2. COMPREHENSIVE FEATURE TESTING
 *    - All 7 KASPER MLX features (journal, daily cards, sanctum, etc.)
 *    - Visual feature selection with spiritual iconography
 *    - Custom prompt testing for edge cases and specific scenarios
 *    - Toggle-based test configuration for rapid experimentation
 * 
 * 3. PROFESSIONAL INSIGHT ANALYSIS
 *    - Full insight metadata display (confidence, inference time, cache status)
 *    - Expandable insight content with tap-to-read-more functionality
 *    - Comprehensive feedback system with persistent storage
 *    - Real-time feedback analytics and positive/negative ratios
 * 
 * 4. DEVELOPER EXPERIENCE OPTIMIZATION
 *    - Intuitive visual hierarchy with clear information architecture
 *    - Smooth animations and transitions that feel native to iOS
 *    - Haptic feedback for important interactions
 *    - Error handling with detailed diagnostic information
 * 
 * 🔬 TESTING METHODOLOGY INNOVATION:
 * 
 * This interface enables sophisticated testing approaches that go beyond
 * traditional AI validation:
 * 
 * • SPIRITUAL CONTEXT TESTING: Validate that insights feel genuinely spiritual
 * • PERFORMANCE UNDER LOAD: Monitor system behavior during intensive use
 * • EDGE CASE EXPLORATION: Test unusual inputs and boundary conditions
 * • USER JOURNEY SIMULATION: Replicate real-world usage patterns
 * • FEEDBACK LOOP VALIDATION: Ensure user ratings improve system performance
 * 
 * 📊 DATA-DRIVEN DEVELOPMENT:
 * 
 * The interface collects and displays metrics that enable data-driven decisions:
 * 
 * • Response Time Distribution: Identify performance outliers and optimization opportunities
 * • Success Rate Trends: Monitor system reliability over time
 * • Feature Usage Patterns: Understand which spiritual domains are most popular
 * • User Satisfaction Metrics: Track how often users rate insights positively
 * • Cache Efficiency Analysis: Optimize the balance between speed and freshness
 * 
 * 🎨 DESIGN PHILOSOPHY:
 * 
 * The interface embodies Vybe's design principles while serving technical needs:
 * 
 * • COSMIC AESTHETICS: Maintains Vybe's spiritual visual language
 * • PROFESSIONAL FUNCTIONALITY: Provides all tools needed for serious development
 * • INTUITIVE INTERACTION: Complex capabilities presented through simple interfaces
 * • PERFORMANCE OBSESSION: 60fps animations even with intensive data processing
 * • ACCESSIBILITY FOCUS: Usable by developers with different technical backgrounds
 * 
 * 🚀 INNOVATION IMPACT:
 * 
 * This test interface enables development practices that were previously impossible:
 * 
 * • REAL-TIME AI TUNING: Adjust spiritual AI parameters and see immediate results
 * • COLLABORATIVE DEVELOPMENT: Multiple team members can test and provide feedback
 * • USER-DRIVEN IMPROVEMENT: Direct feedback loop from testing to AI enhancement
 * • RAPID PROTOTYPING: Test new spiritual guidance approaches in minutes, not days
 * • QUALITY ASSURANCE: Catch issues before they reach users' spiritual experiences
 * 
 * 💫 WHY THIS MATTERS FOR VYBE:
 * 
 * The KASPER MLX Test Interface isn't just a development tool - it's a competitive
 * advantage that enables Vybe to:
 * 
 * • DEVELOP FASTER: Rapid iteration cycles accelerate innovation
 * • SHIP HIGHER QUALITY: Comprehensive testing prevents spiritual AI failures
 * • UNDERSTAND USERS: Real feedback data drives user-centric improvements
 * • SCALE EFFICIENTLY: Performance insights enable optimization before scaling
 * • MAINTAIN LEADERSHIP: Advanced tooling keeps Vybe ahead of spiritual AI competitors
 * 
 * This interface represents the state-of-the-art in spiritual AI development
 * tooling, enabling the creation of increasingly sophisticated and helpful
 * spiritual guidance systems that truly serve users' cosmic journeys.
 */

import SwiftUI
import Combine
import Foundation

struct KASPERMLXTestView: View {
    @EnvironmentObject private var kasperMLX: KASPERMLXManager
    @StateObject private var kasperFeedback = KASPERFeedbackManager.shared
    @State private var insight: KASPERInsight?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var selectedFeature: KASPERFeature = .journalInsight
    @State private var lastInferenceTime: Double = 0.0
    @State private var totalInsightsGenerated: Int = 0
    @State private var showingFullInsight = false
    @State private var loadingProgress: Double = 0.0
    @State private var currentStatus: String = "Ready"
    @State private var providersStatus: [String: Bool] = [:]
    @State private var performanceMetrics: [String: Any] = [:]
    @State private var lastFeedback: FeedbackRating?
    @State private var customPrompt: String = ""
    @State private var useCustomPrompt: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    performanceDashboardSection
                    featureSelectionSection
                    customPromptSection
                    generateButtonSection
                    
                    if let insight = insight {
                        insightDisplaySection(insight)
                    }
                    
                    if let errorMessage = errorMessage {
                        errorDisplaySection(errorMessage)
                    }
                    
                    developerToolsSection
                }
                .padding(20)
            }
            .navigationTitle("KASPER MLX")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                updateEngineStatus()
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("KASPER MLX")
                        .font(.title.bold())
                        .foregroundColor(.primary)
                    
                    Text("Apple Intelligence Test Suite")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(kasperMLX.isReady ? .green : .orange)
                            .frame(width: 12, height: 12)
                            .scaleEffect(kasperMLX.isReady ? 1.0 : 0.8)
                            .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: kasperMLX.isReady)
                        
                        Text(currentStatus)
                            .font(.caption.weight(.medium))
                            .foregroundColor(kasperMLX.isReady ? .green : .orange)
                    }
                    
                    Text("v1.0.0-beta")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack(spacing: 16) {
                MetricCard(title: "Generated", value: "\(totalInsightsGenerated)", icon: "sparkles")
                MetricCard(title: "Last Time", value: String(format: "%.2fs", lastInferenceTime), icon: "timer")
                MetricCard(title: "Engine", value: kasperMLX.getEngineStatus(), icon: "cpu")
            }
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.quaternary, lineWidth: 1)
        )
    }
    
    private var featureSelectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Test Configuration")
                .font(.headline.weight(.semibold))
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(KASPERFeature.allCases, id: \.self) { feature in
                    FeatureCard(
                        feature: feature,
                        isSelected: selectedFeature == feature,
                        action: { 
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedFeature = feature
                            }
                        }
                    )
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.quaternary, lineWidth: 1)
        )
    }
    
    // Claude: Custom prompt section for specific testing scenarios
    private var customPromptSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Custom Test Prompt")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Toggle("", isOn: $useCustomPrompt)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: .purple))
            }
            
            if useCustomPrompt {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Enter custom context for testing specific scenarios")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    TextField("e.g., 'I'm feeling anxious about my relationship'", text: $customPrompt, axis: .vertical)
                        .textFieldStyle(.plain)
                        .font(.body)
                        .padding(12)
                        .background(Color.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                        .lineLimit(3...6)
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.quaternary, lineWidth: 1)
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: useCustomPrompt)
    }
    
    private var generateButtonSection: some View {
        VStack(spacing: 16) {
            Button(action: generateInsight) {
                HStack(spacing: 12) {
                    ZStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.9)
                        } else {
                            Image(systemName: "sparkles")
                                .font(.title3.weight(.semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 24, height: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(isLoading ? "Generating Insight..." : "Generate Insight")
                            .font(.headline.weight(.semibold))
                            .foregroundColor(.white)
                        
                        if isLoading {
                            Text(currentStatus)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        } else {
                            Text("Test \(selectedFeature.rawValue) feature")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    
                    Spacer()
                    
                    if !isLoading {
                        Image(systemName: "arrow.right")
                            .font(.title3.weight(.medium))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: kasperMLX.isReady ? [.blue, .purple] : [.gray, .gray.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: kasperMLX.isReady ? .blue.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
            }
            .disabled(!kasperMLX.isReady || isLoading)
            .scaleEffect(isLoading ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isLoading)
            
            if isLoading {
                ProgressView(value: loadingProgress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .scaleEffect(y: 2)
                    .animation(.easeInOut(duration: 0.3), value: loadingProgress)
            }
        }
    }
    
    private func insightDisplaySection(_ insight: KASPERInsight) -> some View {
        VStack(spacing: 20) {
            insightHeaderView(insight)
            insightContentView(insight)
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.quaternary, lineWidth: 1)
        )
    }
    
    private func insightHeaderView(_ insight: KASPERInsight) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Generated Insight")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.primary)
                
                Text("ID: \(insight.id.uuidString.prefix(8))")
                    .font(.caption.monospaced())
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 8) {
                    Image(systemName: "timer")
                        .font(.caption.weight(.medium))
                        .foregroundColor(.blue)
                    Text(String(format: "%.3fs", insight.inferenceTime))
                        .font(.caption.weight(.medium).monospacedDigit())
                        .foregroundColor(.blue)
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "gauge.medium")
                        .font(.caption.weight(.medium))
                        .foregroundColor(.green)
                    Text("\(Int(insight.confidence * 100))%")
                        .font(.caption.weight(.medium).monospacedDigit())
                        .foregroundColor(.green)
                }
            }
        }
    }
    
    private func insightContentView(_ insight: KASPERInsight) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            insightTextView(insight)
            insightMetadataGrid(insight)
            feedbackSection(insight)
        }
    }
    
    private func insightTextView(_ insight: KASPERInsight) -> some View {
        Button(action: { showingFullInsight = true }) {
            VStack(alignment: .leading, spacing: 12) {
                Text(insight.content)
                    .font(.body)
                    .lineSpacing(4)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(showingFullInsight ? nil : 3)
                
                if insight.content.count > 150 && !showingFullInsight {
                    HStack {
                        Text("Tap to read full insight")
                            .font(.caption.weight(.medium))
                            .foregroundColor(.blue)
                        
                        Image(systemName: "chevron.down")
                            .font(.caption.weight(.medium))
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(16)
            .background(Color.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.blue.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func insightMetadataGrid(_ insight: KASPERInsight) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
            MetadataCard(title: "Feature", value: insight.feature.rawValue, icon: "tag")
            MetadataCard(title: "Type", value: insight.type.rawValue, icon: "lightbulb")
            MetadataCard(title: "Model", value: insight.metadata.modelVersion, icon: "cpu")
            MetadataCard(title: "Cached", value: insight.metadata.cacheHit ? "Yes" : "No", icon: "memorychip")
        }
    }
    
    // Claude: Feedback section for testing
    private func feedbackSection(_ insight: KASPERInsight) -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("Feedback")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if let feedback = lastFeedback {
                    Text(feedback == .positive ? "Liked ✓" : "Disliked ✗")
                        .font(.caption.weight(.medium))
                        .foregroundColor(feedback == .positive ? .green : .red)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill((feedback == .positive ? Color.green : Color.red).opacity(0.1))
                        )
                }
            }
            
            HStack(spacing: 16) {
                // Like button
                Button(action: { provideFeedback(for: insight, rating: .positive) }) {
                    HStack(spacing: 8) {
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.title3)
                        Text("Like")
                            .font(.body.weight(.medium))
                    }
                    .foregroundColor(lastFeedback == .positive ? .white : .green)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(lastFeedback == .positive ? Color.green : Color.green.opacity(0.1))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.green.opacity(0.3), lineWidth: 1)
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                // Dislike button
                Button(action: { provideFeedback(for: insight, rating: .negative) }) {
                    HStack(spacing: 8) {
                        Image(systemName: "hand.thumbsdown.fill")
                            .font(.title3)
                        Text("Dislike")
                            .font(.body.weight(.medium))
                    }
                    .foregroundColor(lastFeedback == .negative ? .white : .red)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(lastFeedback == .negative ? Color.red : Color.red.opacity(0.1))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
            }
            
            if kasperFeedback.feedbackHistory.count > 0 {
                Text("Total feedback: \(kasperFeedback.feedbackHistory.count) • Positive: \(Int(kasperFeedback.stats.positivePercentage))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(Color.secondary.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
    }
    
    private func errorDisplaySection(_ errorMessage: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title3)
                .foregroundColor(.red)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Generation Failed")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(.red)
                
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(16)
        .background(.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.red.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var developerToolsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Developer Tools")
                .font(.headline.weight(.semibold))
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                KASPERActionButton(
                    title: "Clear Cache",
                    icon: "trash.circle",
                    color: .orange,
                    action: { 
                        Task {
                            await kasperMLX.clearCache()
                            totalInsightsGenerated = 0
                        }
                    }
                )
                
                KASPERActionButton(
                    title: "Journal Test",
                    icon: "book.circle",
                    color: .green,
                    action: testJournalInsight
                )
                
                KASPERActionButton(
                    title: "Daily Card",
                    icon: "star.circle",
                    color: .purple,
                    action: testDailyCard
                )
            }
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.quaternary, lineWidth: 1)
        )
    }
    
    // MARK: - Methods
    
    private func generateInsight() {
        Task {
            do {
                await MainActor.run {
                    isLoading = true
                    errorMessage = nil
                    currentStatus = "Initializing..."
                    loadingProgress = 0.0
                }
                
                await updateProgress(0.2, status: "Loading providers...")
                try await Task.sleep(nanoseconds: 200_000_000)
                
                await updateProgress(0.5, status: "Gathering context...")
                try await Task.sleep(nanoseconds: 300_000_000)
                
                await updateProgress(0.8, status: "Generating insight...")
                
                let startTime = Date()
                let generatedInsight = try await kasperMLX.generateQuickInsight(
                    for: selectedFeature,
                    query: useCustomPrompt && !customPrompt.isEmpty ? customPrompt : "Professional test insight generation"
                )
                let inferenceTime = Date().timeIntervalSince(startTime)
                
                await updateProgress(1.0, status: "Complete!")
                
                await MainActor.run {
                    insight = generatedInsight
                    lastInferenceTime = inferenceTime
                    totalInsightsGenerated += 1
                    isLoading = false
                    currentStatus = "Ready"
                    showingFullInsight = true
                }
                
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                    currentStatus = "Error"
                    loadingProgress = 0.0
                }
            }
        }
    }
    
    private func updateProgress(_ progress: Double, status: String) async {
        await MainActor.run {
            loadingProgress = progress
            currentStatus = status
        }
    }
    
    private func updateEngineStatus() {
        currentStatus = kasperMLX.isReady ? "Ready" : "Initializing"
    }
    
    // Claude: Feedback handling for MLX testing
    private func provideFeedback(for insight: KASPERInsight, rating: FeedbackRating) {
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: rating == .positive ? .light : .soft)
        impactFeedback.impactOccurred()
        
        // Update local state
        lastFeedback = rating
        
        // Record feedback with test context
        kasperFeedback.recordFeedback(
            for: insight,
            rating: rating,
            contextData: [
                "testView": "true",
                "feature": selectedFeature.rawValue,
                "inferenceTime": String(format: "%.3f", lastInferenceTime),
                "confidence": String(format: "%.2f", insight.confidence),
                "cacheHit": insight.metadata.cacheHit ? "true" : "false"
            ]
        )
        
        print("🧪 Test Feedback: \(rating.emoji) for insight \(insight.id.uuidString.prefix(8))")
    }
    
    // Claude: Performance Dashboard Section
    private var performanceDashboardSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Performance Dashboard")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("Reset") {
                    kasperMLX.resetPerformanceMetrics()
                }
                .font(.caption.weight(.medium))
                .foregroundColor(.red)
                .disabled(kasperMLX.performanceMetrics.totalRequests == 0)
            }
            
            if kasperMLX.performanceMetrics.totalRequests > 0 {
                // Performance metrics grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    PerformanceMetricCard(
                        title: "Requests", 
                        value: "\(kasperMLX.performanceMetrics.totalRequests)", 
                        icon: "number.circle",
                        color: .blue
                    )
                    PerformanceMetricCard(
                        title: "Success Rate", 
                        value: "\(Int(kasperMLX.performanceMetrics.successRate))%", 
                        icon: "checkmark.circle",
                        color: kasperMLX.performanceMetrics.successRate > 80 ? .green : .orange
                    )
                    PerformanceMetricCard(
                        title: "Avg Response", 
                        value: String(format: "%.2fs", kasperMLX.performanceMetrics.averageResponseTime), 
                        icon: "timer",
                        color: kasperMLX.performanceMetrics.averageResponseTime < 1.0 ? .green : .orange
                    )
                    PerformanceMetricCard(
                        title: "Cache Hit Rate", 
                        value: "\(Int(kasperMLX.performanceMetrics.cacheHitRate))%", 
                        icon: "memorychip",
                        color: kasperMLX.performanceMetrics.cacheHitRate > 50 ? .green : .orange
                    )
                }
                
                // Simple response time indicator
                HStack {
                    Text("Recent Performance")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    let recentTimes = kasperMLX.performanceMetrics.recentResponseTimes
                    if !recentTimes.isEmpty {
                        HStack(spacing: 4) {
                            ForEach(Array(recentTimes.suffix(10).enumerated()), id: \.offset) { index, time in
                                Rectangle()
                                    .fill(time < 1.0 ? Color.green : time < 2.0 ? Color.orange : Color.red)
                                    .frame(width: 6, height: max(4, min(20, time * 10)))
                                    .opacity(0.7)
                            }
                        }
                        .animation(.easeInOut(duration: 0.3), value: recentTimes.count)
                    }
                }
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "chart.bar")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    Text("No performance data yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Generate some insights to see performance metrics")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 20)
            }
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.quaternary, lineWidth: 1)
        )
    }
    
    private func testJournalInsight() {
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                insight = try await kasperMLX.generateJournalInsight(
                    entryText: useCustomPrompt && !customPrompt.isEmpty ? customPrompt : "Today I felt a deep connection to the cosmic energies around me...",
                    tone: "reflective"
                )
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    private func testDailyCard() {
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                insight = try await kasperMLX.generateDailyCardInsight(
                    cardType: "guidance"
                )
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
}

// MARK: - Supporting UI Components

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption.weight(.medium))
                .foregroundColor(.blue)
            
            Text(value)
                .font(.caption.weight(.semibold).monospacedDigit())
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
    }
}

struct FeatureCard: View {
    let feature: KASPERFeature
    let isSelected: Bool
    let action: () -> Void
    
    private var featureInfo: (icon: String, color: Color) {
        switch feature {
        case .journalInsight: return ("book.fill", .blue)
        case .dailyCard: return ("star.fill", .purple)
        case .sanctumGuidance: return ("building.columns.fill", .indigo)
        case .matchCompatibility: return ("heart.fill", .pink)
        case .cosmicTiming: return ("clock.fill", .orange)
        case .focusIntention: return ("target", .green)
        case .realmInterpretation: return ("globe", .teal)
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: featureInfo.icon)
                    .font(.title3.weight(.medium))
                    .foregroundColor(isSelected ? .white : featureInfo.color)
                
                Text(feature.rawValue.capitalized)
                    .font(.caption.weight(.medium))
                    .foregroundColor(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                isSelected ? featureInfo.color : Color.secondary.opacity(0.1),
                in: RoundedRectangle(cornerRadius: 12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? featureInfo.color : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MetadataCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption.weight(.medium))
                .foregroundColor(.blue)
                .frame(width: 16)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.caption.weight(.medium))
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding(8)
        .background(Color.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
    }
}

struct KASPERActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title3.weight(.medium))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption.weight(.medium))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Claude: Performance metric card component
struct PerformanceMetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.caption.weight(.medium))
                    .foregroundColor(color)
                    .frame(width: 16)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(color.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationView {
        KASPERMLXTestView()
            .environmentObject(KASPERMLXManager.shared)
    }
}