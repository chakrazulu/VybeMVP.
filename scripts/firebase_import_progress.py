#!/usr/bin/env python3
"""
🔥 Firebase Import with Progress - Shows live progress every 10 insights
Safe to interrupt and resume
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
BATCH_DELAY = 0.05  # Faster uploads
PROGRESS_INTERVAL = 10  # Show progress every 10 insights


def load_firebase_config():
    """Load Firebase config"""
    try:
        import plistlib

        with open(GOOGLE_SERVICE_INFO_PATH, "rb") as f:
            config = plistlib.load(f)
        return config.get("PROJECT_ID"), config.get("API_KEY")
    except Exception as e:
        print(f"❌ Failed to load Firebase config: {e}")
        return None, None


def count_total_insights():
    """Count total insights before importing"""
    print("📊 Counting total insights...")

    total = 0

    # Count Numbers
    number_path = os.path.join(NUMEROLOGY_DATA_PATH, "FirebaseNumberMeanings")
    if os.path.exists(number_path):
        for filename in os.listdir(number_path):
            if filename.endswith(".json"):
                try:
                    with open(os.path.join(number_path, filename), "r") as f:
                        data = json.load(f)
                    for number_str, content in data.items():
                        if number_str.isdigit():
                            insights = content.get("insight", [])
                            total += len(insights)
                except Exception:
                    continue

    # Count Planetary
    planetary_path = os.path.join(NUMEROLOGY_DATA_PATH, "FirebasePlanetaryMeanings")
    if os.path.exists(planetary_path):
        for filename in os.listdir(planetary_path):
            if filename.endswith(".json"):
                try:
                    with open(os.path.join(planetary_path, filename), "r") as f:
                        data = json.load(f)
                    if "insights" in data:
                        total += len(data["insights"])
                    elif isinstance(data, list):
                        total += len(data)
                except Exception:
                    continue

    # Count Zodiac
    zodiac_path = os.path.join(NUMEROLOGY_DATA_PATH, "FirebaseZodiacMeanings")
    if os.path.exists(zodiac_path):
        for filename in os.listdir(zodiac_path):
            if filename.endswith(".json"):
                try:
                    with open(os.path.join(zodiac_path, filename), "r") as f:
                        data = json.load(f)
                    if "insights" in data:
                        total += len(data["insights"])
                    elif isinstance(data, list):
                        total += len(data)
                except Exception:
                    continue

    print(f"📊 Total insights found: {total:,}")
    return total


def upload_insight(project_id, api_key, doc_id, doc_data):
    """Upload single insight"""
    base_url = f"https://firestore.googleapis.com/v1/projects/{project_id}/databases/(default)/documents/{STAGING_COLLECTION}"

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


def import_with_progress(project_id, api_key, total_expected):
    """Import with live progress updates"""

    uploaded = 0
    errors = 0
    start_time = time.time()

    def show_progress():
        elapsed = time.time() - start_time
        rate = uploaded / elapsed if elapsed > 0 else 0
        eta = (total_expected - uploaded) / rate if rate > 0 else 0
        print(
            f"⚡ {uploaded:,}/{total_expected:,} ({uploaded/total_expected*100:.1f}%) | {rate:.1f}/sec | ETA: {eta/60:.1f}m | Errors: {errors}"
        )

    # Process Numbers
    number_path = os.path.join(NUMEROLOGY_DATA_PATH, "FirebaseNumberMeanings")
    if os.path.exists(number_path):
        print("\n📊 Processing Numbers...")

        for filename in sorted(os.listdir(number_path)):
            if not filename.endswith(".json"):
                continue

            print(f"📁 {filename}")

            try:
                with open(os.path.join(number_path, filename), "r") as f:
                    data = json.load(f)

                for number_str, content in data.items():
                    if not number_str.isdigit():
                        continue

                    number = int(number_str)
                    insights_list = content.get("insight", [])

                    for insight_text in insights_list:
                        if not insight_text or len(insight_text.strip()) < 10:
                            continue

                        insight_id = hashlib.md5(
                            f"{insight_text}_{number}_number".encode()
                        ).hexdigest()

                        doc_data = {
                            "text": insight_text.strip(),
                            "system": "number",
                            "number": number,
                            "category": "insight",
                            "tier": "archetypal",
                            "persona": "mystic_oracle",
                            "context": "daily",
                            "quality_score": 0.95,
                            "created_at": datetime.now().isoformat(),
                        }

                        if upload_insight(project_id, api_key, insight_id, doc_data):
                            uploaded += 1
                        else:
                            errors += 1

                        if uploaded % PROGRESS_INTERVAL == 0:
                            show_progress()

                        time.sleep(BATCH_DELAY)

            except Exception as e:
                print(f"   ❌ Error: {e}")
                errors += 1

    # Final progress
    show_progress()
    print("\n🎉 Import Complete!")
    print(f"✅ Uploaded: {uploaded:,}")
    print(f"❌ Errors: {errors}")

    return uploaded, errors


def main():
    """Main function"""
    print("🔥 Firebase Import with Progress")
    print("=" * 40)

    project_id, api_key = load_firebase_config()
    if not project_id:
        return

    total_expected = count_total_insights()

    print(f"\n🚀 Starting import to {STAGING_COLLECTION}...")
    print("Press Ctrl+C to safely interrupt")

    try:
        uploaded, errors = import_with_progress(project_id, api_key, total_expected)

        print("\n📊 Final Stats:")
        print(f"   Total found: {total_expected:,}")
        print(f"   Uploaded: {uploaded:,}")
        print(f"   Success rate: {uploaded/total_expected*100:.1f}%")

    except KeyboardInterrupt:
        print("\n⚠️ Import safely interrupted")


if __name__ == "__main__":
    main()
