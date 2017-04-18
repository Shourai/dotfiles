# Change shell to zsh
sudo sh -c 'echo "$(brew --prefix)/bin/zsh" >> /etc/shells'
chsh -s $(brew --prefix)/bin/zsh

# Change some permissions for zsh
sudo chmod -R 755 $(brew --prefix)/share/zsh
sudo chown -R $USER:admin $(brew --prefix)/share/zsh

# git clone usefull shell functionality
git clone https://github.com/b4b4r07/enhancd.git ~/Documents/enhancd 
