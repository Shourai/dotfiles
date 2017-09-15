#!/bin/bash

# Change shell to zsh
if [[ "$(uname)" = "Darwin" ]]; then
    sudo sh -c 'echo "$(brew --prefix)/bin/zsh" >> /etc/shells'
    chsh -s $(brew --prefix)/bin/zsh

    # Change some permissions for zsh
    sudo chmod -R 755 $(brew --prefix)/share/zsh
    sudo chown -R $USER:admin $(brew --prefix)/share/zsh
else
    chsh -s $(which zsh)
fi

