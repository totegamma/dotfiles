#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)


#if [ "$OSTYPE" != linux-gnu ]; then  # Is this the macOS system?
#	# instlal brew
#	brew install coreutils
#fi

# INSTALL
## install zsh
if ! command -v zsh &> /dev/null ; then
	if [ "$OSTYPE" = linux-gnu ]; then
		apt install -y zsh
	fi
fi
## install zplug
if [ ! -d ~/.zplug ]; then
	curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
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


