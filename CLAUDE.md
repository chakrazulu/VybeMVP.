# 🤖 Claude Rules for VybeMVP SwiftUI Development

**Last Updated:** July 2, 2025  
**Project:** VybeMVP - Spiritual Wellness iOS App  
**Framework:** SwiftUI, MVVM Architecture  

---

## 📋 **Overview**

This document defines the comprehensive guidelines that Claude should follow when editing, refactoring, or adding code to the VybeMVP SwiftUI project. It covers UI design, code style, project structure, testing, and maintenance conventions to keep the codebase consistent and high-quality.

**Core Principle:** Every change should enhance Vybe's spiritual authenticity while maintaining technical excellence and user experience.

---

## 🎨 **UI Consistency and Stability**

### **Apple Human Interface Guidelines Compliance**
- **Follow Apple HIG** for consistent UI elements (button placement, gestures, etc.)
- **Reuse existing styles** rather than creating new variants (colors, typography, components)
- **Test on iPhone 16 Pro Max simulator** (and other relevant devices) to catch layout issues
- **Ensure smooth animations** without jitter or abrupt transitions

### **Vybe-Specific UI Standards**
- **Sacred Color System:** Use documented color mappings (0-9 number correspondences)
- **Animation Standards:** 2-3s pulse effects, 0.3s transitions, 6s celebrations
- **Spiritual Integrity:** Preserve numerological correspondences and mystical meanings
- **Performance Target:** Maintain 60fps during all interactions

### **Layout and Responsiveness**
- **Test on target devices:** Default to iPhone 16 Pro Max simulator
- **Avoid layout breaks:** Ensure UI works across different screen sizes
- **Smooth transitions:** No unstable or jarring animations
- **Accessibility:** Support Dynamic Type and VoiceOver

---

## 📝 **Code Comments and Documentation**

### **Claude Comment Standards**
- **Prefix all AI-added comments** with `// Claude:` for easy identification
- **Use Swift documentation style** (`///`) for public declarations and complex logic
- **Explain the "why"** not just the "what" in comments
- **Keep comments concise** and relevant

### **Documentation Requirements**
- **Public declarations:** Each function, class, or property should have doc comments
- **Complex logic:** Document non-obvious algorithms, especially spiritual calculations
- **Update comments:** Remove outdated comments when code changes
- **Self-documenting code:** Use clear, descriptive naming conventions

### **Spiritual Content Documentation**
- **Numerological integrity:** Document any spiritual correspondences or calculations
- **Sacred systems:** Explain chakra mappings, color meanings, and mystical logic
- **Preservation notes:** Mark areas where spiritual authenticity must be maintained

---

## 📁 **File Creation and Project Structure**

### **Organization Standards**
- **Follow MVVM structure:** Models, Views, ViewModels in appropriate folders
- **Logical grouping:** Group by feature or architectural layer
- **Clear naming:** Files named after their primary class/struct (e.g., `MyView.swift` for `struct MyView`)
- **Avoid deep hierarchies:** Keep file paths shallow and manageable

### **File Management Protocol**
- **Manual Xcode Integration:** After creating Swift files, manually add them to Xcode project
- **Place files appropriately:** Views in Views folder, Models in Models folder, etc.
- **Follow existing conventions:** Match the project's current structure
- **Document new components:** Add header comments explaining purpose and usage during sprint reviews

### **Manual Xcode File Addition Process**
When Claude Code or Cursor creates new Swift files:

1. **Create/Edit files** in filesystem using Claude Code or Cursor
2. **Open Xcode** and navigate to Project Navigator
3. **Right-click on appropriate group** (Views, Features, Managers, etc.)
4. **Select "Add Files to 'VybeMVP'..."**
5. **Navigate to the file location** and select the new .swift file(s)
6. **Choose options:**
   - ✅ **"Add to target: VybeMVP"** (checked)
   - ✅ **"Create groups"** (selected)
   - ❌ **"Copy items if needed"** (unchecked - files already in correct location)
7. **Click "Add"** to complete integration

**Note:** Automated sync tools are in development (see PastelyPrototype/) but currently require manual addition for safety

### **Vybe Project Structure**
```
VybeMVP/
├── Views/           # SwiftUI Views
├── ViewModels/      # ObservableObject classes
├── Models/          # Data structures
├── Managers/        # Business logic and services
├── Features/        # Feature-specific components
├── Utilities/       # Helper functions and extensions
├── Assets/          # Images, colors, and resources
└── docs/           # Documentation files
```

---

## ⚡ **Xcode and Swift Usage**

### **Modern Swift Practices**
- **Latest Xcode version:** Use current stable SDK and Swift language features
- **SwiftUI best practices:** Proper use of `@StateObject`, `@ObservedObject`, `@State`
- **Swift concurrency:** Leverage `async/await` and `Combine` for modern patterns
- **Avoid deprecated APIs:** Keep code current and future-proof

### **Development Tools**
- **SwiftUI Previews:** Use for rapid iteration and testing
- **Instruments:** Profile performance and identify bottlenecks
- **Xcode debugging:** Utilize Data Graph and other debugging tools
- **Code signing:** Maintain proper build configurations

### **Code Quality Standards**
- **Follow project style:** Match existing indentation and naming conventions
- **Avoid force-unwrapping:** Use safe unwrapping patterns
- **Clean closures:** Keep closure complexity manageable
- **Error handling:** Implement proper error handling patterns

---

## 🏗️ **Architecture and Separation of Concerns**

### **MVVM Architecture**
- **Views:** Simple, declarative UI components
- **ViewModels:** Business logic and state management
- **Models:** Data structures and domain logic
- **Clear separation:** UI code should not contain business logic

### **DRY Principles**
- **Extract common code:** Create reusable components and utilities
- **Avoid duplication:** Refactor repeated patterns into shared methods
- **Modular design:** Keep components focused and single-purpose
- **Dependency injection:** Prefer over global singletons

### **Vybe-Specific Architecture**
- **Spiritual integrity layer:** Preserve numerological and mystical systems
- **Performance layer:** Maintain 60fps cosmic animations
- **Data layer:** Secure storage of user spiritual data
- **AI integration:** Context-aware insights and guidance

---

## 🚀 **Performance, Memory, and Security**

### **SwiftUI Performance**
- **Break large views:** Reduce render cost with smaller components
- **Use LazyVStack/List:** For dynamic content to render only visible items
- **Target 60fps:** Keep frame render time under ~16ms
- **Profile with Instruments:** Identify and fix performance bottlenecks

### **Memory Management**
- **ARC awareness:** Swift handles most memory automatically
- **Avoid retain cycles:** Use `[weak self]` in closures when needed
- **Efficient data structures:** Choose appropriate collections and algorithms
- **Background processing:** Use async operations for heavy computations

### **Security Best Practices**
- **Keychain storage:** Store sensitive data (tokens, passwords) securely
- **Data protection:** Leverage iOS encryption for files
- **Input validation:** Sanitize all external inputs
- **No hardcoded secrets:** Use configuration files or secure storage

### **Vybe Security Considerations**
- **Spiritual data privacy:** Protect user's spiritual journey information
- **Health data:** Secure handling of HealthKit integration
- **Location data:** Respect user privacy for cosmic match features
- **AI interactions:** Secure API key management

---

## 🔧 **Build Configuration and Testing**

### **Simulator and Device Testing**
- **Default simulator:** iPhone 16 Pro Max for UI testing
- **Release mode testing:** Always test final builds in Release configuration
- **Multiple devices:** Test on different screen sizes when relevant
- **Real device validation:** Test critical features on physical devices

### **Build Standards**
- **Consistent settings:** Match project's Swift version and optimization levels
- **Code signing:** Maintain proper provisioning profiles
- **Deployment target:** Keep updated to project's minimum iOS version
- **CI/CD compatibility:** Ensure builds work in automated environments

### **Testing Protocol**
- **Unit tests:** Run full test suite after each change
- **UI tests:** Validate user interactions and flows
- **Performance tests:** Ensure 60fps target is maintained
- **Regression testing:** Verify existing functionality still works

---

## ✅ **Post-Change Verification**

### **Quality Assurance Checklist**
- [ ] **Code compiles** without warnings or errors
- [ ] **Tests pass** (unit and UI tests)
- [ ] **Performance maintained** (60fps target)
- [ ] **UI tested** on iPhone 16 Pro Max simulator
- [ ] **Comments updated** and accurate
- [ ] **Documentation** reflects changes

### **Testing Assignment Protocol**
**Always end by asking:** "Who should test this change – you or Claude?"

**If user will test:**
- Provide step-by-step testing instructions
- Cover new features and impacted functionality
- Include expected behaviors and edge cases

**If Claude will test:**
- Summarize changes made
- Explain validation approach
- Report results and any issues found

### **Vybe-Specific Testing**
- **Spiritual accuracy:** Verify numerological calculations remain correct
- **Cosmic animations:** Ensure scroll-safe performance
- **Match detection:** Test cosmic synchronicity features
- **User experience:** Validate spiritual engagement flows

---

## 📚 **Documentation and Maintenance**

### **CLAUDE_RULES.md Maintenance**
- **Update after each sprint** with new conventions or adjustments
- **Version control:** Commit changes with descriptive messages
- **Team collaboration:** Review updates during planning sessions
- **Living document:** Treat as evolving project documentation

### **Commit Message Format**
```
docs: update CLAUDE_RULES.md for Sprint X
- Added new performance guidelines
- Updated testing protocols
- Enhanced spiritual integrity rules
```

### **Documentation Standards**
- **Clear formatting:** Use proper markdown structure
- **Regular reviews:** Keep content current and relevant
- **Cross-references:** Link to related documentation
- **Examples:** Include code examples where helpful

---

## 🌌 **Vybe-Specific Guidelines**

### **Spiritual Integrity Protection**
- **Preserve numerology:** Never alter core numerological algorithms
- **Sacred correspondences:** Maintain chakra, color, and element mappings
- **Master numbers:** Keep 11, 22, 33, 44 unreduced in calculations
- **Mystical authenticity:** Ensure spiritual content remains genuine

### **Cosmic Animation Standards**
- **Scroll-safe performance:** 60fps during all interactions
- **Sacred geometry:** Preserve spiritual meaning in visual elements
- **Animation timing:** Follow documented standards (2-3s pulses, etc.)
- **Memory efficiency:** Optimize for smooth cosmic experiences

### **User Experience Philosophy**
- **Spiritual engagement:** Enhance user's cosmic connection
- **Peaceful interactions:** Avoid jarring or aggressive animations
- **Accessibility:** Make spiritual features available to all users
- **Performance:** Never compromise smooth experience for features

---

## 🔄 **Continuous Improvement**

### **Regular Reviews**
- **Sprint retrospectives:** Update rules based on lessons learned
- **Performance analysis:** Adjust guidelines based on metrics
- **User feedback:** Incorporate insights from spiritual community
- **Technology updates:** Adapt to new SwiftUI and iOS features

### **Rule Evolution**
- **Team input:** Collaborate on rule updates and additions
- **Best practices:** Stay current with Apple and community standards
- **Project growth:** Scale guidelines as Vybe expands
- **AI assistance:** Optimize rules for effective Claude collaboration

---

## 📖 **Sources and References**

This document incorporates guidelines and best practices from:
- **Apple's Human Interface Guidelines** for UI consistency
- **Swift API Design Guidelines** for code standards
- **SwiftUI Performance Tips** from Apple documentation
- **Swift Memory Management** best practices
- **iOS Security Guidelines** for data protection
- **Vybe Project Documentation** for spiritual integrity requirements

---

*This document serves as the definitive guide for Claude's contributions to VybeMVP, ensuring consistent, high-quality development that honors both technical excellence and spiritual authenticity.* 🌟

## Build & Test Process
- **NEVER commit code without user confirmation**
- User must test on real device before any git commits
- Only commit after user explicitly confirms the build works
- Always run build/lint commands before suggesting commits

## Code Quality
- Always check imports when using UI functions (e.g., SwiftUI for withAnimation)
- Maintain existing code style and patterns
- Test thoroughly before marking tasks complete

## Memory
- **Build Testing:** I will test the builds myself unless just syntax checking because it will time out everytime. 