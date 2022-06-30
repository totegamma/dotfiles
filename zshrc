
# Basics
## PATH
PATH=~/Library/Python/3.8/bin:$PATH

## sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin

## PROMPT
PROMPT="%F{111}[%n@%D{%H:%M}]%f%~%# "

## homebrew
eval $(/opt/homebrew/bin/brew shellenv)

# initialize zplug
source ~/.zplug/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# 構文のハイライト(https://github.com/zsh-users/zsh-syntax-highlighting)
zplug "zsh-users/zsh-syntax-highlighting"
# コマンド入力途中で上下キー押したときの過去履歴がいい感じに出るようになる
zplug "zsh-users/zsh-history-substring-search"
# 過去に入力したコマンドの履歴が灰色のサジェストで出る
zplug "zsh-users/zsh-autosuggestions"
# 補完強化
zplug "zsh-users/zsh-completions"
# 256色表示にする
zplug "chrissicool/zsh-256color"
# コマンドライン上の文字リテラルの絵文字を emoji 化する
zplug "mrowa44/emojify", as:command
# lsに色を付ける
zplug "zpm-zsh/ls"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
	printf "Install? [y/N]: "
	if read -q; then
		echo; zplug install
	fi
fi

zplug load

