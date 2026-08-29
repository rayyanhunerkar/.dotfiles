#!/usr/bin/env bash
# Switch kitty's font. Usage: set-font.sh <jetbrains-mono|victor-mono|maple-mono>
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
  kitty @ --to "unix:$sock" load-config 2>/dev/null && echo "reloaded $sock"
done
