# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

macOS dotfiles for a themed terminal stack, deployed with GNU stow. `README.md` holds the user-facing reference: theme palettes, keybindings, nvim language table.

There is no build or CI. Verify a change with `scripts/check.sh`: it parses shell, JSON, kitty and zellij config, confirms every theme has every file, and fails if generated files drifted from their sources. It writes nothing to the working tree. After running a generator, read `git diff` to confirm only the intended files changed.

## Deployment

Repo root must be `~/.dotfiles`. `./install.sh` runs `brew bundle`, restows, runs `mise install`, and seeds default `current-*` files; it is idempotent and never uninstalls.

Packages: `Brewfile` holds shell/terminal tools, CLIs, system libraries, apps and fonts. `.config/mise/config.toml` holds language runtimes and any CLI a project might pin; never add those to the Brewfile. `scripts/defaults.sh` changes live macOS settings: run it only when asked.

| Stow package | Target |
|---|---|
| `.config` | `~/.config` |
| `zsh`, `git`, `containers` | `~` |

Stow folds most of `~/.config/<tool>` into a symlink to this repo, so runtime `current-*` files land inside the working tree. They are gitignored, and `.gitignore` must gain a line for any new one. `~/.config/git` and `~/.config/containers` are real directories with individual links inside.

## Theme system

A theme is one basename across per-tool `themes/` dirs. `scripts/set-theme.sh` copies each to its `current-*` destination, then hands oh-my-posh to `set-prompt.sh` so a chosen shape survives the switch. A theme's existence is defined by its kitty file; other missing files are skipped with a warning. That copy table is the only list of theme files: `install.sh` and `check.sh` both use it through `set-theme.sh --seed`, which fills in missing files without reloading anything.

Generated files are tracked, so change the source and regenerate:

| Output | Source | Regenerate |
|---|---|---|
| `.config/nvim/themes/*.lua` | `.config/kitty/themes/*.conf` | `scripts/gen-nvim-themes.py` |
| `.config/zed/palettes/*.json` | `.config/kitty/themes/*.conf` | `scripts/gen-zed-themes.py` |
| `.config/oh-my-posh/palettes/*.json`, `.config/git/themes/*`, `.config/zsh/themes/*`, `.config/zellij/palettes/*.kdl` | theme table `T` in `scripts/gen-theme-extras.py` | `scripts/gen-theme-extras.py` |
| `.config/oh-my-posh/shapes/*.omp.json` | `scripts/gen-omp-shapes.py` | same script |

Handwritten per theme: kitty, tmux, oh-my-posh `themes/*.omp.json`, fastfetch.

The nvim and Zed generators share their kitty-to-editor color derivation in `scripts/kitty_palette.py`; change it there so both editors stay in step.

So a new theme takes the four handwritten files, an entry in `T`, all three theme generators, then a font pairing in `scripts/set-look.sh`. Shapes colour only through palette roles (`p:accent`, `p:warn`, ...) so every shape works with every theme; `set-prompt.sh` merges shape and palette with `jq`.

- `set-theme.sh`, `set-prompt.sh`, `set-font.sh` and `set-look.sh` change the user's live kitty, zellij, tmux and nvim sessions. zellij is the daily driver; it polls `themes/` and recolors running sessions by itself. Run them only when asked; prove a change with the generators and `git diff` instead.
- `set-theme` and friends are interactive aliases; scripts call the `.sh` names, which `.zshrc` puts on PATH.

## Shell

`zsh/.zshrc` section order is load-bearing and documented at the top of the file; place additions in the matching section. Machine-specific and work config goes in the untracked `~/.zshrc.local`.

## nvim

AstroNvim v6. Commit `lazy-lock.json` when plugin versions change.
