# Link dotfiles

mkdir -p ~/.config
ln -sf ~/Documents/github/dotfiles/zsh/zshrc ~/.zshrc

mkdir -p ~/.zsh/functions
ln -sf ~/Documents/github/dotfiles/zsh/pure.zsh ~/.zsh/functions/prompt_pure_setup
ln -sf ~/Documents/github/dotfiles/zsh/async.zsh ~/.zsh/functions/async
ln -sf ~/Documents/github/dotfiles/zsh/LS_COLORS ~/.zsh/LS_COLORS

ln -sf ~/Documents/github/nvim ~/.config/nvim
ln -sf ~/Documents/github/dotfiles/tmux ~/.config/tmux
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
