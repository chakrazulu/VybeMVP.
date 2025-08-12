# 🧪 Shadow Mode Testing Guide

## Quick Test Checklist

### Before You Start
- [ ] Ollama is running: `ollama serve`
- [ ] Mixtral is installed: `ollama list` (should show mixtral:latest)
- [ ] Xcode project builds: `Cmd+B`

## Test 1: Basic Connection Test

### In Terminal:
```bash
# Test Ollama API
curl http://localhost:11434/api/tags

# Should return JSON with models list including mixtral
```

## Test 2: App Integration Test

### In Xcode:
1. **Run the app** (`Cmd+R`)
2. **Open console** (`Cmd+Shift+Y`)
3. **Look for these startup messages:**

```
🤖 KASPER MLX: Initializing Local LLM provider for heavyweight competition
✅ Local LLM Provider ready - Server connection verified
🔧 Model info: Available models: mixtral:latest
✅ Local LLM provider successfully added to KASPER
🏠 Using Mixtral 8x7B for private, local spiritual AI insights
🌙 Initializing shadow mode for heavyweight competition
```

✅ **Success**: All messages appear
❌ **Failure**: Missing messages = check Ollama is running

## Test 3: Shadow Mode Competition

### In the App:
1. **Navigate to Home screen**
2. **Generate a daily insight**
3. **Watch console for competition:**

```
🥊 Shadow mode competition: dailyCard F7 R3
🤖 Local LLM generating dailyCard insight: Focus 7, Realm 3
🔥 Sending request to local LLM: mixtral
⚡️ Local inference completed in 4.82s
📊 Quality score: 0.91 (A-)
🤖 COMPETITION ROUND:
   RuntimeBundle: 0.89 (B+)
   Local LLM: 0.91 (A-)
   Winner: Local LLM (margin: 0.02)
```

### What You're Seeing:
- **F7 R3** = Focus number 7, Realm number 3
- **Two insights generated** = RuntimeBundle + Mixtral
- **Quality scores** = How well each performed
- **Winner** = Higher quality score wins

## Test 4: Performance Monitoring

### First Run (Cold Start):
```
⚡️ Local inference completed in 15.32s  // Normal - model loading
```

### Subsequent Runs (Warm):
```
⚡️ Local inference completed in 4.82s   // Much faster!
```

## Test 5: Manual API Test

### Test Mixtral Directly:
```bash
curl -X POST http://localhost:11434/api/generate \
  -d '{
    "model": "mixtral",
    "prompt": "As a spiritual Oracle, provide insight for someone with Focus Number 7 exploring Realm 3. Keep it under 100 words.",
    "stream": false,
    "options": {
      "temperature": 0.7,
      "top_p": 0.9
    }
  }' | jq -r '.response'
```

**Expected**: Spiritual insight mentioning number 7 and realm 3

## Debugging Commands

### Check What's Running:
```bash
# Is Ollama running?
ps aux | grep ollama

# What models are loaded?
ollama list

# Check Ollama logs
tail -f ~/.ollama/logs/server.log
```

### Force Restart:
```bash
# Kill everything
killall ollama

# Start fresh
ollama serve

# Rebuild app in Xcode
```

## Expected Behaviors

### ✅ Working Correctly:
- First inference: 10-20 seconds
- Subsequent: 3-8 seconds
- Quality scores: 0.70-0.95 range
- Both providers generate content
- Winner is logged

### ⚠️ Common Issues:
- **"Provider not ready"** → Ollama not running
- **Timeout errors** → First run, give it 30 seconds
- **Low quality scores** → Normal, Mixtral is learning
- **RuntimeBundle always wins** → Expected initially

## Shadow Mode Phases

### Current: Shadow Mode
- Users see: RuntimeBundle only
- Background: Mixtral generates and competes
- Risk: None to users

### Future: Hybrid Mode (75% win rate)
- Users see: Best quality insight
- Requires: Mixtral winning consistently

### Ultimate: Full Mode (90% win rate)
- Users see: Mixtral primarily
- Fallback: RuntimeBundle if needed

## Quick Status Check

In the app console, look for periodic status updates:
```
📊 SHADOW MODE STATUS:
   Total Comparisons: 25
   Local LLM Wins: 12 (48.0%)
   RuntimeBundle Wins: 13 (52.0%)
   Avg Local LLM Score: 0.84
   Avg RuntimeBundle Score: 0.86
```

**Interpretation:**
- Mixtral winning 48% = Getting close to competitive!
- Need 75% for hybrid mode
- This is excellent for a general model vs curated content

---

## 🎯 Success Metrics

After 10 test runs, you should see:
- [ ] All inferences complete without timeout
- [ ] Inference time decreasing (warm cache)
- [ ] Quality scores above 0.70
- [ ] Some rounds where Mixtral wins
- [ ] No crashes or hangs

**Remember**: Mixtral is a general AI competing with your hand-crafted spiritual content. Even 40-50% win rate is impressive!
