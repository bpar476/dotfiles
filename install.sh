#!/usr/bin/env bash

# Author: Ben Partridge

# Set up tmux config
./tmux/install.sh

# Symlink vimrc
ln -s ./vim/vimrc ~/.vimrc
# Clone vim theme

# Install vim plugins
vim +'PlugInstall --sync' +qa

# Symlink nvim config
if [ -d ~/.config/nvim ] ; then
    mkdir ~/.config/nvim
fi
ln -s ./vim/nvimrc ~/.config/nvim/init.vim

