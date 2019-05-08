# Link dotfiles

mkdir -p ~/.config
ln -s ~/Documents/github/dotfiles/nvim/init.vim ~/.vimrc
ln -s ~/Documents/github/dotfiles/zsh/zshrc ~/.zshrc

mkdir -p ~/.zsh/functions
ln -s ~/Documents/github/dotfiles/zsh/pure.zsh ~/.zsh/functions/prompt_pure_setup
ln -s ~/Documents/github/dotfiles/zsh/async.zsh ~/.zsh/functions/async

ln -s ~/Documents/github/dotfiles/emacs.d ~/.emacs.d
ln -s ~/Documents/github/dotfiles/weechat.conf ~/.weechat.conf
ln -s ~/Documents/github/dotfiles/ledgerrc ~/.ledgerrc
ln -s ~/Documents/github/dotfiles/latexmkrc ~/.latexmkrc
ln -s ~/Documents/github/dotfiles/ranger ~/.config/ranger
ln -s ~/Documents/github/dotfiles/nvim ~/.config/nvim
ln -s ~/Documents/github/dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/Documents/github/dotfiles/neomutt ~/.config/neomutt

if [ "$(uname)" = "Linux" ]; then
    ln -s ~/Documents/github/dotfiles/arch/xinitrc ~/.xinitrc
    ln -s ~/Documents/github/dotfiles/arch/xresources ~/.xresources
    ln -s ~/Documents/github/dotfiles/arch/i3 ~/.config/
    ln -s ~/Documents/github/dotfiles/arch/urxvt ~/.urxvt
    ln -s ~/Documents/github/dotfiles/arch/compton.conf ~/.config
    ln -s ~/Documents/github/dotfiles/arch/bspwm ~/.config
    ln -s ~/Documents/github/dotfiles/arch/sxhkd ~/.config
    ln -s ~/Documents/github/dotfiles/arch/polybar ~/.config
fi
