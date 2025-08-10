#!/usr/bin/env python3
"""
KASPER MLX Determinism Tests
Ensures dataset digest is stable across multiple generator runs
This is critical for reproducible ML releases
"""
import hashlib
import json
import pathlib
import subprocess
import sys
import time
import unittest

import pytest

# Add project root to path for imports
project_root = pathlib.Path(__file__).parent.parent
sys.path.insert(0, str(project_root))


class TestDeterminism(unittest.TestCase):
    def setUp(self):
        """Setup test environment"""
        self.manifest_path = project_root / "artifacts" / "MANIFEST.json"
        self.artifacts_dir = project_root / "artifacts"

        # Ensure artifacts directory exists
        self.artifacts_dir.mkdir(exist_ok=True)

    def run_generator(self):
        """Run the release cards generator"""
        # Clean previous manifest
        if self.manifest_path.exists():
            self.manifest_path.unlink()

        # Run generator
        result = subprocess.run(
            [sys.executable, "scripts/release_cards.py"],
            cwd=project_root,
            capture_output=True,
            text=True,
        )

        if result.returncode != 0:
            self.fail(f"Generator failed: {result.stderr}")

        return result

    @pytest.mark.structural
    def test_manifest_digest_is_stable(self):
        """Verify dataset digest is identical across runs"""
        print("\n🔬 Testing deterministic dataset digest...")

        # First run
        print("   • First generator run...")
        self.run_generator()
        self.assertTrue(self.manifest_path.exists(), "MANIFEST.json not generated on first run")

        manifest1 = json.loads(self.manifest_path.read_text())
        digest1 = manifest1.get("dataset_digest")
        self.assertIsNotNone(digest1, "dataset_digest missing from first manifest")

        # Small delay to ensure timestamps change
        time.sleep(1.1)

        # Second run
        print("   • Second generator run...")
        self.run_generator()
        self.assertTrue(self.manifest_path.exists(), "MANIFEST.json not generated on second run")

        manifest2 = json.loads(self.manifest_path.read_text())
        digest2 = manifest2.get("dataset_digest")
        self.assertIsNotNone(digest2, "dataset_digest missing from second manifest")

        # Critical assertion: digests must be identical
        self.assertEqual(
            digest1,
            digest2,
            f"❌ Non-deterministic dataset_digest detected!\n"
            f"   First run:  {digest1}\n"
            f"   Second run: {digest2}\n"
            f"   This breaks reproducible releases!",
        )

        print(f"   ✅ Dataset digest stable: {digest1[:12]}...")

    @pytest.mark.structural
    def test_file_count_consistency(self):
        """Verify file counts remain consistent across runs"""
        print("\n🔬 Testing consistent file counts...")

        # First run
        self.run_generator()
        manifest1 = json.loads(self.manifest_path.read_text())
        file_count1 = manifest1.get("total_files", 0)

        # Second run
        time.sleep(0.5)
        self.run_generator()
        manifest2 = json.loads(self.manifest_path.read_text())
        file_count2 = manifest2.get("total_files", 0)

        self.assertEqual(
            file_count1, file_count2, f"File count inconsistency: {file_count1} vs {file_count2}"
        )

        print(f"   ✅ File count stable: {file_count1} files")

    @pytest.mark.structural
    def test_release_tag_format(self):
        """Verify release tag follows expected format"""
        print("\n🔬 Testing release tag format...")

        self.run_generator()
        manifest = json.loads(self.manifest_path.read_text())

        release_info = manifest.get("release_info", {})
        release_tag = release_info.get("release_tag")

        self.assertIsNotNone(release_tag, "release_tag missing from manifest")

        # Verify format: kasper-lp-trinity_vYYYY.MM.DD_build1

        pattern = r"^kasper-lp-trinity_v\d{4}\.\d{2}\.\d{2}_build\d+$"
        self.assertRegex(release_tag, pattern, f"Release tag format invalid: {release_tag}")

        print(f"   ✅ Release tag format valid: {release_tag}")

    @pytest.mark.skip(reason="ZIP bundles intentionally include build timestamps")
    @pytest.mark.structural
    def test_reproducible_zip_bundles(self):
        """Verify ZIP bundles are byte-for-byte identical across runs"""
        print("\n🔬 Testing reproducible ZIP bundles...")

        bundle_path = self.artifacts_dir / "release_cards_bundle.zip"

        # First run
        print("   • First bundle generation...")
        self.run_generator()
        self.assertTrue(bundle_path.exists(), "ZIP bundle not generated on first run")

        with open(bundle_path, "rb") as f:
            bundle1_bytes = f.read()
        bundle1_hash = hashlib.sha256(bundle1_bytes).hexdigest()

        # Small delay to ensure any time-dependent changes would show up
        time.sleep(1.1)

        # Second run
        print("   • Second bundle generation...")
        self.run_generator()
        self.assertTrue(bundle_path.exists(), "ZIP bundle not generated on second run")

        with open(bundle_path, "rb") as f:
            bundle2_bytes = f.read()
        bundle2_hash = hashlib.sha256(bundle2_bytes).hexdigest()

        # Critical assertion: ZIP bundles must be byte-identical
        self.assertEqual(
            bundle1_hash,
            bundle2_hash,
            f"❌ Non-reproducible ZIP bundle detected!\n"
            f"   First run SHA256:  {bundle1_hash}\n"
            f"   Second run SHA256: {bundle2_hash}\n"
            f"   This indicates timestamp or permission drift in ZIP creation!",
        )

        print(f"   ✅ ZIP bundle reproducible: {bundle1_hash[:12]}...")


if __name__ == "__main__":
    # Run with verbose output
    unittest.main(verbosity=2)
