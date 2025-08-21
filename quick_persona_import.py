#!/usr/bin/env python3
"""
Quick Persona Import - Upload AlanWatts and CarlJung to Firebase Emulator
"""

import json
import os

from google.cloud import firestore

# Initialize Firestore emulator
os.environ["FIRESTORE_EMULATOR_HOST"] = "127.0.0.1:8080"
db = firestore.Client(project="vybemvp")


def import_persona(persona_name):
    """Import a single persona to its own collection"""
    print(f"🚀 Importing {persona_name}...")

    # Target collection for this persona
    collection_name = f"{persona_name.lower()}_staging"
    collection = db.collection(collection_name)

    # Directory path
    data_dir = f"NumerologyData/{persona_name}NumberInsights"

    # Find all files for this persona
    files = [
        f
        for f in os.listdir(data_dir)
        if f.startswith(f"{persona_name}Insights_Number_") and f.endswith(".json")
    ]

    total_insights = 0

    for filename in sorted(files):
        file_path = os.path.join(data_dir, filename)
        print(f"  📄 Processing {filename}...")

        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)

        # Extract number from filename
        number = int(filename.split("_")[2].split(".")[0])

        # Handle schema differences
        if "categories" in data:
            categories_data = data["categories"]
        else:
            categories_data = data.get(str(number), {})
            if "categories" in categories_data:
                categories_data = categories_data["categories"]

        if not categories_data:
            print(f"    ⚠️ No data found for {number}")
            continue

        # Process each category
        batch = db.batch()
        batch_count = 0

        categories = [
            "insight",
            "reflection",
            "contemplation",
            "manifestation",
            "challenge",
            "physical_practice",
            "shadow",
            "archetype",
            "energy_check",
            "numerical_context",
            "astrological",
        ]

        for category in categories:
            insights = categories_data.get(category, [])

            for insight_text in insights:
                if not insight_text or not insight_text.strip():
                    continue

                doc_data = {
                    "text": insight_text.strip(),
                    "system": "number",
                    "number": number,
                    "category": category,
                    "tier": "persona",
                    "persona": persona_name.lower(),
                    "context": "philosophical",
                    "quality_score": 1.0,
                    "length": len(insight_text.split()),
                    "created_at": firestore.SERVER_TIMESTAMP,
                    "source_file": filename,
                }

                doc_ref = collection.document()
                batch.set(doc_ref, doc_data)
                batch_count += 1
                total_insights += 1

                # Commit in smaller batches
                if batch_count >= 50:
                    batch.commit()
                    batch = db.batch()
                    batch_count = 0
                    print("    ✅ Committed batch of 50")

        # Commit remaining
        if batch_count > 0:
            batch.commit()
            print(f"    ✅ Committed final batch of {batch_count}")

    print(f"  🎉 {persona_name} complete! Total insights: {total_insights}")
    return total_insights


def main():
    print("🔥 QUICK PERSONA IMPORT TO FIREBASE EMULATOR")
    print("=" * 50)

    total = 0

    # Import Alan Watts
    try:
        alan_total = import_persona("AlanWatts")
        total += alan_total
    except Exception as e:
        print(f"❌ Error importing AlanWatts: {e}")

    # Import Carl Jung
    try:
        carl_total = import_persona("CarlJung")
        total += carl_total
    except Exception as e:
        print(f"❌ Error importing CarlJung: {e}")

    print(f"\n🎉 IMPORT COMPLETE! Total insights uploaded: {total}")

    # Verify collections
    collections = db.collections()
    for collection_ref in collections:
        collection_id = collection_ref.id
        if collection_id.endswith("_staging"):
            count = len(list(collection_ref.stream()))
            print(f"  📊 {collection_id}: {count} insights")


if __name__ == "__main__":
    main()
