# ArchetypeCardGenerator.md

**Purpose:** This file outlines the visual and functional design of the user's shareable "Cosmic Archetype Card" in Vybe — a collectible identity card that reflects their spiritual blueprint.

---

## Overview

The **Archetype Card** is a beautiful, visually rich identity object that summarizes the user’s numerology and cosmic makeup. It can be:

- Viewed within the “My Vybe” tab
- Saved to Photos
- Shared to social or other Vybe users (future)

---

## Card Elements

| Layer             | Component                       | Description                                                 |
|------------------|----------------------------------|-------------------------------------------------------------|
| Background        | Cosmic gradient or glyph field   | Optionally themed by element (Fire, Earth, etc.)            |
| Core Glyph        | Focus Number or Planet Sigil     | Centered visual glyph that reflects user's energetic core   |
| Name Tag          | User’s full name                 | Styled with sacred typography                               |
| Life Path         | Number + Label                   | “Life Path 7 – The Seeker”                                  |
| Soul Urge         | Number + Label                   | “Soul Urge 5 – Freedom”                                     |
| Expression        | Number + Label                   | “Expression 2 – Harmony”                                    |
| Zodiac Sign       | Glyph + Label                    | Optional date range display                                 |
| Element           | Color-coded ring or tag          | Fire = Red, Air = Blue, etc.                                |
| Planets           | Primary + Subconscious           | Planet symbols with short keyword (e.g. Venus = Beauty)     |
| Focus Tags        | Selected focus themes            | 3–5 focus words in a glyph bar                              |
| Insight Tone      | Icon + style word                | Poetic, Direct, Mythic, etc.                                |
| Timestamp         | Date generated                   | Optional display at bottom corner                           |

---

## Visual Format

- Aspect Ratio: 4:5 or square
- Color Themes: Dynamic — based on user’s element or zodiac
- Font: Sacred, readable, cosmic-inspired
- Glow: Glyphs and key symbols should glow subtly
- Motion: Optional shimmer or sparkle animation (future)

---

## Save & Share

- **Save to Photos**: Button to generate high-res PNG
- **Share**: Sheet to share to iMessage, IG, etc. (future)
- **Regenerate**: Option to refresh look based on current moon/planet alignment

---

## Technical Notes

### Storage

- Stored locally and regeneratable on demand
- Also saved to Firestore under user document as lastPreviewImageURL (optional)

### Generation Stack

| Data Source                | Component                             |
|----------------------------|----------------------------------------|
| UserProfileModel.swift     | lifePath, soulUrge, expression, etc.   |
| NumerologyEngine.swift     | Calculations                           |
| PlanetArchetypeManager.swift | Planet glyphs, keywords                |
| ElementColorPalette.swift  | Theming by Element                     |

---

## Future Expansion

- Dynamic themes (e.g. “Full Moon Mode” or “Mercury Retrograde Aura”)
- Multi-card collection (e.g. Seasonal Archetype Cards)
- Sigil integration (add their personal sigil to the card)
- NFT or collectible format (optional, future)

---

## Summary

The Archetype Card is Vybe’s way of giving the user a visual soul-token — something beautiful, symbolic, and uniquely theirs. It connects their numerology, astrology, and chosen focus into a single shareable identity.
