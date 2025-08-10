#!/usr/bin/env python3
"""
VybeOS Content Coverage CI Reporter
Generates detailed reports showing exactly which numbers/contexts are missing rich or behavioral files

This script is part of ChatGPT's strategic recommendation for content coverage visibility.
It creates comprehensive reports that help identify gaps in the spiritual content system.

Key features:
1. Complete coverage analysis for all numbers (1-9, 11, 22, 33, 44)
2. Context-specific reporting (lifePath, expression, soulUrge)
3. Rich content vs behavioral content gap analysis
4. CI-friendly output formats (JSON, Markdown, console)
5. Master number special attention (11, 22, 33, 44)
6. Missing file identification and prioritization
7. Content quality metrics and statistics

Usage:
    python3 scripts/generate_content_coverage_report.py [--format=json|markdown|console] [--output=file]
    
Output formats:
    console: Human-readable terminal output (default)
    json: Machine-readable JSON for CI integration
    markdown: GitHub-friendly markdown for PR comments
"""

import json
import os
import sys
from pathlib import Path
from typing import Dict, List, Set, Optional, Tuple
from dataclasses import dataclass, asdict
from datetime import datetime
import argparse

# VybeOS spiritual constants
VALID_NUMBERS = [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33, 44]
MASTER_NUMBERS = [11, 22, 33, 44]
BEHAVIORAL_CONTEXTS = ['lifePath', 'expression', 'soulUrge']


@dataclass
class CoverageStats:
    """Statistics for content coverage analysis."""
    total_expected_files: int
    total_existing_files: int
    missing_files: int
    coverage_percentage: float
    missing_master_numbers: List[int]
    missing_contexts: List[str]


@dataclass
class NumberCoverage:
    """Coverage information for a specific number."""
    number: int
    rich_content_exists: bool
    behavioral_contexts: Dict[str, bool]  # context -> exists
    missing_contexts: List[str]
    is_master_number: bool
    priority_score: int  # Higher = more important to fix


@dataclass
class ContentCoverageReport:
    """Complete content coverage report."""
    timestamp: str
    bundle_version: str
    overall_stats: CoverageStats
    rich_content_stats: CoverageStats
    behavioral_content_stats: CoverageStats
    number_details: List[NumberCoverage]
    missing_files_detailed: List[str]
    recommendations: List[str]


class ContentCoverageAnalyzer:
    """Analyzes content coverage and generates comprehensive reports."""
    
    def __init__(self, bundle_path: str = "KASPERMLXRuntimeBundle"):
        self.bundle_path = Path(bundle_path)
        self.manifest = None
        self.report = None
        
    def analyze(self) -> ContentCoverageReport:
        """Perform complete coverage analysis."""
        print("🔍 VybeOS Content Coverage Analysis")
        print("=" * 50)
        
        # Load manifest if available
        self._load_manifest()
        
        # Analyze coverage
        number_details = []
        missing_files = []
        
        for number in VALID_NUMBERS:
            coverage = self._analyze_number_coverage(number)
            number_details.append(coverage)
            
            # Collect missing files
            if not coverage.rich_content_exists:
                missing_files.append(f"NumberMeanings/{number}_rich.json")
            
            for context in coverage.missing_contexts:
                # Handle different file naming conventions
                for suffix in ["_converted.json", "_v2.0_converted.json", "_v3.0_converted.json"]:
                    missing_files.append(f"Behavioral/{context}_{number:02d}{suffix}")
        
        # Generate statistics
        overall_stats = self._calculate_overall_stats(number_details)
        rich_stats = self._calculate_rich_stats(number_details)
        behavioral_stats = self._calculate_behavioral_stats(number_details)
        
        # Generate recommendations
        recommendations = self._generate_recommendations(number_details, overall_stats)
        
        # Create report
        self.report = ContentCoverageReport(
            timestamp=datetime.now().isoformat(),
            bundle_version=self._get_bundle_version(),
            overall_stats=overall_stats,
            rich_content_stats=rich_stats,
            behavioral_content_stats=behavioral_stats,
            number_details=sorted(number_details, key=lambda x: x.priority_score, reverse=True),
            missing_files_detailed=missing_files,
            recommendations=recommendations
        )
        
        return self.report
    
    def _load_manifest(self):
        """Load manifest if available."""
        manifest_path = self.bundle_path / "manifest.json"
        if manifest_path.exists():
            try:
                with open(manifest_path, 'r', encoding='utf-8') as f:
                    self.manifest = json.load(f)
                print(f"✅ Manifest loaded - version {self.manifest.get('version', 'unknown')}")
            except Exception as e:
                print(f"⚠️ Manifest load error: {e}")
    
    def _analyze_number_coverage(self, number: int) -> NumberCoverage:
        """Analyze coverage for a specific number."""
        
        # Check rich content
        rich_exists = self._check_rich_content_exists(number)
        
        # Check behavioral contexts
        behavioral_contexts = {}
        missing_contexts = []
        
        for context in BEHAVIORAL_CONTEXTS:
            exists = self._check_behavioral_content_exists(number, context)
            behavioral_contexts[context] = exists
            if not exists:
                missing_contexts.append(context)
        
        # Calculate priority score
        priority = self._calculate_priority_score(number, rich_exists, missing_contexts)
        
        return NumberCoverage(
            number=number,
            rich_content_exists=rich_exists,
            behavioral_contexts=behavioral_contexts,
            missing_contexts=missing_contexts,
            is_master_number=number in MASTER_NUMBERS,
            priority_score=priority
        )
    
    def _check_rich_content_exists(self, number: int) -> bool:
        """Check if rich content exists for number."""
        rich_path = self.bundle_path / "NumberMeanings" / f"{number}_rich.json"
        return rich_path.exists()
    
    def _check_behavioral_content_exists(self, number: int, context: str) -> bool:
        """Check if behavioral content exists for number and context."""
        behavioral_dir = self.bundle_path / "Behavioral"
        
        # Try different naming conventions
        possible_files = [
            f"{context}_{number:02d}_converted.json",
            f"{context}_{number}_converted.json",
            f"{context}_{number:02d}_v2.0_converted.json",
            f"{context}_{number}_v2.0_converted.json",
            f"{context}_{number:02d}_v3.0_converted.json",
            f"{context}_{number}_v3.0_converted.json",
        ]
        
        for filename in possible_files:
            if (behavioral_dir / filename).exists():
                return True
        
        return False
    
    def _calculate_priority_score(self, number: int, rich_exists: bool, missing_contexts: List[str]) -> int:
        """Calculate priority score for fixing missing content."""
        score = 0
        
        # Master numbers are highest priority
        if number in MASTER_NUMBERS:
            score += 100
        
        # Sacred numbers (7) get bonus priority
        if number == 7:
            score += 50
        
        # Base numbers (1-9) are important
        if 1 <= number <= 9:
            score += 30
        
        # Missing rich content is important for UI
        if not rich_exists:
            score += 40
        
        # Missing behavioral contexts hurt AI quality
        score += len(missing_contexts) * 20
        
        # Complete misses are highest priority
        if not rich_exists and len(missing_contexts) == len(BEHAVIORAL_CONTEXTS):
            score += 100
        
        return score
    
    def _calculate_overall_stats(self, number_details: List[NumberCoverage]) -> CoverageStats:
        """Calculate overall coverage statistics."""
        total_expected = len(VALID_NUMBERS) * (1 + len(BEHAVIORAL_CONTEXTS))  # rich + behavioral
        total_existing = 0
        missing_master_numbers = []
        missing_contexts = set()
        
        for detail in number_details:
            if detail.rich_content_exists:
                total_existing += 1
            
            total_existing += len(BEHAVIORAL_CONTEXTS) - len(detail.missing_contexts)
            
            if detail.is_master_number and (not detail.rich_content_exists or detail.missing_contexts):
                missing_master_numbers.append(detail.number)
            
            missing_contexts.update(detail.missing_contexts)
        
        missing_files = total_expected - total_existing
        coverage_percentage = (total_existing / total_expected) * 100
        
        return CoverageStats(
            total_expected_files=total_expected,
            total_existing_files=total_existing,
            missing_files=missing_files,
            coverage_percentage=coverage_percentage,
            missing_master_numbers=missing_master_numbers,
            missing_contexts=list(missing_contexts)
        )
    
    def _calculate_rich_stats(self, number_details: List[NumberCoverage]) -> CoverageStats:
        """Calculate rich content specific statistics."""
        total_expected = len(VALID_NUMBERS)
        total_existing = sum(1 for detail in number_details if detail.rich_content_exists)
        missing_files = total_expected - total_existing
        coverage_percentage = (total_existing / total_expected) * 100
        
        missing_master_numbers = [
            detail.number for detail in number_details 
            if detail.is_master_number and not detail.rich_content_exists
        ]
        
        return CoverageStats(
            total_expected_files=total_expected,
            total_existing_files=total_existing,
            missing_files=missing_files,
            coverage_percentage=coverage_percentage,
            missing_master_numbers=missing_master_numbers,
            missing_contexts=[]
        )
    
    def _calculate_behavioral_stats(self, number_details: List[NumberCoverage]) -> CoverageStats:
        """Calculate behavioral content specific statistics."""
        total_expected = len(VALID_NUMBERS) * len(BEHAVIORAL_CONTEXTS)
        total_existing = 0
        missing_contexts = set()
        
        for detail in number_details:
            total_existing += len(BEHAVIORAL_CONTEXTS) - len(detail.missing_contexts)
            missing_contexts.update(detail.missing_contexts)
        
        missing_files = total_expected - total_existing
        coverage_percentage = (total_existing / total_expected) * 100
        
        missing_master_numbers = [
            detail.number for detail in number_details 
            if detail.is_master_number and detail.missing_contexts
        ]
        
        return CoverageStats(
            total_expected_files=total_expected,
            total_existing_files=total_existing,
            missing_files=missing_files,
            coverage_percentage=coverage_percentage,
            missing_master_numbers=missing_master_numbers,
            missing_contexts=list(missing_contexts)
        )
    
    def _generate_recommendations(self, number_details: List[NumberCoverage], stats: CoverageStats) -> List[str]:
        """Generate actionable recommendations based on analysis."""
        recommendations = []
        
        # Overall coverage recommendations
        if stats.coverage_percentage < 50:
            recommendations.append("🚨 CRITICAL: Content coverage below 50% - immediate action required")
        elif stats.coverage_percentage < 80:
            recommendations.append("⚠️ WARNING: Content coverage below 80% - expansion needed")
        
        # Master number recommendations
        if stats.missing_master_numbers:
            recommendations.append(
                f"🔮 PRIORITY: Missing master number content for: {', '.join(map(str, stats.missing_master_numbers))}"
            )
        
        # Context-specific recommendations
        if 'lifePath' in stats.missing_contexts:
            recommendations.append("📍 FOCUS: LifePath content gaps detected - primary spiritual journey affected")
        
        if 'soulUrge' in stats.missing_contexts:
            recommendations.append("💫 FOCUS: SoulUrge content gaps detected - inner motivation insights affected")
        
        # Top priority numbers
        high_priority_numbers = [d.number for d in number_details if d.priority_score > 150]
        if high_priority_numbers:
            recommendations.append(
                f"🎯 TOP PRIORITY: Focus on numbers {', '.join(map(str, high_priority_numbers[:5]))}"
            )
        
        # Success recognition
        if stats.coverage_percentage >= 90:
            recommendations.append("✨ EXCELLENT: High content coverage maintained")
        
        return recommendations
    
    def _get_bundle_version(self) -> str:
        """Get bundle version from manifest."""
        if self.manifest:
            return self.manifest.get('version', 'unknown')
        return 'no-manifest'
    
    def generate_console_report(self) -> str:
        """Generate human-readable console report."""
        if not self.report:
            return "No report generated"
        
        lines = [
            "🎯 VYBEOS CONTENT COVERAGE REPORT",
            "=" * 60,
            "",
            f"📊 OVERALL STATISTICS:",
            f"  Bundle Version: {self.report.bundle_version}",
            f"  Coverage: {self.report.overall_stats.coverage_percentage:.1f}% ({self.report.overall_stats.total_existing_files}/{self.report.overall_stats.total_expected_files})",
            f"  Missing Files: {self.report.overall_stats.missing_files}",
            "",
            f"🎨 RICH CONTENT COVERAGE:",
            f"  Coverage: {self.report.rich_content_stats.coverage_percentage:.1f}% ({self.report.rich_content_stats.total_existing_files}/{self.report.rich_content_stats.total_expected_files})",
            f"  Missing Files: {self.report.rich_content_stats.missing_files}",
            "",
            f"🧠 BEHAVIORAL CONTENT COVERAGE:",
            f"  Coverage: {self.report.behavioral_content_stats.coverage_percentage:.1f}% ({self.report.behavioral_content_stats.total_existing_files}/{self.report.behavioral_content_stats.total_expected_files})",
            f"  Missing Files: {self.report.behavioral_content_stats.missing_files}",
            "",
        ]
        
        # Master number status
        if self.report.overall_stats.missing_master_numbers:
            lines.extend([
                "🔮 MASTER NUMBER GAPS:",
                f"  Missing: {', '.join(map(str, self.report.overall_stats.missing_master_numbers))}",
                "",
            ])
        
        # Top priority numbers
        lines.append("🎯 TOP PRIORITY NUMBERS:")
        for detail in self.report.number_details[:10]:
            status_icons = []
            if not detail.rich_content_exists:
                status_icons.append("❌ Rich")
            if detail.missing_contexts:
                status_icons.append(f"❌ {'/'.join(detail.missing_contexts)}")
            
            status = " ".join(status_icons) if status_icons else "✅ Complete"
            master_icon = "🔮 " if detail.is_master_number else "   "
            
            lines.append(f"  {master_icon}Number {detail.number:2d}: {status} (Priority: {detail.priority_score})")
        
        # Recommendations
        if self.report.recommendations:
            lines.extend(["", "💡 RECOMMENDATIONS:"])
            for rec in self.report.recommendations:
                lines.append(f"  {rec}")
        
        lines.extend(["", "=" * 60, f"Generated: {self.report.timestamp}"])
        
        return "\n".join(lines)
    
    def generate_json_report(self) -> str:
        """Generate machine-readable JSON report."""
        if not self.report:
            return "{}"
        
        return json.dumps(asdict(self.report), indent=2)
    
    def generate_markdown_report(self) -> str:
        """Generate GitHub-friendly markdown report."""
        if not self.report:
            return "# No Report Generated"
        
        lines = [
            "# 🎯 VybeOS Content Coverage Report",
            "",
            f"**Bundle Version:** {self.report.bundle_version}  ",
            f"**Generated:** {self.report.timestamp}  ",
            f"**Overall Coverage:** {self.report.overall_stats.coverage_percentage:.1f}% ({self.report.overall_stats.total_existing_files}/{self.report.overall_stats.total_expected_files} files)",
            "",
            "## 📊 Coverage Statistics",
            "",
            "| Content Type | Coverage | Existing | Missing |",
            "|--------------|----------|----------|---------|",
            f"| **Overall** | {self.report.overall_stats.coverage_percentage:.1f}% | {self.report.overall_stats.total_existing_files} | {self.report.overall_stats.missing_files} |",
            f"| Rich Content | {self.report.rich_content_stats.coverage_percentage:.1f}% | {self.report.rich_content_stats.total_existing_files} | {self.report.rich_content_stats.missing_files} |",
            f"| Behavioral | {self.report.behavioral_content_stats.coverage_percentage:.1f}% | {self.report.behavioral_content_stats.total_existing_files} | {self.report.behavioral_content_stats.missing_files} |",
            "",
        ]
        
        # Master number status
        if self.report.overall_stats.missing_master_numbers:
            lines.extend([
                "## 🔮 Master Number Gaps",
                "",
                f"**Missing master numbers:** {', '.join(map(str, self.report.overall_stats.missing_master_numbers))}",
                "",
            ])
        
        # Top priority table
        lines.extend([
            "## 🎯 Priority Numbers",
            "",
            "| Number | Type | Rich Content | Missing Contexts | Priority |",
            "|--------|------|--------------|------------------|----------|",
        ])
        
        for detail in self.report.number_details[:15]:
            number_type = "🔮 Master" if detail.is_master_number else "Regular"
            rich_status = "✅" if detail.rich_content_exists else "❌"
            missing_contexts = ", ".join(detail.missing_contexts) if detail.missing_contexts else "None"
            
            lines.append(f"| {detail.number} | {number_type} | {rich_status} | {missing_contexts} | {detail.priority_score} |")
        
        # Recommendations
        if self.report.recommendations:
            lines.extend(["", "## 💡 Recommendations", ""])
            for rec in self.report.recommendations:
                lines.append(f"- {rec}")
        
        return "\n".join(lines)


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(description="Generate VybeOS content coverage report")
    parser.add_argument(
        "--format", 
        choices=["console", "json", "markdown"], 
        default="console",
        help="Output format (default: console)"
    )
    parser.add_argument(
        "--output",
        help="Output file path (default: stdout)"
    )
    parser.add_argument(
        "--bundle-path",
        default="KASPERMLXRuntimeBundle",
        help="Path to RuntimeBundle directory"
    )
    
    args = parser.parse_args()
    
    # Determine bundle path relative to script
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    bundle_path = project_root / args.bundle_path
    
    try:
        # Generate report
        analyzer = ContentCoverageAnalyzer(str(bundle_path))
        analyzer.analyze()
        
        # Generate output
        if args.format == "console":
            output = analyzer.generate_console_report()
        elif args.format == "json":
            output = analyzer.generate_json_report()
        elif args.format == "markdown":
            output = analyzer.generate_markdown_report()
        else:
            output = "Unknown format"
        
        # Write output
        if args.output:
            with open(args.output, 'w', encoding='utf-8') as f:
                f.write(output)
            print(f"Report written to: {args.output}")
        else:
            print(output)
        
        # Exit with appropriate code
        if analyzer.report and analyzer.report.overall_stats.coverage_percentage < 80:
            sys.exit(1)  # Warning exit code for CI
        else:
            sys.exit(0)
            
    except KeyboardInterrupt:
        print("\n❌ Report generation cancelled by user")
        sys.exit(2)
    except Exception as e:
        print(f"💥 Report generation error: {e}")
        sys.exit(2)


if __name__ == "__main__":
    main()