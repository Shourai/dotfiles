#!/bin/bash

# Change shell to zsh
if [[ "$(uname)" = "Darwin" ]] && ! fgrep -q "$(brew --prefix)/bin/zsh" /etc/shells
then
    echo "$(brew --prefix)/bin/zsh" | sudo tee -a /etc/shells
    chsh -s $(brew --prefix)/bin/zsh
else
    chsh -s $(which zsh)
fi
