# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

VybeMVP is a spiritually immersive numerology and transcendental journaling app built in Swift using SwiftUI + Firebase. The app creates a cosmic interface for users to explore their sacred numbers and maintain a spiritual journal with voice reflections.

## Build & Development Commands

### Building the Project
```bash
# Open the Xcode project
open VybeMVP.xcodeproj

# Build from command line (requires xcode-tools)
xcodebuild -project VybeMVP.xcodeproj -scheme VybeMVP -destination 'platform=iOS Simulator,name=iPhone 14 Pro' build
```

### Testing
```bash
# Run tests from command line
xcodebuild test -project VybeMVP.xcodeproj -scheme VybeMVP -destination 'platform=iOS Simulator,name=iPhone 14 Pro'

# Or use the test plan in Xcode
# Tests are configured in VybeMVP.xctestplan with parallelizable execution enabled
```

### Development Environment
- **Xcode**: Latest version recommended for SwiftUI and iOS development
- **iOS Target**: iOS 14.0+ (supports latest SwiftUI features)
- **Testing Framework**: Swift Testing (new framework, not XCTest)
- **Core Data Model**: VybeMVP.xcdatamodeld (automatic migration enabled)
- **Firebase Integration**: GoogleService-Info.plist required for Firebase services

## Architecture Overview

### Core Design Patterns
- **MVVM Architecture**: Models, Views, ViewModels with SwiftUI + Combine
- **Manager Pattern**: Singleton managers for core functionality with dependency injection
- **ObservableObject**: Reactive state management throughout the app
- **Environment Objects**: Shared state management across SwiftUI views

### Key Architectural Components

#### Core Data Stack
- **PersistenceController**: Centralized Core Data management with automatic migration
- **Models**: JournalEntry, FocusMatch, UserPreferences, PersistedInsightLog, Sighting
- **Thread Safety**: Main context for UI, background contexts for saving operations
- **Performance**: Optimized with automatic merging and fault management

#### Manager Layer (Singleton Business Logic)
- **VybeMatchManager**: Cosmic alignment detection (Focus Number == Realm Number)
- **AIInsightManager**: Personalized spiritual insights with Core Data persistence
- **RealmNumberManager**: Dynamic calculation engine (time + biometrics + location)
- **FocusNumberManager**: User's chosen spiritual anchor number (1-9)
- **HealthKitManager**: Heart rate and biometric integration for cosmic calculations
- **JournalManager**: Journal CRUD operations with voice recording support
- **AuthenticationManager**: Firebase Auth + Apple Sign-In integration
- **NotificationManager**: Numerology-based notification scheduling

#### Cosmic Animation System
- **ScrollSafeCosmicView**: TimelineView-based animation wrapper for scroll-safe cosmic effects
- **CosmicBackgroundLayer**: Lightweight background animations (60fps performance)
- **TwinklingDigitsBackground**: Procedural number generation with sacred geometry blooming
- **NeonTracerView**: BPM-synced glow effects around sacred geometry
- **DynamicAssetMandalaView**: Time-based rotation of sacred geometry assets (every 15 minutes)

#### Sacred Geometry & Numerology
- **SacredGeometryAssets**: 70+ SVG assets categorized by sacred numbers (0-9)
- **NumerologyService**: Life Path, Soul Urge, Expression number calculations
- **InsightFilterService**: Template matching and personalization algorithms
- **Sacred Color System**: Number-based color mappings with spiritual correspondences

### Data Flow Architecture

#### Cosmic Match Detection Flow
1. **RealmNumberManager** calculates dynamic realm number (time + biometrics + location)
2. **FocusNumberManager** maintains user's chosen focus number
3. **VybeMatchManager** detects alignment via NotificationCenter subscriptions
4. **VybeMatchOverlay** displays multi-modal celebrations (haptics + particles + audio)
5. **Match history** persisted for analytics and cooldown management

#### Insight Generation System
1. **UserProfileService** provides spiritual profile data
2. **InsightFilterService** scores and matches insight templates
3. **AIInsightManager** orchestrates personalized insight delivery
4. **Core Data persistence** for activity feed and daily insight caching
5. **ActivityView** displays insight history and analytics

#### Authentication & State Management
1. **AppDelegate** configures Firebase and background tasks
2. **AuthenticationWrapperView** manages auth flow and onboarding state
3. **UserProfileService** handles Firestore profile management
4. **Onboarding flow** collects spiritual preferences and numerological data

## Key Files & Components

### Entry Points
- `VybeApp/VybeMVPApp.swift`: Main app entry point with Firebase configuration
- `Views/AuthenticationWrapperView.swift`: Root navigation and auth flow management
- `Views/ContentView.swift`: Main authenticated app interface

### Core Managers (Business Logic)
- `Managers/VybeMatchManager.swift`: Cosmic alignment detection and celebrations
- `Managers/AIInsightManager.swift`: Personalized insight generation and caching
- `Managers/RealmNumberManager.swift`: Dynamic cosmic number calculations
- `Managers/FocusNumberManager.swift`: User's spiritual anchor number management
- `Managers/HealthKitManager.swift`: Biometric data integration for cosmic calculations

### Data Layer
- `Core/Data/PersistenceController.swift`: Core Data stack with automatic migration
- `Core/Models/`: Core data models and spiritual entity definitions
- `NumerologyData/`: JSON templates for insights and number meanings

### UI Components
- `Views/ReusableComponents/CosmicAnimations/`: Scroll-safe cosmic animation system
- `Views/ReusableComponents/`: Shared UI components (badges, charts, loading views)
- `Features/`: Feature-specific view modules (Journal, Onboarding, Social, etc.)

### Cosmic Animation System
- `Views/ReusableComponents/CosmicAnimations/ScrollSafeCosmicView.swift`: Main cosmic animation wrapper
- `Views/ReusableComponents/CosmicAnimations/CosmicBackgroundLayer.swift`: Background animation layer
- `Views/ReusableComponents/TwinklingDigitsBackground.swift`: Procedural number effects

## Development Guidelines

### File Organization
- Always specify exact file locations when creating new files
- Follow existing folder structure: `Core/`, `Managers/`, `Features/`, `Views/`
- Place reusable UI components in `Views/ReusableComponents/`
- Sacred geometry and cosmic animations go in `Views/ReusableComponents/CosmicAnimations/`

### SwiftUI & Performance
- Use @StateObject for manager instances, @EnvironmentObject for sharing
- Implement scroll-safe animations using TimelineView pattern
- Maintain 60fps performance during cosmic animations
- Follow cosmic theming with sacred color system and spiritual iconography

### Numerology & Spiritual Integrity
- Preserve master numbers (11, 22, 33, 44) in all calculations
- Follow established sacred color mappings for numbers 0-9
- Maintain spiritual authenticity in all UI text and imagery
- Use proper sacred geometry correspondences for visual elements

### Firebase & Authentication
- Firebase configuration happens in AppDelegate for reliability
- User profiles stored in Firestore with local UserDefaults caching
- Apple Sign-In integrated with Firebase Auth
- Background task scheduling for cosmic number updates

### Testing & Quality Assurance
- Use Swift Testing framework (not XCTest) for new tests
- Test critical numerology calculations for accuracy
- Validate cosmic match detection logic thoroughly
- Performance test cosmic animations on device (target 60fps)

### Code Documentation
- Comprehensive header comments required for all managers
- Document spiritual correspondences and numerological meanings
- Include performance notes and integration points
- Maintain AI handoff documentation in master taskflow logs

## Current Development Status

### Recently Completed
- **Phase 1**: Scroll-safe cosmic animation system with twinkling numbers
- **Phase 2.1**: Multi-modal cosmic match celebrations (haptics + particles + audio)
- **Phase 2.2**: Enhanced VybeMatchOverlay with interactive action buttons

### Current Phase (2.3)
- Enhanced Activity View with cosmic match integration
- Badge navigation system for all NumerologyBadge components
- Code quality improvements and comprehensive comment updates

### Known Issues
- Sacred frequency audio implementation needs actual AVFoundation integration
- Build performance occasionally stalls around compilation phase (complex SwiftUI views)
- Some badge components need navigation closure implementations

## Testing Notes

- Tests use Swift Testing framework with `@Test` annotations
- VybeMVPTests.swift contains basic test structure
- Parallelizable tests enabled in VybeMVP.xctestplan
- Focus on testing numerology calculations and cosmic match detection logic
- Use in-memory Core Data stores for test isolation

## Important Architecture Notes

### Cosmic Animation Performance
- All cosmic animations use TimelineView for off-main-thread rendering
- Maximum 60-100 active cosmic objects to maintain 60fps
- Scroll-safe implementation prevents animation stuttering during UI interactions
- Sacred geometry assets loaded lazily to prevent memory issues

### State Management Philosophy
- Single source of truth via singleton managers
- Reactive updates through @Published properties and Combine
- Environment object injection for SwiftUI view hierarchy
- Core Data as persistent state store with optimized queries

### Spiritual Data Integrity
- All numerology calculations preserve spiritual accuracy
- Sacred geometry assets maintain proper mystical correspondences
- Color system follows traditional numerological associations
- Master numbers (11, 22, 33, 44) never reduced inappropriately