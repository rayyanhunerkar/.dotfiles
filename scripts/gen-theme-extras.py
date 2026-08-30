#!/usr/bin/env python3
"""Generate the git-color and shell-env (fzf/bat/eza) theme files."""
import os
D = os.path.expanduser('~/.dotfiles/.config')

# name -> palette + closest bat built-in theme
T = {
 'dive-to-the-heart': dict(
   bg='#0a0e27', fg='#dfe6ff', dim='#5a6699', line='#2a3155',
   accent='#35d0e0', alt='#4d7cff', warn='#f2c14e', bad='#e0566b',
   good='#4bd6a8', extra='#ff8fb2', bat='Nord'),
 'organization-xiii': dict(
   bg='#0b0b0d', fg='#e8e8ec', dim='#6a6a75', line='#2a2a30',
   accent='#7fb0c9', alt='#2e5c8a', warn='#b8bcc4', bad='#c8102e',
   good='#7a9c8a', extra='#6a6a75', bat='ansi'),
 'twilight-town': dict(
   bg='#1a1220', fg='#ffe4c4', dim='#7d6b8f', line='#3a2c47',
   accent='#4fd6be', alt='#c98fd8', warn='#ffc857', bad='#ff7a7a',
   good='#a8d96b', extra='#ff9e4f', bat='Dracula'),
 'castle-oblivion': dict(
   bg='#2b2b33', fg='#f0ede4', dim='#9a9284', line='#4a4a56',
   accent='#8fb89e', alt='#a8bcd4', warn='#d9b76a', bad='#f0787e',
   good='#8fb89e', extra='#c49ab4', bat='Coldark-Cold'),
 'erdtree': dict(
   bg='#14100c', fg='#e8dcc0', dim='#7a6b52', line='#3a3227',
   accent='#5aa8b8', alt='#d4a437', warn='#e8c56a', bad='#b83232',
   good='#7a8a52', extra='#8a6a9a', bat='gruvbox-dark'),
 'frutiger-aero': dict(
   bg='#04222e', fg='#e6f7ff', dim='#5f96aa', line='#174c60',
   accent='#2ee6d6', alt='#4db8ff', warn='#ffd93d', bad='#ff6b6b',
   good='#8ee84f', extra='#9d8df1', bat='Coldark-Dark'),
}

os.makedirs(f'{D}/git/themes', exist_ok=True)
os.makedirs(f'{D}/zsh/themes', exist_ok=True)

for name, p in T.items():
    # ---------------------------------------------------------- git colors ---
    with open(f'{D}/git/themes/{name}.gitconfig', 'w') as f:
        f.write(f"""# {name} — git colors. Copied to ~/.config/git/current-theme.gitconfig
# by `set-theme`; included from ~/.gitconfig.
[color]
\tui = auto

[color "diff"]
\tmeta = "{p['dim']}"
\tfrag = "{p['accent']}"
\tfunc = "{p['alt']}"
\told = "{p['bad']}"
\tnew = "{p['good']}"
\tcommit = "{p['warn']}"
\twhitespace = "reverse {p['bad']}"

[color "diff-highlight"]
\toldNormal = "{p['bad']}"
\toldHighlight = "{p['bad']} reverse"
\tnewNormal = "{p['good']}"
\tnewHighlight = "{p['good']} reverse"

[color "status"]
\theader = "{p['dim']}"
\tadded = "{p['good']}"
\tchanged = "{p['warn']}"
\tuntracked = "{p['bad']}"
\tbranch = "{p['accent']} bold"
\tnobranch = "{p['bad']}"
\tlocalBranch = "{p['accent']}"
\tremoteBranch = "{p['extra']}"

[color "branch"]
\tcurrent = "{p['accent']} bold"
\tlocal = "{p['fg']}"
\tremote = "{p['extra']}"
\tupstream = "{p['alt']}"

[color "decorate"]
\tbranch = "{p['accent']} bold"
\tremoteBranch = "{p['extra']}"
\ttag = "{p['warn']}"
\tstash = "{p['alt']}"
\tHEAD = "{p['accent']}"
""")

    # ------------------------------------------- shell env: fzf / bat / eza ---
    fzf = (
      f"--color=bg+:{p['line']},bg:-1,spinner:{p['accent']},hl:{p['bad']}"
      f" --color=fg:{p['dim']},header:{p['bad']},info:{p['warn']},pointer:{p['accent']}"
      f" --color=marker:{p['good']},fg+:{p['fg']},prompt:{p['warn']},hl+:{p['bad']}"
      f" --color=border:{p['line']},gutter:-1"
    )
    with open(f'{D}/zsh/themes/{name}.zsh', 'w') as f:
        f.write(f"""# {name} — colors for tools that read env vars (fzf, bat, eza).
# Copied to ~/.config/zsh/current-theme.zsh by `set-theme`; sourced from .zshrc.

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=rounded \\
  {fzf}"

export BAT_THEME="{p['bat']}"

# di=dir  ln=symlink  ex=executable  *.md etc. Uses eza's own key syntax.
export EZA_COLORS="di=38;2;{int(p['alt'][1:3],16)};{int(p['alt'][3:5],16)};{int(p['alt'][5:7],16)}\\
:ln=38;2;{int(p['accent'][1:3],16)};{int(p['accent'][3:5],16)};{int(p['accent'][5:7],16)}\\
:ex=38;2;{int(p['good'][1:3],16)};{int(p['good'][3:5],16)};{int(p['good'][5:7],16)}\\
:da=38;2;{int(p['dim'][1:3],16)};{int(p['dim'][3:5],16)};{int(p['dim'][5:7],16)}\\
:uu=38;2;{int(p['dim'][1:3],16)};{int(p['dim'][3:5],16)};{int(p['dim'][5:7],16)}\\
:gu=38;2;{int(p['dim'][1:3],16)};{int(p['dim'][3:5],16)};{int(p['dim'][5:7],16)}"
""")
    print(f"  {name}")
print("done")
