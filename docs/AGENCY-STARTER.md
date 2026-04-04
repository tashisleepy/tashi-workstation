# AI Agency Starter Kit

Everyone in the AI world knows what can be achieved. Everyone knows what's possible. But not many are making money.

The gap isn't knowledge. It's tooling.

We're leaking our basic stack — compiled from various open-source projects — which is a must for any agency to start the basic work and get paid. Our advanced stack has proprietary tools built over years of enterprise deployment worth INR 50Cr+. That stays private. But this? This is for the young founders.

This starter kit helps you market yourself for basic things and still make some money. Shipping is not equal to making money — and we want to help founders bridge that gap.

---

## What You Actually Need to Get Paid

Not a wishlist. Not a tutorial. These are the tools that let a solo founder deliver work that looks like a 10-person team built it.

| What Clients Pay For | Tool That Delivers It | Cost |
|---------------------|----------------------|------|
| "Build me an app" | Claude Code + /autopilot + /ralph (32 agents) | Free |
| "Redesign our website" | Design systems (54 brands — Stripe, Apple, Vercel) | Free |
| "Create a pitch deck" | clean-slides + Instrumenta (McKinsey quality) | Free |
| "Write us a proposal" | sales-proposal-strategist agent | Free |
| "Audit our security" | Trail of Bits security skills (6 tools) | Free |
| "Run our social media" | X/Twitter automation (10 skills) | Free |
| "Make us a video" | FFmpeg + Voxtral TTS (free voiceovers) | Free |
| "Give us a market report" | python-docx templates + council decision engine | Free |
| "We need an AI strategy" | /council + /deep-interview + analyst agent | Free |

**Total cost to deliver all of the above: $0.**

---

## The Stack

### Layer 1: Your AI Team (32 Agents)

These are specialists that live inside Claude Code. Call one by name and it switches into expert mode.

**Install (5 minutes):**

```bash
# 19 engineering agents + 31 core skills
npm i -g oh-my-claude-sisyphus@latest
omc setup

# 12 marketing/sales/design/product agents
git clone --depth 1 https://github.com/msitarzewski/agency-agents.git /tmp/aa
for a in marketing/marketing-seo-specialist.md marketing/marketing-twitter-engager.md \
  marketing/marketing-linkedin-content-creator.md marketing/marketing-content-creator.md \
  design/design-image-prompt-engineer.md design/design-brand-guardian.md \
  sales/sales-proposal-strategist.md sales/sales-discovery-coach.md \
  product/product-manager.md product/product-trend-researcher.md \
  engineering/engineering-ai-engineer.md engineering/engineering-software-architect.md; do
  cp "/tmp/aa/$a" ~/.claude/agents/ 2>/dev/null
done && rm -rf /tmp/aa
```

**Agents that directly make you money:**

| Agent | How It Pays |
|-------|------------|
| sales-proposal-strategist | Write proposals that win contracts |
| sales-discovery-coach | Ask questions that uncover what clients actually need |
| architect | Design systems clients can't build themselves |
| executor | Ship the code |
| marketing-seo-specialist | Deliver SEO as a service |
| design-brand-guardian | Keep client brands consistent across deliverables |

### Layer 2: Workflow Automation (57 Skills)

One command triggers an entire delivery pipeline.

**Install (10 minutes):**

```bash
# Media generation (9 skills)
git clone --depth 1 https://github.com/SamurAIGPT/Generative-Media-Skills.git /tmp/gms
for d in /tmp/gms/library/*/; do for s in "$d"*/; do
  [ -f "$s/SKILL.md" ] && mkdir -p ~/.claude/commands/"$(basename "$s")" && \
  cp "$s/SKILL.md" ~/.claude/commands/"$(basename "$s")"/
done; done
for d in /tmp/gms/core/*/; do [ -f "$d/SKILL.md" ] && \
  mkdir -p ~/.claude/commands/"media-$(basename "$d")" && \
  cp "$d/SKILL.md" ~/.claude/commands/"media-$(basename "$d")"/
done && rm -rf /tmp/gms

# X/Twitter automation (10 skills)
git clone --depth 1 https://github.com/nirholas/XActions.git /tmp/xa
for s in content-posting viral-thread-generation analytics-insights engagement-interaction \
  competitor-intelligence growth-automation follower-monitoring twitter-scraping \
  discovery-explore profile-management; do
  [ -f "/tmp/xa/skills/$s/SKILL.md" ] && mkdir -p ~/.claude/commands/"x-$s" && \
  cp "/tmp/xa/skills/$s/SKILL.md" ~/.claude/commands/"x-$s"/
done && rm -rf /tmp/xa

# Security audit (6 skills)
git clone --depth 1 https://github.com/trailofbits/skills.git /tmp/tob
for s in audit-context-building entry-point-analyzer semgrep-rule-creator \
  seatbelt-sandboxer zeroize-audit audit-augmentation; do
  p=$(find /tmp/tob -path "*/$s/SKILL.md" | head -1)
  [ -n "$p" ] && mkdir -p ~/.claude/commands/"sec-$s" && cp "$p" ~/.claude/commands/"sec-$s"/
done && rm -rf /tmp/tob
```

**Skills that directly make you money:**

| Skill | Command | Revenue Use Case |
|-------|---------|-----------------|
| Autopilot | `/autopilot` | Client says "build this" — you type one command |
| Ralph | `/ralph` | "Keep going until the tests pass" — zero babysitting |
| Deep Interview | `/deep-interview` | Turn vague client brief into real spec in 10 minutes |
| Council | `/council` | Pressure-test pricing, positioning, strategy decisions |
| Security Audit | `/sec-audit-context-building` | Offer code audits as a service (clients pay well for this) |
| Viral Thread | `/x-viral-thread-generation` | Your agency marketing — attract inbound leads |

### Layer 3: Local AI (Zero API Costs)

Every API call you don't make is profit margin.

```bash
brew install ollama && brew services start ollama
ollama pull qwen3-coder:30b    # 18GB coding model
ollama pull qwen3.5:9b         # 6.6GB fast model
```

Access through a ChatGPT-like interface (needs Docker):

```bash
docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway \
  --name open-webui --restart always ghcr.io/open-webui/open-webui:main
# Open http://localhost:3000
```

### Layer 4: Client Deliverables

**McKinsey-style slide deck from YAML:**

```bash
git clone --depth 1 https://github.com/tmustier/clean-slides.git /tmp/cs && \
cd /tmp/cs && pip3 install --break-system-packages -e . && cd - && pptx init
```

**PowerPoint toolbar (270+ consulting tools):**

```bash
curl -L -o ~/Downloads/Instrumenta.ppam \
  https://github.com/iappyx/Instrumenta/releases/download/1.66/InstrumentaPowerpointToolbar.ppam
# macOS: copy to ~/Library/Group Containers/UBF8T346G9.Office/User Content/Add-Ins/
# Then: PowerPoint → Tools → Add-ins → enable
```

**Branded reports and decks from code:**

```bash
npm install pptxgenjs docx
pip3 install --break-system-packages python-pptx python-docx
```

### Layer 5: Video Production + Free Voiceovers

```bash
# Merge clips
ffmpeg -i clip1.mp4 -i clip2.mp4 -filter_complex \
  "[0:v][1:v]xfade=transition=fade:duration=0.3:offset=4.7[v]" -map "[v]" output.mp4

# Free voiceover (Mistral API — sign up at console.mistral.ai, no credit card)
curl -s -X POST "https://api.mistral.ai/v1/audio/speech" \
  -H "Authorization: Bearer YOUR_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"voxtral-mini-tts-2603","input":"Your text","voice":"gb_oliver_neutral","response_format":"wav"}' \
  | python3 -c "import sys,json,base64; open('vo.wav','wb').write(base64.b64decode(json.load(sys.stdin)['audio_data']))"

# Add voiceover to video
ffmpeg -i video.mp4 -i vo.wav -map 0:v -map 1:a -c:v copy -c:a aac -shortest final.mp4
```

### Layer 6: Design Systems (54 Brands)

One file makes Claude output pixel-perfect branded UI.

```bash
git clone --depth 1 https://github.com/VoltAgent/awesome-design-md.git ~/design-systems

# Copy the brand you want into your project root
cp ~/design-systems/design-md/stripe/DESIGN.md ./DESIGN.md
```

Apple, Stripe, Vercel, Notion, Airbnb, Spotify, SpaceX, BMW, Figma, Uber, and 44 more.

---

## What You Can Charge

| Deliverable | What It Takes | Realistic Price |
|-------------|--------------|-----------------|
| Landing page | executor + design system + 2 hours | $500–2,000 |
| Pitch deck | clean-slides + Instrumenta + 1 hour | $300–1,500 |
| Client proposal | sales-proposal-strategist + 30 min | Part of your sales process |
| Social media package | X/Twitter skills + 1 hour/week | $500–2,000/month |
| Security audit | sec-audit + report template + 3 hours | $1,000–5,000 |
| Full web app | /autopilot + /ralph + 1-2 days | $3,000–15,000 |
| Product video | FFmpeg + Voxtral TTS + 1 hour | $200–1,000 |
| Market research report | council + python-docx + 2 hours | $500–3,000 |

The tools are free. Your time and judgment is what clients pay for.

---

## One-Command Install (Everything)

```bash
npm i -g oh-my-claude-sisyphus@latest && omc setup && \
git clone --depth 1 https://github.com/msitarzewski/agency-agents.git /tmp/aa && \
for a in marketing/marketing-seo-specialist.md marketing/marketing-twitter-engager.md \
  marketing/marketing-linkedin-content-creator.md marketing/marketing-content-creator.md \
  design/design-image-prompt-engineer.md design/design-brand-guardian.md \
  sales/sales-proposal-strategist.md sales/sales-discovery-coach.md \
  product/product-manager.md product/product-trend-researcher.md \
  engineering/engineering-ai-engineer.md engineering/engineering-software-architect.md; do
  cp "/tmp/aa/$a" ~/.claude/agents/ 2>/dev/null; done && rm -rf /tmp/aa && \
brew install ollama && brew services start ollama && \
ollama pull qwen3-coder:30b && ollama pull qwen3.5:9b && \
npm install -g pptxgenjs docx && \
pip3 install --break-system-packages python-pptx python-docx && \
git clone --depth 1 https://github.com/VoltAgent/awesome-design-md.git ~/design-systems && \
echo "Done. 32 agents. 57 skills. Local AI. Design systems. Go get paid."
```

---

## Credits

Built on open-source projects by: [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode), [agency-agents](https://github.com/msitarzewski/agency-agents), [Generative-Media-Skills](https://github.com/SamurAIGPT/Generative-Media-Skills), [XActions](https://github.com/nirholas/XActions), [Trail of Bits](https://github.com/trailofbits/skills), [clean-slides](https://github.com/tmustier/clean-slides), [Instrumenta](https://github.com/iappyx/Instrumenta), [Open WebUI](https://github.com/open-webui/open-webui), [Ollama](https://ollama.com), [awesome-design-md](https://github.com/VoltAgent/awesome-design-md), [Voxtral TTS](https://mistral.ai/news/voxtral-tts).

---

*The tools are free. Your expertise is what clients pay for. This kit just makes sure you can deliver.*
