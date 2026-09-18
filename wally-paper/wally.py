#!/usr/bin/env python3

import json
import os
import subprocess
import sys

WALLPAPER_DIR = "/home/theilker/wallpapers"
MONITOR = "eDP-1"

EXTENSIONS = (".jpg", ".jpeg", ".png", ".webp")


def get_wallpapers():
    wallpapers = []

    if not os.path.isdir(WALLPAPER_DIR):
        return wallpapers

    for filename in sorted(os.listdir(WALLPAPER_DIR)):
        path = os.path.join(WALLPAPER_DIR, filename)

        if os.path.isfile(path) and filename.lower().endswith(EXTENSIONS):
            wallpapers.append({
                "name": filename,
                "path": path
            })

    return wallpapers


def set_wallpaper(path):
    if not os.path.isfile(path):
        return False

    try:
        subprocess.run(
            ["hyprctl", "hyprpaper", "preload", path],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )

        subprocess.run(
            ["hyprctl", "hyprpaper", "wallpaper", f"{MONITOR},{path}"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )

        return True

    except Exception:
        return False


def main():
    if len(sys.argv) < 2:
        print(json.dumps(get_wallpapers()))
        return

    command = sys.argv[1]

    if command == "list":
        print(json.dumps(get_wallpapers()))

    elif command == "set" and len(sys.argv) >= 3:
        print(json.dumps({
            "success": set_wallpaper(sys.argv[2])
        }))

    else:
        print(json.dumps({
            "success": False,
            "error": "invalid command"
        }))


if __name__ == "__main__":
    main()
