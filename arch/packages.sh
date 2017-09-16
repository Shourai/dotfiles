# update package list
sudo pacman -Syu --noconfirm

# Install packages
sudo pacman -S python3 --noconfirm
sudo pacman -S python-pip --noconfirm
sudo pacman -S tmux --noconfirm
sudo pacman -S vim --noconfirm
sudo pacman -S neovim --noconfirm
sudo pacman -S zsh --noconfirm
sudo pacman -S zsh-syntax-highlighting --noconfirm
sudo pacman -S emacs --noconfirm
sudo pacman -S ledger --noconfirm
sudo pacman -S fasd --noconfirm
sudo pacman -S fzf --noconfirm
sudo pacman -S urxvt --noconfirm
sudo pacman -S dmenu --noconfirm
sudo pacman -S i3blocks --noconfirm
sudo pacman -S archey3 --noconfirm
sudo pacman -S ttf-dejavu --noconfirm
sudo pacman -S sysstat --noconfirm
sudo pacman -S acpi --noconfirm
sudo pacman -S feh --noconfirm


# Do a cleanup
sudo pacman -Sc --noconfirm
