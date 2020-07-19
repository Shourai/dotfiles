# Link dotfiles

mkdir -p ~/.config
ln -sf ~/Documents/github/dotfiles/nvim/init.vim ~/.vimrc
ln -sf ~/Documents/github/dotfiles/zsh/zshrc ~/.zshrc

mkdir -p ~/.zsh/functions
ln -sf ~/Documents/github/dotfiles/zsh/pure.zsh ~/.zsh/functions/prompt_pure_setup
ln -sf ~/Documents/github/dotfiles/zsh/async.zsh ~/.zsh/functions/async
ln -sf ~/Documents/github/dotfiles/zsh/LS_COLORS ~/.zsh/LS_COLORS

ln -sf ~/Documents/github/dotfiles/emacs.d ~/.emacs.d
ln -sf ~/Documents/github/dotfiles/nvim ~/.config/nvim

if [ "$(uname)" = "Darwin" ]; then
ln -sf ~/Documents/github/dotfiles/tmux/tmux.conf ~/.tmux.conf
fi

echo "Do you wish to add ledgerrc, latexmkrc and ranger? (y/n)"
read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    ln -sf ~/Documents/github/dotfiles/ledgerrc ~/.ledgerrc
    ln -sf ~/Documents/github/dotfiles/latexmkrc ~/.latexmkrc
    ln -sf ~/Documents/github/dotfiles/ranger ~/.config/ranger
else
    echo "Skipping lederrc, latexmkrc, ranger"
fi

# ln -sf ~/Documents/github/dotfiles/neomutt ~/.config/neomutt
# ln -sf ~/Documents/github/dotfiles/weechat.conf ~/.weechat.conf

if [ "$(uname)" = "Linux" ]; then
    ln -sf ~/Documents/github/dotfiles/arch/xinitrc ~/.xinitrc
    ln -sf ~/Documents/github/dotfiles/arch/xresources ~/.xresources
    ln -sf ~/Documents/github/dotfiles/arch/i3 ~/.config/
    ln -sf ~/Documents/github/dotfiles/arch/urxvt ~/.urxvt
    ln -sf ~/Documents/github/dotfiles/arch/picom.conf ~/.config
    ln -sf ~/Documents/github/dotfiles/arch/bspwm ~/.config
    ln -sf ~/Documents/github/dotfiles/arch/sxhkd ~/.config
    ln -sf ~/Documents/github/dotfiles/arch/polybar ~/.config
    ln -sf ~/Documents/github/dotfiles/arch/fontconfig ~/.config
    ln -sf ~/Documents/github/dotfiles/arch/fonts ~/.local/share
    ln -sf ~/Documents/github/dotfiles/arch/bspwm/scripts/bspwm_resize ~/.local/bin
    ln -sf ~/Documents/github/dotfiles/tmux ~/.config/tmux
fi
