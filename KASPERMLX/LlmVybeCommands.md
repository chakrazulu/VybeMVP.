# 🚀 Local LLM Quick Command Reference for VybeMVP

## 🎯 Essential Commands

### Start Local LLM Server (Required for Shadow Mode)
```bash
OLLAMA_HOST=0.0.0.0:11434 ollama serve
```
This makes Ollama listen on all network interfaces so your iPhone can connect.

## 📋 Complete Setup Steps

1. **Open Terminal**
2. **Run the command above**
3. **Keep terminal running** (don't close it)
4. **Run VybeMVP on your iPhone**
5. **Shadow mode auto-activates!**

## 🛠️ Useful Commands

### Check if Ollama is Running
```bash
ps aux | grep ollama
```

### Kill Existing Ollama Process
```bash
killall ollama
```

### List Available Models
```bash
ollama list
```

### Pull a New Model (if needed)
```bash
ollama pull mixtral:latest
```

### Test Ollama Connection
```bash
curl http://localhost:11434/api/tags
```

### Test from Another Device
```bash
curl http://192.168.1.159:11434/api/tags  # Replace with your Mac's IP
```

## 💡 Pro Tips

### Create a Shortcut Alias
Add to your `~/.zshrc` or `~/.bash_profile`:
```bash
alias vybe-llm="OLLAMA_HOST=0.0.0.0:11434 ollama serve"
```

Then just type:
```bash
vybe-llm
```

### Run in Background (Advanced)
```bash
nohup OLLAMA_HOST=0.0.0.0:11434 ollama serve > ollama.log 2>&1 &
```

### View Background Logs
```bash
tail -f ollama.log
```

### Stop Background Process
```bash
killall ollama
```

## 🔍 Verification & Success Indicators

### 1. Ollama Server Ready
In terminal you'll see:
```
time=2025-08-12T19:48:28.017-04:00 level=INFO msg="llama runner started in 20.11 seconds"
Listening on [::]:11434 (version 0.11.4)
```
**✅ This means Mixtral 46.7B model is loaded and ready!**

### 2. iPhone Successfully Connected
When VybeMVP app connects, terminal shows:
```
[GIN] 2025/08/12 - 20:17:05 | 200 | 3.362708ms | 192.168.1.154 | GET "/api/tags"
[GIN] 2025/08/12 - 20:17:05 | 200 | 639.583µs | 192.168.1.154 | GET "/api/tags"
```
**✅ This means your iPhone is successfully talking to Local LLM!**

### 3. Mixtral Generating Insights
During spiritual insight generation:
```
[GIN] 2025/08/12 - 19:48:43 | 200 | 35.248942083s | 192.168.1.154 | POST "/api/generate"
```
**✅ This is your Local LLM creating personalized spiritual insights!**

### 4. Xcode Console Success Logs
When shadow mode activates, look for:
```
🔧 Using configured Local LLM endpoint: http://192.168.1.159:11434
✅ Local LLM Provider ready - Server connection verified
🎉 Shadow mode successfully activated!
🥊 COMPETITION ROUND: Local LLM vs RuntimeBundle
🧠 Winner: Mixtral 46.7B (Local LLM)
```

### 5. App Visual Indicators
**In VybeMVP app, look for winner badges:**
- 🧠 **"Mixtral 46.7B"** = Local LLM won this insight
- ✨ **"Curated Content"** = RuntimeBundle won this insight

## 🎮 Quick Troubleshooting

### If You See "Address Already in Use"
```bash
Error: listen tcp 0.0.0.0:11434: bind: address already in use
```
**This is GOOD!** It means Ollama is already running. Your Local LLM is ready!

### If Connection Fails
1. **Check Ollama is running**: `ps aux | grep ollama`
2. **Check your Mac's IP**: `ipconfig getifaddr en0`
3. **Update IP in code** if it changed (currently: `192.168.1.159`)
4. **Ensure on same WiFi network**
5. **Allow network permission** on iPhone when prompted

### Terminal Management
- **Keep Ollama terminal open** - don't close the one running `vybe-llm`
- **Open new terminals** with `Cmd+T` (new tab) or `Cmd+N` (new window)
- **Use new terminals** for other commands while Ollama runs
- **400+ lines is NORMAL** - that's Ollama working hard! Look for the success patterns above
- **To clear terminal**: Type `clear` but you'll lose the log history

### If Generation is Slow
- **First generation**: Always slower (20-30s model loading)
- **Subsequent**: Should be faster (~35s for inference)
- **Check Activity Monitor**: Ensure enough RAM available
- **Metal GPU**: Should show high GPU usage during generation

## 📊 Performance Expectations

### Typical Timings
- **Model Load**: 20-30 seconds (first time)
- **Inference**: 35-40 seconds
- **Quality Evaluation**: 5-10ms
- **Total Round Trip**: ~40 seconds

### Resource Usage
- **RAM**: ~26GB for Mixtral
- **GPU**: 25.1GB Metal allocation
- **CPU**: Moderate during inference
- **Network**: Minimal (local only)

## 🔒 Security Notes

### Development Mode (Current)
```bash
OLLAMA_HOST=0.0.0.0:11434 ollama serve  # Open to network
```

### Production Mode (Future)
```bash
OLLAMA_HOST=127.0.0.1:11434 ollama serve  # Local only
# Use VPN or Tailscale for remote access
```

## 🌟 Shadow Mode Magic

When everything is working, you'll see in Xcode console:
```
✅ Local LLM provider created successfully for shadow mode
🥊 Using shadow mode for daily card generation!
🤖 COMPETITION ROUND:
   RuntimeBundle: 0.41 (F)
   Local LLM: 0.80 (B-)
   Winner: Local LLM
```

And in the app, look for the winner badge:
- 🧠 **Mixtral 46.7B** = Local LLM won
- ✨ **Curated Content** = RuntimeBundle won

## 🏆 What We've Achieved

### Historic Breakthrough: August 12, 2025
- **World's first iPhone app** with Local LLM shadow mode competition
- **46.7B parameter Mixtral model** running locally on M1 Max
- **Real-time AI competition** between Local LLM and curated content
- **Automatic quality evaluation** with winner selection
- **Complete privacy** - zero external API calls
- **A+ Architecture Implementation** - Secure configuration management

### Future Team Onboarding
When VybeMVP expands beyond solo development:
1. **Each developer** gets their own `192.168.x.x` IP configuration
2. **Production deployment** uses secure localhost-only configuration
3. **CI/CD pipelines** automatically disable Local LLM for testing
4. **Enterprise monitoring** tracks Local LLM vs cloud performance

### Competition Results (First Victory)
```
🤖 COMPETITION ROUND:
   RuntimeBundle: 0.41 (F)
   Local LLM: 0.80 (B-)
   Winner: Local LLM (margin: 0.39)
```

### Visual Indicators in App
- 🧠 **"Mixtral 46.7B"** (cyan) = Local LLM won
- ✨ **"Curated Content"** (purple) = RuntimeBundle won

---

**Remember**: Keep the terminal with `OLLAMA_HOST=0.0.0.0:11434 ollama serve` running while using the app!

*Last Updated: August 12, 2025 - Shadow Mode Victory Day!*
*Historic Achievement: World's First Local LLM Shadow Mode on iPhone*
