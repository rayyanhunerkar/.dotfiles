# y2k-vaporwave — colors for tools that read env vars (fzf, bat, eza).
# Copied to ~/.config/zsh/current-theme.zsh by `set-theme`; sourced from .zshrc.

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=rounded \
  --color=bg+:#3b2670,bg:-1,spinner:#ff4fd8,hl:#ff5c7a --color=fg:#8d7abc,header:#ff5c7a,info:#ffd166,pointer:#ff4fd8 --color=marker:#5dfdbb,fg+:#f4ecff,prompt:#ffd166,hl+:#ff5c7a --color=border:#3b2670,gutter:-1"

export BAT_THEME="Dracula"

# di=dir  ln=symlink  ex=executable  *.md etc. Uses eza's own key syntax.
export EZA_COLORS="di=38;2;56;232;255\
:ln=38;2;255;79;216\
:ex=38;2;93;253;187\
:da=38;2;141;122;188\
:uu=38;2;141;122;188\
:gu=38;2;141;122;188"
