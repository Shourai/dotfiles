# Upgrade and update repos
apt update
apt upgrade

# Install packages
apt install coreutils -y
apt install openssh -y
apt install python -y
apt install vim -y
apt install wget -y
apt install tar -y
apt install less -y
apt install zsh -y

# Termux specific settings
apt install termux-api -y
apt install termux-tools -y
termux-setup-storage