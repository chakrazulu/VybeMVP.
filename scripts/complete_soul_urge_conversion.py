#!/usr/bin/env python3
"""
Complete Soul Urge Conversion - Final step
Process remaining Soul Urge files with direct smart quote fix
"""

import json
import re
from pathlib import Path

def complete_soul_urge_conversion():
    """Complete the Soul Urge conversion for remaining numbers"""
    
    input_dir = Path("/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/ImportedContent/SoulUrgeContent")
    output_dir = Path("/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/KASPERMLX/MLXTraining/ContentRefinery/Approved")
    
    # Check what's already done
    existing_files = list(output_dir.glob("soulUrge_*_v2.0_converted.json"))
    existing_numbers = set()
    for f in existing_files:
        match = re.search(r'soulUrge_(\d+)_v2.0_converted.json', f.name)
        if match:
            existing_numbers.add(int(match.group(1)))
    
    # Numbers to process
    all_numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33, 44]
    remaining_numbers = [n for n in all_numbers if n not in existing_numbers]
    
    print("🔮 COMPLETE SOUL URGE CONVERSION")
    print("=" * 50)
    print(f"✅ Already converted: {sorted(existing_numbers)}")
    print(f"🔄 Remaining to convert: {remaining_numbers}")
    
    if not remaining_numbers:
        print("🎉 All Soul Urge files already converted!")
        return
    
    successful = 0
    
    for number in remaining_numbers:
        input_file = input_dir / f"SU{number}.md"
        output_file = output_dir / f"soulUrge_{number:02d}_v2.0_converted.json"
        
        if not input_file.exists():
            print(f"❌ Source file not found: SU{number}.md")
            continue
            
        try:
            print(f"Processing SU{number}.md...")
            
            # Read as bytes first to handle smart quote encoding
            raw_bytes = input_file.read_bytes()
            
            # Fix smart quotes at byte level
            raw_bytes = raw_bytes.replace(b'\xe2\x80\x9c', b'"')  # Left double quote
            raw_bytes = raw_bytes.replace(b'\xe2\x80\x9d', b'"')  # Right double quote  
            raw_bytes = raw_bytes.replace(b'\xe2\x80\x98', b"'")  # Left single quote
            raw_bytes = raw_bytes.replace(b'\xe2\x80\x99', b"'")  # Right single quote
            
            # Convert back to string
            content = raw_bytes.decode('utf-8')
            
            # Remove MD headers
            content = re.sub(r'^# SU\d+\s*\n\s*## SU\d+\s*\n', '', content)
            
            # Fix escaped brackets
            content = content.replace('\\[', '[').replace('\\]', ']')
            
            # Remove newlines between JSON properties
            lines = [line.strip() for line in content.split('\n') if line.strip()]
            compact_json = ''.join(lines)
            
            # Fix common JSON structure issues
            compact_json = re.sub(r'":"', '": "', compact_json)
            compact_json = re.sub(r'":(\d)', r'": \1', compact_json)
            compact_json = re.sub(r'":({|\[)', r'": \1', compact_json)
            
            # Fix missing quotes in specific patterns
            compact_json = re.sub(r'"([^"]*?)\s*}\s*,', r'"\1" },', compact_json)  # Fix missing quotes before }
            compact_json = re.sub(r'"([^"]*?)\s*]\s*,', r'"\1" ],', compact_json)  # Fix missing quotes before ]
            
            # Fix any standalone unquoted text before delimiters
            compact_json = re.sub(r':\s*([^",\[\{\}]+)\s*([,\}\]])', r': "\1" \2', compact_json)
            
            # Parse JSON
            soul_urge_data = json.loads(compact_json)
            
            # Convert to v2.0 format (keep original structure for now)
            profile = soul_urge_data['profiles'][0]
            
            v2_data = {
                "number": number,
                "title": f"Soul Urge {number}",
                "behavioral_category": "soul_urge_behavioral_analysis",
                "meta": soul_urge_data.get('meta', {}),
                "profile": profile,
                "behavioral_insights": []
            }
            
            # Extract behavioral insights
            if 'behavioral' in profile:
                for category, insights in profile['behavioral'].items():
                    for insight in insights:
                        behavioral_insight = {
                            "category": category,
                            "text": insight["text"],
                            "intensity": insight.get("intensity", 0.75)
                        }
                        
                        # Add optional fields
                        for field in ["triggers", "supports", "challenges"]:
                            if field in insight:
                                behavioral_insight[field] = insight[field]
                        
                        v2_data["behavioral_insights"].append(behavioral_insight)
            
            # Write output
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(v2_data, f, indent=2, ensure_ascii=False)
            
            insight_count = len(v2_data["behavioral_insights"])
            print(f"✅ Created soulUrge_{number:02d}_v2.0_converted.json")
            print(f"   {insight_count} behavioral insights")
            
            successful += 1
            
        except Exception as e:
            print(f"❌ Error processing SU{number}.md: {e}")
            continue
    
    total_converted = len(existing_numbers) + successful
    print("\n" + "=" * 50)
    print(f"🎯 SOUL URGE CONVERSION COMPLETE")
    print(f"✅ New conversions: {successful}")
    print(f"🔮 Total Soul Urge files: {total_converted}/13")
    
    if total_converted == 13:
        print("🎉 ALL SOUL URGE FILES CONVERTED!")
        print("🔮 Soul Urge v2.0 behavioral corpus ready for KASPER MLX!")
    
    return total_converted

if __name__ == "__main__":
    complete_soul_urge_conversion()