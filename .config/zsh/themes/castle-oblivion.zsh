# castle-oblivion — colors for tools that read env vars (fzf, bat, eza).
# Copied to ~/.config/zsh/current-theme.zsh by `set-theme`; sourced from .zshrc.

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=rounded \
  --color=bg+:#4a4a56,bg:-1,spinner:#8fb89e,hl:#f0787e --color=fg:#9a9284,header:#f0787e,info:#d9b76a,pointer:#8fb89e --color=marker:#8fb89e,fg+:#f0ede4,prompt:#d9b76a,hl+:#f0787e --color=border:#4a4a56,gutter:-1"

export BAT_THEME="Coldark-Cold"

# di=dir  ln=symlink  ex=executable  *.md etc. Uses eza's own key syntax.
export EZA_COLORS="di=38;2;168;188;212\
:ln=38;2;143;184;158\
:ex=38;2;143;184;158\
:da=38;2;154;146;132\
:uu=38;2;154;146;132\
:gu=38;2;154;146;132"
