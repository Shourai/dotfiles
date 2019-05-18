# Configuration for macOS with dotfiles

## Overview
This repository installs everything I need from a clean install of macOS Sierra or Arch Linux.
By running `install`, `homebrew` will be installed (on macOS) which subsequently installs `git`.
The repositories `macOS` and `dotfiles` will be cloned to my Documents folder.

### macOS directory
in `brew.sh` are all brew packages I use.
in `dotfiles.sh`, the dotfiles are symlinked to the home directory, this includes the dotfiles for Linux distros.
in `shell.sh`, BASH gets replaced for ZSH, also for Linux distros.
in `miscellaneous.sh` some packages are installed e.g. `matplotlib` for python3.
Finally in `macOS.sh`, configurations to macOS are performed e.g.: keyboard repeat speed.

###  Arch directory
in `packages.sh`, are all the packages I use.

## Features
- macOS
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
curl -fsSL https://raw.githubusercontent.com/Shourai/dotfiles/master/install | sh
```

## Future reference

### Setting up custom `defaults write` on macOS
1. `defaults read > a`
2. Open system preferences and change the setting to some other value than the default.
3. `defaults read > b`
4. `diff a b`

## Improvements

## Directory Listing
    .
    ├── README.md
    ├── android
    │   ├── README.md
    │   ├── install
    │   ├── packages.sh
    │   └── termux.properties
    ├── arch
    │   ├── README.md
    │   ├── bspwm
    │   ├── compton.conf
    │   ├── i3
    │   ├── packages.sh
    │   ├── polybar
    │   ├── sxhkd
    │   ├── urxvt
    │   ├── xinitrc
    │   └── xresources
    ├── emacs.d
    │   ├── emacs.el
    │   ├── emacs.org
    │   ├── init.el
    │   ├── snippets
    │   └── unused.org
    ├── firefox
    │   ├── README.md
    │   ├── sync.sh
    │   ├── userChrome.css
    │   └── userContent.css
    ├── install
    ├── latexmkrc
    ├── ledgerrc
    ├── macOS
    │   ├── brew.sh
    │   ├── com.googlecode.iterm2.plist
    │   ├── dotfiles.sh
    │   ├── macOS.sh
    │   ├── miscellaneous.sh
    │   └── shell.sh
    ├── neomutt
    │   ├── cache
    │   ├── dracula.muttrc
    │   ├── neomuttrc
    │   ├── personal
    │   └── work
    ├── nvim
    │   ├── autoload
    │   ├── init.vim
    │   ├── local_bundles.vim
    │   ├── local_init.vim
    │   ├── plugged
    │   └── session
    ├── ranger
    │   ├── commands.py
    │   ├── commands_full.py
    │   ├── plugins
    │   ├── rc.conf
    │   ├── rifle.conf
    │   └── scope.sh
    ├── tmux.conf
    ├── weechat.conf
    └── zsh
        ├── async.zsh
        ├── pure.zsh
        └── zshrc
