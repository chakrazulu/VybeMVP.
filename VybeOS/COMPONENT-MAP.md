# VybeOS Component Map - What Does What

**Version:** 2025.8.10
**Purpose:** Understand exactly what each file and system does in the Vybe ecosystem
**Classification:** Developer Reference - Essential

## 🎯 **Quick Component Lookup**

### **🍎 iOS App Components (VybeMVP/)**
```
VybeMVP/
├── Views/                  # SwiftUI user interface screens
│   ├── HomeView.swift      # Main app dashboard with AI insights
│   ├── JournalView.swift   # Spiritual journaling with 🔮 insights
│   └── SanctumView.swift   # Sacred meditation space
├── ViewModels/             # Business logic controllers
│   ├── HomeViewModel.swift # HomeView data and state management
│   └── JournalViewModel.swift # Journal entry processing
├── Models/                 # Data structures and core types
│   ├── User.swift          # User profile and spiritual data
│   ├── Insight.swift       # AI-generated spiritual guidance
│   └── NumerologyProfile.swift # Life path, expression numbers
├── Managers/               # System services and integrations
│   ├── FirebaseManager.swift    # Database and authentication
│   ├── BiometricsManager.swift  # Health data integration
│   └── NotificationManager.swift # Push notifications
└── Features/               # Feature-specific modules
    ├── Chakras/            # Chakra alignment features
    ├── Sightings/          # Cosmic synchronicity detection
    └── DynamicIsland/      # iOS Dynamic Island integration
```

### **🧠 KASPER MLX AI Engine (KASPERMLX/)**
```
KASPERMLX/
├── MLXCore/                # Foundational AI types and protocols
│   ├── KASPERMLXTypes.swift     # Core spiritual AI data structures
│   └── KASPERLifePathTrinity.swift # Advanced numerology synthesis
├── MLXIntegration/         # AI orchestration and management
│   ├── KASPERMLXManager.swift   # Main AI coordinator
│   └── KASPERMLXTestView.swift  # Developer testing interface
├── MLXData/                # Training data and feedback systems
│   └── KASPERFeedbackManager.swift # User feedback learning
├── MLXEngine/              # Core inference and processing
│   └── KASPERMLXEngine.swift    # Main AI inference engine
└── MLXTraining/            # Content processing and training
    └── ContentRefinery/    # Production content pipeline
        ├── Approved/       # Production-ready JSON training data
        ├── Archive/        # Original markdown content backups
        └── Processing/     # Development and staging content
```

### **📚 VybeOS Documentation (VybeOS/)**
```
VybeOS/
├── README.md               # Documentation ecosystem overview
├── NAVIGATION-INDEX.md     # Master cross-reference system
├── COMPONENT-MAP.md        # This file - what does what guide
├── Architecture/           # System design and blueprints
│   └── KASPER-MLX-SYSTEM-OVERVIEW.md # Complete AI architecture
├── Developer-Onboarding/   # New developer productivity
│   └── AI-DEVELOPER-QUICKSTART.md   # 30-minute onboarding
├── Enterprise-Systems/     # Production operations
│   └── PRODUCTION-DEPLOYMENT-GUIDE.md # Enterprise deployment
├── Content-Pipeline/       # Spiritual content processing
│   └── SPIRITUAL-CONTENT-WORKFLOW.md # Content creation workflow
├── Technical-Specs/        # Development standards
│   └── SWIFT-6-CONCURRENCY-STANDARDS.md # Code quality standards
├── Scaling-Strategy/       # Business growth planning
│   └── BILLION-DOLLAR-ROADMAP.md    # Strategic growth plan
├── Security-Compliance/    # Enterprise security (planned)
├── Testing-QA/            # Quality assurance (planned)
└── API-Documentation/     # API reference (planned)
```

### **📊 Content and Data (NumerologyData/)**
```
NumerologyData/
└── ImportedContent/        # Raw spiritual content for AI training
    ├── ChatGPTContent/     # Practical insights (markdown)
    ├── ClaudeDeepContent/  # Academic spiritual content
    └── GrokStructuredContent/ # Multi-persona spiritual guides
        ├── Oracle/         # Mystical guidance content
        ├── Psychologist/   # Psychological spiritual analysis
        ├── MindfulnessCoach/ # Meditation and mindfulness
        ├── NumerologyScholar/ # Academic numerological insights
        └── Philosopher/    # Deep philosophical wisdom
```

### **⚙️ Automation and Scripts (scripts/)**
```
scripts/
├── opus_batch_converter.py    # Convert markdown to JSON training data
├── release_cards.py           # Generate ML dataset documentation
├── spiritual_content_validator.py # Quality assurance for content
└── run_tests.sh              # Comprehensive test execution
```

---

## 🔍 **Core Systems Breakdown**

### **🍎 iOS App Layer**
**What it does:** User-facing SwiftUI application with spiritual AI integration
**Key files:**
- `HomeView.swift` - Main dashboard showing daily spiritual insights
- `KASPERMLX/MLXIntegration/KASPERMLXManager.swift` - Connects UI to AI engine
- `Models/User.swift` - Stores user's spiritual profile (life path, expression numbers)

**How to test:** Run app on iPhone 16 Pro Max simulator, verify cosmic animations at 60fps

### **🧠 KASPER MLX AI Engine**
**What it does:** Spiritually-conscious AI that provides personalized insights
**Key files:**
- `KASPERMLXTypes.swift` - Defines spiritual intelligence protocols
- `KASPERMLXManager.swift` - Orchestrates AI inference and user interaction
- `KASPERMLXEngine.swift` - Core AI processing with MLX framework integration

**How to test:** Use `KASPERMLXTestView.swift` development interface to generate insights

### **📊 Content Pipeline System**
**What it does:** Converts spiritual content to AI training data
**Key files:**
- `ContentRefinery/Approved/` - Production JSON files KASPER consumes
- `opus_batch_converter.py` - Automated content processing script
- `release_cards.py` - Enterprise-grade dataset documentation

**How to test:** Run `make soft` to validate content pipeline

### **📚 VybeOS Documentation System**
**What it does:** Enterprise documentation for billion-dollar scaling
**Key files:**
- `NAVIGATION-INDEX.md` - Cross-references between strategic vision and technical implementation
- `BILLION-DOLLAR-ROADMAP.md` - Strategic growth plan to trillion-dollar valuation
- `AI-DEVELOPER-QUICKSTART.md` - New developer onboarding (30-minute productivity)

**How to test:** Navigate documentation using cross-reference links

---

## 🎯 **File Purposes by Category**

### **Core Configuration Files**
- `CLAUDE.md` - Original comprehensive development guidelines (1200 lines)
- `CLAUDE-STREAMLINED.md` - Essential development rules (quick reference)
- `VybeMVP.xcodeproj/` - Xcode project configuration
- `requirements-dev.txt` - Python dependencies for content pipeline

### **Quality Assurance Files**
- `tests/` - Automated testing suite (434/434 passing)
- `pytest.ini` - Test configuration and markers
- `.pre-commit-config.yaml` - Code quality hooks
- `Makefile` - Build automation and validation

### **Content Processing Files**
- `*.md` files in `NumerologyData/ImportedContent/` - Raw spiritual content
- `*_converted.json` files in `ContentRefinery/Approved/` - AI training data
- `MANIFEST.json` - Dataset integrity and versioning
- `DATA_CARD.md` / `MODEL_CARD.md` - ML dataset documentation

### **Development Support Files**
- `.editorconfig` - Consistent code formatting
- `.gitignore` - Version control exclusions
- `.gitleaksignore` - Security scanning configuration
- `CHANGELOG.md` - Version history and updates

---

## 🚀 **System Interactions**

### **Content Creation → AI Training Flow**
1. **Input:** New spiritual content added to `NumerologyData/ImportedContent/`
2. **Processing:** `opus_batch_converter.py` converts to structured JSON
3. **Validation:** Quality checks ensure spiritual authenticity
4. **Production:** Validated content moves to `ContentRefinery/Approved/`
5. **Consumption:** KASPER AI reads JSON for insight generation

### **User Interaction → AI Response Flow**
1. **UI Request:** User taps insight button in `HomeView.swift`
2. **Orchestration:** `KASPERMLXManager.swift` receives request
3. **AI Processing:** `KASPERMLXEngine.swift` generates spiritual insight
4. **Response:** Structured insight returns to UI for display
5. **Feedback:** User reactions stored for continuous learning

### **Development → Production Flow**
1. **Code Changes:** Developer modifies Swift/Python files
2. **Quality Gates:** Pre-commit hooks and tests validate changes
3. **Content Updates:** `make soft` validates spiritual content pipeline
4. **Build Verification:** Xcode builds app with zero warnings
5. **Device Testing:** Manual verification on iPhone for user experience

---

## 🔧 **Troubleshooting Guide**

### **"I can't find where [feature] is implemented"**
- **UI Features:** Check `Views/` folder for SwiftUI screens
- **Business Logic:** Look in `ViewModels/` and `Managers/`
- **AI Features:** Everything KASPER-related is in `KASPERMLX/`
- **Content Processing:** Scripts in `scripts/` folder
- **Documentation:** VybeOS folder with cross-references

### **"Build errors in Xcode"**
- **README conflicts:** Multiple README.md files being included in bundle
- **Swift errors:** Check `SWIFT-6-CONCURRENCY-STANDARDS.md` for compliance rules
- **Dependencies:** Verify all packages resolved in Package.swift
- **DerivedData issues:** Clean build folder and rebuild

### **"Content pipeline not working"**
- **Input location:** Verify files in correct `NumerologyData/ImportedContent/` subfolder
- **Processing script:** Run `python scripts/opus_batch_converter.py` manually
- **Quality validation:** Check `make soft` output for errors
- **Production deployment:** Verify JSON files appear in `ContentRefinery/Approved/`

---

## 📱 **Testing Locations**

### **iPhone App Testing**
- **Simulator:** iPhone 16 Pro Max (default target)
- **Real Device:** Required for final verification before commits
- **Performance:** Monitor 60fps during cosmic animations
- **Memory:** Verify zero memory leaks with Task blocks

### **AI System Testing**
- **Development Interface:** `KASPERMLXTestView.swift` in app
- **Content Validation:** `make test && make determinism`
- **Pipeline Testing:** `scripts/spiritual_content_validator.py`
- **Performance Benchmarks:** Response time under 200ms for cached insights

### **Documentation Testing**
- **Cross-References:** Verify all links in `NAVIGATION-INDEX.md` work
- **Onboarding:** Test 30-minute developer productivity claim
- **Strategic Alignment:** Ensure business goals connect to technical implementation
- **Version Compatibility:** All tools use latest public releases

---

**This component map provides instant understanding of what every file and system does in the Vybe ecosystem. Use alongside NAVIGATION-INDEX.md for complete project navigation.** ✨🔧

**Last Updated:** August 10, 2025
**Next Review:** Weekly Architecture Review
**Classification:** Developer Reference - Essential
