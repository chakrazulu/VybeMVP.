#!/usr/bin/env python3
# vybe_import_insights.py
#
# Idempotent importer for Vybe Number Insights.
# - Reads NumberMessages_Complete_X.json (+ optional *_archetypal.json) where X=0..9
# - Imports only category == "insight" by default (use --categories to include more)
# - Guarantees number mapping from filename (authoritative)
# - Deterministic doc IDs prevent duplicates across runs
# - Dry-run by default; use --commit to write
#
# Usage examples:
#   python vybe_import_insights.py --input /path/to/FirebaseNumberMeanings --project your-gcp-project
#   python vybe_import_insights.py --input ./NumerologyData/FirebaseNumberMeanings --use-emulator --commit
#   python vybe_import_insights.py --input ./data --categories insight reflection --commit
#
# Firestore auth:
#   - PROD: export GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json
#   - EMULATOR: export FIRESTORE_EMULATOR_HOST=localhost:8080  (or use --use-emulator)
#
import argparse
import glob
import hashlib
import json
import os
import re
import sys
from datetime import datetime, timezone

# Only import firestore when we actually commit or when requested (so dry-run works without creds)
try:
    from google.cloud import firestore
except Exception:
    firestore = None

BATCH_LIMIT = 450

NUMBER_WORDS = {
    "zero": 0,
    "zeros": 0,
    "0": 0,
    "one": 1,
    "ones": 1,
    "1": 1,
    "two": 2,
    "twos": 2,
    "2": 2,
    "three": 3,
    "threes": 3,
    "3": 3,
    "four": 4,
    "fours": 4,
    "4": 4,
    "five": 5,
    "fives": 5,
    "5": 5,
    "six": 6,
    "sixes": 6,
    "6": 6,
    "seven": 7,
    "sevens": 7,
    "7": 7,
    "eight": 8,
    "eights": 8,
    "8": 8,
    "nine": 9,
    "nines": 9,
    "9": 9,
}


def normalize_text(s: str) -> str:
    s = s.replace("\u2019", "'").replace("\u201c", '"').replace("\u201d", '"')
    s = s.replace("\u2014", "-").replace("\u2013", "-")
    s = s.strip().lower()
    s = re.sub(r"\s+", " ", s)
    return s


def sha256_hash(s: str) -> str:
    return hashlib.sha256(normalize_text(s).encode("utf-8")).hexdigest()


def expected_number_from_filename(path: str) -> int:
    m = re.search(r"NumberMessages_Complete_([0-9])", os.path.basename(path))
    if not m:
        raise ValueError(f"Cannot derive number from filename: {path}")
    return int(m.group(1))


def detect_number_mentions(text: str) -> set[int]:
    toks = re.findall(r"[a-z0-9]+", text.lower())
    return {NUMBER_WORDS[t] for t in toks if t in NUMBER_WORDS}


def iter_records_from_file(path: str, allowed_categories: set[str]):
    with open(path, "r") as f:
        data = json.load(f)

    num = expected_number_from_filename(path)
    is_archetypal = "archetypal" in path.lower()
    node = data.get(str(num), {})

    for category, arr in node.items():
        if allowed_categories and category not in allowed_categories:
            continue
        if not isinstance(arr, list):
            continue
        for item in arr:
            if isinstance(item, dict):
                # Archetypal objects: take the "insight" field for the textual payload
                text = item.get("insight", "")
            else:
                text = str(item)
            text = text.strip()
            if not text:
                continue
            yield {
                "number": num,
                "category": category,
                "source_file": os.path.basename(path),
                "source_type": "archetypal" if is_archetypal else "base",
                "text": text,
            }


def load_manifest(input_dir: str, categories: list[str]):
    paths = sorted(glob.glob(os.path.join(input_dir, "NumberMessages_Complete_*.json")))
    if not paths:
        raise SystemExit(f"No JSON files found in: {input_dir}")

    allowed = set([c.strip() for c in categories]) if categories else {"insight"}
    rows = []
    seen_hashes = set()

    for p in paths:
        for rec in iter_records_from_file(p, allowed):
            h = sha256_hash(rec["text"])
            if h in seen_hashes:
                # Deduplicate across sources/categories if the text is exactly the same
                continue
            seen_hashes.add(h)

            mentions = detect_number_mentions(rec["text"])
            validation = "ok"
            if len(mentions) == 0:
                validation = "no_number_mentioned"
            elif rec["number"] in mentions and len(mentions) == 1:
                validation = "mentions_expected_only"
            elif rec["number"] in mentions and len(mentions) > 1:
                validation = "mentions_expected_and_others"
            elif rec["number"] not in mentions:
                validation = "mentions_other_number_only"

            rec.update(
                {
                    "text_hash": h,
                    "mentions": sorted(list(mentions)),
                    "validation": validation,
                }
            )
            rows.append(rec)

    rows.sort(key=lambda r: (r["number"], r["category"], r["source_type"], r["source_file"]))
    return rows


def make_doc_id(number: int, text_hash: str) -> str:
    return f"{number}-{text_hash[:16]}"


def connect_firestore(project: str, use_emulator: bool):
    if firestore is None:
        raise SystemExit("google-cloud-firestore not installed. pip install google-cloud-firestore")

    if use_emulator:
        os.environ.setdefault("FIRESTORE_EMULATOR_HOST", "localhost:8080")
    return firestore.Client(project=project)


def write_batch(db, collection: str, items: list[dict], commit: bool):
    batch = db.batch()
    count = 0
    created = 0
    updated = 0
    for rec in items:
        doc_id = make_doc_id(rec["number"], rec["text_hash"])
        doc_ref = db.collection(collection).document(doc_id)
        payload = {
            "text": rec["text"],
            "number": rec["number"],
            "category": "insight",  # your target structure
            "system": "number",
            "quality_score": 1.0,
            "created_at": firestore.SERVER_TIMESTAMP if commit else None,
            # additional useful fields for later audit/dedup:
            "text_hash": rec["text_hash"],
            "source_file": rec["source_file"],
            "source_type": rec["source_type"],
        }

        # For idempotence: use set() with merge=False on deterministic ID.
        # If you *only* want to create (not overwrite), you can use a precondition:
        #   doc_ref.create(payload)
        # but that will throw AlreadyExists on reruns. We'll use set() for simplicity.
        batch.set(doc_ref, payload, merge=False)
        count += 1
        if count >= BATCH_LIMIT:
            if commit:
                batch.commit()
            created += count  # we treat set() as (create/overwrite); duplicates can't appear with deterministic IDs
            count = 0
            batch = db.batch()

    if count:
        if commit:
            batch.commit()
        created += count

    return created, updated


def write_log_csv(path: str, items: list[dict]):
    import csv

    with open(path, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(
            [
                "doc_id",
                "number",
                "category",
                "source_type",
                "source_file",
                "text_len",
                "text_hash",
                "validation",
                "mentions",
                "text",
            ]
        )
        for r in items:
            doc_id = make_doc_id(r["number"], r["text_hash"])
            w.writerow(
                [
                    doc_id,
                    r["number"],
                    r["category"],
                    r["source_type"],
                    r["source_file"],
                    len(r["text"]),
                    r["text_hash"],
                    r["validation"],
                    "|".join(map(str, r["mentions"])),
                    r["text"],
                ]
            )


def main():
    ap = argparse.ArgumentParser(description="Vybe Number Insights Importer (idempotent)")
    ap.add_argument(
        "--input", required=True, help="Directory containing NumberMessages_Complete_X*.json files"
    )
    ap.add_argument(
        "--project", default=None, help="GCP Project ID (required if committing outside emulator)"
    )
    ap.add_argument("--collection", default="insights_staging", help="Firestore collection name")
    ap.add_argument(
        "--categories",
        nargs="*",
        default=["insight"],
        help="Categories to import (default: insight)",
    )
    ap.add_argument(
        "--use-emulator", action="store_true", help="Use Firestore emulator (localhost:8080)"
    )
    ap.add_argument(
        "--commit", action="store_true", help="Actually write to Firestore. Default is dry-run."
    )
    ap.add_argument(
        "--expect-total", type=int, default=None, help="Assert this many rows will be imported"
    )
    args = ap.parse_args()

    items = load_manifest(args.input, args.categories)
    now = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    log_path = f"import_log_{now}.csv"

    # Summaries
    from collections import Counter

    by_num = Counter([r["number"] for r in items])
    by_num_src = Counter([(r["number"], r["source_type"]) for r in items])

    print("\n=== PLAN ===")
    print(f"Input dir             : {args.input}")
    print(f"Firestore collection  : {args.collection}")
    print(f"Categories            : {args.categories}")
    print(f"Total unique rows     : {len(items)}")
    print("By number             :", dict(sorted(by_num.items())))
    print("By (number,source)    :", dict(sorted(by_num_src.items())))
    suspicious = [r for r in items if r["validation"] in ("mentions_other_number_only")]
    print(f"Validation warnings   : {len(suspicious)} rows mention other numbers only.")
    print(f"CSV plan              : {log_path}")

    # Optional guardrail: exact expected total
    if args.expect_total is not None and len(items) != args.expect_total:
        print(f"ABORT: expected total {args.expect_total} but found {len(items)}")
        sys.exit(2)

    write_log_csv(log_path, items)

    if not args.commit:
        print("\nDRY-RUN complete. No writes performed.")
        return

    if not args.use_emulator and not args.project:
        print("ABORT: --project is required when not using emulator.")
        sys.exit(2)

    db = connect_firestore(args.project, args.use_emulator)
    created, updated = write_batch(db, args.collection, items, commit=True)
    print(f"\nWRITE SUMMARY: created/overwritten={created}, updated={updated}")
    print(f"Import log written to {log_path}")


if __name__ == "__main__":
    main()
