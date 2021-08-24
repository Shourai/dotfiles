# Install AUR helper
git clone https://aur.archlinux.org/yay.git
cd yay || exit
makepkg -si --noconfirm

# update package list
sudo pacman -Syu --noconfirm

# Install packages
# sudo pacman -S acpi --noconfirm
# sudo pacman -S i3-gaps --noconfirm
# sudo pacman -S i3blocks --noconfirm
# sudo pacman -S ledger --noconfirm
# sudo pacman -S rxvt-unicode --noconfirm
# sudo pacman -S sysstat --noconfirm
# sudo pacman -S emacs --noconfirm
# sudo pacman -S fasd --noconfirm
# sudo pacman -S fd --noconfirm
# sudo pacman -S pulseaudio --noconfirm
# sudo pacman -S pulsemixer --noconfirm
# sudo pacman -S the_silver_searcher --noconfirm
# sudo pacman -S feh --noconfirm

sudo pacman -S bspwm --noconfirm
sudo pacman -S dmenu --noconfirm
sudo pacman -S fzf --noconfirm
sudo pacman -S htop --noconfirm
sudo pacman -S keychain --noconfirm
sudo pacman -S lazygit --noconfirm
sudo pacman -S maim --noconfirm
sudo pacman -S mpv --noconfirm
sudo pacman -S neovim --noconfirm
sudo pacman -S nitrogen --noconfirm
sudo pacman -S nnn --noconfirm
sudo pacman -S openssh --noconfirm
sudo pacman -S picom --noconfirm
sudo pacman -S pipewire --noconfirm
sudo pacman -S pipewire-pulse --noconfirm
sudo pacman -S python-pip --noconfirm
sudo pacman -S python3 --noconfirm
sudo pacman -S shellcheck --noconfirm
sudo pacman -S sxhkd --noconfirm
sudo pacman -S sxiv --noconfirm
sudo pacman -S tmux --noconfirm
sudo pacman -S trash-cli --noconfirm
sudo pacman -S xclip --noconfirm
sudo pacman -S xorg-server --noconfirm
sudo pacman -S xorg-xinit --noconfirm
sudo pacman -S z --noconfirm
sudo pacman -S zathura-pdf-mupdf --noconfirm
sudo pacman -S zsh --noconfirm
sudo pacman -S zsh-autosuggestions --noconfirm
sudo pacman -S zsh-syntax-highlighting --noconfirm
yay -S betterlockscreen --noconfirm
yay -S flashfocus --noconfirm
yay -S polybar --noconfirm
yay -S xidlehook --noconfirm

# Install terminal emulator
git clone https://github.com/Shourai/st.git ~/Documents/github/st
cd ~/Documents/github/st || exit
sudo make install

git clone https://github.com/Shourai/scroll.git ~/Documents/github/scroll
cd ~/Documents/github/scroll || exit
sudo make install
