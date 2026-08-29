# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/rayyanhunerkar/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/rayyanhunerkar/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/rayyanhunerkar/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/rayyanhunerkar/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null && eval "$(pyenv init -)"

# NVM — lazy (sourcing it eagerly costs ~260ms)
export NVM_DIR="$HOME/.nvm"
_load_nvm() {
  unset -f nvm node npm npx 2>/dev/null
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
}
for _cmd in nvm node npm npx; do
  eval "${_cmd}() { _load_nvm; ${_cmd} \"\$@\"; }"
done
unset _cmd

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "/Users/rayyanhunerkar/.bun/_bun" ] && source "/Users/rayyanhunerkar/.bun/_bun"

# pnpm
export PNPM_HOME="/Users/rayyanhunerkar/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# uv/uvx completions — cached; regenerating both costs ~45ms per shell
_uv_comp="$HOME/.cache/zsh/uv-completions.zsh"
if command -v uv >/dev/null; then
  if [[ ! -s $_uv_comp || $commands[uv] -nt $_uv_comp ]]; then
    mkdir -p "${_uv_comp:h}"
    { uv generate-shell-completion zsh; uvx --generate-shell-completion zsh; } > "$_uv_comp"
  fi
  source "$_uv_comp"
fi
unset _uv_comp

# History
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_EXPIRE_DUPS_FIRST HIST_VERIFY

# Editor
export EDITOR="nvim"
export VISUAL="$EDITOR"
alias vim="nvim"
alias vi="nvim"

# Aliases
alias ff="fastfetch"
alias zeload="source $HOME/.zshrc"

# SDKMAN — lazy (sourcing it eagerly costs ~314ms)
export SDKMAN_DIR="$HOME/.sdkman"
_load_sdkman() {
  unset -f sdk java javac gradle mvn kotlin scala 2>/dev/null
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
}
for _cmd in sdk java javac gradle mvn kotlin scala; do
  eval "${_cmd}() { _load_sdkman; ${_cmd} \"\$@\"; }"
done
unset _cmd

#PLUGINS
source $HOME/.antidote/antidote.zsh
zsh_plugins=$HOME/.zsh_plugins
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle < ${zsh_plugins}.txt > ${zsh_plugins}.zsh
fi
source ${zsh_plugins}.zsh

# dotfiles scripts (set-font, set-theme) + their completions
export PATH="$HOME/.dotfiles/scripts:$PATH"
fpath=("$HOME/.config/zsh/completions" $fpath)

# compinit — full security scan only once a day, cached dump otherwise
autoload -Uz compinit
_zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ -n $_zcompdump(#qN.mh+24) ]]; then
  compinit -d "$_zcompdump"
  touch "$_zcompdump"
else
  compinit -C -d "$_zcompdump"
fi
unset _zcompdump

# Active theme's colors for the env-var tools (FZF_DEFAULT_OPTS, BAT_THEME,
# EZA_COLORS). Written by `set-theme`; must load before fzf reads its options.
[[ -f "$HOME/.config/zsh/current-theme.zsh" ]] && source "$HOME/.config/zsh/current-theme.zsh"

# fzf: CTRL-T (file finder) / ALT-C (cd finder) / CTRL-R (history, overrides
# zsh-fzf-history-search's binding above)
command -v fzf >/dev/null && source <(fzf --zsh)

# bat/eza (loaded after plugins so these win over OMZ's default ls alias)
command -v bat >/dev/null && alias cat="bat"
if command -v eza >/dev/null; then
  alias ls="eza --icons"
  alias ll="eza --icons -l"
  alias la="eza --icons -la"
  alias tree="eza --icons --tree"
fi

# dotfiles theme/font switchers (tab-completes; see .config/zsh/completions)
alias set-theme="set-theme.sh"
alias set-font="set-font.sh"

# zoxide must init near the end — it overrides `cd`, and anything sourced
# after it (plugins, other cd wrappers) would clobber that.
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd=cd)"

command -v oh-my-posh >/dev/null && \
  eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/current.omp.json)"

# Machine-local / private overrides (infra IPs, work aliases). Not tracked.
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
