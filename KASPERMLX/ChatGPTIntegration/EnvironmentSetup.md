# 🔧 ChatGPT Integration Environment Setup

## 🎯 Overview

This guide walks you through setting up the OpenAI API key for ChatGPT integration in the VybeMVP app. The ChatGPT provider enables the heavyweight competition between ChatGPT and RuntimeBundle for dynamic spiritual insights.

## 🚀 Quick Setup (Recommended)

### Option 1: Xcode Scheme Environment Variables

1. **Open Xcode Project**: Open `VybeMVP.xcworkspace` or `VybeMVP.xcodeproj`

2. **Edit Scheme**:
   - Select the VybeMVP target in the toolbar
   - Choose "Edit Scheme..." from the dropdown
   - Or press `Cmd + <` (Command + Less Than)

3. **Configure Environment**:
   - Select "Run" in the left sidebar
   - Click the "Arguments" tab
   - In the "Environment Variables" section, click the "+" button
   - Add:
     - **Name**: `OPENAI_API_KEY`
     - **Value**: `your-openai-api-key-here`

4. **Save**: Click "Close" to save the scheme

### Option 2: Xcode Build Settings

1. **Open Build Settings**:
   - Select the VybeMVP project in the navigator
   - Select the VybeMVP target
   - Click "Build Settings" tab

2. **Add User-Defined Setting**:
   - Scroll to the bottom or search for "User-Defined"
   - Click the "+" button to add a new setting
   - Set:
     - **Key**: `OPENAI_API_KEY`
     - **Value**: `your-openai-api-key-here`

3. **Update Code** (if using this option):
   ```swift
   // In KASPERMLXEngine.swift, replace:
   if let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"]

   // With:
   if let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String
   ```

## 🔑 Getting Your OpenAI API Key

1. **Create OpenAI Account**:
   - Visit [platform.openai.com](https://platform.openai.com)
   - Sign up or log in to your account

2. **Generate API Key**:
   - Navigate to "API Keys" in the dashboard
   - Click "Create new secret key"
   - Give it a descriptive name like "VybeMVP-ChatGPT"
   - Copy the generated key (starts with `sk-`)

3. **Set Usage Limits** (Recommended):
   - Go to "Usage limits" in your OpenAI dashboard
   - Set a monthly spending limit (e.g., $20-50)
   - This prevents unexpected charges

## 🧪 Testing the Integration

### 1. Verify API Key Setup

Add this test to your app (temporarily) to verify the key is accessible:

```swift
// Add to AppDelegate or ContentView onAppear
if let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] {
    print("✅ OpenAI API Key found: \(apiKey.prefix(7))...")
} else {
    print("❌ OpenAI API Key not found")
}
```

### 2. Check Shadow Mode Activation

Look for these log messages when the app starts:

```
🤖 KASPER MLX: Initializing ChatGPT provider for heavyweight competition
✅ Found OpenAI API key - initializing ChatGPT provider
✅ ChatGPT provider successfully added to KASPER
🌙 Initializing shadow mode for heavyweight competition
✅ Shadow mode initialized - ChatGPT vs RuntimeBundle competition active
```

### 3. Test Insight Generation

Generate a daily insight and look for:

```
🥊 Shadow mode: Generated insight via ChatGPT vs RuntimeBundle competition
🥊 Shadow mode result: 🤖 ChatGPT wins in shadow mode
📊 Quality score: 0.85 (B+)
```

## 🛡️ Security Best Practices

### 1. Never Commit API Keys

Add this to your `.gitignore` if you store keys in files:
```gitignore
# API Keys
*.env
apikeys.txt
secrets.plist
```

### 2. Environment Variables Only

✅ **DO**: Use environment variables in Xcode schemes
❌ **DON'T**: Hard-code keys in source files
❌ **DON'T**: Commit keys to version control

### 3. Team Development

For team development, share setup instructions rather than actual keys:

```markdown
# Team Setup
1. Get your own OpenAI API key from platform.openai.com
2. Add OPENAI_API_KEY to your local Xcode scheme
3. Never commit your personal API key
```

## 🚨 Troubleshooting

### Issue: "ChatGPT provider not available"

**Symptoms**: App logs show "ℹ️ No OpenAI API key found - ChatGPT provider disabled"

**Solutions**:
1. Verify the environment variable name is exactly `OPENAI_API_KEY`
2. Check that the scheme has the environment variable set
3. Restart Xcode after adding the variable
4. Ensure you're running the correct scheme

### Issue: "ChatGPT provider failed to initialize"

**Symptoms**: Provider times out during initialization

**Solutions**:
1. Check your internet connection
2. Verify the API key is valid (test at platform.openai.com)
3. Check OpenAI service status
4. Ensure you have API credits available

### Issue: Build errors with ChatGPT integration

**Symptoms**: Compilation fails with ChatGPT-related errors

**Solutions**:
1. Clean build folder (`Cmd + Shift + K`)
2. Check that all ChatGPT files are added to the Xcode project
3. Verify import statements are correct
4. Check target membership for new files

## 📊 Monitoring Usage

### 1. OpenAI Dashboard

Monitor your usage at [platform.openai.com/usage](https://platform.openai.com/usage):
- Daily API calls
- Token consumption
- Monthly spending

### 2. App Logs

The app logs detailed ChatGPT usage:
```
🤖 ChatGPT generating dailyCard insight: Focus 7, Realm 3
📊 Quality score: 0.88 (A-)
💰 Estimated tokens used: ~150
```

### 3. Shadow Mode Stats

Check shadow mode performance:
```swift
let stats = kasperMLX.getShadowModeStatus()
print("ChatGPT Win Rate: \(stats["stats.chatgpt_win_rate"])%")
print("Total Comparisons: \(stats["stats.total_comparisons"])")
```

## 🎯 Production Considerations

### 1. Rate Limiting

ChatGPT has rate limits. The app includes:
- Automatic retry logic
- Fallback to RuntimeBundle
- Request queuing

### 2. Cost Management

Typical costs for VybeMVP usage:
- **Daily Insight**: ~150 tokens (~$0.0002)
- **Journal Analysis**: ~300 tokens (~$0.0005)
- **Monthly Estimate**: $5-15 for active user

### 3. Quality Monitoring

The app automatically:
- Evaluates all ChatGPT responses
- Logs quality scores
- Falls back to RuntimeBundle for low-quality responses
- Tracks win rates for promotion decisions

## 🚀 Next Steps

Once setup is complete:

1. **Test Generation**: Generate several insights to verify operation
2. **Monitor Quality**: Check logs for quality scores and competition results
3. **Adjust Prompts**: Fine-tune prompts based on evaluation results
4. **Scale Testing**: Test with different personas and focus numbers

---

**Ready to Launch!** 🎊

Your ChatGPT integration is now configured for the heavyweight competition with RuntimeBundle. Users will receive the highest quality spiritual insights while we safely test dynamic content generation in shadow mode.
