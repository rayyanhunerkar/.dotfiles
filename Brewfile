# Machine-level packages. Language runtimes and project-pinned dev CLIs live in
# .config/mise/config.toml instead — don't add node/python/go/java/terraform here.
#
#   brew bundle --file ~/.dotfiles/Brewfile            # install what's missing
#   brew bundle cleanup --file ~/.dotfiles/Brewfile    # list what isn't declared
#   brew bundle cleanup --file ~/.dotfiles/Brewfile --force   # ...and remove it
#
# Rule of thumb: brew owns what the terminal, shell and editor need at login,
# system libraries, and GUI apps. mise owns anything a project might pin.

# Third-party taps. brew refuses to read an untrusted tap, which also hides its
# formulae from `brew leaves`; `brew trust <tap>` once per machine.
tap "jandedobbeleer/oh-my-posh"
tap "anomalyco/tap"
tap "antoniorodr/memo"
tap "bagonyi/formulae"
tap "nats-io/nats-tools"
tap "steipete/tap"
tap "yakitrak/yakitrak"

# ── shell and terminal ────────────────────────────────────────────────────
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "jandedobbeleer/oh-my-posh/oh-my-posh"
brew "tmux"
brew "zellij"
brew "neovim"
brew "stow"
brew "mise"
brew "direnv"
brew "fzf"
brew "zoxide"
brew "fastfetch"

# ── everyday CLI ──────────────────────────────────────────────────────────
brew "bat"
brew "btop"
brew "eza"
brew "fd"
brew "ripgrep"
brew "jq"
brew "tree"
brew "wget"
brew "aria2"
brew "grep"
brew "git"
brew "gh"
brew "lazygit"
brew "dive"
brew "mole"
brew "luarocks" # nvim plugins build with it
brew "pam-reattach" # Touch ID sudo inside tmux; wired by scripts/defaults.sh --system
brew "anomalyco/tap/opencode"
brew "antoniorodr/memo/memo"         # Apple Notes CLI
brew "steipete/tap/imsg"             # iMessage CLI
brew "yakitrak/yakitrak/notesmd-cli" # formerly obsidian-cli
brew "nats-io/nats-tools/nats"
brew "bagonyi/formulae/leveldb@1.22"

# ── cloud and infra ───────────────────────────────────────────────────────
brew "awscli"
brew "azure-cli"
brew "docker-compose"
brew "golang-migrate" # not in mise's registry
brew "helmify"        # not in mise's registry
brew "nats-server"
brew "unbound"
brew "gogcli"

# ── media, documents, OCR ─────────────────────────────────────────────────
brew "ffmpeg"
brew "yt-dlp"
brew "pandoc"
brew "poppler"
brew "tesseract"
brew "clang-format"

# ── Apple platform (need Xcode alongside) ─────────────────────────────────
brew "cocoapods"
brew "ios-deploy"
brew "xcodegen"
brew "libimobiledevice"

# ── apps ──────────────────────────────────────────────────────────────────
cask "kitty"
cask "gcloud-cli"
cask "iina"
cask "libreoffice"
cask "maccy"
cask "obs"
cask "obsidian"
brew "nicotine-plus" # GTK app, a formula not a cask
cask "zed"

# ── fonts (paired with themes in scripts/set-look.sh) ─────────────────────
cask "font-jetbrains-mono-nerd-font"
cask "font-blex-mono-nerd-font"
cask "font-departure-mono-nerd-font"
cask "font-fantasque-sans-mono-nerd-font"
cask "font-maple-mono-nf"
cask "font-recursive-mono-nerd-font"
cask "font-victor-mono-nerd-font"
cask "font-atkinson-hyperlegible"
