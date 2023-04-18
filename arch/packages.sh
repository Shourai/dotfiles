# Install AUR helper
git clone https://aur.archlinux.org/yay.git
cd yay || exit
makepkg -si --noconfirm

# update package list
sudo pacman -Syu --noconfirm

# Install packages
sudo pacman -S bat --noconfirm
sudo pacman -S bspwm --noconfirm
sudo pacman -S exa --noconfirm
sudo pacman -S fd --noconfirm
sudo pacman -S flameshot --noconfirm
sudo pacman -S fzf --noconfirm
sudo pacman -S htop --noconfirm
sudo pacman -S keychain --noconfirm
sudo pacman -S lazygit --noconfirm
sudo pacman -S mpv --noconfirm
sudo pacman -S neovim --noconfirm
sudo pacman -S nitrogen --noconfirm
sudo pacman -S nnn --noconfirm
sudo pacman -S openssh --noconfirm
sudo pacman -S picom --noconfirm
sudo pacman -S pipewire --noconfirm
sudo pacman -S pipewire-pulse --noconfirm
sudo pacman -S polkit --noconfirm
sudo pacman -S python-pip --noconfirm
sudo pacman -S python3 --noconfirm
sudo pacman -S rofi --noconfirm
sudo pacman -S rofi-calc --noconfirm
sudo pacman -S rsync --noconfirm
sudo pacman -S sxhkd --noconfirm
sudo pacman -S tmux --noconfirm
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
yay -S nsxiv --noconfirm
yay -S polybar --noconfirm
yay -S shellcheck-bin --noconfirm

# Install zsh pure prompt
mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"

# Install zsh ssh plugin
git clone https://github.com/sunlei/zsh-ssh ~/.zsh/zsh-ssh

# Install terminal emulator
git clone https://github.com/Shourai/st.git ~/Documents/github/st
cd ~/Documents/github/st || exit
git apply patches/*
sudo make install

git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
