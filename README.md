# Configuration for macOS with dotfiles

## Overview
This repository bootstraps everything I need from a clean install of macOS Monterey or Arch Linux.

## Installation
Here I have my configuration for a clean setup.
The only thing that would be handy is to create your user and add it to the `wheel` group.

```
useradd -m -G wheel [username]
```
Be sure to allow the wheel group to run sudo commands via `visudo`

Basically run the `install` after cloning this repository.
Or run the following cURL command:

```
curl -fsSL https://raw.githubusercontent.com/Shourai/dotfiles/master/install | bash
```

## Directory Listing
    .
    ├── android
    │   ├── install
    │   ├── packages.sh
    │   ├── README.md
    │   └── termux.properties
    ├── arch
    │   ├── 20-keyboard-layout.conf
    │   ├── bspwm
    │   ├── dotfiles.sh
    │   ├── fontconfig
    │   ├── fonts
    │   ├── i3
    │   ├── mimeapps.list
    │   ├── packages.sh
    │   ├── picom.conf
    │   ├── polybar
    │   ├── README.md
    │   ├── sxhkd
    │   ├── urxvt
    │   ├── xinitrc
    │   └── xresources
    ├── emacs
    │   ├── emacs.org
    │   ├── init.el
    │   ├── snippets
    │   └── unused.org
    ├── git
    │   └── config
    ├── install
    ├── latexmkrc
    ├── ledgerrc
    ├── macOS
    │   ├── brew.sh
    │   ├── com.googlecode.iterm2.plist
    │   ├── com.local.KeyRemapping.plist
    │   ├── macOS.sh
    │   ├── miscellaneous.sh
    │   ├── README.md
    │   └── SF-Mono-Powerline-Regular.otf
    ├── neomutt
    │   ├── account.1
    │   ├── dracula.muttrc
    │   └── neomuttrc
    ├── README.md
    ├── tmux
    │   └── tmux.conf
    ├── weechat.conf
    └── zsh
        ├── async.zsh
        ├── pure.zsh
        └── zshrc
