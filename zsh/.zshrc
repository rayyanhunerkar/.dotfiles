#!/usr/bin/env zsh
#
# ~/.zshrc — interactive shell configuration.
#
# LOAD ORDER MATTERS. The sections below are ordered deliberately:
#
#   1. PATH and runtimes   — must precede anything that probes for binaries
#   2. Options and history — cheap, no dependencies
#   3. Plugins (antidote)  — must precede compinit; adds to fpath
#   4. Completion          — compinit, then anything calling compdef
#   5. Theme and aliases   — after plugins, so ours win over plugin defaults
#   6. Prompt and cd       — zoxide/oh-my-posh last; they wrap cd and the prompt
#   7. Local overrides     — untracked, always last word
#
# Startup budget is ~0.3s. Runtimes come from mise, which costs a few ms.
# Measure before adding anything eager:
#
#   for i in 1 2 3; do /usr/bin/time zsh -ic exit; done

# Deduplicate PATH and fpath automatically — repeated `zeload` would otherwise
# keep appending the same entries.
typeset -U path fpath

# ═══════════════════════════════════════════════════════════ RUNTIMES ═══
# Order within this block decides which interpreter wins: later prepends to
# PATH take precedence.

# bun — the binary comes from mise; this is where `bun add -g` puts globals.
export BUN_INSTALL="$HOME/.bun"
path=("$BUN_INSTALL/bin" $path)
# `_bun` is a #compdef file: put its dir on fpath for compinit to pick up. Never
# `source` it — it runs its own compinit against an early, partial fpath, so
# every shell built .zcompdump twice and each build overwrote the other (~150ms).
[[ -s "$BUN_INSTALL/_bun" ]] && fpath=("$BUN_INSTALL" $fpath)

# pnpm — likewise, the global bin dir for `pnpm add -g`.
export PNPM_HOME="$HOME/Library/pnpm"
path=("$PNPM_HOME" $path)

# go — GOPATH/bin holds anything `go install`ed (dlv, staticcheck, sqlc, swag,
# gopls ...). Hardcoded rather than `$(go env GOPATH)` to avoid a subprocess on
# every shell start; this is the default location.
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
[[ -d $GOBIN ]] && path=("$GOBIN" $path)

# dotfiles helper scripts (set-theme, set-font)
path=("$HOME/.dotfiles/scripts" $path)

# podman
export PATH="/opt/podman/bin:$PATH"

# ~/.local/bin — standalone installers drop binaries here (claude, pre-commit via
# `uv tool`). Before mise, so a stray copy here never shadows a pinned version.
path=("$HOME/.local/bin" $path)

# mise: node, python, java, go, bun, pnpm, uv and pinned dev CLIs, per
# directory. Last in this block so its versions win. Config in
# ~/.config/mise/config.toml, overridden by a project's mise.toml.
#
# The shims dir goes on PATH as well as `activate`: shims are real executables,
# so nvim, LSP servers and mason find node/python even outside an interactive
# shell. `activate` then puts the exact per-directory versions ahead of them and
# sets JAVA_HOME and friends.
path=("$HOME/.local/share/mise/shims" $path)
command -v mise >/dev/null && eval "$(mise activate zsh)"

# ════════════════════════════════════════════════ OPTIONS & HISTORY ═══

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000 # must equal HISTSIZE or history truncates on save

setopt SHARE_HISTORY          # one history shared across live shells
setopt HIST_IGNORE_DUPS       # skip a command identical to the previous one
setopt HIST_IGNORE_SPACE      # a leading space keeps it out of history
setopt HIST_EXPIRE_DUPS_FIRST # drop duplicates first when trimming
setopt HIST_VERIFY            # expand !! for review instead of running blind
setopt HIST_REDUCE_BLANKS
setopt NO_BEEP
setopt INTERACTIVE_COMMENTS # allow # comments when typing commands

export EDITOR="nvim"
export VISUAL="$EDITOR"

# ══════════════════════════════════════════════════════════ PLUGINS ═══
# Must run before compinit — plugins add completion functions to fpath.

# Clone under ~/.local/share, NOT ~/Library/Caches: macOS purges that directory
# under disk pressure, which silently guts every plugin while the generated
# bundle still points at the deleted paths.
export ANTIDOTE_HOME="$HOME/.local/share/antidote"

[[ -f "$HOME/.antidote/antidote.zsh" ]] && source "$HOME/.antidote/antidote.zsh"
zsh_plugins="$HOME/.zsh_plugins"

# ── plugin settings that must be set BEFORE the bundle is sourced ─────────

# forgit: remap every alias to a `gf` (git-fzf) prefix. At defaults it defines
# ga/glo/gd/gco/grb/gcb/gss/gsp/gcf/grh — all of which the oh-my-zsh git plugin
# already owns, and forgit loads later so it would win silently.
forgit_add=gfa forgit_reset_head=gfrh
forgit_diff=gfd forgit_restore=gfrs
forgit_log=gfl forgit_revert_commit=gfrc
forgit_show=gfso forgit_reword=gfrw
forgit_ignore=gfi forgit_squash=gfsq
forgit_clean=gfclean forgit_fixup=gffu
forgit_blame=gfbl forgit_cherry_pick=gfcp
forgit_attributes=gfat forgit_rebase=gfrb
forgit_reflog=gfrl forgit_stash_push=gfsp
forgit_checkout_branch=gfcb forgit_stash_show=gfss
forgit_checkout_commit=gfco forgit_switch_branch=gfsw
forgit_checkout_file=gfcf forgit_branch_delete=gfbd
forgit_checkout_file_from_commit=gfcff
forgit_checkout_tag=gfct
forgit_worktree=gfwt forgit_worktree_add=gfwa
forgit_worktree_delete=gfwd

# you-should-use: print the reminder after the command output rather than
# before it, and only report the single best alias instead of every match.
export YSU_MESSAGE_POSITION="after"
export YSU_MODE=BESTMATCH
export YSU_HARDCORE=0 # nag, don't refuse to run the command

# Rebuild the static bundle when the plugin list changes, and also when the
# bundle references something no longer on disk — a timestamp check alone can't
# see that the clones were deleted out from under it.
() {
  if ((! $+functions[antidote])); then
    print -u2 "antidote missing, plugins not loaded: run ~/.dotfiles/install.sh"
    return
  fi
  local rebuild=0
  [[ ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]] || rebuild=1
  if ((! rebuild)); then
    local first_src=${${(f)"$(<${zsh_plugins}.zsh)"}[(r)source *]}
    [[ -n $first_src && -f ${(e)${first_src#source }//\"/} ]] || rebuild=1
  fi
  ((rebuild)) && antidote bundle <${zsh_plugins}.txt >${zsh_plugins}.zsh
}
[[ -f ${zsh_plugins}.zsh ]] && source ${zsh_plugins}.zsh

# ═══════════════════════════════════════════════════════ COMPLETION ═══

fpath=("$HOME/.config/zsh/completions" $fpath)

# NOTE: this deliberately runs a full compinit on every shell. Attempts to cache
# it with `compinit -C` start faster but silently drop ~250 completions —
# docker, go, node, bun, cmake, openssl,
# protoc, mvn among them — because `-C` trusts the dump and skips rescanning
# fpath, and something in the plugin chain (use-omz defers and wraps compinit)
# does not survive that. Correctness over speed until that is understood.
autoload -Uz compinit
compinit -d "${ZDOTDIR:-$HOME}/.zcompdump"

# Enabled after compinit: with EXTENDED_GLOB set beforehand, compinit finds
# fewer completion functions.
setopt EXTENDED_GLOB

# ═══════════════════════════════════════════════════ THEME & TOOLS ═══

# Active theme's colors for tools configured by env var (FZF_DEFAULT_OPTS,
# BAT_THEME, EZA_COLORS). Written by `set-theme`; must precede the fzf init,
# which reads FZF_DEFAULT_OPTS at load.
[[ -f "$HOME/.config/zsh/current-theme.zsh" ]] && source "$HOME/.config/zsh/current-theme.zsh"

# fzf: CTRL-T files, ALT-C directories, CTRL-R history.
command -v fzf >/dev/null && source <(fzf --zsh)

# direnv: per-directory environment. Auto-activates a uv `.venv` on cd, pins
# node per project, and keeps work-only vars out of unrelated shells. Needs an
# `.envrc` per project, approved once with `direnv allow`.
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# ══════════════════════════════════════════════════════════ ALIASES ═══
# After plugins on purpose — these must win over plugin-supplied defaults such
# as oh-my-zsh's `ls`.

# `exec zsh` rather than `source`: re-sourcing runs every init twice, which
# re-binds keys, re-evals the prompt, and makes oh-my-zsh's lib/giz.zsh print
# "_style=no" (it declares `local` at file scope; on the second pass typeset
# echoes the existing value). A fresh exec avoids the whole class of problem.
alias zeload="exec zsh"
alias ff="fastfetch"
alias vim="nvim"
alias vi="nvim"

# Theme/font switchers. Tab-complete via .config/zsh/completions.
alias set-theme="set-theme.sh"
alias set-font="set-font.sh"
alias set-prompt="set-prompt.sh"
alias set-look="set-look.sh"

command -v bat >/dev/null && alias cat="bat"
if command -v eza >/dev/null; then
  alias ls="eza --icons"
  alias ll="eza --icons -l"
  alias la="eza --icons -la"
  alias lt="eza --icons --tree --level=2"
  alias tree="eza --icons --tree"
fi

# ═══════════════════════════════════════════════════ PROMPT & JUMP ═══
# Last, and in this order: zoxide replaces `cd`, so anything sourced after it
# would clobber that. oh-my-posh owns the prompt and should see the final state.

command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd=cd)"

command -v oh-my-posh >/dev/null &&
  eval "$(oh-my-posh init zsh --config "$HOME/.config/oh-my-posh/current.omp.json")"

# ══════════════════════════════════════════════════ LOCAL OVERRIDES ═══
# Untracked: infra hostnames, work aliases, anything machine-specific.

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"


