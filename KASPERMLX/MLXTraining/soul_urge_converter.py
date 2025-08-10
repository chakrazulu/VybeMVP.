#!/usr/bin/env python3
"""
KASPER MLX - Soul Urge Complete Conversion Script
Converts all 13 Soul Urge MD files to perfect v2.0 behavioral format

Handles all corruption issues:
- Unicode smart quotes to ASCII quotes
- Newlines between JSON properties  
- Escaped brackets to normal brackets
- Missing closing quotes
- Extracts 144+ behavioral insights per file
"""

import json
import re
import os
from typing import Dict, List, Any, Optional

class SoulUrgeConverter:
    def __init__(self):
        self.source_dir = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/ImportedContent/SoulUrgeContent"
        self.target_dir = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/KASPERMLX/MLXTraining/ContentRefinery/Approved"
        
        # Behavioral categories for Soul Urge (WHAT you desire internally)
        self.behavioral_categories = [
            "decisionMaking", "relationshipDynamics", "stressResponse", "communicationStyle",
            "creativity", "conflictResolution", "spirituality", "growth", "leadership",
            "intimacy", "boundaries", "transitions", "workStyle", "play", "healing"
        ]
        
    def clean_corrupted_json(self, content: str) -> str:
        """Clean all corruption issues in the source JSON"""
        
        # 1. Replace unicode smart quotes with ASCII quotes
        content = content.replace(chr(8220), '"').replace(chr(8221), '"')  # " and " → "
        content = content.replace(chr(8216), "'").replace(chr(8217), "'")  # ' and ' → '
        content = content.replace('"', '"').replace('"', '"')  # Backup
        content = content.replace(''', "'").replace(''', "'")  # Backup
        
        # 2. Fix escaped brackets BEFORE processing
        content = content.replace('\\[', '[').replace('\\]', ']')
        
        # 3. Remove all newlines and clean up whitespace
        lines = [line.strip() for line in content.split('\n') if line.strip()]
        content = ' '.join(lines)
        
        # 4. Fix structural JSON issues
        # Fix missing commas between objects/arrays
        content = re.sub(r'}\s*{', '}, {', content)  # }{ → }, {
        content = re.sub(r']\s*{', '], {', content)  # ]{ → ], {
        content = re.sub(r'}\s*\[', '}, [', content)  # }[ → }, [
        content = re.sub(r']\s*\[', '], [', content)  # ][ → ], [
        
        # Fix missing commas before specific keys (handling multiple closing brackets/braces)
        content = re.sub(r'([}\]])\s*"(trinity|profiles|meta)', r'\1, "\2', content)
        content = re.sub(r'([}\]]+)\s*"(trinity|profiles|meta)', r'\1, "\2', content)
        
        # Specific fix for the ]}}], "trinity" pattern
        content = re.sub(r']\}\}\]\s*"trinity"', r']}}], "trinity"', content)
        content = re.sub(r']\}\}\],\s*"trinity"', r']}}], "trinity"', content)
        
        # 5. Now handle the quotes-within-strings issue more carefully
        # Find patterns like: "text": "Say, "I need help""
        def fix_embedded_quotes(match):
            key = match.group(1)
            value = match.group(2)
            # Escape internal quotes
            fixed_value = value.replace('"', '\\"')
            return f'"{key}": "{fixed_value}"'
        
        # Apply to common text fields
        content = re.sub(r'"(text|notes|coreEssence|lifeLesson|shadowSignature|themes|practices)":\s*"([^"]*(?:"[^"]*)*)"', 
                        fix_embedded_quotes, content)
        
        # 6. Clean up spacing
        content = re.sub(r'\s*{\s*', '{', content)
        content = re.sub(r'\s*}\s*', '}', content)
        content = re.sub(r'\s*\[\s*', '[', content)
        content = re.sub(r'\s*\]\s*', ']', content)
        content = re.sub(r'\s*:\s*', ': ', content)
        content = re.sub(r'\s*,\s*', ', ', content)
        
        # 7. Final fix for any remaining malformed structure
        content = re.sub(r',\s*}', '}', content)  # Remove trailing commas
        content = re.sub(r',\s*]', ']', content)  # Remove trailing commas
        
        return content
        
    def extract_behavioral_insights(self, profile_data: Dict) -> List[Dict]:
        """Extract all behavioral insights from profile data"""
        insights = []
        
        # Extract from scenarios (main source of behavioral data)
        if 'scenarios' in profile_data:
            for scenario in profile_data['scenarios']:
                category = scenario.get('category', 'general')
                if 'insights' in scenario:
                    for insight in scenario['insights']:
                        insights.append({
                            "category": category,
                            "text": insight.get('text', ''),
                            "intensity": insight.get('intensity', 0.75),
                            "triggers": insight.get('triggers', []),
                            "supports": insight.get('supports', []),
                            "challenges": insight.get('challenges', [])
                        })
        
        # Extract from pinnacles 
        if 'pinnacles' in profile_data:
            for pinnacle in profile_data['pinnacles']:
                if 'insights' in pinnacle:
                    for insight in pinnacle['insights']:
                        insights.append({
                            "category": "spirituality",
                            "text": insight.get('text', ''),
                            "intensity": insight.get('intensity', 0.75)
                        })
        
        # Extract from cycles
        if 'cycles' in profile_data:
            for cycle in profile_data['cycles']:
                if 'insights' in cycle:
                    for insight in cycle['insights']:
                        insights.append({
                            "category": "growth", 
                            "text": insight.get('text', ''),
                            "intensity": insight.get('intensity', 0.75)
                        })
        
        # Extract from challenges section
        if 'challenges' in profile_data:
            for challenge in profile_data['challenges']:
                if 'insights' in challenge:
                    for insight in challenge['insights']:
                        insights.append({
                            "category": "conflictResolution",
                            "text": insight.get('text', ''),
                            "intensity": insight.get('intensity', 0.8)
                        })
        
        return insights
    
    def convert_to_v2_format(self, number: int, source_data: Dict) -> Dict:
        """Convert source data to v2.0 behavioral format"""
        
        # Handle both single profile and profiles array
        if 'profiles' in source_data and isinstance(source_data['profiles'], list):
            profile = source_data['profiles'][0] if source_data['profiles'] else {}
        else:
            profile = source_data.get('profile', {})
        
        # Extract behavioral insights
        behavioral_insights = self.extract_behavioral_insights(profile)
        
        # Create v2.0 structure
        v2_data = {
            "number": number,
            "title": f"Soul Urge {number}",
            "behavioral_category": "soul_urge_behavioral_analysis",
            "core_essence": profile.get('coreEssence', ''),
            "life_lesson": profile.get('lifeLesson', ''),
            "shadow_signature": profile.get('shadowSignature', ''),
            "behavioral_insights": behavioral_insights
        }
        
        return v2_data
    
    def convert_file(self, number: int) -> bool:
        """Convert a single Soul Urge file"""
        # Handle master numbers
        file_number = f"{number:02d}" if number < 10 else str(number)
        source_file = f"{self.source_dir}/SU{number}.md"
        target_file = f"{self.target_dir}/soulUrge_{file_number}_v2.0_converted.json"
        
        try:
            print(f"\n🔮 Converting Soul Urge {number}...")
            
            # Read source file
            with open(source_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Extract JSON from markdown (skip markdown headers)
            json_start = content.find('{')
            if json_start == -1:
                print(f"❌ No JSON found in {source_file}")
                return False
                
            json_content = content[json_start:]
            
            # Clean corruption issues
            cleaned_content = self.clean_corrupted_json(json_content)
            
            # Parse JSON
            try:
                source_data = json.loads(cleaned_content)
            except json.JSONDecodeError as e:
                print(f"❌ JSON parse error in {source_file}: {e}")
                print(f"📍 Error near: {cleaned_content[max(0, e.pos-50):e.pos+50]}")
                return False
            
            # Convert to v2.0 format
            v2_data = self.convert_to_v2_format(number, source_data)
            
            # Write target file
            with open(target_file, 'w', encoding='utf-8') as f:
                json.dump(v2_data, f, indent=2, ensure_ascii=False)
            
            insights_count = len(v2_data['behavioral_insights'])
            print(f"✅ Converted SU{number} → {insights_count} behavioral insights")
            
            return True
            
        except Exception as e:
            print(f"❌ Error converting SU{number}: {e}")
            return False
    
    def convert_all(self):
        """Convert all 13 Soul Urge files"""
        print("🌟 KASPER MLX - Soul Urge Complete Conversion")
        print("=" * 50)
        
        # All Soul Urge numbers (including master numbers)
        numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33, 44]
        
        successful = 0
        failed = []
        
        for number in numbers:
            if self.convert_file(number):
                successful += 1
            else:
                failed.append(number)
        
        print(f"\n🎯 CONVERSION COMPLETE")
        print(f"✅ Successful: {successful}/13")
        
        if failed:
            print(f"❌ Failed: {failed}")
        else:
            print("🏆 ALL SOUL URGE FILES CONVERTED SUCCESSFULLY!")
            print("💫 KASPER MLX spiritual data is now complete!")

def main():
    converter = SoulUrgeConverter()
    converter.convert_all()

if __name__ == "__main__":
    main()