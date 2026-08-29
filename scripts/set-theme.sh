#!/usr/bin/env bash
# Switch the color theme across kitty, tmux, oh-my-posh, fastfetch, git, and the
# env-var tools (fzf, bat, eza).
# Usage: set-theme.sh <name>   — run with no args to list what's available.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$DOTFILES/.config"

if [ $# -ne 1 ] || [ ! -f "$SRC/kitty/themes/$1.conf" ]; then
  echo "usage: $(basename "$0") <theme>"
  echo "available:"
  for f in "$SRC"/kitty/themes/*.conf; do echo "  $(basename "${f%.conf}")"; done
  exit 1
fi

NAME="$1"

# dest <- src, one pair per line. A missing source is reported, not fatal, so a
# half-finished theme still switches everything it does define.
copy() {
  local src=$1 dst=$2
  if [ -f "$src" ]; then
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
  else
    echo "  ! missing $(basename "$src") — skipped"
  fi
}

copy "$SRC/kitty/themes/$NAME.conf"           "$HOME/.config/kitty/current-theme.conf"
copy "$SRC/tmux/themes/$NAME.conf"            "$HOME/.config/tmux/current-theme.conf"
copy "$SRC/oh-my-posh/themes/$NAME.omp.json"  "$HOME/.config/oh-my-posh/current.omp.json"
copy "$SRC/fastfetch/themes/$NAME.jsonc"      "$HOME/.config/fastfetch/config.jsonc"
copy "$SRC/git/themes/$NAME.gitconfig"        "$HOME/.config/git/current-theme.gitconfig"
copy "$SRC/zsh/themes/$NAME.zsh"              "$HOME/.config/zsh/current-theme.zsh"
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

echo "zsh: run 'zeload' — the prompt and fzf/bat/eza colors are per-session"
