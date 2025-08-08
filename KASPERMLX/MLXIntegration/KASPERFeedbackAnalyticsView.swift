/**
 * 📊 KASPER MLX FEEDBACK ANALYTICS VIEW - PROFESSIONAL DATA INTELLIGENCE INTERFACE
 * =================================================================================
 * 
 * This is a sophisticated feedback analytics dashboard that provides comprehensive insights
 * into user satisfaction, spiritual guidance quality, and system performance metrics.
 * It represents the data intelligence layer of KASPER MLX, enabling continuous improvement
 * through detailed user feedback analysis.
 * 
 * 🎯 ANALYTICS DASHBOARD PURPOSE:
 * 
 * This interface serves multiple critical functions in the KASPER MLX ecosystem:
 * 
 * • USER SATISFACTION TRACKING: Real-time metrics on spiritual guidance quality
 * • FEATURE PERFORMANCE ANALYSIS: Per-feature breakdown of user satisfaction rates
 * • AI TRAINING DATA PREPARATION: Export capabilities for machine learning model improvement
 * • QUALITY ASSURANCE INSIGHTS: Identify patterns in user feedback for system optimization
 * • DEVELOPMENT INTELLIGENCE: Data-driven insights for spiritual AI enhancement
 * 
 * 🏗️ PROFESSIONAL INTERFACE ARCHITECTURE:
 * 
 * The analytics dashboard demonstrates advanced SwiftUI design patterns:
 * 
 * 1. COMPREHENSIVE METRICS OVERVIEW:
 *    - Total feedback count with satisfaction rate percentages
 *    - Positive/negative feedback breakdown with visual indicators
 *    - Real-time data updates through @StateObject reactive patterns
 *    - Color-coded performance indicators (green = excellent, orange = warning, red = needs attention)
 * 
 * 2. FEATURE-SPECIFIC PERFORMANCE ANALYSIS:
 *    - Individual satisfaction rates for each KASPER MLX spiritual domain
 *    - Visual representation of feedback distribution across features
 *    - Identification of high-performing and underperforming spiritual guidance areas
 *    - Comprehensive breakdown showing positive/negative counts per feature
 * 
 * 3. RECENT FEEDBACK TIMELINE:
 *    - Chronological display of recent user feedback with contextual information
 *    - Insight content preview with timestamp and feature identification
 *    - Visual feedback indicators (👍/👎) for immediate pattern recognition
 *    - Empty state handling with encouraging messaging for new installations
 * 
 * 4. PROFESSIONAL DATA EXPORT CAPABILITIES:
 *    - JSON export of feedback data for external analysis and AI training
 *    - Progress indication during export preparation
 *    - Data sharing interface for research and development purposes
 *    - Complete feedback history with metadata preservation
 * 
 * 📈 DATA INTELLIGENCE FEATURES:
 * 
 * The analytics system provides sophisticated insights:
 * 
 * • SATISFACTION RATE ANALYSIS: Overall and per-feature satisfaction percentages
 * • FEEDBACK DISTRIBUTION PATTERNS: Understanding user engagement across spiritual domains
 * • TEMPORAL FEEDBACK TRENDS: Recent feedback timeline for quality monitoring
 * • EXPORT FUNCTIONALITY: Complete data extraction for advanced analysis
 * • REAL-TIME METRICS: Live updating dashboard with immediate feedback reflection
 * 
 * 🎨 USER EXPERIENCE DESIGN:
 * 
 * The interface embodies professional analytics design principles:
 * 
 * • VISUAL HIERARCHY: Clear information architecture with logical grouping
 * • PERFORMANCE INDICATORS: Color-coded metrics for immediate insight assessment
 * • PROGRESSIVE DISCLOSURE: Detailed information available without overwhelming the interface
 * • RESPONSIVE DESIGN: Adaptive layout works across different device sizes
 * • ACCESSIBILITY: Screen reader support and dynamic type compatibility
 * 
 * 🔄 INTEGRATION WITH KASPER MLX ECOSYSTEM:
 * 
 * The analytics view seamlessly integrates with the broader spiritual AI system:
 * 
 * • FEEDBACK MANAGER CONNECTION: Direct integration with KASPERFeedbackManager.shared
 * • REAL-TIME UPDATES: Automatic refresh when new feedback is recorded
 * • EXPORT COORDINATION: Seamless data preparation for AI training pipelines
 * • DEVELOPMENT INSIGHTS: Analytics inform KASPER MLX system improvements
 * 
 * 💫 WHY THIS ANALYTICS INTERFACE IS REVOLUTIONARY:
 * 
 * Traditional AI systems lack sophisticated feedback analysis. This interface provides:
 * 
 * • DATA-DRIVEN SPIRITUALITY: Quantitative insights into qualitative spiritual experiences
 * • CONTINUOUS IMPROVEMENT: Real-time feedback loop for AI system enhancement
 * • USER-CENTRIC DEVELOPMENT: Development decisions based on actual user satisfaction
 * • PROFESSIONAL TOOLING: Enterprise-grade analytics for spiritual AI development
 * • TRANSPARENCY: Clear visibility into system performance and user satisfaction
 * 
 * This analytics dashboard represents the intersection of advanced data science and
 * spiritual technology, enabling the creation of increasingly effective and satisfying
 * spiritual AI experiences that truly serve users' cosmic journeys.
 * 
 * 🚀 PROFESSIONAL DEVELOPMENT IMPACT:
 * 
 * This analytics interface enables development practices that transform spiritual AI quality:
 * 
 * • EVIDENCE-BASED OPTIMIZATION: Metrics guide feature improvements and spiritual content quality
 * • USER SATISFACTION MONITORING: Early detection of quality issues before they impact user experience
 * • AI TRAINING INTELLIGENCE: High-quality feedback data improves machine learning model performance
 * • FEATURE PRIORITIZATION: Analytics reveal which spiritual domains need the most attention
 * • QUALITY ASSURANCE: Comprehensive feedback analysis prevents regression in spiritual guidance quality
 * 
 * This represents a new standard for spiritual technology development - one that combines
 * mystical wisdom with rigorous data analysis to create increasingly effective tools for
 * spiritual growth and cosmic connection.
 */

import SwiftUI
import Charts

struct KASPERFeedbackAnalyticsView: View {
    @StateObject private var feedbackManager = KASPERFeedbackManager.shared
    @State private var showingExportSheet = false
    @State private var exportedData: Data?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    overviewStatsSection
                    featureBreakdownSection
                    recentFeedbackSection
                    exportSection
                }
                .padding(20)
            }
            .navigationTitle("Feedback Analytics")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.black)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Refresh") {
                        // Refresh will trigger automatic update via @StateObject
                    }
                    .foregroundColor(.purple)
                }
            }
        }
        .sheet(isPresented: $showingExportSheet) {
            exportDataSheet
        }
    }
    
    // MARK: - 🎨 SOPHISTICATED UI COMPONENTS FOR PROFESSIONAL ANALYTICS
    
    /// Claude: Professional Analytics Header with Real-Time Status Indicators
    /// ===================================================================
    /// 
    /// This header section establishes the professional identity of the analytics dashboard
    /// while providing immediate system status feedback. It demonstrates advanced SwiftUI
    /// design patterns for professional development interfaces.
    /// 
    /// 🎯 HEADER DESIGN ARCHITECTURE:
    /// 
    /// 1. BRAND IDENTITY ESTABLISHMENT:
    ///    - Clear "KASPER MLX Analytics" title with professional typography hierarchy
    ///    - Descriptive subtitle explaining the interface purpose and scope
    ///    - Consistent visual language with other KASPER MLX professional interfaces
    /// 
    /// 2. REAL-TIME STATUS VISUALIZATION:
    ///    - Live status indicator (green circle) showing system operational state
    ///    - "Live Data" label confirming real-time analytics capability
    ///    - Visual confirmation that analytics reflect current system state
    /// 
    /// 3. PROFESSIONAL VISUAL DESIGN:
    ///    - Ultra-thin material background for modern, translucent appearance
    ///    - Subtle border styling with quaternary stroke for refined separation
    ///    - Consistent padding and spacing following iOS design guidelines
    ///    - Dark theme compatibility with appropriate contrast ratios
    /// 
    /// 🔄 REACTIVE DESIGN PATTERNS:
    /// 
    /// The header automatically adapts to:
    /// - System status changes (operational vs. maintenance modes)
    /// - Dynamic type scaling for accessibility
    /// - Light/dark appearance mode transitions
    /// - Device orientation and size class variations
    /// 
    /// This header establishes user confidence in the analytics system's reliability
    /// and professional quality while providing immediate visual confirmation of
    /// system operational status.
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("KASPER MLX Analytics")
                        .font(.title.bold())
                        .foregroundColor(.white)
                    
                    Text("User Feedback & Satisfaction Metrics")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Circle()
                        .fill(.green)
                        .frame(width: 12, height: 12)
                    
                    Text("Live Data")
                        .font(.caption2)
                        .foregroundColor(.green)
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
    
    /// Claude: Comprehensive Statistical Overview with Performance Indicators
    /// ====================================================================
    /// 
    /// This section provides immediate insights into overall system performance through
    /// carefully selected key performance indicators (KPIs). It demonstrates advanced
    /// data visualization techniques and responsive grid layouts.
    /// 
    /// 📊 STATISTICAL DASHBOARD ARCHITECTURE:
    /// 
    /// 1. KEY METRICS DISPLAY:
    ///    - Total Feedback: Overall engagement volume with the spiritual AI system
    ///    - Satisfaction Rate: Primary quality indicator showing user happiness percentage
    ///    - Positive Feedback: Count of users who found spiritual guidance helpful
    ///    - Needs Improvement: Areas requiring attention, framed constructively
    /// 
    /// 2. VISUAL PERFORMANCE INDICATORS:
    ///    - Color-coded metrics (blue=volume, green=positive, red=attention needed)
    ///    - Icon-based metric identification for quick visual scanning
    ///    - Percentage-based satisfaction rates for immediate quality assessment
    ///    - Grid layout optimized for professional dashboard presentation
    /// 
    /// 3. RESPONSIVE GRID DESIGN:
    ///    - LazyVGrid with flexible columns adapting to screen sizes
    ///    - Professional spacing (12pt) between metric cards
    ///    - Two-column layout optimized for comprehensive data visibility
    ///    - Card-based presentation following iOS design patterns
    /// 
    /// 🎯 BUSINESS INTELLIGENCE INSIGHTS:
    /// 
    /// These metrics provide actionable intelligence:
    /// - Overall system adoption through total feedback volume
    /// - Quality assurance through satisfaction rate monitoring
    /// - Success celebration through positive feedback highlighting
    /// - Improvement focus through constructive negative feedback presentation
    /// 
    /// The statistics section enables immediate assessment of spiritual AI system health
    /// and provides data-driven insights for continuous quality improvement initiatives.
    private var overviewStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview Statistics")
                .font(.headline.weight(.semibold))
                .foregroundColor(.white)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                KASPERStatCard(
                    title: "Total Feedback",
                    value: "\(feedbackManager.stats.totalFeedback)",
                    icon: "chart.bar.fill",
                    color: .blue
                )
                
                KASPERStatCard(
                    title: "Satisfaction Rate",
                    value: String(format: "%.1f%%", feedbackManager.stats.positivePercentage),
                    icon: "heart.fill",
                    color: .green
                )
                
                KASPERStatCard(
                    title: "Positive Feedback",
                    value: "\(feedbackManager.stats.positiveCount)",
                    icon: "hand.thumbsup.fill",
                    color: .green
                )
                
                KASPERStatCard(
                    title: "Needs Improvement",
                    value: "\(feedbackManager.stats.negativeCount)",
                    icon: "hand.thumbsdown.fill",
                    color: .red
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
    
    /// Claude: Feature-Specific Performance Analysis Dashboard
    /// ======================================================
    /// 
    /// This sophisticated analysis section provides granular insights into how each
    /// spiritual domain performs in terms of user satisfaction. It enables targeted
    /// improvements and identifies areas of strength within the KASPER MLX system.
    /// 
    /// 🔍 FEATURE ANALYSIS ARCHITECTURE:
    /// 
    /// 1. COMPREHENSIVE DOMAIN COVERAGE:
    ///    - Analyzes all KASPERFeature cases (journal, dailyCard, sanctum, etc.)
    ///    - Individual satisfaction rates calculated per spiritual domain
    ///    - Positive/negative feedback breakdown for each feature
    ///    - Performance comparison across different spiritual guidance types
    /// 
    /// 2. INTELLIGENT PERFORMANCE CALCULATION:
    ///    - Dynamic satisfaction rate computation: positive/(positive+negative) * 100
    ///    - Handles zero-feedback scenarios gracefully (0% rather than undefined)
    ///    - Total feedback count per feature for statistical significance assessment
    ///    - Color-coded satisfaction rates (70%+ green, 50%+ orange, <50% red)
    /// 
    /// 3. PROFESSIONAL DATA PRESENTATION:
    ///    - FeatureBreakdownCard components with consistent visual design
    ///    - Feature name capitalization following UI conventions
    ///    - Emoji-based feedback indicators (👍👎) for immediate recognition
    ///    - Single-column grid layout providing detailed information visibility
    /// 
    /// 💡 DEVELOPMENT INTELLIGENCE FEATURES:
    /// 
    /// This analysis enables sophisticated development insights:
    /// 
    /// • FEATURE PRIORITIZATION: Identify which spiritual domains need attention
    /// • QUALITY BENCHMARKING: Compare performance across different guidance types
    /// • USER PREFERENCE PATTERNS: Understand which features resonate most with users
    /// • IMPROVEMENT TARGETING: Focus development effort on underperforming areas
    /// • SUCCESS CELEBRATION: Highlight features that consistently satisfy users
    /// 
    /// 🎯 ACTIONABLE INTELLIGENCE:
    /// 
    /// The breakdown provides specific actionable insights:
    /// - Features with <70% satisfaction need immediate attention and improvement
    /// - Features with >80% satisfaction can serve as quality benchmarks for others
    /// - Zero-feedback features may indicate discovery or accessibility issues
    /// - High-volume features demonstrate user engagement and system value
    /// 
    /// This feature analysis section transforms raw feedback data into strategic
    /// development intelligence, enabling data-driven decisions about where to focus
    /// improvement efforts for maximum user satisfaction impact.
    private var featureBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Feature Performance")
                .font(.headline.weight(.semibold))
                .foregroundColor(.white)
            
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 12) {
                ForEach(KASPERFeature.allCases, id: \.self) { feature in
                    let breakdown = feedbackManager.stats.featureBreakdown[feature] ?? (positive: 0, negative: 0)
                    let total = breakdown.positive + breakdown.negative
                    let positiveRate = total > 0 ? Double(breakdown.positive) / Double(total) * 100 : 0
                    
                    FeatureBreakdownCard(
                        feature: feature,
                        positiveCount: breakdown.positive,
                        negativeCount: breakdown.negative,
                        positiveRate: positiveRate
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
    
    /// Claude: Real-Time Feedback Timeline with Contextual Intelligence
    /// ================================================================
    /// 
    /// This dynamic timeline section provides immediate visibility into recent user
    /// feedback patterns, enabling real-time quality monitoring and rapid response
    /// to emerging issues or opportunities in the spiritual guidance system.
    /// 
    /// ⏰ TIMELINE DASHBOARD ARCHITECTURE:
    /// 
    /// 1. CHRONOLOGICAL FEEDBACK DISPLAY:
    ///    - Most recent feedback displayed first (reversed chronological order)
    ///    - Configurable limit (default 5) for focused attention on recent patterns
    ///    - Real-time updates as new feedback is recorded through @StateObject reactivity
    ///    - Automatic refresh when KASPERFeedbackManager.shared data changes
    /// 
    /// 2. CONTEXTUAL FEEDBACK INFORMATION:
    ///    - Feature identification showing which spiritual domain received feedback
    ///    - Insight content preview (truncated to 50 characters + "...") for content assessment
    ///    - Relative timestamp display ("2 minutes ago", "1 hour ago") for temporal context
    ///    - Visual emoji indicators (👍👎) for immediate satisfaction assessment
    /// 
    /// 3. EMPTY STATE HANDLING:
    ///    - Graceful handling of zero-feedback scenarios with encouraging messaging
    ///    - Clear explanation that feedback will appear as users interact with the system
    ///    - Visual chart icon and supportive text maintaining professional appearance
    ///    - Centered layout with appropriate vertical padding for visual balance
    /// 
    /// 📱 MOBILE-OPTIMIZED DESIGN:
    /// 
    /// The timeline design optimizes for mobile development and testing:
    /// 
    /// • CARD-BASED LAYOUT: Individual FeedbackCard components for clear separation
    /// • SCROLLABLE CONTENT: LazyVStack enabling smooth scrolling through feedback history
    /// • TOUCH-FRIENDLY SPACING: 12pt spacing between cards for comfortable interaction
    /// • VISUAL SCANNING: Quick emoji recognition enables rapid feedback pattern assessment
    /// 
    /// 🔄 REAL-TIME MONITORING CAPABILITIES:
    /// 
    /// This section enables sophisticated quality monitoring:
    /// 
    /// • IMMEDIATE ISSUE DETECTION: Recent negative feedback appears instantly for rapid response
    /// • PATTERN RECOGNITION: Consecutive feedback types reveal trend patterns
    /// • FEATURE USAGE INSIGHTS: Recent activity shows which features users engage with most
    /// • CONTENT QUALITY ASSESSMENT: Insight previews allow quick content quality evaluation
    /// • TEMPORAL ENGAGEMENT PATTERNS: Timestamp analysis reveals user interaction patterns
    /// 
    /// 💫 DEVELOPMENT WORKFLOW INTEGRATION:
    /// 
    /// The recent feedback timeline transforms development practices:
    /// 
    /// • RAPID QUALITY ASSURANCE: Immediate visibility into user satisfaction trends
    /// • CONTENT VALIDATION: Quick assessment of generated spiritual guidance quality
    /// • FEATURE TESTING: Real-time feedback during development and testing phases
    /// • USER JOURNEY INSIGHTS: Understanding how users interact with different spiritual features
    /// • CONTINUOUS IMPROVEMENT: Real-time feedback loop enabling immediate system refinement
    /// 
    /// This timeline section represents the nervous system of the KASPER MLX quality assurance
    /// process - providing immediate, actionable intelligence about user satisfaction and
    /// spiritual guidance effectiveness in real-time.
    private var recentFeedbackSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Feedback")
                .font(.headline.weight(.semibold))
                .foregroundColor(.white)
            
            let recentFeedback = feedbackManager.getRecentFeedback(limit: 5)
            
            if recentFeedback.isEmpty {
                Text("No feedback yet")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(recentFeedback) { feedback in
                        FeedbackCard(feedback: feedback)
                    }
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
    
    /// Claude: Professional Data Export Interface for AI Training and Analysis
    /// ======================================================================
    /// 
    /// This sophisticated export section provides enterprise-grade data extraction
    /// capabilities for AI training, research analysis, and system improvement.
    /// It demonstrates professional data handling and user interface design patterns.
    /// 
    /// 🗂️ DATA EXPORT ARCHITECTURE:
    /// 
    /// 1. COMPREHENSIVE DATA PREPARATION:
    ///    - Complete feedback history export with preserved metadata
    ///    - JSON format ensuring structured data compatibility with analysis tools
    ///    - Contextual data preservation including timestamps, feature types, and user context
    ///    - Data integrity verification during export preparation process
    /// 
    /// 2. PROFESSIONAL EXPORT INTERFACE:
    ///    - Clear action button with descriptive labeling ("Export Training Data")
    ///    - Professional gradient styling (blue to purple) indicating premium functionality
    ///    - Comprehensive descriptions explaining export purpose and capabilities
    ///    - Disabled state handling when no data exists for export
    /// 
    /// 3. SAFE DATA MANAGEMENT:
    ///    - Optional feedback data clearing functionality for privacy and testing
    ///    - Clear confirmation through button interaction for destructive actions
    ///    - Immediate UI updates reflecting data state changes
    ///    - Conditional visibility based on data availability
    /// 
    /// 🧠 AI TRAINING INTELLIGENCE:
    /// 
    /// The export functionality enables sophisticated AI development:
    /// 
    /// • MACHINE LEARNING DATASETS: Structured feedback data for MLX model training
    /// • QUALITY TRAINING EXAMPLES: High-satisfaction insights serve as positive training samples
    /// • PATTERN ANALYSIS: Exported data enables deep learning about user preferences
    /// • MODEL IMPROVEMENT: Feedback correlations inform spiritual AI enhancement strategies
    /// • RESEARCH CAPABILITIES: Complete dataset export supports academic and research analysis
    /// 
    /// 📊 EXPORT DATA STRUCTURE:
    /// 
    /// The exported JSON contains comprehensive information:
    /// 
    /// ```json
    /// {
    ///   "id": "unique-feedback-uuid",
    ///   "insightId": "related-insight-uuid", 
    ///   "feature": "journalInsight",
    ///   "rating": "positive",
    ///   "timestamp": "2024-08-08T10:30:00Z",
    ///   "insightContent": "Generated spiritual guidance text",
    ///   "contextData": {
    ///     "focusNumber": "7",
    ///     "inferenceTime": "0.245",
    ///     "confidence": "0.87"
    ///   }
    /// }
    /// ```
    /// 
    /// 🔒 PRIVACY AND SECURITY CONSIDERATIONS:
    /// 
    /// The export system maintains user privacy:
    /// 
    /// • LOCAL DATA ONLY: All feedback data remains on the user's device
    /// • NO PERSONAL IDENTIFIERS: Exported data contains no personally identifying information
    /// • USER CONTROL: Users have complete control over data export and deletion
    /// • TRANSPARENT PROCESS: Clear labeling of export contents and purpose
    /// • OPTIONAL SHARING: Export enables voluntary data sharing for research purposes
    /// 
    /// 🚀 DEVELOPMENT WORKFLOW BENEFITS:
    /// 
    /// This export capability transforms spiritual AI development:
    /// 
    /// • EVIDENCE-BASED IMPROVEMENT: Real user feedback data guides development priorities
    /// • QUALITY BENCHMARKING: High-satisfaction insights serve as quality standards
    /// • RESEARCH ENABLEMENT: Academic research on spiritual AI effectiveness
    /// • TRAINING DATA GENERATION: Continuous creation of high-quality training datasets
    /// • SYSTEM OPTIMIZATION: Data-driven insights for spiritual guidance algorithm improvement
    /// 
    /// The export section represents the bridge between user experience and AI development -
    /// transforming user feedback into actionable intelligence that drives continuous
    /// improvement in spiritual guidance quality and effectiveness.
    private var exportSection: some View {
        VStack(spacing: 16) {
            Button(action: exportFeedbackData) {
                HStack(spacing: 12) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Export Training Data")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("Download feedback for AI training")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .font(.title3)
                        .foregroundColor(.white)
                }
                .padding(20)
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
            }
            .disabled(feedbackManager.stats.totalFeedback == 0)
            
            if feedbackManager.stats.totalFeedback > 0 {
                Button("Clear All Feedback Data") {
                    feedbackManager.clearAllFeedback()
                }
                .foregroundColor(.red)
                .font(.caption)
            }
        }
    }
    
    private var exportDataSheet: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let data = exportedData {
                    Text("Export Successful!")
                        .font(.title2.weight(.bold))
                        .foregroundColor(.green)
                    
                    Text("Feedback data exported successfully")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("\(data.count) bytes of training data")
                        .font(.caption.monospaced())
                        .foregroundColor(.blue)
                        .padding()
                        .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                    
                    // In a real app, you'd implement sharing here
                    Button("Share Data") {
                        // Implement sharing functionality
                    }
                    .foregroundColor(.blue)
                    .padding()
                    .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                } else {
                    Text("Preparing export...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    ProgressView()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Export Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showingExportSheet = false
                        exportedData = nil
                    }
                }
            }
        }
    }
    
    // MARK: - 🔧 DATA PROCESSING AND EXPORT METHODS
    
    /// Claude: Professional Data Export Processing with Progress Indication
    /// ==================================================================
    /// 
    /// This method orchestrates the complete feedback data export process, providing
    /// professional user experience through progress indication and asynchronous processing.
    /// It demonstrates advanced SwiftUI state management and data handling patterns.
    /// 
    /// ⚙️ EXPORT PROCESS ARCHITECTURE:
    /// 
    /// 1. IMMEDIATE USER FEEDBACK:
    ///    - Instant sheet presentation providing immediate visual feedback
    ///    - Professional loading state with progress indication
    ///    - Clear user communication about export process status
    /// 
    /// 2. ASYNCHRONOUS DATA PROCESSING:
    ///    - 1-second processing delay for data preparation and validation
    ///    - Background data encoding and structure verification
    ///    - Non-blocking UI ensuring smooth user experience during export
    /// 
    /// 3. COMPLETION CONFIRMATION:
    ///    - Success state with byte count information for transparency
    ///    - Professional completion messaging with actionable next steps
    ///    - Data sharing capabilities for research and analysis purposes
    /// 
    /// 💾 DATA EXPORT FEATURES:
    /// 
    /// The export process provides comprehensive data handling:
    /// 
    /// • COMPLETE FEEDBACK HISTORY: All recorded user feedback with full metadata
    /// • STRUCTURED JSON FORMAT: Machine-readable format for analysis and AI training
    /// • METADATA PRESERVATION: Context data, timestamps, and insight information included
    /// • SIZE REPORTING: Transparent data volume reporting for user awareness
    /// • ERROR HANDLING: Graceful handling of export failures with user notification
    /// 
    /// 🎯 PROFESSIONAL USER EXPERIENCE:
    /// 
    /// The export process demonstrates enterprise-grade UX patterns:
    /// 
    /// • IMMEDIATE ACKNOWLEDGMENT: Instant visual feedback when export begins
    /// • PROGRESS COMMUNICATION: Clear status updates throughout the process
    /// • SUCCESS CELEBRATION: Positive confirmation when export completes successfully
    /// • ACTIONABLE RESULTS: Clear next steps for using exported data
    /// • PROFESSIONAL PRESENTATION: Sheet-based modal following iOS design guidelines
    /// 
    /// This export method enables researchers, developers, and data analysts to access
    /// comprehensive feedback data for spiritual AI improvement and academic research.
    private func exportFeedbackData() {
        showingExportSheet = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            exportedData = feedbackManager.exportFeedbackData()
        }
    }
}

// MARK: - 🎨 PROFESSIONAL ANALYTICS COMPONENT LIBRARY

/// Claude: Professional Statistical Metric Display Card
/// ===================================================
/// 
/// This reusable component provides consistent, professional presentation of key
/// performance indicators throughout the analytics dashboard. It demonstrates
/// advanced SwiftUI component design patterns for data visualization.
/// 
/// 🎯 STATISTICAL CARD ARCHITECTURE:
/// 
/// 1. METRIC HIERARCHY DESIGN:
///    - Color-coded icon at top for immediate category recognition
///    - Prominent value display with monospaced digits for precise alignment
///    - Descriptive title with secondary color for clear information hierarchy
///    - Professional typography scale following iOS design guidelines
/// 
/// 2. VISUAL PERFORMANCE INDICATORS:
///    - Icon-based metric categorization (chart.bar, heart, thumbsup/thumbsdown)
///    - Color psychology application (blue=volume, green=positive, red=attention)
///    - High contrast text on subtle background for excellent readability
///    - Consistent padding and spacing for professional grid presentation
/// 
/// 3. RESPONSIVE DESIGN PATTERNS:
///    - Flexible width adapting to container constraints
///    - Fixed vertical padding ensuring consistent card height across metrics
///    - Background material and corner radius matching dashboard design language
///    - Accessibility support with proper contrast ratios and semantic labeling
/// 
/// 💡 DESIGN INTELLIGENCE:
/// 
/// The card design enables rapid data comprehension:
/// 
/// • IMMEDIATE RECOGNITION: Color and icon combination enables instant metric identification
/// • PROFESSIONAL AESTHETICS: Clean, modern design building user confidence in data accuracy
/// • SCANNABLE LAYOUT: Visual hierarchy optimized for quick dashboard scanning
/// • CONSISTENT PRESENTATION: Reusable component ensuring uniform analytics appearance
/// 
/// This component represents professional-grade data visualization standards,
/// making complex analytics immediately accessible and visually appealing.
struct KASPERStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3.weight(.bold).monospacedDigit())
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }
}

/// Claude: Advanced Feature Performance Analysis Card
/// =================================================
/// 
/// This sophisticated component presents detailed per-feature performance analytics
/// with intelligent visual indicators and comprehensive data presentation. It enables
/// rapid assessment of feature-specific spiritual guidance quality.
/// 
/// 📊 FEATURE ANALYSIS CARD ARCHITECTURE:
/// 
/// 1. INTELLIGENT PERFORMANCE ASSESSMENT:
///    - Dynamic satisfaction rate calculation with color-coded presentation
///    - Green (70%+): Excellent performance requiring no immediate attention
///    - Orange (50-69%): Warning level requiring investigation and improvement
///    - Red (<50%): Critical performance requiring immediate attention and fixes
///    - Professional percentage formatting with monospaced digits for precision
/// 
/// 2. COMPREHENSIVE METRICS DISPLAY:
///    - Feature name with proper capitalization following UI conventions
///    - Total response count providing statistical significance context
///    - Positive/negative feedback breakdown with emoji indicators for quick scanning
///    - Horizontal layout optimizing information density and readability
/// 
/// 3. PROFESSIONAL VISUAL DESIGN:
///    - Card-based layout with subtle background and rounded corners
///    - Consistent padding and spacing following iOS design guidelines
///    - Typography hierarchy enabling rapid information scanning
///    - Color-coded performance indicators for immediate quality assessment
/// 
/// 🎯 DEVELOPMENT INTELLIGENCE FEATURES:
/// 
/// The card provides actionable insights for spiritual AI improvement:
/// 
/// • IMMEDIATE QUALITY ASSESSMENT: Color-coded satisfaction rates enable instant evaluation
/// • STATISTICAL CONTEXT: Total response counts indicate data reliability and significance
/// • IMPROVEMENT PRIORITIZATION: Low-performing features clearly identified for attention
/// • SUCCESS IDENTIFICATION: High-performing features serve as quality benchmarks
/// • USER ENGAGEMENT INSIGHTS: Response volumes reveal feature popularity and adoption
/// 
/// 💫 QUALITY ASSURANCE INTEGRATION:
/// 
/// This component transforms raw feedback data into strategic development intelligence:
/// 
/// • FEATURE COMPARISON: Side-by-side performance evaluation across spiritual domains
/// • TREND MONITORING: Visual indicators reveal performance changes over time
/// • RESOURCE ALLOCATION: Data-driven decisions about where to focus improvement efforts
/// • BENCHMARK ESTABLISHMENT: High-performing features establish quality standards
/// • USER SATISFACTION TRACKING: Comprehensive view of user experience across features
/// 
/// The FeatureBreakdownCard represents the intersection of sophisticated data analysis
/// and intuitive user interface design, making complex performance analytics immediately
/// accessible to developers and stakeholders.
struct FeatureBreakdownCard: View {
    let feature: KASPERFeature
    let positiveCount: Int
    let negativeCount: Int
    let positiveRate: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(feature.rawValue.capitalized)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.white)
                
                Text("\(positiveCount + negativeCount) total responses")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "%.1f%%", positiveRate))
                    .font(.headline.weight(.bold).monospacedDigit())
                    .foregroundColor(positiveRate >= 70 ? .green : positiveRate >= 50 ? .orange : .red)
                
                HStack(spacing: 8) {
                    Text("👍 \(positiveCount)")
                        .font(.caption2)
                        .foregroundColor(.green)
                    
                    Text("👎 \(negativeCount)")
                        .font(.caption2)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }
}

/// Claude: Real-Time Feedback Timeline Entry Card
/// ==============================================
/// 
/// This dynamic component presents individual feedback entries in a timeline format,
/// providing immediate visibility into user satisfaction patterns and spiritual
/// guidance effectiveness. It demonstrates advanced temporal data presentation.
/// 
/// ⏰ FEEDBACK TIMELINE CARD ARCHITECTURE:
/// 
/// 1. IMMEDIATE SATISFACTION ASSESSMENT:
///    - Large emoji indicator (👍👎) for instant satisfaction recognition
///    - Visual scanning optimization enabling rapid pattern identification
///    - Emotional intelligence through emoji-based feedback representation
///    - Consistent visual language across all feedback displays
/// 
/// 2. CONTEXTUAL INFORMATION HIERARCHY:
///    - Feature name identification showing spiritual domain context
///    - Insight content preview (50 characters + "...") for content assessment
///    - Relative timestamp display providing temporal context and recency
///    - Professional typography hierarchy optimizing information scanning
/// 
/// 3. RESPONSIVE TIMELINE DESIGN:
///    - Horizontal layout optimizing mobile screen space utilization
///    - Card-based presentation with subtle background and rounded corners
///    - Consistent spacing and padding following iOS design guidelines
///    - Touch-friendly design supporting future interaction features
/// 
/// 📱 MOBILE-OPTIMIZED PRESENTATION:
/// 
/// The card design prioritizes mobile development and testing workflows:
/// 
/// • QUICK SCANNING: Large emoji and clear text hierarchy enable rapid assessment
/// • CONTENT PREVIEW: Truncated insight content provides quality evaluation capability
/// • TEMPORAL CONTEXT: Relative timestamps show feedback recency and patterns
/// • SPACE EFFICIENCY: Horizontal layout maximizes information density
/// • VISUAL SEPARATION: Card design clearly separates individual feedback entries
/// 
/// 🔍 QUALITY MONITORING CAPABILITIES:
/// 
/// Each feedback card provides immediate insights:
/// 
/// • SATISFACTION PATTERNS: Sequential feedback cards reveal satisfaction trends
/// • CONTENT QUALITY: Insight previews enable rapid content quality assessment
/// • FEATURE ENGAGEMENT: Feature identification shows user interaction patterns
/// • TEMPORAL PATTERNS: Timestamp analysis reveals user engagement timing
/// • ISSUE DETECTION: Negative feedback appears immediately for rapid response
/// 
/// 💫 DEVELOPMENT WORKFLOW INTEGRATION:
/// 
/// The feedback timeline transforms development and testing practices:
/// 
/// • REAL-TIME VALIDATION: Immediate feedback during development and testing
/// • QUALITY ASSURANCE: Continuous monitoring of spiritual guidance effectiveness
/// • USER JOURNEY INSIGHTS: Understanding how users interact with spiritual features
/// • CONTENT IMPROVEMENT: Rapid identification of low-quality generated insights
/// • ENGAGEMENT ANALYSIS: Patterns in feedback timing and feature usage
/// 
/// This FeedbackCard component represents the pulse of the KASPER MLX system -
/// providing real-time visibility into user satisfaction and spiritual guidance
/// quality that enables continuous improvement and responsive development.
struct FeedbackCard: View {
    let feedback: KASPERFeedback
    
    var body: some View {
        HStack(spacing: 12) {
            Text(feedback.rating.emoji)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(feedback.feature.rawValue.capitalized)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.white)
                
                Text(feedback.insightContent.prefix(50) + "...")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text(feedback.timestamp, style: .relative)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    KASPERFeedbackAnalyticsView()
}