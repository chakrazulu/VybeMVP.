#!/usr/bin/env python3
"""
Soul Urge Schema Fixer - Align with Expression Schema Structure
Updates Soul Urge files to match the validated Expression Number schema format
"""

import json
from pathlib import Path
from typing import Dict, List, Any

class SoulUrgeSchemaFixer:
    def __init__(self):
        self.approved_dir = Path("/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/KASPERMLX/MLXTraining/ContentRefinery/Approved")
        
        # Soul Urge context descriptions  
        self.soul_urge_contexts = {
            1: "Inner drive for independence and leadership",
            2: "Deep desire for partnership and cooperation",
            3: "Soul craving for creative expression and joy", 
            4: "Inner need for security and systematic building",
            5: "Soul yearning for freedom and adventure",
            6: "Deep desire to nurture and serve others",
            7: "Inner seeking for truth and spiritual understanding",
            8: "Soul drive for material mastery and recognition", 
            9: "Deep desire to heal and serve humanity",
            11: "Soul mission of spiritual inspiration and illumination",
            22: "Inner drive to build lasting foundations for others",
            33: "Soul calling to teach and heal through compassion",
            44: "Deep desire to create systems that serve generations"
        }

    def convert_to_expression_schema(self, old_data: Dict, number: int) -> Dict[str, Any]:
        """Convert old Soul Urge format to Expression schema structure"""
        
        # Create the new schema structure
        new_data = {
            "meta": {
                "version": "v2.0",
                "sourceNotes": "Divine Triangle tradition + Pythagorean numerology; Soul Urge behavioral patterns",
                "generationGuidelines": "Focus on what the person deeply desires internally, their core motivations, and spiritual driving forces"
            },
            "profiles": [
                {
                    "number": number,
                    "context": "soulUrge",
                    "coreEssence": old_data.get("core_essence", f"Soul Urge {number} essence"),
                    "lifeLesson": old_data.get("life_lesson", f"Soul Urge {number} lesson"), 
                    "shadowSignature": old_data.get("shadow_signature", f"Soul Urge {number} shadow"),
                    "planes": {
                        "physical": {"strength": 6, "notes": f"Physical manifestation of Soul Urge {number} desires"},
                        "mental": {"strength": 7, "notes": f"Mental processing of Soul Urge {number} motivations"},
                        "emotional": {"strength": 8, "notes": f"Emotional expression of Soul Urge {number} longings"},
                        "intuitive": {"strength": 7, "notes": f"Intuitive connection to Soul Urge {number} inner truth"}
                    },
                    "chartOfInclusion": {
                        "counts": {},
                        "missingNumbers": []
                    },
                    "cycles": [
                        {
                            "label": "First Cycle", 
                            "startAge": None,
                            "endAge": None,
                            "themes": [f"Soul Urge {number} awakening", "Inner desire recognition", "Motivation clarity"],
                            "practices": [f"Daily reflection on Soul Urge {number} desires", "Meditation on core motivations", "Journal inner longings"]
                        },
                        {
                            "label": "Second Cycle",
                            "startAge": None, 
                            "endAge": None,
                            "themes": [f"Soul Urge {number} manifestation", "Desire integration", "Spiritual alignment"],
                            "practices": [f"Express Soul Urge {number} through action", "Align choices with deep desires", "Integrate soul wisdom"]
                        },
                        {
                            "label": "Third Cycle",
                            "startAge": None,
                            "endAge": None, 
                            "themes": [f"Soul Urge {number} mastery", "Desire fulfillment", "Spiritual service"],
                            "practices": [f"Master Soul Urge {number} expression", "Serve others through soul gifts", "Teach soul wisdom"]
                        }
                    ],
                    "pinnacles": [
                        {"label": "Pinnacle I", "startAge": None, "endAge": None, "themes": [f"Soul Urge {number} emergence"], "practices": [f"Develop Soul Urge {number} awareness"]},
                        {"label": "Pinnacle II", "startAge": None, "endAge": None, "themes": [f"Soul Urge {number} growth"], "practices": [f"Strengthen Soul Urge {number} expression"]},
                        {"label": "Pinnacle III", "startAge": None, "endAge": None, "themes": [f"Soul Urge {number} integration"], "practices": [f"Integrate Soul Urge {number} wisdom"]},
                        {"label": "Pinnacle IV", "startAge": None, "endAge": None, "themes": [f"Soul Urge {number} mastery"], "practices": [f"Master Soul Urge {number} gifts"]}
                    ],
                    "challenges": [
                        {"label": "Challenge I", "startAge": None, "endAge": None, "themes": [f"Soul Urge {number} resistance"], "practices": [f"Accept Soul Urge {number} desires"]},
                        {"label": "Challenge II", "startAge": None, "endAge": None, "themes": [f"Soul Urge {number} distortion"], "practices": [f"Purify Soul Urge {number} expression"]}, 
                        {"label": "Challenge III", "startAge": None, "endAge": None, "themes": [f"Soul Urge {number} imbalance"], "practices": [f"Balance Soul Urge {number} needs"]},
                        {"label": "Challenge IV", "startAge": None, "endAge": None, "themes": [f"Soul Urge {number} shadow"], "practices": [f"Transform Soul Urge {number} shadow"]}
                    ],
                    "astroLinks": {
                        "tarotKeys": [f"Soul Urge {number} Tarot Connection"],
                        "planetaryCorrespondences": [f"Soul Urge {number} Planet"]
                    },
                    "behavioral": {}
                }
            ],
            "trinity": {
                "integration_notes": "Soul Urge represents WHAT you deeply desire internally vs Life Path (WHO you are becoming) and Expression (HOW you manifest)",
                "calculation": "Sum of vowels in full birth name, reduced to single digit or master number", 
                "relationship_to_life_path": "Soul Urge provides the inner motivation for Life Path journey",
                "relationship_to_expression": "Soul Urge fuels the desires that drive external Expression"
            }
        }
        
        # Convert behavioral insights to proper categories
        if "behavioral_insights" in old_data:
            # Group by category and ensure 12 categories
            categories = ["decisionMaking", "stressResponse", "communication", "relationships",
                         "productivity", "financial", "creative", "learning", "wellness", 
                         "spiritual", "shadow", "transitions"]
            
            behavioral = {}
            for category in categories:
                behavioral[category] = []
            
            # Distribute insights across categories
            insights = old_data["behavioral_insights"]
            for i, insight in enumerate(insights):
                category = categories[i % len(categories)]
                
                converted_insight = {
                    "text": insight["text"],
                    "intensity": insight.get("intensity", 0.75)
                }
                
                # Add optional fields if present
                for field in ["triggers", "supports", "challenges"]:
                    if field in insight:
                        converted_insight[field] = insight[field]
                
                behavioral[category].append(converted_insight)
            
            new_data["profiles"][0]["behavioral"] = behavioral
        
        return new_data

    def fix_all_files(self):
        """Fix all Soul Urge files to match Expression schema"""
        print("🔧 SOUL URGE SCHEMA FIXER - Expression Format Alignment")
        print("=" * 60)
        
        soul_urge_files = list(self.approved_dir.glob("soulUrge_*_v2.0_converted.json"))
        
        if not soul_urge_files:
            print("❌ No Soul Urge files found")
            return
            
        print(f"Found {len(soul_urge_files)} Soul Urge files to fix")
        
        successful = 0
        
        for file in sorted(soul_urge_files):
            try:
                # Extract number from filename
                import re
                match = re.search(r'soulUrge_(\d+)_v2.0_converted.json', file.name)
                if not match:
                    continue
                    
                number = int(match.group(1))
                print(f"Fixing Soul Urge {number}...")
                
                # Load old format
                with open(file, 'r', encoding='utf-8') as f:
                    old_data = json.load(f)
                
                # Convert to new schema
                new_data = self.convert_to_expression_schema(old_data, number)
                
                # Write back
                with open(file, 'w', encoding='utf-8') as f:
                    json.dump(new_data, f, indent=2, ensure_ascii=False)
                
                insight_count = len(old_data.get("behavioral_insights", []))
                print(f"✅ Fixed Soul Urge {number} - {insight_count} insights redistributed")
                
                successful += 1
                
            except Exception as e:
                print(f"❌ Error fixing {file.name}: {e}")
                continue
        
        print("\n" + "=" * 60) 
        print(f"🎯 SCHEMA FIX COMPLETE")
        print(f"✅ Fixed: {successful} files")
        print("🔮 Soul Urge files now match Expression schema structure!")
        print("📝 Ready for ChatGPT validation!")

def main():
    fixer = SoulUrgeSchemaFixer()
    fixer.fix_all_files()

if __name__ == "__main__":
    main()