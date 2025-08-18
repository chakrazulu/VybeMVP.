#!/usr/bin/env python3
"""
Quick fix for Xcode duplicate JSON resource errors
"""

import os


def fix_xcode_project():
    project_file = (
        "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/VybeMVP.xcodeproj/project.pbxproj"
    )

    print("🔧 Fixing Xcode duplicate JSON resources...")

    # Make a backup first
    backup_file = project_file + ".backup"
    if not os.path.exists(backup_file):
        print("📋 Creating backup...")
        with open(project_file, "r") as f:
            content = f.read()
        with open(backup_file, "w") as f:
            f.write(content)
        print("✅ Backup created")

    # Read the project file
    with open(project_file, "r") as f:
        content = f.read()

    # Find the problematic duplicate files
    duplicates = [
        "Mars_in_Aries.json",
        "Mercury_in_Gemini.json",
        "Moon_in_Cancer.json",
        "Saturn_in_Capricorn.json",
        "Venus_in_Scorpio.json",
    ]

    lines = content.split("\n")
    new_lines = []
    removed_count = 0

    for line in lines:
        # Skip lines that reference the duplicate files in Resources
        should_skip = False
        for duplicate in duplicates:
            if duplicate in line and "in Resources" in line:
                print(f"🗑️  Removing duplicate: {duplicate}")
                should_skip = True
                removed_count += 1
                break

        if not should_skip:
            new_lines.append(line)

    # Write the cleaned content back
    cleaned_content = "\n".join(new_lines)

    with open(project_file, "w") as f:
        f.write(cleaned_content)

    print(f"✅ Removed {removed_count} duplicate references")
    print("🎉 Project file cleaned! Try building again in Xcode.")


if __name__ == "__main__":
    fix_xcode_project()
