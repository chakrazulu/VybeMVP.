#!/usr/bin/env python3
"""
🔥 Import Converted Second-Person Insights to Firebase
Imports the converted second-person format insights (0-6) to Firestore
"""

import json
import os
import sys
from datetime import datetime
from typing import Any, Dict, List

# Firebase Admin SDK
try:
    from google.cloud import firestore
    from google.cloud.firestore import Client
except ImportError:
    print("❌ Firebase Admin SDK not installed. Run: pip install google-cloud-firestore")
    sys.exit(1)


class ConvertedInsightImporter:
    """Imports converted second-person insights to Firestore"""

    def __init__(self, use_emulator: bool = True):
        self.use_emulator = use_emulator
        self.db = self._initialize_firestore()
        self.stats = {
            "files_processed": 0,
            "insights_imported": 0,
            "errors": 0,
            "start_time": datetime.now(),
        }

    def _initialize_firestore(self) -> Client:
        """Initialize Firestore client"""
        if self.use_emulator:
            print("🧪 Connecting to Firestore Emulator...")
            os.environ["FIRESTORE_EMULATOR_HOST"] = "127.0.0.1:8080"
            return firestore.Client(project="vybemvp")
        else:
            print("🚀 Connecting to Production Firebase...")
            return firestore.Client(project="vybemvp")

    def import_converted_insights(
        self, data_dir: str = "NumerologyData/FirebaseNumberMeanings"
    ) -> Dict[str, int]:
        """Import converted second-person insights (0-6)"""
        print(f"📊 Importing Converted Second-Person Insights from {data_dir}")

        collection_name = "insights_staging" if self.use_emulator else "insights_prod"
        collection = self.db.collection(collection_name)

        # Files we know are converted (0-6)
        converted_numbers = [0, 1, 2, 3, 4, 5, 6]

        for number in converted_numbers:
            filename = f"NumberMessages_Complete_{number}.json"
            file_path = os.path.join(data_dir, filename)

            if os.path.exists(file_path):
                print(f"📝 Importing Number {number} converted insights...")
                self._import_converted_file(file_path, collection, number)
            else:
                print(f"⚠️  File not found: {file_path}")

        return self._get_import_stats()

    def _import_converted_file(self, file_path: str, collection, number: int) -> None:
        """Import a single converted insights file"""
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                data = json.load(f)

            # Get the number data
            number_data = data.get(str(number), {})
            if not number_data:
                print(f"⚠️  No data found for number {number}")
                return

            # Get primary persona
            primary_persona = data.get("primary_persona", "Oracle")

            # Process each category
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

            batch = self.db.batch()
            batch_count = 0
            total_insights = 0

            for category in categories:
                insights = number_data.get(category, [])

                for insight_text in insights:
                    if not insight_text or not insight_text.strip():
                        continue

                    # Create the document ID pattern: {number}-{category}-{index}
                    doc_id = f"{number}-{category}-{total_insights:03d}"

                    # Create Firestore document
                    doc_data = {
                        "text": insight_text.strip(),
                        "system": "number",
                        "number": number,
                        "category": category,
                        "tier": "converted_second_person",
                        "persona": primary_persona.lower().replace(" ", "_"),
                        "context": "daily",
                        "quality_score": 1.0,
                        "format": "second_person",
                        "actions": self._extract_actions(insight_text),
                        "length": len(insight_text.split()),
                        "checksum": self._calculate_checksum(insight_text),
                        "created_at": firestore.SERVER_TIMESTAMP,
                        "source_file": os.path.basename(file_path),
                        "conversion_date": datetime.now().isoformat(),
                    }

                    # Add to batch with specific document ID
                    doc_ref = collection.document(doc_id)
                    batch.set(doc_ref, doc_data)
                    batch_count += 1
                    total_insights += 1

                    # Commit batch every 100 documents
                    if batch_count >= 100:
                        batch.commit()
                        batch = self.db.batch()
                        batch_count = 0
                        print("  ✅ Committed batch of 100 insights")

            # Commit remaining documents
            if batch_count > 0:
                batch.commit()
                print(f"  ✅ Committed final batch of {batch_count} insights")

            self.stats["files_processed"] += 1
            self.stats["insights_imported"] += total_insights
            print(f"  🎉 Number {number} complete! {total_insights} insights imported")

        except Exception as e:
            print(f"❌ Error importing {file_path}: {e}")
            self.stats["errors"] += 1

    def _extract_actions(self, text: str) -> List[str]:
        """Extract action words from insight text"""
        action_words = [
            "pause",
            "breathe",
            "choose",
            "release",
            "forgive",
            "trust",
            "embrace",
            "honor",
            "listen",
            "write",
            "feel",
            "create",
            "express",
            "align",
            "connect",
            "focus",
            "commit",
            "act",
            "step",
            "speak",
            "explore",
            "discover",
            "welcome",
            "recognize",
            "acknowledge",
            "practice",
            "celebrate",
            "allow",
            "respond",
            "begin",
            "follow",
            "notice",
            "consider",
            "reflect",
            "contemplate",
        ]

        found_actions = []
        text_lower = text.lower()
        for action in action_words:
            if action in text_lower:
                found_actions.append(action)

        return found_actions

    def _calculate_checksum(self, text: str) -> str:
        """Calculate checksum for duplicate detection"""
        import hashlib

        return hashlib.md5(text.encode()).hexdigest()[:8]

    def _get_import_stats(self) -> Dict[str, Any]:
        """Get import statistics"""
        duration = datetime.now() - self.stats["start_time"]
        return {
            "files_processed": self.stats["files_processed"],
            "insights_imported": self.stats["insights_imported"],
            "errors": self.stats["errors"],
            "duration_seconds": duration.total_seconds(),
            "success_rate": (
                self.stats["files_processed"]
                / max(1, self.stats["files_processed"] + self.stats["errors"])
            )
            * 100,
        }

    def verify_import(self, collection_name: str = None) -> Dict[str, Any]:
        """Verify the import was successful"""
        if collection_name is None:
            collection_name = "insights_staging" if self.use_emulator else "insights_prod"

        print(f"🔍 Verifying import in collection: {collection_name}")
        collection = self.db.collection(collection_name)

        # Count documents
        docs = list(collection.where("format", "==", "second_person").stream())
        total_docs = len(docs)

        # Count by number
        number_counts = {}
        category_counts = {}

        for doc in docs:
            data = doc.to_dict()
            number = data.get("number")
            category = data.get("category")

            if number is not None:
                number_counts[number] = number_counts.get(number, 0) + 1
            if category:
                category_counts[category] = category_counts.get(category, 0) + 1

        verification = {
            "total_converted_insights": total_docs,
            "insights_per_number": number_counts,
            "insights_per_category": category_counts,
            "collection": collection_name,
            "emulator_mode": self.use_emulator,
        }

        print("📊 Import Verification Results:")
        print(f"  Total converted insights: {total_docs}")
        print(f"  Numbers covered: {sorted(number_counts.keys())}")
        print(f"  Categories: {len(category_counts)}")

        return verification


def main():
    """Main import function"""
    print("🔥 CONVERTED INSIGHTS IMPORT - Second Person Format")
    print("=" * 60)

    importer = ConvertedInsightImporter(use_emulator=True)

    # Import converted insights
    print("\n📊 Starting Converted Insights Import...")
    stats = importer.import_converted_insights()

    print("\n✅ Import Complete!")
    print(f"Files processed: {stats['files_processed']}")
    print(f"Insights imported: {stats['insights_imported']}")
    print(f"Duration: {stats['duration_seconds']:.1f} seconds")
    print(f"Success rate: {stats['success_rate']:.1f}%")

    # Verify import
    print("\n🔍 Verifying import...")
    verification = importer.verify_import()

    print("\n🎉 CONVERTED CONTENT SUCCESSFULLY IMPORTED!")
    print(f"Total converted insights in Firestore: {verification['total_converted_insights']}")


if __name__ == "__main__":
    main()
