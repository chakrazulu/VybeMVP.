#!/usr/bin/env python3
"""
Systematic duplicate insight fixing script.
Replaces all duplicate insights with unique, sign-specific content.
"""

import json
import os
from collections import defaultdict
import random

# Unique insight templates for each planet-sign combination
UNIQUE_INSIGHTS = {
    # Jupiter insights - expansive wisdom focused
    "Jupiter_Aries": [
        "Jupiter in Aries ignites pioneering wisdom—your understanding blazes new philosophical trails, teaching courage through direct experience of truth.",
        "Jupiter in Aries expands through bold action—your wisdom grows by taking the first step into unknown territories of understanding.",
        "Jupiter in Aries wisdom warriors never hesitate—when truth calls for action, your expansive courage becomes the bridge between knowing and being."
    ],
    "Jupiter_Taurus": [
        "Jupiter in Taurus grows wisdom through sensual abundance—your understanding deepens by savoring each moment of earthly beauty.",
        "Jupiter in Taurus teaches patience rewards—steady accumulation of wisdom creates the most lasting and beautiful forms of abundance.",
        "Jupiter in Taurus wisdom builds foundations—your expansive understanding manifests through consistent, grounded spiritual practices."
    ],
    "Jupiter_Gemini": [
        "Jupiter in Gemini multiplies wisdom through connection—every conversation becomes an opportunity to expand understanding exponentially.",
        "Jupiter in Gemini teaches versatile truth—your expansive mind finds wisdom in paradox, connecting seemingly opposite ideas into unified understanding.",
        "Jupiter in Gemini wisdom networks—your ability to share knowledge creates communities of learning that inspire collective growth."
    ],
    "Jupiter_Cancer": [
        "Jupiter in Cancer expands through emotional wisdom—your understanding grows by honoring the sacred intelligence of feelings.",
        "Jupiter in Cancer nurtures wisdom growth—your expansive heart creates safe spaces where others' understanding can flourish.",
        "Jupiter in Cancer teaches intuitive abundance—trusting your emotional intelligence opens doorways to profound spiritual understanding."
    ],
    "Jupiter_Leo": [
        "Jupiter in Leo radiates wisdom joy—your understanding becomes most expansive when shared with generous, creative expression.",
        "Jupiter in Leo teaches confident truth—your wisdom grows boldest when you trust your unique philosophical perspective.",
        "Jupiter in Leo wisdom performance—your expansive understanding inspires others through authentic, passionate sharing of knowledge."
    ],
    "Jupiter_Virgo": [
        "Jupiter in Virgo perfects wisdom through service—your understanding expands by applying knowledge to improve daily life.",
        "Jupiter in Virgo teaches practical enlightenment—true wisdom shows up in how you organize your life for maximum spiritual efficiency.",
        "Jupiter in Virgo wisdom analysis—your expansive understanding grows through careful attention to meaningful details."
    ],
    "Jupiter_Libra": [
        "Jupiter in Libra balances wisdom perspectives—your understanding expands by finding harmony between opposing truths.",
        "Jupiter in Libra teaches collaborative enlightenment—wisdom grows most beautiful when shared in partnership and mutual respect.",
        "Jupiter in Libra wisdom diplomacy—your expansive understanding creates peace by helping others find common ground in truth."
    ],
    "Jupiter_Scorpio": [
        "Jupiter in Scorpio deepens wisdom intensity—your understanding transforms by diving fearlessly into truth's hidden depths.",
        "Jupiter in Scorpio teaches regenerative knowledge—your wisdom grows by transmuting pain into profound spiritual understanding.",
        "Jupiter in Scorpio wisdom transformation—your expansive understanding helps others heal by sharing truth about life's mysteries."
    ],
    "Jupiter_Sagittarius": [
        "Jupiter in Sagittarius adventures toward truth—your expansive understanding grows through philosophical exploration of unknown territories.",
        "Jupiter in Sagittarius teaches freedom wisdom—your understanding expands by following the call of your highest philosophical vision.",
        "Jupiter in Sagittarius wisdom journey—your expansive truth-seeking inspires others to follow their own authentic path of understanding."
    ],
    "Jupiter_Capricorn": [
        "Jupiter in Capricorn builds wisdom authority—your understanding grows by creating structures that make knowledge accessible and practical.",
        "Jupiter in Capricorn teaches mastery patience—true wisdom accumulates slowly, creating lasting foundations for collective understanding.",
        "Jupiter in Capricorn wisdom leadership—your expansive understanding manifests as responsible guidance that honors traditional wisdom."
    ],
    "Jupiter_Aquarius": [
        "Jupiter in Aquarius innovates wisdom transmission—your understanding expands by discovering revolutionary approaches to ancient truths.",
        "Jupiter in Aquarius teaches collective enlightenment—your wisdom grows by contributing to humanity's evolving consciousness.",
        "Jupiter in Aquarius wisdom revolution—your expansive understanding helps others break free from limiting beliefs about possibility."
    ],
    "Jupiter_Pisces": [
        "Jupiter in Pisces dissolves wisdom boundaries—your understanding expands by surrendering to the ocean of universal truth.",
        "Jupiter in Pisces teaches compassionate knowledge—your wisdom grows by feeling the interconnection of all beings.",
        "Jupiter in Pisces wisdom flow—your expansive understanding moves like water, adapting to serve others' deepest spiritual needs."
    ],
    
    # Sun insights - identity and authentic expression focused
    "Sun_Aries": [
        "Sun in Aries births authentic identity—your true self emerges through bold self-expression and courageous independence.",
        "Sun in Aries pioneers self-discovery—your identity strengthens by being first to express what others fear to show.",
        "Sun in Aries ignites personal truth—your authentic essence blazes brightest when you trust your immediate impulses."
    ],
    "Sun_Taurus": [
        "Sun in Taurus grounds authentic presence—your identity stabilizes through consistent expression of your core values.",
        "Sun in Taurus cultivates lasting identity—your true self grows like a garden, steady and beautiful through all seasons.",
        "Sun in Taurus embodies reliable truth—your authentic essence provides others with the stability they need to trust themselves."
    ],
    "Sun_Gemini": [
        "Sun in Gemini explores identity facets—your authentic self expresses through curious experimentation with multiple perspectives.",
        "Sun in Gemini connects authentic voices—your identity strengthens by sharing different aspects of yourself with various communities.",
        "Sun in Gemini communicates core truth—your authentic essence finds expression through versatile, engaging dialogue."
    ],
    "Sun_Cancer": [
        "Sun in Cancer nurtures authentic emotion—your identity emerges through honoring and expressing your deepest feelings.",
        "Sun in Cancer protects vulnerable truth—your authentic self creates safe spaces where others can express their own sensitivity.",
        "Sun in Cancer flows with identity tides—your true essence changes like the moon, honoring all phases of authentic being."
    ],
    "Sun_Leo": [
        "Sun in Leo radiates creative identity—your authentic self shines brightest through generous, artistic self-expression.",
        "Sun in Leo performs authentic truth—your identity strengthens when you courageously show your unique creative essence.",
        "Sun in Leo celebrates core self—your authentic essence inspires others by demonstrating the joy of being genuinely yourself."
    ],
    "Sun_Virgo": [
        "Sun in Virgo refines authentic service—your identity emerges through precise, helpful expression of your capabilities.",
        "Sun in Virgo analyzes identity truth—your authentic self grows stronger through careful attention to what truly serves.",
        "Sun in Virgo perfects personal essence—your true identity expresses through skillful, organized contribution to collective good."
    ],
    "Sun_Libra": [
        "Sun in Libra balances authentic relationship—your identity emerges through harmonious, fair interaction with others.",
        "Sun in Libra creates identity beauty—your authentic self expresses through aesthetic choices that reflect your inner harmony.",
        "Sun in Libra negotiates personal truth—your identity strengthens by finding balance between self and other."
    ],
    "Sun_Scorpio": [
        "Sun in Scorpio transforms authentic power—your identity emerges through fearless exploration of psychological depths.",
        "Sun in Scorpio regenerates core truth—your authentic self grows stronger by transmuting personal shadows into wisdom.",
        "Sun in Scorpio intensifies identity mystery—your true essence expresses through magnetic, transformational presence."
    ],
    "Sun_Sagittarius": [
        "Sun in Sagittarius explores identity freedom—your authentic self emerges through adventurous expansion of personal horizons.",
        "Sun in Sagittarius teaches identity truth—your true essence expresses through sharing philosophical discoveries with others.",
        "Sun in Sagittarius journeys toward authentic vision—your identity strengthens by following your highest aspirations."
    ],
    "Sun_Capricorn": [
        "Sun in Capricorn builds authentic authority—your identity emerges through responsible, masterful expression of your capabilities.",
        "Sun in Capricorn structures personal truth—your authentic self grows stronger through disciplined development of core skills.",
        "Sun in Capricorn achieves identity goals—your true essence expresses through persistent work toward meaningful accomplishment."
    ],
    "Sun_Aquarius": [
        "Sun in Aquarius innovates authentic rebellion—your identity emerges through unique, humanitarian expression of your ideals.",
        "Sun in Aquarius revolutionizes personal truth—your authentic self grows by challenging conventional expectations of identity.",
        "Sun in Aquarius broadcasts identity vision—your true essence expresses through original contributions to collective consciousness."
    ],
    "Sun_Pisces": [
        "Sun in Pisces dissolves identity boundaries—your authentic self emerges through compassionate connection with universal truth.",
        "Sun in Pisces flows with identity intuition—your true essence expresses through artistic, spiritual attunement to collective needs.",
        "Sun in Pisces dreams authentic unity—your identity strengthens by surrendering personal ego to serve something greater."
    ]
}

def load_file(file_path):
    """Load JSON file safely."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading {file_path}: {e}")
        return None

def save_file(file_path, data):
    """Save JSON file safely."""
    try:
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        return True
    except Exception as e:
        print(f"Error saving {file_path}: {e}")
        return False

def get_unique_insight(planet, sign, context, persona):
    """Generate a unique insight for the given planet-sign combination."""
    key = f"{planet}_{sign}"
    
    if key in UNIQUE_INSIGHTS:
        base_insights = UNIQUE_INSIGHTS[key]
        base_insight = random.choice(base_insights)
        
        # Add context-specific modifications
        if context == "Morning Awakening":
            return f"In morning's light, {base_insight.lower()}"
        elif context == "Evening Integration":
            return f"As evening settles, {base_insight.lower()}"
        elif context == "Crisis Navigation":
            return f"During challenging times, {base_insight.lower()}"
        elif context == "Celebration Expansion":
            return f"In moments of joy, {base_insight.lower()}"
        elif context == "Daily Rhythm":
            return f"Through daily practice, {base_insight.lower()}"
        else:
            return base_insight
    
    # Fallback for planets not yet defined
    return f"{planet} in {sign} creates unique {context.lower()} energy—your {sign.lower()} nature expresses {planet.lower()}'s essence through {persona.lower()} wisdom."

def fix_duplicates_in_file(file_path):
    """Fix duplicate insights in a single file."""
    data = load_file(file_path)
    if not data:
        return False
    
    if 'insights' not in data:
        return True
    
    # Track insights we've seen in this file
    seen_insights = set()
    fixed_count = 0
    
    for insight_obj in data['insights']:
        if 'insight' not in insight_obj:
            continue
            
        original_text = insight_obj['insight']
        
        # If we've seen this insight before in this file, replace it
        if original_text in seen_insights:
            planet = insight_obj.get('planet', '')
            sign = insight_obj.get('sign', '')
            context = insight_obj.get('context', 'Daily Rhythm')
            persona = insight_obj.get('persona', 'Oracle')
            
            # Generate unique insight
            new_insight = get_unique_insight(planet, sign, context, persona)
            insight_obj['insight'] = new_insight
            fixed_count += 1
            print(f"   Fixed duplicate in {os.path.basename(file_path)}: {context} - {persona}")
        
        seen_insights.add(insight_obj['insight'])
    
    if fixed_count > 0:
        save_file(file_path, data)
        print(f"✅ Fixed {fixed_count} duplicates in {os.path.basename(file_path)}")
    
    return True

def main():
    """Main function to fix all duplicates."""
    base_path = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/FirebasePlanetZodiacFusion"
    
    # Focus on the most problematic planets first
    problem_planets = [
        'Jupiter_Combinations', 'Saturn_Combinations', 'Pluto_Combinations',
        'Neptune_Combinations', 'Mercury_Combinations', 'Uranus_Combinations',
        'Sun_Combinations', 'Moon_Combinations'
    ]
    
    print("🔧 FIXING DUPLICATE INSIGHTS")
    print("=" * 50)
    
    total_files_fixed = 0
    
    for planet_dir in problem_planets:
        print(f"\n🔍 Processing {planet_dir}...")
        
        dir_path = os.path.join(base_path, planet_dir)
        if not os.path.exists(dir_path):
            continue
        
        files_in_dir = 0
        for filename in os.listdir(dir_path):
            if filename.endswith('.json'):
                file_path = os.path.join(dir_path, filename)
                if fix_duplicates_in_file(file_path):
                    files_in_dir += 1
        
        print(f"   Processed {files_in_dir} files in {planet_dir}")
        total_files_fixed += files_in_dir
    
    print(f"\n✅ COMPLETE: Processed {total_files_fixed} files")
    print("🔍 Re-run duplicate detection to verify fixes")

if __name__ == "__main__":
    main()