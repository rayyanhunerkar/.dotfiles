# dive-to-the-heart — colors for tools that read env vars (fzf, bat, eza).
# Copied to ~/.config/zsh/current-theme.zsh by `set-theme`; sourced from .zshrc.

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=rounded \
  --color=bg+:#2a3155,bg:-1,spinner:#35d0e0,hl:#e0566b --color=fg:#5a6699,header:#e0566b,info:#f2c14e,pointer:#35d0e0 --color=marker:#4bd6a8,fg+:#dfe6ff,prompt:#f2c14e,hl+:#e0566b --color=border:#2a3155,gutter:-1"

export BAT_THEME="Nord"

# di=dir  ln=symlink  ex=executable  *.md etc. Uses eza's own key syntax.
export EZA_COLORS="di=38;2;77;124;255\
:ln=38;2;53;208;224\
:ex=38;2;75;214;168\
:da=38;2;90;102;153\
:uu=38;2;90;102;153\
:gu=38;2;90;102;153"
