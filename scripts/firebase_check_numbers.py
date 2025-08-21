#!/usr/bin/env python3
"""
Quick Firebase Check - See what number values exist
"""

import json
import plistlib
import urllib.request


def load_firebase_config():
    """Load Firebase config from GoogleService-Info.plist"""
    try:
        with open("../GoogleService-Info.plist", "rb") as f:
            plist = plistlib.load(f)

        project_id = plist.get("PROJECT_ID")
        api_key = plist.get("API_KEY", "")

        print(f"✅ Loaded Firebase config for project: {project_id}")
        return project_id, api_key
    except Exception as e:
        print(f"❌ Failed to load GoogleService-Info.plist: {e}")
        return None, None


def check_firebase_numbers():
    """Check what number values exist in Firebase"""
    print("🔍 Checking Firebase number fields...")

    project_id, api_key = load_firebase_config()
    if not project_id:
        return

    # Simple query to get first 10 documents
    base_url = f"https://firestore.googleapis.com/v1/projects/{project_id}/databases/(default)/documents/insights_staging"
    url = f"{base_url}?key={api_key}&pageSize=10"

    try:
        with urllib.request.urlopen(url) as response:
            data = json.loads(response.read().decode())

            if "documents" not in data:
                print("❌ No documents found")
                return

            print(f"📊 Found {len(data['documents'])} documents")
            print("\n🔢 Number field values:")

            number_counts = {}
            for doc in data["documents"]:
                fields = doc.get("fields", {})
                number_field = fields.get("number", {})
                number_value = number_field.get("integerValue", "MISSING")

                if number_value in number_counts:
                    number_counts[number_value] += 1
                else:
                    number_counts[number_value] = 1

                # Show first few examples
                if len(number_counts) <= 5:
                    text = fields.get("text", {}).get("stringValue", "No text")[:50]
                    print(f"   Number: {number_value} | Text: {text}...")

            print("\n📈 Number distribution in sample:")
            for num, count in number_counts.items():
                print(f"   Number {num}: {count} documents")

    except Exception as e:
        print(f"❌ Check failed: {e}")


if __name__ == "__main__":
    check_firebase_numbers()
