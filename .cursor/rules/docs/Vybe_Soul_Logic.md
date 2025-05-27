# Vybe Numerology System & Phase 2 Architecture

**Generated:** May 26, 2025

---

## Cursor Implementation Recap

Cursor reviewed the Phase 2 implementation brief and confirmed the structure and architecture of the current VybeMVP app. They analyzed the onboarding system, recognized the missing spiritual identity structure (like birthdate and name), and proposed a series of enhancements to support numerology-based personalization. They confirmed:

- Clean MVVM architecture
- Numerology messaging engine exists
- CoreData and Firestore in use
- Needed: UserArchetypeManager, ArchetypeDisplayView, ResonanceEngine
- Needed: Name + Birthdate capture

---

## Numerology Calculation Logic (from *Numerology and the Divine Triangle*)

### Letter to Number Mapping (Pythagorean Table)

| Number | Letters       |
|--------|---------------|
| 1      | A, J, S        |
| 2      | B, K, T        |
| 3      | C, L, U        |
| 4      | D, M, V        |
| 5      | E, N, W        |
| 6      | F, O, X        |
| 7      | G, P, Y        |
| 8      | H, Q, Z        |
| 9      | I, R           |

### Soul Urge Number

- Use **vowels only** from full birth name
- Reduce to a single digit unless the total is 11, 22, or 33 (master numbers)
- Example: A, E, I, O, U from “Sarah Ellen Vaughn” → 1 + 5 + ... = Soul Urge 7

### Expression Number

- Use **all letters** of the full name
- Same mapping as above
- Master numbers 11, 22, 33 are **preserved**, not reduced

---

## AI Insight Mapping Logic

### Number Roles in Insight Generation

| Number Type      | Purpose                                |
|------------------|----------------------------------------|
| Life Path        | Governs insight **archetype**          |
| Soul Urge        | Modifies **tone and prompt style**     |
| Expression       | Shapes **language and delivery rhythm**|
| Element          | Adds **emotional tone / metaphor**     |
| Planet Archetype | Adds **celestial metaphors**           |

### Example Insight Mapping

**User Profile:**
- Life Path = 7 (Seeker)
- Soul Urge = 5 (Freedom)
- Expression = 2 (Diplomat)

**Generated Insight Profile:**
- Theme: Deep spiritual introspection
- Tone: Light, adventurous, seeking new ideas
- Language: Gentle, collaborative, reflective

---

This document defines the core spiritual identity logic and outlines how future AI insights will be shaped dynamically using structured numerological attributes.
