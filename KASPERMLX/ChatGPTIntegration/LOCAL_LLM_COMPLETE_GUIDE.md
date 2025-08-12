# 🤖 KASPER Local LLM Integration - Complete Guide

## 📖 What This Is

This is your **Local LLM integration** that lets VybeMVP generate spiritual insights using Mixtral (a 26GB AI model) running entirely on your M1 Max MacBook. No internet needed, no API costs, complete privacy!

### The System Has 3 Main Parts:

1. **Ollama** - The server that runs AI models locally (like Docker for LLMs)
2. **Mixtral** - The 26GB AI model that generates spiritual insights
3. **Shadow Mode** - A competition system that compares Mixtral vs your curated RuntimeBundle content

## 🚀 Quick Start (How to Use It)

### Step 1: Make Sure Ollama is Running
```bash
# Check if Ollama is running
ps aux | grep ollama

# If not running, start it:
ollama serve
```

### Step 2: Build and Run VybeMVP
```bash
# In Xcode:
1. Open VybeMVP.xcodeproj
2. Press Cmd+B to build
3. Press Cmd+R to run
```

### Step 3: Watch the Magic Happen!

When the app starts, look for these messages in Xcode console:
```
🤖 KASPER MLX: Initializing Local LLM provider for heavyweight competition
✅ Local LLM Provider ready - Server connection verified
🔧 Model info: Available models: mixtral:latest
🏠 Using Mixtral 8x7B for private, local spiritual AI insights
🌙 Initializing shadow mode for heavyweight competition
```

## 🎮 How to Test It

### Test the Daily Insight Feature

1. **Open the app** and go to the Home screen
2. **Tap "Generate Daily Insight"**
3. **Watch the console** for:
   ```
   🤖 Local LLM generating dailyCard insight: Focus 7, Realm 3
   🔥 Sending request to local LLM: mixtral
   ⚡️ Local inference completed in 4.82s
   📊 Quality score: 0.91 (A-)
   ```

### Understanding Shadow Mode

Right now, the app runs in **Shadow Mode**, which means:
- **Users see**: RuntimeBundle content (your proven quality content)
- **In background**: Mixtral generates competing insights
- **Competition logged**: Both are scored and compared

Look for competition results like:
```
🤖 COMPETITION ROUND:
   RuntimeBundle: 0.89 (B+)
   Local LLM: 0.91 (A-)
   Winner: Local LLM (margin: 0.02)
```

## 📁 Where Everything Lives

```
VybeMVP/
├── KASPERMLX/
│   └── ChatGPTIntegration/     # (Actually Local LLM now!)
│       ├── KASPERChatGPTProvider.swift    # Local LLM provider
│       ├── KASPERShadowModeManager.swift  # Competition system
│       ├── VybeChatGPTPromptSystem.swift  # Prompt engineering
│       ├── LocalLLMSetupGuide.md          # Technical setup
│       └── README.md                      # This file!
```

## 🔧 How It Actually Works

### 1. When You Generate an Insight

```swift
// This happens in HomeView.swift
generateDailyInsight()
    ↓
// Goes to KASPERMLXManager
generateInsightWithShadowMode()
    ↓
// Shadow Mode Manager runs both:
├── RuntimeBundle (shown to user)
└── Mixtral (evaluated in background)
    ↓
// Both get quality scores
// Winner is logged for analysis
```

### 2. The Local LLM Provider

- **Connects to**: `http://localhost:11434` (Ollama server)
- **Uses model**: `mixtral` (26GB model you downloaded)
- **Timeout**: 60 seconds (first run can be slow)
- **Retry logic**: Tries 2 times if quality is low

### 3. Quality Evaluation

Every insight is scored on:
- **Fidelity** (30%): Uses correct numerology numbers
- **Actionability** (25%): Provides practical steps
- **Tone** (25%): Warm, spiritual, not preachy
- **Safety** (20%): No absolute health/financial claims

## 🐛 Troubleshooting

### "Local LLM provider failed to initialize"

**Fix:**
```bash
# Make sure Ollama is running
ollama serve

# Check if model exists
ollama list
# Should show: mixtral:latest
```

### "Inference is really slow!"

**Normal for first run!** Mixtral takes time to load into memory:
- First inference: 10-20 seconds
- Subsequent: 3-8 seconds

### "App crashes or hangs"

**Check memory:**
```bash
# See if you're out of RAM
top -o mem
```
Mixtral uses ~45GB RAM. Close other apps if needed.

### "Quality scores are low"

This is why we have shadow mode! The system is learning. Low scores mean RuntimeBundle wins that round.

## 📊 Monitoring Performance

### Check Shadow Mode Status

In `KASPERMLXTestView` or console logs:
```
Shadow Mode Status:
- Phase: Shadow Testing
- Local LLM Win Rate: 45%  (Still learning!)
- Total Comparisons: 20
- Ready for Hybrid: false (needs 75% win rate)
```

### See What Mixtral Generated

Look for logs with the actual content:
```
✅ Local LLM insight generated successfully (289 chars)
Content: "As a Focus 7, you embody the seeker's path..."
```

## 🎯 What Happens Next?

### Current Phase: Shadow Mode
- Users see RuntimeBundle (safe, proven content)
- Mixtral learns in background
- No risk to user experience

### When Mixtral Wins 75%+ (Hybrid Mode)
- Users see whichever scores higher
- Best of both worlds!

### When Mixtral Wins 90%+ (Full Mode)
- Mixtral becomes primary
- RuntimeBundle as backup only

## 💡 Pro Tips

### Speed Up Inference
```bash
# Keep Ollama running always
ollama serve &

# Pre-load the model
curl -X POST http://localhost:11434/api/generate \
  -d '{"model": "mixtral", "prompt": "hello", "stream": false}'
```

### Monitor Ollama
```bash
# See Ollama logs
tail -f ~/.ollama/logs/server.log

# Check model info
ollama show mixtral
```

### Test Without App
```bash
# Quick test of Mixtral
curl -X POST http://localhost:11434/api/generate \
  -d '{
    "model": "mixtral",
    "prompt": "Give spiritual insight for number 7",
    "stream": false
  }' | jq -r '.response'
```

## 🆘 Need Help?

1. **Check Ollama is running**: `ps aux | grep ollama`
2. **Check model is loaded**: `ollama list`
3. **Check console logs** in Xcode for error messages
4. **Restart everything**:
   ```bash
   killall ollama
   ollama serve
   # Then rebuild app in Xcode
   ```

## 🎉 Success Checklist

✅ Ollama installed (`brew install ollama`)
✅ Mixtral downloaded (`ollama pull mixtral`)
✅ Server running (`ollama serve`)
✅ App builds without errors
✅ Console shows "Local LLM Provider ready"
✅ Shadow mode competition running
✅ Quality scores being logged

---

**Remember**: First run is always slow! Give it 10-20 seconds on first insight generation. After that, it'll be much faster (3-8 seconds).

**The Magic**: You now have a 26GB AI model running completely privately on your Mac, competing with your curated content to provide the best spiritual insights! No internet, no API costs, total privacy! 🚀
