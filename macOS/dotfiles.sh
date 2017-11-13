# Link dotfiles

mkdir ~/.config
ln -s ~/Documents/github/dotfiles/vimrc ~/.vimrc
ln -s ~/Documents/github/dotfiles/zshrc ~/.zshrc
ln -s ~/Documents/github/dotfiles/emacs.d ~/.emacs.d
ln -s ~/Documents/github/dotfiles/weechat.conf ~/.weechat.conf
ln -s ~/Documents/github/dotfiles/ledgerrc ~/.ledgerrc
ln -s ~/Documents/github/dotfiles/latexmkrc ~/.latexmkrc
ln -s ~/Documents/github/dotfiles/ranger ~/.config/ranger
ln -s ~/Documents/github/dotfiles/nvim ~/.config/nvim

if [ "$(uname)" = "Linux" ]; then
    ln -s ~/Documents/github/dotfiles/xinitrc ~/.xinitrc
    ln -s ~/Documents/github/dotfiles/xmodmap ~/.xmodmap
    ln -s ~/Documents/github/dotfiles/Xresources ~/.Xresources
    ln -s ~/Documents/github/dotfiles/i3 ~/.config/i3
    ln -s ~/Documents/github/dotfiles/30.touchpad.conf /etc/x11/xorg.conf.d/30.touchpad.conf
fi
