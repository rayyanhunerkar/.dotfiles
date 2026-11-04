"""Read a kitty theme and derive the editor palette shared by nvim and Zed.

The kitty themes carry the full 16-colour palette plus background and
foreground, so they are the single source of truth: editor colours are derived
here once rather than declared again per editor.
"""

import re


def parse(path):
    p = {}
    for line in open(path, encoding="utf-8"):  # noqa: SIM115
        m = re.match(
            r"^(background|foreground|cursor|selection_background|color\d+)\s+(#[0-9a-fA-F]{6})\s*$",
            line,
        )
        if m:
            p[m.group(1)] = m.group(2).lower()
    return p


def rgb(h):
    return tuple(int(h[i : i + 2], 16) for i in (1, 3, 5))


def hx(t):
    return "#{:02x}{:02x}{:02x}".format(*tuple(max(0, min(255, int(v))) for v in t))


def mix(a, b, t):
    """Blend a toward b by t (0..1)."""
    ra, rb = rgb(a), rgb(b)
    return hx(tuple(ra[i] + (rb[i] - ra[i]) * t for i in range(3)))


def is_dark(bg):
    r, g, b = rgb(bg)
    return (0.2126 * r + 0.7152 * g + 0.0722 * b) < 128


def palette(p):
    """Named editor colours from a parsed kitty theme. Returns (colours, dark)."""
    bg, fg = p["background"], p["foreground"]
    dark = is_dark(bg)
    # pull toward white on dark grounds, toward black on light ones
    toward = "#ffffff" if dark else "#000000"

    C = {
        "bg": bg,
        "fg": fg,
        "bg_alt": mix(bg, toward, 0.06),  # floats, statusline
        "bg_hl": mix(bg, toward, 0.10),  # cursorline
        "bg_sel": p.get("selection_background", mix(bg, toward, 0.20)),
        "border": mix(bg, toward, 0.22),
        "comment": mix(fg, bg, 0.45),
        "subtle": mix(fg, bg, 0.65),
        "black": p["color0"],
        "grey": p["color8"],
        "red": p["color1"],
        "red_b": p["color9"],
        "green": p["color2"],
        "green_b": p["color10"],
        "yellow": p["color3"],
        "yellow_b": p["color11"],
        "blue": p["color4"],
        "blue_b": p["color12"],
        "magenta": p["color5"],
        "magenta_b": p["color13"],
        "cyan": p["color6"],
        "cyan_b": p["color14"],
        "white": p["color7"],
        "white_b": p["color15"],
    }
    # diff/diagnostic washes
    C["diff_add"] = mix(bg, C["green"], 0.18)
    C["diff_del"] = mix(bg, C["red"], 0.18)
    C["diff_chg"] = mix(bg, C["blue"], 0.15)
    C["diff_txt"] = mix(bg, C["blue"], 0.30)
    C["sel_search"] = mix(bg, C["yellow"], 0.35)
    return C, dark
