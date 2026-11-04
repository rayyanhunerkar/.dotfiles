#!/usr/bin/env python3
"""Generate the oh-my-posh prompt shapes.

A shape is structure only: it colours everything through palette roles (p:accent,
p:warn, ...) and carries no palette of its own. `set-prompt` merges one with the
active theme's palette, so every shape works with every theme.
"""

import json
import os

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DST = os.path.join(REPO, ".config/oh-my-posh/shapes")
os.makedirs(DST, exist_ok=True)

BRANCH, FOLDER, ROOT, CLOCK = "", "", "", ""
LANGS = [("node", ""), ("python", ""), ("golang", ""), ("rust", "")]

LANG_PROPS = {"fetch_version": True, "home_enabled": False, "display_mode": "files"}
EXEC_PROPS = {"threshold": 2000, "style": "austin"}
GIT_PROPS = {
    "branch_icon": BRANCH + " ",
    "fetch_status": True,
    "fetch_upstream_icon": True,
}
BARE_GIT = {"branch_icon": "", "fetch_status": True}

DIRTY = "{{ if or (.Working.Changed) (.Staging.Changed) }}"
UPDOWN = "{{ if gt .Behind 0 }} ↓{{ .Behind }}{{ end }}{{ if gt .Ahead 0 }} ↑{{ .Ahead }}{{ end }}"
PATH, HEAD, FULL, MS = "{{ .Path }}", "{{ .HEAD }}", "{{ .Full }}", "{{ .FormattedMs }}"
TIME = "{{ .CurrentDate | date .Format }}"


def seg(kind, fg, template, props=None, **extra):
    s = dict(type=kind, style="plain", foreground=f"p:{fg}", template=template, **extra)
    if props:
        s["properties"] = props
    return s


def clock():
    return seg("time", "dim", f" {TIME}", {"time_format": "15:04"})


def status(ch, role="accent", lead=""):
    return seg(
        "status",
        role,
        f"{lead}{{{{ if .Error }}}}<p:bad>{{{{ .Code }}}} {ch}</>{{{{ else }}}}<p:{role}>{ch}</>{{{{ end }}}}",
        {"always_enabled": True},
    )


def threaded(
    sep,
    path,
    git,
    lang="good",
    root="bad",
    ex="dim",
    style="folder",
    prompt="❯",
    icons=True,
    lead="",
):
    """Plain coloured text, every segment after the path introduced by `sep`."""
    segs = [
        seg("path", "fg", path, {"style": style}),
        seg("git", "accent", f"{sep} {git}", GIT_PROPS if icons else BARE_GIT),
    ]
    for kind, glyph in LANGS:
        segs.append(
            seg(kind, lang, f"{sep} {glyph + ' ' if icons else ''}{FULL}", LANG_PROPS)
        )
    segs += [
        seg("root", root, f"{sep} {ROOT}" if icons else f"{sep} root"),
        seg(
            "executiontime", ex, f"{sep} {CLOCK + ' ' if icons else ''}{MS}", EXEC_PROPS
        ),
    ]
    return [segs, [status(prompt, lead=lead)], [clock()]]


def run(left, right, icon=FOLDER, detached=False):
    """A row of filled blocks. `detached` gives each one its own caps."""

    def block(kind, bg, template, props=None, **extra):
        s = seg(kind, "bg", template, props, background=f"p:{bg}", **extra)
        if detached:
            s.update(style="diamond", leading_diamond=left, trailing_diamond=right)
        else:
            s.update(style="powerline", powerline_symbol=right)
        return s

    path = block("path", "accent", f" {icon} <b>{PATH}</b> ", {"style": "folder"})
    path.update(style="diamond", leading_diamond=left, trailing_diamond=right)
    path.pop("powerline_symbol", None)
    segs = [
        path,
        block(
            "git",
            "good",
            f" {HEAD}{UPDOWN} ",
            GIT_PROPS,
            background_templates=[f"{DIRTY}p:warn{{{{ end }}}}"],
        ),
    ]
    segs += [block(k, "alt", f" {g} {FULL} ", LANG_PROPS) for k, g in LANGS]
    segs += [
        block("root", "bad", f" {ROOT} "),
        block("executiontime", "extra", f" {CLOCK} {MS} ", EXEC_PROPS),
    ]
    return [segs, [status("❯")], [clock()]]


def bracketed():
    b = lambda s: f"<p:dim>[</>{s}<p:dim>]</>"
    segs = [
        seg("path", "fg", b(f"<b>{PATH}</b>"), {"style": "folder"}),
        seg(
            "git",
            "accent",
            " " + b(f"{HEAD}{DIRTY}<p:warn>*</>{{{{ end }}}}<p:alt>{UPDOWN}</>"),
            BARE_GIT,
        ),
    ]
    segs += [seg(k, "good", " " + b(FULL), LANG_PROPS) for k, _ in LANGS]
    segs += [
        seg("root", "bad", " " + b("root")),
        seg("executiontime", "extra", " " + b(MS), EXEC_PROPS),
    ]
    return [segs, [status(">")], [clock()]]


def prose():
    """Reads as a sentence: `.dotfiles on main via 22.1 took 5s`."""
    w = lambda s: f"<p:dim> {s}</>"
    segs = [
        seg("path", "accent", f"<b>{PATH}</b>", {"style": "folder"}),
        seg(
            "git",
            "alt",
            f"{w('on')} {BRANCH} {HEAD}{DIRTY}<p:warn>!</>{{{{ end }}}}{UPDOWN}",
            dict(BARE_GIT),
        ),
    ]
    segs += [seg(k, "good", f"{w('via')} {g} {FULL}", LANG_PROPS) for k, g in LANGS]
    segs += [
        seg("root", "bad", w("as") + " root"),
        seg("executiontime", "warn", f"{w('took')} {MS}", EXEC_PROPS),
    ]
    return [segs, [status("❯")], [clock()]]


def sparse():
    """One line. Path and prompt char on the left, everything else on the right."""
    left = [
        seg("path", "fg", f"<b>{PATH}</b>", {"style": "folder"}),
        seg("root", "bad", f" {ROOT}"),
        seg("executiontime", "dim", f" {MS}", EXEC_PROPS),
        status("◆", "fg", lead=" "),
    ]
    right = [
        seg(
            "git",
            "accent",
            f"{HEAD}{DIRTY}<p:warn> ◆</>{{{{ end }}}}<p:dim>{UPDOWN}</> ",
            BARE_GIT,
        )
    ]
    right += [seg(k, "dim", f"<p:line>·</> {FULL} ", LANG_PROPS) for k, _ in LANGS]
    right.append(seg("time", "dim", f"<p:line>·</> {TIME}", {"time_format": "15:04"}))
    return [left, None, right]


def framed():
    rail = "<p:dim>─</>"
    left, _, right = threaded(
        f" {rail}",
        f"<p:dim>╭─</><p:warn> {FOLDER} </><b>{PATH}</b>",
        f"{HEAD}{DIRTY}<p:warn> ●</>{{{{ end }}}}<p:extra>{UPDOWN}</>",
        style="agnoster_short",
    )
    left[0]["properties"]["max_depth"] = 3
    return [left, [status("❯", "warn", lead="<p:dim>╰─</>")], right]


SHAPES = {
    # text only
    "minimal": lambda: threaded(
        "",
        f"<b>{PATH}</b>",
        f"{HEAD}{DIRTY}<p:warn> ●</>{{{{ end }}}}<p:alt>{UPDOWN}</>",
    ),
    "stark": lambda: threaded(
        " <p:dim>—</>",
        f"<b>{PATH}</b>",
        f"{HEAD}{DIRTY}<p:bad> ·</>{{{{ end }}}}<p:dim>{UPDOWN}</>",
        lang="dim",
        prompt="»",
        icons=False,
    ),
    "tide": lambda: threaded(
        " <p:dim>≈</>",
        f"<p:warn>{FOLDER} </><b>{PATH}</b>",
        f"{HEAD}{DIRTY}<p:bad> ◆</>{{{{ end }}}}<p:alt>{UPDOWN}</>",
        ex="extra",
        prompt="≈❯",
    ),
    "brackets": bracketed,
    "prose": prose,
    "sparse": sparse,
    "framed": framed,
    # filled blocks
    "blocks": lambda: run("", ""),
    "capsules": lambda: run("", "", detached=True),
    "slant": lambda: run("", ""),
    "flame": lambda: run("", ""),
    "pixel": lambda: run("", ""),
}

for name, build in SHAPES.items():
    left, second, right = build()
    blocks = [{"type": "prompt", "alignment": "left", "segments": left}]
    if second:
        blocks.append(
            {"type": "prompt", "alignment": "left", "newline": True, "segments": second}  # type: ignore
        )
    blocks.append({"type": "rprompt", "alignment": "right", "segments": right})
    doc = {
        "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
        "version": 4,
        "final_space": True,
        "blocks": blocks,
    }
    with open(f"{DST}/{name}.omp.json", "w", encoding="utf-8") as f:
        json.dump(doc, f, indent=2, ensure_ascii=False)
        f.write("\n")
    print(f"  {name}")
print("done")
