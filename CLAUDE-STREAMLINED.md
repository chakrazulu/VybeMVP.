# 🤖 Claude Rules for VybeMVP SwiftUI Development

**Last Updated:** August 10, 2025  
**Project:** VybeMVP - Spiritual Wellness iOS App  
**Framework:** SwiftUI, MVVM Architecture  
**Latest Achievement:** 🎯 **SWIFT 6 COMPLIANT + PERFECT KASPER UI EXPERIENCE**  

---

## 📋 **Quick Reference**

**For comprehensive documentation, see:** [`VybeOS/`](VybeOS/) - Complete AI development ecosystem

**Core Principle:** Every change should enhance Vybe's spiritual authenticity while maintaining technical excellence and user experience.

---

## 🚀 **Current Status - Production Ready**

- ✅ **Swift 6 Compliance:** Zero concurrency violations, 38+ memory leaks fixed
- ✅ **KASPER MLX Foundation:** Production-ready spiritual AI with 104+ datasets
- ✅ **60fps Performance:** Buttery smooth cosmic animations guaranteed
- ✅ **Enterprise Release System:** Automated ML documentation and validation
- ✅ **VybeOS Documentation:** Complete developer ecosystem established

**Full achievement details:** [`VybeOS/Architecture/KASPER-MLX-SYSTEM-OVERVIEW.md`](VybeOS/Architecture/KASPER-MLX-SYSTEM-OVERVIEW.md)

---

## ⚡ **Essential Development Rules**

### 🚨 Swift 6 Concurrency Compliance (CRITICAL)
```swift
// ✅ CORRECT: [weak self] in classes only
class KASPERManager: ObservableObject {
    func generateInsight() {
        Task { [weak self] in  // ✅ Required for classes
            await self?.processData()
        }
    }
}

// ✅ CORRECT: No [weak self] in SwiftUI Views (structs)
struct InsightView: View {
    var body: some View {
        Text("Insight").task {
            await loadData()  // ✅ No [weak self] needed
        }
    }
}
```

**Detailed standards:** [`VybeOS/Technical-Specs/SWIFT-6-CONCURRENCY-STANDARDS.md`](VybeOS/Technical-Specs/SWIFT-6-CONCURRENCY-STANDARDS.md)

### 🎨 UI Performance Standards (ENFORCED)
- **ZStack Opacity Transitions:** Use opacity changes, not layout animations
- **Fixed Container Heights:** Prevent resize hitches (265px containers)
- **60fps Target:** All cosmic animations must maintain smooth performance
- **GPU Acceleration:** Prefer opacity over layout recalculations

### 📝 Code Quality Essentials
- **Swift 6 Ready:** Use async/await, proper MainActor isolation
- **Memory Management:** All Task blocks in classes use [weak self]
- **Test First:** 434/434 tests passing - run before commits
- **Comments:** Prefix AI-added comments with `// Claude:`

---

## 🏗️ **Architecture Guidelines**

### Project Structure
```
VybeMVP/
├── Views/              # SwiftUI Views
├── ViewModels/         # ObservableObject classes
├── Models/             # Data structures
├── KASPERMLX/         # Spiritual AI engine
└── VybeOS/            # Complete documentation
```

### MVVM Best Practices
- **Views:** Simple, declarative UI components
- **ViewModels:** Business logic and state management  
- **Models:** Data structures and domain logic
- **Clear Separation:** UI code should not contain business logic

**Complete architecture:** [`VybeOS/Architecture/`](VybeOS/Architecture/)

---

## 🔧 **Build & Testing Process**

### Pre-Commit Checklist
- [ ] Code compiles without warnings
- [ ] All tests pass (434/434)
- [ ] 60fps performance maintained
- [ ] Swift 6 concurrency compliant
- [ ] Memory leaks checked

### Testing Commands
```bash
# Swift/iOS Testing
xcodebuild -scheme VybeMVP build
./scripts/run_tests.sh

# KASPER MLX Content Pipeline
make soft                    # Development validation
make test && make determinism # Production validation
```

### Commit Rules
- **NEVER commit without user confirmation**
- **User must test on real device first**
- **Run build/lint commands before suggesting commits**

**Detailed testing guide:** [`VybeOS/Testing-QA/AUTOMATED-TESTING-FRAMEWORK.md`](VybeOS/Testing-QA/)

---

## 🌌 **Vybe-Specific Guidelines**

### Spiritual Integrity Protection
- **Preserve numerology:** Never alter core spiritual algorithms
- **Sacred correspondences:** Maintain chakra, color, element mappings
- **Master numbers:** Keep 11, 22, 33, 44 unreduced in calculations
- **Mystical authenticity:** Ensure spiritual content remains genuine

### KASPER MLX Integration
- **Content Pipeline:** Use established workflow for spiritual content
- **Multi-Persona System:** Oracle, Psychologist, MindfulnessCoach, etc.
- **Performance:** Sub-second spiritual guidance generation
- **Privacy:** All sacred data remains on-device

**Content workflow:** [`VybeOS/Content-Pipeline/SPIRITUAL-CONTENT-WORKFLOW.md`](VybeOS/Content-Pipeline/SPIRITUAL-CONTENT-WORKFLOW.md)

---

## 📚 **Documentation System**

### VybeOS - Complete Developer Ecosystem
- **Architecture:** [`VybeOS/Architecture/`](VybeOS/Architecture/) - System design and technical blueprints
- **Developer Onboarding:** [`VybeOS/Developer-Onboarding/AI-DEVELOPER-QUICKSTART.md`](VybeOS/Developer-Onboarding/AI-DEVELOPER-QUICKSTART.md) - 0-to-productive in 30 minutes
- **Technical Specs:** [`VybeOS/Technical-Specs/`](VybeOS/Technical-Specs/) - Swift 6, SwiftUI, MLX standards
- **Enterprise Systems:** [`VybeOS/Enterprise-Systems/`](VybeOS/Enterprise-Systems/) - Production deployment guides
- **Scaling Strategy:** [`VybeOS/Scaling-Strategy/BILLION-DOLLAR-ROADMAP.md`](VybeOS/Scaling-Strategy/BILLION-DOLLAR-ROADMAP.md) - Growth trajectory

### For AI Developers
**Start here:** [`VybeOS/README.md`](VybeOS/README.md) - Complete documentation ecosystem overview

---

## ⚡ **Claude Code Automated Workflow Rules**

### Core Operational Principles
- **Determinism over speed:** Never ship non-reproducible outputs
- **Fail-fast validation:** Hard gates prevent corrupted releases
- **Swift/Xcode isolation:** Don't touch iOS targets unless requested
- **Zero secrets:** Never commit API keys or PII to repository

### KASPER MLX Development Workflow
```bash
# Standard development commands
pip install -r requirements-dev.txt
pre-commit run --all-files
python scripts/release_cards.py
make test && make determinism
```

**Complete workflow guide:** [`VybeOS/Enterprise-Systems/PRODUCTION-DEPLOYMENT-GUIDE.md`](VybeOS/Enterprise-Systems/PRODUCTION-DEPLOYMENT-GUIDE.md)

---

## 🎯 **Quick Task Assignment**

**Always end by asking:** "Who should test this change – you or Claude?"

**If user will test:**
- Provide step-by-step testing instructions
- Include expected behaviors and edge cases

**If Claude will test:**
- Summarize changes made
- Report results and any issues found

---

## 🔄 **Latest Development Versions**

- **Xcode:** 15.4+ (latest stable)
- **Swift:** 6.0+ (embedded with Xcode)
- **SwiftUI:** 5.0+ (latest framework)
- **Python:** 3.10-3.12 (no betas)
- **iOS Target:** 17.0+ (latest public)

**Version compatibility:** [`VybeOS/Developer-Onboarding/DEVELOPMENT-ENVIRONMENT-SETUP.md`](VybeOS/Developer-Onboarding/)

---

*This streamlined guide focuses on essential development rules. For comprehensive documentation, architecture details, scaling strategies, and advanced topics, see the complete VybeOS ecosystem.* 🌟

**Built with 🔮 by the Vybe Team using Claude Code**