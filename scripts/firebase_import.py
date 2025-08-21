#!/usr/bin/env python3
"""
🔥 Firebase Insights Import Script - Bulletproof Content to Firestore
Imports 159,130+ A+ quality insights from JSON files to Firebase
"""

import json
import os
from datetime import datetime
from typing import Any, Dict, List

# Firebase Admin SDK
from google.cloud import firestore
from google.cloud.firestore import Client


class FirebaseInsightImporter:
    """Imports bulletproof spiritual insights to Firestore collections"""

    def __init__(self, use_emulator: bool = True):
        """
        Initialize Firebase client

        Args:
            use_emulator: If True, connects to local emulator (FREE testing)
                         If False, connects to production Firebase
        """
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
            # Connect to local emulator (FREE)
            print("🧪 Connecting to Firestore Emulator...")
            os.environ["FIRESTORE_EMULATOR_HOST"] = "127.0.0.1:8080"
            return firestore.Client(project="vybemvp")
        else:
            # Connect to production Firebase
            print("🚀 Connecting to Production Firebase...")
            return firestore.Client(project="vybemvp")

    def import_number_insights(
        self, data_dir: str = "NumerologyData/FirebaseNumberMeanings"
    ) -> Dict[str, int]:
        """
        Import number insights (0-9) from bulletproof multiplier

        Args:
            data_dir: Directory containing NumberMessages_Complete_*.json files

        Returns:
            Import statistics
        """
        print(f"📊 Importing Number Insights from {data_dir}")

        # Target collection for insights
        collection_name = "insights_staging" if self.use_emulator else "insights_prod"
        collection = self.db.collection(collection_name)

        # Find all number insight files
        number_files = []
        for filename in os.listdir(data_dir):
            if (
                filename.startswith("NumberMessages_Complete_")
                and filename.endswith(".json")
                and not filename.endswith("_archetypal.json")
            ):
                number_files.append(filename)

        print(f"🔍 Found {len(number_files)} bulletproof number files")

        for filename in sorted(number_files):
            file_path = os.path.join(data_dir, filename)
            self._import_number_file(file_path, collection)

        return self._get_import_stats()

    def import_persona_insights(self, persona: str, data_dir: str = None) -> Dict[str, int]:
        """
        Import persona insights (AlanWatts, CarlJung) from new schema format

        Args:
            persona: Persona name (AlanWatts, CarlJung)
            data_dir: Directory containing PersonaInsights_Number_*.json files

        Returns:
            Import statistics
        """
        if data_dir is None:
            data_dir = f"NumerologyData/{persona}NumberInsights"

        print(f"📊 Importing {persona} Insights from {data_dir}")

        # Target collection specific to persona
        base_name = f"{persona.lower()}_staging" if self.use_emulator else f"{persona.lower()}_prod"
        collection = self.db.collection(base_name)

        # Find all persona insight files
        persona_files = []
        for filename in os.listdir(data_dir):
            if filename.startswith(f"{persona}Insights_Number_") and filename.endswith(".json"):
                persona_files.append(filename)

        print(f"🔍 Found {len(persona_files)} {persona} files")

        for filename in sorted(persona_files):
            file_path = os.path.join(data_dir, filename)
            self._import_persona_file(file_path, collection, persona)

        return self._get_import_stats()

    def _import_number_file(self, file_path: str, collection) -> None:
        """Import a single number insights file"""
        try:
            # Extract number from filename: NumberMessages_Complete_5.json -> 5
            filename = os.path.basename(file_path)
            parts = filename.split("_")  # ['NumberMessages', 'Complete', '5.json']
            number_str = parts[2].split(".")[0]  # Get the '5' part (remove .json)
            number = int(number_str)

            print(f"📝 Importing Number {number} insights...")

            # Load the JSON file
            with open(file_path, "r", encoding="utf-8") as f:
                data = json.load(f)

            # Extract insights from the number's data
            number_data = data.get(str(number), {})
            if not number_data:
                print(f"⚠️  No data found for number {number}")
                return

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

            for category in categories:
                insights = number_data.get(category, [])

                for insight_obj in insights:
                    # Handle both string insights and object insights
                    if isinstance(insight_obj, str):
                        insight_text = insight_obj
                        persona = "oracle"
                        context = "daily"
                        quality_score = 1.0
                    elif isinstance(insight_obj, dict):
                        insight_text = insight_obj.get("insight", "")
                        persona = insight_obj.get("persona", "oracle")
                        context = insight_obj.get("context", "daily")
                        quality_score = insight_obj.get("fusion_authenticity", 1.0)
                    else:
                        continue

                    if not insight_text or not insight_text.strip():
                        continue

                    # Create Firestore document
                    doc_data = {
                        "text": insight_text.strip(),
                        "system": "number",
                        "number": number,
                        "category": category,
                        "tier": "archetypal",  # This is bulletproof content
                        "persona": persona.lower().replace(" ", "_"),
                        "context": context.lower().replace(" ", "_"),
                        "quality_score": quality_score,
                        "actions": self._extract_actions(insight_text),
                        "length": len(insight_text.split()),
                        "checksum": self._calculate_checksum(insight_text),
                        "created_at": firestore.SERVER_TIMESTAMP,
                        "source_file": filename,
                    }

                    # Add to batch
                    doc_ref = collection.document()
                    batch.set(doc_ref, doc_data)
                    batch_count += 1

                    # Commit batch every 100 documents (Firestore limit is 500)
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
            print(f"  🎉 Number {number} complete!")

        except Exception as e:
            print(f"❌ Error importing {file_path}: {e}")
            self.stats["errors"] += 1

    def _import_persona_file(self, file_path: str, collection, persona: str) -> None:
        """Import a single persona insights file (new schema)"""
        try:
            # Extract number from filename: AlanWattsInsights_Number_11.json -> 11
            filename = os.path.basename(file_path)
            parts = filename.split("_")  # ['AlanWattsInsights', 'Number', '11.json']
            number_str = parts[2].split(".")[0]  # Get the '11' part (remove .json)
            number = int(number_str)

            print(f"📝 Importing {persona} Number {number} insights...")

            # Load the JSON file
            with open(file_path, "r", encoding="utf-8") as f:
                data = json.load(f)

            # Extract insights from the persona's data (handle both schema formats)
            number_data = data.get(str(number), {})

            # Check if this uses the "categories" wrapper format (AlanWatts schema)
            if "categories" in data:
                categories_data = data.get("categories", {})
                number_data = categories_data
            elif "categories" in number_data:
                number_data = number_data.get("categories", {})

            if not number_data:
                print(f"⚠️  No data found for {persona} number {number}")
                return

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

            for category in categories:
                insights = number_data.get(category, [])

                for insight_text in insights:
                    if not insight_text or not insight_text.strip():
                        continue

                    # Create Firestore document with persona schema
                    doc_data = {
                        "text": insight_text.strip(),
                        "system": "number",
                        "number": number,
                        "category": category,
                        "tier": "persona",  # This is persona content
                        "persona": persona.lower(),
                        "context": "philosophical",
                        "quality_score": 1.0,  # Persona content is high quality
                        "actions": self._extract_actions(insight_text),
                        "length": len(insight_text.split()),
                        "checksum": self._calculate_checksum(insight_text),
                        "created_at": firestore.SERVER_TIMESTAMP,
                        "source_file": filename,
                    }

                    # Add to batch
                    doc_ref = collection.document()
                    batch.set(doc_ref, doc_data)
                    batch_count += 1

                    # Commit batch every 100 documents (Firestore limit is 500)
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
            print(f"  🎉 {persona} Number {number} complete!")

        except Exception as e:
            print(f"❌ Error importing {file_path}: {e}")
            self.stats["errors"] += 1

    def _extract_actions(self, text: str) -> List[str]:
        """Extract action words from insight text (from bulletproof multiplier)"""
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
            "dedicate",
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
        ]

        found_actions = []
        text_lower = text.lower()
        for action in action_words:
            if action in text_lower:
                found_actions.append(action)

        return found_actions

    def _calculate_checksum(self, text: str) -> str:
        """Calculate simple checksum for duplicate detection"""
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

        # Count total documents
        total_docs = len(list(collection.stream()))

        # Count by number
        number_counts = {}
        for doc in collection.stream():
            data = doc.to_dict()
            number = data.get("number")
            if number is not None:
                number_counts[number] = number_counts.get(number, 0) + 1

        # Count by category
        category_counts = {}
        for doc in collection.stream():
            data = doc.to_dict()
            category = data.get("category")
            if category:
                category_counts[category] = category_counts.get(category, 0) + 1

        verification = {
            "total_insights": total_docs,
            "insights_per_number": number_counts,
            "insights_per_category": category_counts,
            "collection": collection_name,
            "emulator_mode": self.use_emulator,
        }

        print("📊 Import Verification Results:")
        print(f"  Total insights: {total_docs}")
        print(f"  Numbers covered: {sorted(number_counts.keys())}")
        print(f"  Categories: {len(category_counts)}")

        return verification

    def verify_all_collections(self) -> Dict[str, Any]:
        """Verify all collections in the database"""
        print("🔍 Verifying all collections...")

        # Get all collections
        collections = self.db.collections()
        results = {}
        total_insights = 0

        for collection_ref in collections:
            collection_id = collection_ref.id
            if self.use_emulator and not collection_id.endswith("_staging"):
                continue
            if not self.use_emulator and not collection_id.endswith("_prod"):
                continue

            docs = list(collection_ref.stream())
            count = len(docs)
            total_insights += count
            results[collection_id] = count
            print(f"  {collection_id}: {count} insights")

        print(f"\n📊 Total insights across all collections: {total_insights}")
        return {"collections": results, "total_insights": total_insights}


def main():
    """Main import function"""
    import argparse

    parser = argparse.ArgumentParser(description="Import bulletproof insights to Firebase")
    parser.add_argument("--emulator", action="store_true", help="Use Firebase emulator")
    parser.add_argument("--production", action="store_true", help="Use production Firebase")
    parser.add_argument("--status", action="store_true", help="Import and show status")
    parser.add_argument("--persona", type=str, help="Import specific persona (AlanWatts, CarlJung)")
    parser.add_argument("--numbers-only", action="store_true", help="Import only number insights")
    parser.add_argument("--personas-only", action="store_true", help="Import only persona insights")

    args = parser.parse_args()

    print("🔥 FIREBASE INSIGHTS IMPORT - Enhanced Content Pipeline")
    print("=" * 60)

    # Determine which environment to use
    use_emulator = args.emulator or (not args.production)
    importer = FirebaseInsightImporter(use_emulator=use_emulator)

    total_stats = {"files_processed": 0, "duration_seconds": 0, "success_rate": 0}

    # Import number insights (unless personas-only)
    if not args.personas_only:
        print("\n📊 Starting Number Insights Import...")
        stats = importer.import_number_insights()
        total_stats["files_processed"] += stats["files_processed"]
        total_stats["duration_seconds"] += stats["duration_seconds"]

        print("\n✅ Number Insights Import Complete!")
        print(f"Files processed: {stats['files_processed']}")
        print(f"Duration: {stats['duration_seconds']:.1f} seconds")
        print(f"Success rate: {stats['success_rate']:.1f}%")

    # Import persona insights (unless numbers-only)
    if not args.numbers_only:
        personas = [args.persona] if args.persona else ["AlanWatts", "CarlJung"]

        for persona in personas:
            print(f"\n🧘 Starting {persona} Insights Import...")
            try:
                stats = importer.import_persona_insights(persona)
                total_stats["files_processed"] += stats["files_processed"]
                total_stats["duration_seconds"] += stats["duration_seconds"]

                print(f"\n✅ {persona} Insights Import Complete!")
                print(f"Files processed: {stats['files_processed']}")
                print(f"Duration: {stats['duration_seconds']:.1f} seconds")
                print(f"Success rate: {stats['success_rate']:.1f}%")
            except FileNotFoundError:
                print(f"⚠️  {persona} directory not found, skipping...")
            except Exception as e:
                print(f"❌ Error importing {persona}: {e}")

    # Verify all collections
    print("\n🔍 Verifying all collections...")
    verification = importer.verify_all_collections()

    print("\n🎉 ENHANCED CONTENT SUCCESSFULLY IMPORTED!")
    print(f"Total insights in Firestore: {verification['total_insights']}")
    print(f"Total files processed: {total_stats['files_processed']}")
    print(f"Total duration: {total_stats['duration_seconds']:.1f} seconds")


if __name__ == "__main__":
    main()
