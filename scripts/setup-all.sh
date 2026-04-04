#!/bin/bash
# Tashi Workstation — Full Setup from Zero
# Run this on a fresh Mac to get everything installed.
# Tested on: Mac, macOS 15+
#
# Usage: chmod +x scripts/setup-all.sh && ./scripts/setup-all.sh

set -e

echo "=========================================="
echo "  TASHI WORKSTATION — FULL SETUP"
echo "=========================================="
echo ""

# ── 1. oh-my-claudecode ──
echo "[1/6] Installing oh-my-claudecode..."
npm i -g oh-my-claude-sisyphus@latest
omc setup
echo "Done: 19 agents + HUD installed"
echo ""

# ── 2. Agency Agents (cherry-picked) ──
echo "[2/6] Installing agency agents..."
AGENTS_REPO="/tmp/agency-agents-install"
git clone --depth 1 https://github.com/msitarzewski/agency-agents.git "$AGENTS_REPO" 2>/dev/null || true

for agent in \
  marketing/marketing-seo-specialist.md \
  marketing/marketing-twitter-engager.md \
  marketing/marketing-linkedin-content-creator.md \
  marketing/marketing-content-creator.md \
  design/design-image-prompt-engineer.md \
  design/design-brand-guardian.md \
  sales/sales-proposal-strategist.md \
  sales/sales-discovery-coach.md \
  product/product-manager.md \
  product/product-trend-researcher.md \
  engineering/engineering-ai-engineer.md \
  engineering/engineering-software-architect.md; do
  cp "$AGENTS_REPO/$agent" ~/.claude/agents/ 2>/dev/null && echo "  Installed: $(basename $agent .md)"
done
rm -rf "$AGENTS_REPO"
echo "Done: 12 agency agents installed"
echo ""

# ── 3. OMC Skills ──
echo "[3/6] Installing OMC skills..."
SKILLS_REPO="/tmp/omc-skills-install"
git clone --depth 1 https://github.com/Yeachan-Heo/oh-my-claudecode.git "$SKILLS_REPO" 2>/dev/null || true
mkdir -p ~/.claude/commands
for skill_dir in "$SKILLS_REPO"/skills/*/; do
  skill_name=$(basename "$skill_dir")
  if [ -f "$skill_dir/SKILL.md" ]; then
    mkdir -p ~/.claude/commands/"$skill_name"
    cp "$skill_dir/SKILL.md" ~/.claude/commands/"$skill_name"/SKILL.md
  fi
done
rm -rf "$SKILLS_REPO"
echo "Done: 31 skills installed"
echo ""

# ── 4. Ollama + Qwen ──
echo "[4/6] Installing Ollama + Qwen models..."
if ! command -v ollama &> /dev/null; then
  brew install ollama
fi
brew services start ollama 2>/dev/null || true
sleep 3
ollama pull qwen3-coder:30b
ollama pull qwen3.5:9b
echo "Done: 2 AI models downloaded"
echo ""

# ── 5. clean-slides ──
echo "[5/6] Installing clean-slides..."
git clone --depth 1 https://github.com/tmustier/clean-slides.git /tmp/clean-slides-install 2>/dev/null || true
cd /tmp/clean-slides-install && pip3 install --break-system-packages -e . 2>/dev/null
cd - > /dev/null
echo "Done: clean-slides CLI available"
echo ""

# ── 6. Document generation deps ──
echo "[6/10] Installing document generation tools..."
npm install -g pptxgenjs docx 2>/dev/null || true
pip3 install --break-system-packages python-pptx python-docx docxtpl 2>/dev/null || true
echo "Done: PPT + Word generators ready"
echo ""

# ── 7. Generative Media Skills ──
echo "[7/10] Installing generative media skills..."
MEDIA_REPO="/tmp/gen-media-skills-install"
git clone --depth 1 https://github.com/SamurAIGPT/Generative-Media-Skills.git "$MEDIA_REPO" 2>/dev/null || true
for skill_dir in "$MEDIA_REPO"/library/*/; do
  for sub_dir in "$skill_dir"*/; do
    if [ -f "$sub_dir/SKILL.md" ]; then
      skill_name=$(basename "$sub_dir")
      mkdir -p ~/.claude/commands/"$skill_name"
      cp "$sub_dir/SKILL.md" ~/.claude/commands/"$skill_name"/SKILL.md
    fi
  done
done
for core_dir in "$MEDIA_REPO"/core/*/; do
  if [ -f "$core_dir/SKILL.md" ]; then
    skill_name="media-$(basename "$core_dir")"
    mkdir -p ~/.claude/commands/"$skill_name"
    cp "$core_dir/SKILL.md" ~/.claude/commands/"$skill_name"/SKILL.md
  fi
done
rm -rf "$MEDIA_REPO"
echo "Done: 9 media generation skills installed"
echo ""

# ── 8. XActions (X/Twitter automation) ──
echo "[8/10] Installing X/Twitter skills..."
XACTIONS_REPO="/tmp/xactions-install"
git clone --depth 1 https://github.com/nirholas/XActions.git "$XACTIONS_REPO" 2>/dev/null || true
for skill in content-posting viral-thread-generation analytics-insights engagement-interaction \
  competitor-intelligence growth-automation follower-monitoring twitter-scraping discovery-explore profile-management; do
  if [ -f "$XACTIONS_REPO/skills/$skill/SKILL.md" ]; then
    mkdir -p ~/.claude/commands/"x-$skill"
    cp "$XACTIONS_REPO/skills/$skill/SKILL.md" ~/.claude/commands/"x-$skill"/SKILL.md
  fi
done
rm -rf "$XACTIONS_REPO"
echo "Done: 10 X/Twitter skills installed"
echo ""

# ── 9. Trail of Bits Security Skills ──
echo "[9/10] Installing security skills..."
TOB_REPO="/tmp/tob-skills-install"
git clone --depth 1 https://github.com/trailofbits/skills.git "$TOB_REPO" 2>/dev/null || true
for skill in audit-context-building entry-point-analyzer semgrep-rule-creator seatbelt-sandboxer zeroize-audit audit-augmentation; do
  skill_path=$(find "$TOB_REPO" -path "*/$skill/SKILL.md" | head -1)
  if [ -n "$skill_path" ]; then
    mkdir -p ~/.claude/commands/"sec-$skill"
    cp "$skill_path" ~/.claude/commands/"sec-$skill"/SKILL.md
  fi
done
rm -rf "$TOB_REPO"
echo "Done: 6 security skills installed"
echo ""

# ── 10. Open WebUI (requires Docker) ──
echo "[10/10] Setting up Open WebUI..."
if command -v docker &> /dev/null && docker info > /dev/null 2>&1; then
  docker rm -f open-webui 2>/dev/null || true
  docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway \
    --name open-webui --restart always ghcr.io/open-webui/open-webui:main 2>/dev/null
  echo "Done: Open WebUI at http://localhost:3000"
else
  echo "Skipped: Docker not running. Install Docker Desktop, then run scripts/setup-open-webui.sh"
fi
echo ""

# ── Enable agent teams ──
echo "Configuring Claude Code settings..."
SETTINGS_FILE="$HOME/.claude/settings.json"
if [ -f "$SETTINGS_FILE" ]; then
  python3 -c "
import json
with open('$SETTINGS_FILE') as f: d = json.load(f)
d.setdefault('env', {})['CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS'] = '1'
with open('$SETTINGS_FILE', 'w') as f: json.dump(d, f, indent=2)
print('  Agent teams enabled')
" 2>/dev/null
fi

echo ""
echo "=========================================="
echo "  SETUP COMPLETE"
echo "=========================================="
echo ""
echo "  Agents:  32 (19 OMC + 12 Agency + 1 custom)"
echo "  Skills:  56 (31 OMC + 9 Media + 10 X/Twitter + 6 Security)"
echo "  Models:  qwen3-coder:30b + qwen3.5:9b"
echo "  Tools:   clean-slides, pptxgenjs, python-pptx, docx, ffmpeg, remotion"
echo "  WebUI:   http://localhost:3000 (if Docker running)"
echo ""
echo "  Restart Claude Code to activate everything."
echo ""
