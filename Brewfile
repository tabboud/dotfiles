tap "homebrew/bundle"
tap "homebrew/core"

if OS.mac?
  # Taps
  tap "homebrew/cask"
  tap "homebrew/cask-fonts"

  # Applications
  cask "1password"
  cask "font-jetbrains-mono-nerd-font"
  cask "hammerspoon"
  cask "rectangle"    # Window snapping
  cask "spotify"
  cask "wezterm"
  cask "zulu"

  # Packages
  brew "reattach-to-user-namespace"
elsif OS.linux?
  brew "xclip"
end

# Packages
brew "bat"          # better cat
brew "dive"         # Analyze docker image layers
brew "fd"           # find alternative
brew "fzf"          # Fuzzy finder
brew "gh"           # Github CLI
brew "glow"         # markdown TUI
brew "gum"          # shell script utility
brew "htop"
brew "jq"
brew "neovim"
brew "nnn"
brew "python"
brew "ripgrep"      # grep alternative
brew "sd"           # sed alternative
brew "shellcheck"   # diagnostics for shell scripts
brew "stow"         # linking tool
brew "tig"          # git TUI
brew "tmux"
brew "tree"
brew "watch"
brew "wget"
brew "yq"           # jq for yaml
brew "zsh"

# vim:ft=ruby
