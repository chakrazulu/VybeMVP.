#!/bin/bash

# 🧠 VybeMVP Memory Leak Detection
# Automates Instruments memory profiling for leak detection
# Run after manual testing to catch memory issues

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🧠 VybeMVP Memory Leak Detection${NC}"
echo "================================================="

SCHEME="VybeMVP"
DEVICE="iPhone 16 Pro Max"
OUTPUT_DIR="./Profiling/Memory"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

mkdir -p "$OUTPUT_DIR"

echo -e "${YELLOW}📱 Target: ${DEVICE}${NC}"
echo -e "${YELLOW}📊 Output: ${OUTPUT_DIR}/memory_${TIMESTAMP}.trace${NC}"
echo ""

echo -e "${BLUE}🚀 Launching Instruments memory profiling...${NC}"
echo "• This will launch the app and profile memory usage"
echo "• Interact with the app normally (post creation, navigation, etc.)"
echo "• Press Ctrl+C to stop profiling and generate report"
echo ""

# Launch Instruments with Leaks template
instruments \
    -t "Leaks" \
    -D "${OUTPUT_DIR}/memory_${TIMESTAMP}.trace" \
    -w "iPhone 16 Pro Max" \
    VybeMVP &

INSTRUMENTS_PID=$!

echo -e "${GREEN}📱 App launched! Interact normally and press Ctrl+C when done${NC}"

# Wait for user to stop
trap "echo -e '\n${BLUE}🛑 Stopping profiling...${NC}'" INT
wait $INSTRUMENTS_PID

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