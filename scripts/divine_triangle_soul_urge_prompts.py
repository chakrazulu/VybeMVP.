#!/usr/bin/env python3
"""
Divine Triangle Soul Urge Prompts Generator
Creates individual prompts for each Soul Urge number based on "Numerology and The Divine Triangle"
For manual generation with Claude Opus to ensure highest quality
"""

import json
from pathlib import Path
from typing import Dict, Any

class DivineTriangleSoulUrgePrompts:
    def __init__(self):
        self.base_dir = Path(__file__).parent.parent
        
    def get_divine_triangle_essence(self, number: int) -> Dict[str, str]:
        """Get Soul Urge essence based on Divine Triangle book teachings"""
        
        divine_triangle_essences = {
            1: {
                "core_desire": "Independence and individual achievement",
                "emotional_need": "Recognition as a unique, pioneering individual", 
                "soul_craving": "To be first, to lead, to create something original",
                "divine_triangle_quote": "The soul desires to be independent and self-reliant, seeking personal achievement and recognition for original contributions",
                "shadow_desire": "Domination and ego-driven control over others",
                "keywords": "independence, leadership, originality, pioneering, self-reliance, individuality"
            },
            2: {
                "core_desire": "Harmony, partnership, and peaceful cooperation",
                "emotional_need": "To feel needed and appreciated in relationships",
                "soul_craving": "Unity, balance, and collaborative achievement", 
                "divine_triangle_quote": "The soul craves partnership and cooperation, finding fulfillment through helping others and creating harmony",
                "shadow_desire": "Codependency and loss of individual identity in relationships",
                "keywords": "harmony, cooperation, partnership, diplomacy, sensitivity, support"
            },
            3: {
                "core_desire": "Creative self-expression and joyful communication",
                "emotional_need": "Artistic fulfillment and social appreciation",
                "soul_craving": "To inspire others through beauty, creativity, and optimistic expression",
                "divine_triangle_quote": "The soul desires creative expression and seeks to bring joy and inspiration to the world through artistic gifts",
                "shadow_desire": "Superficial attention-seeking and scattered creative energy",
                "keywords": "creativity, joy, artistic expression, communication, inspiration, optimism"
            },
            4: {
                "core_desire": "Security, order, and systematic achievement",
                "emotional_need": "Stability and recognition for reliable service",
                "soul_craving": "To build something lasting and practically valuable",
                "divine_triangle_quote": "The soul craves security and order, finding fulfillment in practical service and building lasting foundations",
                "shadow_desire": "Rigid control and fear-based resistance to change",
                "keywords": "stability, order, practicality, building, reliability, systematic approach"
            },
            5: {
                "core_desire": "Freedom, variety, and adventurous experience",
                "emotional_need": "Mental stimulation and personal liberty",
                "soul_craving": "To experience all of life's possibilities without restriction",
                "divine_triangle_quote": "The soul desires freedom and variety, craving new experiences and the liberty to explore life's endless possibilities",
                "shadow_desire": "Irresponsible escapism and inability to commit",
                "keywords": "freedom, adventure, variety, curiosity, flexibility, progressive thinking"
            },
            6: {
                "core_desire": "Nurturing service and healing responsibility",
                "emotional_need": "To feel needed as a caregiver and healer",
                "soul_craving": "To create harmony in home and community through loving service",
                "divine_triangle_quote": "The soul craves opportunities to nurture and heal, finding fulfillment in creating harmony for family and community",
                "shadow_desire": "Martyrdom and controlling others through guilt",
                "keywords": "nurturing, healing, service, responsibility, family, community care"
            },
            7: {
                "core_desire": "Spiritual understanding and inner wisdom",
                "emotional_need": "Solitude for deep contemplation and mystical connection",
                "soul_craving": "To uncover hidden truths and achieve spiritual enlightenment",
                "divine_triangle_quote": "The soul desires wisdom and spiritual understanding, craving solitude to explore life's deeper mysteries",
                "shadow_desire": "Spiritual superiority and isolation from human connection",
                "keywords": "spirituality, wisdom, contemplation, mysticism, analysis, inner knowledge"
            },
            8: {
                "core_desire": "Material mastery and powerful achievement",
                "emotional_need": "Recognition for executive ability and material success",
                "soul_craving": "To organize and direct resources for significant worldly impact",
                "divine_triangle_quote": "The soul craves material mastery and seeks to achieve power through organizing resources and directing others",
                "shadow_desire": "Ruthless materialism and abuse of power",
                "keywords": "power, achievement, material mastery, organization, executive ability, authority"
            },
            9: {
                "core_desire": "Universal service and humanitarian love",
                "emotional_need": "To feel useful in serving humanity's highest good",
                "soul_craving": "To express unconditional love and serve the greater good of all",
                "divine_triangle_quote": "The soul desires to serve humanity with universal love, finding fulfillment in compassionate service to all",
                "shadow_desire": "Self-righteous judgment and emotional martyrdom",
                "keywords": "universal love, humanitarian service, compassion, wisdom, generosity, global consciousness"
            },
            11: {
                "core_desire": "Spiritual illumination and inspirational leadership",
                "emotional_need": "To channel higher wisdom and inspire spiritual awakening",
                "soul_craving": "To be a bridge between earthly and divine consciousness",
                "divine_triangle_quote": "Master Number 11: The soul craves spiritual illumination and seeks to inspire others through channeling higher wisdom",
                "shadow_desire": "Spiritual fanaticism and overwhelming sensitivity",
                "keywords": "illumination, inspiration, intuition, spiritual leadership, higher consciousness, visionary insight"
            },
            22: {
                "core_desire": "Master building for world transformation",
                "emotional_need": "To create large-scale positive change in the material world",
                "soul_craving": "To manifest visionary ideas into concrete reality for humanity's benefit",
                "divine_triangle_quote": "Master Number 22: The soul desires to be a master builder, transforming visionary ideas into material reality",
                "shadow_desire": "Overwhelming ambition and ruthless pursuit of grand visions",
                "keywords": "master building, transformation, manifestation, world service, practical visionary, large-scale impact"
            },
            33: {
                "core_desire": "Master healing and compassionate teaching",
                "emotional_need": "To heal and uplift others through unconditional love",
                "soul_craving": "To embody Christ-like compassion and heal the world's suffering",
                "divine_triangle_quote": "Master Number 33: The soul craves opportunities for master healing, seeking to embody divine love in service",
                "shadow_desire": "Emotional overwhelm and carrying others' pain as martyrdom",
                "keywords": "master healing, divine love, compassionate teaching, spiritual service, universal healing, Christ consciousness"
            },
            44: {
                "core_desire": "Master organizing for spiritual-material integration",
                "emotional_need": "To systematically manifest spiritual principles in material form",
                "soul_craving": "To organize divine wisdom into practical systems that serve humanity",
                "divine_triangle_quote": "Master Number 44: The soul desires to organize spiritual wisdom into practical systems for world betterment",
                "shadow_desire": "Rigid spiritual dogma and authoritarian control of others' spiritual growth",
                "keywords": "spiritual organization, systematic wisdom, material-spiritual integration, world betterment, practical spirituality"
            }
        }
        
        return divine_triangle_essences.get(number, divine_triangle_essences[1])
    
    def create_individual_prompt(self, number: int) -> str:
        """Create individual prompt for manual Opus generation"""
        
        essence = self.get_divine_triangle_essence(number)
        display_number = str(number)
        if number in [11, 22, 33, 44]:
            display_number = f"{number} (Master Number)"
            
        return f"""SOUL URGE {display_number} - DIVINE TRIANGLE BEHAVIORAL INSIGHTS

You are a master numerologist with deep expertise in "Numerology and The Divine Triangle" by Faith Javane and Dusty Bunker. Generate premium Soul Urge Number {display_number} behavioral insights for KASPER MLX spiritual AI system.

DIVINE TRIANGLE FOUNDATION:
Core Desire: {essence['core_desire']}
Emotional Need: {essence['emotional_need']}  
Soul Craving: {essence['soul_craving']}
Divine Triangle Teaching: "{essence['divine_triangle_quote']}"
Shadow Aspect: {essence['shadow_desire']}
Keywords: {essence['keywords']}

SOUL URGE ESSENCE:
Soul Urge represents what your soul truly desires - your deepest emotional needs, inner motivations, and what fulfills you at the core level. This is about WHAT THE SOUL CRAVES to feel complete and spiritually fulfilled.

GENERATE EXACTLY 12 BEHAVIORAL INSIGHTS FOR EACH CATEGORY:

Categories:
1. decisionMaking - How soul desires influence choices
2. stressResponse - How stress affects when soul needs aren't met  
3. communication - How inner desires shape expression
4. relationships - What the soul craves in connection
5. productivity - How soul fulfillment affects work
6. financial - Soul's relationship with money and security
7. creative - How inner desires fuel creativity
8. wellness - Soul's impact on physical/emotional health
9. learning - How soul desires shape education/growth
10. spiritual - Soul's relationship with the divine
11. transitions - How soul needs affect life changes
12. shadow - Hidden/distorted aspects of soul desires

INSIGHT REQUIREMENTS:
- Each insight: 1-2 sentences, emotionally authentic
- Intensity scores: 0.6 to 0.875 (increasing by 0.025 per insight)
- First 3 insights per category need: triggers, supports, challenges arrays
- Remaining 9 insights: just text and intensity
- Must align with Divine Triangle teachings
- Focus on emotional depth and spiritual authenticity

RETURN JSON FORMAT:
{{
  "decisionMaking": [
    {{
      "text": "Authentic insight about how Soul Urge {display_number} desires influence decision making",
      "intensity": 0.6,
      "triggers": ["specific trigger based on Divine Triangle"],
      "supports": ["specific support based on essence"], 
      "challenges": ["specific challenge based on shadow aspect"]
    }},
    {{
      "text": "Second decision-making insight",
      "intensity": 0.625,
      "triggers": ["trigger"],
      "supports": ["support"], 
      "challenges": ["challenge"]
    }},
    {{
      "text": "Third decision-making insight",
      "intensity": 0.65,
      "triggers": ["trigger"],
      "supports": ["support"], 
      "challenges": ["challenge"]
    }},
    {{
      "text": "Fourth insight (intensity 0.675)",
      "intensity": 0.675
    }},
    // ... continue through intensity 0.875 for total of 12 insights
  ],
  // ... continue for all 12 categories
}}

Focus on the authentic spiritual essence of Soul Urge {display_number} as taught in Divine Triangle. Make each insight deeply meaningful and true to Javane & Bunker's wisdom."""

    def generate_all_prompts(self):
        """Generate individual prompts for all Soul Urge numbers"""
        numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33, 44]
        output_dir = self.base_dir / "KASPERMLX" / "MLXTraining" / "ContentRefinery"
        prompts_dir = output_dir / "DivineTrianglePrompts"
        prompts_dir.mkdir(exist_ok=True)
        
        print("📚 DIVINE TRIANGLE SOUL URGE PROMPTS")
        print("=" * 42)
        print(f"Creating individual prompts based on 'Numerology and The Divine Triangle'")
        print(f"Output directory: {prompts_dir}")
        print()
        
        for number in numbers:
            prompt = self.create_individual_prompt(number)
            
            filename = f"SoulUrge_{number:02d}_DivineTriangle_Prompt.txt"
            filepath = prompts_dir / filename
            
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(prompt)
            
            print(f"✅ Created: {filename}")
        
        print()
        print("🎉 All Divine Triangle prompts created!")
        print("📝 Use these prompts with Claude Opus for premium quality generation")
        print("📚 Each prompt includes specific Divine Triangle essence and shadow aspects")
        print("🔮 Copy-paste prompts to Opus for authentic Soul Urge insights")
        
        return len(numbers)

if __name__ == "__main__":
    generator = DivineTriangleSoulUrgePrompts()
    generator.generate_all_prompts()