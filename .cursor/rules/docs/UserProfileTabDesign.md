# User Profile Tab Design – “My Vybe”

**Purpose:** This file outlines the design and interaction plan for transforming the Completion View into a permanent, sacred user profile tab within the Vybe app.

---

## Tab Identity

- **Tab Name**: My Vybe
- **Tab Icon**: Glowing glyph (sigil, eye, planet, or crystal)
- **Role**: Central hub for viewing and interacting with the user's spiritual identity

---

## Component Structure

| Section             | Component            | Interaction / Description                                                                 |
|---------------------|----------------------|---------------------------------------------------------------------------------------------|
| Header              | Animated Background  | Cosmic gradient or animated glyphs/starfield                                               |
| Profile Summary     | User Name + Title    | Pulls from onboarding; may include optional spiritual title                                |
| Life Path           | Number + Label       | Tap to open modal with explanation, quotes, lesson paths                                   |
| Soul Urge           | Number + Label       | Tap to reveal subconscious desires and journaling prompts                                  |
| Expression Number   | Number + Label       | Tap to view how others see them; external tone influence                                   |
| Zodiac Sign         | Glyph + Name         | Tap to learn seasonal energy, ruling element, compatibility                                |
| Element Ring        | Color-coded circle   | Tap to reveal traits of Air/Fire/Earth/Water, and syncing options                         |
| Planet Glyphs       | Primary + Subconscious| Tap to learn about the ruling planets, mythology, and behavioral tendencies               |
| Sigil (optional)    | Personal Sigil       | Long-press to expand or regenerate variants (based on daily alignment or AI)              |
| Focus Tags          | List of Tags         | Tap to edit or expand meaning                                                              |
| Time of Birth       | Display if given     | Reserved for future astrology features                                                     |

---

## UX Enhancements

- **Haptic Feedback**: All interactive elements provide soft feedback on touch
- **Animated Transitions**: Cards slide or pulse open when expanded
- **Cosmic Sounds (Future)**: Tapping planets or elements plays ambient notes
- **Light/Dark Support**: Background adapts based on time of day or elemental mood

---

## Feature Notes

- **Save as User Sanctum**: This tab is not a settings page; it’s a sacred space.
- **Editable Fields**: Name, time of birth, and focus tags should be editable via small pencil icon.
- **Real-Time Reflection**: User's current focus number or moon phase can influence appearance of the page.
- **Profile Share Option (Future)**: Ability to share their “Cosmic Profile” as an image.

---

## Next Phase Integration

- `UserProfileTabView.swift` will draw from:
  - `UserProfileModel.swift`
  - `NumerologyEngine.swift`
  - `ZodiacHelper.swift`
  - `PlanetArchetypeManager.swift`

- Synced to Firestore & UserDefaults for access across sessions and devices.

---

## Summary

This tab serves as the core of the user’s spiritual identity. It should feel alive, interactive, symbolic, and reverent — offering knowledge, reflection, and inspiration on every visit.
