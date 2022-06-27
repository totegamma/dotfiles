#!/bin/bash

# install powerline
git clone https://github.com/b-ryan/powerline-shell \
&& cd powerline-shell \
&& python3 setup.py install

# install zsh-autosuggestions
#git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# install zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

