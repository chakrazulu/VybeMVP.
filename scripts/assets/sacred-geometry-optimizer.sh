#!/bin/bash

# 🔮 Sacred Geometry Asset Optimizer
# Optimizes SVG files and ensures consistent naming
# Extends your existing asset renaming workflow

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🔮 Sacred Geometry Asset Optimizer${NC}"
echo "================================================="

SVG_DIR="./Resources/SVG"
BACKUP_DIR="./backup_svg_$(date +%Y%m%d_%H%M%S)"

if [ ! -d "$SVG_DIR" ]; then
    echo -e "${YELLOW}⚠️  SVG directory not found: $SVG_DIR${NC}"
    echo "Please run from project root directory"
    exit 1
fi

echo -e "${BLUE}📁 Processing: $SVG_DIR${NC}"
echo -e "${BLUE}💾 Backup: $BACKUP_DIR${NC}"
echo ""

# Create backup
echo -e "${YELLOW}💾 Creating backup...${NC}"
cp -r "$SVG_DIR" "$BACKUP_DIR"
echo -e "${GREEN}✅ Backup created${NC}"

# Count files
SVG_COUNT=$(find "$SVG_DIR" -name "*.svg" | wc -l | tr -d ' ')
echo -e "${BLUE}📊 Found $SVG_COUNT SVG files${NC}"
echo ""

# Optimize SVGs (if svgo is available)
if command -v svgo &> /dev/null; then
    echo -e "${YELLOW}🔧 Optimizing SVG files...${NC}"
    svgo --folder "$SVG_DIR" --recursive --quiet
    echo -e "${GREEN}✅ SVG optimization complete${NC}"
else
    echo -e "${YELLOW}ℹ️  svgo not installed - skipping optimization${NC}"
    echo "   Install with: npm install -g svgo"
fi

# Validate naming convention
echo -e "${YELLOW}🔍 Validating naming convention...${NC}"
INVALID_NAMES=0

find "$SVG_DIR" -name "*.svg" | while read -r file; do
    basename=$(basename "$file")
    
    # Check if follows pattern: category_name.svg
    if [[ ! $basename =~ ^[a-z]+_[a-z_]+\.svg$ ]]; then
        echo -e "${YELLOW}   ⚠️  Non-standard name: $basename${NC}"
        ((INVALID_NAMES++))
    fi
done

# Generate asset report
echo ""
echo -e "${BLUE}📋 Asset Report${NC}"
echo "----------------------------------------"
echo "📊 Total SVG files: $SVG_COUNT"
echo "💾 Backup location: $BACKUP_DIR"
echo "🔧 Optimization: $(command -v svgo &> /dev/null && echo "Applied" || echo "Skipped")"
echo ""

# List by category
echo -e "${BLUE}📂 Files by Category:${NC}"
find "$SVG_DIR" -name "*.svg" | sed 's|.*/||' | cut -d'_' -f1 | sort | uniq -c | sort -nr

echo ""
echo -e "${GREEN}🎉 Sacred geometry asset processing complete!${NC}"
echo ""
echo -e "${YELLOW}📋 Next Steps:${NC}"
echo "1. Review optimized files in $SVG_DIR"
echo "2. Test in Xcode to ensure assets load correctly"
echo "3. Remove backup if satisfied: rm -rf $BACKUP_DIR"
echo "4. Commit changes to version control"