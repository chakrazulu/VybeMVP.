# 🔧 PASTELY - Technical Implementation Guide

## Core Problem
Files created in Cursor don't automatically integrate with Xcode projects, forcing developers into a manual copy-paste-rename workflow that defeats the purpose of AI assistance.

## Technical Solution Overview

### 1. File System Monitoring
**Use FSEvents API via Swift wrapper library**
```swift
import Foundation

// Using FileWatcher library (recommended)
let fileWatcher = FileWatcher([projectPath])
fileWatcher.callback = { event in
    handleNewFile(event)
}
fileWatcher.start()
```

### 2. Xcode Project Integration
**Three implementation approaches:**

#### Option A: xcodebuild CLI (Recommended)
```bash
# Add file to Xcode project
xcodebuild -project MyProject.xcodeproj -target MyTarget -configuration Debug OTHER_SWIFT_FLAGS="-D DEBUG" -add-file /path/to/NewFile.swift
```

#### Option B: Project File Manipulation
```swift
// Parse and modify .xcodeproj/project.pbxproj
let projectFile = try String(contentsOfFile: projectPath)
let modifiedProject = addFileToProject(projectFile, filePath: newFilePath)
try modifiedProject.write(to: projectPath)
```

#### Option C: AppleScript Automation
```applescript
tell application "Xcode"
    tell project "MyProject"
        add file "/path/to/NewFile.swift" to group "Views"
    end tell
end tell
```

### 3. Smart File Categorization
```swift
func categorizeFile(_ filePath: String) -> String {
    let content = try? String(contentsOfFile: filePath)
    let fileName = URL(fileURLWithPath: filePath).lastPathComponent
    
    if content?.contains("struct") == true && content?.contains("View") == true {
        return "Views"
    } else if content?.contains("class") == true && content?.contains("Manager") == true {
        return "Managers"
    } else if fileName.contains("Model") {
        return "Models"
    }
    return "Supporting Files"
}
```

### 4. Menu Bar App Architecture
```swift
import Cocoa

@main
class PastelyApp: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let fileMonitor = FileMonitor()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        startFileMonitoring()
    }
    
    private func setupMenuBar() {
        statusItem.button?.title = "📋"
        statusItem.menu = createMenu()
    }
}
```

## Development Steps

### Phase 1: Core MVP (Week 1-2)
1. **File System Monitoring**: Implement FSEvents via FileWatcher library
2. **Basic Xcode Integration**: xcodebuild CLI approach
3. **Menu Bar Interface**: Status item with basic controls
4. **File Detection**: Monitor for .swift files only

### Phase 2: Smart Features (Week 3-4)
1. **File Categorization**: Analyze content and place appropriately
2. **Settings Panel**: User preferences for monitoring paths
3. **Conflict Resolution**: Handle duplicate files
4. **Bi-directional Sync**: Xcode → Cursor file creation

### Phase 3: Advanced Features (Week 5-6)
1. **Batch Operations**: Handle multiple files at once
2. **Undo/Redo**: Revert file additions
3. **Custom Rules**: User-defined categorization
4. **Performance Optimization**: Memory and CPU efficiency

## Key Technical Decisions

### File System Monitoring
- **Use FileWatcher library** (not raw FSEvents) for Swift compatibility
- **Monitor entire project directory** with recursive watching
- **Filter file types** (.swift, .h, .m, .xib, .storyboard)

### Xcode Integration
- **Primary: xcodebuild CLI** (most reliable)
- **Fallback: Project file parsing** (if CLI fails)
- **Never use AppleScript** (unreliable and slow)

### Architecture
- **Menu bar app** (not dock app) for minimal footprint
- **Background monitoring** with low CPU usage
- **Instant sync** when files detected

## Required Dependencies

### Swift Packages
```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/eonist/FileWatcher", from: "0.1.0")
]
```

### macOS Requirements
- **macOS 10.15+** (for notarization)
- **Xcode 12+** (for development)
- **Developer ID Certificate** (for distribution)

## Distribution Strategy

### Development Setup
1. **Apple Developer Account**: $99/year
2. **Code Signing**: Developer ID Application certificate
3. **Notarization**: Required for distribution outside App Store

### Build Process
```bash
# Build release version
xcodebuild -project Pastely.xcodeproj -scheme Pastely -configuration Release -archivePath Pastely.xcarchive archive

# Export for distribution
xcodebuild -exportArchive -archivePath Pastely.xcarchive -exportPath Pastely -exportOptionsPlist ExportOptions.plist

# Notarize
xcrun notarytool submit Pastely.app --apple-id YOUR_APPLE_ID --team-id YOUR_TEAM_ID --wait
```

## Performance Considerations

### Memory Usage
- **Lightweight monitoring**: Only essential file events
- **Lazy loading**: Load Xcode project data only when needed
- **Cleanup**: Dispose of inactive watchers

### CPU Usage
- **Debounced events**: Avoid rapid-fire file changes
- **Background processing**: Non-blocking file operations
- **Efficient parsing**: Fast project file analysis

## Error Handling

### Common Issues
1. **Xcode not running**: Queue files for later integration
2. **Permission denied**: Request file system access
3. **Project not found**: Prompt user to select project
4. **Duplicate files**: Offer resolution options

### Recovery Strategies
```swift
func handleFileAdditionError(_ error: Error, filePath: String) {
    switch error {
    case .projectNotFound:
        promptUserForProject()
    case .permissionDenied:
        requestFileSystemAccess()
    case .duplicateFile:
        offerDuplicateResolution(filePath)
    default:
        logError(error)
    }
}
```

## Testing Strategy

### Unit Tests
- File categorization logic
- Project file parsing
- Menu bar functionality

### Integration Tests
- Xcode project integration
- File system monitoring
- End-to-end workflow

### Manual Testing
- Multiple Xcode projects
- Various file types
- Edge cases (large files, special characters)

## Next Steps
1. **Set up Xcode project** with menu bar app template
2. **Implement FileWatcher integration** for file monitoring
3. **Build xcodebuild CLI wrapper** for project integration
4. **Create basic menu bar interface** with status updates
5. **Test with real Cursor + Xcode workflow**

This technical specification provides everything needed to build Pastely's core functionality. The MVP can be completed in 2-4 weeks with the right focus on the essential features.