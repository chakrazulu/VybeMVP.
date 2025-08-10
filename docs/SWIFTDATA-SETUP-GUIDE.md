# 🚀 SwiftData Setup Guide for VybeMVP

## Manual Steps Required

### 📁 **Step 1: Add Files to Xcode**

1. **Create the SpiritualDatabase folder structure:**
   - Right-click on your VybeMVP project root in Xcode
   - Select "New Group" → Name it `SpiritualDatabase`

2. **Add the SwiftData model files:**
   - Right-click on the `SpiritualDatabase` folder
   - Select "Add Files to 'VybeMVP'..."
   - Navigate to `/SpiritualDatabase/`
   - Select both:
     - `NumberMeaning.swift`
     - `AspectMeaning.swift`
   - ✅ Check "Add to target: VybeMVP"
   - Click "Add"

3. **Add the SpiritualDataController:**
   - Right-click on `Managers` folder
   - Select "Add Files to 'VybeMVP'..."
   - Select `SpiritualDataController.swift`
   - ✅ Check "Add to target: VybeMVP"
   - Click "Add"

---

### 🔧 **Step 2: Modify VybeMVPApp.swift**

Open your `VybeMVPApp.swift` file and add these modifications:

```swift
import SwiftUI
import SwiftData  // Add this import

@main
struct VybeMVPApp: App {
    // Add the spiritual data controller
    @StateObject private var spiritualDataController = SpiritualDataController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                // Add the model container to the environment
                .modelContainer(spiritualDataController.container)
                // Pass the controller for migration status
                .environmentObject(spiritualDataController)
        }
    }
}
```

---

### 🔄 **Step 3: Create Migration Status View (Optional)**

If you want to show migration progress on first launch:

1. Create a new file `MigrationStatusView.swift` in your Views folder:

```swift
import SwiftUI

struct MigrationStatusView: View {
    @EnvironmentObject var dataController: SpiritualDataController

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(.purple)

            Text("Preparing Spiritual Wisdom")
                .font(.title)
                .fontWeight(.semibold)

            Text(dataController.migrationStatus)
                .font(.caption)
                .foregroundColor(.secondary)

            ProgressView(value: dataController.migrationProgress)
                .progressViewStyle(.linear)
                .padding(.horizontal, 40)

            Text("\(Int(dataController.migrationProgress * 100))%")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
```

2. Modify your main ContentView to show this during migration:

```swift
struct ContentView: View {
    @EnvironmentObject var dataController: SpiritualDataController

    var body: some View {
        if dataController.isMigrationComplete {
            // Your normal app UI
            MainTabView()
        } else {
            MigrationStatusView()
        }
    }
}
```

---

### 🔌 **Step 4: Update KASPER MLX to Use SwiftData**

Update your `NumerologyDataProvider.swift` to use SwiftData instead of JSON:

```swift
// OLD WAY (JSON):
func getFocusArchetype(_ number: Int) -> String {
    if let sanctumManager = sanctumDataManager,
       let focusData = sanctumManager.getFocusNumberData(number) {
        return focusData.archetype
    }
    return "The Seeker"
}

// NEW WAY (SwiftData):
func getFocusArchetype(_ number: Int) -> String {
    // Use the hot cache for immediate response
    return SpiritualDataController.shared.getArchetype(for: number)
}
```

---

### 🧪 **Step 5: Test the Migration**

1. **Build and Run** (⌘+R)
2. On first launch, you should see:
   - Migration progress (if you added the UI)
   - Console logs showing migration success
3. Subsequent launches should be instant (no JSON parsing!)

---

### 📝 **Step 6: Update Tests**

Create a test-specific SwiftData configuration:

```swift
// In your test setup
let testSchema = Schema([NumberMeaning.self, AspectMeaning.self])
let testConfiguration = ModelConfiguration(
    schema: testSchema,
    isStoredInMemoryOnly: true  // In-memory for tests!
)
let testContainer = try ModelContainer(
    for: testSchema,
    configurations: [testConfiguration]
)

// Insert test data
let testMeaning = NumberMeaning(
    number: 3,
    archetype: "The Communicator",
    // ... other properties
)
testContainer.mainContext.insert(testMeaning)
try testContainer.mainContext.save()
```

---

## ✅ **Verification Checklist**

- [ ] Files added to Xcode project
- [ ] SwiftData import added to VybeMVPApp.swift
- [ ] Model container attached to WindowGroup
- [ ] SpiritualDataController initialized
- [ ] Build succeeds without errors
- [ ] First launch shows migration (check console)
- [ ] Second launch is fast (no JSON parsing)
- [ ] KASPER MLX still generates insights

---

## 🎯 **Benefits You'll See**

1. **Memory**: No more loading entire MegaCorpus into RAM
2. **Speed**: Instant queries instead of JSON traversal
3. **Testing**: In-memory database for fast tests
4. **Scalability**: Can grow to thousands of entries
5. **Queries**: Can search and filter spiritual content

---

## 🚨 **Common Issues & Solutions**

**Build Error: "Unknown type SwiftData"**
- Make sure your deployment target is iOS 17.0+

**Migration doesn't run**
- Delete the app from simulator and reinstall

**Crash on launch**
- Check that all SwiftData model properties are supported types

**Tests fail**
- Make sure tests use in-memory configuration, not disk

---

You're now ready to use SwiftData! The spiritual wisdom of VybeMVP is about to become lightning fast and memory efficient. 🌟⚡
