#!/usr/bin/env python3
"""
KASPER MLX POSIX Path Tests
Ensures manifest uses forward slashes for cross-platform compatibility
Critical for Windows/Mac/Linux consistency
"""
import json
import sys
import unittest
from pathlib import Path

import pytest

# Add project root to path
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))


class TestPOSIXPaths(unittest.TestCase):
    def setUp(self):
        """Setup test environment"""
        self.manifest_path = project_root / "artifacts" / "MANIFEST.json"

    @pytest.mark.structural
    def test_manifest_uses_posix_paths(self):
        """Verify all paths in manifest use forward slashes (POSIX format)"""
        if not self.manifest_path.exists():
            self.skipTest("MANIFEST.json not found - run generator first")

        with open(self.manifest_path, "r") as f:
            manifest = json.load(f)

        # Check all file paths
        for file_entry in manifest.get("files", []):
            path = file_entry.get("path", "")

            # Verify no backslashes (Windows paths)
            self.assertNotIn("\\", path, f"Path contains backslash (non-POSIX): {path}")

            # Verify forward slashes are used for subdirectories
            if "/" in path:
                self.assertTrue(path.count("/") > 0, f"Path should use forward slashes: {path}")

            # Verify path doesn't start with absolute marker
            self.assertFalse(path.startswith("/"), f"Path should be relative, not absolute: {path}")

            # Verify no drive letters (Windows C:\ etc)
            self.assertFalse(":" in path, f"Path contains drive letter or colon: {path}")

        print(f"✅ All {len(manifest.get('files', []))} paths use POSIX format")

    @pytest.mark.structural
    def test_manifest_paths_are_relative(self):
        """Verify all paths are relative to repo root"""
        if not self.manifest_path.exists():
            self.skipTest("MANIFEST.json not found - run generator first")

        with open(self.manifest_path, "r") as f:
            manifest = json.load(f)

        for file_entry in manifest.get("files", []):
            path = file_entry.get("path", "")

            # Should start with KASPERMLX (the expected relative path)
            self.assertTrue(
                path.startswith("KASPERMLX/"), f"Path should be relative to repo root: {path}"
            )

            # Should not contain parent directory references
            self.assertNotIn(
                "..", path, f"Path should not contain parent directory references: {path}"
            )

        print("✅ All paths are properly relative to repo root")


if __name__ == "__main__":
    unittest.main(verbosity=2)
