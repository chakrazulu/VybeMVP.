# Phantom of the Chakras

## Overview

The Phantom of the Chakras is an interactive spiritual feature that allows users to explore and harmonize their seven chakras through sound, vibration, and visual feedback. Each chakra is represented by a beautiful, animated symbol that responds to touch and resonates with the user's numerological profile.

## Features

### 🌟 Core Functionality

1. **Interactive Chakra Display**
   - Seven vertically aligned chakra symbols
   - Each chakra has unique colors, frequencies, and properties
   - Animated glow effects that respond to user interaction

2. **Multi-Sensory Interaction**
   - **Tap**: Quick activation with visual and haptic feedback
   - **Long Press**: Continuous harmonization with sustained tones
   - **Multi-Touch**: Play multiple chakras simultaneously for harmonic blends

3. **Numerological Integration**
   - Chakras automatically resonate with user's Focus Number
   - Enhanced glow for chakras aligned with Realm Number
   - Visual indication of spiritual alignment

4. **Meditation Mode**
   - Dedicated meditation interface with Om symbol
   - Timer with progress tracking
   - Play/pause/stop controls
   - 5-minute default sessions (configurable)

## Technical Implementation

### Architecture

```
Features/Chakras/
├── ChakraModel.swift        # Data models and enums
├── ChakraManager.swift      # Audio/haptic engine and state management
├── ChakraSymbolView.swift   # Individual chakra UI component
├── PhantomChakrasView.swift # Main feature view
└── README.md               # This file
```

### Key Components

1. **ChakraType Enum**
   - Defines all seven chakras with properties:
     - Sanskrit names
     - Colors (traditional chakra colors)
     - Frequencies (Solfeggio healing frequencies)
     - Elements, mantras, and affirmations
     - Numerological associations

2. **ChakraManager (Singleton)**
   - AVAudioEngine for tone generation
   - CoreHaptics for vibrational feedback
   - State management for all chakras
   - Meditation timer functionality

3. **Audio System**
   - Pure sine wave generation for each frequency
   - Real-time audio synthesis
   - Multi-channel mixing for simultaneous playback
   - Volume control

4. **Haptic System**
   - Frequency-based haptic patterns
   - Synchronized with audio playback
   - Adjustable intensity

## Chakra Properties

| Chakra | Sanskrit | Frequency | Element | Number Resonance |
|--------|----------|-----------|---------|------------------|
| Root | Muladhara | 396 Hz | Earth | 1, 4, 8 |
| Sacral | Svadhisthana | 417 Hz | Water | 2, 6 |
| Solar Plexus | Manipura | 528 Hz | Fire | 3, 9 |
| Heart | Anahata | 639 Hz | Air | 4, 6 |
| Throat | Vishuddha | 741 Hz | Ether | 5 |
| Third Eye | Ajna | 852 Hz | Light | 7, 11 |
| Crown | Sahasrara | 963 Hz | Thought | 8, 9, 22 |

## User Experience

### Visual Design
- Cosmic background integration
- Glowing aura effects with multiple layers
- Smooth animations and transitions
- Sanskrit names displayed on symbols
- Active state indicators

### Interaction Flow
1. User enters Chakras tab
2. Chakras animate in from bottom to top
3. Tap for detail sheet with full information
4. Long press to activate continuous tone
5. "Begin Meditation" opens dedicated meditation view

## Configuration

The `ChakraConfiguration` struct allows customization of:
- Sound enabled/disabled
- Haptics enabled/disabled
- Visual effects toggle
- Volume level (0.0 - 1.0)
- Meditation duration

## Future Enhancements

1. **Chakra Journal Integration**
   - Log chakra states during meditation
   - Track balance over time

2. **Guided Chakra Meditation**
   - Audio guidance for each chakra
   - Progressive activation sequences

3. **Chakra Analytics**
   - Track which chakras are most/least active
   - Personalized balance recommendations

4. **Advanced Visualizations**
   - Sacred geometry overlays
   - Energy flow animations
   - Aura visualization

## Integration Notes

- The feature integrates seamlessly with existing numerology systems
- Uses the shared `CosmicBackgroundView` for visual consistency
- Follows MVVM architecture pattern
- All audio/haptic resources are generated programmatically (no external files needed)

## Performance Considerations

- Audio engine starts on-demand to save battery
- Haptic patterns are pre-calculated for efficiency
- Animations use SwiftUI's built-in optimization
- Memory-efficient tone generation

## Testing

To test the feature:
1. Add files to Xcode project (see add_chakras_to_xcode.sh)
2. Build and run
3. Navigate to the Chakras tab
4. Test each interaction mode
5. Verify audio plays through device speakers
6. Check haptic feedback on supported devices

## Version History

### Version 1.2 (Current)
- **Lofi Meditation Sound Design**
  - Much softer attack (200ms) for gentle onset
  - Added medium hall reverb for spaciousness
  - EQ with low shelf boost and high frequency cut for warmth
  - Reduced overall volume and harmonics
  - Added subtle analog noise for vintage character
  - Soft limiting to prevent harshness
  
- **Heart Rate Synchronized Haptics**
  - Haptics now pulse at your actual heart rate BPM
  - Creates a meditative heartbeat rhythm
  - Lub-dub pattern for more natural feel
  - Gentler haptic intensity for relaxation
  
- **Audio Effects Chain**
  - Player → Reverb → EQ → Output
  - Creates warm, spacious meditation atmosphere
  - Professional audio processing for comfort

### Version 1.1
- **Improved Sound Quality**
  - Added harmonic overtones for richer tones
  - Implemented smooth attack/decay envelope
  - Added subtle vibrato for organic feel
  - Reduced harshness when multiple chakras play together
  
- **Individual Volume Control**
  - Volume slider appears when chakra is harmonizing
  - Each chakra can have its own volume level
  - Volume settings persist during session
  
- **Enhanced Meditation Mode**
  - Active chakras continue playing during meditation
  - Volumes automatically reduced by 50% for meditation
  - Original volumes restored when meditation ends
  
- **Haptic Engine Improvements**
  - Added automatic restart handlers
  - Better error recovery
  - More reliable vibration feedback

### Version 1.0
- Initial implementation
- Basic chakra interface
- Simple sine wave tones
- Basic haptic feedback 