#!/usr/bin/env bash
# Print the git branch (plus a dirty marker) for the active pane's directory,
# or nothing when it isn't a repo. Called from the tmux status bar.
#
# Takes the directory as $1 when given; otherwise asks tmux for the active
# pane's cwd. tmux does not reliably expand #{pane_current_path} inside #(),
# so the no-arg path is what the status bar actually uses.
set -uo pipefail

dir="${1:-}"
if [ -z "$dir" ] && command -v tmux >/dev/null; then
  dir=$(tmux display-message -p '#{pane_current_path}' 2>/dev/null)
fi
[ -n "$dir" ] && [ -d "$dir" ] || exit 0

branch=$(git -C "$dir" symbolic-ref --quiet --short HEAD 2>/dev/null) ||
  branch=$(git -C "$dir" rev-parse --short HEAD 2>/dev/null) ||
  exit 0

[ -n "$branch" ] || exit 0

# Any staged/unstaged/untracked change flips the marker.
if [ -n "$(git -C "$dir" status --porcelain 2>/dev/null | head -1)" ]; then
  printf ' %s ✦' "$branch"
else
  printf ' %s' "$branch"
fi
