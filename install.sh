#!/usr/bin/env bash
# Install packages, stow configs into ~/.config, install mise toolchains, and
# bootstrap the zsh and tmux plugin managers. macOS settings are separate:
# scripts/defaults.sh.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

# Homebrew packages. Installs what's missing; never removes anything.
if ! command -v brew >/dev/null; then
  echo "install Homebrew first: https://brew.sh" >&2
  exit 1
fi
brew bundle --file "$PWD/Brewfile"

# package `.config` folds into ~/.config (kitty, tmux, oh-my-posh, fastfetch, ...)
stow --dir "$PWD" --target "$HOME/.config" --restow .config

# package `zsh` links .zshrc / .zsh_plugins.txt into $HOME
stow --dir "$PWD" --target "$HOME" --restow zsh

# package `git` links .gitconfig / .gitconfig-work into $HOME
stow --dir "$PWD" --target "$HOME" --restow git

# package `containers` links containers.conf. Real dir first, or stow folds it
# into a symlink and podman writes its runtime state into this repo.
mkdir -p "$HOME/.config/containers"
stow --dir "$PWD" --target "$HOME" --restow containers

# runtimes and dev CLIs from .config/mise/config.toml (now stowed into place)
mise install

# default font (gitignored; scripts/set-font.sh swaps it)
CURRENT_FONT="$HOME/.config/kitty/current-font.conf"
[ -f "$CURRENT_FONT" ] || cp "$PWD/.config/kitty/fonts/jetbrains-mono.conf" "$CURRENT_FONT"

# default theme (gitignored; scripts/set-theme.sh swaps it)
"$PWD/scripts/set-theme.sh" --seed dive-to-the-heart

# zsh plugin manager; .zshrc sources it from here
ANTIDOTE="$HOME/.antidote"
if [ ! -d "$ANTIDOTE" ]; then
  git clone --depth 1 https://github.com/mattmc3/antidote.git "$ANTIDOTE"
fi

# tmux plugin manager (plugins are not vendored)
TPM="$HOME/.config/tmux/plugins/tpm"
if [ ! -d "$TPM" ]; then
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM"
fi

echo
echo "done. open tmux and press <prefix> + I (prefix is C-s) to install plugins."
