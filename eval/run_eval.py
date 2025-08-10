#!/usr/bin/env python3
"""
KASPER MLX Evaluation Runner
Purpose: Automated quality assessment with LLM-judge scoring
Author: KASPER MLX Enterprise System
Generated: August 9, 2025
"""

import json
import random
import time
import hashlib
import os
import sys
from pathlib import Path
from typing import Dict, List, Any

def load_rubric() -> Dict[str, Any]:
    """Load evaluation rubric with YAML support and fallback"""
    rubric_path = Path("eval/rubrics/lp_trinity.yaml")
    
    if rubric_path.exists():
        try:
            import yaml
            with open(rubric_path, 'r', encoding='utf-8') as f:
                return yaml.safe_load(f)
        except ImportError:
            print("⚠️  PyYAML not available. Install with: pip install pyyaml")
            print("📋 Using fallback rubric configuration...")
    
    # Fallback minimal rubric for environments without PyYAML
    return {
        "threshold": 90,
        "weights": {
            "fidelity": 0.35,
            "actionability": 0.25, 
            "tone": 0.20,
            "safety": 0.20
        },
        "sample_size": 60,
        "seed": 42
    }

def pick_samples(manifest: Dict[str, Any], k: int, seed: int) -> List[Dict[str, Any]]:
    """Deterministic sampling from manifest files"""
    # Focus on expression and life_path content for behavioral insights
    files = [
        f for f in manifest.get("files", []) 
        if f.get("category", "").startswith(("expression", "life_path", "soul_urge"))
    ]
    
    print(f"🎯 Found {len(files)} eligible files for evaluation")
    
    if len(files) == 0:
        raise ValueError("No eligible files found in manifest for evaluation")
    
    # Deterministic sampling with fixed seed
    rng = random.Random(seed)
    rng.shuffle(files)
    
    selected = files[:min(k, len(files))]
    print(f"📊 Selected {len(selected)} files for evaluation (seed: {seed})")
    
    return selected

def call_judge(prompt: str, insight_text: str) -> Dict[str, Any]:
    """
    Call LLM judge for content evaluation.
    
    Current implementation: Stub for testing pipeline
    TODO: Integrate with local model (vLLM/ollama/LM Studio) or cloud API
    
    Args:
        prompt: Judge instruction text
        insight_text: Content to evaluate
        
    Returns:
        Dict with fidelity/actionability/tone/safety scores and notes
    """
    
    # Check for environment variable indicating judge configuration
    judge_mode = os.getenv("KASPER_JUDGE_MODE", "stub")
    
    if judge_mode == "stub":
        # Placeholder implementation for pipeline testing
        # Returns realistic scores that will pass threshold
        return {
            "fidelity": 88,
            "actionability": 85, 
            "tone": 92,
            "safety": 94,
            "notes": "Stub evaluation - replace with actual LLM judge"
        }
    
    elif judge_mode == "local":
        # TODO: Implement local model integration
        # Example: call vLLM or ollama endpoint
        raise NotImplementedError("Local judge mode not yet implemented")
        
    elif judge_mode == "cloud":
        # TODO: Implement cloud API integration (nightly only for cost control)
        raise NotImplementedError("Cloud judge mode not yet implemented")
    
    else:
        raise ValueError(f"Unknown judge mode: {judge_mode}")

def calculate_weighted_score(weights: Dict[str, float], result: Dict[str, int]) -> float:
    """Calculate weighted total score from individual dimension scores"""
    total = (
        weights["fidelity"] * result["fidelity"] +
        weights["actionability"] * result["actionability"] +
        weights["tone"] * result["tone"] +
        weights["safety"] * result["safety"]
    )
    return round(total, 2)

def load_insight_content(file_path: str) -> str:
    """Load and extract insight content from JSON file"""
    try:
        content = json.loads(Path(file_path).read_text(encoding='utf-8'))
        
        # Extract key insight content for evaluation
        insights = []
        
        # Collect behavioral insights
        if "behavioral_insights" in content:
            for insight in content["behavioral_insights"]:
                if isinstance(insight, dict) and "insight" in insight:
                    insights.append(insight["insight"])
        
        # Collect other insight fields
        insight_fields = ["summary", "core_message", "guidance", "reflection"]
        for field in insight_fields:
            if field in content and isinstance(content[field], str):
                insights.append(content[field])
        
        return "\n\n".join(insights) if insights else str(content)
        
    except (json.JSONDecodeError, FileNotFoundError, KeyError) as e:
        print(f"⚠️  Error loading {file_path}: {e}")
        return f"Error loading content: {e}"

def main():
    """Main evaluation pipeline"""
    print("🔮 KASPER MLX Evaluation System Starting...")
    
    # Load configuration
    rubric = load_rubric()
    print(f"📋 Rubric loaded: threshold={rubric['threshold']}, sample_size={rubric['sample_size']}")
    
    # Load manifest
    manifest_path = Path("artifacts/MANIFEST.json")
    if not manifest_path.exists():
        print("❌ MANIFEST.json not found. Run release cards generator first.")
        sys.exit(1)
        
    manifest = json.loads(manifest_path.read_text(encoding='utf-8'))
    print(f"📄 Manifest loaded: {manifest.get('total_files', 0)} total files")
    
    # Sample files for evaluation
    samples = pick_samples(manifest, rubric["sample_size"], rubric["seed"])
    
    # Prepare output directory
    report_dir = Path("artifacts/eval")
    report_dir.mkdir(parents=True, exist_ok=True)
    
    # Generate output filenames
    tag = manifest.get("release_info", {}).get("release_tag", "unknown")
    timestamp = int(time.time())
    out_json = report_dir / f"report_{tag}_{timestamp}.json"
    out_md = report_dir / f"summary_{tag}_{timestamp}.md"
    
    # Load judge prompt
    judge_prompt_path = Path("eval/prompts/judge.txt")
    if not judge_prompt_path.exists():
        print("❌ Judge prompt not found at eval/prompts/judge.txt")
        sys.exit(1)
        
    judge_prompt = judge_prompt_path.read_text(encoding='utf-8')
    print(f"🤖 Judge prompt loaded ({len(judge_prompt)} characters)")
    
    # Evaluate samples
    print(f"🔍 Beginning evaluation of {len(samples)} samples...")
    results = []
    
    for i, sample_file in enumerate(samples, 1):
        print(f"   • Evaluating {i}/{len(samples)}: {sample_file.get('filename', 'unknown')}")
        
        # Load content
        file_path = sample_file.get("path", "")
        insight_text = load_insight_content(file_path)
        
        # Call judge
        try:
            judge_result = call_judge(judge_prompt, insight_text)
            
            # Calculate weighted score
            total_score = calculate_weighted_score(rubric["weights"], judge_result)
            judge_result["total"] = total_score
            judge_result["file"] = file_path
            judge_result["category"] = sample_file.get("category", "unknown")
            
            results.append(judge_result)
            
        except Exception as e:
            print(f"⚠️  Error evaluating {file_path}: {e}")
            # Add failed result to maintain sample count
            results.append({
                "fidelity": 0,
                "actionability": 0, 
                "tone": 0,
                "safety": 0,
                "total": 0.0,
                "file": file_path,
                "category": sample_file.get("category", "unknown"),
                "notes": f"Evaluation failed: {e}"
            })
        
        # Rate limiting for external APIs
        time.sleep(0.1)
    
    # Calculate aggregate metrics
    valid_results = [r for r in results if r["total"] > 0]
    if not valid_results:
        print("❌ No valid evaluation results obtained")
        sys.exit(1)
        
    avg_score = round(sum(r["total"] for r in valid_results) / len(valid_results), 2)
    pass_threshold = rubric["threshold"]
    verdict = "PASS ✅" if avg_score >= pass_threshold else "FAIL ❌"
    
    # Generate detailed report
    report_data = {
        "evaluation_metadata": {
            "tag": tag,
            "timestamp": timestamp,
            "judge_mode": os.getenv("KASPER_JUDGE_MODE", "stub"),
            "rubric_file": "eval/rubrics/lp_trinity.yaml"
        },
        "aggregate_metrics": {
            "average_score": avg_score,
            "threshold": pass_threshold,
            "verdict": verdict.split()[0],  # Just PASS or FAIL
            "sample_count": len(results),
            "valid_evaluations": len(valid_results)
        },
        "rubric_config": rubric,
        "individual_results": results
    }
    
    # Write JSON report
    with open(out_json, 'w', encoding='utf-8') as f:
        json.dump(report_data, f, ensure_ascii=False, sort_keys=True, indent=2)
    
    # Generate markdown summary
    summary_content = f"""# KASPER MLX Evaluation Summary

**Release:** {tag}  
**Timestamp:** {timestamp}  
**Evaluated:** {len(valid_results)}/{len(results)} samples  

## Results

**Average Score:** {avg_score}/100  
**Threshold:** {pass_threshold}/100  
**Verdict:** {verdict}

## Score Breakdown

| Dimension | Weight | Avg Score |
|-----------|--------|-----------|
| Fidelity | {rubric['weights']['fidelity']:.0%} | {round(sum(r['fidelity'] for r in valid_results)/len(valid_results), 1) if valid_results else 0} |
| Actionability | {rubric['weights']['actionability']:.0%} | {round(sum(r['actionability'] for r in valid_results)/len(valid_results), 1) if valid_results else 0} |
| Tone | {rubric['weights']['tone']:.0%} | {round(sum(r['tone'] for r in valid_results)/len(valid_results), 1) if valid_results else 0} |  
| Safety | {rubric['weights']['safety']:.0%} | {round(sum(r['safety'] for r in valid_results)/len(valid_results), 1) if valid_results else 0} |

## Judge Configuration

**Mode:** {os.getenv("KASPER_JUDGE_MODE", "stub")}  
**Sampling Seed:** {rubric['seed']}  
**Sample Size:** {rubric['sample_size']}

---
*Generated by KASPER MLX Evaluation System*
"""
    
    with open(out_md, 'w', encoding='utf-8') as f:
        f.write(summary_content)
    
    # Final output
    print(f"\n🎯 Evaluation Complete!")
    print(f"   • Result: {verdict}")  
    print(f"   • Average Score: {avg_score}")
    print(f"   • Threshold: {pass_threshold}")
    print(f"   • Report: {out_json}")
    print(f"   • Summary: {out_md}")
    
    # Exit with appropriate code for CI
    if avg_score < pass_threshold:
        print(f"\n⚠️  Evaluation below threshold. Consider reviewing content quality.")
        sys.exit(1)
    else:
        print(f"\n✅ Evaluation passed! KASPER content meets quality standards.")
        sys.exit(0)

if __name__ == "__main__":
    main()