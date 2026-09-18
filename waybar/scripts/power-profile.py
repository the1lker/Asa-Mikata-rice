#!/usr/bin/env python3

import json
import subprocess
import sys

PROFILES = {
    "power-saver": ("󰌪", "Tasarruf"),
    "balanced": ("󰾅", "Dengeli"),
    "performance": ("󰓅", "Performans"),
}

def get_profile():
    return subprocess.check_output(
        ["powerprofilesctl", "get"],
        text=True
    ).strip()

def notify(profile):
    icon, name = PROFILES[profile]

    subprocess.Popen([
        "notify-send",
        "-a", "Waybar",
        "-u", "normal",
        f"{icon}  Güç Profili",
        f"{name} modu etkin"
    ])

def cycle():
    current = get_profile()

    next_profile = {
        "power-saver": "balanced",
        "balanced": "performance",
        "performance": "power-saver",
    }.get(current, "balanced")

    subprocess.run(
        ["powerprofilesctl", "set", next_profile],
        check=True
    )

    notify(next_profile)

def output():
    profile = get_profile()

    icon, name = PROFILES.get(
        profile,
        ("󰾆", profile)
    )

    print(json.dumps({
        "text": f"{icon} {name}",
        "tooltip": f"Güç profili: {name}"
    }, ensure_ascii=False))

if __name__ == "__main__":
    if "--cycle" in sys.argv:
        cycle()
    else:
        output()
