#!/bin/bash

# Second Pass Grammar Fix Script for VybeMVP Content
# Catches additional patterns missed in first pass

fix_file_second_pass() {
    local file="$1"
    echo "Second pass fixing: $file"

    # Fix remaining "this sacred energy [verb]" patterns
    sed -i '' 's/this sacred energy the frequency/this sacred energy is the frequency/g' "$file"
    sed -i '' 's/this sacred energy the vibration/this sacred energy is the vibration/g' "$file"
    sed -i '' 's/this sacred energy the essence/this sacred energy is the essence/g' "$file"
    sed -i '' 's/this sacred energy the energy/this sacred energy is the energy/g' "$file"
    sed -i '' 's/this sacred energy the bridge/this sacred energy is the bridge/g' "$file"
    sed -i '' 's/this sacred energy the path/this sacred energy is the path/g' "$file"

    # Fix remaining "zero [verb]" patterns
    sed -i '' 's/zero the frequency/zero is the frequency/g' "$file"
    sed -i '' 's/zero the vibration/zero is the vibration/g' "$file"
    sed -i '' 's/zero the essence/zero is the essence/g' "$file"
    sed -i '' 's/zero the bridge/zero is the bridge/g' "$file"

    # Fix number-specific patterns
    sed -i '' 's/one the frequency/one is the frequency/g' "$file"
    sed -i '' 's/two the frequency/two is the frequency/g' "$file"
    sed -i '' 's/three the frequency/three is the frequency/g' "$file"
    sed -i '' 's/four the frequency/four is the frequency/g' "$file"
    sed -i '' 's/five the frequency/five is the frequency/g' "$file"
    sed -i '' 's/six the frequency/six is the frequency/g' "$file"
    sed -i '' 's/seven the frequency/seven is the frequency/g' "$file"
    sed -i '' 's/eight the frequency/eight is the frequency/g' "$file"
    sed -i '' 's/nine the frequency/nine is the frequency/g' "$file"

    # Fix remaining planet patterns
    sed -i '' 's/Venus the frequency/Venus is the frequency/g' "$file"
    sed -i '' 's/Mars the frequency/Mars is the frequency/g' "$file"
    sed -i '' 's/Jupiter the frequency/Jupiter is the frequency/g' "$file"
    sed -i '' 's/Saturn the frequency/Saturn is the frequency/g' "$file"
    sed -i '' 's/Mercury the frequency/Mercury is the frequency/g' "$file"
    sed -i '' 's/Moon the frequency/Moon is the frequency/g' "$file"
    sed -i '' 's/Sun the frequency/Sun is the frequency/g' "$file"

    # Fix remaining patterns with missing articles
    sed -i '' 's/this number the frequency/this number is the frequency/g' "$file"
    sed -i '' 's/this energy the frequency/this energy is the frequency/g' "$file"
    sed -i '' 's/this vibration the frequency/this vibration is the frequency/g' "$file"

    echo "Second pass completed: $file"
}

# Process all Firebase directories
echo "Starting second pass grammar fixes..."

# Process FirebaseNumberMeanings
for file in "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/FirebaseNumberMeanings"/*.json; do
    if [[ -f "$file" ]]; then
        fix_file_second_pass "$file"
    fi
done

# Process FirebaseZodiacMeanings
for file in "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/FirebaseZodiacMeanings"/*.json; do
    if [[ -f "$file" ]]; then
        fix_file_second_pass "$file"
    fi
done

# Process FirebasePlanetaryMeanings
for file in "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/FirebasePlanetaryMeanings"/*.json; do
    if [[ -f "$file" ]]; then
        fix_file_second_pass "$file"
    fi
done

echo "Second pass complete!"
