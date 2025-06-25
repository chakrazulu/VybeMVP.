#!/bin/bash

# Simple Sacred Geometry Asset Renaming Script
# Uses individual commands for reliability

echo "🔮 VybeMVP Sacred Geometry Asset Renaming (Simple Version)"
echo "========================================================"

# Set working directory
cd "MandalaAssets/VybeApp/Assets.xcassets" || exit

echo "📁 Working in: $(pwd)"

# Create backup
BACKUP_DIR="../../../backup_sacred_geometry_$(date +%Y%m%d_%H%M%S)"
echo "💾 Creating backup at: $BACKUP_DIR"
cp -r . "$BACKUP_DIR"

echo "🔄 Starting renaming process..."

# Helper function to rename asset
rename_asset() {
    local old_name="$1"
    local new_name="$2"
    local svg_old="$3"
    local svg_new="$4"
    
    if [ -d "$old_name" ]; then
        echo "✅ $old_name → $new_name"
        
        # Rename folder
        mv "$old_name" "$new_name"
        
        # Update Contents.json
        if [ -f "$new_name/Contents.json" ]; then
            sed -i '' "s/$svg_old/$svg_new/g" "$new_name/Contents.json"
        fi
        
        # Rename SVG file
        if [ -f "$new_name/$svg_old" ]; then
            mv "$new_name/$svg_old" "$new_name/$svg_new"
        fi
    else
        echo "⚠️ Not found: $old_name"
    fi
}

# 0 - VOID & INFINITE POTENTIAL
rename_asset "Sacred Geometry_One Line_63.imageset" "void_triquetra.imageset" "Sacred Geometry_One Line_63.svg" "void_triquetra.svg"
rename_asset "Sacred Geometry_One Line_36.imageset" "void_cosmic_womb.imageset" "Sacred Geometry_One Line_36.svg" "void_cosmic_womb.svg"
rename_asset "Sacred Geometry_One Line_54.imageset" "void_zero_point.imageset" "Sacred Geometry_One Line_54.svg" "void_zero_point.svg"
rename_asset "Sacred Geometry_One Line_45.imageset" "void_eternal_return.imageset" "Sacred Geometry_One Line_45.svg" "void_eternal_return.svg"
rename_asset "Sacred Geometry_One Line_18.imageset" "void_star_matrix.imageset" "Sacred Geometry_One Line_18.svg" "void_star_matrix.svg"
rename_asset "Sacred Geometry_One Line_27.imageset" "void_akashic_grid.imageset" "Sacred Geometry_One Line_27.svg" "void_akashic_grid.svg"
rename_asset "Sacred Geometry_One Line_9.imageset" "void_crystal.imageset" "Sacred Geometry_One Line_9.svg" "void_crystal.svg"

# 1 - UNITY & DIVINE SPARK
rename_asset "Sacred Geometry_One Line_1.imageset" "unity_merkaba.imageset" "Sacred Geometry_One Line_1.svg" "unity_merkaba.svg"
rename_asset "Sacred Geometry_One Line_10.imageset" "unity_solar.imageset" "Sacred Geometry_One Line_10.svg" "unity_solar.svg"
rename_asset "Sacred Geometry_One Line_19.imageset" "unity_crown.imageset" "Sacred Geometry_One Line_19.svg" "unity_crown.svg"
rename_asset "Sacred Geometry_One Line_28.imageset" "unity_monad.imageset" "Sacred Geometry_One Line_28.svg" "unity_monad.svg"
rename_asset "Sacred Geometry_One Line_37.imageset" "unity_alpha.imageset" "Sacred Geometry_One Line_37.svg" "unity_alpha.svg"
rename_asset "Sacred Geometry_One Line_46.imageset" "unity_consciousness.imageset" "Sacred Geometry_One Line_46.svg" "unity_consciousness.svg"
rename_asset "Sacred Geometry_One Line_55.imageset" "unity_spark.imageset" "Sacred Geometry_One Line_55.svg" "unity_spark.svg"

# 2 - DUALITY & COSMIC POLARITY
rename_asset "Sacred Geometry_One Line_2.imageset" "duality_vesica.imageset" "Sacred Geometry_One Line_2.svg" "duality_vesica.svg"
rename_asset "Sacred Geometry_One Line_11.imageset" "duality_lunar.imageset" "Sacred Geometry_One Line_11.svg" "duality_lunar.svg"
rename_asset "Sacred Geometry_One Line_20.imageset" "duality_yin_yang.imageset" "Sacred Geometry_One Line_20.svg" "duality_yin_yang.svg"
rename_asset "Sacred Geometry_One Line_29.imageset" "duality_pillars.imageset" "Sacred Geometry_One Line_29.svg" "duality_pillars.svg"
rename_asset "Sacred Geometry_One Line_38.imageset" "duality_divine.imageset" "Sacred Geometry_One Line_38.svg" "duality_divine.svg"
rename_asset "Sacred Geometry_One Line_47.imageset" "duality_twins.imageset" "Sacred Geometry_One Line_47.svg" "duality_twins.svg"
rename_asset "Sacred Geometry_One Line_56.imageset" "duality_mirror.imageset" "Sacred Geometry_One Line_56.svg" "duality_mirror.svg"

# 3 - TRINITY & DIVINE CREATIVITY
rename_asset "Sacred Geometry_One Line_3.imageset" "trinity_mandala.imageset" "Sacred Geometry_One Line_3.svg" "trinity_mandala.svg"
rename_asset "Sacred Geometry_One Line_12.imageset" "trinity_triangle.imageset" "Sacred Geometry_One Line_12.svg" "trinity_triangle.svg"
rename_asset "Sacred Geometry_One Line_21.imageset" "trinity_wisdom.imageset" "Sacred Geometry_One Line_21.svg" "trinity_wisdom.svg"
rename_asset "Sacred Geometry_One Line_30.imageset" "trinity_fire.imageset" "Sacred Geometry_One Line_30.svg" "trinity_fire.svg"
rename_asset "Sacred Geometry_One Line_39.imageset" "trinity_gate.imageset" "Sacred Geometry_One Line_39.svg" "trinity_gate.svg"
rename_asset "Sacred Geometry_One Line_48.imageset" "trinity_expression.imageset" "Sacred Geometry_One Line_48.svg" "trinity_expression.svg"
rename_asset "Sacred Geometry_One Line_57.imageset" "trinity_logos.imageset" "Sacred Geometry_One Line_57.svg" "trinity_logos.svg"

# 4 - FOUNDATION & MATERIAL MANIFESTATION
rename_asset "Sacred Geometry_One Line_4.imageset" "foundation_cube.imageset" "Sacred Geometry_One Line_4.svg" "foundation_cube.svg"
rename_asset "Sacred Geometry_One Line_13.imageset" "foundation_cross.imageset" "Sacred Geometry_One Line_13.svg" "foundation_cross.svg"
rename_asset "Sacred Geometry_One Line_22.imageset" "foundation_temple.imageset" "Sacred Geometry_One Line_22.svg" "foundation_temple.svg"
rename_asset "Sacred Geometry_One Line_31.imageset" "foundation_stone.imageset" "Sacred Geometry_One Line_31.svg" "foundation_stone.svg"
rename_asset "Sacred Geometry_One Line_40.imageset" "foundation_grid.imageset" "Sacred Geometry_One Line_40.svg" "foundation_grid.svg"
rename_asset "Sacred Geometry_One Line_49.imageset" "foundation_matrix.imageset" "Sacred Geometry_One Line_49.svg" "foundation_matrix.svg"
rename_asset "Sacred Geometry_One Line_58.imageset" "foundation_blessing.imageset" "Sacred Geometry_One Line_58.svg" "foundation_blessing.svg"

# 5 - QUINTESSENCE & DIVINE WILL
rename_asset "Sacred Geometry_One Line_5.imageset" "will_pentagram.imageset" "Sacred Geometry_One Line_5.svg" "will_pentagram.svg"
rename_asset "Sacred Geometry_One Line_14.imageset" "will_golden_spiral.imageset" "Sacred Geometry_One Line_14.svg" "will_golden_spiral.svg"
rename_asset "Sacred Geometry_One Line_23.imageset" "will_shield.imageset" "Sacred Geometry_One Line_23.svg" "will_shield.svg"
rename_asset "Sacred Geometry_One Line_32.imageset" "will_phoenix.imageset" "Sacred Geometry_One Line_32.svg" "will_phoenix.svg"
rename_asset "Sacred Geometry_One Line_41.imageset" "will_power.imageset" "Sacred Geometry_One Line_41.svg" "will_power.svg"
rename_asset "Sacred Geometry_One Line_50.imageset" "will_star.imageset" "Sacred Geometry_One Line_50.svg" "will_star.svg"
rename_asset "Sacred Geometry_One Line_59.imageset" "will_command.imageset" "Sacred Geometry_One Line_59.svg" "will_command.svg"

# 6 - HARMONY & COSMIC LOVE
rename_asset "Sacred Geometry_One Line_6.imageset" "harmony_star_david.imageset" "Sacred Geometry_One Line_6.svg" "harmony_star_david.svg"
rename_asset "Sacred Geometry_One Line_15.imageset" "harmony_flower_life.imageset" "Sacred Geometry_One Line_15.svg" "harmony_flower_life.svg"
rename_asset "Sacred Geometry_One Line_24.imageset" "harmony_heart.imageset" "Sacred Geometry_One Line_24.svg" "harmony_heart.svg"
rename_asset "Sacred Geometry_One Line_33.imageset" "harmony_christ.imageset" "Sacred Geometry_One Line_33.svg" "harmony_christ.svg"
rename_asset "Sacred Geometry_One Line_42.imageset" "harmony_universal.imageset" "Sacred Geometry_One Line_42.svg" "harmony_universal.svg"
rename_asset "Sacred Geometry_One Line_51.imageset" "harmony_marriage.imageset" "Sacred Geometry_One Line_51.svg" "harmony_marriage.svg"
rename_asset "Sacred Geometry_One Line_60.imageset" "harmony_beauty.imageset" "Sacred Geometry_One Line_60.svg" "harmony_beauty.svg"

# 7 - MYSTERY & SPIRITUAL MASTERY
rename_asset "Sacred Geometry_One Line_7.imageset" "mystery_seed_life.imageset" "Sacred Geometry_One Line_7.svg" "mystery_seed_life.svg"
rename_asset "Sacred Geometry_One Line_16.imageset" "mystery_seals.imageset" "Sacred Geometry_One Line_16.svg" "mystery_seals.svg"
rename_asset "Sacred Geometry_One Line_25.imageset" "mystery_rose.imageset" "Sacred Geometry_One Line_25.svg" "mystery_rose.svg"
rename_asset "Sacred Geometry_One Line_34.imageset" "mystery_victory.imageset" "Sacred Geometry_One Line_34.svg" "mystery_victory.svg"
rename_asset "Sacred Geometry_One Line_43.imageset" "mystery_wisdom.imageset" "Sacred Geometry_One Line_43.svg" "mystery_wisdom.svg"
rename_asset "Sacred Geometry_One Line_52.imageset" "mystery_magic.imageset" "Sacred Geometry_One Line_52.svg" "mystery_magic.svg"
rename_asset "Sacred Geometry_One Line_61.imageset" "mystery_gnosis.imageset" "Sacred Geometry_One Line_61.svg" "mystery_gnosis.svg"

# 8 - RENEWAL & INFINITE CYCLES
rename_asset "Sacred Geometry_One Line_8.imageset" "renewal_octagon.imageset" "Sacred Geometry_One Line_8.svg" "renewal_octagon.svg"
rename_asset "Sacred Geometry_One Line_17.imageset" "renewal_infinity.imageset" "Sacred Geometry_One Line_17.svg" "renewal_infinity.svg"
rename_asset "Sacred Geometry_One Line_26.imageset" "renewal_karmic.imageset" "Sacred Geometry_One Line_26.svg" "renewal_karmic.svg"
rename_asset "Sacred Geometry_One Line_35.imageset" "renewal_time.imageset" "Sacred Geometry_One Line_35.svg" "renewal_time.svg"
rename_asset "Sacred Geometry_One Line_44.imageset" "renewal_justice.imageset" "Sacred Geometry_One Line_44.svg" "renewal_justice.svg"
rename_asset "Sacred Geometry_One Line_53.imageset" "renewal_scales.imageset" "Sacred Geometry_One Line_53.svg" "renewal_scales.svg"
rename_asset "Sacred Geometry_One Line_62.imageset" "renewal_matrix.imageset" "Sacred Geometry_One Line_62.svg" "renewal_matrix.svg"

# 9 - COMPLETION & UNIVERSAL WISDOM
rename_asset "Sacred Geometry_One Line.imageset" "wisdom_enneagram.imageset" "Sacred Geometry_One Line.svg" "wisdom_enneagram.svg"
rename_asset "Sacred_Geometry_One_Line_1.imageset" "wisdom_completion.imageset" "Sacred_Geometry_One_Line_1.svg" "wisdom_completion.svg"

echo ""
echo "🎉 Sacred Geometry Renaming Complete!"
echo "💾 Backup created at: $BACKUP_DIR"
echo ""
echo "🔮 Your sacred geometry assets now have mystical technical names!"
echo "✨ Next: Clean Build Folder in Xcode (Cmd+Shift+K)" 