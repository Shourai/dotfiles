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

```
.
├── arch
│   ├── 20-keyboard-layout.conf
│   ├── bspwm
│   ├── dotfiles.sh
│   ├── fontconfig
│   ├── fonts
│   ├── mimeapps.list
│   ├── packages.sh
│   ├── picom.conf
│   ├── polybar
│   ├── README.md
│   ├── rofi
│   ├── sxhkd
│   └── xinitrc
├── git
│   └── config
├── install
├── macOS
│   ├── com.googlecode.iterm2.plist
│   ├── com.local.KeyRemapping.plist
│   ├── macOS.sh
│   ├── README.md
│   ├── settings.sh
│   └── SF-Mono-Powerline-Regular.otf
├── README.md
├── tmux
│   └── tmux.conf
└── zshrc
```

### Useful cli packages

- bat
- erdtree
- eza
- fd
- gping
- lazygit
- mtr
- netop
- pandoc
- ripgrep
- sshs
- termshark
- tmux
- yazi
- zoxide
