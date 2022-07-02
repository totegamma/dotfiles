#!/bin/bash

# VARIABLES
SCRIPT_DIR=$(cd $(dirname $0); pwd)

if [[ "$(uname -r)" == *microsoft* ]]; then # Is this WSL?
	COPYBIN='clip.exe'
else
	if [ "$OSTYPE" = linux-gnu ]; then  # Is this linux?
		COPYBIN='xsel -bi'
	else # This is MacOS
		COPYBIN='pbcopy'
	fi
fi

# INSTALL
## install zsh
if ! command -v zsh &> /dev/null ; then
	if [ "$OSTYPE" = linux-gnu ]; then
		apt install -y zsh
	fi
fi

## install curl
if ! command -v curl &> /dev/null ; then
	if [ "$OSTYPE" = linux-gnu ]; then
		apt install -y curl
	fi
fi

## install zplug
if [ ! -d ~/.zplug ]; then
	git clone https://github.com/zplug/zplug ~/.zplug
fi

## install python3
if ! command -v python3 &> /dev/null ; then
	if [ "$OSTYPE" = linux-gnu ]; then
		apt install -y python3
	fi
fi

## install pip3
if ! command -v pip3 &> /dev/null ; then
	if [ "$OSTYPE" = linux-gnu ]; then
		apt install -y python3-pip
	fi
fi

##install powerline-status
if ! $(pip3 show powerline-status &> /dev/null); then
	pip3 install powerline-status
fi

if ! $(pip3 show powerline-gitstatus &> /dev/null); then
	pip3 install powerline-gitstatus
fi

## install tmux
if ! command -v tmux &> /dev/null ; then
	if [ "$OSTYPE" = linux-gnu ]; then
		apt install -y tmux
	fi
fi

## install vim
if ! command -v vim &> /dev/null ; then
	if [ "$OSTYPE" = linux-gnu ]; then
		apt install -y vim
	fi
fi

## install peco
if ! command -v peco &> /dev/null ; then
	if [ "$OSTYPE" = linux-gnu ]; then
		apt install -y peco
	fi
fi

# COPY
cp $SCRIPT_DIR/zshrc ~/.zshrc
cp $SCRIPT_DIR/vimrc ~/.vimrc
cp $SCRIPT_DIR/tmux.conf ~/.tmux.conf
mkdir -p ~/.tmux
cp -R $SCRIPT_DIR/tmux/* ~/.tmux

# POSTPROCESS
sed -i -e "s%<POWERLINE.CONF>%$(pip3 show powerline-status | awk '/Location/{print $2}')/powerline/bindings/tmux/powerline.conf%g" ~/.tmux.conf
sed -i -e "s%<COPYBIN>%$COPYBIN%g" ~/.tmux.conf



