# dotfiles

Kingdom Hearts — *Dive to the Heart* theme across the terminal stack.

| Tool | Path | Notes |
|------|------|-------|
| kitty | `.config/kitty/` | `kitty.conf` includes `kingdom-hearts.conf`; `base2_dark.conf` kept as an alt theme |
| tmux | `.config/tmux/` | tpm + tmux-dotbar, KH-colored status bar. Plugins are **not** vendored |
| oh-my-posh | `.config/oh-my-posh/kingdom-hearts.omp.json` | wired in `~/.zshrc` |
| fastfetch | `.config/fastfetch/` | `config.jsonc` + `ascii.txt` |

## Palette

```
bg   #0a0e27   fg    #dfe6ff
blue #4d7cff   cyan  #35d0e0
gold #f2c14e   pink  #ff8fb2   red #e0566b
```

## Install

Managed with [GNU stow](https://www.gnu.org/software/stow/). Repo root is `~/.dotfiles`;
the `.config` package folds into `~/.config`.

```sh
git clone <repo> ~/.dotfiles
~/.dotfiles/install.sh          # stow --restow .config  +  clone tpm
```

Or by hand:

```sh
cd ~/.dotfiles && stow -t ~/.config .config
```

Then open tmux and press `<prefix> + I` (prefix is `C-s`) to install plugins.

Add to `~/.zshrc`:

```sh
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/kingdom-hearts.omp.json)"
```

## Notes

- Assumes Apple Silicon Homebrew (`/opt/homebrew`) — referenced in `tmux.conf` and `kitty.conf`.
- Needs a Nerd Font (JetBrainsMono Nerd Font).
- `alacritty` / `helix` / `wezterm` / `spaceship` / `lvim` configs stay on disk but are gitignored.
