#!/usr/bin/env bash
# Stow configs into ~/.config and bootstrap tmux plugins.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

# package `.config` folds into ~/.config (kitty, tmux, oh-my-posh, fastfetch, ...)
stow --dir "$PWD" --target "$HOME/.config" --restow .config

# package `zsh` links .zshrc / .zsh_plugins.txt into $HOME
stow --dir "$PWD" --target "$HOME" --restow zsh

# package `git` links .gitconfig / .gitconfig-work into $HOME
stow --dir "$PWD" --target "$HOME" --restow git

# default font (gitignored; scripts/set-font.sh swaps it)
CURRENT_FONT="$HOME/.config/kitty/current-font.conf"
[ -f "$CURRENT_FONT" ] || cp "$PWD/.config/kitty/fonts/jetbrains-mono.conf" "$CURRENT_FONT"

# default theme (gitignored; scripts/set-theme.sh swaps it)
[ -f "$HOME/.config/kitty/current-theme.conf" ] || cp "$PWD/.config/kitty/themes/dive-to-the-heart.conf" "$HOME/.config/kitty/current-theme.conf"
[ -f "$HOME/.config/tmux/current-theme.conf" ] || cp "$PWD/.config/tmux/themes/dive-to-the-heart.conf" "$HOME/.config/tmux/current-theme.conf"
[ -f "$HOME/.config/oh-my-posh/current.omp.json" ] || cp "$PWD/.config/oh-my-posh/themes/dive-to-the-heart.omp.json" "$HOME/.config/oh-my-posh/current.omp.json"
[ -f "$HOME/.config/fastfetch/config.jsonc" ] || cp "$PWD/.config/fastfetch/themes/dive-to-the-heart.jsonc" "$HOME/.config/fastfetch/config.jsonc"
mkdir -p "$HOME/.config/git" "$HOME/.config/zsh"
[ -f "$HOME/.config/git/current-theme.gitconfig" ] || cp "$PWD/.config/git/themes/dive-to-the-heart.gitconfig" "$HOME/.config/git/current-theme.gitconfig"
[ -f "$HOME/.config/zsh/current-theme.zsh" ] || cp "$PWD/.config/zsh/themes/dive-to-the-heart.zsh" "$HOME/.config/zsh/current-theme.zsh"
mkdir -p "$PWD/.config/nvim/colors"
[ -f "$PWD/.config/nvim/colors/dotfiles.lua" ] || cp "$PWD/.config/nvim/themes/dive-to-the-heart.lua" "$PWD/.config/nvim/colors/dotfiles.lua"

# tmux plugin manager (plugins are not vendored)
TPM="$HOME/.config/tmux/plugins/tpm"
if [ ! -d "$TPM" ]; then
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM"
fi

echo
echo "done. open tmux and press <prefix> + I (prefix is C-s) to install plugins."
echo "keep this in ~/.zshrc:"
echo '  eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/current.omp.json)"'
