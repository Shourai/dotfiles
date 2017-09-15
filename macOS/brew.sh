# Run latest version of brew
brew update
brew upgrade -all

# Opt-out of homebrew analytics
brew analytics off

# Install homebrew packages

# brew install autojump
brew install coreutils
brew install emacs --with-cocoa --srgb emacs
brew install fasd
brew install fzf
brew install ledger
brew install markdown
brew install neovim
brew install python3
brew install tree
brew install vim
brew install weechat
brew install wget
brew install zsh
brew install zsh-syntax-highlighting

# Install cask packages

brew cask install 1password
# brew cask install arduino
brew cask install bettertouchtool
brew cask install calibre
brew cask install dropbox
brew cask install firefox
brew cask install google-chrome
brew cask install istat-menus
brew cask install iterm2
# brew cask install libreoffice
brew cask install mpv
brew cask install skim
brew cask install the-unarchiver
brew cask install transmission
brew cask install tunnelblick

# Clean up brew and cask

brew cleanup
brew cask cleanup
