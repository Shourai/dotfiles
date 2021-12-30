##################################################
# Run latest version of brew
##################################################
brew update
brew upgrade

##################################################
# Opt-out of homebrew analytics
##################################################
brew analytics off

##################################################
# Install homebrew packages
##################################################
# brew install autojump
brew install bash
brew install coreutils
brew install fzf
# brew install gnu-sed
brew install htop
# brew install ledger
# brew install markdown
brew install mpv
brew install neovim
# brew install pandoc
brew install python
brew install shellcheck
brew install tmux
brew install tree
# brew install vim
# brew install weechat
# brew install wget
brew install zsh-syntax-highlighting
brew install zsh-autosuggestions

##################################################
# Install cask packages
##################################################
brew install --cask 1password
# brew install --cask bettertouchtool
# brew install --cask calibre
# brew install --cask emacs
brew install --cask homebrew/cask-versions/firefox-beta
# brew install --cask istat-menus
brew install --cask iterm2
# brew install --cask mpv
# brew install --cask skim
# brew install --cask the-unarchiver
# brew install --cask transmission
brew install --cask font-sf-mono-for-powerline
# brew install --cask arduino
# brew install --cask libreoffice
# brew install --cask tunnelblick

##################################################
# Clean up brew and cask
##################################################
brew cleanup
