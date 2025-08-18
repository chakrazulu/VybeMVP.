#!/usr/bin/env python3
"""
🚀 Insight Promotion Script - Move selected insights from staging to prod
Safely promote curated insights for your app to consume
"""

import json
import time
import urllib.parse
import urllib.request
from datetime import datetime

# Configuration
GOOGLE_SERVICE_INFO_PATH = (
    "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/GoogleService-Info.plist"
)
STAGING_COLLECTION = "insights_staging"
PROD_COLLECTION = "insights_prod"


def load_firebase_config():
    """Load Firebase config"""
    try:
        import plistlib

        with open(GOOGLE_SERVICE_INFO_PATH, "rb") as f:
            config = plistlib.load(f)
        return config.get("PROJECT_ID"), config.get("API_KEY")
    except Exception as e:
        print(f"❌ Firebase config error: {e}")
        return None, None


def fetch_insights_from_staging(project_id, api_key, filters=None):
    """Fetch insights from staging based on filters"""
    base_url = f"https://firestore.googleapis.com/v1/projects/{project_id}/databases/(default)/documents/{STAGING_COLLECTION}"

    # Build query URL
    url = f"{base_url}?key={api_key}"

    # Add filters if provided
    if filters:
        if "number" in filters:
            url += f"&where=number,EQUAL,{filters['number']}"
        if "limit" in filters:
            url += f"&pageSize={filters['limit']}"

    try:
        with urllib.request.urlopen(url) as response:
            data = json.loads(response.read().decode())

            if "documents" not in data:
                return []

            insights = []
            for doc in data["documents"]:
                # Parse Firestore document format
                insight = {"id": doc["name"].split("/")[-1]}

                for field_name, field_value in doc.get("fields", {}).items():
                    if "stringValue" in field_value:
                        insight[field_name] = field_value["stringValue"]
                    elif "integerValue" in field_value:
                        insight[field_name] = int(field_value["integerValue"])
                    elif "doubleValue" in field_value:
                        insight[field_name] = field_value["doubleValue"]

                insights.append(insight)

            return insights

    except Exception as e:
        print(f"❌ Error fetching from staging: {e}")
        return []


def promote_insight_to_prod(project_id, api_key, insight):
    """Promote single insight to production"""
    base_url = f"https://firestore.googleapis.com/v1/projects/{project_id}/databases/(default)/documents/{PROD_COLLECTION}"

    # Convert back to Firestore format
    firestore_doc = {"fields": {}}

    for key, value in insight.items():
        if key == "id":
            continue

        if isinstance(value, str):
            firestore_doc["fields"][key] = {"stringValue": value}
        elif isinstance(value, int):
            firestore_doc["fields"][key] = {"integerValue": str(value)}
        elif isinstance(value, float):
            firestore_doc["fields"][key] = {"doubleValue": value}

    # Add promotion metadata
    firestore_doc["fields"]["promoted_at"] = {"stringValue": datetime.now().isoformat()}
    firestore_doc["fields"]["promoted_from"] = {"stringValue": "staging"}

    url = f"{base_url}/{insight['id']}?key={api_key}"

    try:
        data = json.dumps(firestore_doc).encode("utf-8")
        req = urllib.request.Request(url, data=data, method="PATCH")
        req.add_header("Content-Type", "application/json")

        with urllib.request.urlopen(req) as response:
            return response.status in [200, 201]
    except Exception as e:
        print(f"   ❌ Error promoting {insight['id']}: {e}")
        return False


def promote_starter_set():
    """Promote a starter set of insights for immediate app use"""
    print("🚀 Promoting Starter Set to Production")
    print("=" * 45)

    project_id, api_key = load_firebase_config()
    if not project_id:
        return

    promoted = 0

    # Promote insights for each number 0-9
    for number in range(10):
        print(f"\n📊 Promoting insights for Number {number}")

        # Fetch high-quality insights for this number
        filters = {"number": number, "limit": 10}  # 10 per number = 100 total
        insights = fetch_insights_from_staging(project_id, api_key, filters)

        if not insights:
            print(f"   ⚠️ No insights found for number {number}")
            continue

        # Promote top quality insights
        number_promoted = 0
        for insight in insights:
            # Filter for high quality
            if insight.get("quality_score", 0) >= 0.9:
                if promote_insight_to_prod(project_id, api_key, insight):
                    promoted += 1
                    number_promoted += 1

                    if number_promoted >= 10:  # Max 10 per number
                        break

                time.sleep(0.1)  # Rate limiting

        print(f"   ✅ Promoted {number_promoted} insights for number {number}")

    print("\n🎉 Promotion Complete!")
    print(f"✅ Total promoted: {promoted} insights")
    print(f"🎯 Collection: {PROD_COLLECTION}")
    print("📱 Your app can now read from insights_prod!")


def promote_specific_criteria():
    """Promote insights based on specific criteria"""
    print("🎯 Custom Promotion - Select Your Criteria")
    print("=" * 40)

    # Get user input for criteria
    print("Available criteria:")
    print("1. Number (0-9)")
    print("2. Persona (oracle, psychologist, coach, philosopher, healer)")
    print("3. Context (daily, morning_awakening, evening_integration)")
    print("4. Category (insight, reflection, manifestation, challenge)")

    choice = input("\nSelect criteria (1-4): ").strip()

    project_id, api_key = load_firebase_config()
    if not project_id:
        return

    if choice == "1":
        number = input("Enter number (0-9): ").strip()
        if number.isdigit() and 0 <= int(number) <= 9:
            filters = {"number": int(number), "limit": 50}
            insights = fetch_insights_from_staging(project_id, api_key, filters)

            promoted = 0
            for insight in insights:
                if promote_insight_to_prod(project_id, api_key, insight):
                    promoted += 1
                time.sleep(0.1)

            print(f"✅ Promoted {promoted} insights for number {number}")
        else:
            print("❌ Invalid number")

    else:
        print("⚠️ Other criteria coming soon! Use starter set for now.")


def main():
    """Main promotion interface"""
    print("🚀 Firebase Insight Promotion Tool")
    print("=" * 35)

    print("\nPromotion Options:")
    print("1. Starter Set (10 insights per number = 100 total)")
    print("2. Custom Criteria")
    print("3. Check promotion status")

    choice = input("\nSelect option (1-3): ").strip()

    if choice == "1":
        promote_starter_set()
    elif choice == "2":
        promote_specific_criteria()
    elif choice == "3":
        # Check current prod count
        project_id, api_key = load_firebase_config()
        if project_id:
            base_url = f"https://firestore.googleapis.com/v1/projects/{project_id}/databases/(default)/documents/{PROD_COLLECTION}"
            url = f"{base_url}?key={api_key}&pageSize=1"

            try:
                with urllib.request.urlopen(url) as response:
                    data = json.loads(response.read().decode())
                    count = len(data.get("documents", []))
                    print(f"📊 Current insights_prod count: {count}+")
            except Exception:
                print("❌ Could not check production count")
    else:
        print("❌ Invalid choice")


if __name__ == "__main__":
    main()
