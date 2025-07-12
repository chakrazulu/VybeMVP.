#!/bin/bash

# 📸 VybeMVP Screenshot Automation
# Automates screenshot capture for App Store and documentation
# Eliminates manual screenshot taking for marketing materials

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}📸 VybeMVP Screenshot Automation${NC}"
echo "================================================="

DEVICE="iPhone 16 Pro Max"
OUTPUT_DIR="./Screenshots"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
APP_NAME="VybeMVP"

mkdir -p "$OUTPUT_DIR"

echo -e "${YELLOW}📱 Device: ${DEVICE}${NC}"
echo -e "${YELLOW}📁 Output: ${OUTPUT_DIR}/${NC}"
echo ""

# Function to take screenshot
take_screenshot() {
    local name=$1
    local description=$2
    
    echo -e "${BLUE}📸 $description${NC}"
    echo "   Position the app for: $name"
    echo "   Press ENTER when ready..."
    read
    
    xcrun simctl io booted screenshot "${OUTPUT_DIR}/${TIMESTAMP}_${name}.png"
    echo -e "${GREEN}   ✅ Saved: ${name}.png${NC}"
    echo ""
}

echo -e "${YELLOW}🎬 Starting screenshot session...${NC}"
echo "Make sure VybeMVP is open on iPhone 16 Pro Max simulator"
echo "Press ENTER to continue..."
read

# Core app screenshots
take_screenshot "01_onboarding" "Onboarding - Spiritual Mode Selection"
take_screenshot "02_profile_setup" "Profile Setup - Name and Birthday"
take_screenshot "03_home_view" "Home View - Focus Number Display"
take_screenshot "04_sacred_geometry" "Sacred Geometry - Neon Tracer Animation"
take_screenshot "05_social_timeline" "Social Timeline - Global Resonance"
take_screenshot "06_post_creation" "Post Creation - Spiritual Sharing"
take_screenshot "07_user_profile" "User Profile - Posts and Insights"
take_screenshot "08_match_analytics" "Match Analytics - Cosmic Insights"
take_screenshot "09_chakra_view" "Chakra View - Spiritual Symbols"
take_screenshot "10_activity_tab" "Activity Tab - Personal Timeline"

echo -e "${GREEN}🎉 Screenshot session complete!${NC}"
echo ""
echo -e "${BLUE}📊 Generated Screenshots:${NC}"
ls -la "${OUTPUT_DIR}/${TIMESTAMP}_"*.png 2>/dev/null || echo "No screenshots found"
echo ""
echo -e "${YELLOW}📋 Next Steps:${NC}"
echo "1. Review screenshots in ${OUTPUT_DIR}/"
echo "2. Select best ones for App Store submission"
echo "3. Use for documentation and marketing"
echo "4. Archive old screenshots if satisfied"