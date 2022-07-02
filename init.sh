#!/bin/bash

# VARIABLES
SCRIPT_DIR=$(cd $(dirname $0); pwd)

if [[ "$(uname -r)" == *microsoft* ]]; then # Is this WSL?
	PLATFORM='WSL'
	COPYBIN='clip.exe'
else
	if [ "$OSTYPE" = linux-gnu ]; then  # Is this linux?
		PLATFORM='LINUX'
		COPYBIN='xsel -bi'
	else # This is MacOS
		PLATFORM='MAC'
		COPYBIN='pbcopy'
	fi
fi

function install_command() {
	if [ $# = 2 ]; then CMD=$2; fi
	if [ $# = 3 ]; then CMD=$3; fi
	if ! command -v $CMD &> /dev/null ; then
		echo "install "$CMD
		if [ "$1" = 'MAC' ]; then
			brew install -y $2
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
install_command $PLATFORM vim
install_command $PLATFORM peco

## install zplug
if [ ! -d ~/.zplug ]; then
	git clone https://github.com/zplug/zplug ~/.zplug
fi

##install powerline-status
if ! $(pip3 show powerline-status &> /dev/null); then
	pip3 install powerline-status
fi

if ! $(pip3 show powerline-gitstatus &> /dev/null); then
	pip3 install powerline-gitstatus
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



