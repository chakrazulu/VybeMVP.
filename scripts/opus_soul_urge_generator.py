#!/usr/bin/env python3
"""
Opus Soul Urge Generator - High Quality Content Generation
Uses Claude Opus API to generate authentic, nuanced Soul Urge behavioral insights
Based on validated Expression schema structure for perfect compatibility
"""

import json
import os
from pathlib import Path
from typing import Dict, List, Any
from datetime import datetime
import anthropic

class OpusSoulUrgeGenerator:
    def __init__(self):
        self.base_dir = Path(__file__).parent.parent
        self.expression_schema = self.load_expression_schema()
        
        # Initialize Anthropic client
        api_key = os.getenv('ANTHROPIC_API_KEY')
        if not api_key:
            print("❌ ANTHROPIC_API_KEY environment variable required")
            print("Set with: export ANTHROPIC_API_KEY='your-key-here'")
            exit(1)
            
        self.client = anthropic.Anthropic(api_key=api_key)
        
    def load_expression_schema(self) -> Dict[str, Any]:
        """Load the validated Expression schema as template"""
        schema_path = self.base_dir / "NumerologyData" / "PERFECT_EXPRESSION_NUMBER_SCHEMA.json"
        with open(schema_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    
    def get_divine_triangle_essence(self, number: int) -> Dict[str, str]:
        """Get Soul Urge essence based on Divine Triangle book teachings"""
        
        divine_triangle_essences = {
            1: {
                "core_desire": "Independence and individual achievement",
                "emotional_need": "Recognition as a unique, pioneering individual", 
                "soul_craving": "To be first, to lead, to create something original",
                "divine_triangle_quote": "The soul desires to be independent and self-reliant, seeking personal achievement and recognition for original contributions",
                "shadow_desire": "Domination and ego-driven control over others"
            },
            2: {
                "core_desire": "Harmony, partnership, and peaceful cooperation",
                "emotional_need": "To feel needed and appreciated in relationships",
                "soul_craving": "Unity, balance, and collaborative achievement", 
                "divine_triangle_quote": "The soul craves partnership and cooperation, finding fulfillment through helping others and creating harmony",
                "shadow_desire": "Codependency and loss of individual identity in relationships"
            },
            3: {
                "core_desire": "Creative self-expression and joyful communication",
                "emotional_need": "Artistic fulfillment and social appreciation",
                "soul_craving": "To inspire others through beauty, creativity, and optimistic expression",
                "divine_triangle_quote": "The soul desires creative expression and seeks to bring joy and inspiration to the world through artistic gifts",
                "shadow_desire": "Superficial attention-seeking and scattered creative energy"
            },
            4: {
                "core_desire": "Security, order, and systematic achievement",
                "emotional_need": "Stability and recognition for reliable service",
                "soul_craving": "To build something lasting and practically valuable",
                "divine_triangle_quote": "The soul craves security and order, finding fulfillment in practical service and building lasting foundations",
                "shadow_desire": "Rigid control and fear-based resistance to change"
            },
            5: {
                "core_desire": "Freedom, variety, and adventurous experience",
                "emotional_need": "Mental stimulation and personal liberty",
                "soul_craving": "To experience all of life's possibilities without restriction",
                "divine_triangle_quote": "The soul desires freedom and variety, craving new experiences and the liberty to explore life's endless possibilities",
                "shadow_desire": "Irresponsible escapism and inability to commit"
            },
            6: {
                "core_desire": "Nurturing service and healing responsibility",
                "emotional_need": "To feel needed as a caregiver and healer",
                "soul_craving": "To create harmony in home and community through loving service",
                "divine_triangle_quote": "The soul craves opportunities to nurture and heal, finding fulfillment in creating harmony for family and community",
                "shadow_desire": "Martyrdom and controlling others through guilt"
            },
            7: {
                "core_desire": "Spiritual understanding and inner wisdom",
                "emotional_need": "Solitude for deep contemplation and mystical connection",
                "soul_craving": "To uncover hidden truths and achieve spiritual enlightenment",
                "divine_triangle_quote": "The soul desires wisdom and spiritual understanding, craving solitude to explore life's deeper mysteries",
                "shadow_desire": "Spiritual superiority and isolation from human connection"
            },
            8: {
                "core_desire": "Material mastery and powerful achievement",
                "emotional_need": "Recognition for executive ability and material success",
                "soul_craving": "To organize and direct resources for significant worldly impact",
                "divine_triangle_quote": "The soul craves material mastery and seeks to achieve power through organizing resources and directing others",
                "shadow_desire": "Ruthless materialism and abuse of power"
            },
            9: {
                "core_desire": "Universal service and humanitarian love",
                "emotional_need": "To feel useful in serving humanity's highest good",
                "soul_craving": "To express unconditional love and serve the greater good of all",
                "divine_triangle_quote": "The soul desires to serve humanity with universal love, finding fulfillment in compassionate service to all",
                "shadow_desire": "Self-righteous judgment and emotional martyrdom"
            },
            11: {
                "core_desire": "Spiritual illumination and inspirational leadership",
                "emotional_need": "To channel higher wisdom and inspire spiritual awakening",
                "soul_craving": "To be a bridge between earthly and divine consciousness",
                "divine_triangle_quote": "Master Number 11: The soul craves spiritual illumination and seeks to inspire others through channeling higher wisdom",
                "shadow_desire": "Spiritual fanaticism and overwhelming sensitivity"
            },
            22: {
                "core_desire": "Master building for world transformation",
                "emotional_need": "To create large-scale positive change in the material world",
                "soul_craving": "To manifest visionary ideas into concrete reality for humanity's benefit",
                "divine_triangle_quote": "Master Number 22: The soul desires to be a master builder, transforming visionary ideas into material reality",
                "shadow_desire": "Overwhelming ambition and ruthless pursuit of grand visions"
            },
            33: {
                "core_desire": "Master healing and compassionate teaching",
                "emotional_need": "To heal and uplift others through unconditional love",
                "soul_craving": "To embody Christ-like compassion and heal the world's suffering",
                "divine_triangle_quote": "Master Number 33: The soul craves opportunities for master healing, seeking to embody divine love in service",
                "shadow_desire": "Emotional overwhelm and carrying others' pain as martyrdom"
            },
            44: {
                "core_desire": "Master organizing for spiritual-material integration",
                "emotional_need": "To systematically manifest spiritual principles in material form",
                "soul_craving": "To organize divine wisdom into practical systems that serve humanity",
                "divine_triangle_quote": "Master Number 44: The soul desires to organize spiritual wisdom into practical systems for world betterment",
                "shadow_desire": "Rigid spiritual dogma and authoritarian control of others' spiritual growth"
            }
        }
        
        return divine_triangle_essences.get(number, divine_triangle_essences[1])

    def create_opus_prompt(self, number: int) -> str:
        """Create detailed prompt for Opus to generate Soul Urge content based on Divine Triangle"""
        
        essence = self.get_divine_triangle_essence(number)
        
        # Master Numbers handling
        display_number = str(number)
        if number in [11, 22, 33, 44]:
            display_number = f"{number} (Master Number)"
            
        return f"""You are a master numerologist with deep expertise in "Numerology and The Divine Triangle" by Faith Javane and Dusty Bunker, creating Soul Urge Number {display_number} behavioral insights for KASPER MLX.

DIVINE TRIANGLE FOUNDATION - SOUL URGE {display_number}:
Core Desire: {essence['core_desire']}
Emotional Need: {essence['emotional_need']}  
Soul Craving: {essence['soul_craving']}
Divine Triangle Teaching: "{essence['divine_triangle_quote']}"
Shadow Aspect: {essence['shadow_desire']}

CRITICAL REQUIREMENTS:
- Generate exactly 12 behavioral insights for EACH of these 12 categories
- Each insight must align with Divine Triangle teachings and be spiritually authentic
- Focus on SOUL URGE: inner desires, emotional needs, what the soul truly craves
- Draw specifically from Javane & Bunker's interpretations and spiritual wisdom

SOUL URGE DEFINITION (per Divine Triangle):
Soul Urge represents what your soul truly desires - your deepest emotional needs, inner motivations, and what fulfills you at the core level. Unlike Expression (how you communicate) or Life Path (who you are), Soul Urge is about WHAT YOUR SOUL CRAVES to feel complete and spiritually fulfilled.

REQUIRED CATEGORIES (12 insights each):
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
- First 3 insights in each category need: triggers, supports, challenges arrays
- Remaining 9 insights: just text and intensity
- Focus on emotional depth, not surface behaviors

SOUL URGE {display_number} SPIRITUAL PROFILE:
Create insights that capture the authentic emotional and spiritual essence of Soul Urge {display_number}. Draw from traditional numerology wisdom while making each insight personally resonant and spiritually meaningful.

Return ONLY the behavioral insights in this exact JSON structure:
{{
  "decisionMaking": [
    {{
      "text": "insight about how soul desires influence decision making",
      "intensity": 0.6,
      "triggers": ["specific trigger"],
      "supports": ["specific support"], 
      "challenges": ["specific challenge"]
    }},
    // ... 11 more insights with increasing intensity
  ],
  // ... all 12 categories
}}

Generate profound, spiritually authentic insights that honor the sacred nature of Soul Urge {display_number}."""

    def generate_opus_content(self, number: int) -> Dict[str, Any]:
        """Use Opus to generate high-quality Soul Urge behavioral content"""
        
        prompt = self.create_opus_prompt(number)
        
        print(f"🔮 Generating Soul Urge {number} content with Opus...")
        
        try:
            response = self.client.messages.create(
                model="claude-3-opus-20240229",
                max_tokens=4000,
                temperature=0.7,
                messages=[{"role": "user", "content": prompt}]
            )
            
            # Parse the JSON response
            content = response.content[0].text
            
            # Clean up the response to extract just the JSON
            start_idx = content.find('{')
            end_idx = content.rfind('}') + 1
            
            if start_idx == -1 or end_idx == 0:
                raise ValueError("No JSON found in Opus response")
                
            json_content = content[start_idx:end_idx]
            behavioral_data = json.loads(json_content)
            
            # Validate structure
            expected_categories = [
                "decisionMaking", "stressResponse", "communication", "relationships",
                "productivity", "financial", "creative", "wellness", "learning",
                "spiritual", "transitions", "shadow"
            ]
            
            for category in expected_categories:
                if category not in behavioral_data:
                    raise ValueError(f"Missing category: {category}")
                if len(behavioral_data[category]) != 12:
                    raise ValueError(f"Category {category} has {len(behavioral_data[category])} insights, expected 12")
            
            print(f"✅ Generated {len(behavioral_data)} categories with authentic insights")
            return behavioral_data
            
        except Exception as e:
            print(f"❌ Error generating content with Opus: {e}")
            return None
    
    def create_complete_soul_urge_file(self, number: int) -> Dict[str, Any]:
        """Create complete Soul Urge file using Opus content and Expression schema structure"""
        
        # Generate behavioral content with Opus
        behavioral_data = self.generate_opus_content(number)
        if not behavioral_data:
            return None
            
        # Start with Expression schema as template
        soul_urge_data = json.loads(json.dumps(self.expression_schema))
        
        # Update meta section for Soul Urge
        soul_urge_data["meta"].update({
            "id": f"soulUrge_{number:02d}",
            "numerologyType": "soulUrge",
            "number": number,
            "title": f"Soul Urge Number {number}",
            "description": f"Deep emotional desires and inner motivations for Soul Urge {number}",
            "context": "soulUrge",
            "lastUpdated": datetime.now().isoformat(),
            "generatedBy": "Claude Opus API",
            "qualityLevel": "premium"
        })
        
        # Update trinity for Soul Urge
        soul_urge_data["trinity"]["calculation"] = "Sum the vowels of the full birth name; reduce to a single digit or master number"
        soul_urge_data["trinity"]["meaning"] = "Represents your deepest desires, emotional needs, and what your soul truly craves"
        soul_urge_data["trinity"]["resonance"] = "emotional"
        
        # Update profile context
        soul_urge_data["profiles"][0]["context"] = "soulUrge"
        
        # Insert Opus-generated behavioral data
        soul_urge_data["profiles"][0]["behavioral"] = behavioral_data
        
        # Update generation instructions
        soul_urge_data["generation_instructions"]["context"] = "soulUrge"
        soul_urge_data["generation_instructions"]["focus"] = "Deep emotional desires and inner spiritual motivations"
        soul_urge_data["generation_instructions"]["model"] = "claude-3-opus-20240229"
        
        return soul_urge_data
    
    def generate_all_opus_soul_urge_files(self):
        """Generate all Soul Urge files using Opus for premium quality"""
        numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33, 44]
        output_dir = self.base_dir / "KASPERMLX" / "MLXTraining" / "ContentRefinery" / "Approved"
        
        print("🔮 OPUS SOUL URGE GENERATOR - PREMIUM QUALITY")
        print("=" * 55)
        print(f"Using Claude Opus API for authentic spiritual insights")
        print(f"Output directory: {output_dir}")
        print()
        
        generated_files = []
        
        for i, number in enumerate(numbers, 1):
            try:
                print(f"[{i}/{len(numbers)}] Processing Soul Urge {number}...")
                
                soul_urge_data = self.create_complete_soul_urge_file(number)
                if not soul_urge_data:
                    print(f"❌ Failed to generate Soul Urge {number}")
                    continue
                
                filename = f"soulUrge_{number:02d}_opus_v3.0.json"
                filepath = output_dir / filename
                
                with open(filepath, 'w', encoding='utf-8') as f:
                    json.dump(soul_urge_data, f, indent=2, ensure_ascii=False)
                
                generated_files.append(filename)
                print(f"✅ Generated: {filename} (Opus premium quality)")
                print()
                
            except Exception as e:
                print(f"❌ Error generating Soul Urge {number}: {e}")
                print()
        
        print("🎉 OPUS GENERATION COMPLETE!")
        print("=" * 30)
        print(f"✅ Successfully generated {len(generated_files)} premium Soul Urge files")
        print("🔮 All content created with Claude Opus for maximum spiritual authenticity")
        print("📋 Files use validated Expression schema structure")
        print("🚀 Ready for KASPER MLX premium training pipeline")
        
        return generated_files

if __name__ == "__main__":
    print("🔮 Opus Soul Urge Generator")
    print("Requires ANTHROPIC_API_KEY environment variable")
    print()
    
    generator = OpusSoulUrgeGenerator()
    generator.generate_all_opus_soul_urge_files()