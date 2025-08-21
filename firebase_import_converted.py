#!/usr/bin/env python3
"""
Prepare converted NumberMessages_Complete files for Firebase import.
"""

import json
import os


def convert_to_firebase_import_format():
    """Convert NumberMessages files to Firebase import format"""
    base_path = (
        "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/FirebaseNumberMeanings"
    )

    # Files we know are converted (0-6 so far)
    converted_files = [0, 1, 2, 3, 4, 5, 6]

    firebase_data = {"__collections__": {"insights_staging": {}}}

    print("🔄 Converting files to Firebase import format...")

    for file_num in converted_files:
        file_path = f"{base_path}/NumberMessages_Complete_{file_num}.json"
        if os.path.exists(file_path):
            print(f"Processing file {file_num}...")

            with open(file_path, "r") as f:
                data = json.load(f)

            # Extract the number data
            number_key = str(file_num)
            if number_key in data:
                document_id = f"{file_num}-runtime-033"

                firebase_data["__collections__"]["insights_staging"][document_id] = {
                    "number": file_num,
                    "data": data[number_key],
                    "primary_persona": data.get("primary_persona", "Oracle"),
                    "__collections__": {},
                }

                print(f"✅ Added {document_id}")
            else:
                print(f"⚠️  No data found for key '{number_key}' in {file_path}")
        else:
            print(f"⚠️  File not found: {file_path}")

    # Write the Firebase import file
    output_path = (
        "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/firebase_import_converted.json"
    )
    with open(output_path, "w") as f:
        json.dump(firebase_data, f, indent=2)

    print(f"\n✨ Firebase import file created: {output_path}")
    print(f"📦 Ready to import {len(converted_files)} documents")

    return output_path


if __name__ == "__main__":
    convert_to_firebase_import_format()
