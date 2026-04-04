#!/bin/bash
# Instrumenta PowerPoint Toolbar Setup
# Downloads and installs the free consulting-grade PPT toolbar.
#
# Requirements: Microsoft PowerPoint installed
# Usage: ./scripts/setup-instrumenta.sh

set -e

echo "Installing Instrumenta v1.66..."

# ── Download ──
mkdir -p ~/Downloads/Instrumenta

if command -v gh &> /dev/null; then
  gh release download 1.66 --repo iappyx/Instrumenta --dir ~/Downloads/Instrumenta 2>/dev/null
else
  curl -L -o ~/Downloads/Instrumenta/InstrumentaPowerpointToolbar.ppam \
    https://github.com/iappyx/Instrumenta/releases/download/1.66/InstrumentaPowerpointToolbar.ppam
  curl -L -o ~/Downloads/Instrumenta/InstrumentaAppleScriptPlugin.applescript \
    https://github.com/iappyx/Instrumenta/releases/download/1.66/InstrumentaAppleScriptPlugin.applescript
fi
echo "Downloaded to ~/Downloads/Instrumenta/"

# ── Install add-in ──
mkdir -p ~/Library/Group\ Containers/UBF8T346G9.Office/User\ Content/Add-Ins/
cp ~/Downloads/Instrumenta/InstrumentaPowerpointToolbar.ppam \
  ~/Library/Group\ Containers/UBF8T346G9.Office/User\ Content/Add-Ins/
echo "Add-in installed"

# ── Install AppleScript plugin ──
mkdir -p ~/Library/Application\ Scripts/com.microsoft.Powerpoint/
cp ~/Downloads/Instrumenta/InstrumentaAppleScriptPlugin.applescript \
  ~/Library/Application\ Scripts/com.microsoft.Powerpoint/
echo "AppleScript plugin installed"

echo ""
echo "Done! Now open PowerPoint:"
echo "  1. Tools → PowerPoint Add-ins"
echo "  2. Click + and select InstrumentaPowerpointToolbar.ppam"
echo "  3. Instrumenta tab appears in ribbon"
