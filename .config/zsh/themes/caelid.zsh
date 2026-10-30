# caelid — colors for tools that read env vars (fzf, bat, eza).
# Copied to ~/.config/zsh/current-theme.zsh by `set-theme`; sourced from .zshrc.

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=rounded \
  --color=bg+:#4a211b,bg:-1,spinner:#f0803c,hl:#ff4f3f --color=fg:#96695d,header:#ff4f3f,info:#f2b45a,pointer:#f0803c --color=marker:#a8b04a,fg+:#f2d9c8,prompt:#f2b45a,hl+:#ff4f3f --color=border:#4a211b,gutter:-1"

export BAT_THEME="Monokai Extended Origin"

# di=dir  ln=symlink  ex=executable  *.md etc. Uses eza's own key syntax.
export EZA_COLORS="di=38;2;224;96;138\
:ln=38;2;240;128;60\
:ex=38;2;168;176;74\
:da=38;2;150;105;93\
:uu=38;2;150;105;93\
:gu=38;2;150;105;93"
