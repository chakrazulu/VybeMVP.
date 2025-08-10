#!/bin/bash

# VybeMVP Sacred Geometry Asset Renaming Script
# Renames all assets from original names to mystical technical names
# Creates backups and updates Contents.json files

echo "🔮 VybeMVP Sacred Geometry Asset Renaming Script"
echo "================================================"

# Set the path to your Assets.xcassets directory
ASSETS_DIR="MandalaAssets/VybeApp/Assets.xcassets"

# Check if directory exists
if [ ! -d "$ASSETS_DIR" ]; then
    echo "❌ Error: Assets directory not found at $ASSETS_DIR"
    echo "Please run this script from your project root directory"
    exit 1
fi

echo "📁 Working in: $ASSETS_DIR"

# Create backup
BACKUP_DIR="backup_original_assets_$(date +%Y%m%d_%H%M%S)"
echo "💾 Creating backup at: $BACKUP_DIR"
cp -r "$ASSETS_DIR" "$BACKUP_DIR"

# Define renaming mappings (original_name:new_name:svg_name)
declare -A RENAMES=(
    # 0 - VOID & INFINITE POTENTIAL
    ["Sacred Geometry_One Line_63.imageset"]="void_triquetra.imageset:Sacred Geometry_One Line_63.svg"
    ["Sacred Geometry_One Line_36.imageset"]="void_cosmic_womb.imageset:Sacred Geometry_One Line_36.svg"
    ["Sacred Geometry_One Line_54.imageset"]="void_zero_point.imageset:Sacred Geometry_One Line_54.svg"
    ["Sacred Geometry_One Line_45.imageset"]="void_eternal_return.imageset:Sacred Geometry_One Line_45.svg"
    ["Sacred Geometry_One Line_18.imageset"]="void_star_matrix.imageset:Sacred Geometry_One Line_18.svg"
    ["Sacred Geometry_One Line_27.imageset"]="void_akashic_grid.imageset:Sacred Geometry_One Line_27.svg"
    ["Sacred Geometry_One Line_9.imageset"]="void_crystal.imageset:Sacred Geometry_One Line_9.svg"

    # 1 - UNITY & DIVINE SPARK
    ["Sacred Geometry_One Line_1.imageset"]="unity_merkaba.imageset:Sacred Geometry_One Line_1.svg"
    ["Sacred Geometry_One Line_10.imageset"]="unity_solar.imageset:Sacred Geometry_One Line_10.svg"
    ["Sacred Geometry_One Line_19.imageset"]="unity_crown.imageset:Sacred Geometry_One Line_19.svg"
    ["Sacred Geometry_One Line_28.imageset"]="unity_monad.imageset:Sacred Geometry_One Line_28.svg"
    ["Sacred Geometry_One Line_37.imageset"]="unity_alpha.imageset:Sacred Geometry_One Line_37.svg"
    ["Sacred Geometry_One Line_46.imageset"]="unity_consciousness.imageset:Sacred Geometry_One Line_46.svg"
    ["Sacred Geometry_One Line_55.imageset"]="unity_spark.imageset:Sacred Geometry_One Line_55.svg"

    # 2 - DUALITY & COSMIC POLARITY
    ["Sacred Geometry_One Line_2.imageset"]="duality_vesica.imageset:Sacred Geometry_One Line_2.svg"
    ["Sacred Geometry_One Line_11.imageset"]="duality_lunar.imageset:Sacred Geometry_One Line_11.svg"
    ["Sacred Geometry_One Line_20.imageset"]="duality_yin_yang.imageset:Sacred Geometry_One Line_20.svg"
    ["Sacred Geometry_One Line_29.imageset"]="duality_pillars.imageset:Sacred Geometry_One Line_29.svg"
    ["Sacred Geometry_One Line_38.imageset"]="duality_divine.imageset:Sacred Geometry_One Line_38.svg"
    ["Sacred Geometry_One Line_47.imageset"]="duality_twins.imageset:Sacred Geometry_One Line_47.svg"
    ["Sacred Geometry_One Line_56.imageset"]="duality_mirror.imageset:Sacred Geometry_One Line_56.svg"

    # 3 - TRINITY & DIVINE CREATIVITY
    ["Sacred Geometry_One Line_3.imageset"]="trinity_mandala.imageset:Sacred Geometry_One Line_3.svg"
    ["Sacred Geometry_One Line_12.imageset"]="trinity_triangle.imageset:Sacred Geometry_One Line_12.svg"
    ["Sacred Geometry_One Line_21.imageset"]="trinity_wisdom.imageset:Sacred Geometry_One Line_21.svg"
    ["Sacred Geometry_One Line_30.imageset"]="trinity_fire.imageset:Sacred Geometry_One Line_30.svg"
    ["Sacred Geometry_One Line_39.imageset"]="trinity_gate.imageset:Sacred Geometry_One Line_39.svg"
    ["Sacred Geometry_One Line_48.imageset"]="trinity_expression.imageset:Sacred Geometry_One Line_48.svg"
    ["Sacred Geometry_One Line_57.imageset"]="trinity_logos.imageset:Sacred Geometry_One Line_57.svg"

    # 4 - FOUNDATION & MATERIAL MANIFESTATION
    ["Sacred Geometry_One Line_4.imageset"]="foundation_cube.imageset:Sacred Geometry_One Line_4.svg"
    ["Sacred Geometry_One Line_13.imageset"]="foundation_cross.imageset:Sacred Geometry_One Line_13.svg"
    ["Sacred Geometry_One Line_22.imageset"]="foundation_temple.imageset:Sacred Geometry_One Line_22.svg"
    ["Sacred Geometry_One Line_31.imageset"]="foundation_stone.imageset:Sacred Geometry_One Line_31.svg"
    ["Sacred Geometry_One Line_40.imageset"]="foundation_grid.imageset:Sacred Geometry_One Line_40.svg"
    ["Sacred Geometry_One Line_49.imageset"]="foundation_matrix.imageset:Sacred Geometry_One Line_49.svg"
    ["Sacred Geometry_One Line_58.imageset"]="foundation_blessing.imageset:Sacred Geometry_One Line_58.svg"

    # 5 - QUINTESSENCE & DIVINE WILL
    ["Sacred Geometry_One Line_5.imageset"]="will_pentagram.imageset:Sacred Geometry_One Line_5.svg"
    ["Sacred Geometry_One Line_14.imageset"]="will_golden_spiral.imageset:Sacred Geometry_One Line_14.svg"
    ["Sacred Geometry_One Line_23.imageset"]="will_shield.imageset:Sacred Geometry_One Line_23.svg"
    ["Sacred Geometry_One Line_32.imageset"]="will_phoenix.imageset:Sacred Geometry_One Line_32.svg"
    ["Sacred Geometry_One Line_41.imageset"]="will_power.imageset:Sacred Geometry_One Line_41.svg"
    ["Sacred Geometry_One Line_50.imageset"]="will_star.imageset:Sacred Geometry_One Line_50.svg"
    ["Sacred Geometry_One Line_59.imageset"]="will_command.imageset:Sacred Geometry_One Line_59.svg"

    # 6 - HARMONY & COSMIC LOVE
    ["Sacred Geometry_One Line_6.imageset"]="harmony_star_david.imageset:Sacred Geometry_One Line_6.svg"
    ["Sacred Geometry_One Line_15.imageset"]="harmony_flower_life.imageset:Sacred Geometry_One Line_15.svg"
    ["Sacred Geometry_One Line_24.imageset"]="harmony_heart.imageset:Sacred Geometry_One Line_24.svg"
    ["Sacred Geometry_One Line_33.imageset"]="harmony_christ.imageset:Sacred Geometry_One Line_33.svg"
    ["Sacred Geometry_One Line_42.imageset"]="harmony_universal.imageset:Sacred Geometry_One Line_42.svg"
    ["Sacred Geometry_One Line_51.imageset"]="harmony_marriage.imageset:Sacred Geometry_One Line_51.svg"
    ["Sacred Geometry_One Line_60.imageset"]="harmony_beauty.imageset:Sacred Geometry_One Line_60.svg"

    # 7 - MYSTERY & SPIRITUAL MASTERY
    ["Sacred Geometry_One Line_7.imageset"]="mystery_seed_life.imageset:Sacred Geometry_One Line_7.svg"
    ["Sacred Geometry_One Line_16.imageset"]="mystery_seals.imageset:Sacred Geometry_One Line_16.svg"
    ["Sacred Geometry_One Line_25.imageset"]="mystery_rose.imageset:Sacred Geometry_One Line_25.svg"
    ["Sacred Geometry_One Line_34.imageset"]="mystery_victory.imageset:Sacred Geometry_One Line_34.svg"
    ["Sacred Geometry_One Line_43.imageset"]="mystery_wisdom.imageset:Sacred Geometry_One Line_43.svg"
    ["Sacred Geometry_One Line_52.imageset"]="mystery_magic.imageset:Sacred Geometry_One Line_52.svg"
    ["Sacred Geometry_One Line_61.imageset"]="mystery_gnosis.imageset:Sacred Geometry_One Line_61.svg"

    # 8 - RENEWAL & INFINITE CYCLES
    ["Sacred Geometry_One Line_8.imageset"]="renewal_octagon.imageset:Sacred Geometry_One Line_8.svg"
    ["Sacred Geometry_One Line_17.imageset"]="renewal_infinity.imageset:Sacred Geometry_One Line_17.svg"
    ["Sacred Geometry_One Line_26.imageset"]="renewal_karmic.imageset:Sacred Geometry_One Line_26.svg"
    ["Sacred Geometry_One Line_35.imageset"]="renewal_time.imageset:Sacred Geometry_One Line_35.svg"
    ["Sacred Geometry_One Line_44.imageset"]="renewal_justice.imageset:Sacred Geometry_One Line_44.svg"
    ["Sacred Geometry_One Line_53.imageset"]="renewal_scales.imageset:Sacred Geometry_One Line_53.svg"
    ["Sacred Geometry_One Line_62.imageset"]="renewal_matrix.imageset:Sacred Geometry_One Line_62.svg"

    # 9 - COMPLETION & UNIVERSAL WISDOM
    ["Sacred Geometry_One Line.imageset"]="wisdom_enneagram.imageset:Sacred Geometry_One Line.svg"
    ["Sacred_Geometry_One_Line_1.imageset"]="wisdom_completion.imageset:Sacred Geometry_One Line_1.svg"
)

echo "🔄 Starting asset renaming process..."

# Counter for progress
count=0
total=${#RENAMES[@]}

# Process each rename
for original in "${!RENAMES[@]}"; do
    count=$((count + 1))
    IFS=':' read -r new_name old_svg <<< "${RENAMES[$original]}"
    new_svg="${new_name%.*}.svg"

    original_path="$ASSETS_DIR/$original"
    new_path="$ASSETS_DIR/$new_name"

    echo "[$count/$total] 🔄 $original → $new_name"

    if [ -d "$original_path" ]; then
        # Rename the imageset folder
        mv "$original_path" "$new_path"

        # Update Contents.json to reference new SVG name
        contents_file="$new_path/Contents.json"
        if [ -f "$contents_file" ]; then
            # Replace the filename in Contents.json
            sed -i "" "s/\"$old_svg\"/\"$new_svg\"/g" "$contents_file"
        fi

        # Rename the SVG file inside
        old_svg_path="$new_path/$old_svg"
        new_svg_path="$new_path/$new_svg"
        if [ -f "$old_svg_path" ]; then
            mv "$old_svg_path" "$new_svg_path"
        fi

        echo "  ✅ Renamed folder, SVG, and updated Contents.json"
    else
        echo "  ⚠️  Original imageset not found: $original_path"
    fi
done

echo ""
echo "🎉 Asset renaming complete!"
echo "📊 Processed: $count assets"
echo "💾 Backup created at: $BACKUP_DIR"
echo ""
echo "⚠️  IMPORTANT - XCODE MANUAL STEPS REQUIRED:"
echo "1. Open Xcode"
echo "2. Clean Build Folder (Cmd+Shift+K)"
echo "3. Check Assets.xcassets in Project Navigator"
echo "4. If assets show as missing (red), you may need to:"
echo "   - Right-click Assets.xcassets → 'Show in Finder'"
echo "   - Drag the renamed imagesets back into Xcode"
echo "5. Update any hardcoded asset names in your Swift code"
echo ""
echo "🔮 Your assets now have mystical technical names!"
