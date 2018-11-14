# Install AUR helper
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm

# update package list
sudo pacman -Syu --noconfirm

# Install packages
sudo pacman -S acpi --noconfirm
sudo pacman -S archey3 --noconfirm
sudo pacman -S dmenu --noconfirm
sudo pacman -S emacs --noconfirm
sudo pacman -S fasd --noconfirm
sudo pacman -S feh --noconfirm
sudo pacman -S fzf --noconfirm
sudo pacman -S htop --noconfirm
sudo pacman -S i3-gaps --noconfirm
sudo pacman -S i3blocks --noconfirm
sudo pacman -S ledger --noconfirm
sudo pacman -S mpv --noconfirm
sudo pacman -S neovim --noconfirm
sudo pacman -S openssh --noconfirm
sudo pacman -S pavucontrol --noconfirm
sudo pacman -S pulseaudio --noconfirm
sudo pacman -S python-pip --noconfirm
sudo pacman -S python3 --noconfirm
sudo pacman -S rxvt-unicode --noconfirm
sudo pacman -S sysstat --noconfirm
sudo pacman -S the_silver_searcher --noconfirm
sudo pacman -S tmux --noconfirm
sudo pacman -S ttf-dejavu --noconfirm
sudo pacman -S xclip --noconfirm
sudo pacman -S xf86-video-intel --noconfirm
sudo pacman -S xorg --noconfirm
sudo pacman -S xorg-backlight --noconfirm
sudo pacman -S xorg-xinit --noconfirm
sudo pacman -S zsh --noconfirm
sudo pacman -S zsh-autosuggestions --noconfirm
sudo pacman -S zsh-syntax-highlighting --noconfirm
yay -S otf-font-awesome --noconfirm
yay -S betterlockscreen --noconfirm
yay -S compton-git --noconfirm # Change to community version when up to date?
yay -S flashfocus-git --noconfirm
# sudo pacman -S alsa-utils --noconfirm

# Do a cleanup
sudo pacman -Sc --noconfirm
