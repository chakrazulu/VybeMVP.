#!/usr/bin/env python3
"""
Enhanced Quality-First Multiplication System v2.0
Generates sophisticated A+ quality insights based on transformation patterns
Target: 300 excellent insights with archetypal authenticity
"""

import random
import re
from typing import Any, Dict, List


class EnhancedQualityMultiplier:
    """Advanced quality multiplication with archetypal voice authenticity"""

    def __init__(self):
        self.transformation_patterns = self._load_transformation_patterns()
        self.archetypal_systems = self._load_archetypal_systems()
        self.quality_frameworks = self._load_quality_frameworks()

    def _load_transformation_patterns(self) -> Dict[str, List[str]]:
        """Load patterns discovered during A+ transformation"""
        return {
            "metaphorical_bridges": [
                "Like {metaphor}, {core_truth} emerges from {context}.",
                "In the sacred space where {element1} meets {element2}, {wisdom} awakens.",
                "Your {archetype} essence recognizes that {deep_insight}.",
                "Through the {perspective} of {archetypal_lens}, {revelation} unfolds.",
                "When {cosmic_force} moves through your {human_aspect}, {transformation} begins.",
            ],
            "wisdom_integrations": [
                "This is the invitation to {action} from {state_of_being}.",
                "The path reveals itself: {journey} through {inner_landscape}.",
                "What appears as {surface_challenge} is actually {deeper_gift}.",
                "Your {soul_quality} knows that {truth_statement}.",
                "Beyond {illusion} lies the reality of {authentic_self}.",
            ],
            "embodied_guidance": [
                "Trust the {inner_knowing} that guides you toward {outcome}.",
                "Let {energy_quality} be the {guidance_type} for {life_area}.",
                "Your {gift} is meant to {purpose} in the world.",
                "This moment calls for {response} rooted in {foundation}.",
                "Honor the {wisdom_source} that {action_type} brings forth.",
            ],
        }

    def _load_archetypal_systems(self) -> Dict[str, Dict[str, Any]]:
        """Load authentic archetypal voice systems"""
        return {
            # Numbers
            "8": {
                "archetype": "Master Builder",
                "essence": "sovereign authority grounded in sacred purpose",
                "voice_qualities": ["commanding", "structured", "ethical", "legacy-focused"],
                "signature_concepts": ["foundation", "manifestation", "integrity", "stewardship"],
                "metaphor_family": [
                    "architect and blueprint",
                    "mountain and valley",
                    "forge and refined gold",
                ],
                "wisdom_domain": "material mastery through spiritual alignment",
                "speech_patterns": [
                    "builds upon",
                    "establishes",
                    "creates lasting",
                    "foundations of",
                ],
            },
            # Zodiac
            "aries": {
                "archetype": "Sacred Warrior",
                "essence": "pure initiation and fearless emergence",
                "voice_qualities": ["direct", "pioneering", "energetic", "breakthrough-oriented"],
                "signature_concepts": ["ignition", "pioneering", "courage", "fresh starts"],
                "metaphor_family": ["first flame", "arrow meeting target", "dawn breaking"],
                "wisdom_domain": "action through authentic impulse",
                "speech_patterns": ["ignites", "breaks through", "pioneers", "initiates"],
            },
            "scorpio": {
                "archetype": "Sacred Alchemist",
                "essence": "transformation through depth and truth",
                "voice_qualities": ["intense", "penetrating", "transformative", "truth-seeking"],
                "signature_concepts": ["depth", "regeneration", "mystery", "power"],
                "metaphor_family": ["phoenix and flame", "deep well", "surgeon's precision"],
                "wisdom_domain": "power through emotional mastery",
                "speech_patterns": ["transforms", "penetrates", "reveals", "regenerates"],
            },
            # Planets
            "mars": {
                "archetype": "Divine Protector",
                "essence": "sacred strength in service of what matters",
                "voice_qualities": [
                    "protective",
                    "decisive",
                    "strength-oriented",
                    "boundary-clear",
                ],
                "signature_concepts": ["defense", "action", "boundaries", "strength"],
                "metaphor_family": [
                    "shield and sword",
                    "guardian at the gate",
                    "fire meeting purpose",
                ],
                "wisdom_domain": "power through aligned action",
                "speech_patterns": ["defends", "strengthens", "acts upon", "protects"],
            },
            "venus": {
                "archetype": "Heart Magnet",
                "essence": "love as the organizing principle of reality",
                "voice_qualities": [
                    "harmonious",
                    "magnetic",
                    "beauty-creating",
                    "connection-focused",
                ],
                "signature_concepts": ["attraction", "harmony", "beauty", "connection"],
                "metaphor_family": ["honey drawing bees", "garden in bloom", "magnetic field"],
                "wisdom_domain": "creation through love and beauty",
                "speech_patterns": ["magnetizes", "harmonizes", "creates beauty", "connects"],
            },
        }

    def _load_quality_frameworks(self) -> Dict[str, Any]:
        """Load A+ quality assessment frameworks"""
        return {
            "semantic_depth_levels": {
                "surface": ["you have", "you are", "you feel"],
                "personal": ["your heart", "your essence", "your truth"],
                "archetypal": ["your warrior", "your sage", "your creator"],
                "cosmic": ["the universe through you", "divine essence", "sacred purpose"],
            },
            "wisdom_sophistication": {
                "advice": "You should do X",
                "insight": "You recognize that X",
                "revelation": "X reveals itself through your Y",
                "integration": "As X and Y unite within you, Z awakens",
            },
            "quality_markers": {
                "A+": {
                    "metaphor_freshness": 0.8,
                    "archetypal_authenticity": 0.9,
                    "wisdom_depth": 0.85,
                    "practical_integration": 0.8,
                }
            },
        }

    def generate_archetypal_variation(
        self, base_insight: str, archetype_key: str, variation_type: str = "wisdom_integration"
    ) -> str:
        """Generate archetypal variation with voice authenticity"""

        # Get archetypal system
        archetype_data = self.archetypal_systems.get(archetype_key)
        if not archetype_data:
            return self._generate_generic_quality(base_insight)

        # Extract semantic core
        semantic_core = self._extract_deep_semantics(base_insight, archetype_data)

        # Select appropriate transformation pattern
        pattern_family = self.transformation_patterns.get(
            variation_type, self.transformation_patterns["wisdom_integrations"]
        )
        selected_pattern = random.choice(pattern_family)

        # Generate with archetypal voice
        variation = self._apply_archetypal_voice(selected_pattern, semantic_core, archetype_data)

        # Quality validation
        if self._meets_quality_standards(variation, archetype_data):
            return variation
        else:
            return self._refine_to_quality(variation, semantic_core, archetype_data)

    def _extract_deep_semantics(
        self, insight: str, archetype_data: Dict[str, Any]
    ) -> Dict[str, str]:
        """Extract deep semantic meaning aligned with archetype"""

        # Core semantic extraction
        core = {
            "essential_truth": "",
            "transformational_element": "",
            "wisdom_type": "",
            "action_domain": "",
            "archetypal_resonance": "",
        }

        insight_lower = insight.lower()
        signature_concepts = archetype_data.get("signature_concepts", [])

        # Match to archetypal signature concepts
        for concept in signature_concepts:
            if concept in insight_lower:
                core["archetypal_resonance"] = concept
                break

        # Extract essential truth (remove fluff words)
        # Find the core statement
        sentences = insight.split(".")
        main_sentence = sentences[0] if sentences else insight

        # Remove common prefixes
        clean_truth = re.sub(r"^(this|you|your|the)\s+", "", main_sentence.lower().strip())
        core["essential_truth"] = clean_truth

        # Determine transformation element
        transformation_words = [
            "change",
            "shift",
            "transform",
            "evolve",
            "become",
            "awaken",
            "emerge",
        ]
        if any(word in insight_lower for word in transformation_words):
            core["transformational_element"] = "awakening"
        else:
            core["transformational_element"] = "recognition"

        # Wisdom classification
        if any(word in insight_lower for word in ["power", "strength", "authority"]):
            core["wisdom_type"] = "empowerment"
        elif any(word in insight_lower for word in ["love", "heart", "connection"]):
            core["wisdom_type"] = "connection"
        elif any(word in insight_lower for word in ["truth", "clarity", "understanding"]):
            core["wisdom_type"] = "illumination"
        else:
            core["wisdom_type"] = "integration"

        return core

    def _apply_archetypal_voice(
        self, pattern: str, semantic_core: Dict[str, str], archetype_data: Dict[str, Any]
    ) -> str:
        """Apply authentic archetypal voice to pattern"""

        # Voice-specific elements
        archetype = archetype_data["archetype"]
        essence = archetype_data["essence"]
        concepts = archetype_data["signature_concepts"]
        metaphors = archetype_data["metaphor_family"]
        speech_patterns = archetype_data["speech_patterns"]

        # Smart substitutions based on semantic core
        substitutions = {
            # Core archetypal elements
            "archetype": archetype.lower(),
            "archetypal_lens": archetype.lower() + " wisdom",
            "essence": essence,
            # Semantic-aware substitutions
            "core_truth": semantic_core["essential_truth"],
            "deep_insight": semantic_core["essential_truth"],
            "truth_statement": semantic_core["essential_truth"],
            "wisdom": semantic_core["wisdom_type"] + " wisdom",
            # Voice-specific elements
            "metaphor": random.choice(metaphors),
            "cosmic_force": random.choice(concepts),
            "soul_quality": archetype.lower() + " essence",
            "inner_knowing": archetype.lower() + " intuition",
            "energy_quality": random.choice(concepts),
            # Context elements
            "context": "your current journey",
            "perspective": archetype.lower() + " perspective",
            "foundation": random.choice(concepts),
            "action_type": random.choice(speech_patterns),
            # Integration elements
            "element1": random.choice(concepts),
            "element2": semantic_core.get("archetypal_resonance", "awareness"),
            "transformation": semantic_core["transformational_element"],
            "revelation": semantic_core["wisdom_type"] + " clarity",
        }

        # Apply substitutions
        result = pattern
        for key, value in substitutions.items():
            placeholder = "{" + key + "}"
            if placeholder in result:
                result = result.replace(placeholder, value)

        # Clean up any remaining placeholders
        result = re.sub(r"\{[^}]+\}", "truth", result)

        # Ensure proper capitalization
        result = result[0].upper() + result[1:] if result else result

        return result

    def _meets_quality_standards(self, variation: str, archetype_data: Dict[str, Any]) -> bool:
        """Check if variation meets A+ quality standards"""

        # Length check (meaningful but not verbose)
        if len(variation) < 60 or len(variation) > 180:
            return False

        # Archetypal authenticity (voice consistency)
        signature_concepts = archetype_data.get("signature_concepts", [])
        voice_qualities = archetype_data.get("voice_qualities", [])

        # Must contain at least one signature concept
        if not any(concept in variation.lower() for concept in signature_concepts):
            return False

        # Quality markers
        quality_issues = [
            "{" in variation,  # Template visibility
            "}" in variation,  # Template visibility
            "the this" in variation.lower(),  # Grammar artifacts
            variation.count(" and ") > 2,  # Over-complexity
            len(variation.split()) < 10,  # Too simple
        ]

        if any(quality_issues):
            return False

        return True

    def _refine_to_quality(
        self, variation: str, semantic_core: Dict[str, str], archetype_data: Dict[str, Any]
    ) -> str:
        """Refine variation to meet quality standards"""

        archetype = archetype_data["archetype"]
        essence = archetype_data["essence"]
        primary_concept = archetype_data["signature_concepts"][0]

        # Simple, proven quality pattern
        return f"Your {archetype.lower()} nature reveals that {semantic_core['essential_truth']}, and this {primary_concept} becomes a sacred compass for your journey."

    def _generate_generic_quality(self, base_insight: str) -> str:
        """Fallback for unknown archetypes"""
        clean_insight = base_insight.split(".")[0].lower()
        return f"Your essence recognizes that {clean_insight}, and this wisdom guides your path forward."

    def multiply_content_with_quality(
        self,
        base_insights: List[Dict[str, Any]],
        archetype_key: str,
        target_count: int = 300,
        variation_types: List[str] = None,
    ) -> List[Dict[str, Any]]:
        """Quality-focused content multiplication"""

        if variation_types is None:
            variation_types = ["metaphorical_bridges", "wisdom_integrations", "embodied_guidance"]

        quality_insights = []
        generated_texts = set()

        # Calculate distribution
        insights_per_base = max(1, target_count // len(base_insights))
        variations_per_insight = len(variation_types)

        for base_insight in base_insights:
            base_text = base_insight.get("insight", "")

            for i in range(insights_per_base):
                if len(quality_insights) >= target_count:
                    break

                # Cycle through variation types for diversity
                variation_type = variation_types[i % variations_per_insight]

                # Generate archetypal variation
                variation_text = self.generate_archetypal_variation(
                    base_text, archetype_key, variation_type
                )

                # Ensure uniqueness
                if variation_text not in generated_texts and variation_text != base_text:
                    quality_variation = base_insight.copy()
                    quality_variation["insight"] = variation_text
                    quality_variation["quality_tier"] = "A+"
                    quality_variation["archetypal_voice"] = archetype_key
                    quality_variation["variation_type"] = variation_type
                    quality_variation["generation_method"] = "enhanced_quality_v2"

                    quality_insights.append(quality_variation)
                    generated_texts.add(variation_text)

        return quality_insights[:target_count]


def main():
    """Test the enhanced quality multiplication system"""

    # Test data from actual NumberMessages_Complete_8.json
    test_insights = [
        {"insight": "Eight is the vibration of power, purpose, and aligned manifestation."},
        {"insight": "You are being asked to walk in your power without apology."},
        {"insight": "Power is not dominance—it is self-responsibility on display."},
    ]

    multiplier = EnhancedQualityMultiplier()

    print("🔧 ENHANCED QUALITY MULTIPLICATION TEST")
    print("=" * 50)

    # Test with number 8 archetype
    quality_results = multiplier.multiply_content_with_quality(
        test_insights, archetype_key="8", target_count=9  # 3 per base insight
    )

    print(f"\n📊 Generated {len(quality_results)} A+ quality variations:")
    print("-" * 50)

    for i, insight in enumerate(quality_results, 1):
        print(f"{i}. [{insight['variation_type']}] {insight['insight']}")
        print()

    print("✅ Enhanced quality multiplication system ready!")

    # Test with different archetype
    print("\n🔥 Testing with Aries archetype:")
    print("-" * 30)

    aries_results = multiplier.multiply_content_with_quality(
        [{"insight": "Aries energy ignites the courage to begin again."}],
        archetype_key="aries",
        target_count=3,
    )

    for i, insight in enumerate(aries_results, 1):
        print(f"{i}. {insight['insight']}")


if __name__ == "__main__":
    main()
