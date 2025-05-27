# UserProfileModel.swift – Sacred Identity Structure

**Purpose:** This model defines the user's complete spiritual and energetic identity in Vybe, integrating numerology, planetary, elemental, and preference-based data into a central profile model.

---

## Core Definition

```swift
struct UserProfile: Codable, Identifiable {
    var id: String  // UID
    var fullName: String
    var birthdate: Date
    var timeOfBirth: Date?  // Optional
    var spiritualMode: String
    var insightTone: String
    var focusTags: [String]

    // Core Numbers
    var lifePathNumber: Int
    var soulUrgeNumber: Int
    var expressionNumber: Int

    // Zodiac & Element
    var zodiacSign: String
    var element: ElementType  // enum: .fire, .earth, .air, .water

    // Planetary Archetypes
    var primaryPlanet: Planet
    var subconsciousPlanet: Planet

    // Meta
    var createdAt: Date
    var lastUpdated: Date
}
```

---

## Supporting Enums

```swift
enum ElementType: String, Codable {
    case fire, earth, air, water
}

enum Planet: String, Codable {
    case sun, moon, mercury, venus, mars, jupiter, saturn, uranus, neptune, pluto
}
```

---

## Data Sources

| Field                  | Derived From                                |
|------------------------|---------------------------------------------|
| lifePathNumber         | Calculated from `birthdate`                 |
| soulUrgeNumber         | Calculated from vowels in `fullName`        |
| expressionNumber       | Calculated from all letters in `fullName`   |
| zodiacSign             | From calendar position of `birthdate`       |
| element                | Derived from `zodiacSign`                   |
| primaryPlanet          | Mapped from `lifePathNumber`                |
| subconsciousPlanet     | Mapped from `lifePathNumber` (alternative)  |

---

## Storage Plan

- Firestore Document per User under `/users/{userId}`
- Cache in UserDefaults for offline access
- Used by:
  - AIInsightManager
  - ArchetypeDisplayView
  - ResonanceEngine
  - UserProfileTabView
  - ArchetypeCardGenerator

---

## Future Expansion Fields

| Field            | Description                                    |
|------------------|------------------------------------------------|
| moonPhaseAtBirth | Adds astrological depth (if time is provided)  |
| preferredLanguage | For multilingual future support               |
| insightHistory   | Array of Insight objects (Firestore subcollection) |
| friends          | Social layer support (future)                  |

---

## Summary

This model is the backbone of Vybe's personalized insight system. It carries the user's soul blueprint and drives everything from archetype displays to daily messages, matches, cards, and future social dynamics.

