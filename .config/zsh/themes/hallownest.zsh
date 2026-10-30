# hallownest — colors for tools that read env vars (fzf, bat, eza).
# Copied to ~/.config/zsh/current-theme.zsh by `set-theme`; sourced from .zshrc.

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=rounded \
  --color=bg+:#2a3040,bg:-1,spinner:#6fa3d8,hl:#d8524f --color=fg:#6d7890,header:#d8524f,info:#f08a3c,pointer:#6fa3d8 --color=marker:#7fb88a,fg+:#e9edf2,prompt:#f08a3c,hl+:#d8524f --color=border:#2a3040,gutter:-1"

export BAT_THEME="OneHalfDark"

# di=dir  ln=symlink  ex=executable  *.md etc. Uses eza's own key syntax.
export EZA_COLORS="di=38;2;143;227;220\
:ln=38;2;111;163;216\
:ex=38;2;127;184;138\
:da=38;2;109;120;144\
:uu=38;2;109;120;144\
:gu=38;2;109;120;144"
