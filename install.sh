#!/usr/bin/env bash

# Author: Ben Partridge

# Set up tmux config
echo "Running tmux install script"
echo "------------------------------------------"
./tmux/install.sh || echo "Error while running tmux install script"
echo ""

# Symlink vimrc -f will update link if it exists
echo "Setting up Vim"
echo "------------------------------------------"
ln -sf $(pwd)/vim/vimrc ~/.vimrc || echo "Error creating vimrc symlink"
# Install vim plugins
vim +'PlugInstall --sync' +qa || echo "Unable to install vim plugins"

# Symlink nvim config
if [ ! -d ~/.config/nvim ] ; then
    mkdir ~/.config/nvim
fi
ln -sf $(pwd)/vim/nvimrc ~/.config/nvim/init.vim
echo ""

# Fill in git config template
echo "Configuring git"
echo "------------------------------------------"
echo -e "\e[42mEnter your desired email to use in git config:\e[0m"
read USER_EMAIL
echo -e "\e[42mEnter your name for git config:\e[0m"
read USER_NAME
sed "s/\${git-email}/$USER_EMAIL/" ./git/gitconfig.templ |
sed "s/\${git-name}/$USER_NAME/" > ./git/gitconfig
echo "GIT CONFIG:"
cat ./git/gitconfig

# Symlink git config
ln -sf $(pwd)/git/gitconfig ~/.gitconfig
