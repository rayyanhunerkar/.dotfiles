#!/usr/bin/env bash
# Switch the KH color theme across kitty, tmux, oh-my-posh.
# Usage: set-theme.sh <dive-to-the-heart|organization-xiii>
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ $# -ne 1 ] || [ ! -f "$DOTFILES/.config/kitty/themes/$1.conf" ]; then
  echo "usage: $(basename "$0") <theme>"
  echo "available:"
  for f in "$DOTFILES"/.config/kitty/themes/*.conf; do echo "  $(basename "${f%.conf}")"; done
  exit 1
fi

NAME="$1"
cp "$DOTFILES/.config/kitty/themes/$NAME.conf"          "$HOME/.config/kitty/current-theme.conf"
cp "$DOTFILES/.config/tmux/themes/$NAME.conf"           "$HOME/.config/tmux/current-theme.conf"
cp "$DOTFILES/.config/oh-my-posh/themes/$NAME.omp.json" "$HOME/.config/oh-my-posh/current.omp.json"
cp "$DOTFILES/.config/fastfetch/themes/$NAME.jsonc"     "$HOME/.config/fastfetch/config.jsonc"
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

echo "zsh: run 'zeload' or open a new shell — oh-my-posh config is cached per session"
