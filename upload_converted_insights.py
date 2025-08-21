#!/usr/bin/env python3
"""
Upload converted NumberMessages_Complete files to Firebase emulator.
"""

import json
import os

import requests

# Firebase emulator endpoint
EMULATOR_BASE = "http://127.0.0.1:8080/v1/projects/vybemvp/databases/(default)/documents"
COLLECTION_NAME = "insights_staging"


def upload_file_to_emulator(file_number, file_path):
    """Upload a single NumberMessages_Complete file to the emulator"""
    print(f"Processing file {file_number}: {file_path}")

    try:
        with open(file_path, "r") as f:
            data = json.load(f)

        # Extract the number data (should be key like "0", "1", etc.)
        number_key = str(file_number)
        if number_key not in data:
            print(f"ERROR: Key '{number_key}' not found in {file_path}")
            return False

        number_data = data[number_key]

        # Prepare the document for Firebase
        document_id = f"{file_number}-runtime-033"
        url = f"{EMULATOR_BASE}/{COLLECTION_NAME}/{document_id}"

        # Transform the data to Firebase format
        firebase_doc = {
            "fields": {
                "number": {"integerValue": str(file_number)},
                "data": {"mapValue": {"fields": {}}},
                "primary_persona": {"stringValue": data.get("primary_persona", "Oracle")},
            }
        }

        # Convert each category to Firebase format
        for category, values in number_data.items():
            if isinstance(values, list):
                firebase_values = []
                for value in values:
                    firebase_values.append({"stringValue": str(value)})
                firebase_doc["fields"]["data"]["mapValue"]["fields"][category] = {
                    "arrayValue": {"values": firebase_values}
                }
            else:
                firebase_doc["fields"]["data"]["mapValue"]["fields"][category] = {
                    "stringValue": str(values)
                }

        # Upload to emulator
        response = requests.patch(url, json=firebase_doc)

        if response.status_code in [200, 201]:
            print(f"✅ Successfully uploaded {document_id}")
            return True
        else:
            print(f"❌ Failed to upload {document_id}: {response.status_code}")
            print(f"Response: {response.text}")
            return False

    except Exception as e:
        print(f"❌ Error processing {file_path}: {str(e)}")
        return False


def main():
    """Upload all converted NumberMessages_Complete files"""
    base_path = (
        "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/FirebaseNumberMeanings"
    )

    # Files we know are converted (0-6 so far)
    converted_files = [0, 1, 2, 3, 4, 5, 6]

    print("🚀 Starting upload to Firebase emulator...")

    success_count = 0
    for file_num in converted_files:
        file_path = f"{base_path}/NumberMessages_Complete_{file_num}.json"
        if os.path.exists(file_path):
            if upload_file_to_emulator(file_num, file_path):
                success_count += 1
        else:
            print(f"⚠️  File not found: {file_path}")

    print(
        f"\n✨ Upload complete! {success_count}/{len(converted_files)} files uploaded successfully."
    )
    print("Check the emulator at: http://127.0.0.1:4000/firestore/default/data/insights_staging")


if __name__ == "__main__":
    main()
