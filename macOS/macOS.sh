# Run latest version of brew
brew update
brew upgrade

# Opt-out of homebrew analytics
brew analytics off

# Access to alternate versions of Casks
brew tap homebrew/cask-versions

# Install homebrew packages
brew install 1password-cli
brew install bash
brew install bat
brew install coreutils
brew install erdtree
brew install eza
brew install fd
brew install ripgrep
brew install fzf
brew install gnu-sed
brew install htop
brew install iproute2mac
brew install lazygit
brew install lua
brew install neovim
brew install npm
brew install openconnect
brew install python
brew install shellcheck
brew install tmux
brew install yazi
brew install zsh-syntax-highlighting
brew install zsh-autosuggestions

# Install cask packages
brew install --cask 1password
brew install --cask nikitabobko/tap/aerospace
brew install --cask firefox@developer-edition
brew install --cask google-chrome@dev
brew install --cask ghostty
brew install --cask iina

# Clean up brew and cask
brew cleanup --prune=all

# Enable fzf keybindings
bash $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc

# Add font
brew tap shaunsingh/SFMono-Nerd-Font-Ligaturized
brew install --cask font-sf-mono-nerd-font-ligaturized

# Copy keymaps
mkdir -p ~/Library/LaunchAgents
cp ~/Documents/github/dotfiles/macOS/com.local.KeyRemapping.plist /Library/LaunchDaemons

# Run settings script
# bash ~/Documents/github/dotfiles/macOS/settings.sh
