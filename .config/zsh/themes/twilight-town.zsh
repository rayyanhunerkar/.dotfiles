# twilight-town — colors for tools that read env vars (fzf, bat, eza).
# Copied to ~/.config/zsh/current-theme.zsh by `set-theme`; sourced from .zshrc.

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=rounded \
  --color=bg+:#3a2c47,bg:-1,spinner:#4fd6be,hl:#ff7a7a --color=fg:#7d6b8f,header:#ff7a7a,info:#ffc857,pointer:#4fd6be --color=marker:#a8d96b,fg+:#ffe4c4,prompt:#ffc857,hl+:#ff7a7a --color=border:#3a2c47,gutter:-1"

export BAT_THEME="Dracula"

# di=dir  ln=symlink  ex=executable  *.md etc. Uses eza's own key syntax.
export EZA_COLORS="di=38;2;201;143;216\
:ln=38;2;79;214;190\
:ex=38;2;168;217;107\
:da=38;2;125;107;143\
:uu=38;2;125;107;143\
:gu=38;2;125;107;143"
