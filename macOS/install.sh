# Go to root directory
cd ~

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `install.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install git
brew install git

# Setup github
git config --global user.name "Shourai"
git config --global user.email "mail@shourai.net"
git config --global credential.helper osxkeychain

# Clone respository
git clone https://github.com/Shourai/dotfiles.git ~/Documents/github/dotfiles

# Install brew packages
sh ~/Documents/github/dotfiles/macOS/brew.sh

# Link dotfiles
sh ~/Documents/github/dotfiles/macOS/dotfiles.sh

# Change shell to zsh
sh ~/Documents/github/dotfiles/macOS/shell.sh

# Additional installations
sh ~/Documents/github/dotfiles/macOS/miscellaneous.sh

# macOS changes
sh ~/Documents/github/dotfiles/macOS/macOS.sh
