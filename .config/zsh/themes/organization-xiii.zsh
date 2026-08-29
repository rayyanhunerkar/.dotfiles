# organization-xiii — colors for tools that read env vars (fzf, bat, eza).
# Copied to ~/.config/zsh/current-theme.zsh by `set-theme`; sourced from .zshrc.

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=rounded \
  --color=bg+:#2a2a30,bg:-1,spinner:#7fb0c9,hl:#c8102e --color=fg:#6a6a75,header:#c8102e,info:#b8bcc4,pointer:#7fb0c9 --color=marker:#7a9c8a,fg+:#e8e8ec,prompt:#b8bcc4,hl+:#c8102e --color=border:#2a2a30,gutter:-1"

export BAT_THEME="ansi"

# di=dir  ln=symlink  ex=executable  *.md etc. Uses eza's own key syntax.
export EZA_COLORS="di=38;2;46;92;138\
:ln=38;2;127;176;201\
:ex=38;2;122;156;138\
:da=38;2;106;106;117\
:uu=38;2;106;106;117\
:gu=38;2;106;106;117"
