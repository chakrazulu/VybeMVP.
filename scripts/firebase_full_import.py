#!/usr/bin/env python3
"""
🔥 Full Firebase Import - Import ALL NumerologyData insights
Imports your complete 159k+ A+ quality insights corpus to Firebase
"""

import hashlib
import json
import os
import time
import urllib.parse
import urllib.request
from datetime import datetime

# Configuration
NUMEROLOGY_DATA_PATH = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData"
GOOGLE_SERVICE_INFO_PATH = (
    "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/GoogleService-Info.plist"
)
STAGING_COLLECTION = "insights_staging"
BATCH_DELAY = 0.1  # Small delay between uploads to be gentle on Firebase


def load_firebase_config():
    """Load Firebase config from GoogleService-Info.plist"""
    try:
        import plistlib

        with open(GOOGLE_SERVICE_INFO_PATH, "rb") as f:
            config = plistlib.load(f)

        project_id = config.get("PROJECT_ID")
        api_key = config.get("API_KEY")

        if not project_id or not api_key:
            print("❌ Missing PROJECT_ID or API_KEY in GoogleService-Info.plist")
            return None, None

        print(f"✅ Loaded Firebase config: {project_id}")
        return project_id, api_key
    except Exception as e:
        print(f"❌ Failed to load GoogleService-Info.plist: {e}")
        return None, None


def generate_insight_id(text, number, system):
    """Generate consistent ID for insights"""
    content = f"{text}_{number}_{system}"
    return hashlib.md5(content.encode()).hexdigest()


def determine_category(text):
    """Analyze text to determine category"""
    text_lower = text.lower()

    if any(word in text_lower for word in ["reflect", "contemplat", "ponder", "consider"]):
        return "reflection"
    elif any(word in text_lower for word in ["manifest", "create", "attract", "intention"]):
        return "manifestation"
    elif any(word in text_lower for word in ["challenge", "difficult", "obstacle", "overcome"]):
        return "challenge"
    elif any(word in text_lower for word in ["shadow", "dark", "hidden", "unconscious"]):
        return "shadow"
    elif any(word in text_lower for word in ["archetype", "pattern", "universal", "collective"]):
        return "archetype"
    elif any(word in text_lower for word in ["energy", "vibration", "frequency", "check"]):
        return "energy_check"
    elif any(word in text_lower for word in ["astro", "planet", "cosmic", "celestial"]):
        return "astrological"
    else:
        return "insight"


def determine_context(text):
    """Analyze text to determine context"""
    text_lower = text.lower()

    if any(word in text_lower for word in ["morning", "dawn", "awaken", "start", "begin"]):
        return "morning_awakening"
    elif any(word in text_lower for word in ["evening", "night", "reflect", "integration", "end"]):
        return "evening_integration"
    elif any(word in text_lower for word in ["crisis", "difficult", "struggle", "challenge"]):
        return "crisis"
    elif any(word in text_lower for word in ["celebrate", "joy", "success", "achievement"]):
        return "celebration"
    else:
        return "daily"


def extract_persona_from_filename(filename):
    """Extract persona from filename pattern"""
    filename_lower = filename.lower()

    if "oracle" in filename_lower:
        return "mystic_oracle"
    elif "psychologist" in filename_lower:
        return "soul_psychologist"
    elif "coach" in filename_lower or "mindfulness" in filename_lower:
        return "mindfulness_coach"
    elif "philosopher" in filename_lower:
        return "spiritual_philosopher"
    elif "healer" in filename_lower:
        return "sacred_healer"
    else:
        return "mystic_oracle"  # Default


def upload_insight(project_id, api_key, doc_id, doc_data):
    """Upload single insight to Firebase"""
    base_url = f"https://firestore.googleapis.com/v1/projects/{project_id}/databases/(default)/documents/{STAGING_COLLECTION}"

    # Convert to Firestore format
    firestore_doc = {"fields": {}}

    for key, value in doc_data.items():
        if isinstance(value, str):
            firestore_doc["fields"][key] = {"stringValue": value}
        elif isinstance(value, int):
            firestore_doc["fields"][key] = {"integerValue": str(value)}
        elif isinstance(value, float):
            firestore_doc["fields"][key] = {"doubleValue": value}

    # Make request
    url = f"{base_url}/{doc_id}?key={api_key}"

    try:
        data = json.dumps(firestore_doc).encode("utf-8")
        req = urllib.request.Request(url, data=data, method="PATCH")
        req.add_header("Content-Type", "application/json")

        with urllib.request.urlopen(req) as response:
            return response.status in [200, 201]
    except Exception as e:
        print(f"   ❌ Upload error: {e}")
        return False


def process_number_files(project_id, api_key):
    """Process all number meaning files"""
    number_path = os.path.join(NUMEROLOGY_DATA_PATH, "FirebaseNumberMeanings")
    if not os.path.exists(number_path):
        print(f"⚠️ Number path not found: {number_path}")
        return 0

    print(f"\n📊 Processing Number insights from {number_path}")
    total_uploaded = 0

    for filename in sorted(os.listdir(number_path)):
        if not filename.endswith(".json"):
            continue

        print(f"📁 Processing: {filename}")
        filepath = os.path.join(number_path, filename)
        persona = extract_persona_from_filename(filename)

        try:
            with open(filepath, "r", encoding="utf-8") as f:
                data = json.load(f)

            file_count = 0

            for number_str, content in data.items():
                if not number_str.isdigit():
                    continue

                number = int(number_str)
                insights_list = content.get("insight", [])

                if not isinstance(insights_list, list):
                    continue

                for insight_text in insights_list:
                    if not insight_text or len(insight_text.strip()) < 10:
                        continue

                    insight_id = generate_insight_id(insight_text, number, "number")

                    doc_data = {
                        "text": insight_text.strip(),
                        "system": "number",
                        "number": number,
                        "category": determine_category(insight_text),
                        "tier": "archetypal",
                        "persona": persona,
                        "context": determine_context(insight_text),
                        "quality_score": 0.95,  # High quality for your corpus
                        "created_at": datetime.now().isoformat(),
                    }

                    if upload_insight(project_id, api_key, insight_id, doc_data):
                        file_count += 1
                        total_uploaded += 1

                        if file_count % 50 == 0:
                            print(f"   ✅ {file_count} insights uploaded from {filename}")

                        time.sleep(BATCH_DELAY)  # Be gentle on Firebase

            print(f"   📊 Total from {filename}: {file_count} insights")

        except Exception as e:
            print(f"   ❌ Error processing {filename}: {e}")

    return total_uploaded


def process_planetary_files(project_id, api_key):
    """Process all planetary insight files"""
    planetary_path = os.path.join(NUMEROLOGY_DATA_PATH, "FirebasePlanetaryMeanings")
    if not os.path.exists(planetary_path):
        print(f"⚠️ Planetary path not found: {planetary_path}")
        return 0

    print(f"\n🪐 Processing Planetary insights from {planetary_path}")
    total_uploaded = 0

    for filename in sorted(os.listdir(planetary_path)):
        if not filename.endswith(".json"):
            continue

        print(f"📁 Processing: {filename}")
        filepath = os.path.join(planetary_path, filename)
        persona = extract_persona_from_filename(filename)

        # Extract planet name
        planet_name = "unknown"
        for planet in [
            "Sun",
            "Moon",
            "Mercury",
            "Venus",
            "Mars",
            "Jupiter",
            "Saturn",
            "Uranus",
            "Neptune",
            "Pluto",
        ]:
            if planet in filename:
                planet_name = planet.lower()
                break

        try:
            with open(filepath, "r", encoding="utf-8") as f:
                data = json.load(f)

            file_count = 0

            # Handle different planetary file structures
            if "insights" in data:
                insights_list = data["insights"]
            elif isinstance(data, list):
                insights_list = data
            else:
                continue

            for insight_item in insights_list:
                if isinstance(insight_item, dict):
                    insight_text = insight_item.get("text", insight_item.get("insight", ""))
                else:
                    insight_text = str(insight_item)

                if not insight_text or len(insight_text.strip()) < 10:
                    continue

                insight_id = generate_insight_id(insight_text, 0, f"planet_{planet_name}")

                doc_data = {
                    "text": insight_text.strip(),
                    "system": "planet",
                    "number": 0,  # Planets don't have numbers
                    "planet": planet_name,
                    "category": determine_category(insight_text),
                    "tier": "archetypal",
                    "persona": persona,
                    "context": determine_context(insight_text),
                    "quality_score": 0.95,
                    "created_at": datetime.now().isoformat(),
                }

                if upload_insight(project_id, api_key, insight_id, doc_data):
                    file_count += 1
                    total_uploaded += 1

                    if file_count % 25 == 0:
                        print(f"   ✅ {file_count} insights uploaded from {filename}")

                    time.sleep(BATCH_DELAY)

            print(f"   📊 Total from {filename}: {file_count} insights")

        except Exception as e:
            print(f"   ❌ Error processing {filename}: {e}")

    return total_uploaded


def process_zodiac_files(project_id, api_key):
    """Process all zodiac insight files"""
    zodiac_path = os.path.join(NUMEROLOGY_DATA_PATH, "FirebaseZodiacMeanings")
    if not os.path.exists(zodiac_path):
        print(f"⚠️ Zodiac path not found: {zodiac_path}")
        return 0

    print(f"\n♈ Processing Zodiac insights from {zodiac_path}")
    total_uploaded = 0

    signs = [
        "Aries",
        "Taurus",
        "Gemini",
        "Cancer",
        "Leo",
        "Virgo",
        "Libra",
        "Scorpio",
        "Sagittarius",
        "Capricorn",
        "Aquarius",
        "Pisces",
    ]

    for filename in sorted(os.listdir(zodiac_path)):
        if not filename.endswith(".json"):
            continue

        print(f"📁 Processing: {filename}")
        filepath = os.path.join(zodiac_path, filename)
        persona = extract_persona_from_filename(filename)

        # Extract sign name
        sign_name = "unknown"
        for sign in signs:
            if sign in filename:
                sign_name = sign.lower()
                break

        try:
            with open(filepath, "r", encoding="utf-8") as f:
                data = json.load(f)

            file_count = 0

            if "insights" in data:
                insights_list = data["insights"]
            elif isinstance(data, list):
                insights_list = data
            else:
                continue

            for insight_item in insights_list:
                if isinstance(insight_item, dict):
                    insight_text = insight_item.get("text", insight_item.get("insight", ""))
                else:
                    insight_text = str(insight_item)

                if not insight_text or len(insight_text.strip()) < 10:
                    continue

                insight_id = generate_insight_id(insight_text, 0, f"zodiac_{sign_name}")

                doc_data = {
                    "text": insight_text.strip(),
                    "system": "zodiac",
                    "number": 0,
                    "zodiac_sign": sign_name,
                    "category": determine_category(insight_text),
                    "tier": "archetypal",
                    "persona": persona,
                    "context": determine_context(insight_text),
                    "quality_score": 0.95,
                    "created_at": datetime.now().isoformat(),
                }

                if upload_insight(project_id, api_key, insight_id, doc_data):
                    file_count += 1
                    total_uploaded += 1

                    if file_count % 25 == 0:
                        print(f"   ✅ {file_count} insights uploaded from {filename}")

                    time.sleep(BATCH_DELAY)

            print(f"   📊 Total from {filename}: {file_count} insights")

        except Exception as e:
            print(f"   ❌ Error processing {filename}: {e}")

    return total_uploaded


def main():
    """Main import function"""
    print("🔥 Starting FULL Firebase NumerologyData Import")
    print("=" * 60)
    print(f"📂 Source: {NUMEROLOGY_DATA_PATH}")
    print(f"🎯 Target: {STAGING_COLLECTION}")

    # Load Firebase config
    project_id, api_key = load_firebase_config()
    if not project_id:
        return

    start_time = time.time()
    total_insights = 0

    try:
        # Process all insight types
        total_insights += process_number_files(project_id, api_key)
        total_insights += process_planetary_files(project_id, api_key)
        total_insights += process_zodiac_files(project_id, api_key)

        end_time = time.time()
        duration = end_time - start_time

        print("\n🎉 IMPORT COMPLETE!")
        print(f"📊 Total insights imported: {total_insights:,}")
        print(f"⏱️ Duration: {duration:.1f} seconds")
        print(f"🚀 Rate: {total_insights/duration:.1f} insights/second")
        print(f"💰 Estimated cost: ~${total_insights * 0.0000018:.4f}")
        print(f"🎯 Collection: {STAGING_COLLECTION}")

        print("\n✅ Ready for next steps:")
        print("1. Check Firebase Console → Firestore → insights_staging")
        print("2. Test with Swift FirebaseInsightRepository")
        print("3. Promote selected insights to insights_prod")
        print("4. Wire into Cosmic HUD & match notifications")

    except KeyboardInterrupt:
        print("\n⚠️ Import interrupted by user")
        print(f"📊 Partial import: {total_insights:,} insights uploaded")
    except Exception as e:
        print(f"\n❌ Import failed: {e}")


if __name__ == "__main__":
    main()
