# erdtree — colors for tools that read env vars (fzf, bat, eza).
# Copied to ~/.config/zsh/current-theme.zsh by `set-theme`; sourced from .zshrc.

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=rounded \
  --color=bg+:#3a3227,bg:-1,spinner:#5aa8b8,hl:#b83232 --color=fg:#7a6b52,header:#b83232,info:#e8c56a,pointer:#5aa8b8 --color=marker:#7a8a52,fg+:#e8dcc0,prompt:#e8c56a,hl+:#b83232 --color=border:#3a3227,gutter:-1"

export BAT_THEME="gruvbox-dark"

# di=dir  ln=symlink  ex=executable  *.md etc. Uses eza's own key syntax.
export EZA_COLORS="di=38;2;212;164;55\
:ln=38;2;90;168;184\
:ex=38;2;122;138;82\
:da=38;2;122;107;82\
:uu=38;2;122;107;82\
:gu=38;2;122;107;82"
