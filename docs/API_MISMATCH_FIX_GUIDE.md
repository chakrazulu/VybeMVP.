# 🔧 API Mismatch Fix Guide

**How to align test files with actual VybeMVP APIs**

---

## 🎯 **Step-by-Step Process**

### **Step 1: Identify Real APIs**

For each test file, we need to check the actual class APIs:

```bash
# Check PostManager actual methods
grep -n "func " /Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/Features/Social/SocialManagers/PostManager.swift

# Check AuthenticationManager
grep -n "func \|var \|init" /Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/Managers/AuthenticationManager.swift

# Check BackgroundManager
grep -n "func \|var \|init" /Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/Utilities/BackgroundManager.swift

# Check RealmNumberManager
grep -n "func " /Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/Managers/RealmNumberManager.swift
```

### **Step 2: Fix One File at a Time**

Let's start with the easiest - **PostManager**:

#### **A. Check PostManager Real API**
```bash
# See actual createPost method signature
grep -A 10 "func createPost" /Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/Features/Social/SocialManagers/PostManager.swift
```

#### **B. Check PostManager Initialization**
```bash
# See how PostManager is really initialized
grep -A 5 -B 5 "class PostManager" /Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/Features/Social/SocialManagers/PostManager.swift
```

#### **C. Fix PostManagerTests.swift**
Based on what we find, update the test file to match real APIs.

---

## 🛠️ **Common API Issues & Fixes**

### **Issue 1: Private Initializers**
```swift
// Problem:
let manager = SomeManager() // ❌ Private init

// Solution: Use shared instance or factory method
let manager = SomeManager.shared // ✅
// OR
let manager = SomeManager.createForTesting() // ✅
```

### **Issue 2: @MainActor Methods**
```swift
// Problem:
func testSomething() {
    manager.someMethod() // ❌ MainActor method in sync context
}

// Solution: Use @MainActor or async
@MainActor
func testSomething() {
    manager.someMethod() // ✅
}
// OR
func testSomething() async {
    await manager.someMethod() // ✅
}
```

### **Issue 3: Wrong Method Signatures**
```swift
// Problem: Assumed API
manager.createPost(content: "test", privacy: .global) // ❌

// Solution: Use real API (check actual method)
manager.createPost(authorName: "Test", content: "test", type: .text) // ✅
```

### **Issue 4: Missing Enum Cases**
```swift
// Problem: Assumed enum cases
PostType.spiritual // ❌ Doesn't exist

// Solution: Check real enum values
PostType.text // ✅ Use what actually exists
```

---

## 📋 **Specific Fix Instructions**

### **Fix 1: PostManagerTests.swift**

1. **Check real PostManager API:**
   ```bash
   # Run this to see actual methods
   grep -n "func create\|func update\|func delete" /Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/Features/Social/SocialManagers/PostManager.swift
   ```

2. **Look for initialization pattern:**
   ```bash
   # Check if it's shared instance or regular init
   grep -n "static let shared\|init(" /Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/Features/Social/SocialManagers/PostManager.swift
   ```

3. **Update the test file:**
   - Replace assumed method calls with real ones
   - Fix parameter names and types
   - Add @MainActor if needed

### **Fix 2: AuthenticationManagerTests.swift**

1. **Check real AuthenticationManager:**
   ```bash
   grep -n "static let shared\|init\|func sign" /Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/Managers/AuthenticationManager.swift
   ```

2. **Common fix:**
   ```swift
   // Probably needs:
   let authManager = AuthenticationManager.shared // Instead of init()
   ```

### **Fix 3: RealmNumberManagerTests.swift**

1. **Check for mock conflicts:**
   ```bash
   # Find existing MockHealthKitManager
   find /Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP -name "*.swift" -exec grep -l "MockHealthKitManager" {} \;
   ```

2. **Fix by renaming our mocks:**
   ```swift
   // Change from:
   class MockHealthKitManager // ❌ Conflicts

   // Change to:
   class RealmTestMockHealthKitManager // ✅ Unique name
   ```

### **Fix 4: BackgroundManagerTests.swift**

1. **Check real BackgroundManager:**
   ```bash
   grep -n "init\|shared\|private" /Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/Utilities/BackgroundManager.swift
   ```

2. **Likely fix:**
   ```swift
   // Probably private init, so use shared or different testing approach
   let backgroundManager = BackgroundManager.shared // If it exists
   ```

---

## 🔍 **Quick Discovery Commands**

Run these to understand the real APIs:

### **PostManager Discovery**
```bash
# Check all public methods
grep -n "func \|var \|@Published" /Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/Features/Social/SocialManagers/PostManager.swift | head -20

# Check if it's @MainActor
grep -n "@MainActor" /Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/Features/Social/SocialManagers/PostManager.swift
```

### **AuthenticationManager Discovery**
```bash
# Check initialization and key methods
grep -n "init\|shared\|func \|var " /Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/Managers/AuthenticationManager.swift | head -15
```

### **BackgroundManager Discovery**
```bash
# Check accessibility
grep -n "private\|public\|internal\|init" /Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/Utilities/BackgroundManager.swift
```

### **RealmNumberManager Discovery**
```bash
# Check methods we're trying to test
grep -n "func calculate\|func reduce\|init" /Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/Managers/RealmNumberManager.swift
```

---

## 📝 **Example Fix Process**

### **Let's Fix PostManagerTests.swift Together:**

1. **First, discover the real API:**
   ```bash
   # Run this command
   head -50 /Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/Features/Social/SocialManagers/PostManager.swift
   ```

2. **Look for actual createPost method:**
   ```bash
   # Find the real method signature
   grep -A 10 "func createPost" /Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/Features/Social/SocialManagers/PostManager.swift
   ```

3. **Update our test to match:**
   ```swift
   // Replace our assumed API:
   postManager.createPost(content: "test", privacy: .global) // ❌

   // With the real API (whatever we discover):
   postManager.createPost(authorName: "Test", content: "test", type: .text) // ✅
   ```

---

## 🎯 **Recommended Order**

Fix in this order (easiest to hardest):

1. **RealmNumberManagerTests** - Fix mock name conflicts
2. **PostManagerTests** - Update method signatures
3. **AuthenticationManagerTests** - Fix initialization
4. **BackgroundManagerTests** - Handle private access

---

## ✅ **Test Each Fix**

After each fix:
```bash
# Test just that file
xcodebuild -scheme VybeMVP -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max' test -only-testing:VybeMVPTests.PostManagerTests

# Or test all
xcodebuild -scheme VybeMVP -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max' test
```

**Ready to start? Let's discover the real PostManager API first!** 🚀
