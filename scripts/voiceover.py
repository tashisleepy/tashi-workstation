#!/usr/bin/env python3
"""
Voxtral TTS — Generate voiceovers from text using Mistral's free API.
Add voiceovers to your Kling videos, Reels, or any content.

Usage:
  python3 voiceover.py "Your text here"
  python3 voiceover.py "Your text here" --output my-voiceover.wav
  python3 voiceover.py "Your text here" --voice jessica
  python3 voiceover.py --file script.txt --output narration.wav

Voices: oliver (British male), paul (US male), jane (British female)
Moods: neutral, happy, excited, confident, sad, angry, frustrated, cheerful, sarcasm
"""

import argparse
import json
import sys
import subprocess
import os

API_KEY = os.environ.get("MISTRAL_API_KEY", "")
if not API_KEY:
    print("Error: MISTRAL_API_KEY environment variable not set.")
    print("Set it with: export MISTRAL_API_KEY=your_key_here")
    sys.exit(1)
API_URL = "https://api.mistral.ai/v1/audio/speech"

VOICES = {
    "oliver": "gb_oliver_neutral",
    "paul": "en_paul_neutral",
    "paul-happy": "en_paul_happy",
    "paul-excited": "en_paul_excited",
    "paul-confident": "en_paul_confident",
    "paul-sad": "en_paul_sad",
    "paul-angry": "en_paul_angry",
    "paul-cheerful": "en_paul_cheerful",
    "paul-frustrated": "en_paul_frustrated",
    "jane": "gb_jane_sarcasm",
}

def generate_voiceover(text, voice="oliver", output="voiceover.wav"):
    """Generate voiceover using Mistral Voxtral TTS API."""

    print(f"Generating voiceover...")
    voice_slug = VOICES.get(voice, voice)  # Allow direct slug too
    print(f"  Voice: {voice} → {voice_slug}")
    print(f"  Text: {text[:80]}{'...' if len(text) > 80 else ''}")
    print(f"  Output: {output}")

    import base64

    cmd = [
        "curl", "-s", "-X", "POST", API_URL,
        "-H", f"Authorization: Bearer {API_KEY}",
        "-H", "Content-Type: application/json",
        "-d", json.dumps({
            "model": "voxtral-mini-tts-2603",
            "input": text,
            "voice": voice_slug,
            "response_format": "wav"
        })
    ]

    result = subprocess.run(cmd, capture_output=True, text=True)

    if result.returncode != 0:
        print(f"  Error: {result.stderr}")
        return False

    try:
        data = json.loads(result.stdout)
    except:
        print(f"  Error: unexpected response")
        return False

    if "error" in data or "object" in data and data.get("object") == "error":
        print(f"  API Error: {data}")
        return False

    if "audio_data" in data:
        audio_bytes = base64.b64decode(data["audio_data"])
        with open(output, "wb") as f:
            f.write(audio_bytes)
        size = len(audio_bytes)
        duration_cmd = subprocess.run(
            ["ffprobe", "-v", "quiet", "-show_entries", "format=duration", "-of", "csv=p=0", output],
            capture_output=True, text=True
        )
        duration = float(duration_cmd.stdout.strip()) if duration_cmd.stdout.strip() else 0
        print(f"\n  Done! {size//1024}KB, {duration:.1f}s")
        return True
    else:
        print(f"  Error: no audio_data in response")
        print(f"  Keys: {list(data.keys())}")
        return False


def add_voiceover_to_video(video_path, audio_path, output_path=None):
    """Merge voiceover audio with a video file."""
    if not output_path:
        base = os.path.splitext(video_path)[0]
        output_path = f"{base}-with-voice.mp4"

    print(f"\nAdding voiceover to video...")
    print(f"  Video: {video_path}")
    print(f"  Audio: {audio_path}")

    cmd = [
        "ffmpeg", "-y",
        "-i", video_path,
        "-i", audio_path,
        "-c:v", "copy",
        "-c:a", "aac", "-b:a", "192k",
        "-shortest",
        output_path
    ]

    result = subprocess.run(cmd, capture_output=True, text=True)

    if result.returncode == 0:
        print(f"  Output: {output_path}")
        return output_path
    else:
        print(f"  Error: {result.stderr[:200]}")
        return None


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Voxtral TTS — Free voiceovers for your videos")
    parser.add_argument("text", nargs="?", help="Text to convert to speech")
    parser.add_argument("--file", "-f", help="Read text from file instead")
    parser.add_argument("--output", "-o", default="voiceover.wav", help="Output file (default: voiceover.wav)")
    parser.add_argument("--voice", "-v", default="oliver", choices=VOICES.keys(), help="Voice (default: oliver)")
    parser.add_argument("--video", help="Add voiceover to this video file")
    parser.add_argument("--list-voices", action="store_true", help="List available voices")
    args = parser.parse_args()

    if args.list_voices:
        print("\nAvailable voices:")
        for name, desc in VOICES.items():
            print(f"  {name:<12} {desc}")
        print()
        sys.exit(0)

    # Get text
    text = args.text
    if args.file:
        with open(args.file) as f:
            text = f.read().strip()

    if not text:
        print("Error: Provide text or --file")
        sys.exit(1)

    # Generate voiceover
    success = generate_voiceover(text, args.voice, args.output)

    if success and args.video:
        add_voiceover_to_video(args.video, args.output)

    if success:
        print(f"\nPlay it: open {args.output}")
