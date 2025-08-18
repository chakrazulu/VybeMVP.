#!/usr/bin/env python3
"""
🔥 Number Insights Import - Fast import of 9,483 number insights
"""

import hashlib
import json
import os
import time
import urllib.request
from datetime import datetime

# Configuration
NUMEROLOGY_DATA_PATH = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData"
GOOGLE_SERVICE_INFO_PATH = (
    "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/GoogleService-Info.plist"
)
STAGING_COLLECTION = "insights_staging"


def load_firebase_config():
    """Load Firebase config"""
    try:
        import plistlib

        with open(GOOGLE_SERVICE_INFO_PATH, "rb") as f:
            config = plistlib.load(f)
        return config.get("PROJECT_ID"), config.get("API_KEY")
    except Exception as e:
        print(f"❌ Firebase config error: {e}")
        return None, None


def extract_persona_from_filename(filename):
    """Extract persona from filename"""
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
        return "mystic_oracle"


def determine_category(text):
    """Determine category from content"""
    text_lower = text.lower()
    if any(word in text_lower for word in ["reflect", "contemplat"]):
        return "reflection"
    elif any(word in text_lower for word in ["manifest", "create"]):
        return "manifestation"
    elif any(word in text_lower for word in ["challenge", "difficult"]):
        return "challenge"
    else:
        return "insight"


def determine_context(text):
    """Determine context from content"""
    text_lower = text.lower()
    if any(word in text_lower for word in ["morning", "dawn"]):
        return "morning_awakening"
    elif any(word in text_lower for word in ["evening", "night"]):
        return "evening_integration"
    else:
        return "daily"


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

    url = f"{base_url}/{doc_id}?key={api_key}"

    try:
        data = json.dumps(firestore_doc).encode("utf-8")
        req = urllib.request.Request(url, data=data, method="PATCH")
        req.add_header("Content-Type", "application/json")

        with urllib.request.urlopen(req) as response:
            return response.status in [200, 201]
    except Exception:
        return False


def import_number_insights():
    """Import all number insights with progress"""

    print("🔥 Starting Number Insights Import")
    print("=" * 40)

    # Load Firebase config
    project_id, api_key = load_firebase_config()
    if not project_id:
        return

    number_path = os.path.join(NUMEROLOGY_DATA_PATH, "FirebaseNumberMeanings")
    if not os.path.exists(number_path):
        print(f"❌ Path not found: {number_path}")
        return

    uploaded = 0
    errors = 0
    start_time = time.time()
    total_expected = 9483  # We know the count

    print(f"🎯 Target: {total_expected:,} insights → {STAGING_COLLECTION}")
    print("Press Ctrl+C to safely stop\n")

    try:
        for filename in sorted(os.listdir(number_path)):
            if not filename.endswith(".json") or filename == "personalized_insight_templates.json":
                continue

            print(f"📁 {filename}")
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

                    for insight_text in insights_list:
                        if not insight_text or len(insight_text.strip()) < 10:
                            continue

                        # Generate unique ID
                        insight_id = hashlib.md5(
                            f"{insight_text}_{number}_number".encode()
                        ).hexdigest()

                        # Create document
                        doc_data = {
                            "text": insight_text.strip(),
                            "system": "number",
                            "number": number,
                            "category": determine_category(insight_text),
                            "tier": "archetypal",
                            "persona": persona,
                            "context": determine_context(insight_text),
                            "quality_score": 0.95,
                            "created_at": datetime.now().isoformat(),
                        }

                        # Upload
                        if upload_insight(project_id, api_key, insight_id, doc_data):
                            uploaded += 1
                            file_count += 1
                        else:
                            errors += 1

                        # Progress every 50 insights
                        if uploaded % 50 == 0:
                            elapsed = time.time() - start_time
                            rate = uploaded / elapsed if elapsed > 0 else 0
                            eta = (total_expected - uploaded) / rate if rate > 0 else 0
                            print(
                                f"   ⚡ {uploaded:,}/{total_expected:,} ({uploaded/total_expected*100:.1f}%) | {rate:.1f}/sec | ETA: {eta/60:.1f}m"
                            )

                        time.sleep(0.02)  # Gentle rate limiting

                print(f"   ✅ {file_count:,} insights from {filename}")

            except Exception as e:
                print(f"   ❌ Error in {filename}: {e}")
                errors += 1

        # Final stats
        elapsed = time.time() - start_time
        print("\n🎉 Import Complete!")
        print(f"✅ Uploaded: {uploaded:,}/{total_expected:,}")
        print(f"❌ Errors: {errors}")
        print(f"⏱️ Duration: {elapsed:.1f} seconds")
        print(f"🚀 Rate: {uploaded/elapsed:.1f} insights/second")
        print(f"💰 Cost: ~${uploaded * 0.0000018:.4f}")

        print("\n📱 Next Steps:")
        print("1. Check Firebase Console → insights_staging")
        print("2. Test Swift FirebaseInsightRepository")
        print("3. Create insights_prod promotion")

    except KeyboardInterrupt:
        print("\n⚠️ Import interrupted")
        print(f"📊 Partial: {uploaded:,} uploaded, {errors} errors")


if __name__ == "__main__":
    import_number_insights()
