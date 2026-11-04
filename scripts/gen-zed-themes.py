#!/usr/bin/env python3
"""Generate Zed themes from the kitty theme files.

Same derivation as the nvim colorschemes (kitty_palette.py), and the syntax
roles mirror gen-nvim-themes.py, so a file reads the same in both editors.

Every output defines one theme named "Dotfiles". `set-theme` copies the chosen
one to ~/.config/zed/themes/dotfiles.json; Zed watches that directory and
recolors open windows, and settings.json selects "Dotfiles" by name.
"""

import glob
import json
import os

from kitty_palette import mix, palette, parse

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(REPO, ".config/kitty/themes")
DST = os.path.join(REPO, ".config/zed/palettes")
os.makedirs(DST, exist_ok=True)

CLEAR = "#00000000"


def a(color, alpha):
    """#rrggbb plus a two-digit hex alpha."""
    return color + alpha


def syn(color, italic=False, bold=False):
    s = {"color": color}
    if italic:
        s["font_style"] = "italic"
    if bold:
        s["font_weight"] = 700
    return s


def theme(name, k):
    C, dark = palette(k)
    bg = C["bg"]

    def status(color):
        return {"": color, ".background": mix(bg, color, 0.18), ".border": color}

    style = {
        "background.appearance": "opaque",
        "background": C["bg_alt"],
        "surface.background": C["bg_alt"],
        "elevated_surface.background": C["bg_alt"],
        "panel.background": C["bg_alt"],
        "border": C["border"],
        "border.variant": C["bg_hl"],
        "border.focused": C["cyan"],
        "border.selected": C["cyan"],
        "border.transparent": CLEAR,
        "border.disabled": C["bg_hl"],
        "element.background": C["bg_hl"],
        "element.hover": C["bg_hl"],
        "element.active": C["border"],
        "element.selected": a(C["bg_sel"], "33"),
        "element.disabled": C["bg_alt"],
        "ghost_element.background": CLEAR,
        "ghost_element.hover": C["bg_hl"],
        "ghost_element.active": C["border"],
        "ghost_element.selected": a(C["bg_sel"], "33"),
        "ghost_element.disabled": CLEAR,
        "drop_target.background": a(C["cyan"], "33"),
        "text": C["fg"],
        "text.muted": C["comment"],
        "text.placeholder": C["subtle"],
        "text.disabled": C["subtle"],
        "text.accent": C["cyan"],
        "icon": C["fg"],
        "icon.muted": C["comment"],
        "icon.disabled": C["subtle"],
        "icon.placeholder": C["subtle"],
        "icon.accent": C["cyan"],
        "link_text.hover": C["cyan"],
        "title_bar.background": C["bg_alt"],
        "title_bar.inactive_background": bg,
        "status_bar.background": C["bg_alt"],
        "toolbar.background": bg,
        "tab_bar.background": C["bg_alt"],
        "tab.inactive_background": C["bg_alt"],
        "tab.active_background": bg,
        "pane.focused_border": C["cyan"],
        "pane_group.border": C["border"],
        "panel.focused_border": C["cyan"],
        "panel.indent_guide": C["bg_hl"],
        "panel.indent_guide_active": C["border"],
        "panel.indent_guide_hover": C["subtle"],
        "search.match_background": C["sel_search"],
        "scrollbar.thumb.background": a(C["border"], "99"),
        "scrollbar.thumb.hover_background": C["border"],
        "scrollbar.thumb.border": CLEAR,
        "scrollbar.track.background": CLEAR,
        "scrollbar.track.border": CLEAR,
        # editor — matches nvim: CursorLine, CursorLineNr, LineNr, NonText
        "editor.foreground": C["fg"],
        "editor.background": bg,
        "editor.gutter.background": bg,
        "editor.subheader.background": C["bg_alt"],
        "editor.active_line.background": C["bg_hl"],
        "editor.highlighted_line.background": C["bg_hl"],
        "editor.line_number": C["subtle"],
        "editor.active_line_number": C["yellow"],
        "editor.invisible": C["border"],
        "editor.wrap_guide": C["bg_hl"],
        "editor.active_wrap_guide": C["border"],
        "editor.indent_guide": C["bg_hl"],
        "editor.indent_guide_active": C["border"],
        "editor.document_highlight.read_background": a(C["bg_sel"], "1a"),
        "editor.document_highlight.write_background": a(C["bg_sel"], "33"),
        "editor.document_highlight.bracket_background": a(C["bg_sel"], "26"),
        # terminal — the kitty palette itself, so Zed's terminal matches kitty
        "terminal.background": bg,
        "terminal.foreground": C["fg"],
        "terminal.bright_foreground": C["white_b"],
        "terminal.dim_foreground": C["comment"],
        "terminal.ansi.background": bg,
    }
    for ansi, key in (
        ("black", "black"),
        ("red", "red"),
        ("green", "green"),
        ("yellow", "yellow"),
        ("blue", "blue"),
        ("magenta", "magenta"),
        ("cyan", "cyan"),
        ("white", "white"),
    ):
        bright = "grey" if key == "black" else f"{key}_b"
        style[f"terminal.ansi.{ansi}"] = C[key]
        style[f"terminal.ansi.bright_{ansi}"] = C[bright]
        style[f"terminal.ansi.dim_{ansi}"] = mix(C[key], bg, 0.4)

    # diagnostics and VCS — same hues as nvim's Diagnostic* and GitSigns*
    for key, color in (
        ("error", C["red"]),
        ("warning", C["yellow"]),
        ("info", C["blue"]),
        ("hint", C["cyan"]),
        ("success", C["green"]),
        ("created", C["green"]),
        ("deleted", C["red"]),
        ("modified", C["blue"]),
        ("renamed", C["cyan"]),
        ("conflict", C["magenta"]),
        ("hidden", C["subtle"]),
        ("ignored", C["subtle"]),
        ("predictive", C["comment"]),
        ("unreachable", C["comment"]),
    ):
        for suffix, value in status(color).items():
            style[key + suffix] = value

    hues = ("cyan", "blue", "magenta", "yellow", "green", "red")
    style["accents"] = [C[h] for h in hues]
    style["players"] = [
        {"cursor": C[h], "background": C[h], "selection": a(C["bg_sel"] if h == "cyan" else C[h], "40")}
        for h in hues
    ]

    # syntax — mirrors the treesitter groups in gen-nvim-themes.py
    style["syntax"] = {
        "attribute": syn(C["magenta_b"]),
        "boolean": syn(C["magenta"], bold=True),
        "comment": syn(C["comment"], italic=True),
        "comment.doc": syn(C["comment"], italic=True),
        "constant": syn(C["magenta"]),
        "constructor": syn(C["yellow"]),
        "embedded": syn(C["fg"]),
        "emphasis": {"font_style": "italic"},
        "emphasis.strong": {"font_weight": 700},
        "enum": syn(C["yellow"]),
        "function": syn(C["blue"], bold=True),
        "function.builtin": syn(C["cyan"], bold=True),
        "function.method": syn(C["blue"]),
        "hint": syn(C["comment"], italic=True),
        "keyword": syn(C["red"], italic=True),
        "label": syn(C["cyan"]),
        "link_text": syn(C["blue"]),
        "link_uri": syn(C["cyan"]),
        "number": syn(C["magenta"]),
        "operator": syn(C["cyan"]),
        "predictive": syn(C["comment"], italic=True),
        "preproc": syn(C["yellow"]),
        "primary": syn(C["fg"]),
        "property": syn(C["cyan"]),
        "punctuation": syn(C["subtle"]),
        "punctuation.bracket": syn(C["subtle"]),
        "punctuation.delimiter": syn(C["subtle"]),
        "punctuation.list_marker": syn(C["red"]),
        "punctuation.special": syn(C["cyan"]),
        "string": syn(C["green"]),
        "string.escape": syn(C["cyan_b"]),
        "string.regex": syn(C["cyan_b"]),
        "string.special": syn(C["cyan"]),
        "string.special.symbol": syn(C["magenta"]),
        "tag": syn(C["red"]),
        "text.literal": syn(C["green"]),
        "title": syn(C["cyan"], bold=True),
        "type": syn(C["yellow"]),
        "type.builtin": syn(C["yellow"], italic=True),
        "variable": syn(C["fg"]),
        "variable.parameter": syn(C["magenta_b"]),
        "variable.special": syn(C["red"], italic=True),
        "variant": syn(C["yellow"]),
    }

    return {
        "$schema": "https://zed.dev/schema/themes/v0.2.0.json",
        "name": "dotfiles",
        "author": f"~/.dotfiles — generated from .config/kitty/themes/{name}.conf",
        "themes": [
            {"name": "Dotfiles", "appearance": "dark" if dark else "light", "style": style}
        ],
    }


for src in sorted(glob.glob(f"{SRC}/*.conf")):
    name = os.path.basename(src)[:-5]
    with open(f"{DST}/{name}.json", "w", encoding="utf-8") as f:
        json.dump(theme(name, parse(src)), f, indent=2)
        f.write("\n")
    print(f"  {name}")
print("done")
