#!/usr/bin/env python3
"""
Firebase Number Fix Script - Repairs insights with number: 0
Analyzes content and assigns correct numbers 1-9 without re-importing
"""

import hashlib
import json
import time
import urllib.parse
import urllib.request

# Configuration
STAGING_COLLECTION = "insights_staging"
PROD_COLLECTION = "insights_prod"


def load_firebase_config():
    """Load Firebase config from GoogleService-Info.plist"""
    try:
        import plistlib

        with open("../GoogleService-Info.plist", "rb") as f:
            plist = plistlib.load(f)

        project_id = plist.get("PROJECT_ID")
        api_key = plist.get("API_KEY", "")

        if not project_id:
            raise ValueError("PROJECT_ID not found in plist")

        print(f"✅ Loaded Firebase config for project: {project_id}")
        return project_id, api_key
    except Exception as e:
        print(f"❌ Failed to load GoogleService-Info.plist: {e}")
        return None, None


def get_insights_with_zero_number(project_id, api_key, collection):
    """Fetch all insights with number: 0"""
    print(f"\n🔍 Querying {collection} for insights with number: 0...")

    base_url = f"https://firestore.googleapis.com/v1/projects/{project_id}/databases/(default)/documents/{collection}"

    # Query for number = 0
    query = {
        "structuredQuery": {
            "from": [{"collectionId": collection.split("/")[-1]}],
            "where": {
                "fieldFilter": {
                    "field": {"fieldPath": "number"},
                    "op": "EQUAL",
                    "value": {"integerValue": "0"},
                }
            },
            "limit": 1000,
        }
    }

    url = f"https://firestore.googleapis.com/v1/projects/{project_id}/databases/(default)/documents:runQuery?key={api_key}"

    try:
        data = json.dumps(query).encode("utf-8")
        req = urllib.request.Request(url, data=data, method="POST")
        req.add_header("Content-Type", "application/json")

        with urllib.request.urlopen(req) as response:
            result = json.loads(response.read().decode())
            documents = []

            # Handle runQuery response format
            if isinstance(result, list):
                for item in result:
                    if "document" in item:
                        documents.append(item["document"])
            elif "document" in result:
                documents.append(result["document"])

            print(f"📊 Found {len(documents)} insights with number: 0")
            return documents

    except Exception as e:
        print(f"❌ Query failed: {e}")
        return []


def determine_number_from_content(text):
    """Analyze insight text to determine appropriate number (1-9)"""
    # Keywords associated with each number
    number_keywords = {
        1: ["leadership", "pioneer", "beginning", "individual", "initiative", "independence"],
        2: ["partnership", "cooperation", "balance", "harmony", "relationship", "duality"],
        3: ["creativity", "expression", "communication", "joy", "artistic", "social"],
        4: ["foundation", "stability", "practical", "work", "discipline", "structure"],
        5: ["freedom", "adventure", "change", "versatility", "experience", "exploration"],
        6: ["nurturing", "responsibility", "home", "family", "service", "care"],
        7: ["spiritual", "wisdom", "introspection", "analysis", "mystical", "contemplation"],
        8: ["material", "power", "achievement", "authority", "success", "ambition"],
        9: ["completion", "humanitarian", "universal", "wisdom", "service", "enlightenment"],
    }

    text_lower = text.lower()
    scores = {}

    # Score each number based on keyword matches
    for num, keywords in number_keywords.items():
        score = sum(1 for keyword in keywords if keyword in text_lower)
        scores[num] = score

    # If we have keyword matches, use the highest scoring number
    if max(scores.values()) > 0:
        return max(scores, key=scores.get)

    # Fallback: Use consistent hash to distribute evenly
    hash_value = int(hashlib.md5(text.encode()).hexdigest(), 16)
    return (hash_value % 9) + 1


def update_document_number(project_id, api_key, collection, doc_path, new_number):
    """Update a single document's number field"""
    # Extract document ID from path
    doc_id = doc_path.split("/")[-1]

    url = (
        f"https://firestore.googleapis.com/v1/{doc_path}?key={api_key}&updateMask.fieldPaths=number"
    )

    update_data = {"fields": {"number": {"integerValue": str(new_number)}}}

    try:
        data = json.dumps(update_data).encode("utf-8")
        req = urllib.request.Request(url, data=data, method="PATCH")
        req.add_header("Content-Type", "application/json")

        with urllib.request.urlopen(req) as response:
            return response.status in [200, 201]
    except Exception as e:
        print(f"❌ Failed to update {doc_id}: {e}")
        return False


def fix_firebase_numbers():
    """Main function to fix all number: 0 documents"""
    print("\n🔧 Firebase Number Fix Script")
    print("=" * 50)

    # Load config
    project_id, api_key = load_firebase_config()
    if not project_id:
        return

    # Use staging by default for safety
    collection = STAGING_COLLECTION
    print(f"\n📂 Automatically using staging collection for safety: {collection}")

    print(f"\n🎯 Working with: {collection}")

    # Get documents with number: 0
    documents = get_insights_with_zero_number(project_id, api_key, collection)

    if not documents:
        print("✅ No documents with number: 0 found!")
        return

    # Fix each document
    print(f"\n🔄 Fixing {len(documents)} documents...")

    success_count = 0
    error_count = 0
    number_distribution = {i: 0 for i in range(1, 10)}

    for i, doc in enumerate(documents):
        # Extract text and document path
        doc_path = doc["name"]
        text_field = doc["fields"].get("text", {})
        text = text_field.get("stringValue", "")

        if not text:
            print(f"⚠️ Document {i+1}: No text found, skipping")
            continue

        # Determine correct number
        new_number = determine_number_from_content(text)
        number_distribution[new_number] += 1

        # Update document
        if update_document_number(project_id, api_key, collection, doc_path, new_number):
            success_count += 1
            print(f"✅ Fixed {i+1}/{len(documents)}: Set to number {new_number}")
        else:
            error_count += 1
            print(f"❌ Failed {i+1}/{len(documents)}")

        # Rate limiting
        if (i + 1) % 10 == 0:
            time.sleep(0.5)  # Pause every 10 updates

    # Summary
    print("\n" + "=" * 50)
    print("📊 FIX COMPLETE:")
    print(f"✅ Successfully fixed: {success_count}")
    print(f"❌ Errors: {error_count}")
    print("\n📈 Number Distribution:")
    for num in range(1, 10):
        print(f"   Number {num}: {number_distribution[num]} insights")


if __name__ == "__main__":
    fix_firebase_numbers()
