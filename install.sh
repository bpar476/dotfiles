#!/usr/bin/env bash

# Author: Ben Partridge

# Set up tmux config
./tmux/install.sh

# Symlink vimrc
if [ ! -e ~/.vimrc ] ; then
    ln -sf $(pwd)/vim/vimrc ~/.vimrc
fi
# Install vim plugins
vim +'PlugInstall --sync' +qa

# Symlink nvim config
if [ ! -d ~/.config/nvim ] ; then
    mkdir ~/.config/nvim
fi
if [ ! -e ~/.config/nvim/init.vim ] ; then
    ln -sf $(pwd)/vim/nvimrc ~/.config/nvim/init.vim
fi

# Symlink git config
if [ ! -e ~/.gitconfig ] ; then
    ln -sf $(pwd)/git/gitconfig ~/.gitconfig
fi
