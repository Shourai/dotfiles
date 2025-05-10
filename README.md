# Configuration for arch linux and macOS with dotfiles

## Overview

This repository bootstraps everything I need from a clean install of macOS or Arch Linux.

## Installation
Installing arch linux is quite easy using `archinstall`.

After installation run the `install` after cloning this repository.
Or run the following cURL command:

```
curl -fsSL https://raw.githubusercontent.com/Shourai/dotfiles/master/install | bash
```

## Directory Listing

```
dotfiles
 ├─ README.md
 ├─ install
 ├─ arch
 │  ├─ supplementary_packages.sh
 │  ├─ arch_packages.sh
 │  ├─ packages
 │  ├─ fontconfig
 │  ├─ fonts
 │  ├─ README.md
 │  ├─ dotfiles.sh
 │  └─ wayland
 ├─ zsh
 │  ├─ aliases
 │  ├─ zshenv
 │  └─ zshrc
 ├─ yazi
 │  ├─ package.toml
 │  ├─ yazi.toml
 │  ├─ keymap.toml
 │  ├─ theme.toml
 │  └─ flavors
 ├─ ghostty
 │  └─ config
 ├─ macOS
 │  ├─ aerospace.toml
 │  ├─ README.md
 │  ├─ settings.sh
 │  ├─ macOS.sh
 │  ├─ com.googlecode.iterm2.plist
 │  └─ com.local.KeyRemapping.plist
 ├─ git
 │  ├─ config
 │  └─ gitconfig_personal
 └─ tmux
    └─ tmux.conf
```

### Useful cli packages

- bat
- btop
- erdtree
- eza
- fd
- fzf
- gping
- jq
- jless
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
