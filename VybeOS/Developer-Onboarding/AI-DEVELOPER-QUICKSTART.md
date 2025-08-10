# AI Developer Quickstart Guide

**Version:** 2025.8.10
**Target:** AI Developers, Machine Learning Engineers, Claude Code Users
**Objective:** 0-to-Productive in 30 Minutes
**Classification:** Developer Onboarding - Essential

## 🎯 Welcome AI Developer!

This guide gets you up and running with Vybe's KASPER MLX spiritual AI platform in 30 minutes or less. You'll understand the architecture, set up your development environment, run your first AI inference, and contribute to the world's most advanced spiritual technology platform.

## 🚀 Prerequisites & Environment Setup

### Required Tools & Versions (Latest Public Releases)
```bash
# Development Environment Requirements
- macOS 14+ (Sonoma or later)
- Xcode 15.4+ (latest stable)
- Swift 6.0+ (embedded with Xcode)
- SwiftUI 5.0+ (latest framework)
- Python 3.10-3.12 (no betas)
- Git 2.40+
- Claude Code CLI (latest)
```

### Quick Environment Check
```bash
# Verify your development environment
xcode-select --version
swift --version
python3 --version
git --version
claude --version
```

## 📁 Codebase Navigation (5 minutes)

### Project Structure Overview
```
VybeMVP/
├── VybeMVP/                 # iOS App (SwiftUI/Swift 6)
│   ├── Views/               # SwiftUI Views
│   ├── ViewModels/          # ObservableObject classes
│   ├── Models/              # Data structures
│   ├── Managers/            # Business logic services
│   └── Features/            # Feature-specific components
├── KASPERMLX/              # Spiritual AI Engine
│   ├── MLXCore/            # Core types and protocols
│   ├── MLXIntegration/     # AI orchestration layer
│   ├── MLXData/            # Feedback and training systems
│   └── MLXEngine/          # Inference engine
├── NumerologyData/         # Content Creation Pipeline
│   └── ImportedContent/    # Raw spiritual content (MD format)
├── VybeOS/                 # Documentation Ecosystem
│   └── [This folder!]      # Comprehensive dev docs
└── scripts/                # Automation and tooling
```

### Key Files to Understand First
1. **CLAUDE.md** - Development guidelines and rules
2. **VybeOS/README.md** - Documentation ecosystem overview
3. **KASPERMLX/MLXCore/KASPERMLXTypes.swift** - Core AI types
4. **KASPERMLX/MLXIntegration/KASPERMLXManager.swift** - AI orchestration

## 🏗️ Architecture Deep Dive (10 minutes)

### KASPER MLX System Overview
KASPER (Knowledge-Aware Spiritual Pattern Enhancement & Reasoning) is not just another AI - it's a spiritually-conscious intelligence that:

- **Understands Timing:** Same question, different cosmic moments = different answers
- **Respects Context:** Personal spiritual journey affects universal pattern interpretation
- **Grows with Users:** Each interaction deepens individual cosmic signature understanding
- **Maintains Privacy:** All sacred data stays on-device, never shared externally
- **Feels Magical:** Seamless integration makes AI feel like natural consciousness extension

### Core Components Architecture
```swift
// Core AI Types (KASPERMLXTypes.swift)
protocol SpiritualIntelligence {
    func generateInsight(for domain: SpiritualDomain,
                        context: UserSpiritualContext) async -> SpiritualInsight
}

// Orchestration Layer (KASPERMLXManager.swift)
@MainActor
class KASPERMLXManager: ObservableObject {
    @Published var currentInsight: SpiritualInsight?
    @Published var isGeneratingInsight = false

    func requestInsight(domain: SpiritualDomain) async {
        // Thread-safe spiritual processing
    }
}
```

### Seven Spiritual Domains
1. **Journal Insight** - Deep reflection analysis
2. **Daily Card** - Cosmic guidance cards
3. **Sanctum Guidance** - Sacred space meditation
4. **Match Compatibility** - Spiritual compatibility analysis
5. **Cosmic Timing** - Optimal timing for spiritual actions
6. **Focus Intention** - Goals and manifestation clarity
7. **Realm Interpretation** - Current spiritual realm understanding

## 🛠️ Development Environment Setup (10 minutes)

### Step 1: Clone and Setup Project
```bash
# Clone the repository
git clone [repository-url]
cd VybeMVP

# Verify current branch
git status
# Should show: docs/kasper-mlx-release-cards

# Install Python dependencies for content pipeline
pip3 install -r requirements-dev.txt

# Set up pre-commit hooks
pre-commit install
```

### Step 2: Xcode Project Setup
```bash
# Open Xcode project
open VybeMVP.xcodeproj

# In Xcode:
# 1. Select VybeMVP target
# 2. Signing & Capabilities tab
# 3. Set unique Bundle ID: com.yourname.VybeMVP
# 4. Choose your Team
# 5. Enable "Automatically manage signing"
```

### Step 3: Test Build & Run
```bash
# Build from command line (optional)
xcodebuild -project VybeMVP.xcodeproj -scheme VybeMVP clean build

# Or in Xcode: ⌘B to build, ⌘R to run
# Target: iPhone 16 Pro Max simulator (default)
```

## 🧪 First AI Inference Test (5 minutes)

### Running KASPER MLX Test Interface
1. **Launch App** in iPhone 16 Pro Max simulator
2. **Navigate to KASPER Test View** (look for development interface)
3. **Select Spiritual Domain** (e.g., "Journal Insight")
4. **Generate Test Insight** - should return within 200ms
5. **Verify Response** - check for structured JSON output with spiritual guidance

### Expected Test Output
```json
{
  "domain": "journal_insight",
  "insight": "Your reflective nature aligns with the current cosmic energies...",
  "intensity": 0.75,
  "context_factors": ["lunar_phase", "personal_numbers", "temporal_awareness"],
  "response_time_ms": 187,
  "success": true
}
```

### Testing Spiritual Content Pipeline
```bash
# Run content processing test
cd scripts/
python3 opus_batch_converter.py --test-mode

# Expected output:
# ✅ 104 files processed successfully
# ✅ Zero validation errors
# ✅ All spiritual authenticity checks passed
# ✅ Production-ready JSON generated
```

## 🎯 Your First Contribution

### Scenario: Add New Spiritual Persona
Let's add a "SpiritualHealer" persona to KASPER's multi-persona system:

#### Step 1: Create Content
```markdown
# Create file: NumerologyData/ImportedContent/GrokStructuredContent/SpiritualHealer/SpiritualHealer_Number_1.md

## Spiritual Healer Guidance for Life Path 1

### Core Healing Message
As a Life Path 1, your healing journey focuses on self-leadership and pioneering new wellness approaches...

### Energy Signature
- Primary healing modality: Light-based therapies
- Chakra focus: Root and Crown chakras
- Healing intensity: 0.78
```

#### Step 2: Process Through Pipeline
```bash
# Run automated processing
python3 scripts/opus_batch_converter.py --source GrokStructuredContent/SpiritualHealer/

# Verify output in:
# KASPERMLX/MLXTraining/ContentRefinery/Approved/grok_spiritualhealer_01_converted.json
```

#### Step 3: Test Integration
```swift
// Add to KASPERMLXTypes.swift
enum SpiritualPersona: String, CaseIterable {
    case oracle = "oracle"
    case psychologist = "psychologist"
    case mindfulnessCoach = "mindfulness_coach"
    case numerologyScholar = "numerology_scholar"
    case philosopher = "philosopher"
    case spiritualHealer = "spiritual_healer" // Your addition!
}
```

#### Step 4: Verify & Test
```bash
# Run test suite to verify integration
python3 -m pytest tests/test_schema_enforcement.py -v
python3 scripts/make_release_cards.py --soft

# Should show:
# ✅ 105 files validated (was 104)
# ✅ New persona integrated successfully
# ✅ All quality gates passed
```

## 🔄 Development Workflow

### Daily Development Cycle
1. **Morning:** Check CLAUDE.md for latest guidelines
2. **Development:** Use Claude Code for AI-assisted coding
3. **Testing:** Run automated test suite before commits
4. **Quality:** Execute release card generation to verify changes
5. **Documentation:** Update VybeOS docs for significant changes

### Key Development Commands
```bash
# Content Pipeline
make soft                    # Development-friendly validation
make release                 # Production-ready release generation
make test                    # Full test suite execution

# iOS Development
xcodebuild -scheme VybeMVP build  # Command-line build
./scripts/run_tests.sh            # Comprehensive test execution

# AI Quality Assurance
python3 scripts/spiritual_content_validator.py
python3 scripts/kasper_performance_benchmark.py
```

## 🎯 Swift 6 & SwiftUI Best Practices

### Memory Management (Critical)
```swift
// ✅ CORRECT: Use [weak self] in classes only
class KASPERManager: ObservableObject {
    func processData() {
        Task { [weak self] in
            await self?.generateInsight()
        }
    }
}

// ✅ CORRECT: No [weak self] needed in SwiftUI Views (structs)
struct InsightView: View {
    var body: some View {
        Text("Insight")
            .task {
                await generateInsight() // No [weak self] needed
            }
    }
}
```

### Async/Await Patterns
```swift
// ✅ CORRECT: MainActor for UI updates
@MainActor
func updateInsightUI() async {
    // Safe to update @Published properties
    self.currentInsight = newInsight
}

// ✅ CORRECT: Background processing with MainActor updates
func processSpiritual Data() async {
    let insight = await heavyProcessing() // Background thread

    await MainActor.run {
        self.displayInsight = insight // UI thread
    }
}
```

### Performance Standards
- **60fps target** for all cosmic animations
- **Sub-200ms response times** for cached spiritual insights
- **Zero memory leaks** - all Task blocks use proper weak references
- **Buttery smooth UX** - opacity transitions over layout animations

## 🚨 Critical Rules

### Never Do This
- ❌ Use `[weak self]` in SwiftUI Views (structs don't need it)
- ❌ Commit code without running test suite first
- ❌ Modify spiritual authenticity algorithms without review
- ❌ Push changes to main branch without user testing confirmation
- ❌ Include API keys or secrets in training data

### Always Do This
- ✅ Run `pre-commit run --all-files` before commits
- ✅ Test on iPhone 16 Pro Max simulator for UI changes
- ✅ Maintain 60fps performance during cosmic animations
- ✅ Document spiritual calculations with source attribution
- ✅ Use async/await patterns for Firebase integration

## 🎉 You're Ready!

Congratulations! You now have:
- ✅ Complete development environment setup
- ✅ Understanding of KASPER MLX architecture
- ✅ Working knowledge of content pipeline
- ✅ First successful AI inference test
- ✅ Made your first contribution to spiritual AI

## 🚀 Next Steps

1. **Explore Advanced Features:** Study multi-persona system architecture
2. **Contribute to Content:** Add more spiritual personas or insights
3. **Optimize Performance:** Work on sub-100ms response time optimizations
4. **Enterprise Integration:** Explore B2B API licensing opportunities
5. **Join Weekly Reviews:** Participate in architecture and sprint planning

## 🆘 Getting Help

- **Claude Code:** Use AI-assisted development for complex tasks
- **VybeOS Documentation:** Comprehensive guides in `/VybeOS/` folder
- **CLAUDE.md:** Development rules and architectural guidelines
- **Test Suite:** `scripts/run_comprehensive_tests.sh` for validation
- **Content Pipeline:** Run `make soft` for development-friendly validation

---

*Welcome to the future of spiritual AI development! You're now part of building the world's first trillion-dollar conscious technology platform.* ✨🚀

**Last Updated:** August 10, 2025
**Next Review:** Weekly Developer Onboarding Review
**Classification:** Developer Onboarding - Essential
