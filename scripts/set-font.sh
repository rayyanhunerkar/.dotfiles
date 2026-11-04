#!/usr/bin/env bash
# Switch the kitty font. Usage: set-font.sh <name>   — run with no args to list what's available.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FONTS_DIR="$DOTFILES/.config/kitty/fonts"
CURRENT="$HOME/.config/kitty/current-font.conf"

if [ $# -ne 1 ] || [ ! -f "$FONTS_DIR/$1.conf" ]; then
  echo "usage: $(basename "$0") <font>"
  echo "available:"
  for f in "$FONTS_DIR"/*.conf; do echo "  $(basename "${f%.conf}")"; done
  exit 1
fi

cp "$FONTS_DIR/$1.conf" "$CURRENT"
echo "current-font.conf -> $1"

# live-reload any running kitty instances with remote control on
for sock in /tmp/kitty-*; do
  [ -S "$sock" ] || continue
  # `if`, not `&&`: a stale socket must not become this script's exit status.
  if kitty @ --to "unix:$sock" load-config 2>/dev/null; then
    echo "reloaded $sock"
  fi
done
