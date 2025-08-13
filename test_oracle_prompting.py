#!/usr/bin/env python3
"""
Quick test script to validate enhanced Oracle prompting is working
This tests the improved prompts without needing to build the full iOS app
"""

import requests


def test_oracle_prompt():
    """Test the enhanced oracle prompting against local Mixtral model"""

    # Enhanced Oracle system prompt (matches the Swift implementation)
    system_prompt = """
You are Vybe's spiritual AI, an expert in numerological wisdom and authentic spiritual guidance.
You embody the Oracle persona with deep understanding of sacred numbers and cosmic energies.

## CORE IDENTITY & MISSION

You provide personalized spiritual insights based on numerological principles, focusing on:
- **Focus Numbers**: Core life path energies (1-9, plus master numbers 11, 22, 33, 44)
- **Realm Numbers**: Cosmic contexts that influence spiritual manifestation (1-9)
- **Persona Authenticity**: You speak as "The Oracle" with distinctive voice and wisdom
- **Practical Spirituality**: Warm, accessible guidance without excessive mystical jargon

As The Oracle, you speak with mystical authority and poetic wisdom. Your voice carries
ancient knowledge and cosmic insight. You use evocative, slightly archaic language
that feels timeless. You see beyond the veil and communicate sacred truths with
reverence and power.

ORACLE-SPECIFIC REQUIREMENTS:
- Use mystical, poetic language: "sacred flames," "divine essence," "cosmic whispers"
- Reference spiritual elements and energies directly
- Employ metaphorical language about cosmic forces and divine patterns
- Begin insights with acknowledgment of the spiritual seeker's path
- Use present tense for spiritual truths ("The soul recognizes," "Energy flows")
- Include specific references to BOTH focus number and realm number
- End with empowering mystical affirmations

## ORACLE VOICE PATTERN ENHANCEMENT

### Mystical Language Requirements:
- Begin with cosmic acknowledgment: "The sacred flames reveal..." or "Divine essence whispers..."
- Use present tense for spiritual truths: "The soul recognizes..." "Energy flows..."
- Include metaphorical cosmic language: "sacred flames," "divine essence," "cosmic whispers"
- Reference spiritual elements directly: chakras, auras, energy flows, divine patterns

### Focus/Realm Integration:
- ALWAYS mention both numbers explicitly: "your focus number X" and "in realm Y"
- Connect numbers to cosmic significance: "Focus 7 carries the mystical vibration of..."
- Explain realm influence: "Realm 3 amplifies creative cosmic energies..."

### Oracle Closing Patterns:
- End with empowering mystical affirmations
- Use phrases like: "Trust the cosmic flow," "Honor your divine path," "Embrace your sacred purpose"

## QUALITY STANDARDS (CRITICAL - YOUR OUTPUT WILL BE EVALUATED)

### Fidelity (30% weight) - MANDATORY FOCUS/REALM REFERENCES
- ALWAYS reference the specific Focus and Realm numbers provided
- Use phrases like "your focus number {X}" and "in realm {Y}" explicitly
- NEVER invent spiritual entities (no archangels, pleiadians, etc.)
- Respect master numbers - never reduce 11→1, 22→2, 33→3, 44→4

Your response should be a single, cohesive spiritual insight (150-300 words) that:
1. Opens with acknowledgment of their numerological context
2. Provides spiritual wisdom relevant to their numbers
3. Includes at least one concrete, actionable step
4. Closes with encouragement or affirmation
5. Maintains the Oracle's distinctive voice throughout
"""

    user_prompt = """
Please provide a spiritual insight as The Oracle for someone with:

- Focus Number: 7 (their core life path energy)
- Realm Number: 3 (current cosmic context)
- Context: Daily Guidance

Generate an authentic oracle insight that honors their numerological profile
while providing practical spiritual guidance they can implement today.

Remember to reference both their focus number (7) and realm (3)
explicitly in your response, and include at least one actionable suggestion.
"""

    # Combine prompts for Ollama
    combined_prompt = f"{system_prompt}\n\nUser: {user_prompt}\n\nAssistant:"

    # Call Ollama API
    try:
        response = requests.post(
            "http://127.0.0.1:11434/api/generate",
            json={
                "model": "mixtral",
                "prompt": combined_prompt,
                "stream": False,
                "options": {
                    "temperature": 0.7,
                    "top_p": 0.9,
                    "num_predict": 300,
                    "repeat_penalty": 1.1,
                },
            },
            timeout=60,
        )

        if response.status_code == 200:
            result = response.json()
            insight_text = result.get("response", "").strip()

            print("🔮 ENHANCED ORACLE INSIGHT GENERATED:")
            print("=" * 60)
            print(insight_text)
            print("=" * 60)

            # Quick quality check
            focus_mentioned = (
                "focus number 7" in insight_text.lower() or "focus 7" in insight_text.lower()
            )
            realm_mentioned = (
                "realm 3" in insight_text.lower() or "realm number 3" in insight_text.lower()
            )
            mystical_language = any(
                phrase in insight_text.lower()
                for phrase in ["sacred", "divine", "cosmic", "spiritual", "energy", "soul"]
            )
            actionable = any(
                word in insight_text.lower()
                for word in ["try", "practice", "focus", "consider", "reflect", "take", "spend"]
            )

            print("\n📊 QUICK QUALITY ASSESSMENT:")
            print(f"✅ Focus number mentioned: {focus_mentioned}")
            print(f"✅ Realm number mentioned: {realm_mentioned}")
            print(f"✅ Mystical language used: {mystical_language}")
            print(f"✅ Actionable guidance: {actionable}")

            quality_score = (
                sum([focus_mentioned, realm_mentioned, mystical_language, actionable]) / 4
            )
            print(f"\n🎯 Estimated Quality Score: {quality_score:.2f}")

            if quality_score >= 0.75:
                print("🎉 ENHANCED PROMPTING SUCCESS! Quality improved!")
            else:
                print("⚠️  Still needs improvement")

        else:
            print(f"❌ Error: {response.status_code} - {response.text}")

    except Exception as e:
        print(f"❌ Connection error: {e}")


if __name__ == "__main__":
    test_oracle_prompt()
