#!/usr/bin/env python3
"""
Identify the most common duplicate patterns for targeted fixing.
"""

import json
import os
from collections import defaultdict

def extract_insights_from_file(file_path):
    """Extract all insights from a JSON file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        insights = []
        if 'insights' in data:
            for insight_obj in data['insights']:
                if 'insight' in insight_obj:
                    insights.append({
                        'text': insight_obj['insight'].strip(),
                        'planet': insight_obj.get('planet', ''),
                        'sign': insight_obj.get('sign', ''),
                        'context': insight_obj.get('context', ''),
                        'persona': insight_obj.get('persona', ''),
                        'file': os.path.basename(file_path)
                    })
        return insights
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return []

def main():
    """Identify most common duplicate patterns."""
    base_path = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/FirebasePlanetZodiacFusion"
    
    planet_dirs = [
        'Jupiter_Combinations', 'Saturn_Combinations', 'Pluto_Combinations',
        'Neptune_Combinations', 'Mercury_Combinations', 'Uranus_Combinations',
        'Sun_Combinations', 'Moon_Combinations'
    ]
    
    insights_by_text = defaultdict(list)
    
    print("🔍 COMMON DUPLICATE PATTERN ANALYSIS")
    print("=" * 50)
    
    # Extract insights from problem planets only
    for planet_dir in planet_dirs:
        dir_path = os.path.join(base_path, planet_dir)
        if not os.path.exists(dir_path):
            continue
            
        for filename in os.listdir(dir_path):
            if filename.endswith('.json'):
                file_path = os.path.join(dir_path, filename)
                insights = extract_insights_from_file(file_path)
                
                for insight in insights:
                    insights_by_text[insight['text']].append(insight)
    
    # Find duplicates and sort by frequency
    exact_duplicates = {text: insights for text, insights in insights_by_text.items() if len(insights) > 1}
    
    # Sort by most common patterns
    sorted_duplicates = sorted(exact_duplicates.items(), key=lambda x: len(x[1]), reverse=True)
    
    print(f"📊 TOP 10 MOST COMMON DUPLICATE PATTERNS:")
    print("-" * 60)
    
    for i, (text, duplicates) in enumerate(sorted_duplicates[:10], 1):
        planets_affected = set(dup['planet'] for dup in duplicates)
        signs_affected = set(dup['sign'] for dup in duplicates)
        contexts_affected = set(dup['context'] for dup in duplicates)
        
        print(f"\n🔥 PATTERN #{i}: ({len(duplicates)} instances)")
        print(f"Planets: {', '.join(sorted(planets_affected))}")
        print(f"Signs: {', '.join(sorted(signs_affected))}")
        print(f"Contexts: {', '.join(sorted(contexts_affected))}")
        print(f"Text: {text[:100]}...")
        print("-" * 40)
    
    # Analyze by template structure
    print(f"\n🎯 TEMPLATE ANALYSIS:")
    template_patterns = {
        'celebration wisdom teaches': 0,
        'awakens as': 0,
        'under full moon': 0,
        'in daily flow teaches': 0,
        'retrograde—in evening': 0,
        'wisdom integrates': 0,
        'transforms celebration into': 0,
        'in crisis becomes': 0
    }
    
    for text in exact_duplicates.keys():
        for pattern in template_patterns.keys():
            if pattern in text.lower():
                template_patterns[pattern] += 1
    
    print("Template phrase frequencies:")
    for pattern, count in sorted(template_patterns.items(), key=lambda x: x[1], reverse=True):
        if count > 0:
            print(f"   '{pattern}': {count} duplicate sets")
    
    print(f"\n📋 SUMMARY:")
    print(f"Total duplicate patterns: {len(exact_duplicates)}")
    print(f"Most duplicated pattern appears {len(sorted_duplicates[0][1])} times")
    print(f"Average duplication per pattern: {sum(len(dups) for dups in exact_duplicates.values()) / len(exact_duplicates):.1f}")

if __name__ == "__main__":
    main()