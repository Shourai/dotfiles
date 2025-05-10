# Link dotfiles

mkdir -p ~/.config
mkdir -p ~/.local/bin
mkdir -p ~/.local/share

ln -sf ~/Documents/github/dotfiles/zsh ~/.config/zsh

ln -sf ~/Documents/github/nvim ~/.config/nvim
ln -sf ~/Documents/github/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -sf ~/Documents/github/dotfiles/git ~/.config
ln -sf ~/Documents/github/dotfiles/yazi ~/.config

if [ "$(uname)" = "Linux" ]; then
    rm ~/.config/hypr
    ln -sf ~/Documents/github/dotfiles/arch/wayland/alacritty ~/.config
    ln -sf ~/Documents/github/dotfiles/arch/wayland/hypr ~/.config
    ln -sf ~/Documents/github/dotfiles/arch/wayland/swayidle ~/.config
    ln -sf ~/Documents/github/dotfiles/arch/wayland/swaylock ~/.config
    ln -sf ~/Documents/github/dotfiles/arch/wayland/waybar ~/.config
    ln -sf ~/Documents/github/dotfiles/arch/wayland/wofi ~/.config
    ln -sf ~/Documents/github/dotfiles/arch/fontconfig ~/.config
    ln -sf ~/Documents/github/dotfiles/arch/fonts ~/.local/share
fi
