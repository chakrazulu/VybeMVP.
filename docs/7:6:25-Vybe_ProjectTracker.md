# VybeMVP Project Tracker – Post Phase 5

## ✅ Completed
- Phase 3C-3: Action Button Navigation + Profile Data Connection
- Username Editing: Full implementation with settings integration
- Tone/Spiritual Mode Capture: Completed in onboarding flow
- Scroll-Safe Cosmic Animation Layer: HomeView + system-wide support
- KASPER Prep Layer (Partial): Preferences and user data being captured
- Chakra Affirmation Enhancement: Scoping + UI/UX finalized

---

## 🌌 Introducing K.A.S.P.E.R.

**KASPER** stands for **Knowledge‑Activated Spiritual Pattern & Expression Renderer**
Vybe’s forthcoming oracle engine—an AI framework that generates sacred insights, guided affirmations, and vibrational prompts in real time using numerology, astrology, biometrics, and symbolic logic.

**Data Ingestion:**
- User profile data: Life Path, Expression, Soul Urge
- State preference: Spiritual tone (e.g., Manifestation, Reflection)
- Daily sacred numerology (Focus & Realm)
- Chakra state and BPM (from HealthKit)
- Cosmic overlays: Lunar phases, astrological positions
- Proximity matches
- Dream journaling (future)

_All current onboarding and sacred data flows are being piped and primed for KASPER so that once it goes live, no retroactive refactoring is required._

---

## 🔜 Immediate Next Steps

### Phase 6: Onboarding Completion & AI Priming
- Re-enable onboarding screen for first-time sign-ins
- Connect onboarding to username creation flow
- Pipe tone/mode preference into `KASPERPrimingPayload`
- Firestore wipe → simulate new user flow for QA test

### Phase 7: Sacred Geometry Mandala Engine
- Alternate mandalas based on `.md` or `.json` sacred files
- Mandala display logic tied to:
  - Current tone
  - Daily number
  - Chakra state (future)
- Performance profiling: SVG layering, TimelineView integration
- Primed for KASPER: dynamic overlays, number-symbol synthesis

### Phase 8: Moon Phase & Astrology Engine [Not Yet Started]
- Integrate lunar API (e.g. NASA or ephemeris)
- Add moon phase to HomeView and MySanctum
- Planetary alignment engine (Sun, Moon, Mercury, etc.)
- Map user zodiac to daily planetary data
- Primed for KASPER: interpretative cosmic overlays

### Phase 9: Proximity-Based Matching Engine
- CoreLocation-based match system (opt-in)
- Match scoring based on number compatibility, chakra tone, zodiac alignment
- Nearby resonance detection
- Primed for KASPER: energetic field calculation + harmony prompts

### Phase 10: Full QA Testing Tree
- Git branch: `testing/full-suite-diagnostics`
- Run stress tests: scroll performance, memory leaks, animation stutter
- Verify onboarding → insight → social posting → cosmic celebration → analytics
- Begin unit and UI tests for KASPER-related data flow

### Phase 11: Activate K.A.S.P.E.R. Oracle Engine
- Create `KASPERPrimingPayload.swift`
- Implement orchestration layer for:
  - Daily sacred number → interpretation
  - Chakra tone + heartbeat → affirmation type
  - Astrology alignment → forecast tag
  - Focus vs Realm → resonance status
- Return:
  - Personalized daily insight
  - Meditation suggestion
  - “Spiritual weather” summary
  - Optional dream interpretation or karmic pattern feedback

---

## 🔧 Ready‑to‑Use Cursor/Coding Tags

```swift
// KASPERPrimingPayload.swift
// Struct for piping onboarding, biometric, and cosmic data into oracle engine
```

---

## 🎯 KASPER Priming Fields
- lifePathNumber
- soulUrgeNumber
- expressionNumber
- userTonePreference
- chakraState (future)
- bpm
- lunarPhase
- dominantPlanet
- realmNumber
- focusNumber
- proximityMatchScore
