#!/usr/bin/env sh

## Aliases
if ls --color > /dev/null 2>&1; then # GNU `ls`
  alias ls="ls -F --color=always"
else # bsd `ls`
  alias ls="ls -F -G"
fi
alias ll="ls -l"
alias la="ls -a"
alias vi='vim'
alias vim='nvim'

macos_setup() {
  # based on https://mths.be/macos
  defaults write com.apple.dock persistent-apps -array
  defaults write com.apple.dock autohide -boolean true
  defaults write com.apple.dock orientation -string left

  defaults write -g ApplePressAndHoldEnabled -bool false  # Key repeats when you hold it

  defaults write com.apple.menuextra.clock DateFormat -string 'EEE MMM d H:mm'

  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3 # enable full keyboard access
  defaults write NSGlobalDomain com.apple.keyboard.fnState -boolean true  # enable function keys

  # SecureKeyboardEntry for Terminal & iTerm https://security.stackexchange.com/a/47786/8918
  defaults write com.apple.terminal SecureKeyboardEntry -bool true
  defaults write com.googlecode.iterm2 SecureKeyboardEntry -bool true

  # Enable snap-to-grid for icons on the desktop and in other icon views
  /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" \
    "${HOME}/Library/Preferences/com.apple.finder.plist"
  /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" \
    "${HOME}/Library/Preferences/com.apple.finder.plist"
  /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" \
    "${HOME}/Library/Preferences/com.apple.finder.plist"

  # Use list view in all Finder windows by default, other view mode codes: `icnv`, `clmv`, `glyv`
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

  # Expand save panel by default
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

  # Expand print panel by default
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

  # Expand “General”, “Open with”, and “Sharing & Permissions” File Info panes:
  defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

  # Privacy: don’t send search queries to Apple
  defaults write com.apple.Safari UniversalSearchEnabled -bool false
  defaults write com.apple.Safari SuppressSearchSuggestions -bool true

  # Enable Safari’s debug menu
  defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

  # Bypass the annoyingly slow t.co URL shortener
  defaults write com.tapbots.TweetbotMac OpenURLsDirectly -bool true
}

# Homebrew
export HOMEBREW_NO_ANALYTICS=1 # Turn of homebrew data collection
export HOMEBREW_BUNDLE_NO_LOCK=1 # No brew lockfile
export HOMEBREW_NO_INSECURE_REDIRECT=1 # Disallow `https` => `http` redirects
export HOMEBREW_CASK_OPTS='--require-sha'
export HOMEBREW_BUNDLE_FILE="${HOME}/workspace/dotfiles/Brewfile"
homebrew_git_api_token="${HOME}/.homebrew-git-api-token"
# shellcheck source=/dev/null
test -f "${homebrew_git_api_token}" && . "${homebrew_git_api_token}"

bup() {
  brew update && \
    brew bundle && \
    brew upgrade
}

## Golang: This has to happen after GVM otherwise GOPATH will get unset
export GOPATH="${HOME}/go"
export PATH=${PATH}:"${GOPATH}/bin":/usr/local/go/bin

## Git Duet
export GIT_DUET_ROTATE_AUTHOR=1
export GIT_DUET_SET_GIT_USER_CONFIG=1
export GIT_DUET_GLOBAL=true

## Don't check mail when opening terminal.
unset MAILCHECK

## Default Editor
export EDITOR="nvim"

## Force xterm-256color
export TERM="xterm-256color"

## Direnv
test -e "$(which direnv)" && eval "$(direnv hook "$(ps -ocomm= $$| cut -d"-" -f2)")"
