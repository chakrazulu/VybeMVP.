# Sightings Portal

## Overview
The Sightings Portal is a feature that allows users to capture and track synchronicities - moments when they spot their focus numbers in daily life. Users can photograph these moments, add notes about their significance, and track patterns over time.

## Features

### Core Functionality
- **Photo Capture**: Take photos or select from library to document sightings
- **Number Selection**: Choose which number (1-9) was spotted
- **Location Tracking**: Optional location capture with map display
- **Notes & Significance**: Add context about why the sighting was meaningful
- **Timeline View**: Browse all sightings chronologically
- **Filtering**: Filter sightings by specific numbers
- **Statistics**: View counts for today, total, and most frequent numbers

### Technical Components

#### Core Data Model (`Sighting`)
- `id`: UUID
- `numberSpotted`: Int16
- `title`: String (optional)
- `note`: String (optional)
- `significance`: String (optional)
- `imageData`: Binary (external storage)
- `timestamp`: Date
- `locationLatitude`: Double
- `locationLongitude`: Double
- `locationName`: String (optional)

#### Manager
- **SightingsManager**: Singleton managing all CRUD operations, filtering, and analytics

#### Views
1. **SightingsView**: Main portal displaying all sightings with stats
2. **NewSightingView**: Form for creating new sightings with camera/photo integration
3. **SightingDetailView**: Full details with photo, map, and sharing options
4. **Supporting Views**: FilterChips, StatCards, SightingCards

### User Flow
1. User taps floating camera button or "Record First Sighting"
2. Selects/confirms the number they spotted (defaults to their focus number)
3. Captures photo via camera or selects from library
4. Adds optional title, note, and significance
5. Chooses to use current location or enter custom location
6. Saves sighting to Core Data
7. Views sighting in timeline with filtering and detail options

### Design Highlights
- **Cosmic Theme**: Consistent with app's spiritual aesthetic
- **Sacred Colors**: Each number has its associated color throughout
- **Smooth Animations**: Staggered fade-ins and spring animations
- **Haptic Feedback**: Tactile responses for key interactions

### Permissions Required
- Camera access (for photo capture)
- Photo library access (for photo selection)
- Location access (optional, for geotagging)

### Future Enhancements
- Heat map visualization of sighting locations
- Time-based patterns (e.g., "You see 7s most often at 3pm")
- Social sharing with custom cards
- Sighting streaks and achievements
- Export functionality for sightings data
- Integration with journal entries

## Usage

The Sightings Portal appears as a tab in the main navigation. Users can:
- View all sightings in a timeline
- Filter by specific numbers
- Tap any sighting for full details
- Share sightings with formatted text and images
- Track their synchronicity patterns over time 