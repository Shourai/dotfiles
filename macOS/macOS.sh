# Run latest version of brew
brew update
brew upgrade

# Opt-out of homebrew analytics
brew analytics off

# Install homebrew packages
brew install 1password-cli
brew install coreutils
brew install gnu-sed
brew install iproute2mac
brew install openconnect
brew install shellcheck

FILE="../arch/packages"

while read -r line; do
    brew install "$line"
done <"$FILE"


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
