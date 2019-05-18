# Install python 3 libraries

if [ "$(uname)" = "Darwin" ]; then

    # Install python packages
    pip3 install numpy
    pip3 install scipy
    pip3 install matplotlib
    pip3 install jedi
    pip3 install flake8
    pip3 install importmagic
    pip3 install autopep8
    pip3 install sympy
    pip3 install jupyter
    pip3 install neovim

    #Symlink python3 to python
    pypath=$(greadlink -f "$(brew --prefix)"/bin/python3)
    pippath=$(greadlink -f "$(brew --prefix)"/bin/pip3)
    ln -sf "$pypath" "$(brew --prefix)"/bin/python
    ln -sf "$pippath" "$(brew --prefix)"/bin/pip

    echo "Manually install fzf keybindings with"
    echo "/usr/local/opt/fzf/install"
    bash /usr/local/opt/fzf/install

elif [ "$(uname)" = "Linux" ]; then

    # Install python packages
    pip3 install --user numpy
    pip3 install --user scipy
    pip3 install --user matplotlib
    pip3 install --user jedi
    pip3 install --user flake8
    pip3 install --user importmagic
    pip3 install --user autopep8
    pip3 install --user sympy
    pip3 install --user jupyter
    pip3 install --user neovim
fi
