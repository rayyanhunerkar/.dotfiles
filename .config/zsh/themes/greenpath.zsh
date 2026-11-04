# greenpath — colors for tools that read env vars (fzf, bat, eza).
# Copied to ~/.config/zsh/current-theme.zsh by `set-theme`; sourced from .zshrc.

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=rounded \
  --color=bg+:#26392d,bg:-1,spinner:#8fcf6e,hl:#d9625a --color=fg:#6a8574,header:#d9625a,info:#e0b64f,pointer:#8fcf6e --color=marker:#57c7a0,fg+:#e3efe2,prompt:#e0b64f,hl+:#d9625a --color=border:#26392d,gutter:-1"

export BAT_THEME="gruvbox-dark"

# di=dir  ln=symlink  ex=executable  *.md etc. Uses eza's own key syntax.
export EZA_COLORS="di=38;2;95;168;196\
:ln=38;2;143;207;110\
:ex=38;2;87;199;160\
:da=38;2;106;133;116\
:uu=38;2;106;133;116\
:gu=38;2;106;133;116"
