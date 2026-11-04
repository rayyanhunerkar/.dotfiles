# black-gold — colors for tools that read env vars (fzf, bat, eza).
# Copied to ~/.config/zsh/current-theme.zsh by `set-theme`; sourced from .zshrc.

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=rounded \
  --color=bg+:#332a14,bg:-1,spinner:#d4af37,hl:#e5484d --color=fg:#8a7a52,header:#e5484d,info:#ff9f1c,pointer:#d4af37 --color=marker:#a3b86c,fg+:#f5ecd6,prompt:#ff9f1c,hl+:#e5484d --color=border:#332a14,gutter:-1"

export BAT_THEME="gruvbox-dark"

# di=dir  ln=symlink  ex=executable  *.md etc. Uses eza's own key syntax.
export EZA_COLORS="di=38;2;245;215;110\
:ln=38;2;212;175;55\
:ex=38;2;163;184;108\
:da=38;2;138;122;82\
:uu=38;2;138;122;82\
:gu=38;2;138;122;82"
