#!/usr/bin/env python3
"""
Analyze JSON schemas across NumerologyData collections
"""

import json
import os
from collections import defaultdict


def analyze_schema(file_path):
    """Analyze the schema structure of a JSON file"""
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)

        schema_info = {
            "file": os.path.basename(file_path),
            "type": type(data).__name__,
            "root_keys": [],
            "structure": "unknown",
        }

        if isinstance(data, dict):
            schema_info["root_keys"] = list(data.keys())

            # Detect schema patterns
            if "categories" in data:
                schema_info["structure"] = "categories_wrapper"
                if "number" in data:
                    schema_info["structure"] = "persona_with_categories"
            elif any(key.isdigit() for key in data.keys()):
                schema_info["structure"] = "number_keyed"
                # Check if numbers contain categories
                first_number = next((k for k in data.keys() if k.isdigit()), None)
                if first_number and isinstance(data[first_number], dict):
                    if "categories" in data[first_number]:
                        schema_info["structure"] = "number_keyed_with_categories"
                    else:
                        # Check if it has direct insight categories
                        insight_categories = [
                            "insight",
                            "reflection",
                            "contemplation",
                            "manifestation",
                        ]
                        if any(cat in data[first_number] for cat in insight_categories):
                            schema_info["structure"] = "number_keyed_direct_categories"
            elif "primary_persona" in data:
                schema_info["structure"] = "persona_primary"
            elif all(isinstance(v, list) for v in data.values()):
                schema_info["structure"] = "direct_categories"
            elif "system" in data or "tier" in data:
                schema_info["structure"] = "firebase_document"
        elif isinstance(data, list):
            schema_info["structure"] = "array"

        return schema_info
    except Exception as e:
        return {"file": os.path.basename(file_path), "error": str(e)}


def main():
    print("🔍 Analyzing JSON schemas in NumerologyData...")

    schemas_by_type = defaultdict(list)

    # Walk through all JSON files
    for root, dirs, files in os.walk("NumerologyData"):
        for file in files:
            if file.endswith(".json"):
                file_path = os.path.join(root, file)
                schema_info = analyze_schema(file_path)

                # Categorize by directory and structure
                rel_path = os.path.relpath(root, "NumerologyData")
                category = f"{rel_path}::{schema_info.get('structure', 'unknown')}"
                schemas_by_type[category].append(schema_info)

    print("\n📊 Schema Analysis Results:")

    for category, files in sorted(schemas_by_type.items()):
        directory, structure = category.split("::")
        print(f"\n📁 {directory} ({structure}):")
        print(f"   Files: {len(files)}")

        # Show sample file structure
        if files:
            sample = files[0]
            if "root_keys" in sample:
                keys_preview = sample["root_keys"][:5]
                if len(sample["root_keys"]) > 5:
                    keys_preview.append("...")
                print(f"   Sample keys: {keys_preview}")

        # Show first few files
        for file_info in files[:3]:
            if "error" in file_info:
                print(f"   ❌ {file_info['file']}: {file_info['error']}")
            else:
                print(f"   ✅ {file_info['file']}")

        if len(files) > 3:
            print(f"   ... and {len(files) - 3} more files")

    # Summary of unique schemas
    unique_structures = set()
    for category in schemas_by_type.keys():
        structure = category.split("::")[-1]
        unique_structures.add(structure)

    print(f"\n🎯 Unique Schema Structures Found: {len(unique_structures)}")
    for structure in sorted(unique_structures):
        print(f"   - {structure}")

    return schemas_by_type


if __name__ == "__main__":
    main()
