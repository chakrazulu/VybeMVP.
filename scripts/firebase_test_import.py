#!/usr/bin/env python3
"""
🧪 Firebase Import Test - Validate Structure First
Tests import of 10 insights to ensure perfect format match
"""

import hashlib
import json
import os
import sys

import firebase_admin
from firebase_admin import credentials, firestore

# Configuration
NUMEROLOGY_DATA_PATH = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData"
FIREBASE_CREDENTIALS_PATH = (
    "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/vybemvp-firebase-adminsdk.json"
)
STAGING_COLLECTION = "insights_staging"
TEST_LIMIT = 10  # Only import 10 insights for testing


def init_firebase():
    """Initialize Firebase Admin SDK"""
    try:
        if not firebase_admin._apps:
            cred = credentials.Certificate(FIREBASE_CREDENTIALS_PATH)
            firebase_admin.initialize_app(cred)

        db = firestore.client()
        print("✅ Firebase initialized successfully")
        return db
    except Exception as e:
        print(f"❌ Firebase initialization failed: {e}")
        sys.exit(1)


def generate_insight_id(text, number):
    """Generate consistent ID for insights"""
    content = f"{text}_{number}_test"
    return f"test_{hashlib.md5(content.encode()).hexdigest()[:8]}"


def determine_category(text):
    """Simple category determination"""
    text_lower = text.lower()
    if "reflect" in text_lower or "contemplate" in text_lower:
        return "reflection"
    elif "manifest" in text_lower or "create" in text_lower:
        return "manifestation"
    elif "challenge" in text_lower or "difficult" in text_lower:
        return "challenge"
    else:
        return "insight"


def determine_context(text):
    """Simple context determination"""
    text_lower = text.lower()
    if "morning" in text_lower or "dawn" in text_lower:
        return "morning_awakening"
    elif "evening" in text_lower or "night" in text_lower:
        return "evening_integration"
    else:
        return "daily"


def test_import():
    """Test import of just 10 insights"""
    print("🧪 Starting Firebase Import Test")
    print(f"📊 Will import {TEST_LIMIT} insights to validate structure")

    # Initialize Firebase
    db = init_firebase()

    # Find a number file to test with
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

    # Load and process test file
    with open(test_file, "r") as f:
        data = json.load(f)

    insights_imported = 0
    batch = db.batch()

    # Process number 1 insights only
    if "1" in data:
        insights_list = data["1"].get("insight", [])

        for i, insight_text in enumerate(insights_list[:TEST_LIMIT]):
            if not insight_text or len(insight_text.strip()) < 5:
                continue

            insight_id = generate_insight_id(insight_text, 1)

            # Create document matching your exact Firebase structure
            doc_data = {
                "category": determine_category(insight_text),
                "context": determine_context(insight_text),
                "number": 1,
                "persona": "oracle",  # Default for testing
                "quality_score": 0.95,  # High quality for your corpus
                "system": "number",
                "text": insight_text.strip(),
                "tier": "archetypal",
            }

            batch.set(db.collection(STAGING_COLLECTION).document(insight_id), doc_data)
            insights_imported += 1
            print(f"📝 Prepared insight {i+1}: {insight_text[:50]}...")

    # Commit the test batch
    if insights_imported > 0:
        print(f"\n💾 Committing {insights_imported} test insights...")
        batch.commit()
        print("✅ Test import successful!")

        # Verify the structure by reading one back
        print("\n🔍 Verifying structure...")
        test_docs = db.collection(STAGING_COLLECTION).where("system", "==", "number").limit(1).get()

        if test_docs:
            doc = test_docs[0]
            print("✅ Sample document structure:")
            for key, value in doc.to_dict().items():
                print(f"   {key}: {value}")

        print("\n🎯 Test complete! Ready for full import of your 159k insights.")
        print("📋 Next step: Run the full import script")

    else:
        print("❌ No insights imported")


def cleanup_test_data():
    """Remove test insights"""
    print("🧹 Cleaning up test data...")
    db = init_firebase()

    # Delete all test documents
    test_docs = db.collection(STAGING_COLLECTION).where("system", "==", "number").get()
    batch = db.batch()

    deleted = 0
    for doc in test_docs:
        if doc.id.startswith("test_"):
            batch.delete(doc.reference)
            deleted += 1

    if deleted > 0:
        batch.commit()
        print(f"✅ Cleaned up {deleted} test documents")
    else:
        print("ℹ️ No test documents to clean up")


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "cleanup":
        cleanup_test_data()
    else:
        test_import()
