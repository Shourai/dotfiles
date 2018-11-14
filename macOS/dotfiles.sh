# Link dotfiles

mkdir -p ~/.config
ln -s ~/Documents/github/dotfiles/vimrc ~/.vimrc
ln -s ~/Documents/github/dotfiles/zshrc ~/.zshrc

mkdir -p ~/.zsh/functions
ln -s ~/Documents/github/dotfiles/pure.zsh ~/.zsh/functions/prompt_pure_setup
ln -s ~/Documents/github/dotfiles/async.zsh ~/.zsh/functions/async

ln -s ~/Documents/github/dotfiles/emacs.d ~/.emacs.d
ln -s ~/Documents/github/dotfiles/weechat.conf ~/.weechat.conf
ln -s ~/Documents/github/dotfiles/ledgerrc ~/.ledgerrc
ln -s ~/Documents/github/dotfiles/latexmkrc ~/.latexmkrc
ln -s ~/Documents/github/dotfiles/ranger ~/.config/ranger
ln -s ~/Documents/github/dotfiles/nvim ~/.config/nvim
ln -s ~/Documents/github/dotfiles/tmux.conf ~/.tmux.conf

if [ "$(uname)" = "Linux" ]; then
    ln -s ~/Documents/github/dotfiles/xinitrc ~/.xinitrc
    ln -s ~/Documents/github/dotfiles/xresources ~/.xresources
    ln -s ~/Documents/github/dotfiles/i3 ~/.config/
    ln -s ~/Documents/github/dotfiles/urxvt ~/.urxvt
fi
