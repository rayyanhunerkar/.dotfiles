# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

macOS dotfiles for a themed terminal stack, deployed with GNU stow. `README.md` holds the user-facing reference: theme palettes, keybindings, nvim language table.

There is no build, test suite or CI. Verify a change by parsing what you touched (`jq . file.json`, `bash -n`, `zsh -n`), and after running a generator, read `git diff` to confirm only the intended files changed.

## Deployment

Repo root must be `~/.dotfiles`. `./install.sh` restows and seeds default `current-*` files; it is idempotent.

| Stow package | Target |
|---|---|
| `.config` | `~/.config` |
| `zsh`, `git`, `containers` | `~` |

Stow folds most of `~/.config/<tool>` into a symlink to this repo, so runtime `current-*` files land inside the working tree. They are gitignored, and `.gitignore` must gain a line for any new one. `~/.config/git` and `~/.config/containers` are real directories with individual links inside.

## Theme system

A theme is one basename across per-tool `themes/` dirs. `scripts/set-theme.sh` copies each to its `current-*` destination, then hands oh-my-posh to `set-prompt.sh` so a chosen shape survives the switch. A theme's existence is defined by its kitty file; other missing files are skipped with a warning.

Generated files are tracked, so change the source and regenerate:

| Output | Source | Regenerate |
|---|---|---|
| `.config/nvim/themes/*.lua` | `.config/kitty/themes/*.conf` | `scripts/gen-nvim-themes.py` |
| `.config/oh-my-posh/palettes/*.json`, `.config/git/themes/*`, `.config/zsh/themes/*` | theme table `T` in `scripts/gen-theme-extras.py` | `scripts/gen-theme-extras.py` |
| `.config/oh-my-posh/shapes/*.omp.json` | `scripts/gen-omp-shapes.py` | same script |

Handwritten per theme: kitty, tmux, oh-my-posh `themes/*.omp.json`, fastfetch.

So a new theme takes the four handwritten files, an entry in `T`, then both theme generators. Shapes colour only through palette roles (`p:accent`, `p:warn`, ...) so every shape works with every theme; `set-prompt.sh` merges shape and palette with `jq`.

- Generators hardcode `~/.dotfiles`, so they write to the main checkout even when run from a git worktree.
- `set-theme.sh`, `set-prompt.sh` and `set-font.sh` change the user's live kitty, tmux and nvim sessions. Run them only when asked; prove a change with the generators and `git diff` instead.
- `set-theme` and friends are interactive aliases; scripts call the `.sh` names, which `.zshrc` puts on PATH.

## Shell

`zsh/.zshrc` section order is load-bearing and documented at the top of the file; place additions in the matching section. Machine-specific and work config goes in the untracked `~/.zshrc.local`.

## nvim

AstroNvim v6. A file in `.config/nvim/lua/` starting with `if true then return {} end` is an inert template stub; delete that line to activate it. Commit `lazy-lock.json` when plugin versions change.
