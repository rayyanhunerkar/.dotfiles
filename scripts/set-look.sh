#!/usr/bin/env bash
# Switch theme and font together. Without a font, uses the theme's paired one.
# Usage: set-look.sh <theme> [font]   — run with no args to list what's available.
#        set-look.sh --font-for <theme>   — print the pairing (check.sh uses this).
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KITTY="$DOTFILES/.config/kitty"

font_for() {
  case "$1" in
    organization-xiii | caelid) echo jetbrains-mono ;;
    dive-to-the-heart | castle-oblivion) echo victor-mono ;;
    destiny-islands | frutiger-aero) echo recursive-casual ;;
    hallownest | crystal-peak) echo recursive-linear ;;
    erdtree | castlevania | black-gold) echo blex-mono ;;
    twilight-town | greenpath) echo fantasque-sans-mono ;;
    y2k-vaporwave) echo departure-mono ;;
    *) return 1 ;;
  esac
}

if [ "${1:-}" = --font-for ]; then
  font_for "${2:-}"
  exit
fi

usage() {
  echo "usage: $(basename "$0") <theme> [font]"
  echo "themes:"
  for f in "$KITTY"/themes/*.conf; do
    name="$(basename "${f%.conf}")"
    echo "  $name ($(font_for "$name" || echo 'no pairing'))"
  done
  echo "fonts:"
  for f in "$KITTY"/fonts/*.conf; do echo "  $(basename "${f%.conf}")"; done
  exit 1
}

if [ $# -lt 1 ] || [ $# -gt 2 ] || [ ! -f "$KITTY/themes/$1.conf" ]; then
  usage
fi

THEME="$1"
FONT="${2:-$(font_for "$THEME" || true)}"

# Validate before switching, so a bad font can't leave the theme half changed.
if [ -z "$FONT" ]; then
  echo "$THEME has no paired font: pass one, or add it to set-look.sh" >&2
  exit 1
fi
if [ ! -f "$KITTY/fonts/$FONT.conf" ]; then
  usage
fi

"$DOTFILES/scripts/set-font.sh" "$FONT"
"$DOTFILES/scripts/set-theme.sh" "$THEME"
