#!/usr/bin/env python3
"""
KASPER MLX Schema Enforcement Tests
Validates sample files, intensity bounds, and category counts
"""

import json
import sys
import unittest
from pathlib import Path

import pytest

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent.parent))

from make_release_cards import KASPERReleaseCardsGenerator  # noqa: E402


class TestSchemaEnforcement(unittest.TestCase):
    """Test suite for KASPER MLX schema compliance."""

    def setUp(self):
        """Set up test fixtures."""
        self.generator = KASPERReleaseCardsGenerator()
        self.approved_dir = self.generator.approved_dir

        # Find sample files for testing
        self.sample_expression = None
        self.sample_soul_urge = None
        self.sample_life_path = None

        if self.approved_dir.exists():
            expression_files = list(self.approved_dir.glob("expression_*.json"))
            soul_urge_files = list(self.approved_dir.glob("soulUrge_*.json"))
            life_path_files = list(self.approved_dir.glob("lifePath_*.json"))

            if expression_files:
                self.sample_expression = expression_files[0]
            if soul_urge_files:
                self.sample_soul_urge = soul_urge_files[0]
            if life_path_files:
                self.sample_life_path = life_path_files[0]

    @pytest.mark.structural
    def test_sample_file_validation(self):
        """Test that sample files can be loaded and parsed as JSON."""
        if self.sample_expression:
            with open(self.sample_expression, "r", encoding="utf-8") as f:
                data = json.load(f)
                self.assertIsInstance(data, dict)
                self.assertIn("meta", data)

    @pytest.mark.structural
    def test_intensity_bounds(self):
        """Test that intensity values are within 0.60-0.90 range."""
        if self.sample_expression:
            with open(self.sample_expression, "r", encoding="utf-8") as f:
                data = json.load(f)

            if "profiles" in data and data["profiles"]:
                profile = data["profiles"][0]
                if "behavioral" in profile:
                    behavioral = profile["behavioral"]

                    for category_name, insights in behavioral.items():
                        if isinstance(insights, list):
                            for insight in insights:
                                if isinstance(insight, dict) and "intensity" in insight:
                                    intensity = insight["intensity"]
                                    self.assertGreaterEqual(
                                        intensity,
                                        0.60,
                                        f"Intensity {intensity} in {category_name} below minimum 0.60",
                                    )
                                    self.assertLessEqual(
                                        intensity,
                                        0.90,
                                        f"Intensity {intensity} in {category_name} above maximum 0.90",
                                    )

    @pytest.mark.structural
    def test_category_count(self):
        """Test that behavioral categories have expected structure."""
        expected_categories = [
            "decisionMaking",
            "stressResponse",
            "communication",
            "relationships",
            "productivity",
            "financial",
            "creative",
            "wellness",
            "learning",
            "spiritual",
            "transitions",
            "shadow",
        ]

        if self.sample_expression:
            with open(self.sample_expression, "r", encoding="utf-8") as f:
                data = json.load(f)

            if "profiles" in data and data["profiles"]:
                profile = data["profiles"][0]
                if "behavioral" in profile:
                    behavioral = profile["behavioral"]

                    # Check that all expected categories are present
                    for category in expected_categories:
                        self.assertIn(
                            category,
                            behavioral,
                            f"Missing required behavioral category: {category}",
                        )

                        # Check insight count for each category
                        insights = behavioral[category]
                        if isinstance(insights, list):
                            self.assertEqual(
                                len(insights),
                                12,
                                f"Category '{category}' has {len(insights)} insights, expected 12",
                            )

    def test_generator_initialization(self):
        """Test that the generator initializes correctly."""
        generator = KASPERReleaseCardsGenerator()
        self.assertTrue(generator.project_root.exists())
        self.assertTrue(generator.approved_dir.exists())

    def test_manifest_generation_structure(self):
        """Test that manifest has required structure."""
        # Create minimal test data
        test_categories = {"expression": []}
        if self.sample_expression:
            test_categories["expression"] = [self.sample_expression]

        manifest = self.generator.generate_manifest(test_categories)

        # Check required fields
        required_fields = [
            "manifest_version",
            "generated_at",
            "dataset_name",
            "dataset_version",
            "total_files",
            "total_bytes",
            "files",
            "dataset_digest",
        ]

        for field in required_fields:
            self.assertIn(field, manifest, f"Missing required field: {field}")

        # Check file entries structure
        for file_entry in manifest["files"]:
            file_required_fields = ["path", "filename", "category", "sha256", "bytes"]
            for field in file_required_fields:
                self.assertIn(field, file_entry, f"Missing file field: {field}")

            # Check SHA256 format
            self.assertEqual(len(file_entry["sha256"]), 64, "SHA256 hash must be 64 characters")


if __name__ == "__main__":
    unittest.main()
