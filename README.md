# Configuration for macOS with dotfiles

## Overview
This repository installs everything I need from a clean install of macOS Sierra.
By running `install.sh`, `homebrew` will be installed which subsequently installs `git`.  
The repositories `macOS` and `dotfiles` will be cloned to my Documents folder.

in `brew.sh` are all brew packages I use.   
in `dotfiles.sh`, the dotfiles are symlinked to the home directory.  
in `shell.sh`, BASH gets replaced for ZSH.  
in `miscellaneous.sh` some packages are installed e.g. `matplotlib` for python3.  
Finally in `macOS.sh`, configurations to macOS Sierra are performed e.g.: keyboard repeat speed.  

## Features
- macOS Sierra
- iTerm2
- Chalkboard theme ([Chalkboard](https://github.com/mbadolato/iTerm2-Color-Schemes/blob/master/schemes/Chalkboard.itermcolors))
- Zsh
- Vim
- Emacs

## Installation
Here I have my configuration for a clean macOS setup.  
Basically run the `install.sh` after cloning this repository.  
Or run the following cURL command:  
```
curl -fsSL https://raw.githubusercontent.com/Shourai/dotfiles/master/macOS/install.sh | sh
```

## Future reference

### Setting up custom `defaults write` on macOS
1. `defaults read > a`
2. Open system preferences and change the setting to some other value than the default.
3. `defaults read > b`
4. `diff a b`
