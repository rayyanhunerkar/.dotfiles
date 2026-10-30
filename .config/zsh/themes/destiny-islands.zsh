# destiny-islands — colors for tools that read env vars (fzf, bat, eza).
# Copied to ~/.config/zsh/current-theme.zsh by `set-theme`; sourced from .zshrc.

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=rounded \
  --color=bg+:#205355,bg:-1,spinner:#39c5bb,hl:#ff7f6a --color=fg:#6f9c97,header:#ff7f6a,info:#ffc93c,pointer:#39c5bb --color=marker:#7fd46a,fg+:#fbeed6,prompt:#ffc93c,hl+:#ff7f6a --color=border:#205355,gutter:-1"

export BAT_THEME="Solarized (dark)"

# di=dir  ln=symlink  ex=executable  *.md etc. Uses eza's own key syntax.
export EZA_COLORS="di=38;2;110;198;255\
:ln=38;2;57;197;187\
:ex=38;2;127;212;106\
:da=38;2;111;156;151\
:uu=38;2;111;156;151\
:gu=38;2;111;156;151"
