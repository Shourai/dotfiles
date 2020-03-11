# Install AUR helper
git clone https://aur.archlinux.org/yay.git
cd yay || exit
makepkg -si --noconfirm

# update package list
sudo pacman -Syu --noconfirm

# Install packages
# sudo pacman -S alsa-utils --noconfirm
# sudo pacman -S i3-gaps --noconfirm
# sudo pacman -S i3blocks --noconfirm
# sudo pacman -S ledger --noconfirm
# sudo pacman -S pavucontrol --noconfirm
# sudo pacman -S rxvt-unicode --noconfirm
sudo pacman -S acpi --noconfirm
sudo pacman -S archey3 --noconfirm
sudo pacman -S bspwm
sudo pacman -S dmenu --noconfirm
sudo pacman -S emacs --noconfirm
sudo pacman -S fasd --noconfirm
sudo pacman -S feh --noconfirm
sudo pacman -S fzf --noconfirm
sudo pacman -S htop --noconfirm
sudo pacman -S keychain --noconfirm
sudo pacman -S mesa --noconfirm
sudo pacman -S mpv --noconfirm
sudo pacman -S neovim --noconfirm
sudo pacman -S openssh --noconfirm
sudo pacman -S picom --noconfirm
sudo pacman -S pulseaudio --noconfirm
sudo pacman -S python-pip --noconfirm
sudo pacman -S python3 --noconfirm
sudo pacman -S sxhkd --noconfirm
sudo pacman -S sysstat --noconfirm
sudo pacman -S the_silver_searcher --noconfirm
sudo pacman -S tmux --noconfirm
sudo pacman -S ttf-dejavu --noconfirm
sudo pacman -S xclip --noconfirm
sudo pacman -S xorg --noconfirm
sudo pacman -S xorg-backlight --noconfirm
sudo pacman -S xorg-xinit --noconfirm
sudo pacman -S zsh --noconfirm
sudo pacman -S zsh-autosuggestions --noconfirm
sudo pacman -S zsh-syntax-highlighting --noconfirm
yay -S otf-font-awesome --noconfirm
yay -S betterlockscreen --noconfirm
yay -S flashfocus-git --noconfirm
yay -S polybar --noconfirm

git clone https://github.com/Shourai/st.git ~/Documents/github/st
cd ~/Documents/github/st
sudo make install
