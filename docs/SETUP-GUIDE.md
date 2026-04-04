# Tashi AI Stack — Complete Setup Guide

Everything installed on 2026-04-01. All free. All working.

---

## 1. oh-my-claudecode (Multi-Agent Orchestration)

**What:** 32 specialized AI agents + 31 skills that turn Claude Code into a full engineering team.

**Where:** `~/.claude/agents/` (32 agents) + `~/.claude/commands/` (31 skills)

**How to use:**
```bash
# Start Claude Code, then use these commands:
/autopilot build a REST API for task management    # Full autonomous build
/ralph fix all TypeScript errors                    # Persistent loop until done
/team 3:executor "refactor the auth module"         # 3 parallel agents
/deep-interview "I want to build a food scanner"    # Socratic requirements first
/ultrawork fix all lint errors                      # Maximum parallelism
/ai-slop-cleaner                                    # Clean AI-generated code
/cancel                                             # Stop any active mode
```

**Key agents available:**
- analyst, architect, executor, debugger, planner, verifier (engineering)
- marketing-twitter-engager, marketing-seo-specialist, marketing-linkedin-content-creator (marketing)
- sales-proposal-strategist, sales-discovery-coach (sales)
- product-manager, product-trend-researcher (product)
- design-brand-guardian, design-image-prompt-engineer (design)
- engineering-ai-engineer, engineering-software-architect (engineering)
- kling (your custom video director V2.2)

---

## 2. Instrumenta (PowerPoint Toolbar)

**What:** 270+ McKinsey/BCG/Bain formatting tools for PowerPoint.

**Where:** Already installed in PowerPoint add-ins directory.

**How to activate:**
1. Open PowerPoint
2. Go to Tools → PowerPoint Add-ins
3. Click + and select `InstrumentaPowerpointToolbar.ppam`
4. Instrumenta tab appears in ribbon

**What you get:** Perfect alignment, table optimization, Harvey Balls, traffic lights, RAG indicators, bulk formatting, pyramid storyline builder.

---

## 3. Ollama + Qwen (Local AI)

**What:** Free local coding AI. Runs 100% offline on your Mac. Zero cost.

**Where:** Ollama runs as background service. Models in `~/.ollama/models/`

**Models installed:**

| Model | Size | Command |
|-------|------|---------|
| qwen3-coder:30b | 18 GB | `ollama run qwen3-coder:30b` |
| qwen3.5:9b | 6.6 GB | `ollama run qwen3.5:9b` |

**How to use:**
```bash
# Interactive coding session
ollama run qwen3-coder:30b

# API call from scripts
curl -s http://localhost:11434/api/generate \
  -d '{"model":"qwen3-coder:30b","prompt":"Write a fibonacci function","stream":false}'

# Check running models
curl -s http://localhost:11434/api/ps

# List all models
ollama list
```

**Service management:**
```bash
brew services start ollama    # Start (auto-starts on login)
brew services stop ollama     # Stop
```

**Security:** Listens on localhost:11434 only. Not exposed to network. GGUF format = inert weight data, no executable code.

---

## 4. clean-slides (YAML → McKinsey PPTX)

**What:** Write YAML, get consulting-grade PowerPoint slides.

**Where:** Installed globally. Config in `.clean-slides/` directory.

**How to use:**
```bash
# Create a YAML spec
cat > slide.yaml << 'EOF'
title: Market Overview
subtitle: Key competitors and positioning

table:
  rows: 3
  cols: 3
  has_col_header: true
  has_row_header: true
  col_headers: ["Revenue", "Strength", "Weakness"]
  col_header_color: accent1
  row_headers:
    - "Company A"
    - "Company B"
    - "Company C"
  cells:
    - ["$50M", "Market leader", "Slow iteration"]
    - ["$12M", "Strong tech", "Limited sales"]
    - ["$3M", "Low cost", "Early stage"]
EOF

# Generate slide
pptx generate slide.yaml -o output.pptx

# Open it
open output.pptx
```

**Other commands:**
```bash
pptx list deck.pptx              # List slides
pptx summary deck.pptx 1         # Summarize slide 1
pptx merge deck1.pptx deck2.pptx -o combined.pptx  # Merge decks
pptx init -t template.pptx       # Use custom template
```

---

## 5. Document Generators (PPT + Word)

**What:** Generate branded PowerPoint decks and Word reports from code or data.

**Where:** `~/tashi-workspace/ai-office-automation/scripts/`

### PowerPoint

**JavaScript (quick):**
```bash
cd ~/tashi-workspace/ai-office-automation
node --input-type=module < scripts/create-deck.mjs
# Output: output-deck.pptx
```

**Python (data-driven):**
```bash
python3 scripts/pptx-template.py
python3 scripts/pptx-template.py --output client-deck.pptx
```

### Word

**JavaScript (quick):**
```bash
node scripts/create-report.cjs
# Output: output-report.docx
```

**Python (data-driven):**
```bash
python3 scripts/docx-template.py
python3 scripts/docx-template.py --output client-report.docx
```

**Customization:** Edit the `BRAND` dict at the top of any script to change colors, fonts, and styling globally.

---

## 6. Telegram Bot (Notifications + Log)

**What:** Get pinged on Telegram when Claude Code finishes tasks. All notifications logged locally.

**Bot:** @tashisleepy_ai_bot

**How to use:**
```bash
# Send a notification from any terminal
tashi-notify "Deployment complete"
tashi-notify "Forensic report ready for review"
```

**View notification history:**
```bash
cat ~/.omc/notification-log.md
```

**Where config lives:**
- Bot config: `~/.omc/notifications.json`
- Notification log: `~/.omc/notification-log.md`
- Notify script: `/usr/local/bin/tashi-notify`

---

## 7. GitHub Repos

| Repo | URL | Visibility |
|------|-----|-----------|
| ai-engineering-stack | github.com/tashisleepy/ai-engineering-stack | Public |
| ai-office-automation | github.com/tashisleepy/ai-office-automation | Public |

**ai-engineering-stack** — 4 public agents (content, image, video, music) + content pipeline workflow + model routing config.

**ai-office-automation** — PPT/Word generators + Ollama/Qwen setup + Instrumenta guide + clean-slides guide + QUICKSTART.md with all copy-paste commands.

---

## 8. GitHub CLI

**What:** Authenticated GitHub access from terminal.

```bash
gh repo list              # Your repos
gh pr list                # Pull requests
gh issue list             # Issues
gh repo create name       # Create new repo
```

---

## 9. Microsoft 365

**What:** PowerPoint + Word + Excel + 1TB OneDrive + Copilot.

**Installed apps:** PowerPoint, Word, Excel.

---

## Quick Reference — All Commands

```bash
# oh-my-claudecode
/autopilot ...            # Full autonomous build
/ralph ...                # Persistent until done
/team N:executor "..."    # N parallel agents
/deep-interview "..."     # Socratic requirements

# Local AI
ollama run qwen3-coder:30b   # Coding AI
ollama list                   # See models

# Document generation
pptx generate spec.yaml -o deck.pptx           # YAML → McKinsey slide
python3 ~/tashi-workspace/ai-office-automation/scripts/pptx-template.py   # Branded deck
python3 ~/tashi-workspace/ai-office-automation/scripts/docx-template.py   # Branded report

# Notifications
tashi-notify "Your message"       # Ping Telegram
cat ~/.omc/notification-log.md    # View history

# GitHub
gh repo create name --public      # New repo
gh pr create --title "..."        # New PR
```

---

## File Locations

| What | Where |
|------|-------|
| Agents | `~/.claude/agents/` (32 files) |
| Skills | `~/.claude/commands/` (31 folders) |
| Claude Code settings | `~/.claude/settings.json` |
| Ollama models | `~/.ollama/models/` |
| OMC config | `~/.omc/` |
| Telegram config | `~/.omc/notifications.json` |
| Notification log | `~/.omc/notification-log.md` |
| clean-slides config | `.clean-slides/` (in project dir) |
| Instrumenta add-in | `~/Library/Group Containers/UBF8T346G9.Office/User Content/Add-Ins/` |
| Document scripts | `~/tashi-workspace/ai-office-automation/scripts/` |
| HUD statusline | `~/.claude/hud/omc-hud.mjs` |
| Notify script | `/usr/local/bin/tashi-notify` |

---

## What's Private (Your IP — NOT Public)

- All 25 Claude Projects (Numerology Queen, IFVG+CRT, Suno Master Pro, etc.)
- Brain files and research methodology
- Trading strategy (IFVG Turtle Soup + numerology calendar)
- Forensic teardown process
- Pitch deck methodology
- Amazon A+ Luxe system
- Client-specific work

## Pending (Next Session)

- openclaw (personal AI assistant on WhatsApp/Telegram/Slack)
- n8n workflow templates
- Claude Projects review (which to showcase publicly)
