#!/bin/bash

apps=""

# Steam
if pgrep -x steam >/dev/null 2>&1 || pgrep -f "steamwebhelper" >/dev/null 2>&1; then
    apps="$apps 󰓓 Steam"
fi

# Discord
if pgrep -x Discord >/dev/null 2>&1 || pgrep -f discord >/dev/null 2>&1; then
    apps="$apps 󰙯 Discord"
fi

# Spotify
if pgrep -x spotify >/dev/null 2>&1 || pgrep -f spotify >/dev/null 2>&1; then
    apps="$apps 󰓇 Spotify"
fi

# Telegram
if pgrep -x telegram-desktop >/dev/null 2>&1 || pgrep -f telegram-desktop >/dev/null 2>&1; then
    apps="$apps 󰚩 Telegram"
fi

# Firefox
if pgrep -x firefox >/dev/null 2>&1; then
    apps="$apps 󰈹 Firefox"
fi

# Kitty
if pgrep -x kitty >/dev/null 2>&1; then
    apps="$apps 󰄛 Kitty"
fi

if [ -z "$apps" ]; then
    echo '{"text":"","tooltip":"Arka planda çalışan uygulama yok"}'
else
    apps=$(echo "$apps" | sed 's/^ *//')

    echo "{\"text\":\"$apps\",\"tooltip\":\"$apps\"}"
fi
