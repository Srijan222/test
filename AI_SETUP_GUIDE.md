# 🤖 Configure AI Models in Lotti

## ⚠️ Issue: "No eligible models"

When trying to select an AI model in Lotti, you see no models available. This is because no AI providers have been configured yet.

---

## ✅ How to Add AI Providers

### Step 1: Open Settings in Lotti

In the running Lotti app:

1. Look for **Settings** in the navigation (usually in sidebar or menu)
2. Find **AI Settings** or **Integrations** section
3. You should see options for different AI providers

---

### Step 2: Choose Your AI Provider

Lotti supports **5 AI providers**:

| Provider | Models | Cost | Setup Difficulty |
|----------|--------|------|------------------|
| **OpenAI** | GPT-4, GPT-3.5 | Paid | Easy |
| **Anthropic** | Claude 3.5 Sonnet, Claude 3 Opus | Paid | Easy |
| **Google Gemini** | Gemini Pro, Gemini Flash | Free tier available | Easy |
| **Ollama** | Llama, Mistral (local) | Free | Medium |
| **Custom** | Any OpenAI-compatible API | Varies | Advanced |

**Recommendation**: Start with **Anthropic** (Claude) or **OpenAI** (GPT) for best results.

---

## 🔑 Get API Keys

### Option 1: Anthropic (Claude) - Recommended

1. **Create Account**:
   - Visit: https://console.anthropic.com/
   - Sign up for free

2. **Get API Key**:
   - Go to: https://console.anthropic.com/settings/keys
   - Click **"Create Key"**
   - Copy the key (starts with `sk-ant-...`)
   - **Save it securely** (you won't see it again)

3. **Pricing**:
   - $15 free credits for new accounts
   - Claude 3.5 Sonnet: ~$3 per million input tokens
   - Claude 3 Haiku: ~$0.25 per million tokens (cheap!)

4. **In Lotti**:
   - Go to Settings → AI Settings
   - Find **Anthropic** section
   - Paste your API key
   - Select model: **Claude 3.5 Sonnet** (recommended) or **Claude 3 Haiku** (faster/cheaper)
   - Save

---

### Option 2: OpenAI (GPT)

1. **Create Account**:
   - Visit: https://platform.openai.com/signup
   - Sign up

2. **Get API Key**:
   - Go to: https://platform.openai.com/api-keys
   - Click **"Create new secret key"**
   - Copy the key (starts with `sk-...`)
   - **Save it securely**

3. **Add Credits**:
   - OpenAI requires prepaid credits
   - Minimum: $5
   - Go to: https://platform.openai.com/settings/organization/billing/overview

4. **Pricing**:
   - GPT-4 Turbo: ~$10 per million input tokens
   - GPT-3.5 Turbo: ~$0.50 per million tokens (cheap!)

5. **In Lotti**:
   - Go to Settings → AI Settings
   - Find **OpenAI** section
   - Paste your API key
   - Select model: **GPT-4 Turbo** or **GPT-3.5 Turbo**
   - Save

---

### Option 3: Google Gemini (Free Tier)

1. **Create Account**:
   - Visit: https://makersuite.google.com/app/apikey
   - Sign in with Google account

2. **Get API Key**:
   - Click **"Create API Key"**
   - Copy the key

3. **Pricing**:
   - **Free tier**: 60 requests/minute
   - Great for testing!

4. **In Lotti**:
   - Settings → AI Settings → Gemini
   - Paste API key
   - Select: **Gemini 1.5 Pro** or **Gemini 1.5 Flash**
   - Save

---

### Option 4: Ollama (Local - Free, No Internet Required)

**Best for**: Privacy-conscious users, offline usage

1. **Install Ollama**:
   - Download: https://ollama.com/download/windows
   - Run installer
   - Ollama runs locally on your machine

2. **Download a Model**:
   ```bash
   # In PowerShell or Command Prompt
   ollama pull llama3.1:8b
   # Or for smaller/faster model:
   ollama pull mistral:7b
   ```

3. **In Lotti**:
   - Settings → AI Settings → Ollama
   - Base URL: `http://localhost:11434`
   - Model: `llama3.1:8b` (or whichever you pulled)
   - Save

**Pros**:
- ✅ Completely free
- ✅ Runs offline
- ✅ Private (data never leaves your machine)

**Cons**:
- ⚠️ Requires powerful hardware (8GB+ RAM)
- ⚠️ Slower than cloud APIs
- ⚠️ Quality depends on model size

---

## 🎯 After Adding API Key

### Step 3: Verify Model Selection

1. **Go back to AI model selection** in Lotti
2. You should now see models listed:
   - For Anthropic: Claude 3.5 Sonnet, Claude 3 Haiku, etc.
   - For OpenAI: GPT-4 Turbo, GPT-3.5 Turbo, etc.
   - For Gemini: Gemini 1.5 Pro, Gemini 1.5 Flash
   - For Ollama: Whatever models you pulled

3. **Select a model** from the dropdown
4. **Save/Apply** settings

---

## 🧪 Test Your AI Configuration

### Try AI Features in Lotti:

1. **AI Chat**:
   - Go to AI Chat section
   - Type a message
   - Should get a response from your chosen model

2. **AI-Assisted Journaling**:
   - Create a journal entry
   - Look for AI assistance features (autocomplete, suggestions, etc.)

3. **Audio Transcription** (if using Whisper):
   - Record audio
   - Should transcribe using configured model

---

## 💡 Recommended Setup

**For Best Experience**:

1. **Primary model**: Anthropic Claude 3.5 Sonnet
   - Best quality/cost ratio
   - Excellent at tasks, summarization, insights

2. **Fast/cheap model**: Claude 3 Haiku or GPT-3.5 Turbo
   - For quick tasks, autocomplete
   - Much cheaper

3. **Local/private**: Ollama with Llama 3.1
   - For sensitive data
   - Offline capability

**Configure multiple providers** so you can switch based on needs!

---

## 🔒 Security Note

**Keep API keys secure**:
- ✅ Lotti stores keys locally (not in cloud)
- ✅ Keys are encrypted with `flutter_secure_storage`
- ⚠️ Never commit keys to git
- ⚠️ Rotate keys if accidentally exposed

---

## 🐛 Troubleshooting

### Issue: "API key invalid"

**Check**:
- Key copied correctly (no extra spaces)
- Key has correct permissions
- Account has available credits (for paid APIs)

### Issue: "Rate limit exceeded"

**Solutions**:
- Wait a few minutes
- Upgrade to paid tier
- Switch to different provider
- Use Ollama (no rate limits)

### Issue: Ollama not connecting

**Check**:
```bash
# Verify Ollama is running
ollama list

# Test connection
curl http://localhost:11434/api/tags
```

If Ollama isn't running:
```bash
# Start Ollama service
ollama serve
```

---

## 📊 Cost Estimates

**Typical usage** (moderate journaling + AI chat):

| Provider | Monthly Cost |
|----------|--------------|
| Claude 3.5 Sonnet | $2-5 |
| Claude 3 Haiku | $0.50-1 |
| GPT-4 Turbo | $5-10 |
| GPT-3.5 Turbo | $1-2 |
| Gemini (free tier) | $0 |
| Ollama | $0 |

**For heavy users** (lots of transcription, long chats):
- Could be 2-3x higher
- Consider Ollama for cost-free option

---

## 🎯 Quick Start Checklist

- [ ] Choose AI provider (Anthropic recommended)
- [ ] Create account and get API key
- [ ] Open Lotti Settings → AI Settings
- [ ] Paste API key
- [ ] Select model
- [ ] Save settings
- [ ] Verify models appear in selection
- [ ] Test with AI chat or journal entry

---

## 🆘 Still Not Seeing Models?

**Try**:

1. **Restart Lotti**:
   - Press `q` to quit
   - Run `flutter run -d windows` again

2. **Check console for errors**:
   - Look for API-related errors in the terminal

3. **Verify settings saved**:
   - Close settings
   - Reopen to confirm key is still there

4. **Check internet connection**:
   - Cloud APIs need internet
   - Ollama works offline

---

**After configuring an API key, eligible models will appear!** ✅

**Recommended**: Start with **Anthropic Claude 3.5 Sonnet** - $15 free credits, excellent quality! 🤖
