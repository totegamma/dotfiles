#!/bin/bash

# VARIABLES
SCRIPT_DIR=$(cd $(dirname $0); pwd)

if [[ "$(uname -r)" == *microsoft* ]]; then # Is this WSL?
    PLATFORM='WSL'
    COPYBIN='clip.exe'
    PASTEBIN='powershell.exe -command Get-Clipboard'
else
    if [ "$OSTYPE" = linux-gnu ]; then  # Is this linux?
        PLATFORM='LINUX'
        COPYBIN='xsel -bi'
        PASTEBIN='xsel -b0'
    else # This is MacOS
        PLATFORM='MAC'
        COPYBIN='pbcopy'
        PASTEBIN='pbpaste'
    fi
fi

function install_command() {
    if [ $# = 2 ]; then CMD=$2; fi
    if [ $# = 3 ]; then CMD=$3; fi
    if ! command -v $CMD &> /dev/null ; then
        echo "install "$CMD
        if [ "$1" = 'MAC' ]; then
            brew install $2
        else
            apt install -y $2
        fi
        if [ $? != 0 ]; then
            echo "install failed. abort."
            exit
        fi
    fi
}


# INSTALL
install_command $PLATFORM zsh
install_command $PLATFORM curl
install_command $PLATFORM python3
install_command $PLATFORM python3-pip pip3
install_command $PLATFORM tmux
install_command $PLATFORM nvim
install_command $PLATFORM peco

## install zi
if [ ! -d ~/.zi ]; then
	sh -c "$(curl -fsSL https://git.io/get-zi)" -- -i skip -b main
fi

## install powerline-status
if ! $(pip3 show powerline-status &> /dev/null); then
	pip3 install powerline-status
fi

if ! $(pip3 show powerline-gitstatus &> /dev/null); then
	pip3 install powerline-gitstatus
fi

## install vimplug
if [ ! -e "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim ]; then
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

## install vimplugins
nvim -c ":PlugInstall | qa"

# COPY
cp $SCRIPT_DIR/zshrc ~/.zshrc
cp $SCRIPT_DIR/tmux.conf ~/.tmux.conf
mkdir -p ~/.tmux
mkdir -p ~/.config
cp -R $SCRIPT_DIR/tmux/* ~/.tmux
cp -R $SCRIPT_DIR/config/* ~/.config

# POSTPROCESS
sed -i -e "s%<COPYBIN>%$COPYBIN%g" ~/.tmux.conf
sed -i -e "s%<COPYBIN>%$COPYBIN%g" ~/.zshrc
sed -i -e "s%<COPYBIN>%$COPYBIN%g" ~/.config/nvim/init.vim
sed -i -e "s%<PASTEBIN>%$PASTEBIN%g" ~/.config/nvim/init.vim

