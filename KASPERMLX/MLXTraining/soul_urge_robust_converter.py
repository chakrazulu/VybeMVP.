#!/usr/bin/env python3
"""
KASPER MLX - Soul Urge ROBUST Converter (Pattern Matching Approach)
Bypasses JSON parsing entirely - extracts data via regex patterns

This approach:
1. Uses regex to extract key fields directly from source text
2. Builds v2.0 structure manually without parsing corrupted JSON  
3. Focuses on extracting ALL behavioral insights (144+ per file)
4. Handles all corruption issues at the text level
"""

import json
import re
import os
from typing import Dict, List, Any

class RobustSoulUrgeConverter:
    def __init__(self):
        self.source_dir = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/ImportedContent/SoulUrgeContent"
        self.target_dir = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/KASPERMLX/MLXTraining/ContentRefinery/Approved"
    
    def clean_text(self, text: str) -> str:
        """Clean text of unicode issues"""
        # Replace unicode smart quotes  
        text = text.replace(chr(8220), '"').replace(chr(8221), '"')  # " and " → "
        text = text.replace(chr(8216), "'").replace(chr(8217), "'")  # ' and ' → '
        text = text.replace('"', '"').replace('"', '"')  # Backup
        text = text.replace(''', "'").replace(''', "'")  # Backup
        
        # Remove escaped brackets
        text = text.replace('\\[', '[').replace('\\]', ']')
        
        return text.strip()
    
    def extract_core_fields(self, content: str) -> Dict[str, str]:
        """Extract core essence, life lesson, and shadow signature using regex"""
        cleaned_content = self.clean_text(content)
        
        fields = {}
        
        # Extract coreEssence
        core_match = re.search(r'"coreEssence":\s*"([^"]+(?:\\"[^"]*)*)"', cleaned_content)
        if core_match:
            fields['core_essence'] = core_match.group(1).replace('\\"', '"')
        
        # Extract lifeLesson  
        life_match = re.search(r'"lifeLesson":\s*"([^"]+(?:\\"[^"]*)*)"', cleaned_content)
        if life_match:
            fields['life_lesson'] = life_match.group(1).replace('\\"', '"')
        
        # Extract shadowSignature
        shadow_match = re.search(r'"shadowSignature":\s*"([^"]+(?:\\"[^"]*)*)"', cleaned_content)
        if shadow_match:
            fields['shadow_signature'] = shadow_match.group(1).replace('\\"', '"')
        
        return fields
    
    def extract_behavioral_insights(self, content: str) -> List[Dict]:
        """Extract ALL behavioral insights from scenarios using regex patterns"""
        cleaned_content = self.clean_text(content)
        insights = []
        
        # Pattern 1: Direct "text" fields in insights arrays
        text_pattern = r'"text":\s*"([^"]+(?:\\"[^"]*)*)"'
        text_matches = re.findall(text_pattern, cleaned_content)
        
        # Pattern 2: Extract scenarios with categories
        scenario_pattern = r'"category":\s*"([^"]+)"\s*,.*?"insights":\s*\[(.*?)\]'
        scenario_matches = re.findall(scenario_pattern, cleaned_content, re.DOTALL)
        
        # Process scenario-based insights
        for category, insights_text in scenario_matches:
            # Find all text entries within this scenario
            scenario_texts = re.findall(r'"text":\s*"([^"]+(?:\\"[^"]*)*)"', insights_text)
            for text in scenario_texts:
                insights.append({
                    "category": self.map_category(category),
                    "text": text.replace('\\"', '"'),
                    "intensity": 0.75
                })
        
        # Pattern 3: Direct text extractions (for insights without clear categories)
        for text in text_matches[:150]:  # Limit to prevent duplicates
            if len(text) > 10 and text not in [insight['text'] for insight in insights]:  # Avoid duplicates
                insights.append({
                    "category": "general",
                    "text": text.replace('\\"', '"'),
                    "intensity": 0.75
                })
        
        return insights[:144]  # Limit to 144 insights per file as requested
    
    def map_category(self, original_category: str) -> str:
        """Map original categories to standard behavioral categories"""
        category_map = {
            'relationships': 'relationshipDynamics',
            'work': 'workStyle', 
            'stress': 'stressResponse',
            'communication': 'communicationStyle',
            'conflict': 'conflictResolution',
            'spiritual': 'spirituality',
            'personal': 'growth',
            'leadership': 'leadership',
            'intimate': 'intimacy',
            'boundary': 'boundaries',
            'transition': 'transitions',
            'creative': 'creativity',
            'decision': 'decisionMaking',
            'healing': 'healing',
            'play': 'play'
        }
        
        # Try exact match first
        if original_category in category_map:
            return category_map[original_category]
        
        # Try partial matches
        for key, value in category_map.items():
            if key in original_category.lower():
                return value
        
        # Default fallback
        return 'general'
    
    def convert_file(self, number: int) -> bool:
        """Convert a single Soul Urge file using pattern matching"""
        # Handle master numbers
        file_number = f"{number:02d}" if number < 10 else str(number)
        source_file = f"{self.source_dir}/SU{number}.md"
        target_file = f"{self.target_dir}/soulUrge_{file_number}_v2.0_converted.json"
        
        try:
            print(f"\n🔮 Converting Soul Urge {number} (Pattern Matching)...")
            
            # Read source file
            with open(source_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Extract core fields
            core_fields = self.extract_core_fields(content)
            
            # Extract behavioral insights
            behavioral_insights = self.extract_behavioral_insights(content)
            
            # Build v2.0 structure
            v2_data = {
                "number": number,
                "title": f"Soul Urge {number}",
                "behavioral_category": "soul_urge_behavioral_analysis",
                "core_essence": core_fields.get('core_essence', ''),
                "life_lesson": core_fields.get('life_lesson', ''),
                "shadow_signature": core_fields.get('shadow_signature', ''),
                "behavioral_insights": behavioral_insights
            }
            
            # Write target file
            with open(target_file, 'w', encoding='utf-8') as f:
                json.dump(v2_data, f, indent=2, ensure_ascii=False)
            
            insights_count = len(behavioral_insights)
            print(f"✅ Converted SU{number} → {insights_count} behavioral insights")
            
            return True
            
        except Exception as e:
            print(f"❌ Error converting SU{number}: {e}")
            return False
    
    def convert_all(self):
        """Convert all 13 Soul Urge files using robust pattern matching"""
        print("🌟 KASPER MLX - Soul Urge ROBUST Conversion (Pattern Matching)")
        print("=" * 60)
        
        # All Soul Urge numbers (including master numbers)
        numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33, 44]
        
        successful = 0
        failed = []
        total_insights = 0
        
        for number in numbers:
            if self.convert_file(number):
                successful += 1
                # Count insights in converted file
                file_number = f"{number:02d}" if number < 10 else str(number)
                target_file = f"{self.target_dir}/soulUrge_{file_number}_v2.0_converted.json"
                try:
                    with open(target_file, 'r') as f:
                        data = json.load(f)
                        total_insights += len(data.get('behavioral_insights', []))
                except:
                    pass
            else:
                failed.append(number)
        
        print(f"\n🎯 ROBUST CONVERSION COMPLETE")
        print(f"✅ Successful: {successful}/13")
        print(f"💫 Total Behavioral Insights: {total_insights}")
        
        if failed:
            print(f"❌ Failed: {failed}")
        else:
            print("🏆 ALL SOUL URGE FILES CONVERTED SUCCESSFULLY!")
            print("💎 KASPER MLX spiritual data is now COMPLETE!")

def main():
    converter = RobustSoulUrgeConverter()
    converter.convert_all()

if __name__ == "__main__":
    main()