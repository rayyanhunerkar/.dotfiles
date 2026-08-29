# frutiger-aero — colors for tools that read env vars (fzf, bat, eza).
# Copied to ~/.config/zsh/current-theme.zsh by `set-theme`; sourced from .zshrc.

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=rounded \
  --color=bg+:#174c60,bg:-1,spinner:#2ee6d6,hl:#ff6b6b --color=fg:#5f96aa,header:#ff6b6b,info:#ffd93d,pointer:#2ee6d6 --color=marker:#8ee84f,fg+:#e6f7ff,prompt:#ffd93d,hl+:#ff6b6b --color=border:#174c60,gutter:-1"

export BAT_THEME="Coldark-Dark"

# di=dir  ln=symlink  ex=executable  *.md etc. Uses eza's own key syntax.
export EZA_COLORS="di=38;2;77;184;255\
:ln=38;2;46;230;214\
:ex=38;2;142;232;79\
:da=38;2;95;150;170\
:uu=38;2;95;150;170\
:gu=38;2;95;150;170"
