#!/usr/bin/env python3
"""
Simple Firebase Number Fix - Updates documents with correct numbers
"""

import hashlib
import json
import plistlib
import time
import urllib.parse
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


def determine_number_from_content(text):
    """Analyze insight text to determine appropriate number (1-9)"""
    # Keywords associated with each number
    number_keywords = {
        1: [
            "leadership",
            "pioneer",
            "beginning",
            "individual",
            "initiative",
            "independence",
            "first",
            "start",
            "new",
        ],
        2: [
            "partnership",
            "cooperation",
            "balance",
            "harmony",
            "relationship",
            "together",
            "pair",
            "dual",
        ],
        3: [
            "creativity",
            "expression",
            "communication",
            "joy",
            "artistic",
            "social",
            "create",
            "speak",
        ],
        4: [
            "foundation",
            "stability",
            "practical",
            "work",
            "discipline",
            "structure",
            "build",
            "solid",
        ],
        5: [
            "freedom",
            "adventure",
            "change",
            "versatility",
            "experience",
            "explore",
            "travel",
            "variety",
        ],
        6: ["nurturing", "responsibility", "home", "family", "service", "care", "love", "healing"],
        7: [
            "spiritual",
            "wisdom",
            "introspection",
            "analysis",
            "mystical",
            "contemplation",
            "inner",
            "sacred",
        ],
        8: [
            "material",
            "power",
            "achievement",
            "authority",
            "success",
            "ambition",
            "money",
            "business",
        ],
        9: [
            "completion",
            "humanitarian",
            "universal",
            "wisdom",
            "service",
            "enlightenment",
            "ending",
            "whole",
        ],
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


def update_document_number(project_id, api_key, doc_name, new_number):
    """Update a single document's number field"""
    url = (
        f"https://firestore.googleapis.com/v1/{doc_name}?key={api_key}&updateMask.fieldPaths=number"
    )

    update_data = {"fields": {"number": {"integerValue": str(new_number)}}}

    try:
        data = json.dumps(update_data).encode("utf-8")
        req = urllib.request.Request(url, data=data, method="PATCH")
        req.add_header("Content-Type", "application/json")

        with urllib.request.urlopen(req) as response:
            return response.status in [200, 201]
    except Exception as e:
        print(f"❌ Failed to update document: {e}")
        return False


def fix_firebase_batch():
    """Fix Firebase numbers in batches"""
    print("🔧 Simple Firebase Number Fix")
    print("=" * 40)

    project_id, api_key = load_firebase_config()
    if not project_id:
        return

    collection = "insights_staging"
    base_url = f"https://firestore.googleapis.com/v1/projects/{project_id}/databases/(default)/documents/{collection}"

    print(f"🎯 Fixing numbers in: {collection}")

    # Process in batches
    page_token = None
    total_updated = 0
    number_counts = {i: 0 for i in range(1, 10)}

    while True:
        # Get batch of documents
        url = f"{base_url}?key={api_key}&pageSize=50"
        if page_token:
            url += f"&pageToken={page_token}"

        try:
            with urllib.request.urlopen(url) as response:
                data = json.loads(response.read().decode())

                if "documents" not in data:
                    print("✅ No more documents to process")
                    break

                documents = data["documents"]
                print(f"\n📦 Processing batch of {len(documents)} documents...")

                # Update each document in this batch
                for i, doc in enumerate(documents):
                    doc_name = doc["name"]
                    fields = doc.get("fields", {})

                    # Get current number and text
                    current_number = int(fields.get("number", {}).get("integerValue", "0"))
                    text = fields.get("text", {}).get("stringValue", "")

                    # Skip if already has correct number (not 0)
                    if current_number != 0:
                        continue

                    # Determine new number
                    new_number = determine_number_from_content(text)
                    number_counts[new_number] += 1

                    # Update document
                    if update_document_number(project_id, api_key, doc_name, new_number):
                        total_updated += 1
                        print(f"✅ {total_updated}: Updated to number {new_number}")
                    else:
                        print(f"❌ {total_updated + 1}: Failed to update")

                    # Rate limiting
                    time.sleep(0.1)

                # Check for next page
                page_token = data.get("nextPageToken")
                if not page_token:
                    break

        except Exception as e:
            print(f"❌ Batch processing failed: {e}")
            break

    # Summary
    print("\n🎉 UPDATE COMPLETE!")
    print(f"✅ Total documents updated: {total_updated}")
    print("\n📊 Number distribution:")
    for num in range(1, 10):
        print(f"   Number {num}: {number_counts[num]} insights")


if __name__ == "__main__":
    fix_firebase_batch()
