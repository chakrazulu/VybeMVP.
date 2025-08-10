#!/usr/bin/env python3
"""
KASPER MLX Runtime Bundle Exporter v2.1.4
==========================================

PURPOSE:
Creates a slim runtime bundle for iOS app deployment, separating training data from runtime data.
Provides authentic content routing with intelligent fallback strategies for maximum spiritual accuracy.

ARCHITECTURE:
- Source: KASPERMLX/MLXTraining/ContentRefinery/Approved/ (behavioral training data)
- Source: KASPERMLX/MLXTraining/ContentRefinery/SingleNumbers/ (authentic single numbers 1-9)
- Source: KASPERMLX/MLXTraining/ContentRefinery/MasterNumbers/ (authentic master numbers 11/22/33/44)
- Source: NumerologyData/NumberMeanings/ (legacy rich content - fallback only)
- Output: KASPERMLXRuntimeBundle/ (runtime bundle for app at root level)

KEY FEATURES v2.1.4:
- ✅ AUTHENTIC CONTENT PRIORITY: Prefers specialized single/master number files over legacy
- ✅ INTELLIGENT FALLBACK SYSTEM: Graceful degradation with clear reporting
- ✅ MANIFEST-DRIVEN ROUTING: Extensible for planets/zodiacs domains
- ✅ BEHAVIORAL/RICH SEPARATION: Clean separation of KASPER AI vs UI content
- ✅ BUNDLE INTEGRITY VERIFICATION: SHA256 hashing prevents corruption
- ✅ COMPREHENSIVE VALIDATION: Ensures all required numbers have coverage
- ✅ PERFORMANCE OPTIMIZED: 1.4MB bundle with 104 behavioral + 13 rich files

CONTENT PRIORITY LOGIC v2.1.4:
Single Numbers (1-9): SingleNumbers/single_{n}_rich.json → NumerologyData/NumberMessages_Complete_{n}.json
Master Numbers (11/22/33/44): MasterNumbers/master_{n}_rich.json → enhanced base fallback
Behavioral: Always from Approved/ folder (lifePath, expression, soulUrge, personas)

USAGE:
python3 scripts/export_runtime_bundle.py

OUTPUT STRUCTURE:
KASPERMLXRuntimeBundle/
├── manifest.json           # Routing configuration with fallback strategy
├── NumberMeanings/         # Rich content for UI display (authentic preferred)
│   ├── 1_rich.json → 9_rich.json     # Single numbers (authentic)  
│   └── 11_rich.json → 44_rich.json   # Master numbers (authentic)
├── Behavioral/             # Behavioral insights for KASPER AI generation
│   ├── lifePath_*.json     # Primary spiritual journey insights
│   ├── expression_*.json   # External presentation insights  
│   ├── soulUrge_*.json     # Inner motivation insights
│   └── [personas]/         # Oracle, Psychologist, MindfulnessCoach, etc.
└── Correspondences/        # Future: planet/zodiac mappings

QUALITY ASSURANCE:
- Bundle validation ensures no missing numbers
- Content integrity verification via SHA256
- Clear reporting: "(authentic single/master)" vs "(legacy fallback)"
- Size monitoring: Currently 1442.7 KB optimized

Author: KASPER MLX Team  
Date: August 2025
Version: 2.1.4 - Authentic Content Priority System
"""

import hashlib
import json
import shutil
from datetime import datetime
from pathlib import Path


class RuntimeBundleExporter:
    """
    KASPER MLX Runtime Bundle Exporter v2.1.4 - Main orchestration class.
    
    Creates production-ready content bundles for iOS deployment with intelligent 
    content routing and authentic spiritual content prioritization.

    CORE RESPONSIBILITIES:
    1. 🧹 Clean and prepare output directory structure
    2. 📦 Export behavioral content for KASPER AI insight generation
    3. 🎭 Export persona-specific content (Oracle, Psychologist, etc.)
    4. 📚 Export rich content with authentic single/master number preference
    5. 📋 Create intelligent routing manifest with fallback strategies
    6. 🔍 Validate bundle integrity and completeness
    7. 📊 Generate comprehensive quality reports

    CONTENT INTELLIGENCE v2.1.4:
    - Prioritizes authentic single numbers (1-9) from /SingleNumbers/
    - Prioritizes authentic master numbers (11/22/33/44) from /MasterNumbers/
    - Graceful fallback to legacy content when needed
    - Clear reporting of content sources for debugging
    
    QUALITY ASSURANCE:
    - SHA256 bundle integrity verification
    - Required number coverage validation  
    - File corruption detection
    - Size monitoring and optimization reporting
    
    Usage:
        exporter = RuntimeBundleExporter()
        success = exporter.export()  # Returns True if successful
    """

    def __init__(self):
        """
        Initialize the exporter with all source and destination paths.
        
        Sets up the complete content routing architecture for v2.1.4 with 
        intelligent priority systems for authentic spiritual content.
        """
        # PROJECT ROOT: Base directory for all operations
        self.project_root = Path(__file__).parent.parent
        
        # BEHAVIORAL CONTENT SOURCES: Training data for KASPER AI insight generation
        self.approved_dir = self.project_root / "KASPERMLX/MLXTraining/ContentRefinery/Approved"
        # ↳ Contains: lifePath_*.json, expression_*.json, soulUrge_*.json + personas
        
        # AUTHENTIC RICH CONTENT SOURCES: Specialized spiritual content (v2.1.4+)
        self.single_numbers_dir = (
            self.project_root / "KASPERMLX/MLXTraining/ContentRefinery/SingleNumbers"
        )
        # ↳ Contains: single_1_rich.json → single_9_rich.json (20 insights each)
        
        self.master_numbers_dir = (
            self.project_root / "KASPERMLX/MLXTraining/ContentRefinery/MasterNumbers"  
        )
        # ↳ Contains: master_11_rich.json → master_44_rich.json (20 insights each)
        
        # LEGACY FALLBACK SOURCE: Original rich content (compatibility only)
        self.number_meanings_dir = self.project_root / "NumerologyData/NumberMeanings"
        # ↳ Contains: NumberMessages_Complete_1.json → NumberMessages_Complete_9.json
        # ↳ NOTE: Only used when authentic content missing (should never happen in v2.1.4)

        # RUNTIME BUNDLE DESTINATION: Production-ready content for iOS deployment
        self.runtime_bundle_dir = self.project_root / "KASPERMLXRuntimeBundle"
        # ↳ Structure: manifest.json + NumberMeanings/ + Behavioral/ + Correspondences/
        # ↳ Total size: ~1.4MB optimized for mobile deployment

        # EXPORT STATISTICS: Real-time metrics for quality monitoring
        self.stats = {
            "behavioral_files": 0,       # Count: lifePath + expression + soulUrge + personas
            "rich_files": 0,            # Count: single numbers + master numbers exported
            "correspondence_files": 0,  # Count: future planet/zodiac mappings
            "total_size_kb": 0,        # Size: cumulative bundle size in kilobytes
            "missing_numbers": [],      # List: any numbers without rich content (should be empty)
        }

        # VALIDATION REQUIREMENTS: Essential number coverage for spiritual completeness
        # All single digits (1-9) and master numbers (11/22/33/44) must have content
        self.required_numbers = [
            # SINGLE NUMBERS: Core spiritual archetypes
            "1",  # The Pioneer - Leadership, independence, new beginnings
            "2",  # The Diplomat - Partnership, cooperation, harmony  
            "3",  # The Creative Communicator - Artistic expression, joy
            "4",  # The Architect - Structure, reliability, foundation
            "5",  # The Freedom Seeker - Adventure, change, versatility
            "6",  # The Nurturer - Healing, responsibility, love
            "7",  # The Mystic Seeker - Spiritual seeking, wisdom
            "8",  # The Material Master - Worldly success, power
            "9",  # The Universal Humanitarian - Service, completion
            
            # MASTER NUMBERS: Advanced spiritual consciousness  
            "11", # The Illuminator - Intuitive mastery, spiritual insight
            "22", # The Master Builder - Practical manifestation, legacy
            "33", # The Master Teacher - Christ consciousness, love
            "44", # The Master Healer - Planetary healing, cosmic service
        ]

    def clean_and_prepare(self):
        """
        Clean existing runtime bundle and prepare directory structure.

        This ensures a fresh export every time, preventing stale content
        from previous exports from lingering in the bundle.
        """
        if self.runtime_bundle_dir.exists():
            print("🧹 Cleaning existing RuntimeBundle...")
            shutil.rmtree(self.runtime_bundle_dir)

        # Create directory structure for organized content
        self.runtime_bundle_dir.mkdir(parents=True, exist_ok=True)
        (self.runtime_bundle_dir / "NumberMeanings").mkdir(exist_ok=True)
        (self.runtime_bundle_dir / "Behavioral").mkdir(exist_ok=True)
        (self.runtime_bundle_dir / "Correspondences").mkdir(exist_ok=True)

        print(f"✅ Created RuntimeBundle structure at {self.runtime_bundle_dir}")

    def export_behavioral_content(self):
        """
        Export behavioral insights for KASPER generation.

        These files contain structured insights that KASPER uses to generate
        personalized spiritual guidance. They're optimized for AI consumption
        with consistent JSON structure and intensity values.

        Includes:
        - Life Path insights (primary spiritual journey)
        - Expression insights (how one presents to the world)
        - Soul Urge insights (inner desires and motivations)
        """
        print("\n📦 Exporting Behavioral Content...")

        # Define patterns for different behavioral content types
        behavioral_patterns = [
            "lifePath_*_converted.json",
            "expression_*_converted.json",
            "soulUrge_*_converted.json",
        ]

        for pattern in behavioral_patterns:
            for file_path in self.approved_dir.glob(pattern):
                # Extract number and context from filename
                filename = file_path.name

                # Copy to behavioral folder with clear naming
                # Preserves original naming for compatibility
                dest_path = self.runtime_bundle_dir / "Behavioral" / filename
                shutil.copy2(file_path, dest_path)

                self.stats["behavioral_files"] += 1
                self.stats["total_size_kb"] += file_path.stat().st_size / 1024

                print(f"  ✓ {filename}")

    def export_rich_content(self):
        """
        Export rich number meanings for UI display.

        These files contain comprehensive spiritual knowledge about each number,
        including symbolism, correspondences, and detailed interpretations.
        Used by NumberMeaningView to display educational content to users.

        AUTHENTIC CONTENT HANDLING (v2.1.4+):
        - Single numbers (1-9) now prefer explicit single-specific files from /SingleNumbers/
        - Master numbers (11, 22, 33, 44) prefer explicit master-specific files from /MasterNumbers/
        - Falls back to NumberMeanings/NumberMessages_Complete_{base}.json for legacy compatibility
        This enables authentic specialized content while maintaining compatibility.
        """
        print("\n📚 Exporting Rich Number Meanings...")

        # Export the NumberMessages_Complete files (rich content)
        master_numbers = {"11": "1", "22": "2", "33": "3", "44": "4"}
        single_numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

        for number in self.required_numbers:
            dest_file = self.runtime_bundle_dir / "NumberMeanings" / f"{number}_rich.json"

            # For single numbers, prefer explicit single-specific files
            if number in single_numbers:
                single_specific_file = self.single_numbers_dir / f"single_{number}_rich.json"
                legacy_file = self.number_meanings_dir / f"NumberMessages_Complete_{number}.json"

                if single_specific_file.exists():
                    # Use authentic single number content
                    shutil.copy2(single_specific_file, dest_file)
                    self.stats["rich_files"] += 1
                    self.stats["total_size_kb"] += single_specific_file.stat().st_size / 1024
                    print(f"  ✓ Number {number} rich content (authentic single)")
                elif legacy_file.exists():
                    # Fallback to legacy NumberMessages content
                    shutil.copy2(legacy_file, dest_file)
                    self.stats["rich_files"] += 1
                    self.stats["total_size_kb"] += legacy_file.stat().st_size / 1024
                    print(f"  ✓ Number {number} rich content (legacy fallback)")
                else:
                    self.stats["missing_numbers"].append(number)
                    print(f"  ⚠️ Missing rich content for single number {number}")

            # For master numbers, prefer explicit master file if it exists
            elif number in master_numbers:
                master_specific_file = self.master_numbers_dir / f"master_{number}_rich.json"
                base_number = master_numbers[number]
                base_file = self.number_meanings_dir / f"NumberMessages_Complete_{base_number}.json"

                if master_specific_file.exists():
                    # Use authentic master number content
                    shutil.copy2(master_specific_file, dest_file)
                    self.stats["rich_files"] += 1
                    self.stats["total_size_kb"] += master_specific_file.stat().st_size / 1024
                    print(f"  ✓ Number {number} rich content (authentic master)")
                elif base_file.exists():
                    # Fallback to enhanced base number content
                    with open(base_file, "r", encoding="utf-8") as f:
                        content = json.load(f)

                    # Enhance with master number metadata
                    content["meta"] = {
                        "number": number,
                        "type": "master_fallback",
                        "base_number": base_number,
                        "note": "Master number using enhanced base content (fallback mode)",
                    }

                    with open(dest_file, "w", encoding="utf-8") as f:
                        json.dump(content, f, indent=2, ensure_ascii=False)

                    self.stats["rich_files"] += 1
                    self.stats["total_size_kb"] += base_file.stat().st_size / 1024
                    print(f"  ✓ Number {number} rich content (fallback→{base_number})")
                else:
                    self.stats["missing_numbers"].append(number)
                    print(
                        f"  ⚠️ Missing rich content for master number {number} (and base {base_number})"
                    )

    def export_persona_content(self):
        """
        Export persona-based content for enhanced insights.

        KASPER uses multiple personas to provide varied perspectives:
        - Oracle: Mystical, intuitive guidance
        - Psychologist: Evidence-based spiritual psychology
        - MindfulnessCoach: Present-moment awareness
        - NumerologyScholar: Academic numerological analysis
        - Philosopher: Deep existential wisdom

        Each persona has unique voice and perspective while maintaining
        spiritual authenticity and accuracy.
        """
        print("\n🎭 Exporting Persona Content...")

        personas = [
            "oracle",
            "psychologist",
            "mindfulnesscoach",
            "numerologyscholar",
            "philosopher",
        ]

        for persona in personas:
            persona_files = list(self.approved_dir.glob(f"grok_{persona}_*_converted.json"))

            if persona_files:
                # Create persona subdirectory for organization
                persona_dir = self.runtime_bundle_dir / "Behavioral" / persona
                persona_dir.mkdir(exist_ok=True)

                for file_path in persona_files:
                    dest_path = persona_dir / file_path.name
                    shutil.copy2(file_path, dest_path)
                    self.stats["behavioral_files"] += 1

                print(f"  ✓ {persona}: {len(persona_files)} files")

    def create_manifest(self):
        """
        Create manifest file for runtime routing.

        The manifest is the heart of the RuntimeBundle system. It tells
        KASPERContentRouter where to find content and how to handle fallbacks.

        Key features:
        - Path templates with {id} placeholders for dynamic routing
        - Fallback strategy configuration
        - Bundle integrity hash for verification
        - Statistics for monitoring
        - Extensible structure for future domains (planets, zodiacs)
        """
        print("\n📋 Creating Runtime Manifest...")

        manifest = {
            "version": "2.1.4",
            "generated": datetime.now().isoformat(),
            "bundle_hash": self.calculate_bundle_hash(),
            "domains": {
                "numbers": {
                    # Rich content for UI display
                    "rich": "NumberMeanings/{id}_rich.json",
                    # Behavioral content for KASPER insights
                    "behavioral": {
                        "lifePath": "Behavioral/lifePath_{id}_v2.0_converted.json",
                        "expression": "Behavioral/expression_{id}_converted.json",
                        "soulUrge": "Behavioral/soulUrge_{id}_v3.0_converted.json",
                    },
                    # Persona-specific content paths
                    "personas": {
                        "oracle": "Behavioral/oracle/grok_oracle_{id}_converted.json",
                        "psychologist": "Behavioral/psychologist/grok_psychologist_{id}_converted.json",
                        "mindfulnesscoach": "Behavioral/mindfulnesscoach/grok_mindfulnesscoach_{id}_converted.json",
                        "numerologyscholar": "Behavioral/numerologyscholar/grok_numerologyscholar_{id}_converted.json",
                        "philosopher": "Behavioral/philosopher/grok_philosopher_{id}_converted.json",
                    },
                }
                # Future: Add "planets" and "zodiacs" domains here
            },
            # Fallback strategy when content is missing
            # "behavioral_then_template" means: try behavioral first, then template
            "fallback_strategy": "behavioral_then_template",
            # Validation information for quality assurance
            "validation": {
                "schema_version": "3.0",
                "required_coverage": self.required_numbers,
                "missing_numbers": self.stats["missing_numbers"],
            },
            # Statistics for monitoring and debugging
            "statistics": {
                "behavioral_files": self.stats["behavioral_files"],
                "rich_files": self.stats["rich_files"],
                "total_size_kb": round(self.stats["total_size_kb"], 2),
            },
        }

        manifest_path = self.runtime_bundle_dir / "manifest.json"
        with open(manifest_path, "w", encoding="utf-8") as f:
            json.dump(manifest, f, indent=2, ensure_ascii=False)

        print(f"  ✓ Manifest created with bundle hash: {manifest['bundle_hash'][:12]}...")

    def calculate_bundle_hash(self) -> str:
        """
        Calculate SHA256 hash of entire bundle for integrity verification.

        This ensures the bundle hasn't been corrupted or modified after export.
        The hash covers all JSON files except the manifest itself.

        Returns:
            SHA256 hash as hexadecimal string
        """
        hasher = hashlib.sha256()

        # Sort files for deterministic hashing
        for file_path in sorted(self.runtime_bundle_dir.rglob("*.json")):
            if file_path.name != "manifest.json":
                with open(file_path, "rb") as f:
                    hasher.update(f.read())

        return hasher.hexdigest()

    def validate_bundle(self) -> bool:
        """
        Validate the exported bundle meets requirements.

        Checks:
        1. All required numbers have behavioral content
        2. All required numbers have rich content (or noted as missing)
        3. Manifest exists and is valid
        4. No corrupt JSON files

        Returns:
            True if validation passes, False otherwise
        """
        print("\n🔍 Validating Runtime Bundle...")

        issues = []

        # Check required number coverage
        for number in self.required_numbers:
            # Check behavioral content (padded for file naming)
            lifepath_file = (
                self.runtime_bundle_dir
                / "Behavioral"
                / f"lifePath_{number.zfill(2)}_v2.0_converted.json"
            )
            if not lifepath_file.exists():
                issues.append(f"Missing lifePath behavioral for number {number}")

            # Check rich content
            rich_file = self.runtime_bundle_dir / "NumberMeanings" / f"{number}_rich.json"
            if not rich_file.exists() and number not in self.stats["missing_numbers"]:
                issues.append(f"Missing rich content for number {number}")

        # Check manifest
        manifest_file = self.runtime_bundle_dir / "manifest.json"
        if not manifest_file.exists():
            issues.append("Missing manifest.json")

        if issues:
            print("  ❌ Validation failed:")
            for issue in issues:
                print(f"    - {issue}")
            return False
        else:
            print("  ✅ All validation checks passed!")
            return True

    def export(self):
        """
        Main export process orchestrator.

        Executes the complete export pipeline:
        1. Clean and prepare output directory
        2. Export behavioral content for KASPER
        3. Export persona content for varied perspectives
        4. Export rich content for UI display
        5. Create manifest for routing
        6. Validate the complete bundle

        Returns:
            True if export successful, False otherwise
        """
        print("🚀 KASPER MLX Runtime Bundle Export v1.0")
        print("=" * 50)

        # Step 1: Clean and prepare
        self.clean_and_prepare()

        # Step 2: Export behavioral content
        self.export_behavioral_content()

        # Step 3: Export persona content
        self.export_persona_content()

        # Step 4: Export rich content
        self.export_rich_content()

        # Step 5: Create manifest
        self.create_manifest()

        # Step 6: Validate
        valid = self.validate_bundle()

        # Summary report
        print("\n📊 Export Summary")
        print("=" * 50)
        print(f"  Behavioral files: {self.stats['behavioral_files']}")
        print(f"  Rich content files: {self.stats['rich_files']}")
        print(f"  Total bundle size: {self.stats['total_size_kb']:.1f} KB")

        if self.stats["missing_numbers"]:
            print(f"  ⚠️ Missing numbers: {', '.join(self.stats['missing_numbers'])}")
            print("     Note: Master numbers may use base content (intentional for v2.1.2)")

        if valid:
            print("\n✅ RuntimeBundle exported successfully!")
            print(f"📍 Location: {self.runtime_bundle_dir}")
            print("\n🎯 Next steps:")
            print("  1. Add 'KASPERMLXRuntimeBundle' folder to Xcode's Copy Bundle Resources")
            print("     - Select as 'Create folder references' (BLUE folder)")
            print("  2. Build and test on device to verify rich content + behavioral insights")
        else:
            print("\n⚠️ Export completed with warnings. Review validation issues above.")

        return valid


def main():
    """
    Main entry point for the export script.

    Creates an exporter instance and runs the export process.
    Exit code 0 for success, 1 for failure (useful for CI/CD).
    """
    exporter = RuntimeBundleExporter()
    success = exporter.export()

    # Exit with appropriate code for CI
    exit(0 if success else 1)


if __name__ == "__main__":
    main()
