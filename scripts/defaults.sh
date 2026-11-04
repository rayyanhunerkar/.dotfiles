#!/usr/bin/env bash
# macOS settings for a dev machine. Idempotent; safe to re-run.
#
#   scripts/defaults.sh            # user-level defaults (no sudo)
#   scripts/defaults.sh --system   # also Touch ID sudo, firewall, screen lock (sudo)
#
# Changes the live system and restarts Finder/SystemUIServer: run it when you
# mean to, not from install.sh.
set -euo pipefail

SYSTEM=0
[[ ${1:-} == --system ]] && SYSTEM=1

echo "keyboard and text input"
# Hold a key to repeat it (vim motions) instead of showing the accent picker.
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15
# "Smart" substitutions corrupt code pasted through text fields.
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

echo "finder"
defaults write -g AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# No .DS_Store litter on shares and USB drives.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo "homebrew analytics off"
command -v brew >/dev/null && brew analytics off

killall Finder SystemUIServer 2>/dev/null || true

if ((SYSTEM)); then
  echo "touch id for sudo (also inside tmux)"
  # sudo_local survives macOS updates; /etc/pam.d/sudo does not.
  # pam_reattach lets Touch ID work from tmux/zellij panes.
  REATTACH="$(brew --prefix 2>/dev/null)/lib/pam/pam_reattach.so"
  if [[ ! -f $REATTACH ]]; then
    brew install pam-reattach
  fi
  sudo tee /etc/pam.d/sudo_local >/dev/null <<EOF
# managed by ~/.dotfiles/scripts/defaults.sh
auth       optional       $REATTACH ignore_ssh
auth       sufficient     pam_tid.so
EOF

  echo "application firewall + stealth mode"
  FW=/usr/libexec/ApplicationFirewall/socketfilterfw
  sudo "$FW" --setglobalstate on >/dev/null
  sudo "$FW" --setstealthmode on >/dev/null

  echo "require password immediately after lock (prompts for your password)"
  sysadminctl -screenLock immediate -password -
fi

echo "done. some settings apply after logging out and back in."
