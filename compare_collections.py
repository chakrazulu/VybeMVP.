#!/usr/bin/env python3
"""
Compare NumerologyData vs KASPERMLXRuntimeBundle to find missing files
"""

import os
from collections import defaultdict


def get_files_by_category(root_dir):
    """Get files organized by category/persona"""
    files_by_category = defaultdict(list)

    for root, dirs, files in os.walk(root_dir):
        for file in files:
            if file.endswith(".json"):
                # Determine category from path
                rel_path = os.path.relpath(root, root_dir)
                category = rel_path.replace("/", "_")
                files_by_category[category].append(file)

    return files_by_category


def main():
    print("🔍 Comparing NumerologyData vs KASPERMLXRuntimeBundle...")

    # Get files from both locations
    numerology_files = get_files_by_category("NumerologyData")
    runtime_files = get_files_by_category("KASPERMLXRuntimeBundle")

    print(f"\n📊 NumerologyData: {sum(len(files) for files in numerology_files.values())} files")
    for category, files in sorted(numerology_files.items()):
        print(f"  {category}: {len(files)} files")

    print(
        f"\n📊 KASPERMLXRuntimeBundle: {sum(len(files) for files in runtime_files.values())} files"
    )
    for category, files in sorted(runtime_files.items()):
        print(f"  {category}: {len(files)} files")

    print("\n🔍 Missing from KASPERMLXRuntimeBundle:")

    # Check what's in NumerologyData but not in RuntimeBundle
    missing_categories = set(numerology_files.keys()) - set(runtime_files.keys())
    for category in sorted(missing_categories):
        files = numerology_files[category]
        print(f"  ❌ ENTIRE CATEGORY MISSING: {category} ({len(files)} files)")
        for file in sorted(files)[:5]:  # Show first 5 files
            print(f"    - {file}")
        if len(files) > 5:
            print(f"    ... and {len(files) - 5} more files")

    # Check individual missing files within existing categories
    for category in sorted(set(numerology_files.keys()) & set(runtime_files.keys())):
        numerology_set = set(numerology_files[category])
        runtime_set = set(runtime_files[category])
        missing_files = numerology_set - runtime_set

        if missing_files:
            print(f"  ⚠️  Missing from {category}: {len(missing_files)} files")
            for file in sorted(missing_files)[:3]:
                print(f"    - {file}")
            if len(missing_files) > 3:
                print(f"    ... and {len(missing_files) - 3} more")

    # Calculate total missing
    total_numerology = sum(len(files) for files in numerology_files.values())
    total_runtime = sum(len(files) for files in runtime_files.values())
    print("\n📈 Summary:")
    print(f"  NumerologyData total: {total_numerology}")
    print(f"  RuntimeBundle total: {total_runtime}")
    print(f"  Missing files: {total_numerology - total_runtime}")


if __name__ == "__main__":
    main()
