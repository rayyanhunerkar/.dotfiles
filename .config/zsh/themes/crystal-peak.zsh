# crystal-peak — colors for tools that read env vars (fzf, bat, eza).
# Copied to ~/.config/zsh/current-theme.zsh by `set-theme`; sourced from .zshrc.

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=rounded \
  --color=bg+:#3a2d4a,bg:-1,spinner:#f27fc0,hl:#e8566f --color=fg:#85759a,header:#e8566f,info:#f2c078,pointer:#f27fc0 --color=marker:#7fd4b0,fg+:#f3e8f2,prompt:#f2c078,hl+:#e8566f --color=border:#3a2d4a,gutter:-1"

export BAT_THEME="Dracula"

# di=dir  ln=symlink  ex=executable  *.md etc. Uses eza's own key syntax.
export EZA_COLORS="di=38;2;132;220;220\
:ln=38;2;242;127;192\
:ex=38;2;127;212;176\
:da=38;2;133;117;154\
:uu=38;2;133;117;154\
:gu=38;2;133;117;154"
