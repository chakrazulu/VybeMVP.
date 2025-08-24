# 🤖 Claude Rules for VybeMVP

**Project:** VybeMVP - Spiritual Wellness iOS App
**Framework:** SwiftUI, MVVM, Swift 6
**Current Status:** A+ Roadmap System Complete - Consolidated & Production Ready ✅
**Branch:** `feature/hawkins-consciousness-mapping` - **READY FOR PHASE 1 IMPLEMENTATION**

## 🎯 Critical Rules (MUST FOLLOW)

### Swift 6 Concurrency
- **NEVER** use `[weak self]` in SwiftUI Views (structs)
- **ALWAYS** use `[weak self]` in Task blocks within classes
- **ALWAYS** use `await MainActor.run {}` for UI updates from background

### Performance Standards
- **60fps** target for all animations
- **ZStack opacity** transitions over layout animations
- **Fixed heights** to prevent resize hitches

### Development Process
- **NEVER commit** without user confirmation
- **Test on real device** before commits
- **Run tests** (`Cmd+U`) - must show 434/434 passing
- **Follow A+ roadmap safety procedures** - see KASPERMLX/APlusRoadmapWorkflow.md
- **NEVER modify sacred view files** (JournalView, TimelineView, SanctumView, MeditationView)
- **Use Git safety net** - tags, branches, emergency rollback procedures established
- **Follow CODEOWNERS** - protected files require review (.github/CODEOWNERS)
- **Xcode manual file addition** required for proper recognition
- **Phase-based progression** - complete Phase 1 before Phase 2A/2B
- **Owner approval gates** - screenshot validation required at each milestone

## 📁 Architecture Overview

### **Core App Structure (350+ Swift Files)**
```
VybeMVP/
├── Features/              # Feature modules (8 domains)
│   ├── Social/           # PostManager, CommentManager, FriendManager
│   │   ├── SocialManagers/    # Repository pattern (A+ grade)
│   │   ├── SocialModels/      # Post, Comment, SocialUser
│   │   ├── SocialRepositories/ # Firebase + CoreData hybrid
│   │   └── SocialViews/       # Timeline, PostCard, Comments
│   ├── Journal/          # Spiritual reflection system
│   ├── Meditation/       # v2.1 production system (434/434 tests)
│   ├── UserProfile/      # Sanctum + social identity
│   ├── Onboarding/       # Spiritual profile creation
│   ├── Sightings/        # Community spiritual experiences
│   ├── Chakras/          # Energy center mapping
│   └── CosmicHUD/        # VFI consciousness widgets
├── Views/                # Main navigation + sacred view files
├── Core/                 # Data models, utilities, KeyChain
├── Components/           # Shared UI (ShimmerLoading, SpiritualFeedback)
├── KASPERMLX/           # Revolutionary AI consciousness system (56 files)
│   ├── APlusRoadmap.md       # Strategic implementation guide (2,016 lines)
│   ├── APlusRoadmapWorkflow.md # Safety procedures + Owner commands
│   ├── VybeKanbanTemplate.yml # GitHub Projects execution template
│   ├── DevTools.md           # Development utilities & scripts
│   ├── MLXCore/              # Training, inference, consciousness mapping
│   ├── MLXProviders/         # RuntimeBundle, Firebase, Hybrid providers
│   └── ContentSelection/     # Smart content routing (Phase 1.5)
├── Docs/Examples/       # Implementation examples & design rationale
│   ├── PerformanceOptimizationExamples.md
│   └── NavigationDesignRationale.md
├── Managers/            # Business logic (25 manager classes)
└── KASPERMLXRuntimeBundle/ # Spiritual content (992 JSON files, 4.2MB)
```

## 🏆 **COMPREHENSIVE FEATURE AUDIT (August 23, 2025)**

### **🎯 Core Differentiators (Why VybeMVP is Unique)**

#### **1. KASPER MLX AI Consciousness System (A+)**
- **Revolutionary Local LLM**: 56 files, Trinity architecture (KASPER/Apple Intelligence/User)
- **992 JSON Spiritual Database**: Life Path, Soul Urge, Expression numbers with persona voices
- **Smart Content Selection**: RuntimeSelector with semantic similarity (Phase 1.5 complete)
- **Quality Gate System**: A-grade insight guarantee with evaluation metrics
- **Shadow Mode**: Competitive AI analysis (ChatGPT vs RuntimeBundle)

#### **2. Social Spiritual Community (A+)**
- **Enterprise Repository Pattern**: PostManager, CommentManager, FriendManager
- **Hybrid Data Strategy**: Firebase real-time + CoreData performance (80% cost reduction)
- **Advanced Caching**: Offline-first approach with intelligent sync
- **Timeline & Profiles**: Full social networking with spiritual context integration

#### **3. Advanced Meditation System v2.1 (A+)**
- **8 Meditation Types**: Biofeedback integration, HRV monitoring
- **60fps Animations**: Scroll-resistant sine waves, wall-clock timing
- **HealthKit Integration**: Real-time HR/HRV with privacy compliance
- **Session Analytics**: Complete history with spiritual insights embedded

#### **4. Numerology & Consciousness Mapping (A)**
- **Birth Chart Calculations**: Life Path, Destiny, Soul Urge, Expression numbers
- **Hawkins Consciousness Scale**: 700-point calibration system
- **VFI Consciousness Engine**: Frequency detection (20-700Hz)
- **Sacred Geometry Integration**: Cosmic patterns and alignments

#### **5. Comprehensive Onboarding (A)**
- **Spiritual Profile Creation**: Birth location, preferences, cosmic rhythms
- **Multi-step Flow**: 10 specialized views with state persistence
- **Personalization Engine**: Customized app experience based on spiritual archetype

### **📊 Technical Excellence Metrics**

#### **Code Quality (A+ Grade)**
- **350+ Swift Files**: 95%+ documentation coverage with comprehensive headers
- **Swift 6 Compliance**: Full @MainActor, async/await, memory safety
- **434/434 Tests Passing**: Comprehensive test coverage including mocks
- **Zero Memory Leaks**: Proper weak self usage, timer cleanup, resource management

#### **Architecture Quality (A Grade)**
- **MVVM Pattern**: Clean separation of concerns across all features
- **Repository Pattern**: Social features use enterprise-grade data access patterns
- **Singleton Management**: 25+ manager classes with proper lifecycle control
- **State Management**: Robust @Published, @StateObject, @EnvironmentObject usage

#### **Performance Quality (B+ → A+ Target)**
- **Current**: 15+ second startup, complex manager initialization
- **A+ Target**: <3s startup, <50MB memory, <200ms tab switching
- **Optimization Strategy**: JSON lazy loading (992→50 files), content distribution

### **🚀 A+ ROADMAP STATUS**

#### **Phase 1: Navigation Excellence (Ready for Implementation)**
- **Current**: 14 tabs overwhelming users (violates iOS HIG)
- **Target**: 5 clean tabs (Home, Journal, Timeline, Sanctum, Meditation) + home grid access
- **Approach**: "Moving furniture, not remodeling" - preserve all functionality
- **Safety Net**: Bulletproof Git workflow, snapshot testing, emergency rollback
- **Success Criteria**: <3s startup, <50MB memory, 100% feature accessibility

#### **Phase 2A: Performance Optimization (Queued)**
- **Target**: JSON lazy loading (992→50 files), startup <2.5s, memory <45MB
- **Strategy**: Predictive caching, background processing, memory pressure response
- **Timeline**: 3-4 weeks after Phase 1 completion

#### **Phase 2B: LLM Integration (Queued)**
- **Target**: KASPER-Apple Intelligence synergy, local/cloud hybrid responses
- **Strategy**: Privacy-preserving AI, personalized spiritual insights
- **Timeline**: 2-3 weeks after Phase 2A completion

#### **Implementation Strategy (Three-Pillar System)**
- **Strategy**: KASPERMLX/APlusRoadmap.md (2,016 lines) - Comprehensive implementation guide
- **Safety**: KASPERMLX/APlusRoadmapWorkflow.md - Step-by-step Git procedures + owner commands
- **Execution**: KASPERMLX/VybeKanbanTemplate.yml - GitHub Projects daily task template
- **Examples**: Docs/Examples/ - Performance optimization & design rationale
- **Protection**: .github/CODEOWNERS - Automated file protection
- **Overview**: README-VybeAPlus.md - Quick start navigation guide

#### **Success Metrics**
- **Grade Path**: B+ (85/100) → A+ (95/100)
- **Timeline**: 16-21 weeks systematic improvement
- **Risk Level**: Minimal (bulletproof rollback capability)
- **Feature Preservation**: 100% - no functionality loss

### **🛡️ CRITICAL SAFETY PROTOCOLS**

#### **Sacred Files (NEVER MODIFY)**
```
Features/Journal/JournalView.swift          ← Spiritual reflection hub
Features/Social/SocialViews/SocialTimelineView.swift ← Community feed
Features/UserProfile/SanctumView.swift      ← Spiritual identity
Features/Meditation/MeditationView.swift    ← Biofeedback sessions
```

#### **A+ Development Rules (Consolidated)**
- **Phase 1 Focus**: Navigation consolidation ONLY - no feature changes
- **UI Preservation**: Screenshot comparison + snapshot testing prevents visual regression
- **Git Safety Net**: Safety tags, progressive branches, copy-paste emergency rollback
- **CODEOWNERS Protection**: Sacred files auto-protected, navigation changes require approval
- **Performance Gates**: Progressive thresholds (Phase 1: <3s, Phase 2A: <2.5s, Phase 2B: <2s)
- **Owner Approval**: Mandatory sign-offs with screenshot validation at each milestone
- **Command Index**: Quick reference for all critical Git operations
- **Cross-References**: Complete documentation ecosystem with line-level navigation

---

## 🎯 **QUICK START FOR A+ IMPLEMENTATION**

### **Phase 1 Checklist (Copy-Paste Ready)**
```bash
# Navigate to project
cd /Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP

# Create safety branch + tag
git checkout -b feature/navigation-refactor-ui-safe
git tag UI_BEFORE_A_PLUS_REFACTOR
git push origin UI_BEFORE_A_PLUS_REFACTOR

# Emergency rollback command (if needed)
git reset --hard UI_BEFORE_A_PLUS_REFACTOR && git clean -fd
```

### **Key Documentation**
- **📋 Strategy**: `KASPERMLX/APlusRoadmap.md` - Read first for complete context
- **🛡️ Safety**: `KASPERMLX/APlusRoadmapWorkflow.md` - Follow step-by-step
- **📊 Execution**: `KASPERMLX/VybeKanbanTemplate.yml` - Import to GitHub Projects
- **🔧 Examples**: `Docs/Examples/` - Implementation patterns & rationale

### **Success Criteria**
- ✅ All 434 tests passing
- ✅ App startup <3 seconds
- ✅ Memory usage <50MB
- ✅ 100% feature accessibility preserved
- ✅ Screenshot comparison shows identical UI
- ✅ Owner approval with sign-off documentation

---

*A+ Roadmap System Complete: August 24, 2025 - Ready for bulletproof implementation*
