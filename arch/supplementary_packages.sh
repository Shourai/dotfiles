# Install supplementary packages
sudo pacman -S buku --noconfirm
sudo pacman -S chromium --noconfirm
sudo pacman -S firefox --noconfirm
sudo pacman -S man --noconfirm
sudo pacman -S newsboat --noconfirm
sudo pacman -S npm --noconfirm
sudo pacman -S seahorse --noconfirm
sudo pacman -S syncthing --noconfirm
yay -S 1password --noconfirm
yay -S brave-bin --noconfirm
yay -S dragon-drop-git --noconfirm

# Add nnn plugins
sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"

# Install tabbed for nnn tabbed to work
git clone https://git.suckless.org/tabbed ~/Documents/github/tabbed
cd ~/Documents/github/tabbed || exit
sudo make install
