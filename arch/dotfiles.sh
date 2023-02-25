# Link dotfiles

mkdir -p ~/.config
mkdir -p ~/.local/bin
mkdir -p ~/.local/share

mkdir -p ~/.zsh/functions
ln -sf ~/Documents/github/dotfiles/zsh/zshrc ~/.zshrc
ln -sf ~/Documents/github/dotfiles/zsh/pure.zsh ~/.zsh/functions/prompt_pure_setup
ln -sf ~/Documents/github/dotfiles/zsh/async.zsh ~/.zsh/functions/async
ln -sf ~/Documents/github/dotfiles/zsh/LS_COLORS ~/.zsh/LS_COLORS

ln -sf ~/Documents/github/nvim ~/.config/nvim
ln -sf ~/Documents/github/dotfiles/tmux/tmux.conf ~/.config/tmux
ln -sf ~/Documents/github/dotfiles/git ~/.config

if [ "$(uname)" = "Linux" ]; then
    ln -sf ~/Documents/github/dotfiles/arch/xinitrc ~/.xinitrc
    ln -sf ~/Documents/github/dotfiles/arch/picom.conf ~/.config
    ln -sf ~/Documents/github/dotfiles/arch/bspwm ~/.config
    ln -sf ~/Documents/github/dotfiles/arch/sxhkd ~/.config
    ln -sf ~/Documents/github/dotfiles/arch/polybar ~/.config
    ln -sf ~/Documents/github/dotfiles/arch/rofi ~/.config
    ln -sf ~/Documents/github/dotfiles/arch/fontconfig ~/.config
    ln -sf ~/Documents/github/dotfiles/arch/fonts ~/.local/share
    ln -sf ~/Documents/github/dotfiles/arch/bspwm/scripts/bspwm_resize ~/.local/bin
fi

if [ -f /etc/arch-release ]; then
    # Install x-server keyboard-layout
    sudo rsync -a ~/Documents/github/dotfiles/arch/20-keyboard-layout.conf /etc/X11/xorg.conf.d/
fi

