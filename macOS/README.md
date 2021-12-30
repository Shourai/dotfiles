# MacOS

### Note
On Monterey permissions need to be granted to terminal to access the whole disk
otherwise this script will fail.

### Files
in `brew.sh` are all brew packages I use.
in `dotfiles.sh`, the dotfiles are symlinked to the home directory, this includes the dotfiles for Linux distros.
in `shell.sh`, BASH gets replaced for ZSH, also for Linux distros.
in `miscellaneous.sh` some packages are installed e.g. `matplotlib` for python3.
Finally in `macOS.sh`, configurations to macOS are performed e.g.: keyboard repeat speed.


### Key remap
Remapping a mac keyboard which is not in US layout

Move `com.local.KeyRemapping.plist` to `~/Library/LaunchAgents/com.local.KeyRemapping.plist`.


| From                   | Keycode     | To                     | Keycode     |
|------------------------|-------------|------------------------|-------------|
| backslash              | 0x700000031 | return_or_enter        | 0x700000028 |
| grave_accent_and_tilde | 0x700000035 | backslash (\)          | 0x700000031 |
| non_us_backslash (§/±) | 0x700000064 | grave_accent_and_tilde | 0x700000035 |

### Setting up custom `defaults write` on macOS
1. `defaults read > a`
2. Open system preferences and change the setting to some other value than the default.
3. `defaults read > b`
4. `diff a b`
