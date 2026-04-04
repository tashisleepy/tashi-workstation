#!/bin/bash
# Merge multiple video clips into one final video
# Usage: ./scripts/merge-clips.sh output.mp4 clip1.mp4 clip2.mp4 clip3.mp4 ...
#
# Options:
#   --transition fade|smoothleft|smoothright|wipeleft|none (default: none = hard cut)
#   --duration 0.3 (transition duration in seconds, default: 0.3)
#   --music track.mp3 (add music underneath)
#   --fps 30 (output fps, default: 30)
#
# Examples:
#   ./scripts/merge-clips.sh final.mp4 clip1.mp4 clip2.mp4 clip3.mp4
#   ./scripts/merge-clips.sh final.mp4 --transition fade --music bgm.mp3 clip1.mp4 clip2.mp4

set -e

# Parse args
OUTPUT=""
TRANSITION="none"
TRANS_DUR="0.3"
MUSIC=""
FPS="30"
CLIPS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --transition) TRANSITION="$2"; shift 2 ;;
    --duration) TRANS_DUR="$2"; shift 2 ;;
    --music) MUSIC="$2"; shift 2 ;;
    --fps) FPS="$2"; shift 2 ;;
    *)
      if [ -z "$OUTPUT" ]; then
        OUTPUT="$1"
      else
        CLIPS+=("$1")
      fi
      shift ;;
  esac
done

if [ -z "$OUTPUT" ] || [ ${#CLIPS[@]} -lt 2 ]; then
  echo "Usage: merge-clips.sh output.mp4 [options] clip1.mp4 clip2.mp4 ..."
  echo "  --transition fade|smoothleft|none   Transition type (default: none)"
  echo "  --duration 0.3                       Transition duration"
  echo "  --music track.mp3                    Add music track"
  echo "  --fps 30                             Output FPS"
  exit 1
fi

echo "Merging ${#CLIPS[@]} clips → $OUTPUT"
echo "Transition: $TRANSITION ($TRANS_DUR s)"

if [ "$TRANSITION" = "none" ]; then
  # Hard cuts — simple concat
  CONCAT_FILE=$(mktemp /tmp/concat-XXXXX.txt)
  for clip in "${CLIPS[@]}"; do
    echo "file '$clip'" >> "$CONCAT_FILE"
  done

  ffmpeg -y -f concat -safe 0 -i "$CONCAT_FILE" \
    -c:v libx264 -preset slow -crf 16 -pix_fmt yuv420p -r "$FPS" -an \
    "${OUTPUT%.mp4}-noaudio.mp4" 2>/dev/null
  rm "$CONCAT_FILE"
else
  # With transitions — need xfade chain
  # First normalize all clips
  NORM_CLIPS=()
  for i in "${!CLIPS[@]}"; do
    NORM="/tmp/norm_clip_${i}.mp4"
    ffmpeg -y -i "${CLIPS[$i]}" \
      -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:-1:-1" \
      -c:v libx264 -preset fast -crf 18 -an -r "$FPS" "$NORM" 2>/dev/null
    NORM_CLIPS+=("$NORM")
    echo "  Normalized: $(basename "${CLIPS[$i]}")"
  done

  # Build xfade filter chain
  INPUTS=""
  FILTER=""
  for i in "${!NORM_CLIPS[@]}"; do
    INPUTS="$INPUTS -i ${NORM_CLIPS[$i]}"
  done

  # Calculate offsets
  PREV_OUT="[0:v]"
  for ((i=1; i<${#NORM_CLIPS[@]}; i++)); do
    DUR=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "${NORM_CLIPS[$((i-1))]}")
    if [ $i -eq 1 ]; then
      OFFSET=$(echo "$DUR - $TRANS_DUR" | bc)
    else
      OFFSET=$(echo "$OFFSET + $DUR - $TRANS_DUR" | bc)
    fi
    OUT_LABEL="[v${i}]"
    if [ $i -eq $((${#NORM_CLIPS[@]}-1)) ]; then
      OUT_LABEL="[vout]"
    fi
    FILTER="${FILTER}${PREV_OUT}[${i}:v]xfade=transition=${TRANSITION}:duration=${TRANS_DUR}:offset=${OFFSET}${OUT_LABEL}; "
    PREV_OUT="$OUT_LABEL"
  done

  # Remove trailing semicolon
  FILTER="${FILTER%; }"

  eval ffmpeg -y $INPUTS -filter_complex "\"$FILTER\"" \
    -map "\"[vout]\"" \
    -c:v libx264 -preset slow -crf 16 -pix_fmt yuv420p -r "$FPS" \
    "\"${OUTPUT%.mp4}-noaudio.mp4\"" 2>/dev/null
fi

# Add music if provided
if [ -n "$MUSIC" ]; then
  echo "Adding music: $MUSIC"
  ffmpeg -y -i "${OUTPUT%.mp4}-noaudio.mp4" -i "$MUSIC" \
    -c:v copy -c:a aac -b:a 192k -shortest \
    "$OUTPUT" 2>/dev/null
  rm "${OUTPUT%.mp4}-noaudio.mp4"
else
  mv "${OUTPUT%.mp4}-noaudio.mp4" "$OUTPUT"
fi

DUR=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$OUTPUT")
SIZE=$(ls -lh "$OUTPUT" | awk '{print $5}')
printf "\nDone! %s (%.1fs, %s)\n" "$OUTPUT" "$DUR" "$SIZE"
