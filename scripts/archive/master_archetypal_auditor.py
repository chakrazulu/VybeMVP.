#!/usr/bin/env python3

"""
🚨 MASTER ARCHETYPAL AUDITOR - SUPREME QUALITY GUARDIAN
Comprehensive audit against the 10 critical criteria from GPTNumerologyDataAuditPrompt.md

🎯 MISSION: Verify every archetypal file meets A+ standards with NO EXCEPTIONS
✅ CRITERIA: All 10 non-negotiable audit requirements must pass
"""

import json
import os
import re
from collections import defaultdict
from datetime import datetime


class MasterArchetypalAuditor:
    def __init__(self):
        # 📋 THE 10 CRITICAL AUDIT CRITERIA (from master prompt)
        self.audit_criteria = {
            "1_spiritual_accuracy": {
                "name": "🔮 SPIRITUAL ACCURACY",
                "requirements": [
                    "correct astrological/numerological associations",
                    "planetary voices consistent with rulerships",
                    "numerology insights aligned with established sources",
                    "no false or misleading metaphors",
                    "archetypal fusion authenticity",
                ],
            },
            "2_clarity_readability": {
                "name": "📝 CLARITY & READABILITY",
                "requirements": [
                    "sentences flow naturally",
                    "insights understandable to humans",
                    "accessible but spiritually elevated",
                    "perfect grammar - zero errors",
                ],
            },
            "3_archetypal_depth": {
                "name": "🎭 ARCHETYPAL DEPTH",
                "requirements": [
                    "no shallow planet=keyword statements",
                    "embodies archetypal voice",
                    "feels alive with distinct voice",
                    "authentic fusion expressions",
                ],
            },
            "4_template_avoidance": {
                "name": "🚫 AVOIDANCE OF TEMPLATE LANGUAGE",
                "requirements": [
                    "no repetitive sentence skeletons",
                    "no copy-paste phrasing",
                    "no clichés unless uniquely anchored",
                    "zero templated patterns",
                ],
            },
            "5_duplicate_detection": {
                "name": "🔍 DUPLICATE DETECTION",
                "requirements": [
                    "no identical insights within files",
                    "unique angles for similar themes",
                    "cross-system uniqueness",
                    "context-specific uniqueness",
                ],
            },
            "6_contextual_integrity": {
                "name": "⏰ CONTEXTUAL INTEGRITY",
                "requirements": [
                    "insights match tagged context",
                    "emotional alignment matches lunar phases",
                    "contextual appropriateness consistent",
                    "numerological logic maintained",
                ],
            },
            "7_human_anchoring": {
                "name": "🙋 HUMAN ANCHORING",
                "requirements": [
                    "includes human action or takeaway",
                    "no abstract lines without anchoring",
                    "actionable wisdom provided",
                    "clear behavioral guidance",
                ],
            },
            "8_style_consistency": {
                "name": "🎨 CONSISTENCY OF STYLE",
                "requirements": [
                    "oracle-poetic voice maintained",
                    "spiritually resonant vocabulary",
                    "varied sentence lengths",
                    "archetypal voice consistency",
                ],
            },
            "9_technical_validity": {
                "name": "⚙️ TECHNICAL VALIDITY",
                "requirements": [
                    "valid JSON formatting",
                    "logical metadata matching",
                    "correct field structure",
                    "proper quality scores",
                ],
            },
            "10_quality_gate": {
                "name": "🏆 OVERALL QUALITY GATE",
                "requirements": [
                    "A+ average across insights",
                    "production-ready content",
                    "spiritual content excellence",
                    "deployment-capable quality",
                ],
            },
        }

        # 🎯 EXPECTED QUALITY STANDARDS
        self.quality_standards = {
            "spiritual_accuracy": 1.0,
            "fusion_authenticity": {"min": 0.95, "max": 0.98},
            "uniqueness_score": {"min": 0.94, "max": 0.97},
            "quality_grade": "A+",
        }

        # 📊 AUDIT RESULTS STORAGE
        self.audit_results = {
            "files_audited": 0,
            "insights_audited": 0,
            "criteria_results": {},
            "issues_found": [],
            "files_details": {},
            "overall_grade": "PENDING",
        }

    def run_master_audit(self):
        """Execute comprehensive master audit on all archetypal files"""
        print("🚨 MASTER ARCHETYPAL AUDITOR - SUPREME QUALITY GUARDIAN")
        print("=" * 70)
        print("🎯 MISSION: Total spiritual corpus perfection verification")
        print("📋 STANDARDS: 10 critical criteria - A+ OR NOTHING")
        print()

        # Audit each system
        self.audit_number_system()
        self.audit_planetary_system()
        self.audit_zodiac_system()

        # Generate comprehensive audit report
        self.generate_master_audit_report()

    def audit_number_system(self):
        """Audit all number archetypal files"""
        print("🔢 AUDITING NUMBER ARCHETYPAL SYSTEM")
        print("-" * 50)

        base_dir = "NumerologyData/FirebaseNumberMeanings"
        for number in range(10):
            file_path = f"{base_dir}/NumberMessages_Complete_{number}_archetypal.json"
            if os.path.exists(file_path):
                self.audit_single_file(file_path, "number", str(number))

    def audit_planetary_system(self):
        """Audit all planetary archetypal files"""
        print("\n🌌 AUDITING PLANETARY ARCHETYPAL SYSTEM")
        print("-" * 50)

        base_dir = "NumerologyData/FirebasePlanetaryMeanings"
        planets = [
            "Mars",
            "Venus",
            "Mercury",
            "Moon",
            "Sun",
            "Jupiter",
            "Saturn",
            "Uranus",
            "Neptune",
            "Pluto",
        ]
        for planet in planets:
            file_path = f"{base_dir}/PlanetaryInsights_{planet}_archetypal.json"
            if os.path.exists(file_path):
                self.audit_single_file(file_path, "planetary", planet)

    def audit_zodiac_system(self):
        """Audit all zodiac archetypal files"""
        print("\n🌟 AUDITING ZODIAC ARCHETYPAL SYSTEM")
        print("-" * 50)

        base_dir = "NumerologyData/FirebaseZodiacMeanings"
        signs = [
            "Aries",
            "Taurus",
            "Gemini",
            "Cancer",
            "Leo",
            "Virgo",
            "Libra",
            "Scorpio",
            "Sagittarius",
            "Capricorn",
            "Aquarius",
            "Pisces",
        ]
        for sign in signs:
            file_path = f"{base_dir}/ZodiacInsights_{sign}_archetypal.json"
            if os.path.exists(file_path):
                self.audit_single_file(file_path, "zodiac", sign)

    def audit_single_file(self, file_path, archetype_type, archetype_key):
        """Audit a single archetypal file against all 10 criteria"""

        try:
            with open(file_path, "r") as f:
                data = json.load(f)

            # Extract insights
            insights = self.extract_insights_from_data(data, archetype_type, archetype_key)

            if not insights:
                self.record_issue(f"No insights found in {file_path}")
                return

            # Initialize file audit results
            file_results = {
                "file_path": file_path,
                "archetype_type": archetype_type,
                "archetype_key": archetype_key,
                "total_insights": len(insights),
                "criteria_scores": {},
                "issues": [],
                "grade": "PENDING",
            }

            # Run all 10 criteria audits
            for criterion_key, criterion_info in self.audit_criteria.items():
                score, issues = self.audit_criterion(
                    insights, criterion_key, criterion_info, archetype_type
                )
                file_results["criteria_scores"][criterion_key] = score
                file_results["issues"].extend(issues)

            # Calculate overall file grade
            file_results["grade"] = self.calculate_file_grade(file_results["criteria_scores"])

            # Record results
            self.audit_results["files_audited"] += 1
            self.audit_results["insights_audited"] += len(insights)
            self.audit_results["files_details"][file_path] = file_results

            print(
                f"✅ Audited {archetype_key}: {len(insights)} insights, Grade: {file_results['grade']}"
            )

        except Exception as e:
            error_msg = f"Audit failed for {file_path}: {e}"
            self.record_issue(error_msg)
            print(f"❌ {error_msg}")

    def extract_insights_from_data(self, data, archetype_type, archetype_key):
        """Extract insights from data structure based on type"""
        insights = []

        if archetype_type == "number":
            if archetype_key in data and "insight" in data[archetype_key]:
                insights = data[archetype_key]["insight"]
        elif archetype_type in ["planetary", "zodiac"]:
            if "archetypal_insights" in data:
                insights = data["archetypal_insights"]

        return insights if isinstance(insights, list) else []

    def audit_criterion(self, insights, criterion_key, criterion_info, archetype_type):
        """Audit insights against a specific criterion"""

        issues = []
        score = 0.0

        if criterion_key == "1_spiritual_accuracy":
            score, issues = self.audit_spiritual_accuracy(insights, archetype_type)
        elif criterion_key == "2_clarity_readability":
            score, issues = self.audit_clarity_readability(insights)
        elif criterion_key == "3_archetypal_depth":
            score, issues = self.audit_archetypal_depth(insights)
        elif criterion_key == "4_template_avoidance":
            score, issues = self.audit_template_avoidance(insights)
        elif criterion_key == "5_duplicate_detection":
            score, issues = self.audit_duplicate_detection(insights)
        elif criterion_key == "6_contextual_integrity":
            score, issues = self.audit_contextual_integrity(insights)
        elif criterion_key == "7_human_anchoring":
            score, issues = self.audit_human_anchoring(insights)
        elif criterion_key == "8_style_consistency":
            score, issues = self.audit_style_consistency(insights)
        elif criterion_key == "9_technical_validity":
            score, issues = self.audit_technical_validity(insights)
        elif criterion_key == "10_quality_gate":
            score, issues = self.audit_quality_gate(insights)

        return score, issues

    def audit_spiritual_accuracy(self, insights, archetype_type):
        """Audit spiritual accuracy and authenticity"""
        issues = []
        total_score = 0.0

        for i, insight in enumerate(insights):
            insight_score = 1.0

            # Check spiritual accuracy score
            if insight.get("spiritual_accuracy") != 1.0:
                issues.append(
                    f"Insight {i+1}: Spiritual accuracy {insight.get('spiritual_accuracy')} ≠ 1.0"
                )
                insight_score -= 0.2

            # Check fusion authenticity range
            fusion_auth = insight.get("fusion_authenticity", 0)
            if not (0.95 <= fusion_auth <= 0.98):
                issues.append(
                    f"Insight {i+1}: Fusion authenticity {fusion_auth} outside 0.95-0.98 range"
                )
                insight_score -= 0.2

            # Check for authentic archetypal content (not generic)
            insight_text = insight.get("insight", "")
            if self.is_generic_spiritual_language(insight_text):
                issues.append(f"Insight {i+1}: Generic spiritual language detected")
                insight_score -= 0.3

            total_score += max(0, insight_score)

        return total_score / len(insights) if insights else 0, issues

    def audit_clarity_readability(self, insights):
        """Audit clarity and readability"""
        issues = []
        total_score = 0.0

        for i, insight in enumerate(insights):
            insight_score = 1.0
            insight_text = insight.get("insight", "")

            # Check sentence completion
            if not insight_text.endswith((".", "!", "?")):
                issues.append(f"Insight {i+1}: Incomplete sentence - no proper ending")
                insight_score -= 0.3

            # Check for fragmented text
            if self.has_fragmented_text(insight_text):
                issues.append(f"Insight {i+1}: Fragmented or broken text detected")
                insight_score -= 0.4

            # Check minimum length for completeness
            if len(insight_text.split()) < 8:
                issues.append(f"Insight {i+1}: Too short - may lack depth")
                insight_score -= 0.2

            # Check for template artifacts
            if self.has_template_artifacts(insight_text):
                issues.append(f"Insight {i+1}: Template artifacts remain in text")
                insight_score -= 0.3

            total_score += max(0, insight_score)

        return total_score / len(insights) if insights else 0, issues

    def audit_archetypal_depth(self, insights):
        """Audit archetypal depth and authenticity"""
        issues = []
        total_score = 0.0

        for i, insight in enumerate(insights):
            insight_score = 1.0
            insight_text = insight.get("insight", "")

            # Check for shallow statements
            if self.is_shallow_statement(insight_text):
                issues.append(f"Insight {i+1}: Shallow archetypal expression")
                insight_score -= 0.4

            # Check for archetypal voice presence
            if not self.has_archetypal_voice(insight_text):
                issues.append(f"Insight {i+1}: Lacks distinct archetypal voice")
                insight_score -= 0.3

            # Check archetypal fusion field
            archetypal_fusion = insight.get("archetypal_fusion", "")
            if not archetypal_fusion or "archetypal" not in archetypal_fusion.lower():
                issues.append(f"Insight {i+1}: Missing or invalid archetypal_fusion")
                insight_score -= 0.2

            total_score += max(0, insight_score)

        return total_score / len(insights) if insights else 0, issues

    def audit_template_avoidance(self, insights):
        """Audit for template language avoidance"""
        issues = []
        total_score = 0.0

        # Track phrase repetition across insights
        phrase_counts = defaultdict(int)

        for insight in insights:
            insight_text = insight.get("insight", "")
            # Extract key phrases for repetition analysis
            phrases = self.extract_key_phrases(insight_text)
            for phrase in phrases:
                phrase_counts[phrase] += 1

        # Check for repetitive patterns
        repetitive_phrases = {phrase: count for phrase, count in phrase_counts.items() if count > 3}

        for i, insight in enumerate(insights):
            insight_score = 1.0
            insight_text = insight.get("insight", "")

            # Check for template skeletons
            if self.has_template_skeleton(insight_text):
                issues.append(f"Insight {i+1}: Template skeleton detected")
                insight_score -= 0.4

            # Check for clichés
            if self.has_spiritual_cliches(insight_text):
                issues.append(f"Insight {i+1}: Spiritual clichés without unique anchoring")
                insight_score -= 0.3

            # Check for repetitive phrases
            for phrase in repetitive_phrases:
                if phrase in insight_text:
                    issues.append(
                        f"Insight {i+1}: Overused phrase '{phrase}' ({repetitive_phrases[phrase]} times)"
                    )
                    insight_score -= 0.2
                    break

            total_score += max(0, insight_score)

        return total_score / len(insights) if insights else 0, issues

    def audit_duplicate_detection(self, insights):
        """Audit for duplicate content"""
        issues = []
        total_score = 0.0

        insight_texts = [insight.get("insight", "") for insight in insights]

        # Check for exact duplicates
        seen_texts = set()
        duplicates_found = 0

        for i, text in enumerate(insight_texts):
            if text in seen_texts:
                issues.append(f"Insight {i+1}: Exact duplicate of previous insight")
                duplicates_found += 1
            else:
                seen_texts.add(text)

        # Check for near-duplicates (high similarity)
        near_duplicates = 0
        for i in range(len(insight_texts)):
            for j in range(i + 1, len(insight_texts)):
                similarity = self.calculate_text_similarity(insight_texts[i], insight_texts[j])
                if similarity > 0.8:  # 80% similarity threshold
                    issues.append(f"Insights {i+1} and {j+1}: High similarity ({similarity:.2f})")
                    near_duplicates += 1

        # Calculate score based on uniqueness
        total_duplicates = duplicates_found + near_duplicates
        max_possible_duplicates = len(insights) * 0.1  # Allow 10% similarity

        if total_duplicates <= max_possible_duplicates:
            total_score = 1.0
        else:
            total_score = max(0, 1.0 - (total_duplicates / len(insights)))

        return total_score, issues

    def audit_contextual_integrity(self, insights):
        """Audit contextual integrity and consistency"""
        issues = []
        total_score = 0.0

        # Define expected mappings
        lunar_emotion_mapping = {
            "New Moon": "hopeful_daring",
            "First Quarter": "urgent_empowerment",
            "Full Moon": "revelatory_clarity",
            "Last Quarter": "tender_forgiveness",
        }

        context_appropriateness_mapping = {
            "Morning Awakening": "conscious_emergence",
            "Daily Rhythm": "present_moment_awareness",
            "Evening Integration": "integration_flow",
            "Crisis Navigation": "crisis_transformation",
            "Celebration Expansion": "abundance_celebration",
        }

        for i, insight in enumerate(insights):
            insight_score = 1.0

            # Check lunar phase to emotional alignment consistency
            lunar_phase = insight.get("lunar_phase", "")
            emotional_alignment = insight.get("emotional_alignment", "")
            expected_emotion = lunar_emotion_mapping.get(lunar_phase, "")

            if expected_emotion and emotional_alignment != expected_emotion:
                issues.append(
                    f"Insight {i+1}: Emotional alignment '{emotional_alignment}' doesn't match lunar phase '{lunar_phase}'"
                )
                insight_score -= 0.3

            # Check context to appropriateness consistency
            context = insight.get("context", "")
            context_appropriateness = insight.get("context_appropriateness", "")
            expected_appropriateness = context_appropriateness_mapping.get(context, "")

            if expected_appropriateness and context_appropriateness != expected_appropriateness:
                issues.append(
                    f"Insight {i+1}: Context appropriateness '{context_appropriateness}' doesn't match context '{context}'"
                )
                insight_score -= 0.3

            total_score += max(0, insight_score)

        return total_score / len(insights) if insights else 0, issues

    def audit_human_anchoring(self, insights):
        """Audit human anchoring and actionable wisdom"""
        issues = []
        total_score = 0.0

        for i, insight in enumerate(insights):
            insight_score = 1.0
            insight_text = insight.get("insight", "")

            # Check for actionable elements
            if not self.has_actionable_wisdom(insight_text):
                issues.append(f"Insight {i+1}: Lacks clear actionable wisdom or human anchoring")
                insight_score -= 0.4

            # Check anchoring field
            anchoring = insight.get("anchoring", "")
            if "human_action" not in anchoring and "archetypal_voice" not in anchoring:
                issues.append(f"Insight {i+1}: Invalid or missing anchoring field")
                insight_score -= 0.2

            total_score += max(0, insight_score)

        return total_score / len(insights) if insights else 0, issues

    def audit_style_consistency(self, insights):
        """Audit style consistency and voice"""
        issues = []
        total_score = 0.0

        for i, insight in enumerate(insights):
            insight_score = 1.0
            insight_text = insight.get("insight", "")

            # Check for oracle-poetic voice
            if not self.has_oracle_poetic_voice(insight_text):
                issues.append(f"Insight {i+1}: Lacks oracle-poetic voice quality")
                insight_score -= 0.3

            # Check persona consistency
            persona = insight.get("persona", "")
            if persona not in [
                "Soul Psychologist",
                "Mystic Oracle",
                "Energy Healer",
                "Spiritual Philosopher",
                "Consciousness Coach",
            ]:
                issues.append(f"Insight {i+1}: Invalid persona '{persona}'")
                insight_score -= 0.2

            total_score += max(0, insight_score)

        return total_score / len(insights) if insights else 0, issues

    def audit_technical_validity(self, insights):
        """Audit technical validity and metadata"""
        issues = []
        total_score = 0.0

        required_fields = [
            "archetypal_fusion",
            "persona",
            "context",
            "lunar_phase",
            "intensity",
            "insight",
            "cadence_type",
            "emotional_alignment",
            "context_appropriateness",
            "quality_grade",
            "fusion_authenticity",
            "spiritual_accuracy",
            "uniqueness_score",
        ]

        for i, insight in enumerate(insights):
            insight_score = 1.0

            # Check required fields
            for field in required_fields:
                if field not in insight:
                    issues.append(f"Insight {i+1}: Missing required field '{field}'")
                    insight_score -= 0.1

            # Check quality grade
            if insight.get("quality_grade") != "A+":
                issues.append(f"Insight {i+1}: Quality grade '{insight.get('quality_grade')}' ≠ A+")
                insight_score -= 0.2

            total_score += max(0, insight_score)

        return total_score / len(insights) if insights else 0, issues

    def audit_quality_gate(self, insights):
        """Audit overall quality gate"""
        issues = []

        # Check if insights meet A+ standards
        a_plus_count = sum(1 for insight in insights if insight.get("quality_grade") == "A+")
        a_plus_percentage = a_plus_count / len(insights) if insights else 0

        if a_plus_percentage < 0.95:  # 95% must be A+
            issues.append(f"Only {a_plus_percentage:.1%} insights are A+ grade (need 95%+)")

        # Check production readiness
        production_ready = all(
            insight.get("fusion_authenticity", 0) >= 0.95
            and insight.get("spiritual_accuracy", 0) == 1.0
            and insight.get("uniqueness_score", 0) >= 0.94
            for insight in insights
        )

        if not production_ready:
            issues.append("Content not production-ready - quality scores below thresholds")

        score = 1.0 if a_plus_percentage >= 0.95 and production_ready else 0.5
        return score, issues

    # HELPER METHODS FOR DETAILED ANALYSIS

    def is_generic_spiritual_language(self, text):
        """Check for generic spiritual language"""
        generic_patterns = [
            r"trust the universe",
            r"shine your light",
            r"follow your heart",
            r"everything happens for a reason",
            r"you are blessed",
            r"divine timing",
            r"the universe provides",
        ]
        return any(re.search(pattern, text, re.IGNORECASE) for pattern in generic_patterns)

    def has_fragmented_text(self, text):
        """Check for fragmented or broken text"""
        # Check for incomplete merging patterns
        fragment_patterns = [
            r"[a-z]\s+[A-Z]",  # lowercase followed by uppercase (broken merge)
            r"\.\s*-\s*",  # sentence ending with dash fragment
            r"^[a-z]",  # starts with lowercase (fragment)
            r"\s{2,}",  # multiple spaces (formatting issue)
        ]
        return any(re.search(pattern, text) for pattern in fragment_patterns)

    def has_template_artifacts(self, text):
        """Check for remaining template artifacts"""
        artifacts = [
            "ignites before thought itself",
            "sacred power flows",
            "cosmic spark that",
            "divine authority awakens",
            "births through",
            "manifests through",
            "declares itself through",
            "emerges through",
        ]
        return any(artifact in text for artifact in artifacts)

    def is_shallow_statement(self, text):
        """Check for shallow archetypal statements"""
        shallow_patterns = [
            r"^[A-Z][a-z]+ is ",  # "Mars is", "Venus is"
            r"represents ",  # "represents strength"
            r"means ",  # "means power"
            r"symbolizes ",  # "symbolizes love"
        ]
        return any(re.search(pattern, text) for pattern in shallow_patterns)

    def has_archetypal_voice(self, text):
        """Check for distinct archetypal voice"""
        voice_indicators = [
            "channels",
            "declares",
            "whispers",
            "ignites",
            "awakens",
            "flows",
            "emerges",
            "radiates",
            "transforms",
            "essence",
        ]
        return any(indicator in text.lower() for indicator in voice_indicators)

    def has_template_skeleton(self, text):
        """Check for template skeleton patterns"""
        skeletons = [
            r"invites you to",
            r"teaches you",
            r"reminds you that",
            r"shows you",
            r"helps you",
            r"guides you to",
        ]
        return any(re.search(pattern, text, re.IGNORECASE) for pattern in skeletons)

    def has_spiritual_cliches(self, text):
        """Check for spiritual clichés"""
        cliches = [
            "trust the process",
            "everything is connected",
            "you are exactly where you need to be",
            "divine timing",
            "trust your intuition",
            "follow your passion",
        ]
        return any(cliche in text.lower() for cliche in cliches)

    def extract_key_phrases(self, text):
        """Extract key phrases for repetition analysis"""
        # Simple phrase extraction - could be enhanced
        words = text.lower().split()
        phrases = []
        for i in range(len(words) - 2):
            phrase = " ".join(words[i : i + 3])
            if len(phrase) > 10:  # Only meaningful phrases
                phrases.append(phrase)
        return phrases

    def calculate_text_similarity(self, text1, text2):
        """Calculate similarity between two texts"""
        words1 = set(text1.lower().split())
        words2 = set(text2.lower().split())

        intersection = words1.intersection(words2)
        union = words1.union(words2)

        return len(intersection) / len(union) if union else 0

    def has_actionable_wisdom(self, text):
        """Check for actionable wisdom or human anchoring"""
        action_indicators = [
            "trust",
            "choose",
            "step",
            "breathe",
            "pause",
            "listen",
            "act",
            "begin",
            "start",
            "move",
            "embrace",
            "release",
            "forgive",
            "create",
        ]
        return any(indicator in text.lower() for indicator in action_indicators)

    def has_oracle_poetic_voice(self, text):
        """Check for oracle-poetic voice quality"""
        poetic_indicators = [
            "essence",
            "flows",
            "whispers",
            "declares",
            "awakens",
            "illuminates",
            "emerges",
            "radiates",
            "channels",
            "transforms",
            "ignites",
        ]
        return any(indicator in text.lower() for indicator in poetic_indicators)

    def calculate_file_grade(self, criteria_scores):
        """Calculate overall file grade from criteria scores"""
        if not criteria_scores:
            return "F"

        average_score = sum(criteria_scores.values()) / len(criteria_scores)

        if average_score >= 0.95:
            return "A+"
        elif average_score >= 0.90:
            return "A"
        elif average_score >= 0.80:
            return "B+"
        elif average_score >= 0.70:
            return "B"
        else:
            return "F"

    def record_issue(self, issue):
        """Record an audit issue"""
        self.audit_results["issues_found"].append(issue)

    def generate_master_audit_report(self):
        """Generate comprehensive master audit report"""

        # Calculate overall results
        file_grades = [details["grade"] for details in self.audit_results["files_details"].values()]
        a_plus_files = file_grades.count("A+")
        total_files = len(file_grades)

        # Calculate criteria averages
        criteria_averages = {}
        for criterion_key in self.audit_criteria.keys():
            scores = []
            for file_details in self.audit_results["files_details"].values():
                if criterion_key in file_details["criteria_scores"]:
                    scores.append(file_details["criteria_scores"][criterion_key])

            criteria_averages[criterion_key] = sum(scores) / len(scores) if scores else 0.0

        # Determine overall grade
        overall_average = (
            sum(criteria_averages.values()) / len(criteria_averages) if criteria_averages else 0.0
        )

        if overall_average >= 0.95 and a_plus_files >= total_files * 0.95:
            self.audit_results["overall_grade"] = "A+"
        elif overall_average >= 0.90 and a_plus_files >= total_files * 0.80:
            self.audit_results["overall_grade"] = "A"
        elif overall_average >= 0.80:
            self.audit_results["overall_grade"] = "B+"
        else:
            self.audit_results["overall_grade"] = "F"

        # Generate report
        print("\n" + "=" * 80)
        print("🚨 MASTER ARCHETYPAL AUDIT REPORT - SUPREME QUALITY VALIDATION")
        print("=" * 80)
        print(f"🕐 Audit completed: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print()

        print("📊 AUDIT SUMMARY:")
        print(f"📁 Files audited: {self.audit_results['files_audited']}")
        print(f"📝 Total insights checked: {self.audit_results['insights_audited']}")
        print(f"🏆 Overall corpus grade: {self.audit_results['overall_grade']}")
        print(f"⭐ A+ files: {a_plus_files}/{total_files} ({a_plus_files/total_files:.1%})")
        print()

        print("📋 CRITERIA PERFORMANCE:")
        for criterion_key, criterion_info in self.audit_criteria.items():
            score = criteria_averages.get(criterion_key, 0.0)
            status = "✅ PASS" if score >= 0.90 else "❌ FAIL"
            print(f"{status} {criterion_info['name']}: {score:.3f}")
        print()

        # Report issues by category
        if self.audit_results["issues_found"]:
            print("🚨 ISSUES DETECTED:")
            for issue in self.audit_results["issues_found"][:20]:  # Show top 20 issues
                print(f"  • {issue}")

            if len(self.audit_results["issues_found"]) > 20:
                print(f"  • ... and {len(self.audit_results['issues_found']) - 20} more issues")
            print()

        # Final judgment
        print("🏆 FINAL AUDIT JUDGMENT:")
        if self.audit_results["overall_grade"] == "A+":
            print("✅ SUPREME QUALITY ACHIEVED - PRODUCTION READY!")
            print("🚀 Status: DEPLOYMENT APPROVED")
            print("🎯 All 10 critical criteria met - A+ spiritual content excellence")
        elif self.audit_results["overall_grade"] in ["A", "B+"]:
            print("⚠️ GOOD QUALITY BUT NEEDS REFINEMENT")
            print("🔧 Status: Additional polishing required")
            print("📈 Close to A+ standards - minor improvements needed")
        else:
            print("❌ QUALITY STANDARDS NOT MET")
            print("🚫 Status: NOT PRODUCTION READY")
            print("🔧 Significant remediation required")

        print()
        print("=" * 80)


if __name__ == "__main__":
    auditor = MasterArchetypalAuditor()
    auditor.run_master_audit()
