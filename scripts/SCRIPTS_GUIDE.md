# 🛠️ VybeMVP Developer Productivity Scripts

Automation tools to eliminate repetitive tasks and enhance development workflow.

## 🎯 Philosophy
**"Manual testing for precision, automated scripts for productivity"**

- **Testing**: Manual execution with Cmd+U for insight and control
- **Profiling**: Automated Instruments memory leak detection  
- **Screenshots**: Automated capture for App Store and documentation
- **Assets**: Batch processing and optimization tools

## 📁 Script Categories

### 🧠 Profiling (`profiling/`)
```bash
./scripts/profiling/memory-check.sh           # Instruments memory leak detection
./scripts/profiling/generate-screenshots.sh   # Automated screenshot capture
```

### 🔮 Assets (`assets/`)
```bash
./scripts/assets/sacred-geometry-optimizer.sh # SVG optimization and validation
```

### 🧹 Utilities (`utils/`)
```bash
./scripts/utils/clean-project.sh              # Comprehensive project cleanup
```

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

Perfect for eliminating boring tasks while maintaining manual testing precision! 🎯