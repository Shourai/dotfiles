#!/bin/sh

# Change shell to zsh
if [ "$(uname)" = "Darwin" ] && ! grep -Fq "$(brew --prefix)/bin/zsh" /etc/shells
then
    echo "$(brew --prefix)/bin/zsh" | sudo tee -a /etc/shells
    chsh -s "$(brew --prefix)"/bin/zsh
else
    chsh -s "$(command -v zsh)"
fi
