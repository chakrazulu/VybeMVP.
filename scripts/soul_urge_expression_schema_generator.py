#!/usr/bin/env python3
"""
Soul Urge Expression Schema Generator
Generates Soul Urge files using the validated Expression Number schema structure
Based on ChatGPT feedback that Expression schema is perfect for reuse
"""

import json
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List


class SoulUrgeExpressionGenerator:
    def __init__(self):
        self.base_dir = Path(__file__).parent.parent
        self.expression_schema = self.load_expression_schema()

    def load_expression_schema(self) -> Dict[str, Any]:
        """Load the validated Expression schema as template"""
        schema_path = self.base_dir / "NumerologyData" / "PERFECT_EXPRESSION_NUMBER_SCHEMA.json"
        with open(schema_path, "r", encoding="utf-8") as f:
            return json.load(f)

    def generate_soul_urge_content(self, number: int) -> Dict[str, Any]:
        """Generate Soul Urge specific content based on Expression schema"""

        # Core Soul Urge behavioral insights by number
        soul_urge_insights = {
            1: {
                "core_drive": "Independence and leadership in spiritual expression",
                "key_desires": ["Personal freedom", "Creative innovation", "Spiritual pioneering"],
                "emotional_patterns": "Direct, passionate, pioneering spirit",
                "relationship_style": "Needs independence while seeking spiritual connection",
            },
            2: {
                "core_drive": "Harmony and cooperation in spiritual growth",
                "key_desires": ["Partnership", "Peace", "Collaborative spiritual work"],
                "emotional_patterns": "Sensitive, diplomatic, seeks balance",
                "relationship_style": "Thrives in supportive, harmonious connections",
            },
            3: {
                "core_drive": "Creative expression and joyful communication",
                "key_desires": [
                    "Artistic fulfillment",
                    "Social connection",
                    "Inspirational sharing",
                ],
                "emotional_patterns": "Optimistic, expressive, creatively driven",
                "relationship_style": "Seeks fun, inspiring, creative partnerships",
            },
            4: {
                "core_drive": "Stability and systematic spiritual building",
                "key_desires": ["Security", "Order", "Practical spiritual application"],
                "emotional_patterns": "Methodical, reliable, values consistency",
                "relationship_style": "Seeks stable, committed, long-term bonds",
            },
            5: {
                "core_drive": "Freedom and adventurous spiritual exploration",
                "key_desires": ["Variety", "Adventure", "Experiential learning"],
                "emotional_patterns": "Curious, restless, seeks new experiences",
                "relationship_style": "Values freedom and intellectual stimulation",
            },
            6: {
                "core_drive": "Nurturing and healing service to others",
                "key_desires": ["Family harmony", "Healing work", "Caring for others"],
                "emotional_patterns": "Compassionate, responsible, service-oriented",
                "relationship_style": "Devoted caregiver seeking meaningful connection",
            },
            7: {
                "core_drive": "Deep spiritual understanding and inner wisdom",
                "key_desires": ["Spiritual truth", "Inner knowledge", "Mystical connection"],
                "emotional_patterns": "Introspective, analytical, spiritually focused",
                "relationship_style": "Seeks deep, spiritual, intellectually stimulating bonds",
            },
            8: {
                "core_drive": "Material mastery for spiritual purposes",
                "key_desires": ["Achievement", "Recognition", "Spiritual leadership"],
                "emotional_patterns": "Ambitious, determined, spiritually powerful",
                "relationship_style": "Seeks respected, successful, spiritually aligned partner",
            },
            9: {
                "core_drive": "Universal service and humanitarian spiritual work",
                "key_desires": ["World service", "Compassionate action", "Universal love"],
                "emotional_patterns": "Compassionate, idealistic, globally minded",
                "relationship_style": "Seeks partner for shared humanitarian mission",
            },
            11: {
                "core_drive": "Spiritual illumination and inspirational leadership",
                "key_desires": [
                    "Spiritual teaching",
                    "Intuitive guidance",
                    "Inspirational service",
                ],
                "emotional_patterns": "Highly intuitive, spiritually sensitive, visionary",
                "relationship_style": "Seeks spiritually awakened, intuitive soul mate",
            },
            22: {
                "core_drive": "Master building for spiritual transformation",
                "key_desires": [
                    "Large-scale impact",
                    "Spiritual architecture",
                    "World transformation",
                ],
                "emotional_patterns": "Visionary builder, spiritually ambitious, globally focused",
                "relationship_style": "Seeks powerful spiritual partner for world-changing work",
            },
            33: {
                "core_drive": "Master healing and spiritual teaching",
                "key_desires": ["Healing mastery", "Spiritual education", "Compassionate service"],
                "emotional_patterns": "Master healer, deeply compassionate, spiritually evolved",
                "relationship_style": "Seeks spiritually advanced partner for healing mission",
            },
            44: {
                "core_drive": "Master organizing for spiritual manifestation",
                "key_desires": [
                    "Spiritual systems",
                    "Organized service",
                    "Material-spiritual integration",
                ],
                "emotional_patterns": "Master organizer, spiritually grounded, systematically evolved",
                "relationship_style": "Seeks spiritually practical partner for organized service",
            },
        }

        return soul_urge_insights.get(number, soul_urge_insights[1])

    def generate_behavioral_insights(self, number: int, category: str) -> List[Dict[str, Any]]:
        """Generate 12 behavioral insights for a category"""
        base_content = self.generate_soul_urge_content(number)
        insights = []

        # Category-specific insight templates
        templates = {
            "decisionMaking": [
                f"Driven by {base_content['core_drive']} when making choices",
                "Considers emotional fulfillment alongside practical outcomes",
                f"Decision style reflects {base_content['emotional_patterns']}",
                "Values alignment with soul's deepest desires",
            ],
            "communication": [
                f"Expresses {base_content['core_drive']} through words and actions",
                "Communication style reflects inner emotional needs",
                f"Seeks to share {base_content['key_desires'][0]} through expression",
                "Voice carries emotional authenticity and soul truth",
            ],
            "relationships": [
                base_content["relationship_style"],
                f"Emotional needs center around {base_content['key_desires'][0]}",
                "Seeks soul-level connection and understanding",
                "Partnership style reflects deepest spiritual desires",
            ],
            "stressResponse": [
                f"Stress emerges when {base_content['core_drive']} is blocked",
                "Emotional pressure builds when desires feel unattainable",
                f"Coping mechanisms involve {base_content['emotional_patterns']}",
                "Recovery requires alignment with soul's true needs",
            ],
            "productivity": [
                f"Most productive when work aligns with {base_content['core_drive']}",
                "Performance peaks when emotional needs are met",
                f"Work style reflects {base_content['emotional_patterns']}",
                "Career satisfaction depends on soul fulfillment",
            ],
            "financial": [
                f"Money serves {base_content['core_drive']}",
                "Financial decisions reflect emotional priorities",
                f"Abundance flows when aligned with {base_content['key_desires'][0]}",
                "Material security supports spiritual growth",
            ],
            "creative": [
                f"Creativity expresses {base_content['core_drive']}",
                "Artistic impulses arise from soul's deepest needs",
                f"Creative blocks occur when {base_content['emotional_patterns']} is suppressed",
                "Innovation serves spiritual evolution",
            ],
            "health": [
                f"Physical health reflects fulfillment of {base_content['core_drive']}",
                "Emotional well-being impacts physical vitality",
                f"Healing occurs through {base_content['emotional_patterns']}",
                "Wellness practices serve soul's deepest desires",
            ],
            "learning": [
                f"Learning style honors {base_content['core_drive']}",
                "Education serves soul's evolutionary needs",
                f"Knowledge acquisition reflects {base_content['emotional_patterns']}",
                "Wisdom emerges through experiential understanding",
            ],
            "spiritual": [
                f"Spiritual practice expresses {base_content['core_drive']}",
                "Sacred connection serves soul's deepest longings",
                f"Devotion style reflects {base_content['emotional_patterns']}",
                "Divine relationship mirrors inner emotional needs",
            ],
            "wellness": [
                f"Physical wellness reflects fulfillment of {base_content['core_drive']}",
                "Emotional well-being impacts physical vitality",
                f"Healing occurs through {base_content['emotional_patterns']}",
                "Wellness practices serve soul's deepest desires",
            ],
            "transitions": [
                f"Life transitions trigger evaluation of {base_content['core_drive']}",
                "Adaptation serves soul's evolutionary needs",
                f"Change style reflects {base_content['emotional_patterns']}",
                "Growth aligns with deepest spiritual desires",
            ],
            "shadow": [
                f"Shadow emerges when {base_content['core_drive']} becomes distorted",
                "Hidden patterns block soul's authentic expression",
                f"Shadow integration honors {base_content['emotional_patterns']}",
                "Healing transforms shadow into spiritual strength",
            ],
        }

        category_templates = templates.get(category, templates["decisionMaking"])

        for i in range(12):
            template_index = i % len(category_templates)
            insight = {
                "text": category_templates[template_index],
                "intensity": round(0.6 + (i * 0.025), 3),  # 0.6 to 0.875 range
            }

            # Add triggers/supports for key insights (match Expression schema structure exactly)
            if i < 3:
                insight.update(
                    {
                        "triggers": [f"When {base_content['key_desires'][0]} feels threatened"],
                        "supports": [f"Alignment with {base_content['core_drive']}"],
                        "challenges": ["Balancing soul needs with practical demands"],
                    }
                )

            insights.append(insight)

        return insights

    def create_soul_urge_file(self, number: int) -> Dict[str, Any]:
        """Create complete Soul Urge file using Expression schema structure"""

        # Start with Expression schema as template
        soul_urge_data = json.loads(json.dumps(self.expression_schema))

        # Update meta section for Soul Urge
        soul_urge_data["meta"].update(
            {
                "id": f"soulUrge_{number:02d}",
                "numerologyType": "soulUrge",
                "number": number,
                "title": f"Soul Urge Number {number}",
                "description": f"Deep emotional desires and inner motivations for Soul Urge {number}",
                "context": "soulUrge",
                "lastUpdated": datetime.now().isoformat(),
            }
        )

        # Update trinity calculation for Soul Urge
        soul_urge_data["trinity"][
            "calculation"
        ] = "Sum the vowels of the full birth name; reduce to a single digit or master number"
        soul_urge_data["trinity"][
            "meaning"
        ] = "Represents your deepest desires, emotional needs, and what your soul truly craves"
        soul_urge_data["trinity"]["resonance"] = "emotional"

        # Generate all 12 behavioral categories - exact match to Expression schema
        categories = [
            "decisionMaking",
            "stressResponse",
            "communication",
            "relationships",
            "productivity",
            "financial",
            "creative",
            "wellness",
            "learning",
            "spiritual",
            "transitions",
            "shadow",
        ]

        behavioral_data = {}
        for category in categories:
            behavioral_data[category] = self.generate_behavioral_insights(number, category)

        soul_urge_data["profiles"][0]["behavioral"] = behavioral_data

        # Update generation instructions for Soul Urge
        soul_urge_data["generation_instructions"]["context"] = "soulUrge"
        soul_urge_data["generation_instructions"][
            "focus"
        ] = "Deep emotional desires and inner spiritual motivations"

        return soul_urge_data

    def generate_all_soul_urge_files(self):
        """Generate all Soul Urge files using Expression schema structure"""
        numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33, 44]
        output_dir = self.base_dir / "KASPERMLX" / "MLXTraining" / "ContentRefinery" / "Approved"

        print("🔮 SOUL URGE EXPRESSION SCHEMA GENERATOR")
        print("=" * 50)
        print("Using validated Expression schema structure")
        print(f"Output directory: {output_dir}")
        print()

        generated_files = []

        for number in numbers:
            try:
                soul_urge_data = self.create_soul_urge_file(number)

                filename = f"soulUrge_{number:02d}_v2.0_converted.json"
                filepath = output_dir / filename

                with open(filepath, "w", encoding="utf-8") as f:
                    json.dump(soul_urge_data, f, indent=2, ensure_ascii=False)

                generated_files.append(filename)
                print(
                    f"✅ Generated: {filename} ({len(soul_urge_data['profiles'][0]['behavioral'])} categories)"
                )

            except Exception as e:
                print(f"❌ Error generating Soul Urge {number}: {e}")

        print()
        print(f"🎉 Successfully generated {len(generated_files)} Soul Urge files!")
        print("All files use validated Expression schema structure")
        print("Ready for KASPER MLX consumption")

        return generated_files


if __name__ == "__main__":
    generator = SoulUrgeExpressionGenerator()
    generator.generate_all_soul_urge_files()
