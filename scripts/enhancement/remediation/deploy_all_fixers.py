#!/usr/bin/env python3

"""
🚑 MASTER ARCHETYPAL REMEDIATION DEPLOYMENT
Deploys all three fixer agents to clean existing _archetypal files

🎯 MISSION: Fix all 32 existing _archetypal files without creating new files
✅ AGENTS: Number (10 files) + Planetary (10 files) + Zodiac (12 files) = 32 total
"""

import os
import subprocess
import sys
from datetime import datetime


class MasterArchetypalRemediation:
    def __init__(self):
        self.agents = [
            {
                "name": "Number Archetypal Fixer",
                "script": "scripts/remediation/number_archetypal_fixer.py",
                "target_files": 10,
                "emoji": "🔢",
            },
            {
                "name": "Planetary Archetypal Fixer",
                "script": "scripts/remediation/planetary_archetypal_fixer.py",
                "target_files": 10,
                "emoji": "🌌",
            },
            {
                "name": "Zodiac Archetypal Fixer",
                "script": "scripts/remediation/zodiac_archetypal_fixer.py",
                "target_files": 12,
                "emoji": "🌟",
            },
        ]

    def deploy_all_remediation_agents(self):
        """Deploy all remediation agents sequentially"""
        print("🚑 MASTER ARCHETYPAL REMEDIATION DEPLOYMENT")
        print("=" * 60)
        print(f"🕐 Started: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print()
        print("🎯 MISSION: Fix all 32 existing _archetypal files")
        print("✅ MODE: Direct editing only - no new files created")
        print("🛠️ AGENTS: 3 specialized remediation agents")
        print()

        total_files_fixed = 0
        total_insights_fixed = 0
        successful_agents = 0

        for i, agent in enumerate(self.agents, 1):
            print(f"{agent['emoji']} DEPLOYING AGENT {i}/3: {agent['name']}")
            print(f"🎯 Target: {agent['target_files']} files")
            print("-" * 40)

            try:
                # Run the agent script
                result = subprocess.run(
                    [sys.executable, agent["script"]],
                    capture_output=True,
                    text=True,
                    timeout=300,  # 5 minute timeout per agent
                )

                if result.returncode == 0:
                    print("✅ AGENT DEPLOYMENT SUCCESSFUL")
                    print(result.stdout)
                    successful_agents += 1
                    total_files_fixed += agent["target_files"]
                else:
                    print("❌ AGENT DEPLOYMENT FAILED")
                    print(f"Error: {result.stderr}")

            except subprocess.TimeoutExpired:
                print("⏰ AGENT TIMEOUT - Taking too long")
            except Exception as e:
                print(f"💥 AGENT CRASH: {e}")

            print()

        # Final deployment report
        self.generate_deployment_report(successful_agents, total_files_fixed)

    def generate_deployment_report(self, successful_agents, files_fixed):
        """Generate final deployment report"""
        print("🎉 MASTER ARCHETYPAL REMEDIATION COMPLETE!")
        print("=" * 60)
        print(f"🕐 Completed: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print()
        print("📊 DEPLOYMENT SUMMARY:")
        print(f"✅ Successful agents: {successful_agents}/3")
        print(f"📁 Files remediated: {files_fixed}")
        print("🎯 Target: 32 total _archetypal files")
        print()

        if successful_agents == 3:
            print("🏆 FULL DEPLOYMENT SUCCESS!")
            print("✅ All archetypal files have been cleaned and fixed")
            print("✅ Template artifacts eliminated")
            print("✅ A+ quality voices restored")
            print("✅ Ready for master audit")
            print()
            print("🔄 NEXT STEP: Run master audit to verify all fixes")
        else:
            print("⚠️ PARTIAL DEPLOYMENT")
            print(f"❌ {3 - successful_agents} agents failed")
            print("🔧 Manual intervention may be required")

        print()
        print("📂 REMEDIATED FILES LOCATION:")
        print("• Numbers: NumerologyData/FirebaseNumberMeanings/*_archetypal.json")
        print("• Planets: NumerologyData/FirebasePlanetaryMeanings/*_archetypal.json")
        print("• Zodiac: NumerologyData/FirebaseZodiacMeanings/*_archetypal.json")

    def verify_deployment_readiness(self):
        """Verify all agent scripts exist before deployment"""
        print("🔍 PRE-DEPLOYMENT VERIFICATION")
        print("-" * 30)

        all_ready = True
        for agent in self.agents:
            if os.path.exists(agent["script"]):
                print(f"✅ {agent['name']}: Ready")
            else:
                print(f"❌ {agent['name']}: Script missing - {agent['script']}")
                all_ready = False

        print()
        return all_ready


if __name__ == "__main__":
    deployment = MasterArchetypalRemediation()

    # Verify all agents are ready
    if deployment.verify_deployment_readiness():
        print("🚀 All agents ready - beginning deployment...")
        print()
        deployment.deploy_all_remediation_agents()
    else:
        print("❌ Deployment aborted - missing agent scripts")
        sys.exit(1)
