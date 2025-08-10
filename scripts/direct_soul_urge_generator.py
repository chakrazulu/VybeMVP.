#!/usr/bin/env python3
"""
Direct Soul Urge Generator - High Quality Content
Generates authentic Soul Urge behavioral insights using comprehensive numerology knowledge
Based on Expression schema structure for perfect compatibility
"""

import json
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List


class DirectSoulUrgeGenerator:
    def __init__(self):
        self.base_dir = Path(__file__).parent.parent
        self.expression_schema = self.load_expression_schema()

    def load_expression_schema(self) -> Dict[str, Any]:
        """Load the validated Expression schema as template"""
        schema_path = self.base_dir / "NumerologyData" / "PERFECT_EXPRESSION_NUMBER_SCHEMA.json"
        with open(schema_path, "r", encoding="utf-8") as f:
            return json.load(f)

    def get_soul_urge_insights(self, number: int, category: str) -> List[Dict[str, Any]]:
        """Generate 12 authentic behavioral insights for a category"""

        # Soul Urge core meanings
        soul_essences = {
            1: {
                "desire": "independence and leadership",
                "need": "recognition for originality",
                "drive": "pioneer new paths",
            },
            2: {
                "desire": "harmony and cooperation",
                "need": "feeling needed in relationships",
                "drive": "create peaceful unity",
            },
            3: {
                "desire": "creative self-expression",
                "need": "artistic fulfillment and joy",
                "drive": "inspire through beauty",
            },
            4: {
                "desire": "security and order",
                "need": "stable foundations",
                "drive": "build lasting structures",
            },
            5: {
                "desire": "freedom and variety",
                "need": "unlimited exploration",
                "drive": "experience all possibilities",
            },
            6: {
                "desire": "nurturing and healing",
                "need": "caring for others",
                "drive": "create harmony through service",
            },
            7: {
                "desire": "spiritual wisdom",
                "need": "deep understanding",
                "drive": "uncover hidden truths",
            },
            8: {
                "desire": "material mastery",
                "need": "powerful achievement",
                "drive": "organize resources for impact",
            },
            9: {
                "desire": "universal service",
                "need": "humanitarian contribution",
                "drive": "serve the greater good",
            },
            11: {
                "desire": "spiritual illumination",
                "need": "inspire others with higher wisdom",
                "drive": "channel divine consciousness",
            },
            22: {
                "desire": "master building",
                "need": "transform visionary ideas into reality",
                "drive": "create large-scale positive change",
            },
            33: {
                "desire": "master healing",
                "need": "heal through unconditional love",
                "drive": "embody divine compassion",
            },
            44: {
                "desire": "spiritual organization",
                "need": "systematize divine wisdom",
                "drive": "integrate spiritual and material realms",
            },
        }

        essence = soul_essences.get(number, soul_essences[1])

        # Category-specific insight patterns
        category_insights = {
            "decisionMaking": [
                f"Makes decisions based on what fulfills the soul's need for {essence['need']}",
                f"Choices are driven by the desire for {essence['desire']}",
                f"Decision-making process honors the soul's drive to {essence['drive']}",
                "Values emotional fulfillment over purely logical outcomes",
                "Seeks alignment between choices and deepest spiritual values",
                "Decision confidence comes from soul-level resonance",
                "Struggles when forced to choose against inner desires",
                "Best decisions emerge from quiet contemplation of soul needs",
                "Regrets choices that ignore emotional authenticity",
                "Finds clarity when connecting decisions to life purpose",
                "Trusts intuitive guidance over external pressure",
                "Makes bold choices when soul desires are at stake",
            ],
            "stressResponse": [
                f"Stress emerges when the soul's desire for {essence['desire']} is blocked",
                f"Emotional pressure builds when unable to fulfill the need for {essence['need']}",
                f"Coping mechanisms center around restoring the drive to {essence['drive']}",
                "Physical tension manifests when soul needs are ignored",
                "Becomes overwhelmed when disconnected from authentic desires",
                "Finds relief through activities that honor soul cravings",
                "Stress triggers involve threats to core emotional needs",
                "Recovery requires returning to activities that fulfill the soul",
                "Chronic stress develops when living against soul nature",
                "Healing comes through acknowledging and honoring deep desires",
                "Stress management works best when aligned with soul essence",
                "Resilience builds through regular soul-nourishing practices",
            ],
            "communication": [
                f"Communication style reflects the soul's desire for {essence['desire']}",
                f"Words carry the energy of the deep need for {essence['need']}",
                f"Expression serves the soul's drive to {essence['drive']}",
                "Voice becomes authentic when speaking from soul truth",
                "Communication blocks occur when soul desires are suppressed",
                "Most compelling when sharing what the soul truly craves",
                "Listening improves when others honor their authentic desires",
                "Conflict arises when communication ignores soul needs",
                "Persuasion works through appealing to others' soul desires",
                "Written expression flows when channeling deep longings",
                "Non-verbal communication reveals soul-level authenticity",
                "Communication mastery comes through soul-centered expression",
            ],
            "relationships": [
                f"Seeks partners who understand and support the desire for {essence['desire']}",
                f"Relationship fulfillment depends on meeting the need for {essence['need']}",
                f"Attracts people who appreciate the drive to {essence['drive']}",
                "Soul-mate connection requires emotional authenticity",
                "Relationship conflicts emerge when soul needs are unmet",
                "Love deepens through sharing authentic desires and fears",
                "Partnership thrives when both honor individual soul paths",
                "Emotional intimacy builds through vulnerable soul sharing",
                "Relationship growth comes through supporting each other's deepest needs",
                "Long-term compatibility requires soul-level understanding",
                "Relationship healing happens through honoring authentic desires",
                "Partnership legacy involves mutual soul evolution",
            ],
            "productivity": [
                f"Work productivity peaks when aligned with the desire for {essence['desire']}",
                f"Professional fulfillment requires meeting the need for {essence['need']}",
                f"Career satisfaction comes through the drive to {essence['drive']}",
                "Performance suffers when work conflicts with soul desires",
                "Motivation increases when tasks honor authentic longings",
                "Workplace stress decreases when soul needs are respected",
                "Professional growth accelerates through soul-aligned goals",
                "Team collaboration improves when individual desires are acknowledged",
                "Leadership effectiveness comes from soul-centered authenticity",
                "Innovation emerges when work serves deeper soul purpose",
                "Work-life balance achieved through honoring soul rhythms",
                "Career legacy built on foundation of authentic soul expression",
            ],
            "financial": [
                f"Money serves the soul's desire for {essence['desire']}",
                f"Financial security supports the need for {essence['need']}",
                f"Abundance flows when resources enable the drive to {essence['drive']}",
                "Financial stress increases when money conflicts with soul values",
                "Spending patterns reflect deep emotional priorities",
                "Investment decisions consider soul-level fulfillment",
                "Financial planning includes resources for soul nourishment",
                "Money anxiety decreases when financial goals align with authentic desires",
                "Generosity flows naturally when soul needs are met",
                "Financial independence serves deeper soul freedom",
                "Wealth consciousness expands through soul-centered values",
                "Money mastery achieved through honoring authentic relationship with abundance",
            ],
            "creative": [
                f"Creativity expresses the soul's desire for {essence['desire']}",
                f"Artistic inspiration emerges from the need for {essence['need']}",
                f"Creative projects serve the drive to {essence['drive']}",
                "Creative blocks occur when ignoring soul's authentic voice",
                "Artistic fulfillment comes through soul-centered expression",
                "Innovation flows when creativity honors deep desires",
                "Creative collaboration thrives when soul needs are respected",
                "Artistic courage builds through trusting soul guidance",
                "Creative legacy reflects authentic soul journey",
                "Artistic healing happens through expressing deep longings",
                "Creative mastery develops through soul-aligned practice",
                "Inspiration strikes when connecting to soul's deepest truths",
            ],
            "wellness": [
                f"Physical health reflects fulfillment of the soul's desire for {essence['desire']}",
                f"Emotional wellbeing depends on meeting the need for {essence['need']}",
                f"Vitality increases when lifestyle supports the drive to {essence['drive']}",
                "Health challenges may signal soul needs being ignored",
                "Healing accelerates when treatment honors soul wisdom",
                "Wellness practices most effective when soul-aligned",
                "Mental health improves through authentic soul expression",
                "Physical symptoms often mirror emotional soul conflicts",
                "Energy levels increase when living authentically",
                "Wellness goals succeed when connected to soul purpose",
                "Health resilience builds through honoring deep desires",
                "Holistic wellness achieved through soul-body-mind integration",
            ],
            "learning": [
                f"Learning style honors the soul's desire for {essence['desire']}",
                f"Educational motivation increases when meeting the need for {essence['need']}",
                f"Knowledge acquisition serves the drive to {essence['drive']}",
                "Learning blocks occur when education conflicts with soul nature",
                "Curiosity peaks when subjects connect to deep desires",
                "Teaching ability emerges through sharing soul wisdom",
                "Student engagement increases when learning honors authentic interests",
                "Knowledge retention improves when material resonates with soul",
                "Educational growth accelerates through soul-centered inquiry",
                "Wisdom develops through integrating learning with soul experience",
                "Mentorship thrives when honoring individual soul paths",
                "Lifelong learning sustained through following soul curiosity",
            ],
            "spiritual": [
                f"Spiritual practice expresses the soul's desire for {essence['desire']}",
                f"Divine connection deepens through honoring the need for {essence['need']}",
                f"Sacred work serves the drive to {essence['drive']}",
                "Spiritual growth accelerates when practices align with soul nature",
                "Divine relationship strengthens through authentic soul expression",
                "Meditation deepens when connecting to soul's deepest truths",
                "Prayer becomes powerful when rooted in soul desires",
                "Spiritual community forms around shared soul values",
                "Sacred service flows from soul-centered compassion",
                "Divine guidance clearest when soul is authentically expressed",
                "Spiritual healing happens through soul-level forgiveness",
                "Enlightenment unfolds through complete soul authenticity",
            ],
            "transitions": [
                f"Life transitions trigger deeper connection to the desire for {essence['desire']}",
                f"Change processes honor the soul's need for {essence['need']}",
                f"Transformation serves the drive to {essence['drive']}",
                "Transition anxiety decreases when soul needs are acknowledged",
                "Change resistance dissolves when transformation aligns with soul path",
                "Adaptation succeeds through honoring authentic desires during change",
                "Growth phases accelerate when soul wisdom guides transition",
                "Change courage builds through trusting soul guidance",
                "Transition healing happens through soul-centered self-care",
                "Life phases unfold naturally when following soul compass",
                "Change mastery develops through soul-aligned flexibility",
                "Transformation completion marked by deeper soul authenticity",
            ],
            "shadow": [
                f"Shadow emerges when the desire for {essence['desire']} becomes distorted",
                f"Hidden patterns block authentic expression of the need for {essence['need']}",
                f"Shadow integration transforms the drive to {essence['drive']} into wisdom",
                "Unconscious behaviors reflect unmet soul needs seeking expression",
                "Shadow work reveals authentic desires beneath defensive patterns",
                "Integration heals split between soul desires and conscious behavior",
                "Shadow gifts emerge through embracing rejected soul aspects",
                "Healing happens when shadow behaviors are seen as misdirected soul energy",
                "Wholeness achieved through accepting all aspects of soul nature",
                "Shadow transformation turns wounds into sources of compassion",
                "Integration process honors both light and shadow soul expressions",
                "Shadow mastery creates authentic power through soul completeness",
            ],
        }

        base_insights = category_insights.get(category, category_insights["decisionMaking"])
        insights = []

        for i in range(12):
            insight_text = (
                base_insights[i]
                if i < len(base_insights)
                else base_insights[i % len(base_insights)]
            )

            insight = {"text": insight_text, "intensity": round(0.6 + (i * 0.025), 3)}

            # Add triggers/supports/challenges for first 3 insights
            if i < 3:
                insight.update(
                    {
                        "triggers": [f"When soul's desire for {essence['desire']} is threatened"],
                        "supports": [f"Honoring the need for {essence['need']}"],
                        "challenges": ["Balancing soul desires with practical demands"],
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

        # Update trinity for Soul Urge
        soul_urge_data["trinity"][
            "calculation"
        ] = "Sum the vowels of the full birth name; reduce to a single digit or master number"
        soul_urge_data["trinity"][
            "meaning"
        ] = "Represents your deepest desires, emotional needs, and what your soul truly craves"
        soul_urge_data["trinity"]["resonance"] = "emotional"

        # Update profile context
        soul_urge_data["profiles"][0]["context"] = "soulUrge"

        # Generate all behavioral categories
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
            behavioral_data[category] = self.get_soul_urge_insights(number, category)

        soul_urge_data["profiles"][0]["behavioral"] = behavioral_data

        # Update generation instructions
        soul_urge_data["generation_instructions"]["context"] = "soulUrge"
        soul_urge_data["generation_instructions"][
            "focus"
        ] = "Deep emotional desires and inner spiritual motivations"

        return soul_urge_data

    def generate_all_soul_urge_files(self):
        """Generate all Soul Urge files with high-quality content"""
        numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33, 44]
        output_dir = self.base_dir / "KASPERMLX" / "MLXTraining" / "ContentRefinery" / "Approved"

        print("🔮 DIRECT SOUL URGE GENERATOR - HIGH QUALITY")
        print("=" * 48)
        print("Generating authentic Soul Urge content")
        print(f"Output directory: {output_dir}")
        print()

        generated_files = []

        for number in numbers:
            try:
                soul_urge_data = self.create_soul_urge_file(number)

                filename = f"soulUrge_{number:02d}_v3.0_converted.json"
                filepath = output_dir / filename

                with open(filepath, "w", encoding="utf-8") as f:
                    json.dump(soul_urge_data, f, indent=2, ensure_ascii=False)

                generated_files.append(filename)
                print(f"✅ Generated: {filename} (12 categories, 144 insights)")

            except Exception as e:
                print(f"❌ Error generating Soul Urge {number}: {e}")

        print()
        print(f"🎉 Successfully generated {len(generated_files)} Soul Urge files!")
        print("✅ All files use validated Expression schema structure")
        print("🔮 High-quality content ready for KASPER MLX consumption")

        return generated_files


if __name__ == "__main__":
    generator = DirectSoulUrgeGenerator()
    generator.generate_all_soul_urge_files()
