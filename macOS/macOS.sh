# Run latest version of brew
brew update
brew upgrade

# Opt-out of homebrew analytics
brew analytics off

# Install homebrew packages
brew install bash
brew install coreutils
brew install fzf
brew install gnu-sed
brew install htop
brew install lazygit
brew install lua
brew install mpv
brew install neovim
brew install python
brew install shellcheck
brew install tmux
brew install tree
brew install zsh-syntax-highlighting
brew install zsh-autosuggestions

# Install cask packages
brew install --cask 1password
brew install --cask firefox-developer-edition
brew install --cask google-chrome-dev
brew install --cask iterm2

# Clean up brew and cask
brew cleanup

# Enable fzf keybindings
bash /usr/local/opt/fzf/install

# Add font
brew tap shaunsingh/SFMono-Nerd-Font-Ligaturized
brew install --cask font-sf-mono-nerd-font-ligaturized

# Copy keymaps
mkdir -p ~/Library/LaunchAgents
cp ~/Documents/github/dotfiles/macOS/com.local.KeyRemapping.plist ~/Library/LaunchAgents

# Run settings script
# bash ~/Documents/github/dotfiles/macOS/settings.sh
