# VybeMVP File Structure

## Core System Components

### Sacred Geometry System
- `Core/Models/SacredGeometryAssets.swift` - Asset management and mystical correspondences
- `Core/Models/RealmSample.swift` - ✨ NEW: Data model for tracking realm number frequency
- `Views/ReusableComponents/DynamicAssetMandalaView.swift` - ✨ NEW: Dynamic rotating mandala backgrounds
- `Views/ReusableComponents/RulingNumberChartView.swift` - ✨ NEW: Interactive histogram for ruling numbers
- `Views/ReusableComponents/EnhancedLoadingView.swift` - ✨ NEW: Loading view with timeout prevention
- `Views/StaticAssetMandalaView.swift` - Legacy static mandala (being phased out)

### Main Views (Updated)
- `Views/RealmNumberView.swift` - ✅ FIXED: Removed outer circle, added ruling chart, dynamic backgrounds
- `Views/HomeView.swift` - ✅ UPDATED: Now uses dynamic mandala backgrounds
- `Views/AuthenticationWrapperView.swift` - ✅ UPDATED: Enhanced loading with timeout prevention

### Existing Core Components
- `Core/Data/` - Core Data models
- `Managers/` - Business logic managers
- `Features/` - Feature-specific modules
- `VybeApp/Assets.xcassets/` - Asset management with sacred geometry images

## Key Improvements Implemented

### 1. ✅ Realm Number UI Cleanup
- **Issue**: Outer circle conflicted with sacred geometry background
- **Fix**: Removed outer circle, matched font size to HomeView (140pt), enhanced glow effects
- **Files**: `Views/RealmNumberView.swift`

### 2. ✅ Missing Geometry for "1" 
- **Issue**: "1" geometry wasn't showing due to static asset selection
- **Fix**: Created `DynamicAssetMandalaView` with intelligent rotation through available assets
- **Files**: `Views/ReusableComponents/DynamicAssetMandalaView.swift`

### 3. ✅ Dynamic Background Logic
- **Issue**: Same sacred geometry always displayed
- **Fix**: Implemented time-based rotation every 15 minutes with device-specific seeding
- **Files**: `Views/ReusableComponents/DynamicAssetMandalaView.swift`, updated HomeView and RealmView

### 4. ✅ Cold-Start Splash Bug
- **Issue**: Loading screen sometimes hangs indefinitely
- **Fix**: Created `EnhancedLoadingView` with 8-second timeout and retry mechanisms
- **Files**: `Views/ReusableComponents/EnhancedLoadingView.swift`, `Views/AuthenticationWrapperView.swift`

### 5. ✅ "Ruling Number" Graph Feature
- **Issue**: Static "Cosmic Alignment Factors" panel
- **Fix**: Interactive bar chart showing daily realm number frequency with XP rewards
- **Components**:
  - `Core/Models/RealmSample.swift` - Data tracking system
  - `Views/ReusableComponents/RulingNumberChartView.swift` - Interactive histogram
  - Integrated into `Views/RealmNumberView.swift`

## Sacred Geometry Asset System

### Asset Categories (0-9)
- **0 - Void**: 7 variations (triquetra, cosmic womb, zero point, etc.)
- **1 - Unity**: 7 variations (merkaba, solar, crown, monad, alpha, consciousness, spark)
- **2 - Duality**: 7 variations (vesica piscis, lunar, yin-yang, etc.)
- **3 - Trinity**: 7 variations (mandala, triangle, wisdom, fire, etc.)
- **4 - Foundation**: 7 variations (cube, cross, temple, stone, etc.)
- **5 - Will**: 7 variations (pentagram, golden spiral, shield, etc.)
- **6 - Harmony**: 7 variations (star of david, flower of life, heart, etc.)
- **7 - Mystery**: 7 variations (seed of life, seals, rose, etc.)
- **8 - Renewal**: 7 variations (octagon, infinity, karmic wheel, etc.)
- **9 - Wisdom**: 2 variations (enneagram, completion merkaba)

### Dynamic Selection Algorithm
```swift
// Time-based rotation (changes every 15 minutes)
let timeComponent = (hour * 60 + minute) / 15

// Number-specific variation  
let numberComponent = number * 17 // Prime multiplier

// Device/session seed for uniqueness
let seedComponent = generateRotationSeed()

// Final index calculation
let index = (timeComponent + numberComponent + seedComponent) % availableAssets.count
```

## Testing and Quality Assurance

### Debug Features
- `AssetDebugView` - Shows available assets for each number
- Console logging for asset rotation and realm sampling
- Preview support for all new components

### Error Prevention
- Asset existence validation with fallbacks
- Timeout mechanisms for loading states
- Throttled sampling (30-minute minimum intervals)
- XP reward duplicate prevention

### Performance Optimizations
- Minimal asset loading
- Efficient time-based calculations
- Cached sacred geometry selections
- Memory-conscious asset rotation

## Architecture Patterns

### MVVM Implementation
- **Models**: `RealmSample`, `SacredGeometryAsset`
- **ViewModels**: `RealmSampleManager` (ObservableObject)
- **Views**: Component-based with clear separation

### Combine Integration
- Real-time realm number updates
- Reactive UI updates for ruling number chart
- Publisher/subscriber patterns for data flow

### SwiftUI Best Practices
- Environment objects for shared state
- Preference for declarative UI
- Animation-driven state changes
- Accessibility support 