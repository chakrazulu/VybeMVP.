# 🚀 Claude Code Quick Reference for VybeMVP

**Project:** VybeMVP - Spiritual Wellness iOS App
**Framework:** SwiftUI, MVVM, Swift 6 Compliant
**Status:** Production Ready with KASPER MLX v2.1.2 ✅ RuntimeBundle Integrated (Aug 10, 2025)

## 🎯 Core Development Rules

### Swift 6 Compliance (CRITICAL)
- **Never use [weak self] in SwiftUI Views** (structs don't need it)
- **Always use [weak self] in Task blocks within classes**
- **Use `await MainActor.run {}` for UI updates from background**
- **Mark delegate methods `nonisolated` in @MainActor classes**

### UI Performance Standards
- **60fps target** for all animations
- **ZStack opacity transitions** over layout animations
- **Fixed container heights** to prevent resize hitches
- **GPU acceleration** via opacity changes

### Code Quality
- **Test before marking complete** (434/434 tests passing)
- **Run lint/typecheck** before suggesting commits
- **Follow existing patterns** - don't reinvent
- **Prefix AI comments** with `// Claude:`

## 📁 Project Structure

```
VybeMVP/
├── Views/           # SwiftUI Views
├── ViewModels/      # @ObservableObject classes
├── Models/          # Data structures
├── Managers/        # Business logic
├── KASPERMLX/       # AI spiritual intelligence
├── VybeOS/          # Documentation
└── Resources/
    └── RuntimeBundle/  # KASPER content (v2.1.2)
```

## 🔮 KASPER MLX Integration

### RuntimeBundle Implementation (v2.1.2) ✅ INTEGRATED
1. **Export content:** `python scripts/export_runtime_bundle.py`
2. **Add to Xcode:** Copy Bundle Resources → KASPERMLXRuntimeBundle (as folder reference)
3. **Use in code:**
   ```swift
   let router = KASPERContentRouter.shared  // Always use singleton
   let content = await router.getRichContent(for: number)
   ```
4. **Status:** 104 behavioral files + 13 rich content files successfully integrated

### Content Pipeline
```
ImportedContent/ → ContentRefinery/Approved/ → RuntimeBundle/
    (User adds MD)     (Claude processes)        (iOS app uses)
```

## ✅ Testing Protocol

### Before ANY Commit
1. Clean build: `Cmd+Shift+K`
2. Build: `Cmd+B` (zero warnings)
3. Test: `Cmd+U` (all passing)
4. Run on iPhone 16 Pro Max simulator
5. Test on physical device
6. Get user confirmation

### Smoke Tests
- **KASPER:** `python scripts/kasper_smoke_test.py`
- **Release:** `python scripts/release_cards.py`

## 🛠️ Common Tasks

### Adding New Files
1. Create file in filesystem
2. Open Xcode → Project Navigator
3. Right-click group → "Add Files to VybeMVP"
4. Select file (don't copy if already in place)
5. Ensure target membership ✓

### Updating KASPER Content
1. Add MD files to `NumerologyData/ImportedContent/`
2. Run `python scripts/opus_batch_converter.py`
3. Run `python scripts/export_runtime_bundle.py`
4. Rebuild app

## 🚨 Critical Rules

### NEVER
- ❌ Commit without user confirmation
- ❌ Use force unwrapping (`!`)
- ❌ Create files unless necessary
- ❌ Add emojis unless requested
- ❌ Alter numerological algorithms
- ❌ Share user spiritual data

### ALWAYS
- ✅ Maintain 60fps performance
- ✅ Test on real device before commits
- ✅ Use existing components first
- ✅ Follow Swift 6 concurrency rules
- ✅ Preserve spiritual authenticity
- ✅ Use TodoWrite for task tracking

## 📊 Current Status

- **Swift 6:** ✅ Fully compliant
- **Tests:** 434/434 passing
- **Memory:** Zero leaks detected
- **KASPER:** v2.1.2 with RuntimeBundle
- **Performance:** 60fps maintained

## 🔗 Quick Links

- [Full CLAUDE.md Archive](./CLAUDE-ARCHIVE.md)
- [Weekend Sprint Docs](../../docs/8-10-weekend-sprint.md)
- [KASPER Implementation](../../docs/8-10-weekend-sprint-kasper-mlx-implementation.md)

---

*Last Updated: August 10, 2025 - Post KASPER MLX RuntimeBundle Implementation*
