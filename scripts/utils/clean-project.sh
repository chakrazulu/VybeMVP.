#!/bin/bash

# 🧹 VybeMVP Project Cleaner
# Comprehensive cleanup of build artifacts and caches
# Useful when builds get corrupted or need fresh start

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🧹 VybeMVP Project Cleaner${NC}"
echo "================================================="

echo -e "${YELLOW}🗑️  Cleaning build artifacts...${NC}"

# Clean Xcode derived data
echo "• Clearing DerivedData..."
rm -rf ~/Library/Developer/Xcode/DerivedData/VybeMVP-* 2>/dev/null || true

# Clean local build folder
if [ -d "build" ]; then
    echo "• Clearing local build folder..."
    rm -rf build
fi

# Clean user data
echo "• Clearing Xcode user data..."
find . -name "*.xcuserdata" -exec rm -rf {} + 2>/dev/null || true

# Clean DS_Store files
echo "• Removing .DS_Store files..."
find . -name ".DS_Store" -delete 2>/dev/null || true

# Clean temporary files
echo "• Removing temporary files..."
rm -rf /tmp/VybeMVP-* 2>/dev/null || true

# Clean simulator data (optional)
read -p "🔄 Reset simulator data? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "• Resetting simulator..."
    xcrun simctl shutdown all
    xcrun simctl erase all
    echo -e "${GREEN}✅ Simulator reset complete${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Project cleanup complete!${NC}"
echo ""
echo -e "${BLUE}📋 What was cleaned:${NC}"
echo "✅ Xcode DerivedData"
echo "✅ Local build folders"
echo "✅ User data files"
echo "✅ .DS_Store files"
echo "✅ Temporary files"
echo "$([ "$REPLY" = "y" ] && echo "✅ Simulator data" || echo "⏸️  Simulator data (skipped)")"
echo ""
echo -e "${YELLOW}🔧 Next Steps:${NC}"
echo "1. Open Xcode"
echo "2. Clean Build Folder (Cmd+Shift+K)"
echo "3. Build project (Cmd+B)"
echo "4. Test functionality to ensure everything works"
