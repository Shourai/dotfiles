# Install AUR helper
git clone https://aur.archlinux.org/yay.git
cd yay || exit
makepkg -si --noconfirm

# update package list
sudo pacman -Syu --noconfirm

# Install packages
sudo pacman -S alacritty --noconfirm
sudo pacman -S bat --noconfirm
sudo pacman -S btop --noconfirm
sudo pacman -S eza --noconfirm
sudo pacman -S fd --noconfirm
sudo pacman -S fzf --noconfirm
sudo pacman -S grim --noconfirm
sudo pacman -S hyprland --noconfirm
sudo pacman -S hyprlock --noconfirm
sudo pacman -S hypridle --noconfirm
sudo pacman -S hyprpaper --noconfirm
sudo pacman -S lazygit --noconfirm
sudo pacman -S lua --noconfirm
sudo pacman -S mpv --noconfirm
sudo pacman -S neovim --noconfirm
sudo pacman -S nnn --noconfirm
sudo pacman -S npm --noconfirm
sudo pacman -S openssh --noconfirm
sudo pacman -S pipewire --noconfirm
sudo pacman -S pipewire-pulse --noconfirm
sudo pacman -S polkit --noconfirm
sudo pacman -S polkit-gnome --noconfirm
sudo pacman -S python-pip --noconfirm
sudo pacman -S python3 --noconfirm
sudo pacman -S rsync --noconfirm
sudo pacman -S seahorse --noconfirm
sudo pacman -S slurp --noconfirm
sudo pacman -S swayidle --noconfirm
#sudo pacman -S swaylock --noconfirm
sudo pacman -S tmux --noconfirm
sudo pacman -S tree --noconfirm
sudo pacman -S unzip --noconfirm
sudo pacman -S waybar --noconfirm
sudo pacman -S wl-clipboard --noconfirm
sudo pacman -S wofi --noconfirm
sudo pacman -S xdg-utils --noconfirm
sudo pacman -S zathura-pdf-mupdf --noconfirm
sudo pacman -S zsh --noconfirm
sudo pacman -S zsh-autosuggestions --noconfirm
sudo pacman -S zsh-syntax-highlighting --noconfirm
yay -S swaylock-effects-git --noconfirm
yay -S shellcheck-bin --noconfirm

git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
