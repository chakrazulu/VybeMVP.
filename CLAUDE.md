# 🤖 Claude Rules for VybeMVP

**Project:** VybeMVP - Spiritual Wellness iOS App
**Framework:** SwiftUI, MVVM, Swift 6
**Status:** Production Ready - KASPER MLX v2.1.9 ✅ **ALAN WATTS & CARL JUNG COMPLETE + ENHANCED SYSTEM** 🧘

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
- **Xcode needs the file to be manually added through the IDE for it to be properly recognized**

## 📁 Quick Structure

```
VybeMVP/
├── Views/           # SwiftUI Views
├── ViewModels/      # Business logic
├── KASPERMLX/       # AI system
├── VybeCore/         # Branded shared utilities
└── KASPERMLXRuntimeBundle/  # Content (v2.1.4)
```

## 🧘 **MEDITATION SYSTEM v2.0 - PRODUCTION READY** (August 23, 2025)

### **✅ Complete Feature Set**
- **8 Meditation Types**: Each with custom icons, colors, and numerology-based recommendations
- **Smart Flow**: Practice selection → Configuration modal → 10-second countdown → Live session
- **Advanced Biofeedback**: 60fps scroll-resistant sine waves with progressive HRV thresholds
- **Timer Intelligence**: Auto-completion with haptic feedback + continue option for deep states
- **Spiritual Insights**: Focus + Realm number combinations generate 18+ unique session insights
- **Rich History**: Clickable sessions with detailed view showing HR analysis and insights
- **Session Persistence**: Every session saved with biometrics, achievements, and spiritual guidance

### **🎯 Latest Improvements (August 23)**
- **Fixed First-Tap Issue**: Enum-based `ActiveSheet` system eliminates blank screens
- **Scroll-Resistant Animation**: Timer runs in `.common` RunLoop mode (no pausing)
- **Extended Countdown**: 10 seconds with preparation tips and HealthKit priming
- **Timer Completion Modal**: Shows at target duration with continue/end options
- **Session Detail Views**: Tap any history session for comprehensive analysis
- **Insights Integration**: Every session stores and displays personalized spiritual guidance
- **Comprehensive Documentation**: `MEDITATION_SYSTEM_DOCUMENTATION.md` created

### **🏗️ Technical Excellence**
- **State Management**: Robust enum-based sheet presentation pattern
- **Memory Safety**: Zero leaks, proper timer cleanup, singleton patterns
- **Performance**: 60fps animations, optimized calculations, efficient data persistence
- **SwiftUI Best Practices**: Correct property wrappers, proper sheet presentations
- **HealthKit Integration**: Priming during countdown, real-time HR/HRV monitoring
- **Wall-Clock Timing**: Session duration survives app backgrounding

### **📊 Analytics & Progress**
- **Metrics Tracked**: Duration, BPM improvement, coherence %, quality assessment
- **Progress Features**: Streaks, personal bests, favorite practice with tie-breaking
- **Spiritual Integration**: Focus/Realm insights embedded in session data
- **History Analytics**: Real data displayed when sessions exist (not "Coming Soon")

### **🔧 Zero Technical Debt**
- **No Memory Leaks**: All resources properly managed
- **No Timer Issues**: Proper invalidation and cleanup
- **No State Bugs**: Reliable sheet presentation
- **No UI Glitches**: Dark mode compatible, proper text sizing
- **Complete Documentation**: System overview, code comments, architecture plans

---

*Documentation updated: August 23, 2025 - Meditation system audit complete*
