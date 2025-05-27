# SigilGenerator.md – Procedural Sacred Geometry Blueprint

**Purpose:** This file outlines a system for generating unique, symbolic sigils or glyphs for each user based on their numerology — primarily derived from the name and birthdate entered during onboarding.

---

## Core Concept

Every user receives a **procedurally generated sacred glyph**, or "sigil," that:
- Represents their **Life Path**, **Soul Urge**, and **Expression Number**
- Uses letter-to-number mappings to form visual patterns
- Incorporates **sacred geometry rules** (symmetry, rotation, geometry ratios)
- Feels personal, symbolic, and visually mystical

---

## Input Variables

| Source                 | Purpose                            |
|------------------------|------------------------------------|
| Life Path Number       | Defines base shape archetype       |
| Soul Urge Number       | Defines internal glyph layering    |
| Expression Number      | Affects symmetry & curve vs line   |
| Full Name Letters      | Used to seed pattern arrangements  |
| Element Type           | Alters color scheme and flow       |
| Zodiac Sign            | Glyph overlay or outer ring form   |
| Focus Tags             | Optional embedded icons            |

---

## Procedural Generation Flow (Pseudocode)

```swift
let seed = name.unicodeScalars.reduce(0) { $0 + Int($1.value) } + birthdateEpoch
let randomGen = SeededRandom(seed: seed)

let baseShape = shapeForLifePath(user.lifePath)
let innerPattern = patternForSoulUrge(user.soulUrge)
let symmetry = symmetryForExpression(user.expression)

let glyph = SacredGeometryBuilder(
    base: baseShape,
    pattern: innerPattern,
    symmetry: symmetry,
    color: paletteForElement(user.element)
).generate()
```

---

## Visual Layers (Component Stack)

| Layer           | Source Field          | Description                                     |
|------------------|------------------------|-------------------------------------------------|
| Core Shape       | Life Path              | Circle, triangle, square, pentagon, spiral      |
| Inner Pattern    | Soul Urge              | Starburst, lattice, petal, wave, arrow          |
| Symmetry Mode    | Expression             | Radial, bilateral, asymmetrical, recursive      |
| Outer Ring       | Zodiac Sign            | Adds astrological glyph with element-based arc  |
| Color Palette    | Element                | Fire = red-orange, Earth = green-gold, etc.     |
| Fine Lines       | Name letters/seed      | Added flourishes, fractals, line intensity      |
| Overlay Glyphs   | Focus Tags             | Optional iconography mapped to focus traits     |

---

## Sigil Usage

- Displayed in **User Profile Tab**
- Used as part of **Insight Background** or **animated badge**
- Can be saved as **.png image or vector path**
- Option to **regenerate** using new cosmic alignments (moon, sun, etc.)

---

## Visual Style Guide

- **Line Style**: Sacred line weight (thick outer, thin inner)
- **Geometry**: Based on Golden Ratio, Flower of Life, Metatron's Cube
- **Glow**: Optional aura matching dominant planet or focus tag
- **Output Formats**: Rendered in SwiftUI or SceneKit for interactive view

---

## Technical Considerations

- Uses `Canvas` or `SceneKit` for real-time drawing
- Supports random symmetry modifiers via seeded logic
- Export to `SVG` or rasterized PNG

---

## Future Expansion

- Sigil Sharing + Trading (Social Layer)
- Sigil Wallpapers or Lock Screens
- Sigil NFT / Collection Book
- Daily Focus Sigil based on current alignment

---

## Summary

The Sigil Generator turns a user's numeric identity into sacred visual symbolism. This bridges numerology, identity, art, and magic into a personal digital artifact.
