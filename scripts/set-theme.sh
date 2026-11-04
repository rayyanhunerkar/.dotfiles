#!/usr/bin/env bash
# Switch the color theme across kitty, tmux, zellij, oh-my-posh, fastfetch, nvim,
# Zed, git, and the env-var tools (fzf, bat, eza). zellij and Zed watch their
# themes/ dirs and recolor on their own.
# Usage: set-theme.sh <name>   — run with no args to list what's available.
#        set-theme.sh --seed <name>   — fill in only missing files, no live reload
#                                       (install.sh uses this, so the table below
#                                       is the one list of theme files).
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$DOTFILES/.config"

SEED=0
if [ "${1:-}" = --seed ]; then
  SEED=1
  shift
fi

if [ $# -ne 1 ] || [ ! -f "$SRC/kitty/themes/$1.conf" ]; then
  echo "usage: $(basename "$0") [--seed] <theme>"
  echo "available:"
  for f in "$SRC"/kitty/themes/*.conf; do echo "  $(basename "${f%.conf}")"; done
  exit 1
fi

NAME="$1"

# dest <- src, one pair per line. A missing source is reported, not fatal, so a
# half-finished theme still switches everything it does define.
copy() {
  local src=$1 dst=$2
  if [ "$SEED" = 1 ] && [ -f "$dst" ]; then
    return 0
  fi
  if [ -f "$src" ]; then
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
  else
    echo "  ! missing $(basename "$src") — skipped"
  fi
}

copy "$SRC/kitty/themes/$NAME.conf"           "$HOME/.config/kitty/current-theme.conf"
copy "$SRC/tmux/themes/$NAME.conf"            "$HOME/.config/tmux/current-theme.conf"
copy "$SRC/fastfetch/themes/$NAME.jsonc"      "$HOME/.config/fastfetch/config.jsonc"
copy "$SRC/git/themes/$NAME.gitconfig"        "$HOME/.config/git/current-theme.gitconfig"
copy "$SRC/zsh/themes/$NAME.zsh"              "$HOME/.config/zsh/current-theme.zsh"
copy "$SRC/nvim/themes/$NAME.lua"             "$HOME/.config/nvim/colors/dotfiles.lua"
copy "$SRC/zellij/palettes/$NAME.kdl"         "$HOME/.config/zellij/themes/dotfiles.kdl"
copy "$SRC/zed/palettes/$NAME.json"           "$HOME/.config/zed/themes/dotfiles.json"

# oh-my-posh goes through set-prompt so a chosen shape survives the switch
OMP_STATE="$HOME/.config/oh-my-posh"
mkdir -p "$OMP_STATE"
if [ "$SEED" = 0 ] || [ ! -f "$OMP_STATE/current-theme.name" ]; then
  echo "$NAME" >"$OMP_STATE/current-theme.name"
fi
if [ "$SEED" = 0 ] || [ ! -f "$OMP_STATE/current.omp.json" ]; then
  "$DOTFILES/scripts/set-prompt.sh" "$(cat "$OMP_STATE/current-shape.name" 2>/dev/null || echo default)"
fi

if [ "$SEED" = 1 ]; then
  echo "seeded defaults from $NAME"
  exit 0
fi

echo "theme -> $NAME"

# live-reload kitty (remote control)
for sock in /tmp/kitty-*; do
  [ -S "$sock" ] || continue
  kitty @ --to "unix:$sock" load-config 2>/dev/null && echo "reloaded kitty ($sock)"
done

# live-reload tmux
if command -v tmux >/dev/null && tmux info >/dev/null 2>&1; then
  tmux source-file "$HOME/.config/tmux/tmux.conf" && echo "reloaded tmux"
fi

# live-reload any running nvim that exposes a server socket
if command -v nvim >/dev/null; then
  # macOS default: $TMPDIR/nvim.<user>/<id>/nvim.<pid>.0
  for sock in "${TMPDIR:-/tmp}"/nvim.*/*/nvim.*.0 /tmp/nvim*.sock; do
    [ -S "$sock" ] || continue
    nvim --server "$sock" --remote-send '<C-\><C-N>:colorscheme dotfiles<CR>' 2>/dev/null \
      && echo "reloaded nvim ($sock)"
  done
fi

echo "zsh: run 'zeload' — the prompt and fzf/bat/eza colors are per-session"
