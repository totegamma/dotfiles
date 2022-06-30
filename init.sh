#!/bin/bash

# install powerline
git clone https://github.com/b-ryan/powerline-shell \
&& cd powerline-shell \
&& python3 setup.py install

if [ "$OSTYPE" != linux-gnu ]; then  # Is this the macOS system?
	# instlal brew
	brew install coreutils
fi

# install zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

