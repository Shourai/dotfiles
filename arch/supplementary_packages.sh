# Install supplementary packages
sudo pacman -S chromium --noconfirm
sudo pacman -S firefox-developer-edition --noconfirm
sudo pacman -S man --noconfirm
sudo pacman -S newsboat --noconfirm
sudo pacman -S syncthing --noconfirm
yay -S 1password --noconfirm
yay -S brave-bin --noconfirm
yay -S buku --noconfirm
yay -S dragon-drop-git --noconfirm

## Add nnn plugins
#sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"
#
## Install tabbed for nnn tabbed to work
#git clone https://git.suckless.org/tabbed ~/Documents/github/tabbed
#cd ~/Documents/github/tabbed || exit
#sudo make install

# x11 packages
#sudo pacman -S picom --noconfirm
#sudo pacman -S nitrogen --noconfirm
#sudo pacman -S flameshot --noconfirm
#sudo pacman -S bspwm --noconfirm
#sudo pacman -S sxhkd --noconfirm
#sudo pacman -S xclip --noconfirm
#sudo pacman -S xorg-server --noconfirm
#sudo pacman -S xorg-xinit --noconfirm
#yay -S betterlockscreen --noconfirm
#yay -S flashfocus --noconfirm
#yay -S nsxiv --noconfirm
#yay -S polybar --noconfirm


# Install terminal emulator
#git clone https://github.com/Shourai/st.git ~/Documents/github/st
#cd ~/Documents/github/st || exit
#git apply patches/*
#sudo make install
