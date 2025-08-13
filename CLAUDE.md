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
- Before we ever add to git we need to make sure the code is thoroughly commented, up to date and adhering to the architecture
- You need to ask me before you add to git

## 📁 Quick Structure

```
VybeMVP/
├── Views/           # SwiftUI Views
├── ViewModels/      # Business logic
├── KASPERMLX/       # AI system
├── VybeCore/         # Branded shared utilities
└── KASPERMLXRuntimeBundle/  # Content (v2.1.4)
```

## 🔮 KASPER MLX v2.1.5 - Local LLM Shadow Mode ACTIVE! 🎉

### 🤖 Local LLM Setup (Mixtral 46.7B Parameters)
```bash
# REQUIRED: Start before running app
OLLAMA_HOST=0.0.0.0:11434 ollama serve

# Wait for: "llama runner started in 20.11 seconds"
# Look for: iPhone connections in terminal logs
```

### 🏆 Historic Achievement: August 12, 2025
- ✅ **World's first iPhone app** with Local LLM shadow mode
- ✅ **46.7B parameter competition** vs curated content
- ✅ **Real-time quality evaluation** (0.80+ threshold)
- ✅ **Winner badges** in UI showing AI victories
- ✅ **Oracle persona support** for rich content competition

### Shadow Mode Competition (NEW)
```swift
// Local Mixtral vs RuntimeBundle competition
// Users see RuntimeBundle while Mixtral learns
// Automatic quality evaluation and logging
let shadowMode = KASPERShadowModeManager(localLLMProvider)
```

### Quick Test
```bash
# Test if Mixtral is working
curl -X POST http://localhost:11434/api/generate \
  -d '{"model": "mixtral", "prompt": "Hello", "stream": false}'
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

1. **Ask user**: "Would you like me to review the code to ensure it's thoroughly commented and up to date before adding to git?"
2. **Self-healing validation**: `make self-healing-validate`
3. Clean build: `Cmd+Shift+K`
4. Build: `Cmd+B` (zero warnings)
5. Test: `Cmd+U` (all passing)
6. Run on simulator
7. Test on device
8. Get user confirmation for commit

## 📚 Documentation

- **Self-Healing Guide:** [VybeOS/self-healing-architecture-guide.md](./VybeOS/self-healing-architecture-guide.md)
- **Quick Reference:** [VybeOS/Developer-Onboarding/CLAUDE-REFERENCE-GUIDE.md](./VybeOS/Developer-Onboarding/CLAUDE-REFERENCE-GUIDE.md)
- **Full Archive:** [VybeOS/Developer-Onboarding/CLAUDE-ARCHIVE.md](./VybeOS/Developer-Onboarding/CLAUDE-ARCHIVE.md)
- **Sprint Docs:** [docs/8-10-weekend-sprint.md](./docs/8-10-weekend-sprint.md)

---

*Streamlined: August 10, 2025 - Use reference guide for details*
