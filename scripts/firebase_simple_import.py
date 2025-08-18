#!/usr/bin/env python3
"""
🔥 Simple Firebase Import - Uses GoogleService-Info.plist
Imports NumerologyData insights using your existing app credentials
"""

import hashlib
import json
import os
import urllib.parse

# We'll use Firebase REST API instead of Admin SDK
import urllib.request
from datetime import datetime

# Configuration
NUMEROLOGY_DATA_PATH = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData"
GOOGLE_SERVICE_INFO_PATH = (
    "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/GoogleService-Info.plist"
)
STAGING_COLLECTION = "insights_staging"


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


def create_insight_document(text, number, persona="oracle"):
    """Create Firebase document structure"""
    return {
        "category": "insight",  # Default category
        "context": "daily",  # Default context
        "number": number,
        "persona": persona,
        "quality_score": 0.95,
        "system": "number",
        "text": text.strip(),
        "tier": "archetypal",
        "created_at": datetime.now().isoformat(),
    }


def test_simple_import():
    """Test import using REST API"""
    print("🧪 Starting Simple Firebase Import Test")
    print("=" * 50)

    # Load Firebase config
    project_id, api_key = load_firebase_config()
    if not project_id:
        return

    # Find test file
    number_path = os.path.join(NUMEROLOGY_DATA_PATH, "FirebaseNumberMeanings")
    test_file = None

    for filename in os.listdir(number_path):
        if filename.endswith(".json") and "Complete_1" in filename:
            test_file = os.path.join(number_path, filename)
            break

    if not test_file:
        print("❌ No test file found")
        return

    print(f"📁 Testing with: {os.path.basename(test_file)}")

    # Load insights
    with open(test_file, "r") as f:
        data = json.load(f)

    insights_list = data["1"].get("insight", [])[:3]  # Just 3 for testing

    print(f"📝 Uploading {len(insights_list)} test insights...")

    # Upload via REST API
    base_url = f"https://firestore.googleapis.com/v1/projects/{project_id}/databases/(default)/documents/{STAGING_COLLECTION}"

    success_count = 0

    for i, insight_text in enumerate(insights_list):
        doc_id = f"test_{hashlib.md5(insight_text.encode()).hexdigest()[:8]}"
        doc_data = create_insight_document(insight_text, 1)

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
            # Convert to JSON and create request
            data = json.dumps(firestore_doc).encode("utf-8")
            req = urllib.request.Request(url, data=data, method="PATCH")
            req.add_header("Content-Type", "application/json")

            with urllib.request.urlopen(req) as response:
                if response.status in [200, 201]:
                    success_count += 1
                    print(f"✅ Uploaded insight {i+1}")
                else:
                    print(f"❌ Failed insight {i+1}: {response.status}")

        except Exception as e:
            print(f"❌ Error uploading insight {i+1}: {e}")

    print("\n🎯 Test complete!")
    print(f"✅ Successfully uploaded: {success_count}/{len(insights_list)} insights")

    if success_count > 0:
        print(f"\n📱 Check Firebase Console → Firestore → {STAGING_COLLECTION}")
        print("Ready for full import!")
    else:
        print("\n❌ No insights uploaded. Check credentials and permissions.")


if __name__ == "__main__":
    test_simple_import()
