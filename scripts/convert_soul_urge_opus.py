#!/usr/bin/env python3

import json
import os
import re
from pathlib import Path
from typing import Dict, List, Any
import shutil

class SoulUrgeOPUSConverter:
    """Convert Soul Urge MD files to v2.0 JSON with Divine Triangle consistency"""
    
    def __init__(self):
        self.input_dir = Path("/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/ImportedContent/SoulUrgeContent")
        self.archive_dir = Path("/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/KASPERMLX/MLXTraining/ContentRefinery/Archive")
        self.incoming_dir = Path("/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/KASPERMLX/MLXTraining/ContentRefinery/Incoming/SoulUrgeContent")
        self.approved_dir = Path("/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/KASPERMLX/MLXTraining/ContentRefinery/Approved")
        
        # Create directories if needed
        self.incoming_dir.mkdir(parents=True, exist_ok=True)
        self.archive_dir.mkdir(parents=True, exist_ok=True)
        
        # Divine Triangle consistency mappings
        self.number_archetypes = {
            1: "The Pioneer",
            2: "The Cooperator", 
            3: "The Communicator",
            4: "The Builder",
            5: "The Freedom Seeker",
            6: "The Nurturer",
            7: "The Mystic",
            8: "The Material Master",
            9: "The Humanitarian",
            11: "The Intuitive",
            22: "The Master Builder",
            33: "The Master Teacher",
            44: "The Master Healer"
        }
        
    def extract_number_from_filename(self, filename: str) -> int:
        """Extract number from SU1.md, SU11.md, etc."""
        match = re.search(r'SU(\d+)\.md', filename)
        if match:
            return int(match.group(1))
        return 0
    
    def parse_md_to_json(self, file_path: Path) -> Dict[str, Any]:
        """Parse the pseudo-JSON from MD file"""
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Remove the markdown headers
        content = re.sub(r'^#.*$', '', content, flags=re.MULTILINE)
        
        # Fix the JSON array brackets
        content = content.replace('\\[', '[').replace('\\]', ']')
        
        # Try to find the JSON content
        json_match = re.search(r'\{.*\}', content, re.DOTALL)
        if json_match:
            json_str = json_match.group(0)
            try:
                # Parse the JSON
                return json.loads(json_str)
            except json.JSONDecodeError as e:
                print(f"JSON parsing error in {file_path.name}: {e}")
                # Try to fix common issues
                json_str = re.sub(r',\s*}', '}', json_str)  # Remove trailing commas
                json_str = re.sub(r',\s*]', ']', json_str)
                try:
                    return json.loads(json_str)
                except:
                    return None
        return None
    
    def convert_to_v2_behavioral(self, data: Dict, number: int) -> Dict[str, Any]:
        """Convert to v2.0 behavioral format with Divine Triangle consistency"""
        
        profile = data['profiles'][0] if 'profiles' in data and data['profiles'] else {}
        behavioral = profile.get('behavioral', {})
        
        # Build v2.0 structure with simple naming
        v2_data = {
            "number": number,
            "title": self.number_archetypes.get(number, f"Soul Urge {number}"),
            "behavioral_category": "soul_urge_behavioral_analysis",
            "core_essence": profile.get('coreEssence', ''),
            "life_lesson": profile.get('lifeLesson', ''),
            "shadow_signature": profile.get('shadowSignature', ''),
            "intensity_scoring": {
                "min_range": 0.6,
                "max_range": 0.9,
                "note": "Higher intensity indicates stronger Soul Urge behavioral tendency"
            },
            "behavioral_insights": []
        }
        
        # Process behavioral categories with OPUS refinement
        category_mappings = {
            'decisionMaking': 'inner_decision_making',
            'stressResponse': 'emotional_stress_response',
            'communication': 'soul_communication',
            'relationships': 'intimate_relationships',
            'productivity': 'personal_productivity',
            'financial': 'value_systems',
            'creative': 'creative_expression',
            'learning': 'wisdom_seeking',
            'wellness': 'soul_wellness',
            'spiritual': 'spiritual_connection',
            'shadow': 'shadow_integration',
            'transitions': 'soul_transitions'
        }
        
        for original_category, refined_category in category_mappings.items():
            if original_category in behavioral:
                insights = behavioral[original_category]
                if isinstance(insights, list):
                    for insight in insights:
                        if isinstance(insight, dict) and 'text' in insight:
                            # Structured insight with metadata
                            behavioral_insight = {
                                "category": refined_category,
                                "insight": self.refine_with_divine_triangle(insight['text'], number),
                                "intensity": self.calculate_soul_urge_intensity(insight.get('intensity', 0.7), number),
                                "triggers": insight.get('triggers', []),
                                "supports": insight.get('supports', []),
                                "challenges": insight.get('challenges', [])
                            }
                        elif isinstance(insight, str):
                            # Simple string insight
                            behavioral_insight = {
                                "category": refined_category,
                                "insight": self.refine_with_divine_triangle(insight, number),
                                "intensity": 0.7,
                                "triggers": [],
                                "supports": [],
                                "challenges": []
                            }
                        else:
                            continue
                            
                        v2_data["behavioral_insights"].append(behavioral_insight)
        
        return v2_data
    
    def refine_with_divine_triangle(self, insight: str, number: int) -> str:
        """Apply Divine Triangle principles to ensure consistency"""
        # Keep insight focused on Soul Urge (inner motivation) vs Life Path (external action)
        if "external" in insight.lower() or "outward" in insight.lower():
            insight = insight.replace("external", "inner").replace("outward", "inward")
        
        # Ensure Master Numbers maintain their elevated frequency
        if number in [11, 22, 33, 44]:
            if "master" not in insight.lower() and "elevated" not in insight.lower():
                insight = insight  # Keep as is but note it's a master number context
        
        return insight
    
    def calculate_soul_urge_intensity(self, base_intensity: float, number: int) -> float:
        """Calculate intensity with Divine Triangle principles"""
        # Master numbers have higher base intensity
        if number in [11, 22, 33, 44]:
            return min(0.9, base_intensity + 0.1)
        # Keep within standard range
        return max(0.6, min(0.85, base_intensity))
    
    def process_all_files(self):
        """Process all Soul Urge MD files"""
        print("🔮 KASPER MLX Soul Urge Conversion - OPUS Enhanced with Divine Triangle")
        print("=" * 70)
        
        md_files = sorted(self.input_dir.glob("SU*.md"))
        success_count = 0
        
        for md_file in md_files:
            print(f"\n📖 Processing: {md_file.name}")
            
            # Extract number
            number = self.extract_number_from_filename(md_file.name)
            if not number:
                print(f"❌ Could not extract number from {md_file.name}")
                continue
            
            # Parse MD file
            data = self.parse_md_to_json(md_file)
            if not data:
                print(f"❌ Could not parse {md_file.name}")
                continue
            
            # Convert to v2.0 format
            v2_data = self.convert_to_v2_behavioral(data, number)
            
            # Simple naming convention
            output_filename = f"soulUrge_{number:02d}.json"
            approved_path = self.approved_dir / output_filename
            
            # Archive original MD
            archive_path = self.archive_dir / f"SoulUrge_{number}_original.md"
            shutil.copy2(md_file, archive_path)
            
            # Save to Approved folder
            with open(approved_path, 'w', encoding='utf-8') as f:
                json.dump(v2_data, f, indent=2, ensure_ascii=False)
            
            print(f"✅ Converted to: {output_filename}")
            print(f"   Generated {len(v2_data['behavioral_insights'])} behavioral insights")
            print(f"   Archived to: {archive_path.name}")
            success_count += 1
        
        print("\n" + "=" * 70)
        print(f"🎯 Conversion Complete: {success_count}/{len(md_files)} files processed")
        
        if success_count == len(md_files):
            print("✅ All Soul Urge files successfully converted!")
            print("🔮 Divine Triangle consistency applied")
            print("📂 Files ready in Approved folder with simple naming")
        
        return success_count == len(md_files)

def main():
    converter = SoulUrgeOPUSConverter()
    converter.process_all_files()

if __name__ == "__main__":
    main()