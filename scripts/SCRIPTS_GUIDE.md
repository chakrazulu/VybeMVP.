# 🛠️ VybeMVP Developer Productivity Scripts

**Last Updated:** July 27, 2025 - Post Phase 18  
**Purpose:** Automation tools to eliminate repetitive tasks and enhance development workflow  
**Context:** Custom scripts developed to support performance optimization and development workflow  

Automation tools to eliminate repetitive tasks and enhance development workflow.

## 🎯 Philosophy
**"Manual testing for precision, automated scripts for productivity"**

- **Testing**: Manual execution with Cmd+U for insight and control (434/434 tests passing)
- **Profiling**: Automated Instruments memory leak detection and performance analysis
- **Screenshots**: Automated capture for App Store and documentation
- **Assets**: Batch processing and optimization tools for sacred geometry SVGs

## 🧠 **Claude Context for Future AI Instances**

These scripts were developed during Phase 18 and Performance Optimization phases to:
- **Automate repetitive profiling tasks** that developers shouldn't do manually
- **Provide consistent performance benchmarks** across development cycles
- **Support App Store asset generation** with automated screenshot capture
- **Optimize sacred geometry assets** for better app performance

## 📁 Script Categories

### 🧠 Profiling (`profiling/`)
```bash
./scripts/profiling/memory-check.sh           # Instruments memory leak detection
./scripts/profiling/generate-screenshots.sh   # Automated screenshot capture
```

**memory-check.sh** - Critical Performance Analysis Tool  
- **Purpose:** Automated Instruments profiling for memory leaks and performance bottlenecks
- **Target Device:** iPhone 16 Pro Max simulator (matches development target)
- **Output:** Timestamped .trace files in `./Profiling/Memory/` directory
- **When to Use:** After major code changes, before releases, during performance sprints
- **Human Interaction Required:** User must interact with app during profiling for realistic data
- **Analysis:** Opens in Instruments for detailed leak detection and memory pattern analysis

**generate-screenshots.sh** - App Store Asset Automation  
- **Purpose:** Automated screenshot capture for App Store listings and documentation
- **Output:** Marketing-ready screenshots in standardized formats
- **When to Use:** Before App Store submissions, for marketing materials

### 🔮 Assets (`assets/`)
```bash
./scripts/assets/sacred-geometry-optimizer.sh # SVG optimization and validation
```

**sacred-geometry-optimizer.sh** - Spiritual Asset Optimization  
- **Purpose:** Optimizes sacred geometry SVG files for app performance while preserving spiritual accuracy
- **Process:** Compresses file sizes, validates sacred proportions, creates backup copies
- **Output:** Optimized SVGs + backup folder with timestamp
- **Dependencies:** Requires `svgo` (npm install -g svgo)
- **Spiritual Integrity:** Maintains exact geometric proportions essential for mystical accuracy

### 🧹 Utilities (`utils/`)
```bash
./scripts/utils/clean-project.sh              # Comprehensive project cleanup
```

**clean-project.sh** - Development Environment Reset  
- **Purpose:** Comprehensive cleanup of development artifacts and cached data
- **Cleans:** DerivedData, build folders, temporary files, cached assets
- **When to Use:** When experiencing build issues, before major releases, periodic maintenance
- **Safety:** Preserves source code and important project files

## 🚀 Quick Start

1. **Make scripts executable:**
   ```bash
   chmod +x scripts/**/*.sh
   ```

2. **Memory leak detection:**
   ```bash
   ./scripts/profiling/memory-check.sh
   ```

3. **Generate App Store screenshots:**
   ```bash
   ./scripts/profiling/generate-screenshots.sh
   ```

4. **Optimize sacred geometry assets:**
   ```bash
   ./scripts/assets/sacred-geometry-optimizer.sh
   ```

## 🎮 Development Workflow

### Daily Cycle
1. **Code changes** - Normal development
2. **Manual testing** - Cmd+U for test execution
3. **Automated profiling** - Memory leak detection
4. **Asset processing** - SVG optimization as needed

### Pre-Release
1. **Manual test suite** - Complete Cmd+U validation
2. **Memory profiling** - Clean leak report
3. **Screenshot update** - Fresh marketing assets
4. **Asset optimization** - All SVGs processed

## 📊 Output Locations

- **Memory profiles**: `./Profiling/Memory/`
- **Screenshots**: `./Screenshots/`
- **Asset backups**: `./backup_svg_[timestamp]/`

## 🔧 Dependencies

- **Xcode Command Line Tools** (included)
- **svgo** (optional): `npm install -g svgo`
- **Instruments** (included with Xcode)

## 🚀 **Performance Optimization Workflow (Current Sprint)**

### **Phase 1: Baseline Measurement**
```bash
# 1. Clean environment first
./scripts/utils/clean-project.sh

# 2. Get baseline memory performance
./scripts/profiling/memory-check.sh
```

### **Phase 2: Optimization Cycle**
1. **Make performance improvements** (Core Data, memory management, etc.)
2. **Re-run memory profiling** to measure impact
3. **Compare trace files** to validate improvements
4. **Repeat until targets achieved**

### **Phase 3: Asset Optimization**
```bash
# Optimize sacred geometry assets for better loading performance
./scripts/assets/sacred-geometry-optimizer.sh
```

### **🎯 Performance Targets (Post-Phase 18)**
- **App Launch:** <400ms cold start
- **Memory Usage:** <200MB baseline, no leaks
- **Cosmic Animations:** Stable 60fps 
- **Core Data:** Background context operations
- **Sacred Geometry:** Optimized SVG loading

### **📊 Key Metrics to Track**
- Memory leaks (red indicators in Instruments)
- Peak memory usage during cosmic animations
- Core Data save operation timing
- App launch performance
- UI responsiveness during timeline scrolling

Perfect for eliminating boring tasks while maintaining manual testing precision! 🎯