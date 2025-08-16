#!/bin/bash

# Grammar and Flow Fix Script for VybeMVP Content
# Fixes systematic grammar issues across all Firebase content files

fix_file() {
    local file="$1"
    echo "Fixing: $file"

    # Fix missing "is" verbs
    sed -i '' 's/this sacred energy pure being/this sacred energy is pure being/g' "$file"
    sed -i '' 's/this sacred energy not empty/this sacred energy is not empty/g' "$file"
    sed -i '' 's/this sacred energy not absence/this sacred energy is not absence/g' "$file"
    sed -i '' 's/this sacred energy not the end/this sacred energy is not the end/g' "$file"
    sed -i '' 's/this sacred energy not silence/this sacred energy is not silence/g' "$file"
    sed -i '' 's/this sacred energy the sacred cipher/this sacred energy is the sacred cipher/g' "$file"
    sed -i '' 's/this sacred energy the master seed/this sacred energy is the master seed/g' "$file"
    sed -i '' 's/zero the sacred cipher/zero is the sacred cipher/g' "$file"
    sed -i '' 's/zero the master seed/zero is the master seed/g' "$file"

    # Fix duplicate/incomplete phrases
    sed -i '' 's/to sit with this sacred energy to sit with source/to sit with this sacred energy is to sit with source/g' "$file"
    sed -i '' 's/to sit with zero to sit with source/to sit with zero is to sit with source/g' "$file"

    # Fix awkward inserted adjectives
    sed -i '' 's/transformative this is the point/this is the point/g' "$file"
    sed -i '' 's/transformative You are standing/You are standing/g' "$file"
    sed -i '' 's/profound You are standing/You are standing/g' "$file"
    sed -i '' 's/profound to sit with/to sit with/g' "$file"
    sed -i '' 's/soul-level zero teaches/zero teaches/g' "$file"
    sed -i '' 's/transformative zero teaches/zero teaches/g' "$file"
    sed -i '' 's/transformative all beginnings/all beginnings/g' "$file"
    sed -i '' 's/soul-level from zero/from zero/g' "$file"
    sed -i '' 's/sacred in numerology/in numerology/g' "$file"
    sed -i '' 's/soul-level in transcendental/in transcendental/g' "$file"
    sed -i '' 's/soul-level this is the space/this is the space/g' "$file"
    sed -i '' 's/profound zero holds/zero holds/g' "$file"
    sed -i '' 's/soul-level it is the womb/it is the womb/g' "$file"

    # Fix success/abundance related awkward insertions
    sed -i '' 's/radiant to sit with/to sit with/g' "$file"
    sed -i '' 's/expansive You are being/You are being/g' "$file"
    sed -i '' 's/expansive in transcendental/in transcendental/g' "$file"
    sed -i '' 's/luminous zero doesn/zero doesn/g' "$file"
    sed -i '' 's/abundant this is the void/this is the void/g' "$file"
    sed -i '' 's/luminous all beginnings/all beginnings/g' "$file"
    sed -i '' 's/radiant this is the reset/this is the reset/g' "$file"
    sed -i '' 's/abundant this is the point/this is the point/g' "$file"
    sed -i '' 's/magnificent this is the void/this is the void/g' "$file"
    sed -i '' 's/luminous this is the point/this is the point/g' "$file"
    sed -i '' 's/magnificent this sacred energy is not absence/this sacred energy is not absence/g' "$file"
    sed -i '' 's/abundant zero teaches/zero teaches/g' "$file"
    sed -i '' 's/expansive this sacred energy is not empty/this sacred energy is not empty/g' "$file"
    sed -i '' 's/abundant this is the reset/this is the reset/g' "$file"
    sed -i '' 's/sacred You are entering/You are entering/g' "$file"
    sed -i '' 's/sacred You are being invited/You are being invited/g' "$file"
    sed -i '' 's/sacred the circle of zero/the circle of zero/g' "$file"

    # Fix capitalization after periods
    sed -i '' 's/this is the reset\. the recalibration\. the return to soul/this is the reset. The recalibration. The return to soul/g' "$file"
    sed -i '' 's/nothing is missing\. it simply hasn/nothing is missing. It simply hasn/g' "$file"
    sed -i '' 's/zero is not the end or the start\. it is the container/zero is not the end or the start. It is the container/g' "$file"
    sed -i '' 's/from zero, all numbers are born\. it is the parent/from zero, all numbers are born. It is the parent/g' "$file"
    sed -i '' 's/zero is not empty\. it is full of everything/zero is not empty. It is full of everything/g' "$file"

    # Fix question mark formatting issues
    sed -i '' 's/What if zero is not silence—it is divine listening\.?/What if zero is not silence—it is divine listening?/g' "$file"
    sed -i '' 's/What if this is the reset\. the recalibration\. the return to soul\.?/What if this is the reset. The recalibration. The return to soul?/g' "$file"
    sed -i '' 's/What if the great mystery lives here, unsolved and unshaped\.?/What if the great mystery lives here, unsolved and unshaped?/g' "$file"
    sed -i '' 's/What if to sit with zero is to sit with source\.?/What if to sit with zero is to sit with source?/g' "$file"

    echo "Completed: $file"
}

# Process FirebaseNumberMeanings
echo "Processing FirebaseNumberMeanings..."
for file in "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/FirebaseNumberMeanings"/*.json; do
    if [[ -f "$file" ]]; then
        fix_file "$file"
    fi
done

# Process FirebaseZodiacMeanings
echo "Processing FirebaseZodiacMeanings..."
for file in "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/FirebaseZodiacMeanings"/*.json; do
    if [[ -f "$file" ]]; then
        fix_file "$file"
    fi
done

# Process FirebasePlanetaryMeanings
echo "Processing FirebasePlanetaryMeanings..."
for file in "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/FirebasePlanetaryMeanings"/*.json; do
    if [[ -f "$file" ]]; then
        fix_file "$file"
    fi
done

echo "All files processed!"
