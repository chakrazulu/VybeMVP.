#!/usr/bin/env python3
"""
Soul Urge Robust Converter - Handles malformed JSON with newlines
Converts Soul Urge MD files to v2.0 behavioral JSON format
"""

import json
import re
from pathlib import Path
from typing import Dict, List, Any

class SoulUrgeRobustConverter:
    def __init__(self):
        self.input_dir = Path("/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/ImportedContent/SoulUrgeContent")
        self.output_dir = Path("/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/KASPERMLX/MLXTraining/ContentRefinery/Approved")

    def fix_malformed_json(self, content: str) -> str:
        """Fix JSON with newlines between every property and missing quotes"""
        # Remove MD headers
        content = re.sub(r'^# SU\d+\s*\n\s*## SU\d+\s*\n', '', content, flags=re.MULTILINE)
        
        # Fix escaped brackets
        content = content.replace('\\[', '[').replace('\\]', ']')
        
        # Fix smart quotes to regular ASCII quotes
        content = content.replace('"', '"').replace('"', '"')  # Unicode smart quotes
        content = content.replace(''', "'").replace(''', "'")  # Unicode smart apostrophes
        
        # Remove excessive newlines - join all non-empty lines
        lines = [line.strip() for line in content.split('\n') if line.strip()]
        
        # Join with no spaces to create compact JSON
        compact_json = ''.join(lines)
        
        # Fix missing closing quotes (common issue)
        # Pattern: "notes": "text without closing quote }
        compact_json = re.sub(r'"notes":\s*"([^"]*?)\s*}', r'"notes": "\1" }', compact_json)
        compact_json = re.sub(r'"notes":\s*"([^"]*?)\s*\]', r'"notes": "\1" ]', compact_json)
        
        # Add proper spacing for readability
        compact_json = re.sub(r'":"', '": "', compact_json)
        compact_json = re.sub(r'":(\d)', r'": \1', compact_json)  
        compact_json = re.sub(r'":({|\[)', r'": \1', compact_json)
        compact_json = re.sub(r'",("|\})', r'", \1', compact_json)
        compact_json = re.sub(r'},\s*{', '}, {', compact_json)
        compact_json = re.sub(r'\],\s*"', '], "', compact_json)
        
        # Final cleanup for any remaining quote issues
        compact_json = re.sub(r'\s+', ' ', compact_json)  # Normalize whitespace
        
        return compact_json

    def convert_to_v2_behavioral(self, soul_urge_data: Dict, number: int) -> Dict[str, Any]:
        """Convert to v2.0 behavioral format with Soul Urge focus"""
        
        profile = soul_urge_data['profiles'][0]
        behavioral = profile['behavioral']
        
        v2_data = {
            "number": number,
            "title": f"Soul Urge {number}",
            "behavioral_category": "soul_urge_behavioral_analysis",
            "core_essence": profile.get('coreEssence', ''),
            "life_lesson": profile.get('lifeLesson', ''),
            "shadow_signature": profile.get('shadowSignature', ''),
            "intensity_scoring": {
                "min_range": 0.6,
                "max_range": 0.9,
                "note": "Higher intensity indicates stronger soul urge manifestation"
            },
            "divine_triangle_role": {
                "focus": "WHAT you deeply desire and are motivated by internally",
                "calculation": "Sum of vowels in full birth name",
                "relationship_to_life_path": "Provides inner motivation for Life Path journey",
                "relationship_to_expression": "Fuels the desires that drive external Expression"
            },
            "behavioral_insights": []
        }
        
        # Convert all behavioral categories
        for category, insights in behavioral.items():
            for insight in insights:
                behavioral_insight = {
                    "category": category,
                    "text": insight["text"],
                    "intensity": insight.get("intensity", 0.75)
                }
                
                # Add optional fields if present
                for field in ["triggers", "supports", "challenges"]:
                    if field in insight:
                        behavioral_insight[field] = insight[field]
                
                v2_data["behavioral_insights"].append(behavioral_insight)
        
        return v2_data

    def convert_file(self, input_file: Path) -> bool:
        """Convert single Soul Urge file"""
        try:
            print(f"Converting {input_file.name}...")
            
            # Extract number
            number_match = re.search(r'SU(\d+)', input_file.name)
            if not number_match:
                return False
            
            number = int(number_match.group(1))
            
            # Read and fix content
            content = input_file.read_text(encoding='utf-8')
            fixed_content = self.fix_malformed_json(content)
            
            # Try to parse JSON, if it fails, save debug and try to fix quotes
            try:
                soul_urge_data = json.loads(fixed_content)
            except json.JSONDecodeError as e:
                # Save debug file for inspection
                debug_file = Path(f"/tmp/SU{number}_debug_fixed.json")
                debug_file.write_text(fixed_content)
                
                print(f"❌ JSON parsing failed: {e}")
                print(f"💾 Saved debug to: {debug_file}")
                
                # Try using the pre-validated debug files if they exist
                try:
                    pre_validated = Path(f"/tmp/SU{number}_debug.json")
                    if pre_validated.exists():
                        print(f"🔄 Using pre-validated debug file")
                        soul_urge_data = json.loads(pre_validated.read_text())
                    else:
                        # Final attempt with aggressive quote fixing
                        quote_fixed = re.sub(r'([{,]\s*)([a-zA-Z_][a-zA-Z0-9_]*)\s*:', r'\1"\2":', fixed_content)
                        soul_urge_data = json.loads(quote_fixed)
                        print(f"✅ Fixed with property name quotes")
                except json.JSONDecodeError as e2:
                    print(f"❌ Final attempt failed: {e2}")
                    return False
            
            # Convert to v2.0 format
            v2_data = self.convert_to_v2_behavioral(soul_urge_data, number)
            
            # Write output
            output_file = self.output_dir / f"soulUrge_{number:02d}_v2.0_converted.json"
            
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(v2_data, f, indent=2, ensure_ascii=False)
            
            insight_count = len(v2_data["behavioral_insights"])
            print(f"✅ Created soulUrge_{number:02d}_v2.0_converted.json")
            print(f"   {insight_count} behavioral insights converted")
            
            return True
            
        except Exception as e:
            print(f"❌ Error converting {input_file.name}: {e}")
            return False

    def convert_all_files(self):
        """Convert all Soul Urge files"""
        print("🔮 SOUL URGE ROBUST CONVERTER - v2.0 Behavioral Format")
        print("=" * 60)
        
        md_files = list(self.input_dir.glob("SU*.md"))
        
        if not md_files:
            print("❌ No Soul Urge files found")
            return
        
        print(f"Found {len(md_files)} Soul Urge files")
        
        self.output_dir.mkdir(parents=True, exist_ok=True)
        
        successful = 0
        failed = 0
        total_insights = 0
        
        for md_file in sorted(md_files):
            if self.convert_file(md_file):
                successful += 1
            else:
                failed += 1
        
        print("\n" + "=" * 60)
        print(f"🎯 SOUL URGE CONVERSION COMPLETE")
        print(f"✅ Successful: {successful}")
        print(f"❌ Failed: {failed}")
        
        if successful > 0:
            print("🔮 Soul Urge v2.0 behavioral corpus ready for KASPER MLX!")

def main():
    converter = SoulUrgeRobustConverter()
    converter.convert_all_files()

if __name__ == "__main__":
    main()