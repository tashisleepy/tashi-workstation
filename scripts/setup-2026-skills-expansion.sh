#!/usr/bin/env bash
# Tashi Workstation — 2026 Skills Expansion
# Installs 19 skill packs (~250+ sub-skills) covering SEO, ads, content, video, security, science, trading, ML eval, and automation.
# Generated: 2026-04-26
# Reproduces the expansion documented in docs/SKILLS-EXPANSION-2026-04-26.md

set -euo pipefail

SKILLS_DIR="$HOME/.claude/skills"
INSTALL_TMP="$HOME/.claude/skill-installs/2026-expansion"

echo "==============================================="
echo "Tashi Workstation — 2026 Skills Expansion"
echo "==============================================="
echo ""
echo "Installing 19 skill packs (~250+ sub-skills)"
echo "Skills directory: $SKILLS_DIR"
echo ""

mkdir -p "$INSTALL_TMP/tier1" "$INSTALL_TMP/tier2" "$INSTALL_TMP/optional"
mkdir -p "$SKILLS_DIR"

# ===========================================================
# TIER 1 — Critical (10 packs)
# ===========================================================
echo ""
echo "==============================================="
echo "TIER 1 — Critical (10 packs)"
echo "==============================================="

cd "$INSTALL_TMP/tier1"

echo "[1/10] AgriciDaniel/claude-seo (5,465⭐)..."
git clone --depth 1 https://github.com/AgriciDaniel/claude-seo.git 2>/dev/null && (cd claude-seo && bash install.sh) || echo "  already installed or skipped"

echo "[2/10] AgriciDaniel/claude-ads (3,121⭐)..."
git clone --depth 1 https://github.com/AgriciDaniel/claude-ads.git 2>/dev/null && (cd claude-ads && bash install.sh) || echo "  already installed or skipped"

echo "[3/10] AgriciDaniel/claude-blog (586⭐)..."
git clone --depth 1 https://github.com/AgriciDaniel/claude-blog.git 2>/dev/null && (cd claude-blog && chmod +x install.sh && ./install.sh) || echo "  already installed or skipped"

echo "[4/10] AgriciDaniel/claude-repurpose (30⭐)..."
git clone --depth 1 https://github.com/AgriciDaniel/claude-repurpose.git 2>/dev/null && (cd claude-repurpose && bash install.sh) || echo "  already installed or skipped"

echo "[5/10] AgriciDaniel/claude-email (30⭐)..."
git clone --depth 1 https://github.com/AgriciDaniel/claude-email.git 2>/dev/null && (cd claude-email && bash install.sh) || echo "  already installed or skipped"

echo "[6/10] AgriciDaniel/claude-youtube (69⭐)..."
git clone --depth 1 https://github.com/AgriciDaniel/claude-youtube.git 2>/dev/null
mkdir -p "$SKILLS_DIR/claude-youtube"
cp -r claude-youtube/skills/claude-youtube/* "$SKILLS_DIR/claude-youtube/" 2>/dev/null || true

echo "[7/10] AgriciDaniel/claude-shorts (66⭐)..."
git clone --depth 1 https://github.com/AgriciDaniel/claude-shorts.git 2>/dev/null && (cd claude-shorts && bash install.sh) || echo "  already installed or skipped"

echo "[8/10] K-Dense-AI/scientific-agent-skills (19,419⭐) — 134 skills..."
git clone --depth 1 https://github.com/K-Dense-AI/scientific-agent-skills.git 2>/dev/null
mkdir -p "$SKILLS_DIR/scientific-agent-skills"
cp -r scientific-agent-skills/scientific-skills/* "$SKILLS_DIR/scientific-agent-skills/" 2>/dev/null || true

echo "[9/10] realkimbarrett/advertising-skills (589⭐)..."
git clone --depth 1 https://github.com/realkimbarrett/advertising-skills.git 2>/dev/null
mkdir -p "$SKILLS_DIR/advertising-skills"
cp -r advertising-skills/skills/* "$SKILLS_DIR/advertising-skills/" 2>/dev/null || true

echo "[10/10] K-Dense-AI/claude-scientific-writer (1,607⭐) — 24 skills..."
git clone --depth 1 https://github.com/K-Dense-AI/claude-scientific-writer.git 2>/dev/null
mkdir -p "$SKILLS_DIR/scientific-writer"
cp -r claude-scientific-writer/skills/* "$SKILLS_DIR/scientific-writer/" 2>/dev/null || true

# ===========================================================
# TIER 2 — High Value (8 packs)
# ===========================================================
echo ""
echo "==============================================="
echo "TIER 2 — High Value (8 packs)"
echo "==============================================="

cd "$INSTALL_TMP/tier2"

echo "[1/8] AgriciDaniel/wp-mcp-ultimate (62⭐) — clone for WP upload..."
git clone --depth 1 https://github.com/AgriciDaniel/wp-mcp-ultimate.git 2>/dev/null || true
echo "      → Upload to WordPress: WP Admin → Plugins → Upload Plugin"

echo "[2/8] AgriciDaniel/claude-cybersecurity (84⭐)..."
git clone --depth 1 https://github.com/AgriciDaniel/claude-cybersecurity.git 2>/dev/null && (cd claude-cybersecurity && bash install.sh) || echo "  already installed or skipped"

echo "[3/8] AgriciDaniel/automated-business-analysis-workflow (109⭐) — clone for n8n import..."
git clone --depth 1 https://github.com/AgriciDaniel/automated-business-analysis-workflow.git 2>/dev/null || true
echo "      → Import JSON into n8n manually"

echo "[4/8] ognjengt/founder-skills (125⭐) — 15 skills..."
git clone --depth 1 https://github.com/ognjengt/founder-skills.git 2>/dev/null
mkdir -p "$SKILLS_DIR/founder-skills"
cp -r founder-skills/skills/* "$SKILLS_DIR/founder-skills/" 2>/dev/null || true

echo "[5/8] tradermonty/claude-trading-skills (1,048⭐) — 52 skills..."
git clone --depth 1 https://github.com/tradermonty/claude-trading-skills.git 2>/dev/null
mkdir -p "$SKILLS_DIR/trading-skills"
cp -r claude-trading-skills/skills/* "$SKILLS_DIR/trading-skills/" 2>/dev/null || true

echo "[6/8] hamelsmu/evals-skills (1,190⭐) — 7 skills..."
git clone --depth 1 https://github.com/hamelsmu/evals-skills.git 2>/dev/null
mkdir -p "$SKILLS_DIR/evals-skills"
cp -r evals-skills/skills/* "$SKILLS_DIR/evals-skills/" 2>/dev/null || true

echo "[7/8] AgriciDaniel/claude-video (9⭐) — 15 sub-skills..."
git clone --depth 1 https://github.com/AgriciDaniel/claude-video.git 2>/dev/null && (cd claude-video && bash install.sh) || echo "  already installed or skipped"

echo "[8/8] AgriciDaniel/claude-gif (11⭐) — 5 sub-skills..."
git clone --depth 1 https://github.com/AgriciDaniel/claude-gif.git 2>/dev/null && (cd claude-gif && bash install.sh) || echo "  already installed or skipped"

# ===========================================================
# OPTIONAL — Workflow
# ===========================================================
echo ""
echo "==============================================="
echo "OPTIONAL — Workflow"
echo "==============================================="

cd "$INSTALL_TMP/optional"

echo "[1/1] AlexBoudreaux/claude-zapier-skill — uses free Zapier tier..."
git clone --depth 1 https://github.com/alexboudreaux/claude-zapier-skill.git 2>/dev/null
mkdir -p "$SKILLS_DIR/zapier-workflows"
cp -r claude-zapier-skill/.claude/skills/zapier-workflows/* "$SKILLS_DIR/zapier-workflows/" 2>/dev/null || true

# ===========================================================
# COMPLETE
# ===========================================================
echo ""
echo "==============================================="
echo "✓ INSTALLATION COMPLETE"
echo "==============================================="
echo ""
echo "Installed skill directories: $(ls "$SKILLS_DIR" | wc -l | tr -d ' ')"
echo ""
echo "Restart Claude Code to activate new skills."
echo ""
echo "OPTIONAL FREE API KEYS (recommended for full features):"
echo "  • Google AI Studio:  https://aistudio.google.com/apikey"
echo "  • YouTube Data API:  https://console.cloud.google.com/apis/library/youtube.googleapis.com"
echo "  • FMP Financial:     https://site.financialmodelingprep.com/developer/docs"
echo ""
echo "Manual setup needed:"
echo "  • WordPress MCP:  Upload wp-mcp-ultimate to your WP sites"
echo "  • n8n flow:       Import automated-business-analysis-workflow JSON to n8n"
echo "  • Zapier MCP:     https://mcp.zapier.com/mcp/servers"
echo ""
