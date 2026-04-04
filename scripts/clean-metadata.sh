#!/bin/bash
# Clean video metadata and inject iPhone 17 Pro Max + Dubai Marina tags
# Usage: ./scripts/clean-metadata.sh input.mp4 [output.mp4]
#
# What it does:
#   1. Strips ALL metadata (CapCut, FFmpeg, computer info — everything)
#   2. Injects Apple iPhone 17 Pro Max camera tags
#   3. Injects Dubai Marina GPS coordinates
#   4. Removes all editing software fingerprints
#
# Requirements: ffmpeg, exiftool

set -e

INPUT="${1:?Usage: ./scripts/clean-metadata.sh input.mp4 [output.mp4]}"
OUTPUT="${2:-${INPUT%.*}-clean.mp4}"

echo "Cleaning: $INPUT"
echo "Output:   $OUTPUT"
echo ""

# Step 1: Strip all metadata
echo "[1/3] Stripping all metadata..."
ffmpeg -y -i "$INPUT" \
  -map_metadata -1 \
  -c:v copy -c:a copy \
  -movflags +faststart \
  "$OUTPUT" 2>/dev/null

# Step 2: Inject iPhone 17 Pro Max + Dubai Marina tags
echo "[2/3] Injecting iPhone 17 Pro Max + Dubai Marina tags..."
exiftool \
  -overwrite_original \
  -Make="Apple" \
  -Model="iPhone 17 Pro Max" \
  -Software="18.4" \
  -LensModel="iPhone 17 Pro Max back triple camera 6.765mm f/1.78" \
  -LensSerialNumber="" \
  -FocalLength="6.765mm" \
  -FocalLengthIn35mmFormat="24 mm" \
  -FNumber="1.78" \
  -ExposureProgram="Program AE" \
  -MeteringMode="Multi-segment" \
  -Flash="Off, Did not fire" \
  -WhiteBalance="Auto" \
  -DigitalZoomRatio="1" \
  -SceneCaptureType="Standard" \
  -GPSLatitude="25.0762" \
  -GPSLatitudeRef="N" \
  -GPSLongitude="55.1342" \
  -GPSLongitudeRef="E" \
  -GPSAltitude="15" \
  -GPSAltitudeRef="Above Sea Level" \
  -ContentIdentifier="" \
  -XResolution="72" \
  -YResolution="72" \
  "$OUTPUT" > /dev/null 2>&1

# Step 3: Remove encoder traces
echo "[3/3] Removing encoder traces..."
exiftool -overwrite_original \
  -Encoder="" \
  -EncodingTool="" \
  -History="" \
  -XMP:All="" \
  "$OUTPUT" > /dev/null 2>&1

echo ""
echo "Done! Metadata:"
exiftool "$OUTPUT" | grep -E "Make|Model|Software|Lens|GPS Position|Focal Length In"
echo ""
echo "Trace check:"
exiftool "$OUTPUT" | grep -iE "capcut|ffmpeg|lavf|encoder|encoding" || echo "  Clean — zero editing traces"
