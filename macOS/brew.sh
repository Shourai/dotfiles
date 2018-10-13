##################################################
# Run latest version of brew
##################################################
brew update
brew upgrade -all

##################################################
# Opt-out of homebrew analytics
##################################################
brew analytics off

##################################################
# Install homebrew packages
##################################################
# brew install autojump
brew install ag
brew install bash
brew install coreutils
brew install emacs --with-cocoa --with-imagemagick@6 --with-librsvg --HEAD
brew install fasd
brew install fzf
brew install gnu-sed
brew install gnutls
brew install htop
brew install ledger
brew install markdown
brew install mpv
brew install neovim
brew install pandoc
brew install python
brew install tmux
brew install tree
# brew install vim
brew install weechat
brew install wget
brew install zsh
brew install zsh-syntax-highlighting

##################################################
# Install cask packages
##################################################
brew cask install 1password
brew cask install bettertouchtool
brew cask install calibre
brew cask install dropbox
brew cask install caskroom/versions/firefox-beta
brew cask install istat-menus
brew cask install iterm2
brew cask install mpv
# brew cask install skim
brew cask install the-unarchiver
brew cask install transmission
brew cask install caskroom/fonts/font-menlo-for-powerline
# brew cask install arduino
# brew cask install libreoffice
# brew cask install tunnelblick

##################################################
# Clean up brew and cask
##################################################
brew cleanup
