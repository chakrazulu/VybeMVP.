# AI Insight Framework

**Purpose:** This file defines how numerological data is used to shape AI-generated daily insights in the Vybe app.

---

## Numerology-to-Insight Mapping

| Attribute         | Use in Insight Generation                              |
|------------------|--------------------------------------------------------|
| Life Path        | Core archetype / lesson of the day                     |
| Soul Urge        | Emotional tone and internal prompt themes              |
| Expression       | Language style and delivery rhythm                     |
| Element          | Metaphor set (Fire = passion, Water = emotion, etc.)  |
| Planet Archetype | Celestial styling and symbolic overlays                |

---

## Insight Generation Flow (Pseudocode)

```
if user.hasValidProfile:
    archetype = getLifePathArchetype(user.lifePath)
    tone = getSoulUrgeTone(user.soulUrge)
    style = getExpressionStyle(user.expression)
    elementFlair = getElementFilter(user.element)
    celestialTag = getPlanetSignature(user.primaryPlanet)

    finalInsight = combine(archetype, tone, style, elementFlair, celestialTag)
    return finalInsight
```

---

## Future Expansion

- Streak-based archetype shifts
- Resonance matches influence daily prompt
- Synced moon phase influence
