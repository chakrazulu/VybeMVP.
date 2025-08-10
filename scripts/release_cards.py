#!/usr/bin/env python3
"""
Cross-platform release cards generator wrapper
Works on Windows, Mac, and Linux without make
Supports CLI overrides for dataset name and version
"""

import sys
import os
import argparse
from pathlib import Path
from datetime import datetime

# Add parent directory to path so we can import make_release_cards
sys.path.insert(0, str(Path(__file__).parent.parent))

from make_release_cards import KASPERReleaseCardsGenerator

def parse_arguments():
    """Parse command line arguments for dataset configuration."""
    parser = argparse.ArgumentParser(
        description="KASPER MLX Release Cards Generator",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python scripts/release_cards.py
  python scripts/release_cards.py --dataset-name kasper-lp-trinity
  python scripts/release_cards.py --dataset-version v2025.08.09_build1
  python scripts/release_cards.py --dataset-name custom-dataset --dataset-version v1.0.0
        """
    )
    
    parser.add_argument(
        "--dataset-name",
        default="kasper-lp-trinity",
        help="Dataset name for manifest and release tagging (default: kasper-lp-trinity)"
    )
    
    parser.add_argument(
        "--dataset-version",
        help="Dataset version (default: auto-generated from current date)"
    )
    
    parser.add_argument(
        "--verbose", "-v",
        action="store_true",
        help="Enable verbose output"
    )
    
    return parser.parse_args()

def main():
    """Cross-platform entry point for release cards generation."""
    args = parse_arguments()
    
    print("🔮 KASPER MLX Release Cards Generator (Cross-Platform)")
    print("=" * 60)
    
    # Generate default version if not provided
    if not args.dataset_version:
        build_date = datetime.now().strftime('%Y.%m.%d')
        args.dataset_version = f"v{build_date}_build1"
    
    if args.verbose:
        print(f"📋 Configuration:")
        print(f"   • Dataset Name: {args.dataset_name}")
        print(f"   • Dataset Version: {args.dataset_version}")
        print(f"   • Release Tag: {args.dataset_name}_{args.dataset_version}")
        print()
    
    try:
        generator = KASPERReleaseCardsGenerator(
            dataset_name=args.dataset_name,
            dataset_version=args.dataset_version
        )
        bundle_path = generator.generate_release_documentation()
        
        print("\n✅ SUCCESS: Release documentation generated!")
        print(f"📦 Bundle: {bundle_path}")
        print(f"🏷️  Release Tag: {args.dataset_name}_{args.dataset_version}")
        print("\n🚀 Ready for MLX training and production deployment!")
        
        return 0
        
    except Exception as e:
        print(f"\n❌ ERROR: {e}")
        if args.verbose:
            import traceback
            print(f"\n🐛 Full traceback:")
            traceback.print_exc()
        return 1

if __name__ == "__main__":
    sys.exit(main())