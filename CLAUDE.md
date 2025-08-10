# 🤖 Claude Rules for VybeMVP

**Project:** VybeMVP - Spiritual Wellness iOS App
**Framework:** SwiftUI, MVVM, Swift 6
**Status:** Production Ready - KASPER MLX v2.1.4 ✅ Bulletproof Content Pipeline Complete

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

## 🔮 KASPER MLX v2.1.4

### Using RuntimeBundle (v2.1.4)
```swift
let router = KASPERContentRouter.shared  // Always use shared instance
let content = await router.getRichContent(for: number)
```

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

## ✅ Before Every Commit

1. Clean build: `Cmd+Shift+K`
2. Build: `Cmd+B` (zero warnings)
3. Test: `Cmd+U` (all passing)
4. Run on simulator
5. Test on device
6. Get user confirmation

## 📚 Documentation

- **Quick Reference:** [VybeOS/Developer-Onboarding/CLAUDE-REFERENCE-GUIDE.md](./VybeOS/Developer-Onboarding/CLAUDE-REFERENCE-GUIDE.md)
- **Full Archive:** [VybeOS/Developer-Onboarding/CLAUDE-ARCHIVE.md](./VybeOS/Developer-Onboarding/CLAUDE-ARCHIVE.md)
- **Sprint Docs:** [docs/8-10-weekend-sprint.md](./docs/8-10-weekend-sprint.md)

---

*Streamlined: August 10, 2025 - Use reference guide for details*
