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
# Startup budget is ~0.7s. `nvm` and `sdkman` are lazy because sourcing them
# eagerly cost ~570ms of that. Measure before adding anything eager:
#
#   for i in 1 2 3; do /usr/bin/time zsh -ic exit; done

# Deduplicate PATH and fpath automatically — repeated `zeload` would otherwise
# keep appending the same entries.
typeset -U path fpath

# ═══════════════════════════════════════════════════════════ RUNTIMES ═══
# Order within this block decides which interpreter wins: later prepends to
# PATH take precedence, so pyenv shadows conda by design.

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && path=("$PYENV_ROOT/bin" $path)
command -v pyenv >/dev/null && eval "$(pyenv init -)"

# bun
export BUN_INSTALL="$HOME/.bun"
path=("$BUN_INSTALL/bin" $path)
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
path=("$PNPM_HOME" $path)

# dotfiles helper scripts (set-theme, set-font)
path=("$HOME/.dotfiles/scripts" $path)

# ─────────────────────────────────────────────────────── lazy runtimes ───
# Each shim replaces itself with the real thing on first call. Sourcing these
# eagerly costs ~570ms combined, and most shells never touch them.

# Defines stub functions that source $2 on first invocation of any of $@.
_lazy_load() {
  local loader=$1 init=$2; shift 2
  local cmds=("$@") cmd
  eval "$loader() {
    unset -f ${cmds[*]} $loader 2>/dev/null
    $init
  }"
  for cmd in $cmds; do
    eval "$cmd() { $loader; $cmd \"\$@\"; }"
  done
}

export NVM_DIR="$HOME/.nvm"
_lazy_load _load_nvm '
  [ -s /opt/homebrew/opt/nvm/nvm.sh ] && . /opt/homebrew/opt/nvm/nvm.sh
  [ -s /opt/homebrew/opt/nvm/etc/bash_completion.d/nvm ] && . /opt/homebrew/opt/nvm/etc/bash_completion.d/nvm
' nvm node npm npx

export SDKMAN_DIR="$HOME/.sdkman"
_lazy_load _load_sdkman '
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
' sdk java javac gradle mvn kotlin scala

# ════════════════════════════════════════════════ OPTIONS & HISTORY ═══

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000          # must equal HISTSIZE or history truncates on save

setopt SHARE_HISTORY          # one history shared across live shells
setopt HIST_IGNORE_DUPS       # skip a command identical to the previous one
setopt HIST_IGNORE_SPACE      # a leading space keeps it out of history
setopt HIST_EXPIRE_DUPS_FIRST # drop duplicates first when trimming
setopt HIST_VERIFY            # expand !! for review instead of running blind
setopt HIST_REDUCE_BLANKS
setopt NO_BEEP
setopt INTERACTIVE_COMMENTS   # allow # comments when typing commands

export EDITOR="nvim"
export VISUAL="$EDITOR"

# ══════════════════════════════════════════════════════════ PLUGINS ═══
# Must run before compinit — plugins add completion functions to fpath.

# Clone under ~/.local/share, NOT ~/Library/Caches: macOS purges that directory
# under disk pressure, which silently guts every plugin while the generated
# bundle still points at the deleted paths.
export ANTIDOTE_HOME="$HOME/.local/share/antidote"

source "$HOME/.antidote/antidote.zsh"
zsh_plugins="$HOME/.zsh_plugins"

# Rebuild the static bundle when the plugin list changes, and also when the
# bundle references something no longer on disk — a timestamp check alone can't
# see that the clones were deleted out from under it.
() {
  local rebuild=0
  [[ ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]] || rebuild=1
  if (( ! rebuild )); then
    local first_src=${${(f)"$(<${zsh_plugins}.zsh)"}[(r)source *]}
    [[ -n $first_src && -f ${(e)${first_src#source }//\"/} ]] || rebuild=1
  fi
  (( rebuild )) && antidote bundle < ${zsh_plugins}.txt > ${zsh_plugins}.zsh
}
source ${zsh_plugins}.zsh

# ═══════════════════════════════════════════════════════ COMPLETION ═══

fpath=("$HOME/.config/zsh/completions" $fpath)

# NOTE: this deliberately runs a full compinit on every shell (~0.5s of the
# ~0.7s startup). Attempts to cache it with `compinit -C` cut startup to 0.19s
# but silently drop ~250 completions — docker, go, node, bun, cmake, openssl,
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

# fzf: CTRL-T files, ALT-C directories, CTRL-R history (overrides the binding
# from zsh-fzf-history-search loaded above).
command -v fzf >/dev/null && source <(fzf --zsh)

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
