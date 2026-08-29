#!/usr/bin/env bash
# Stow configs into ~/.config and bootstrap tmux plugins.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

# package `.config` folds into ~/.config (kitty, tmux, oh-my-posh, fastfetch, ...)
stow --dir "$PWD" --target "$HOME/.config" --restow .config

# tmux plugin manager (plugins are not vendored)
TPM="$HOME/.config/tmux/plugins/tpm"
if [ ! -d "$TPM" ]; then
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM"
fi

echo
echo "done. open tmux and press <prefix> + I (prefix is C-s) to install plugins."
echo "keep this in ~/.zshrc:"
echo '  eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/kingdom-hearts.omp.json)"'
