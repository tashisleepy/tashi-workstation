# Tashi Workstation

Complete AI engineering workstation. One script installs everything from zero: 32 AI agents, 57 skills (including a custom 5-advisor decision council), 2 local AI models, ChatGPT-like web UI, video editing pipeline, metadata cleaner, Telegram notifications, McKinsey slide generator, and document automation.

Built for Mac.

---

## Starting an AI Agency?

Everyone in the AI world knows what can be achieved. Not many are making money.

We're leaking our basic stack compiled from various open-source sources, which is a must for any agency to start the basic work and get paid. Our advanced stack has proprietary tools built over years of enterprise deployment. That stays private. But this is for the young founders.

**[Read the Agency Starter Kit →](docs/AGENCY-STARTER.md)**

Includes: what clients pay for, which tools deliver it, pricing guide ($500-15K per deliverable), and a one-command install that sets up everything.

*The tools are free. Your expertise is what clients pay for. This kit helps you bridge the gap between shipping and getting paid.*

---

## What Gets Installed

| Tool | What It Does | Size |
|------|-------------|------|
| **oh-my-claudecode** | 32-agent orchestration for Claude Code | ~50 MB |
| **Agency Agents** | 12 cherry-picked marketing/sales/design/engineering agents | ~1 MB |
| **Generative Media Skills** | AI image/video/music generation inside Claude Code | ~1 MB |
| **XActions** | X/Twitter automation — posting, analytics, growth, scraping | ~1 MB |
| **Trail of Bits Security** | 6 security audit skills (code analysis, vulnerability detection) | ~1 MB |
| **Ollama + Qwen** | Local AI (qwen3-coder:30b + qwen3.5:9b) | ~25 GB |
| **Open WebUI** | ChatGPT-like browser UI for your local AI models | Docker |
| **clean-slides** | YAML to McKinsey-style PowerPoint slides | ~10 MB |
| **Instrumenta** | 270+ consulting formatting tools for PowerPoint | ~1 MB |
| **FFmpeg + Remotion** | Video editing — merge clips, transitions, animations, metadata | Installed |
| **Telegram Bot** | Phone notifications when tasks complete + local log | Config only |
| **Document Generators** | Auto-create branded PPT and Word files (JS + Python) | ~5 MB |

## One-Command Setup

```bash
git clone https://github.com/tashisleepy/tashi-workstation.git
cd tashi-workstation
chmod +x scripts/*.sh
./scripts/setup-all.sh
```

## Individual Setup Scripts

```bash
./scripts/setup-all.sh                          # Everything
./scripts/setup-telegram.sh <TOKEN> <CHAT_ID>   # Telegram notifications
./scripts/setup-instrumenta.sh                   # PowerPoint toolbar
./scripts/setup-open-webui.sh                    # ChatGPT-like UI
./scripts/clean-metadata.sh input.mp4            # Strip metadata + inject iPhone tags
./scripts/merge-clips.sh out.mp4 clip1 clip2     # Merge video clips
```

## After Setup

```bash
# Claude Code agents
/autopilot build a REST API                    # Full autonomous build
/ralph fix all errors                          # Persistent until done
/team 3:executor "refactor auth"               # 3 parallel agents
/deep-interview "build a scanner"              # Socratic requirements

# Local AI
ollama run qwen3-coder:30b                     # Local coding AI
open http://localhost:3000                     # ChatGPT-like web UI

# Documents
pptx generate spec.yaml -o deck.pptx          # YAML to McKinsey slide
python3 scripts/pptx-template.py               # Branded deck from data
python3 scripts/docx-template.py               # Branded report from data

# Video
./scripts/merge-clips.sh final.mp4 clip1.mp4 clip2.mp4 clip3.mp4
./scripts/merge-clips.sh final.mp4 --transition fade --music bgm.mp3 clip1.mp4 clip2.mp4
./scripts/clean-metadata.sh video.mp4          # iPhone 17 Pro Max + Dubai Marina tags

# Notifications
tashi-notify "Task complete"                   # Ping Telegram
cat ~/.omc/notification-log.md                 # View history
```

## Component Breakdown

### Agents (32)

| Source | Count | Type |
|--------|-------|------|
| oh-my-claudecode | 19 | Engineering (architect, executor, debugger, planner, etc.) |
| agency-agents | 12 | Marketing, sales, design, product, engineering |
| Custom | 1 | Video director (Kling 3.0, 72 situations) |

Full list: [configs/agents-list.md](configs/agents-list.md)

### Skills (56)

| Source | Count | Type |
|--------|-------|------|
| oh-my-claudecode | 31 | Orchestration (autopilot, ralph, team, etc.) |
| Custom | 1 | Council — 5-advisor decision war room |
| Generative Media | 9 | Image/video/music generation (Nano Banana, Kling, Suno) |
| XActions | 10 | X/Twitter automation (posting, analytics, growth) |
| Trail of Bits | 6 | Security audit (code analysis, vulnerability detection) |

Full list: [configs/skills-list.md](configs/skills-list.md)

### Local AI Models

| Model | Size | Use |
|-------|------|-----|
| qwen3-coder:30b | 18 GB | Coding, refactoring, debugging |
| qwen3.5:9b | 6.6 GB | Fast general tasks |

Both run offline. Localhost only. No data leaves your machine.

### Open WebUI

ChatGPT-like interface at `http://localhost:3000`. Talks to your local Ollama models. Requires Docker Desktop.

### Video Pipeline

| Tool | Command | What It Does |
|------|---------|-------------|
| **Merge clips** | `./scripts/merge-clips.sh out.mp4 clips...` | Combine Kling clips with transitions |
| **Add music** | `--music track.mp3` flag | Layer audio track |
| **Clean metadata** | `./scripts/clean-metadata.sh video.mp4` | Strip all traces, inject iPhone 17 Pro Max + Dubai Marina GPS |
| **Remotion** | `npx remotion render TitleCard out.mp4` | Animated title cards, social post videos |
| **FFmpeg** | Direct commands | Trim, resize, format convert, color grade |

### Telegram Notifications

Bot: @tashisleepy_ai_bot

```bash
tashi-notify "Your message"        # Send notification
cat ~/.omc/notification-log.md      # View history
```

## File Locations

| What | Where |
|------|-------|
| Agents | `~/.claude/agents/` |
| Skills (56) | `~/.claude/commands/` |
| Settings | `~/.claude/settings.json` |
| AI Models | `~/.ollama/models/` |
| Open WebUI | Docker container `open-webui` on port 3000 |
| Telegram Config | `~/.omc/notifications.json` |
| Notification Log | `~/.omc/notification-log.md` |
| Notify Command | `/usr/local/bin/tashi-notify` |
| clean-slides Config | `.clean-slides/` |
| Instrumenta | `~/Library/Group Containers/.../Add-Ins/` |
| Video Studio | `~/tashi-workspace/video-studio/` |

## Documentation

- [Setup Guide (Markdown)](docs/SETUP-GUIDE.md) — Technical reference
- [Setup Guide (Word)](docs/Tashi-AI-Stack-Setup-Guide.docx) — Step-by-step with simple language
- [Awesome Claude Code Picks](docs/awesome-claude-code-picks.md) — Curated tools to explore later

## Security Notes

- Ollama listens on localhost:11434 only
- Open WebUI on localhost:3000 only
- AI models are GGUF format (inert weights, no executable code)
- Telegram bot token stored locally in `~/.omc/notifications.json`
- No credentials pushed to this repo
- All tools are open source (MIT/Apache 2.0)
- Metadata cleaner removes ALL editing software fingerprints

## License

MIT
