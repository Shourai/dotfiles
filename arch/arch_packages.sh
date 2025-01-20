# Install AUR helper
git clone https://aur.archlinux.org/yay.git
cd yay || exit
makepkg -si --noconfirm

# update package list
sudo pacman -Syu --noconfirm

# Install packages
sudo pacman -S alacritty --noconfirm
sudo pacman -S grim --noconfirm
sudo pacman -S hyprland --noconfirm
sudo pacman -S hyprlock --noconfirm
sudo pacman -S hypridle --noconfirm
sudo pacman -S hyprpaper --noconfirm
sudo pacman -S mpv --noconfirm
sudo pacman -S openssh --noconfirm
sudo pacman -S pipewire --noconfirm
sudo pacman -S pipewire-pulse --noconfirm
sudo pacman -S polkit --noconfirm
sudo pacman -S polkit-gnome --noconfirm
sudo pacman -S seahorse --noconfirm
sudo pacman -S slurp --noconfirm
sudo pacman -S swayidle --noconfirm
#sudo pacman -S swaylock --noconfirm
sudo pacman -S unzip --noconfirm
sudo pacman -S waybar --noconfirm
sudo pacman -S wl-clipboard --noconfirm
sudo pacman -S wofi --noconfirm
sudo pacman -S xdg-utils --noconfirm
sudo pacman -S zathura-pdf-mupdf --noconfirm
yay -S swaylock-effects-git --noconfirm
yay -S shellcheck-bin --noconfirm

git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
