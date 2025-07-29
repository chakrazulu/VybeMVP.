#!/bin/bash

# 🧠 VybeMVP Memory Leak Detection & Performance Profiling
# Automates xctrace (modern Instruments) memory profiling for leak detection and performance analysis
# 
# DEVICE TARGETING OPTIONS:
# - Physical Device (Wireless): Set DEVICE to your actual device name like "iPhone 14 Pro Max"
# - Simulator: Set DEVICE to "iPhone 16 Pro Max" (only simulator installed)
# 
# REQUIREMENTS FOR PHYSICAL DEVICE:
# - Device on same WiFi as Mac (for wireless profiling)
# - OR device plugged in via USB cable
# - Developer mode enabled on device
# - Device trusted/paired with Xcode
# 
# FUTURE AI CONTEXT:
# - This script was enhanced during Performance Optimization Sprint (Post-Phase 18)
# - Targets user's personal iPhone 14 Pro Max for real-world performance data
# - Can fallback to iPhone 16 Pro Max simulator if device unavailable
# - Creates timestamped .trace files for comparison across optimization iterations

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🧠 VybeMVP Memory Leak Detection${NC}"
echo "================================================="

# Configuration - Modify these for different targets
SCHEME="com.infinitiesinn.vybe.VybeMVP"  # Bundle identifier for app launch
# DEVICE OPTIONS:
# For physical device: "Maniac's iPhone" (user's actual iPhone 14 Pro Max)  
# For simulator: "iPhone 16 Pro Max" (only simulator available)
DEVICE="00008120-001E4CD914D8201E"  # Maniac's iPhone UDID (from device list)
FALLBACK_DEVICE="8F2E9D10-58E4-4F19-8CAA-3C3236EEC7FE"  # iPhone 16 Pro Max Simulator (18.5) UDID

OUTPUT_DIR="./Profiling/Memory"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

mkdir -p "$OUTPUT_DIR"

echo -e "${YELLOW}📱 Target: Maniac's iPhone (UDID: ${DEVICE})${NC}"
echo -e "${YELLOW}📊 Output: ${OUTPUT_DIR}/memory_${TIMESTAMP}.trace${NC}"
echo ""

echo -e "${BLUE}🚀 Launching xctrace memory profiling...${NC}"
echo "• This will launch the app and profile memory usage"
echo "• PHYSICAL DEVICE: Make sure Maniac's iPhone (iPhone 14 Pro Max) is connected (wireless or USB)"
echo "• Interact with the app normally (navigation, cosmic animations, social features)"
echo "• Focus on: Timeline scrolling, profile views, cosmic animations, post creation"
echo "• Press Ctrl+C to stop profiling and generate report"
echo ""

echo -e "${YELLOW}🎯 Profiling Strategy:${NC}"
echo "1. Let app fully launch and load"
echo "2. Navigate through all main tabs"
echo "3. Test cosmic animations and sacred geometry"
echo "4. Scroll timeline, create/view posts" 
echo "5. Open profile/sanctum views"
echo "6. Stress test: rapid navigation, scrolling"
echo ""

# Launch xctrace with Leaks template - try physical device first
echo -e "${BLUE}📱 Attempting to connect to: Maniac's iPhone${NC}"

# Use modern xctrace command (replacement for deprecated instruments CLI)
XCTRACE="$(xcrun -find xctrace)"

# Try physical device first, fallback to simulator if it fails
if ! "$XCTRACE" record \
    --template "Leaks" \
    --output "${OUTPUT_DIR}/memory_${TIMESTAMP}.trace" \
    --device "${DEVICE}" \
    --launch -- "${SCHEME}" &
then
    echo -e "${YELLOW}⚠️  Physical device connection failed, falling back to simulator...${NC}"
    echo -e "${BLUE}📱 Connecting to: iPhone 16 Pro Max Simulator${NC}"
    "$XCTRACE" record \
        --template "Leaks" \
        --output "${OUTPUT_DIR}/memory_${TIMESTAMP}.trace" \
        --device "${FALLBACK_DEVICE}" \
        --launch -- "${SCHEME}" &
fi

XCTRACE_PID=$!

echo -e "${GREEN}📱 App launched! Interact normally and press Ctrl+C when done${NC}"

# Wait for user to stop
trap "echo -e '\n${BLUE}🛑 Stopping profiling...${NC}'" INT
wait $XCTRACE_PID

echo -e "${GREEN}✅ Memory profiling complete!${NC}"
echo -e "${BLUE}📊 Results saved to: ${OUTPUT_DIR}/memory_${TIMESTAMP}.trace${NC}"
echo ""
echo -e "${YELLOW}🔍 Quick Analysis:${NC}"
echo "• Open trace file in Instruments for detailed analysis"
echo "• Look for red leak indicators in timeline"
echo "• Check UserProfileView, PostManager, and cosmic animations"
echo ""
echo -e "${BLUE}📋 Next Steps:${NC}"
echo "1. Open ${OUTPUT_DIR}/memory_${TIMESTAMP}.trace in Instruments"
echo "2. Review leak detection results"
echo "3. Fix any memory leaks found"
echo "4. Re-run this script to verify fixes"