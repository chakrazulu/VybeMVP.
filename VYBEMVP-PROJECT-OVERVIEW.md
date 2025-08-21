# VybeMVP - Sacred Numerology & Transcendental Journaling App

## 🌌 Project Overview

VybeMVP is a spiritually immersive numerology and transcendental journaling app built in Swift using SwiftUI + Firebase. The app creates a cosmic interface for users to explore their sacred numbers and maintain a spiritual journal with voice reflections.

## ✨ Core Features

- 🔢 **Focus and Realm Numbers**: Personalized numerology calculations
- 🌌 **Cosmic Background Animations**: Sacred geometry and mystical UI
- 🪐 **Personalized Insights**: AI-generated cosmic insights based on numerology
- 📖 **Sacred Journal**: Private spiritual journaling with encryption
- 🔊 **Voice Reflections**: Audio recording and playback for journal entries
- 🧠 **Auto-generated Cosmic Insights**: Resonance matching and sacred notifications
- 🧘 **Enhanced Wisdom Collections**: Alan Watts Zen philosophy and Carl Jung archetypal psychology
- 🛸 **Mystical UI Components**: Sacred color logic and animated elements

## 🏗️ Project Structure

```
VybeMVP/
├── App/                              # Main app configuration
├── Auth/                             # Authentication components
├── Core/
│   ├── Data/
│   │   └── VybeMVP.xcdatamodeld/    # Core Data model
│   ├── Models/                       # Core data models
│   └── Utilities/                    # Core utilities
├── Features/
│   ├── Activity/                     # Activity tracking features
│   ├── Insights/                     # AI insights and cosmic messages
│   ├── Journal/                      # Journaling system
│   │   ├── JournalView.swift
│   │   ├── NewJournalEntryView.swift
│   │   ├── JournalEntryDetailView.swift
│   │   └── EditJournalEntryView.swift
│   ├── NumberMeanings/              # Numerology interpretations
│   ├── Onboarding/                  # User onboarding flow
│   ├── SignIn/                      # Authentication views
│   └── UserProfile/                 # Profile management
├── Managers/                        # Core business logic
│   ├── VoiceRecordingManager.swift  # Audio recording/playback
│   ├── JournalManager.swift         # Journal CRUD operations
│   ├── FocusNumberManager.swift     # Focus number logic
│   ├── RealmNumberManager.swift     # Realm number calculations
│   ├── BackgroundManager.swift      # Background tasks
│   ├── HealthKitManager.swift       # Health data integration
│   ├── AIInsightManager.swift       # AI-powered insights
│   ├── UserProfileService.swift     # User profile management
│   ├── NumerologyService.swift      # Numerology calculations
│   └── Services/                    # Additional services
├── NumerologyData/                  # JSON data for numerology messages
├── Utilities/                       # Helper utilities and extensions
├── Views/
│   └── ReusableComponents/          # Shared UI components
└── VybeApp/                         # App assets and configuration
```

## 🔧 Recent Bug Fixes (Nov 19, 2024)

### Voice Recording Issues Fixed
- **State Management**: Improved recording state synchronization between UI and VoiceRecordingManager
- **File Access**: Added proper file verification before attempting audio operations
- **UI Consistency**: Fixed waveform display timing and button state management
- **Error Handling**: Enhanced error logging and graceful failure handling

### Journal Entry Edit Bug Fixed
- **Missing Edit Option**: Added Edit menu item to JournalEntryDetailView toolbar
- **Modern UI**: Updated EditJournalEntryView with cosmic theme and better UX
- **Navigation**: Improved navigation patterns using modern SwiftUI standards

### Audio File Management Improvements
- **File Verification**: Added existence and readability checks before audio operations
- **State Synchronization**: Improved recording state transitions
- **Error Prevention**: Added safeguards against accessing incomplete audio files

## 🎯 Key Architecture Patterns

### MVVM Design Pattern
- **Models**: Core Data entities (JournalEntry, PersistedInsightLog)
- **Views**: SwiftUI views with cosmic theming
- **ViewModels**: ObservableObject managers for business logic

### Manager Pattern
- **Singleton Managers**: Shared instances for core functionality
- **Dependency Injection**: Environment objects for SwiftUI views
- **Combine Integration**: Reactive programming for data flow

### Sacred Theming
- **Cosmic Backgrounds**: Animated gradient backgrounds
- **Sacred Colors**: Number-based color assignments
- **Mystical UI**: Sacred geometry and spiritual iconography

## 🛠️ Development Guidelines

### Code Standards
1. Use latest Swift and Xcode standards
2. Follow MVVM architecture pattern
3. Provide comprehensive documentation
4. Optimize for performance and memory efficiency
5. Implement proper error handling

### File Management
1. Save files in correct project directories
2. Prevent duplicate file creation
3. Automatically add files to Xcode project
4. Maintain logical folder structure

### Security & Privacy
1. Encrypt sensitive user data
2. Follow Apple's privacy guidelines
3. Use secure HTTPS communication
4. Implement data protection mechanisms

### Testing
1. Generate test cases for new functionality
2. Provide mock data for testing
3. Test critical features thoroughly
4. Use proper debugging tools

## 🚀 Current Branch: feature/journal-cosmic-enhancement

Working on enhancing the JournalView with:
- Cosmic backgrounds and sacred geometry overlays
- Improved voice reflection recording
- Enhanced metadata tagging (Focus Number, Realm Number, Timestamp)
- Mood-based UI interactions
- Future plans for animated sigils and deeper cosmic integrations

## 📝 Known Issues & Future Improvements

### Build Performance
- Build stalls around 1640/1654 during compilation phase
- Likely related to complex SwiftUI view hierarchies
- Consider modularization for improvement

### Voice Recording Enhancements
- Add waveform visualization during recording
- Implement voice-to-text transcription
- Add audio quality settings

### Sacred Geometry Integration
- Animated sacred geometry overlays based on numerology
- Dynamic sigil generation
- Cosmic particle effects

## 🔮 KASPER MLX - Revolutionary Spiritual AI Dataset

[![KASPER MLX Release Cards](https://github.com/VybeMVP/VybeMVP/actions/workflows/release-cards.yml/badge.svg)](https://github.com/VybeMVP/VybeMVP/actions/workflows/release-cards.yml)

**Version:** 2.0 | **Dataset Size:** 130 files (2.29 MB) | **Status:** Production Ready

VybeMVP now includes the world's first professionally documented spiritual AI dataset, specifically designed for Apple's MLX framework. KASPER MLX contains 130 professionally curated JSON files with 4,606+ behavioral insights across multiple spiritual wisdom traditions.

### Quick Start - Generate Release Documentation

```bash
# Production release (hard validation)
make release-cards

# Development-friendly (soft validation - warnings only)
make soft

# Custom configuration
python make_release_cards.py --soft --name my-dataset --version v2.1

# Cross-platform PowerShell (Windows)
.\scripts\release_cards.ps1
```

### Documentation Links

- 📋 **[DATA_CARD.md](docs/DATA_CARD.md)** - Comprehensive dataset documentation
- 🤖 **[MODEL_CARD.md](docs/MODEL_CARD.md)** - ML model specifications and ethics
- 🔐 **[MANIFEST.json](artifacts/MANIFEST.json)** - Dataset integrity verification

### Advanced Workflow

```bash
# Install development environment
make install-dev

# Generate release cards with policy-driven validation
make release-cards

# Test deterministic dataset digest (critical for production)
make determinism

# Run structural validation tests only (CI-compatible)
make test-structural

# Complete build pipeline
make build
```

### Testing & Validation

```bash
# Run all validation tests
make test

# Structural tests only (required for CI)
make test-structural

# Heuristic quality tests only
make test-heuristic

# Test dataset digest determinism
make determinism

# Manual pytest execution
python -m pytest tests/ -m structural --verbose
```

### Policy-Driven Configuration

Release validation is controlled by `configs/release_policy.yml`:

```yaml
gates:
  determinism: hard        # Always enforced
  schema_validation: hard  # Critical structural integrity
  duplicate_insights: soft # Can be warning in development
```

## 🔮 Future Roadmap

1. **Enhanced Sacred Geometry**: Dynamic geometry based on numerological attributes
2. **Cloud Sync**: CloudKit integration for cross-device synchronization
3. **KASPER MLX Training**: Native Apple MLX spiritual AI model training
4. **Social Features**: Sacred number matching and cosmic community
5. **Apple Watch**: Numerology notifications and quick reflections

---

**VybeMVP Development Team** - *Bridging Ancient Wisdom with Revolutionary AI* 🔮✨🌌
