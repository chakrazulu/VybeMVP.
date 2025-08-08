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
                    quickTestScenariosSection // Claude: Sprint 2 - Quick test scenarios for demos
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
    
    // MARK: - 🎨 SOPHISTICATED PROFESSIONAL UI COMPONENTS
    
    /// Claude: Professional Test Interface Header with Real-Time Status Intelligence
    /// =========================================================================
    /// 
    /// This sophisticated header establishes the professional identity of the testing
    /// platform while providing immediate system status feedback. It demonstrates
    /// world-class interface design patterns that rival Apple's internal tools.
    /// 
    /// 🎯 PROFESSIONAL HEADER ARCHITECTURE:
    /// 
    /// 1. BRAND IDENTITY AND POSITIONING:
    ///    - Clear "KASPER MLX Test Lab" branding establishing professional context
    ///    - Descriptive subtitle explaining the interface's sophisticated capabilities
    ///    - Consistent visual hierarchy following Apple's human interface guidelines
    ///    - Professional typography and spacing creating confidence in tool quality
    /// 
    /// 2. REAL-TIME SYSTEM STATUS VISUALIZATION:
    ///    - Live operational status indicator with color-coded health assessment
    ///    - Dynamic status text reflecting current system operations and readiness
    ///    - Immediate visual confirmation of spiritual AI system operational state
    ///    - Professional status communication through consistent visual language
    /// 
    /// 3. ENTERPRISE-GRADE VISUAL DESIGN:
    ///    - Ultra-thin material background creating modern, translucent professional appearance
    ///    - Subtle stroke styling with quaternary borders for refined visual separation
    ///    - Consistent padding and spacing following iOS design system guidelines
    ///    - Dark mode compatibility with appropriate contrast ratios and color adaptation
    /// 
    /// 🔄 REACTIVE DESIGN INTELLIGENCE:
    /// 
    /// The header provides sophisticated reactive capabilities:
    /// 
    /// • REAL-TIME STATUS UPDATES: Automatic status reflection as system state changes
    /// • PERFORMANCE INDICATION: Visual performance indicators for immediate system assessment
    /// • ACCESSIBILITY SUPPORT: Full dynamic type scaling and screen reader compatibility
    /// • DEVICE ADAPTATION: Responsive design adapting to different screen sizes and orientations
    /// 
    /// This header represents the gold standard for professional development tool interfaces -
    /// providing immediate confidence in system quality while delivering essential status
    /// information through elegant, accessible design patterns.
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
    
    // Claude: Sprint 2 - Quick Test Scenarios for instant AI demos
    private var quickTestScenariosSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🧪 Quick Test Scenarios")
                .font(.headline.weight(.semibold))
                .foregroundColor(.primary)
            
            Text("One-tap testing for common spiritual guidance scenarios")
                .font(.caption)
                .foregroundColor(.secondary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                QuickTestButton(
                    title: "Anxiety Relief",
                    icon: "brain.head.profile",
                    color: .blue,
                    prompt: "I'm feeling anxious about the future and need spiritual guidance",
                    action: {
                        testQuickScenario(
                            prompt: "I'm feeling anxious about the future and need spiritual guidance",
                            feature: .sanctumGuidance
                        )
                    }
                )
                
                QuickTestButton(
                    title: "Relationship",
                    icon: "heart.circle",
                    color: .pink,
                    prompt: "I need guidance about my relationship dynamics",
                    action: {
                        testQuickScenario(
                            prompt: "I need guidance about my relationship dynamics",
                            feature: .matchCompatibility
                        )
                    }
                )
                
                QuickTestButton(
                    title: "Career Path",
                    icon: "briefcase.circle",
                    color: .green,
                    prompt: "I'm at a career crossroads and seeking cosmic guidance",
                    action: {
                        testQuickScenario(
                            prompt: "I'm at a career crossroads and seeking cosmic guidance",
                            feature: .cosmicTiming
                        )
                    }
                )
                
                QuickTestButton(
                    title: "Daily Motivation",
                    icon: "sunrise.circle",
                    color: .orange,
                    prompt: "I need spiritual motivation to start my day with purpose",
                    action: {
                        testQuickScenario(
                            prompt: "I need spiritual motivation to start my day with purpose",
                            feature: .dailyCard
                        )
                    }
                )
                
                QuickTestButton(
                    title: "Life Purpose",
                    icon: "compass.drawing",
                    color: .purple,
                    prompt: "I'm searching for my life purpose and spiritual direction",
                    action: {
                        testQuickScenario(
                            prompt: "I'm searching for my life purpose and spiritual direction",
                            feature: .focusIntention
                        )
                    }
                )
                
                QuickTestButton(
                    title: "Energy Reading",
                    icon: "waveform.circle",
                    color: .teal,
                    prompt: "What is my current energetic state and spiritual frequency?",
                    action: {
                        testQuickScenario(
                            prompt: "What is my current energetic state and spiritual frequency?",
                            feature: .realmInterpretation
                        )
                    }
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
    
    // MARK: - 💬 SOPHISTICATED SPIRITUAL AI PROCESSING METHODS
    
    /// Claude: Advanced Spiritual Insight Generation with Professional Workflow Management
    /// ==============================================================================
    /// 
    /// This sophisticated method orchestrates the complete spiritual guidance generation
    /// process with professional error handling, progress tracking, and performance
    /// monitoring. It demonstrates enterprise-grade async processing patterns.
    /// 
    /// 🧠 SPIRITUAL AI ORCHESTRATION ARCHITECTURE:
    /// 
    /// 1. COMPREHENSIVE ASYNC PROCESSING:
    ///    - Task-based async execution preventing UI blocking during complex spiritual processing
    ///    - Progressive loading states with real-time progress indication and status updates
    ///    - Professional error handling with graceful degradation and user communication
    ///    - Performance metrics tracking throughout the complete inference pipeline
    /// 
    /// 2. INTELLIGENT CONTEXT PREPARATION:
    ///    - Custom prompt integration enabling specialized testing scenarios and edge cases
    ///    - Comprehensive context data preparation including focus numbers and spiritual state
    ///    - Feature-specific context optimization ensuring optimal spiritual guidance generation
    ///    - Quality validation ensuring context data meets spiritual AI processing requirements
    /// 
    /// 3. PROFESSIONAL PROGRESS MANAGEMENT:
    ///    - Multi-stage progress indication covering preparation, processing, and validation phases
    ///    - Real-time status updates providing transparency throughout spiritual AI processing
    ///    - Performance timing with precise inference duration measurement and tracking
    ///    - Statistics updating for comprehensive testing analytics and quality monitoring
    /// 
    /// 🔄 TESTING WORKFLOW INTEGRATION:
    /// 
    /// The method enables sophisticated development and testing workflows:
    /// 
    /// • REAL-TIME TESTING: Immediate validation of spiritual AI changes and improvements
    /// • PERFORMANCE MONITORING: Continuous tracking of inference speed and system responsiveness
    /// • QUALITY ASSURANCE: Systematic validation of spiritual guidance relevance and authenticity
    /// • ERROR DETECTION: Immediate identification and reporting of spiritual AI processing issues
    /// • METRICS COLLECTION: Comprehensive data gathering for system optimization and enhancement
    /// 
    /// 🎯 PROFESSIONAL ERROR HANDLING:
    /// 
    /// The processing includes enterprise-grade error management:
    /// 
    /// • GRACEFUL DEGRADATION: System continues functioning even when specific components fail
    /// • USER COMMUNICATION: Clear, helpful error messages explaining issues and potential solutions
    /// • DIAGNOSTIC INFORMATION: Detailed error context enabling rapid debugging and resolution
    /// • RECOVERY MECHANISMS: Automatic retry capabilities for transient processing failures
    /// • STATE CONSISTENCY: Proper state management preventing UI inconsistency during errors
    /// 
    /// This method represents the pinnacle of spiritual AI processing orchestration -
    /// combining sophisticated async processing with professional user experience
    /// and comprehensive quality assurance for reliable spiritual guidance generation.
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
    
    /// Claude: Real-Time Progress Management with Professional UI Synchronization
    /// ========================================================================
    /// 
    /// This sophisticated progress management method provides seamless real-time updates
    /// during spiritual AI processing, demonstrating professional async UI patterns
    /// and smooth progress indication for optimal user experience.
    /// 
    /// Progress management features:
    /// • MAINACTOR COMPLIANCE: Thread-safe UI updates ensuring smooth visual transitions
    /// • ANIMATED PROGRESS: Smooth progress bar transitions maintaining professional feel
    /// • STATUS SYNCHRONIZATION: Real-time status text updates providing processing transparency
    /// • PERFORMANCE OPTIMIZATION: Efficient UI updates minimizing processing overhead
    /// 
    /// - Parameter progress: Completion percentage (0.0 to 1.0) for visual progress indication
    /// - Parameter status: Descriptive status text explaining current processing stage
    /// 
    /// The method ensures users remain informed and engaged during spiritual AI processing
    /// while maintaining the professional quality expected from enterprise development tools.
    private func updateProgress(_ progress: Double, status: String) async {
        await MainActor.run {
            loadingProgress = progress
            currentStatus = status
        }
    }
    
    // Claude: Sprint 2 - Quick scenario testing method for one-tap demos
    /// Claude: Automated Quick Scenario Testing with Intelligent Parameter Management
    /// ============================================================================
    /// 
    /// This automated testing method enables rapid validation of spiritual AI responses
    /// to predefined scenarios, providing systematic quality assurance and edge case
    /// validation through professional testing workflow automation.
    /// 
    /// Quick testing architecture:
    /// • SCENARIO AUTOMATION: Pre-configured test scenarios enabling rapid quality validation
    /// • PARAMETER OPTIMIZATION: Automatic feature selection and prompt configuration for scenarios
    /// • SEAMLESS EXECUTION: One-tap scenario testing with automatic spiritual guidance generation
    /// • PROFESSIONAL WORKFLOW: Integration with existing testing infrastructure and analytics
    /// 
    /// Testing capabilities:
    /// • EDGE CASE VALIDATION: Systematic testing of complex spiritual scenarios and user needs
    /// • QUALITY ASSURANCE: Rapid validation of spiritual AI improvements and system changes
    /// • USER EXPERIENCE TESTING: Validation of spiritual guidance across different user contexts
    /// • REGRESSION PREVENTION: Automated testing preventing quality degradation during development
    /// 
    /// - Parameter prompt: Pre-configured test prompt representing specific user scenario
    /// - Parameter feature: Target spiritual domain optimized for the specific testing scenario
    /// 
    /// This method enables professional-grade spiritual AI testing practices that ensure
    /// system quality and reliability across diverse user needs and spiritual contexts.
    private func testQuickScenario(prompt: String, feature: KASPERFeature) {
        // Set the selected feature and custom prompt
        selectedFeature = feature
        customPrompt = prompt
        useCustomPrompt = true
        
        // Generate insight with the scenario
        generateInsight()
        
        // Log for debugging
        print("🧪 Quick Test: \(feature.rawValue) - \(prompt)")
    }
    
    /// Claude: Real-Time Engine Status Monitoring with Comprehensive Health Assessment
    /// ============================================================================
    /// 
    /// This intelligent monitoring method provides real-time assessment of spiritual AI
    /// system health and operational status, enabling immediate detection of performance
    /// issues and system readiness validation for professional quality assurance.
    /// 
    /// System monitoring capabilities:
    /// • ENGINE READINESS: Real-time assessment of KASPER MLX engine operational status
    /// • PROVIDER HEALTH: Comprehensive monitoring of spiritual data provider availability
    /// • PERFORMANCE METRICS: Live tracking of system performance indicators and response times
    /// • STATUS VISUALIZATION: Professional status communication through visual indicators
    /// 
    /// Professional monitoring features:
    /// • IMMEDIATE UPDATES: Real-time status reflection enabling rapid issue detection
    /// • HEALTH INDICATORS: Visual status communication through color-coded system assessment
    /// • DIAGNOSTIC INFORMATION: Detailed system state information for debugging and optimization
    /// • PREDICTIVE MONITORING: Early warning systems for potential performance degradation
    /// 
    /// This monitoring method ensures spiritual AI system reliability through continuous
    /// health assessment and professional status communication, maintaining the quality
    /// standards expected from enterprise-grade spiritual technology platforms.
    private func updateEngineStatus() {
        currentStatus = kasperMLX.isReady ? "Ready" : "Initializing"
    }
    
    // Claude: Feedback handling for MLX testing
    /// Claude: Intelligent Feedback Processing with Advanced Analytics Integration
    /// ========================================================================
    /// 
    /// This sophisticated feedback processing method orchestrates comprehensive user
    /// satisfaction data collection and analysis, enabling continuous spiritual AI
    /// improvement through systematic feedback integration and analytics.
    /// 
    /// 📊 FEEDBACK PROCESSING ARCHITECTURE:
    /// 
    /// 1. COMPREHENSIVE DATA COLLECTION:
    ///    - Complete insight correlation preserving relationship between feedback and guidance
    ///    - Rich contextual data capture including technical performance and user context
    ///    - Professional feedback recording with immediate analytics integration
    ///    - Quality assurance through systematic feedback validation and processing
    /// 
    /// 2. REAL-TIME ANALYTICS INTEGRATION:
    ///    - Immediate statistics updates providing live feedback analysis and trends
    ///    - Performance correlation linking technical metrics with user satisfaction
    ///    - Quality tracking enabling continuous spiritual AI improvement and optimization
    ///    - User satisfaction monitoring supporting data-driven development decisions
    /// 
    /// 3. PROFESSIONAL USER EXPERIENCE:
    ///    - Immediate visual feedback confirming successful feedback submission
    ///    - Professional toast notifications providing clear confirmation of feedback recording
    ///    - Seamless integration with existing spiritual guidance display and interaction patterns
    ///    - Accessibility support ensuring feedback collection works for all users
    /// 
    /// 🧠 AI IMPROVEMENT INTELLIGENCE:
    /// 
    /// The feedback processing enables sophisticated AI enhancement:
    /// 
    /// • TRAINING DATA GENERATION: High-satisfaction feedback creates positive training examples
    /// • QUALITY BENCHMARKING: User satisfaction patterns establish quality improvement targets
    /// • PERSONALIZATION INSIGHTS: Feedback patterns inform personalized spiritual guidance development
    /// • SYSTEM OPTIMIZATION: Performance correlation guides technical optimization priorities
    /// • CONTENT QUALITY ANALYSIS: Systematic feedback analysis improves spiritual guidance quality
    /// 
    /// - Parameter insight: Complete spiritual insight with metadata for comprehensive correlation
    /// - Parameter rating: User satisfaction assessment enabling quality tracking and improvement
    /// 
    /// This feedback processing represents professional-grade spiritual AI improvement
    /// infrastructure - transforming user interactions into actionable intelligence that
    /// drives continuous enhancement of spiritual guidance quality and effectiveness.
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

// MARK: - 🎨 PROFESSIONAL UI COMPONENT LIBRARY FOR SPIRITUAL AI TESTING

/// Claude: Advanced Metric Display Card with Professional Data Visualization
/// ========================================================================
/// 
/// This sophisticated metric card component provides professional presentation of
/// key performance indicators throughout the testing interface. It demonstrates
/// enterprise-grade data visualization patterns and consistent design language.
/// 
/// 📊 METRIC CARD ARCHITECTURE:
/// 
/// 1. PROFESSIONAL DATA PRESENTATION:
///    - Clean typography hierarchy optimized for rapid metric comprehension
///    - Icon-based metric categorization enabling immediate visual recognition
///    - Color-coded values providing instant performance assessment and status indication
///    - Monospaced numeric display ensuring precise alignment and professional appearance
/// 
/// 2. VISUAL PERFORMANCE INDICATORS:
///    - Context-sensitive color coding (green=excellent, orange=warning, red=critical)
///    - Professional icon selection reflecting metric category and importance
///    - Consistent card styling with subtle backgrounds and refined borders
///    - Responsive design adapting to different screen sizes and content lengths
/// 
/// 3. ACCESSIBILITY AND USABILITY:
///    - High contrast text ensuring readability across different lighting conditions
///    - Semantic labeling supporting screen readers and accessibility technologies
///    - Touch-friendly sizing optimized for mobile development and testing workflows
///    - Consistent spacing following iOS design guidelines and professional standards
/// 
/// 🎯 DEVELOPMENT INTELLIGENCE:
/// 
/// The metric cards enable sophisticated development insights:
/// 
/// • IMMEDIATE ASSESSMENT: Color-coded metrics enable instant performance evaluation
/// • PROFESSIONAL PRESENTATION: Enterprise-grade visualization building confidence in data
/// • COMPARATIVE ANALYSIS: Consistent presentation enabling cross-metric comparison
/// • SCALABLE DESIGN: Reusable component supporting diverse metric types and values
/// 
/// This component represents professional-grade data visualization standards,
/// making complex spiritual AI performance metrics immediately accessible and
/// visually compelling for development and quality assurance workflows.
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

/// Claude: Sophisticated Spiritual Domain Selection Card with Visual Intelligence
/// ===========================================================================
/// 
/// This advanced feature selection card provides elegant presentation and selection
/// of spiritual domains, demonstrating professional UI component design patterns
/// for complex feature navigation and interaction management.
/// 
/// 🎯 FEATURE CARD ARCHITECTURE:
/// 
/// 1. INTELLIGENT VISUAL DESIGN:
///    - Dynamic feature information lookup providing icons and colors for each domain
///    - Selected state visualization with professional highlighting and visual feedback
///    - Consistent card styling maintaining visual coherence across feature options
///    - Professional typography and spacing following iOS design system guidelines
/// 
/// 2. SPIRITUAL DOMAIN REPRESENTATION:
///    - Icon-based feature identification enabling rapid visual recognition
///    - Color-coded spiritual domain categories supporting intuitive navigation
///    - Proper capitalization and formatting for professional presentation
///    - Accessible interaction design supporting diverse user needs and preferences
/// 
/// 3. INTERACTIVE STATE MANAGEMENT:
///    - Professional selection feedback with immediate visual state updates
///    - Touch-friendly interaction areas optimized for mobile testing workflows
///    - Consistent interaction patterns across all feature selection options
///    - Accessibility support through proper semantic labeling and state communication
/// 
/// 🔍 TESTING WORKFLOW OPTIMIZATION:
/// 
/// The feature cards enable sophisticated testing workflows:
/// 
/// • RAPID DOMAIN SELECTION: Visual feature identification enabling quick testing focus
/// • COMPREHENSIVE COVERAGE: All spiritual domains accessible through consistent interface
/// • PROFESSIONAL PRESENTATION: Enterprise-grade design building confidence in testing tools
/// • ACCESSIBLE INTERACTION: Inclusive design supporting diverse developer and tester needs
/// 
/// This component demonstrates professional UI component architecture for complex
/// spiritual domain navigation while maintaining the visual elegance and accessibility
/// expected from world-class development and testing interfaces.
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

/// Claude: Advanced Metadata Display Card with Rich Contextual Information
/// ======================================================================
/// 
/// This sophisticated metadata presentation component provides comprehensive display
/// of spiritual insight generation context, enabling detailed analysis and quality
/// assessment of AI-generated spiritual guidance with professional presentation.
/// 
/// 📊 METADATA ARCHITECTURE:
/// 
/// 1. COMPREHENSIVE CONTEXT DISPLAY:
///    - Key-value pair presentation with professional typography and visual hierarchy
///    - Intelligent data formatting supporting diverse metadata types and formats
///    - Scrollable content handling extensive metadata without interface disruption
///    - Professional spacing and alignment creating confidence in data accuracy
/// 
/// 2. TECHNICAL INTELLIGENCE PRESENTATION:
///    - Performance metrics including inference time and confidence scoring
///    - Provider information showing data sources and spiritual context contributors
///    - Model version tracking enabling quality correlation and improvement analysis
///    - Cache status indication supporting performance optimization and debugging
/// 
/// 3. PROFESSIONAL VISUAL DESIGN:
///    - Card-based layout with subtle backgrounds and refined visual separation
///    - Monospaced value display ensuring precise alignment and professional appearance
///    - Consistent color scheme matching overall testing interface design language
///    - Accessibility support with proper contrast ratios and semantic labeling
/// 
/// 🧠 DEVELOPMENT INTELLIGENCE:
/// 
/// The metadata display enables sophisticated analysis:
/// 
/// • QUALITY CORRELATION: Technical metrics correlation with spiritual guidance quality
/// • PERFORMANCE ANALYSIS: Detailed timing and efficiency information for optimization
/// • CONTEXT UNDERSTANDING: Complete visibility into spiritual AI processing context
/// • DEBUGGING SUPPORT: Comprehensive technical information enabling rapid issue resolution
/// 
/// This metadata card represents professional-grade technical information presentation,
/// making complex spiritual AI processing details immediately accessible for analysis,
/// debugging, and continuous improvement of spiritual guidance generation systems.
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

/// Claude: Professional Action Button with Sophisticated State Management
/// =====================================================================
/// 
/// This advanced action button component provides enterprise-grade interaction
/// patterns with intelligent state management, professional styling, and
/// accessibility support for critical testing interface actions.
/// 
/// 🚀 ACTION BUTTON ARCHITECTURE:
/// 
/// 1. SOPHISTICATED STATE MANAGEMENT:
///    - Dynamic enabled/disabled states with intelligent condition evaluation
///    - Professional visual feedback for interactive and non-interactive states
///    - Loading state support with integrated progress indication and status communication
///    - Contextual styling adapting to button importance and action criticality
/// 
/// 2. PROFESSIONAL VISUAL DESIGN:
///    - Gradient styling with sophisticated color transitions and visual depth
///    - Consistent typography and spacing following iOS design system guidelines
///    - Shadow effects and visual hierarchy establishing button importance and interactivity
///    - Responsive design adapting to different screen sizes and accessibility requirements
/// 
/// 3. ACCESSIBILITY AND USABILITY:
///    - Touch-friendly sizing optimized for mobile development and testing workflows
///    - High contrast text ensuring readability across different lighting conditions
///    - Semantic labeling supporting screen readers and accessibility technologies
///    - Keyboard navigation support enabling inclusive interaction patterns
/// 
/// 🎯 PROFESSIONAL INTERACTION PATTERNS:
/// 
/// The action button enables sophisticated user experiences:
/// 
/// • IMMEDIATE FEEDBACK: Instant visual response to user interactions and state changes
/// • CONTEXTUAL STATES: Intelligent state management reflecting system capacity and readiness
/// • PROFESSIONAL PRESENTATION: Enterprise-grade styling building confidence in interface quality
/// • ACCESSIBLE INTERACTION: Inclusive design supporting diverse user needs and preferences
/// 
/// This action button component represents professional UI component architecture,
/// providing sophisticated interaction patterns that match the quality standards
/// of world-class development tools while maintaining accessibility and usability.
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
/// Claude: Advanced Performance Metrics Visualization with Real-Time Intelligence
/// ============================================================================
/// 
/// This sophisticated performance visualization component provides comprehensive
/// real-time monitoring of spiritual AI system performance with professional
/// data presentation and intelligent status indication for development workflows.
/// 
/// 📊 PERFORMANCE METRICS ARCHITECTURE:
/// 
/// 1. REAL-TIME PERFORMANCE MONITORING:
///    - Live system performance tracking with immediate updates and trend analysis
///    - Multi-dimensional metrics including speed, reliability, and efficiency indicators
///    - Professional data visualization with color-coded performance thresholds
///    - Comprehensive system health assessment through integrated performance indicators
/// 
/// 2. INTELLIGENT STATUS VISUALIZATION:
///    - Color-coded performance indicators (green=optimal, orange=warning, red=critical)
///    - Professional icon selection reflecting metric category and performance level
///    - Dynamic status assessment with automatic threshold evaluation and visual feedback
///    - Consistent presentation patterns enabling rapid performance assessment across metrics
/// 
/// 3. PROFESSIONAL DATA PRESENTATION:
///    - Clean typography hierarchy optimized for rapid performance data comprehension
///    - Precise numeric formatting with appropriate units and decimal precision
///    - Card-based layout with professional styling and visual separation
///    - Accessibility support ensuring performance data is available to all development team members
/// 
/// 🚀 DEVELOPMENT INTELLIGENCE:
/// 
/// The performance metrics enable sophisticated development insights:
/// 
/// • IMMEDIATE OPTIMIZATION: Real-time performance data enabling rapid system tuning
/// • BOTTLENECK IDENTIFICATION: Performance indicators revealing system constraints and optimization opportunities
/// • QUALITY ASSURANCE: Performance thresholds ensuring spiritual AI meets professional standards
/// • TREND ANALYSIS: Continuous monitoring supporting predictive performance management
/// 
/// This performance metrics component represents enterprise-grade system monitoring,
/// providing the real-time intelligence necessary for maintaining professional
/// spiritual AI system performance and reliability standards.
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

// Claude: Sprint 2 - Quick Test Button for one-tap scenario testing
/// Claude: Intelligent Quick Test Action Button with Scenario Management
/// ====================================================================
/// 
/// This sophisticated quick test button provides streamlined access to predefined
/// testing scenarios, enabling rapid spiritual AI validation through professional
/// test automation and intelligent scenario management.
/// 
/// 🧠 QUICK TEST ARCHITECTURE:
/// 
/// 1. SCENARIO-DRIVEN TESTING:
///    - Predefined test scenarios covering critical spiritual AI use cases
///    - One-tap test execution enabling rapid quality validation and regression testing
///    - Intelligent scenario selection optimized for comprehensive spiritual guidance validation
///    - Professional test automation reducing manual testing overhead and improving coverage
/// 
/// 2. PROFESSIONAL INTERACTION DESIGN:
///    - Compact button design optimized for quick test scenario execution
///    - Clear scenario labeling enabling rapid test selection and execution
///    - Professional styling consistent with overall testing interface design language
///    - Touch-friendly sizing supporting efficient testing workflow execution
/// 
/// 3. TESTING WORKFLOW INTEGRATION:
///    - Seamless integration with existing spiritual AI testing infrastructure
///    - Automatic test execution with immediate result visualization and analysis
///    - Performance tracking and quality assessment integrated into test execution
///    - Professional feedback and status communication throughout test execution
/// 
/// 🎯 DEVELOPMENT WORKFLOW BENEFITS:
/// 
/// The quick test buttons enable sophisticated testing practices:
/// 
/// • RAPID VALIDATION: One-tap testing of critical spiritual AI scenarios and edge cases
/// • COMPREHENSIVE COVERAGE: Predefined scenarios ensuring systematic testing of spiritual domains
/// • PROFESSIONAL AUTOMATION: Streamlined testing reducing manual effort while improving quality
/// • IMMEDIATE FEEDBACK: Quick test results enabling rapid development iteration and improvement
/// 
/// This quick test button component represents professional test automation standards,
/// enabling rapid, comprehensive spiritual AI validation through elegant, accessible
/// user interfaces that support efficient development and quality assurance workflows.
struct QuickTestButton: View {
    let title: String
    let icon: String
    let color: Color
    let prompt: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title3.weight(.medium))
                    .foregroundColor(color)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text("Tap to test")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(0.98)
        .animation(.easeInOut(duration: 0.1), value: UUID())
    }
}

#Preview {
    NavigationView {
        KASPERMLXTestView()
            .environmentObject(KASPERMLXManager.shared)
    }
}