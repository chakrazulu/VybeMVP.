# 🚀 Local LLM Quick Start Guide

## ⚡ **Quick Commands (Copy & Paste)**

### 1. Start Local LLM Server
```bash
OLLAMA_HOST=0.0.0.0:11434 ollama serve
```
**What it does:** Starts Mixtral 46.7B model accessible from iPhone

### 2. Check if Running
```bash
curl http://localhost:11434/api/tags
```
**What it does:** Confirms Ollama is responding

### 3. Stop LLM Server
```bash
killall ollama
```
**What it does:** Stops Ollama completely

## 📱 **App Behavior**

| Device Type | Connects To | Why |
|-------------|-------------|-----|
| **iPhone (Real Device)** | `192.168.1.159:11434` | Your Mac's network IP |
| **iOS Simulator** | `localhost:11434` | Same machine |
| **Production** | `localhost:11434` | Security |

## 🔍 **Success Indicators**

**In Xcode Console - Look for:**
```
🔧 Using configured Local LLM endpoint: http://192.168.1.159:11434
✅ Local LLM Provider ready - Server connection verified
🎉 Shadow mode successfully activated!
```

**In Terminal - Look for:**
```
[GIN] 2025/08/12 - 20:17:05 | 200 | GET "/api/tags"
time=2025-08-12T19:48:28.017 level=INFO msg="llama runner started"
```

## 🛠️ **Troubleshooting**

### "Connection refused" in Xcode logs
1. ✅ Check terminal: Is `OLLAMA_HOST=0.0.0.0:11434 ollama serve` running?
2. ✅ Check network: Are iPhone and Mac on same WiFi?
3. ✅ Kill and restart: `killall ollama` then restart with command above

### Shadow Mode Not Activating
1. ✅ Wait 30 seconds after app launch (model loading takes time)
2. ✅ Check Ollama terminal for model loading messages
3. ✅ Restart app if needed

## 📋 **Daily Workflow**

1. **Open Terminal** → Run `OLLAMA_HOST=0.0.0.0:11434 ollama serve`
2. **Wait for** → "Listening on [::]:11434" message
3. **Build & Run** → VybeMVP app on iPhone
4. **Look for** → Shadow mode success logs

## 🔒 **Security Notes**

- ✅ Network IP (192.168.1.159) is LOCAL NETWORK ONLY
- ✅ No internet exposure - only works on your home WiFi
- ✅ Production builds automatically use localhost
- ✅ All inference happens locally on your Mac

## 💡 **Pro Tips**

- **Alias Command:** Add to `~/.zshrc`: `alias vybe-llm="OLLAMA_HOST=0.0.0.0:11434 ollama serve"`
- **Terminal Tab:** Keep dedicated terminal tab for Ollama
- **Model Loading:** First startup takes ~20 seconds (46.7B parameters!)
- **Memory Usage:** Uses ~26GB of your Mac's GPU memory

---

*Keep this file - it's safe to reference and contains no secrets!*
