#!/usr/bin/env python3
"""Generate the git-color, shell-env (fzf/bat/eza) and prompt palette theme files."""

import json
import os

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
D = os.path.join(REPO, ".config")

# name -> palette + closest bat built-in theme
T = {
    "dive-to-the-heart": {
        "bg": "#0a0e27",
        "fg": "#dfe6ff",
        "dim": "#5a6699",
        "line": "#2a3155",
        "accent": "#35d0e0",
        "alt": "#4d7cff",
        "warn": "#f2c14e",
        "bad": "#e0566b",
        "good": "#4bd6a8",
        "extra": "#ff8fb2",
        "bat": "Nord",
    },
    "organization-xiii": {
        "bg": "#0b0b0d",
        "fg": "#e8e8ec",
        "dim": "#6a6a75",
        "line": "#2a2a30",
        "accent": "#7fb0c9",
        "alt": "#2e5c8a",
        "warn": "#b8bcc4",
        "bad": "#c8102e",
        "good": "#7a9c8a",
        "extra": "#6a6a75",
        "bat": "ansi",
    },
    "twilight-town": {
        "bg": "#1a1220",
        "fg": "#ffe4c4",
        "dim": "#7d6b8f",
        "line": "#3a2c47",
        "accent": "#4fd6be",
        "alt": "#c98fd8",
        "warn": "#ffc857",
        "bad": "#ff7a7a",
        "good": "#a8d96b",
        "extra": "#ff9e4f",
        "bat": "Dracula",
    },
    "castle-oblivion": {
        "bg": "#2b2b33",
        "fg": "#f0ede4",
        "dim": "#9a9284",
        "line": "#4a4a56",
        "accent": "#8fb89e",
        "alt": "#a8bcd4",
        "warn": "#d9b76a",
        "bad": "#f0787e",
        "good": "#8fb89e",
        "extra": "#c49ab4",
        "bat": "Coldark-Cold",
    },
    "erdtree": {
        "bg": "#14100c",
        "fg": "#e8dcc0",
        "dim": "#7a6b52",
        "line": "#3a3227",
        "accent": "#5aa8b8",
        "alt": "#d4a437",
        "warn": "#e8c56a",
        "bad": "#b83232",
        "good": "#7a8a52",
        "extra": "#8a6a9a",
        "bat": "gruvbox-dark",
    },
    "frutiger-aero": {
        "bg": "#04222e",
        "fg": "#e6f7ff",
        "dim": "#5f96aa",
        "line": "#174c60",
        "accent": "#2ee6d6",
        "alt": "#4db8ff",
        "warn": "#ffd93d",
        "bad": "#ff6b6b",
        "good": "#8ee84f",
        "extra": "#9d8df1",
        "bat": "Coldark-Dark",
    },
    "destiny-islands": {
        "bg": "#0a2b2e",
        "fg": "#fbeed6",
        "dim": "#6f9c97",
        "line": "#205355",
        "accent": "#39c5bb",
        "alt": "#6ec6ff",
        "warn": "#ffc93c",
        "bad": "#ff7f6a",
        "good": "#7fd46a",
        "extra": "#f6a6c1",
        "bat": "Solarized (dark)",
    },
    "caelid": {
        "bg": "#1a0c0a",
        "fg": "#f2d9c8",
        "dim": "#96695d",
        "line": "#4a211b",
        "accent": "#f0803c",
        "alt": "#e0608a",
        "warn": "#f2b45a",
        "bad": "#ff4f3f",
        "good": "#a8b04a",
        "extra": "#a98add",
        "bat": "Monokai Extended Origin",
    },
    "hallownest": {
        "bg": "#0c0e14",
        "fg": "#e9edf2",
        "dim": "#6d7890",
        "line": "#2a3040",
        "accent": "#6fa3d8",
        "alt": "#8fe3dc",
        "warn": "#f08a3c",
        "bad": "#d8524f",
        "good": "#7fb88a",
        "extra": "#a48fd0",
        "bat": "OneHalfDark",
    },
    "greenpath": {
        "bg": "#0b1410",
        "fg": "#e3efe2",
        "dim": "#6a8574",
        "line": "#26392d",
        "accent": "#8fcf6e",
        "alt": "#5fa8c4",
        "warn": "#e0b64f",
        "bad": "#d9625a",
        "good": "#57c7a0",
        "extra": "#b08fc7",
        "bat": "gruvbox-dark",
    },
    "crystal-peak": {
        "bg": "#15111c",
        "fg": "#f3e8f2",
        "dim": "#85759a",
        "line": "#3a2d4a",
        "accent": "#f27fc0",
        "alt": "#84dcdc",
        "warn": "#f2c078",
        "bad": "#e8566f",
        "good": "#7fd4b0",
        "extra": "#8fb4f0",
        "bat": "Dracula",
    },
    "castlevania": {
        "bg": "#120a10",
        "fg": "#efe3da",
        "dim": "#8f7482",
        "line": "#3e2230",
        "accent": "#e8455a",
        "alt": "#7fa6d6",
        "warn": "#eeb04a",
        "bad": "#ff7a66",
        "good": "#7fb08a",
        "extra": "#a77fd1",
        "bat": "Dracula",
    },
    "black-gold": {
        "bg": "#000000",
        "fg": "#f5ecd6",
        "dim": "#8a7a52",
        "line": "#332a14",
        "accent": "#d4af37",
        "alt": "#f5d76e",
        "warn": "#ff9f1c",
        "bad": "#e5484d",
        "good": "#a3b86c",
        "extra": "#dba392",
        "bat": "gruvbox-dark",
    },
    "y2k-vaporwave": {
        "bg": "#150a2e",
        "fg": "#f4ecff",
        "dim": "#8d7abc",
        "line": "#3b2670",
        "accent": "#ff4fd8",
        "alt": "#38e8ff",
        "warn": "#ffd166",
        "bad": "#ff5c7a",
        "good": "#5dfdbb",
        "extra": "#a77bff",
        "bat": "Dracula",
    },
}


def zellij_theme(name, p):
    """Component styles, not the 11-color palette: zellij paints the selected tab
    and pane frame from a legacy theme's `green`, so every theme came out green."""

    def style(node, base, background, emphasis):
        lines = [f"        {node} {{", f'            base "{p[base]}"']
        if background:
            lines.append(f'            background "{p[background]}"')
        lines += [
            f'            emphasis_{i} "{p[role]}"' for i, role in enumerate(emphasis)
        ]
        return lines + ["        }"]

    text = ("warn", "accent", "good", "extra")
    ribbon = ("bad", "warn", "extra", "alt")
    frame = ("warn", "alt", "extra", "good")
    players = ("accent", "alt", "extra", "warn", "good", "bad")

    body = []
    for node, base, background, emphasis in (
        ("text_unselected", "fg", "bg", text),
        ("text_selected", "fg", "line", text),
        ("ribbon_unselected", "fg", "line", ribbon),
        ("ribbon_selected", "bg", "accent", ribbon),
        ("table_title", "accent", "bg", text),
        ("table_cell_unselected", "fg", "bg", text),
        ("table_cell_selected", "fg", "line", text),
        ("list_unselected", "fg", "bg", text),
        ("list_selected", "fg", "line", text),
        ("frame_unselected", "line", None, frame),
        ("frame_selected", "accent", None, frame),
        ("frame_highlight", "warn", None, ("extra", "accent", "warn", "bad")),
        ("exit_code_success", "good", None, frame),
        ("exit_code_error", "bad", None, frame),
    ):
        body += style(node, base, background, emphasis)

    body.append("        multiplayer_user_colors {")
    body += [
        f'            player_{i + 1} "{p[players[i % len(players)]]}"'
        for i in range(10)
    ]
    body.append("        }")

    return (
        f"// {name} — zellij colors. Copied to ~/.config/zellij/themes/dotfiles.kdl\n"
        "// by `set-theme`, and zellij reloads that directory on its own.\n"
        "// Always named `dotfiles`, the name config.kdl selects.\n"
        "themes {\n    dotfiles {\n" + "\n".join(body) + "\n    }\n}\n"
    )


os.makedirs(f"{D}/git/themes", exist_ok=True)
os.makedirs(f"{D}/zsh/themes", exist_ok=True)
os.makedirs(f"{D}/oh-my-posh/palettes", exist_ok=True)
os.makedirs(f"{D}/zellij/palettes", exist_ok=True)

for name, p in T.items():
    # ------------------------------------------------- oh-my-posh palette ---
    with open(f"{D}/oh-my-posh/palettes/{name}.json", "w") as f:
        json.dump({k: v for k, v in p.items() if k != "bat"}, f, indent=2)
        f.write("\n")

    # -------------------------------------------------------------- zellij ---
    with open(f"{D}/zellij/palettes/{name}.kdl", "w") as f:
        f.write(zellij_theme(name, p))

    # ---------------------------------------------------------- git colors ---
    with open(f"{D}/git/themes/{name}.gitconfig", "w") as f:
        f.write(f"""# {name} — git colors. Copied to ~/.config/git/current-theme.gitconfig
# by `set-theme`; included from ~/.gitconfig.
[color]
\tui = auto

[color "diff"]
\tmeta = "{p["dim"]}"
\tfrag = "{p["accent"]}"
\tfunc = "{p["alt"]}"
\told = "{p["bad"]}"
\tnew = "{p["good"]}"
\tcommit = "{p["warn"]}"
\twhitespace = "reverse {p["bad"]}"

[color "diff-highlight"]
\toldNormal = "{p["bad"]}"
\toldHighlight = "{p["bad"]} reverse"
\tnewNormal = "{p["good"]}"
\tnewHighlight = "{p["good"]} reverse"

[color "status"]
\theader = "{p["dim"]}"
\tadded = "{p["good"]}"
\tchanged = "{p["warn"]}"
\tuntracked = "{p["bad"]}"
\tbranch = "{p["accent"]} bold"
\tnobranch = "{p["bad"]}"
\tlocalBranch = "{p["accent"]}"
\tremoteBranch = "{p["extra"]}"

[color "branch"]
\tcurrent = "{p["accent"]} bold"
\tlocal = "{p["fg"]}"
\tremote = "{p["extra"]}"
\tupstream = "{p["alt"]}"

[color "decorate"]
\tbranch = "{p["accent"]} bold"
\tremoteBranch = "{p["extra"]}"
\ttag = "{p["warn"]}"
\tstash = "{p["alt"]}"
\tHEAD = "{p["accent"]}"
""")

    # ------------------------------------------- shell env: fzf / bat / eza ---
    fzf = (
        f"--color=bg+:{p['line']},bg:-1,spinner:{p['accent']},hl:{p['bad']}"
        f" --color=fg:{p['dim']},header:{p['bad']},info:{p['warn']},pointer:{p['accent']}"
        f" --color=marker:{p['good']},fg+:{p['fg']},prompt:{p['warn']},hl+:{p['bad']}"
        f" --color=border:{p['line']},gutter:-1"
    )
    with open(f"{D}/zsh/themes/{name}.zsh", "w") as f:
        f.write(f"""# {name} — colors for tools that read env vars (fzf, bat, eza).
# Copied to ~/.config/zsh/current-theme.zsh by `set-theme`; sourced from .zshrc.

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=rounded \\
  {fzf}"

export BAT_THEME="{p["bat"]}"

# di=dir  ln=symlink  ex=executable  *.md etc. Uses eza's own key syntax.
export EZA_COLORS="di=38;2;{int(p["alt"][1:3], 16)};{int(p["alt"][3:5], 16)};{int(p["alt"][5:7], 16)}\\
:ln=38;2;{int(p["accent"][1:3], 16)};{int(p["accent"][3:5], 16)};{int(p["accent"][5:7], 16)}\\
:ex=38;2;{int(p["good"][1:3], 16)};{int(p["good"][3:5], 16)};{int(p["good"][5:7], 16)}\\
:da=38;2;{int(p["dim"][1:3], 16)};{int(p["dim"][3:5], 16)};{int(p["dim"][5:7], 16)}\\
:uu=38;2;{int(p["dim"][1:3], 16)};{int(p["dim"][3:5], 16)};{int(p["dim"][5:7], 16)}\\
:gu=38;2;{int(p["dim"][1:3], 16)};{int(p["dim"][3:5], 16)};{int(p["dim"][5:7], 16)}"
""")
    print(f"  {name}")
print("done")
