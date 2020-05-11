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
echo ""

echo "Setting up Neovim"
echo "------------------------------------------"
# Symlink nvim config
if [ ! -d ~/.config/nvim ] ; then
    mkdir -p ~/.config/nvim
fi
ln -sf $(pwd)/vim/nvimrc ~/.config/nvim/init.vim
# Install vim-plug for neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +'PlugInstall --sync' +qa || echo "Unable to install vim plugins"

echo "installing coc plugins"

for server in $(cat vim/cocservers.txt) ; do
  nvim +":CocInstall ${server}" +qa || echo "Unable to install coc language server: ${server}"
done

ln -sf $(pwd)/vim/coc-settings.json ~/.config/nvim/coc-settings.json
echo "nvim configured!"

FONTS_DIR="powerlinet-fonts"
if [ -d $FONTS_DIR ]; then
  echo "already installed fonts"
else
  echo "installing powerline fonts"
  git clone https://github.com/powerline/fonts.git $FONTS_DIR
  $FONTS_DIR/install.sh || echo "failed to install powerline fonts"
fi

if [ $1 == "--no-git" ] ; then
  exit 0
fi

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
