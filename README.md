# VybeMVP - Transcendental Number System

## Overview
VybeMVP is an iOS application that implements a transcendental number system, combining real-time calculations with numerological principles. The app processes time, location, and biometric data to generate meaningful number patterns and track synchronicities.

## Core Features

### 1. Focus Number System
- User-selected focus numbers (1-9)
- Real-time calculation using:
  - UTC time components
  - Location data (latitude/longitude)
  - BPM (simulated heart rate)
- Transcendental reduction method ensuring pure number essence
- Match detection and logging

### 2. Realm Number System
- Automatic updates every minute
- Components:
  - Time factors (hour, minute)
  - Date factors (day, month)
  - Location coordinates
  - Activity levels (BPM ranges)
- Real-time synchronicity detection with focus numbers

### 3. Number Meanings
- Comprehensive documentation of numbers 0-9
- Structured content for each number:
  - Title
  - Essence
  - Symbolism
  - Application
  - Additional notes
- Interactive UI with number picker

### 4. Journal System
- Entry creation and management
- Mood tracking
- Timestamp association
- CoreData persistence

## Technical Implementation

### Architecture
- MVVM design pattern
- CoreData for persistence
- SwiftUI for modern UI
- Manager classes for business logic

### Key Components
1. **Managers/**
   - `FocusNumberManager`: Handles focus number calculations and matches
   - `RealmNumberManager`: Manages realm number updates and calculations
   - `JournalManager`: Handles journal entries and persistence

2. **Core/Models/**
   - `NumberMeaning`: Structure for number documentation
   - `JournalMood`: Enumeration of mood states
   - CoreData entities for persistence

3. **Views/**
   - Tab-based navigation
   - Specialized views for each feature
   - Reusable components

### Data Flow
1. **Focus Number Calculation**
   ```swift
   Time Components + Location Data + BPM = Raw Sum → Transcendental Reduction
   ```

2. **Realm Number Updates**
   ```swift
   (Hour + Minute) + (Day + Month) + Location Factor + BPM = Raw Total → Final Reduction
   ```

3. **Match Detection**
   - Real-time monitoring of focus and realm numbers
   - Automatic logging of matches
   - CoreData persistence of match history

## Current Capabilities

### 1. Number Processing
- Transcendental reduction of all components
- Pure number calculations without early reductions
- Activity-based BPM simulation (62-135 BPM)

### 2. User Interface
- Clean, intuitive tab navigation
- Interactive number selection
- Detailed number meaning display
- Journal entry management

### 3. Data Management
- CoreData persistence for matches and journal entries
- Real-time updates and calculations
- Comprehensive logging system

### 4. Location Services
- Coordinate tracking
- Distance-based updates (500m threshold)
- Location factor integration

## Development Notes

### Logging System
- Emoji-based log categories
- Detailed calculation breakdowns
- State transitions and updates
- Match detection notifications

### State Management
- Clear state tracking
- Error handling
- Background processing
- Timer management

## Future Enhancements
1. Real BPM integration
2. Enhanced match analytics
3. Expanded number meanings
4. Journal entry analysis
5. Location pattern recognition

## Build and Run
- Requires iOS 15.0+
- Xcode 13.0+
- Location permissions required
- Background capability for updates
