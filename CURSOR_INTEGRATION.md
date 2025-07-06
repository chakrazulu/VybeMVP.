# Cursor Integration for Xcode File Sync

## Overview
This document explains how to integrate the Xcode file synchronization system with your Cursor workflow for seamless Swift development.

## Workflow Integration

### 1. After Creating Files with Cursor
When Cursor creates new Swift files, simply run:
```bash
./sync_xcode.sh
```

This will automatically:
- Find all new Swift files in your project
- Add them to the correct Xcode groups based on folder structure
- Update your VybeMVP.xcodeproj file
- Skip files that are already in the project

### 2. Terminal Integration in Cursor
You can run the sync command directly from Cursor's integrated terminal:

1. Open terminal in Cursor (`Cmd+` `)
2. Run `./sync_xcode.sh`
3. Switch to Xcode to see your new files

### 3. Cursor Terminal Shortcuts
Add these aliases to your shell profile (`~/.zshrc` or `~/.bash_profile`):

```bash
# Xcode sync aliases
alias xsync="./sync_xcode.sh"
alias xsync-silent="ruby sync_xcode_files.rb"
```

Then you can just type `xsync` after creating files.

### 4. File Creation Best Practices

When creating files with Cursor:
- **Follow folder structure**: Place files in correct directories (Views/, Features/, Managers/, etc.)
- **Use descriptive names**: Match your class/struct names with filenames
- **Run sync immediately**: Don't batch multiple file creations before syncing

### 5. Recommended Workflow

1. **Create files** with Cursor in appropriate folders
2. **Run sync**: `./sync_xcode.sh`
3. **Switch to Xcode** to continue development/testing
4. **Repeat** as needed

## Troubleshooting

### Common Issues

**"xcodeproj gem not installed"**
- Run `./setup_xcode_sync.sh` once to install dependencies

**"Files not appearing in Xcode"**
- Make sure you're running the script from the project root directory
- Check that the Swift files are in the correct folder structure

**"Permission denied"**
- Run `chmod +x sync_xcode.sh` to make the script executable

### Folder Structure Mapping

The script automatically maps filesystem folders to Xcode groups:

```
Views/                    → Views group
Features/                 → Features group  
Managers/                 → Managers group
Core/Data/               → Core/Data group
Core/Models/             → Core/Models group
Core/Utilities/          → Core/Utilities group
Utilities/               → Utilities group
VybeApp/                 → VybeApp group
Auth/                    → Auth group
App/                     → App group
VybeMVPTests/            → VybeMVPTests group
```

## Advanced Usage

### Silent Mode
For automated workflows or when you don't need verbose output:
```bash
ruby sync_xcode_files.rb
```

### Integration with Git Hooks
You can add the sync to your git hooks for automatic syncing:
```bash
# In .git/hooks/post-commit
#!/bin/bash
ruby sync_xcode_files.rb
```

## Next Steps

Once you've set up the sync system:
1. Create some test Swift files with Cursor
2. Run `./sync_xcode.sh` 
3. Open Xcode to verify files were added correctly
4. Integrate into your regular workflow

This eliminates the manual file management that was causing issues with your previous Claude Code sessions.