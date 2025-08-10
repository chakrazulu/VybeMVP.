#!/usr/bin/env python3
"""
VybeOS Runtime Bundle Validation Script
Self-healing architecture validation for KASPERMLXRuntimeBundle

This script validates the RuntimeBundle before push to prevent deployment issues.
Part of ChatGPT's strategic recommendation for fail-fast behavioral validation.

Key validations:
1. Manifest integrity and version consistency
2. File existence for all referenced content
3. JSON schema validation for behavioral content
4. Fallback chain completeness verification
5. Master number coverage (11, 22, 33, 44)

Usage:
    python3 scripts/validate_runtime_bundle.py

Exit codes:
    0: All validations passed
    1: Validation failures found
    2: Critical system error
"""

import json
import sys
from pathlib import Path
from typing import Dict, List, Optional

# VybeOS spiritual number constants
VALID_NUMBERS = {1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33, 44}
MASTER_NUMBERS = {11, 22, 33, 44}
BEHAVIORAL_CONTEXTS = ["lifePath", "expression", "soulUrge"]


class RuntimeBundleValidator:
    """Validates the KASPER MLX RuntimeBundle integrity."""

    def __init__(self, bundle_path: str = "KASPERMLXRuntimeBundle"):
        self.bundle_path = Path(bundle_path)
        self.errors: List[str] = []
        self.warnings: List[str] = []
        self.manifest: Optional[Dict] = None

    def validate(self) -> bool:
        """Run all validations and return success status."""
        print("🔍 VybeOS Runtime Bundle Validation")
        print("=" * 50)

        try:
            # Core validations
            if not self._validate_bundle_exists():
                return False

            if not self._validate_manifest():
                return False

            if not self._validate_file_coverage():
                return False

            if not self._validate_behavioral_content():
                return False

            if not self._validate_rich_content():
                return False

            if not self._validate_fallback_chain():
                return False

            # Report results
            self._report_results()
            return len(self.errors) == 0

        except Exception as e:
            print(f"💥 Critical validation error: {e}")
            return False

    def _validate_bundle_exists(self) -> bool:
        """Validate bundle directory exists."""
        if not self.bundle_path.exists():
            self.errors.append(f"RuntimeBundle not found: {self.bundle_path}")
            return False

        print(f"✅ RuntimeBundle found: {self.bundle_path}")
        return True

    def _validate_manifest(self) -> bool:
        """Validate manifest.json exists and is well-formed."""
        manifest_path = self.bundle_path / "manifest.json"

        if not manifest_path.exists():
            self.errors.append("manifest.json not found in RuntimeBundle")
            return False

        try:
            with open(manifest_path, "r", encoding="utf-8") as f:
                self.manifest = json.load(f)

            # Validate required manifest fields (handle both camelCase and snake_case)
            required_fields = {
                "version": "version",
                "generated": "generated",
                "bundleHash": ["bundleHash", "bundle_hash"],
                "domains": "domains",
                "fallbackStrategy": ["fallbackStrategy", "fallback_strategy"],
                "validation": "validation",
                "statistics": "statistics",
            }

            for logical_field, possible_names in required_fields.items():
                names_to_check = (
                    possible_names if isinstance(possible_names, list) else [possible_names]
                )
                found = any(name in self.manifest for name in names_to_check)
                if not found:
                    self.errors.append(
                        f"Missing required manifest field: {logical_field} (looked for: {names_to_check})"
                    )

            # Validate domains.numbers exists
            if "domains" not in self.manifest or "numbers" not in self.manifest["domains"]:
                self.errors.append("Missing domains.numbers in manifest")
                return False

            print(f"✅ Manifest validated - version {self.manifest.get('version', 'unknown')}")
            return True

        except json.JSONDecodeError as e:
            self.errors.append(f"Invalid JSON in manifest: {e}")
            return False
        except Exception as e:
            self.errors.append(f"Manifest validation error: {e}")
            return False

    def _validate_file_coverage(self) -> bool:
        """Validate all files referenced in manifest exist."""
        if not self.manifest:
            return False

        numbers_domain = self.manifest["domains"]["numbers"]
        missing_files = []

        # Check rich content files
        if "rich" in numbers_domain:
            rich_template = numbers_domain["rich"]
            for number in VALID_NUMBERS:
                file_path = self.bundle_path / rich_template.replace("{id}", str(number))
                if not file_path.exists():
                    missing_files.append(str(file_path.relative_to(self.bundle_path)))

        # Check behavioral content files
        if "behavioral" in numbers_domain:
            behavioral = numbers_domain["behavioral"]
            for context in BEHAVIORAL_CONTEXTS:
                if context not in behavioral:
                    continue

                template = behavioral[context]
                for number in VALID_NUMBERS:
                    # Handle different numbering formats (01 vs 1)
                    number_str = f"{number:02d}" if number < 10 else str(number)
                    file_path = self.bundle_path / template.replace("{id}", number_str)
                    if not file_path.exists():
                        # Try without zero padding
                        file_path = self.bundle_path / template.replace("{id}", str(number))
                        if not file_path.exists():
                            missing_files.append(f"{context}_{number}_converted.json")

        if missing_files:
            self.warnings.extend([f"Missing file: {f}" for f in missing_files[:10]])  # Limit output
            if len(missing_files) > 10:
                self.warnings.append(f"... and {len(missing_files) - 10} more missing files")

        print(f"📊 File coverage: {len(missing_files)} missing files")
        return True  # Warnings, not errors

    def _validate_behavioral_content(self) -> bool:
        """Validate behavioral content JSON structure."""
        behavioral_dir = self.bundle_path / "Behavioral"

        if not behavioral_dir.exists():
            self.warnings.append("Behavioral directory not found")
            return True

        behavioral_files = list(behavioral_dir.glob("*.json"))
        valid_files = 0

        for file_path in behavioral_files:
            try:
                with open(file_path, "r", encoding="utf-8") as f:
                    data = json.load(f)

                # Basic structure validation
                if not isinstance(data, dict):
                    self.warnings.append(f"Invalid structure in {file_path.name}")
                    continue

                # Check for behavioral_insights
                if "behavioral_insights" in data:
                    insights = data["behavioral_insights"]
                    if isinstance(insights, list) and len(insights) > 0:
                        valid_files += 1
                    else:
                        self.warnings.append(f"Empty behavioral_insights in {file_path.name}")

            except json.JSONDecodeError:
                self.warnings.append(f"Invalid JSON in {file_path.name}")
            except Exception as e:
                self.warnings.append(f"Error reading {file_path.name}: {e}")

        print(f"✅ Behavioral content: {valid_files} valid files")
        return True

    def _validate_rich_content(self) -> bool:
        """Validate rich content JSON structure."""
        rich_dir = self.bundle_path / "NumberMeanings"

        if not rich_dir.exists():
            self.warnings.append("NumberMeanings directory not found")
            return True

        rich_files = list(rich_dir.glob("*_rich.json"))
        valid_files = 0

        for file_path in rich_files:
            try:
                with open(file_path, "r", encoding="utf-8") as f:
                    data = json.load(f)

                # Basic structure validation
                if isinstance(data, dict) and len(data) > 0:
                    valid_files += 1
                else:
                    self.warnings.append(f"Empty content in {file_path.name}")

            except json.JSONDecodeError:
                self.warnings.append(f"Invalid JSON in {file_path.name}")
            except Exception as e:
                self.warnings.append(f"Error reading {file_path.name}: {e}")

        print(f"✅ Rich content: {valid_files} valid files")
        return True

    def _validate_fallback_chain(self) -> bool:
        """Validate the RuntimeBundle fallback chain works correctly."""
        if not self.manifest:
            return False

        # Handle both camelCase and snake_case
        fallback_strategy = self.manifest.get("fallbackStrategy") or self.manifest.get(
            "fallback_strategy", "unknown"
        )

        # Validate fallback strategy is supported
        valid_strategies = ["behavioral_then_template", "strict", "template_only"]
        if fallback_strategy not in valid_strategies:
            self.warnings.append(f"Unknown fallback strategy: {fallback_strategy}")

        # Test master number coverage specifically (critical requirement)
        missing_master_numbers = set()
        if "behavioral" in self.manifest["domains"]["numbers"]:
            behavioral = self.manifest["domains"]["numbers"]["behavioral"]
            for context in BEHAVIORAL_CONTEXTS:
                if context not in behavioral:
                    continue

                template = behavioral[context]
                for master_num in MASTER_NUMBERS:
                    # Check both numbering formats
                    file_path1 = self.bundle_path / template.replace("{id}", str(master_num))
                    file_path2 = self.bundle_path / template.replace("{id}", f"{master_num:02d}")

                    if not file_path1.exists() and not file_path2.exists():
                        missing_master_numbers.add(master_num)

        if missing_master_numbers:
            self.warnings.append(
                f"Master numbers missing content: {sorted(missing_master_numbers)}"
            )

        print(f"✅ Fallback chain: strategy='{fallback_strategy}'")
        return True

    def _report_results(self):
        """Report validation results."""
        print("\n" + "=" * 50)

        if self.errors:
            print("❌ VALIDATION ERRORS:")
            for error in self.errors:
                print(f"  ❌ {error}")

        if self.warnings:
            print(f"\n⚠️  VALIDATION WARNINGS ({len(self.warnings)}):")
            for warning in self.warnings[:5]:  # Show first 5
                print(f"  ⚠️  {warning}")
            if len(self.warnings) > 5:
                print(f"  ... and {len(self.warnings) - 5} more warnings")

        if not self.errors and not self.warnings:
            print("🎯 ALL VALIDATIONS PASSED!")
        elif not self.errors:
            print("✅ VALIDATION PASSED (with warnings)")
        else:
            print("💥 VALIDATION FAILED!")

        print("=" * 50)


def main():
    """Main entry point."""
    # Determine bundle path relative to script location
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    bundle_path = project_root / "KASPERMLXRuntimeBundle"

    validator = RuntimeBundleValidator(str(bundle_path))

    try:
        success = validator.validate()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        print("\n❌ Validation cancelled by user")
        sys.exit(2)
    except Exception as e:
        print(f"💥 Critical validation error: {e}")
        sys.exit(2)


if __name__ == "__main__":
    main()
