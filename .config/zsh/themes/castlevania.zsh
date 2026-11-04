# castlevania — colors for tools that read env vars (fzf, bat, eza).
# Copied to ~/.config/zsh/current-theme.zsh by `set-theme`; sourced from .zshrc.

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=rounded \
  --color=bg+:#3e2230,bg:-1,spinner:#e8455a,hl:#ff7a66 --color=fg:#8f7482,header:#ff7a66,info:#eeb04a,pointer:#e8455a --color=marker:#7fb08a,fg+:#efe3da,prompt:#eeb04a,hl+:#ff7a66 --color=border:#3e2230,gutter:-1"

export BAT_THEME="Dracula"

# di=dir  ln=symlink  ex=executable  *.md etc. Uses eza's own key syntax.
export EZA_COLORS="di=38;2;127;166;214\
:ln=38;2;232;69;90\
:ex=38;2;127;176;138\
:da=38;2;143;116;130\
:uu=38;2;143;116;130\
:gu=38;2;143;116;130"
