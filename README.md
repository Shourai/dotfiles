# Configuration for macOS with dotfiles

## Overview
This repository installs everything I need from a clean install of macOS Sierra or Debian or Arch Linux.
By running `install`, `homebrew` will be installed (on macOS) which subsequently installs `git`.
The repositories `macOS` and `dotfiles` will be cloned to my Documents folder.

### macOS directory
in `brew.sh` are all brew packages I use.
in `dotfiles.sh`, the dotfiles are symlinked to the home directory, this includes the dotfiles for Linux distros.
in `shell.sh`, BASH gets replaced for ZSH, also for Linux distros.
in `miscellaneous.sh` some packages are installed e.g. `matplotlib` for python3.
Finally in `macOS.sh`, configurations to macOS are performed e.g.: keyboard repeat speed.

###  debian/arch directory
in `packages.sh`, are all the packages I use.

## Features
- macOS
- Debian
- Arch
- iTerm2
- zsh with syntax highlighting
- (neo)vim
- emacs

## Installation
Here I have my configuration for a clean setup.
Basically run the `install` after cloning this repository.
Or run the following cURL command:
```
curl -fsSL https://raw.githubusercontent.com/Shourai/dotfiles/master/install | bash
```

## Future reference

### Setting up custom `defaults write` on macOS
1. `defaults read > a`
2. Open system preferences and change the setting to some other value than the default.
3. `defaults read > b`
4. `diff a b`

## Improvements
I would like to have a script that differentiates between macos/arch/debian
instead of using `if statements` in bash.
