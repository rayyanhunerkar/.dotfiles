#!/usr/bin/env bash
# Switch the oh-my-posh prompt shape without changing the theme. `default` is the
# active theme's own prompt; any other shape is merged with its palette.
# Usage: set-prompt.sh <shape>   — run with no args to list what's available.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OMP="$DOTFILES/.config/oh-my-posh"
STATE="$HOME/.config/oh-my-posh"

if [ $# -ne 1 ] || { [ "$1" != default ] && [ ! -f "$OMP/shapes/$1.omp.json" ]; }; then
  echo "usage: $(basename "$0") <shape>"
  echo "available:"
  echo "  default"
  for f in "$OMP"/shapes/*.omp.json; do echo "  $(basename "${f%.omp.json}")"; done
  exit 1
fi

SHAPE="$1"
THEME="$(cat "$STATE/current-theme.name" 2>/dev/null || true)"
if [ -z "$THEME" ]; then
  echo "no active theme recorded — run set-theme <name> first" >&2
  exit 1
fi

if [ "$SHAPE" = default ]; then
  cp "$OMP/themes/$THEME.omp.json" "$STATE/current.omp.json"
else
  # write beside the target first: a failed merge must not leave an empty prompt
  jq --slurpfile palette "$OMP/palettes/$THEME.json" '. + {palette: $palette[0]}' \
    "$OMP/shapes/$SHAPE.omp.json" >"$STATE/current.omp.json.tmp"
  mv "$STATE/current.omp.json.tmp" "$STATE/current.omp.json"
fi

echo "$SHAPE" >"$STATE/current-shape.name"
echo "prompt -> $SHAPE ($THEME)"
