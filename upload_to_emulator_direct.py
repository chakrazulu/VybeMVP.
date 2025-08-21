#!/usr/bin/env python3
"""
Upload converted NumberMessages_Complete files directly to Firebase emulator using admin endpoints.
"""

import json
import os

import requests


def upload_document(doc_id, data):
    """Upload a single document using emulator admin API"""
    # Use the emulator's admin REST endpoint that bypasses security rules
    url = f"http://localhost:8080/emulator/v1/projects/vybemvp/databases/(default)/documents/insights_staging/{doc_id}"

    # Create the document structure
    document = {
        "fields": {
            "number": {"integerValue": str(data["number"])},
            "primary_persona": {"stringValue": data["primary_persona"]},
        }
    }

    # Add all the insight data
    for category, values in data["data"].items():
        if isinstance(values, list):
            firebase_values = []
            for value in values:
                firebase_values.append({"stringValue": str(value)})
            document["fields"][category] = {"arrayValue": {"values": firebase_values}}
        else:
            document["fields"][category] = {"stringValue": str(values)}

    try:
        response = requests.put(url, json=document, timeout=10)
        if response.status_code in [200, 201]:
            print(f"✅ Successfully uploaded {doc_id}")
            return True
        else:
            print(f"❌ Failed to upload {doc_id}: {response.status_code}")
            print(f"Response: {response.text}")
            return False
    except requests.exceptions.RequestException as e:
        print(f"❌ Error uploading {doc_id}: {str(e)}")
        return False


def main():
    """Upload all converted files"""
    base_path = (
        "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/FirebaseNumberMeanings"
    )
    converted_files = [0, 1, 2, 3, 4, 5, 6]  # Files we know are converted

    print("🚀 Starting direct upload to Firebase emulator...")

    success_count = 0

    for file_num in converted_files:
        file_path = f"{base_path}/NumberMessages_Complete_{file_num}.json"

        if not os.path.exists(file_path):
            print(f"⚠️  File not found: {file_path}")
            continue

        print(f"Processing file {file_num}...")

        try:
            with open(file_path, "r") as f:
                file_data = json.load(f)

            # Extract the number data
            number_key = str(file_num)
            if number_key not in file_data:
                print(f"⚠️  No data found for key '{number_key}' in {file_path}")
                continue

            doc_data = {
                "number": file_num,
                "data": file_data[number_key],
                "primary_persona": file_data.get("primary_persona", "Oracle"),
            }

            doc_id = f"{file_num}-runtime-033"
            if upload_document(doc_id, doc_data):
                success_count += 1

        except Exception as e:
            print(f"❌ Error processing {file_path}: {str(e)}")

    print(
        f"\n✨ Upload complete! {success_count}/{len(converted_files)} files uploaded successfully."
    )
    print("🌐 Check the emulator at: http://127.0.0.1:4000/firestore/default/data/insights_staging")


if __name__ == "__main__":
    main()
