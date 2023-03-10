#!/usr/bin/env bash

# Author: Ben Partridge

# Install basic utilities

sudo apt install -y git openssl curl wget neovim tmux vim man-db zsh fuse3 libfuse2 python3 ruby build-essential dnsutils \
    universal-ctags ca-certificates curl gnupg lsb-release libssl-dev automake autoconf libncurses5-dev xsltproc fop \
    inotify-tools jq

# Setup Directories
mkdir build
mkdir -p $HOME/.local/bin

if ! which nvim > /dev/null
then
    echo "Installing neovim"
    pushd build

    mkdir nvim
    pushd nvim

    wget https://github.com/neovim/neovim/releases/download/v0.8.2/nvim.appimage
    sudo ln -s $(pwd)/nvim.appimage $HOME/.local/bin/nvim

    popd
    popd


    echo "Setting up Neovim"
    echo "------------------------------------------"
    # Symlink nvim config
    if [ ! -d $HOME/.config/nvim ] ; then
        mkdir -p $HOME/.config/nvim
    fi

    ln -sf $(pwd)/vim/nvimrc $HOME/.config/nvim/init.vim
    # Install vim-plug for neovim
    curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    nvim +'PlugInstall --sync' +qa || echo "Unable to install vim plugins"
fi

if ! which aws > /dev/null
then
    pushd build
    mkdir aws
    pushd aws

    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install    

    popd
    popd
fi

if ! which psql > /dev/null
then
    echo "Installing postgres"
    sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    sudo apt-get update
    sudo apt-get -y install postgresql-client-15
    sudo apt install -y libpq-dev
fi

if ! which docker > /dev/null
then
    echo "Installing docker engine"
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    sudo groupadd docker
    current_user = $(whoami)
    sudo usermod -aG docker $current_user

    # WSL issue - docker can't use new iptables
    if [[ "${PLATFORM}" == "WSL" ]]
    then
        sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
        sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
    fi
fi

if [[ $NVM_BIN == "" ]]
then
    echo "Setting up nvm"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
fi

if ! which gh > /dev/null
then
    echo "Installing GitHub CLI"
    type -p curl >/dev/null || sudo apt install curl -y
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install gh -y
fi

if ! [[ -f $HOME/.tmux.conf ]]; then
    # Set up tmux config
    echo "Running tmux install script"
    echo "------------------------------------------"
    ./tmux/install.sh || echo "Error while running tmux install script"
    echo ""
fi

FONTS_DIR="powerline-fonts"
if [ -d $FONTS_DIR ]; then
  echo "already installed fonts"
else
  echo "installing powerline fonts"
  git clone https://github.com/powerline/fonts.git $FONTS_DIR
  $FONTS_DIR/install.sh || echo "failed to install powerline fonts"
fi

if ! [[ -f $HOME/.vimrc ]]; then
    # Symlink vimrc -f will update link if it exists
    echo "Setting up Vim"
    echo "------------------------------------------"
    ln -sf $(pwd)/vim/vimrc $HOME/.vimrc || echo "Error creating vimrc symlink"
    # Install vim plugins
    vim +'PlugInstall --sync' +qa || echo "Unable to install vim plugins"
    echo ""
fi

if ! rustc --version > /dev/null
then
    pushd build
    mkdir rust
    pushd rust

    echo "Installing Rust"

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup-init
    chmod +x rustup-init
    ./rustup-init -y


    popd
    popd
fi

if ! which hx > /dev/null
then
    echo "Installing Helix Editor"

    git clone https://github.com/helix-editor/helix $HOME/helix
    pushd $HOME/helix
    cargo install --locked --path helix-term
    popd

    mkdir -p ~/.config/helix/themes
    ln -sf $HOME/helix/runtime $HOME/.config/helix/runtime
    ln -sf $(pwd)/helix/benparty.toml $HOME/.config/helix/themes/benparty.toml
    ln -sf $(pwd)/helix/config.toml $HOME/.config/helix/config.toml

    echo "Installing language servers"

    npm install -g vscode-html-languageservice
    npm install -g vscode-css-languageservice

    curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
    chmod +x ~/.local/bin/rust-analyzer

    go install golang.org/x/tools/gopls@latest

    mkdir elixir-ls
    pushd elixir-ls
    wget https://github.com/elixir-lsp/elixir-ls/releases/download/v0.13.0/elixir-ls-1.14-25.1.zip
    unzip elixir-ls-1.14-25.1.zip 

    ln -sf $(pwd)/language_server.sh $HOME/.local/bin/elixir-ls 

    popd
fi

if ! terraform version > /dev/null
then
    echo "Installing terraform"

    wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
        https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
        sudo tee /etc/apt/sources.list.d/hashicorp.list

    sudo apt-get update
    sudo apt-get install -y terraform terraform-ls
fi

if ! go version > /dev/null
then
    echo "Installing Go"

    pushd build
    mkdir golang
    pushd golang

    wget "https://go.dev/dl/go1.19.5.linux-amd64.tar.gz"
    sudo tar -C "/usr/local" -xzf "go1.19.5.linux-amd64.tar.gz"

    popd
    popd

    go install golang.org/x/tools/cmd/goimports@latest
fi

if ! asdf version > /dev/null
then
    pushd build
    mkdir asdf
    pushd asdf

    echo "Installing ASDF"

    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2
fi

if ! which iex > /dev/null
then
    echo "Installing erlang"
    # Install erlang/OTP
    asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
    asdf install erlang 25.1
    
    asdf global erlang 25.1

    echo "Installing elixir"
    # Install elixir
    asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git

    asdf install elixir 1.14-otp-25
    asdf global  elixir 1.14-otp-25

    # Install phoenix
    mix local.hex
    mix archive.install hex phx_new
fi

if ! which zsh > /dev/null
then
    echo "Installing ZSH"
    sudo apt install -y zsh
    chsh -s $(which zsh)
    echo "=========configuring oh-my-zsh==========="
    echo "installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ln -sf $(pwd)/zsh/zshrc $HOME/.zshrc
    ln -sf $(pwd)/zsh/zsh_aliases $HOME/.zsh_aliases

    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting
fi

if ! which fish > /dev/null
then
    echo "Installing fish"
    echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_11/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
    curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_11/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null
    sudo apt update
    sudo apt install fish
fi

if ! which javac > /dev/null
then
    echo "Installing Java"
    asdf plugin-add java https://github.com/halcyon/asdf-java.git
    asdf install java temurin-19.0.2+7
    asdf global java temurin-19.0.2+7

    echo "Installing Gradle"
    https://downloads.gradle-dn.com/distributions/gradle-8.0.2-bin.zip
    mkdir -p $HOME/.gradle
    unzip -d $HOME/.gradle gradle-8.0.2-bin.zip
fi

if [ ${1:-"git"} == "--no-git" ] ; then
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
ln -sf $(pwd)/git/gitconfig $HOME/.gitconfig
