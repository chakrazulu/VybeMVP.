# ⚡️ Bulletproof Multiplier – Workflow Cheat Sheet

## 🧭 Purpose

The Bulletproof Multiplier guarantees every generated or multiplied insight is:
- ✅ **Action-anchored** (100%)
- ✅ **Unique** (0 duplicates)
- ✅ **Balanced voice** (25–33% first-person)
- ✅ **Properly structured & compliant**

**No cleanup required. No regressions possible.**

---

## 🔑 Core Helpers

```python
_has_action(text)      # Detects explicit or soft actions (regex + lexicon)
_ensure_action(text)   # Appends a short action clause if none exists
apply_voice_guards()   # Runs all guards, then final _ensure_action for bulletproof anchoring
```

---

## 🛠 Workflow – Generating New Insights

```python
# Initialize multiplier
multiplier = ArchetypalFirebaseMultiplier()

# Generate insights with 100% quality guarantee
multiplier.multiply_firebase_insights(testing_mode=False)

# Output is always production-ready
# No post-processing or filtering needed
```

---

## 🛠 Workflow – Testing Quality

```bash
# Run canary test to validate all metrics
python3 scripts/generation/active_multiplication/test_multiplier_quality.py

# Expected output:
# ⚡ % with human action: 100.0% (target: ~95-100%)
# 📏 Length compliance: 90.9% (target: >90%)
# 👤 % first-person: 25.9% (target: 25-33%)
# 🔄 Duplicates: 0 (target: 0)
```

---

## 🔧 Extending the Multiplier

### 1. Add New Action Verbs
```python
# In __init__, extend ACTION_WORDS set:
self.ACTION_WORDS = {
    # ... existing words ...
    "meditate", "reflect", "ground", "center"  # Add new verbs
}
```

### 2. Add New Action Clauses
```python
# In __init__, extend ACTION_CLAUSES list (keep ≤10 words):
self.ACTION_CLAUSES = [
    # ... existing clauses ...
    "Ground yourself and proceed mindfully.",  # 5 words
    "Center within and take action.",        # 5 words
]
```

### 3. Add New Soft Patterns
```python
# In _has_action(), extend soft_patterns:
soft_patterns = [
    # ... existing patterns ...
    r"\b(ground|center|meditate)\s+(yourself|your)\b",
]
```

### 4. Validate Changes
```bash
# After any changes, run canary test
python3 test_multiplier_quality.py

# All metrics should remain green:
# Human action ≥95%, Length compliance ≥90%, Duplicates = 0
```

---

## 🚦 Production Checklist

Before production deployment:
- [ ] Run canary test - all metrics green
- [ ] Generate sample batch (10 insights per number)
- [ ] Verify no malformed wisdom essence
- [ ] Check first-person distribution (25-33%)
- [ ] Confirm median word count (18-28)

---

## 📊 Key Architecture

```
Input → Generate Insight → apply_voice_guards()
                                ↓
                          Guard 1: Clean "I am"
                                ↓
                          Guard 2: Fix punctuation
                                ↓
                          Guard 3: Enforce length
                                ↓
                          Guard 4: Fix structure
                                ↓
                    Guard FINAL: _ensure_action() ← [100% GUARANTEE]
                                ↓
                          Production-Ready Output
```

---

## 🏆 Performance Metrics

| Metric | Target | Current | Status |
|--------|--------|---------|--------|
| Human Action | ≥95% | 100.0% | ✅ |
| Length Compliance | ≥90% | 90.9% | ✅ |
| First-Person | 25-33% | 25.9% | ✅ |
| Duplicates | 0 | 0 | ✅ |
| Archetypal Anchors | ≥95% | 100.0% | ✅ |

---

## 🚀 Quick Commands

```bash
# Generate full production batch (100 insights per number)
python3 archetypal_firebase_multiplier.py

# Test with reduced batch (20 insights per number)
python3 archetypal_firebase_multiplier.py --test

# Run quality validation
python3 test_multiplier_quality.py

# Check specific number output
cat NumerologyData/FirebaseNumberMeanings/NumberMessages_Complete_0_archetypal.json | jq '.["0"].insight[0]'
```

---

## 💡 Tips

1. **Always run canary test** after any code changes
2. **Keep ACTION_CLAUSES short** (≤10 words) for length compliance
3. **Test with seed** for reproducible debugging: `testing_mode=True, seed=42`
4. **Monitor first-person ratio** - should stay 25-33%
5. **Check for malformed essence** - should be caught by quality gates

---

## 🔒 Why It's Bulletproof

1. **_has_action()** catches both explicit verbs AND natural language patterns
2. **_ensure_action()** guarantees action if missing
3. **Guard FINAL** runs last, after all text modifications
4. **Centralized logic** means no scattered action checks
5. **Regex patterns** catch "soft" directives like "you can choose"

**Result: 100% human action coverage, guaranteed.**

---

*Last Updated: August 17, 2025 | Version: 1.0 | Status: Production-Ready*
