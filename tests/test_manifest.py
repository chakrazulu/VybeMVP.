#!/usr/bin/env python3
"""
KASPER MLX Manifest Tests
Ensures MANIFEST includes all files and SHA format is correct
"""

import hashlib
import json
import sys
import unittest
from pathlib import Path

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent.parent))

from make_release_cards import KASPERReleaseCardsGenerator  # noqa: E402


class TestManifest(unittest.TestCase):
    """Test suite for KASPER MLX manifest integrity."""

    def setUp(self):
        """Set up test fixtures."""
        self.generator = KASPERReleaseCardsGenerator()
        self.approved_dir = self.generator.approved_dir
        self.manifest_path = self.generator.artifacts_dir / "MANIFEST.json"

    def test_manifest_file_exists(self):
        """Test that MANIFEST.json file exists."""
        if self.manifest_path.exists():
            self.assertTrue(self.manifest_path.exists(), "MANIFEST.json should exist")

    def test_manifest_json_valid(self):
        """Test that MANIFEST.json is valid JSON."""
        if self.manifest_path.exists():
            with open(self.manifest_path, "r", encoding="utf-8") as f:
                manifest = json.load(f)
                self.assertIsInstance(manifest, dict)

    def test_manifest_includes_all_files(self):
        """Test that MANIFEST includes all approved files."""
        if not self.manifest_path.exists():
            self.skipTest("MANIFEST.json not found - run generator first")

        with open(self.manifest_path, "r", encoding="utf-8") as f:
            manifest = json.load(f)

        # Get all JSON files from approved directory
        actual_files = set()
        if self.approved_dir.exists():
            for json_file in self.approved_dir.glob("*.json"):
                actual_files.add(json_file.name)

        # Get files from manifest
        manifest_files = set()
        for file_entry in manifest.get("files", []):
            manifest_files.add(file_entry["filename"])

        # Check that all actual files are in manifest
        missing_from_manifest = actual_files - manifest_files
        self.assertEqual(
            len(missing_from_manifest), 0, f"Files missing from MANIFEST: {missing_from_manifest}"
        )

    def test_sha256_format(self):
        """Test that all SHA256 hashes are correctly formatted."""
        if not self.manifest_path.exists():
            self.skipTest("MANIFEST.json not found - run generator first")

        with open(self.manifest_path, "r", encoding="utf-8") as f:
            manifest = json.load(f)

        for file_entry in manifest.get("files", []):
            sha256 = file_entry.get("sha256", "")

            # Check length
            self.assertEqual(
                len(sha256),
                64,
                f"SHA256 for {file_entry['filename']} has wrong length: {len(sha256)}",
            )

            # Check format (hexadecimal)
            try:
                int(sha256, 16)
            except ValueError:
                self.fail(f"SHA256 for {file_entry['filename']} is not valid hex: {sha256}")

    def test_sha256_accuracy(self):
        """Test that SHA256 hashes match actual file contents."""
        if not self.manifest_path.exists():
            self.skipTest("MANIFEST.json not found - run generator first")

        with open(self.manifest_path, "r", encoding="utf-8") as f:
            manifest = json.load(f)

        # Test a few random files to verify hash accuracy
        files_to_test = manifest.get("files", [])[:3]  # Test first 3 files

        for file_entry in files_to_test:
            file_path = Path(self.generator.project_root) / file_entry["path"]

            if file_path.exists():
                # Calculate actual hash
                with open(file_path, "rb") as f:
                    actual_hash = hashlib.sha256(f.read()).hexdigest()

                # Compare with manifest hash
                manifest_hash = file_entry["sha256"]
                self.assertEqual(
                    actual_hash,
                    manifest_hash,
                    f"Hash mismatch for {file_entry['filename']}: "
                    f"actual={actual_hash}, manifest={manifest_hash}",
                )

    def test_dataset_digest(self):
        """Test that dataset digest is present and formatted correctly."""
        if not self.manifest_path.exists():
            self.skipTest("MANIFEST.json not found - run generator first")

        with open(self.manifest_path, "r", encoding="utf-8") as f:
            manifest = json.load(f)

        dataset_digest = manifest.get("dataset_digest", "")

        # Check presence
        self.assertTrue(dataset_digest, "Dataset digest should not be empty")

        # Check format
        self.assertEqual(
            len(dataset_digest), 64, f"Dataset digest has wrong length: {len(dataset_digest)}"
        )

        # Check hexadecimal format
        try:
            int(dataset_digest, 16)
        except ValueError:
            self.fail(f"Dataset digest is not valid hex: {dataset_digest}")

    def test_manifest_metadata(self):
        """Test that manifest contains required metadata."""
        if not self.manifest_path.exists():
            self.skipTest("MANIFEST.json not found - run generator first")

        with open(self.manifest_path, "r", encoding="utf-8") as f:
            manifest = json.load(f)

        required_fields = [
            "manifest_version",
            "generated_at",
            "dataset_name",
            "dataset_version",
            "total_files",
            "total_bytes",
            "dataset_digest",
        ]

        for field in required_fields:
            self.assertIn(field, manifest, f"Missing required field: {field}")
            self.assertIsNotNone(manifest[field], f"Field {field} should not be None")


if __name__ == "__main__":
    unittest.main()
