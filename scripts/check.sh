#!/usr/bin/env bash
# Read-only sanity check: nothing here writes to the working tree or touches live
# sessions. Generators run on a temp copy; themes seed into a temp HOME.
# Usage: scripts/check.sh
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT" || exit 1

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

failures=0
fail() {
  echo "  FAIL $*"
  failures=$((failures + 1))
}

echo "syntax: shell"
for f in install.sh scripts/*.sh .config/tmux/scripts/*.sh; do
  bash -n "$f" || fail "bash -n $f"
done
for f in zsh/.zshrc .config/zsh/themes/*.zsh; do
  zsh -n "$f" || fail "zsh -n $f"
done

echo "syntax: Brewfile, mise config"
ruby -c Brewfile >/dev/null || fail "ruby -c Brewfile"
if python3 -c 'import tomllib' 2>/dev/null; then
  python3 -c 'import sys, tomllib; tomllib.load(open(sys.argv[1], "rb"))' \
    .config/mise/config.toml || fail "toml .config/mise/config.toml"
else
  echo "  python3 < 3.11, mise config parse skipped"
fi

echo "syntax: json"
for f in .config/oh-my-posh/themes/*.json .config/oh-my-posh/shapes/*.json .config/oh-my-posh/palettes/*.json \
  .config/zed/palettes/*.json; do
  jq empty "$f" || fail "jq $f"
done

# kitty logs bad keys and carries on, so any output at all is a failure.
if command -v kitty >/dev/null; then
  echo "kitty: config, themes, fonts"
  out="$(kitty +runpy 'import sys; from kitty.config import load_config; load_config(*sys.argv[1:])' \
    .config/kitty/kitty.conf .config/kitty/themes/*.conf .config/kitty/fonts/*.conf 2>&1)"
  [ -z "$out" ] || fail "kitty: $out"

  # A wrong family name is not an error to kitty: it quietly falls back to Menlo.
  echo "kitty: every font resolves"
  for f in .config/kitty/fonts/*.conf; do
    out="$(kitty +runpy 'import sys; from kitty.config import load_config; from kitty.fonts.common import get_font_files; print(get_font_files(load_config(sys.argv[1])))' "$f" 2>&1)"
    if grep -qE 'not found|Menlo' <<<"$out"; then
      fail "kitty font not resolved (bad name or not installed): $f"
    fi
  done
else
  echo "kitty: not installed, skipped"
fi

# zellij reports a bad theme in its output, so look there as well as at the status.
if command -v zellij >/dev/null; then
  echo "zellij: config and every palette"
  ZCONF="$TMP/zellij"
  mkdir -p "$ZCONF/themes"
  cp .config/zellij/config.kdl "$ZCONF/"
  for f in .config/zellij/palettes/*.kdl; do
    cp "$f" "$ZCONF/themes/dotfiles.kdl"
    if ! out="$(zellij --config-dir "$ZCONF" --config "$ZCONF/config.kdl" setup --check 2>&1)" ||
      grep -qi 'error' <<<"$out"; then
      fail "zellij: $f"
    fi
  done
else
  echo "zellij: not installed, skipped"
fi

# --seed walks set-theme's own file table, so a tool added there is covered here.
echo "themes: every file present"
for f in .config/kitty/themes/*.conf; do
  name="$(basename "$f" .conf)"
  home="$TMP/home-$name"
  mkdir -p "$home"
  if ! out="$(HOME="$home" scripts/set-theme.sh --seed "$name" 2>&1)"; then
    fail "$name: seed failed: $out"
  elif [[ $out == *missing* ]]; then
    fail "$name: $out"
  fi
  [ -f ".config/oh-my-posh/palettes/$name.json" ] || fail "$name: no oh-my-posh palette"
  font="$(scripts/set-look.sh --font-for "$name")"
  [ -f ".config/kitty/fonts/$font.conf" ] || fail "$name: no paired font in set-look.sh"
done

echo "generators: no drift"
GEN="$TMP/repo"
GENERATED=(
  .config/nvim/themes
  .config/oh-my-posh/palettes
  .config/oh-my-posh/shapes
  .config/git/themes
  .config/zsh/themes
  .config/zellij/palettes
  .config/zed/palettes
)
mkdir -p "$GEN/.config/nvim"
cp -R scripts "$GEN/"
cp -R .config/kitty .config/oh-my-posh .config/git .config/zsh .config/zellij "$GEN/.config/"
cp -R .config/nvim/themes "$GEN/.config/nvim/"
for g in gen-theme-extras gen-nvim-themes gen-zed-themes gen-omp-shapes; do
  python3 "$GEN/scripts/$g.py" >/dev/null || fail "$g.py"
done
for d in "${GENERATED[@]}"; do
  diff -r "$d" "$GEN/$d" >/dev/null || fail "$d out of date: run the generators"
done

if [ "$failures" -gt 0 ]; then
  echo "$failures failed"
  exit 1
fi
echo "all good"
