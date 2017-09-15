# Add testing repository
sudo bash -c 'echo "deb http://http.us.debian.org/debian/ testing non-free contrib main" >> /etc/apt/sources.list'

# update package list
sudo apt-get update
sudo apt-get upgrade

# Install packages
sudo apt-get install python3 -y
sudo apt-get install python3-pip -y
sudo apt-get install tmux -y
sudo apt-get install vim -y
sudo apt-get install neovim -y
sudo apt-get install zsh -y
sudo apt-get install zsh-syntax-highlighting -y
sudo apt-get install emacs -y
sudo apt-get install ledger -y
sudo apt-get install fasd -y

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Do a cleanup
sudo apt-get clean
