# 🤖 Claude Rules for VybeMVP

**Project:** VybeMVP - Spiritual Wellness iOS App
**Framework:** SwiftUI, MVVM, Swift 6
**Status:** Production Ready - KASPER MLX v2.1.4 ✅ Active MLX Inference

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
- **Follow existing patterns** - don't reinvent

## 📁 Quick Structure

```
VybeMVP/
├── Views/           # SwiftUI Views
├── ViewModels/      # Business logic
├── KASPERMLX/       # AI system
├── VybeCore/         # Branded shared utilities
└── KASPERMLXRuntimeBundle/  # Content (v2.1.4)
```

## 🔮 KASPER MLX v2.1.4 - Active MLX Inference

### MLX Inference Architecture (NEW)
```swift
// MLX inference with personalized content variation
let router = KASPERContentRouter.shared
let content = await router.getRichContent(for: number)

// MLX stub model generates unique insights based on focus/realm numbers
// No more repetitive content - each insight is personalized
```

### RuntimeBundle Integration

### Bulletproof Content Pipeline (NEW v2.1.4)
```bash
# Complete pipeline (normalize + validate + export)
make content-all

# Individual operations
make content-lint        # Validate all content
make content-normalize   # Fix Claude artifacts
make content-export      # Generate runtime bundle
```

### Content Validation
- **Schema**: `content.schema.json` enforces structure
- **Linter**: `scripts/lint_rich_content.py` validates content
- **CI/CD**: GitHub Actions prevents invalid content
- **Runtime Guards**: `VybeCore/Guards/RichContentValidator.swift`

### Current Status: 13/13 files validated ✅
### MLX Status: Active inference with focus/realm personalization ✅

## 🌟 Self-Healing Architecture (NEW v2.1.6)

### Quick Setup
```bash
make self-healing-setup     # One-time setup
make self-healing-validate  # Full system health check
```

### Self-Healing Features
- **Pre-push SwiftLint hooks** - Runtime quality gates active
- **Behavioral regression tests** - RuntimeBundle fallback chain tested
- **Content coverage CI reports** - Missing files identified automatically
- **Automated system health monitoring** - Continuous validation

## ✅ Before Every Commit

1. **Self-healing validation**: `make self-healing-validate`
2. Clean build: `Cmd+Shift+K`
3. Build: `Cmd+B` (zero warnings)
4. Test: `Cmd+U` (all passing)
5. Run on simulator
6. Test on device
7. Get user confirmation

## 📚 Documentation

- **Self-Healing Guide:** [VybeOS/self-healing-architecture-guide.md](./VybeOS/self-healing-architecture-guide.md)
- **Quick Reference:** [VybeOS/Developer-Onboarding/CLAUDE-REFERENCE-GUIDE.md](./VybeOS/Developer-Onboarding/CLAUDE-REFERENCE-GUIDE.md)
- **Full Archive:** [VybeOS/Developer-Onboarding/CLAUDE-ARCHIVE.md](./VybeOS/Developer-Onboarding/CLAUDE-ARCHIVE.md)
- **Sprint Docs:** [docs/8-10-weekend-sprint.md](./docs/8-10-weekend-sprint.md)

---

*Streamlined: August 10, 2025 - Use reference guide for details*
