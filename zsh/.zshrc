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
eval "$(pyenv init -)"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

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

eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

eval "$(zoxide init zsh --cmd=cd)"


export CERT="$HOME/Workspace/Morfius/certs"
export DEV_IP="150.136.227.224"
export VPN_IP="132.145.187.226"

# History
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_EXPIRE_DUPS_FIRST HIST_VERIFY

# Aliases
alias ff="fastfetch"
alias zeload="source $HOME/.zshrc"
alias ssh_dev="ssh -i $CERT/ssh-key-2024-01-15.key opc@$DEV_IP"
alias ssh_vpn="ssh -i $CERT/vpn.key ubuntu@$VPN_IP"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

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

autoload -Uz compinit && compinit

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

eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/current.omp.json)"
