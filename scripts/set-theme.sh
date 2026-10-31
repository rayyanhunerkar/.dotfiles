#!/usr/bin/env bash
# Switch the color theme across kitty, ghostty, tmux, zellij, oh-my-posh, fastfetch,
# nvim, git, and the env-var tools (fzf, bat, eza).
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
copy "$SRC/ghostty/themes/$NAME"              "$HOME/.config/ghostty/current-theme"
copy "$SRC/tmux/themes/$NAME.conf"            "$HOME/.config/tmux/current-theme.conf"
copy "$SRC/fastfetch/themes/$NAME.jsonc"      "$HOME/.config/fastfetch/config.jsonc"
copy "$SRC/git/themes/$NAME.gitconfig"        "$HOME/.config/git/current-theme.gitconfig"
copy "$SRC/zsh/themes/$NAME.zsh"              "$HOME/.config/zsh/current-theme.zsh"
copy "$SRC/nvim/themes/$NAME.lua"             "$HOME/.config/nvim/colors/dotfiles.lua"
copy "$SRC/zellij/palettes/$NAME.kdl"         "$HOME/.config/zellij/themes/dotfiles.kdl"

# oh-my-posh goes through set-prompt so a chosen shape survives the switch
OMP_STATE="$HOME/.config/oh-my-posh"
mkdir -p "$OMP_STATE"
echo "$NAME" >"$OMP_STATE/current-theme.name"
"$DOTFILES/scripts/set-prompt.sh" "$(cat "$OMP_STATE/current-shape.name" 2>/dev/null || echo default)"
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
  for sock in "${XDG_RUNTIME_DIR:-/tmp}"/nvim.*/0 /tmp/nvim.*/0 /tmp/nvim*.sock; do
    [ -S "$sock" ] || continue
    nvim --server "$sock" --remote-send '<C-\><C-N>:colorscheme dotfiles<CR>' 2>/dev/null \
      && echo "reloaded nvim ($sock)"
  done
fi

echo "zsh: run 'zeload' — the prompt and fzf/bat/eza colors are per-session"
if pgrep -qx ghostty; then
  echo "ghostty: press cmd+shift+, to reload — no remote reload on macOS"
fi
