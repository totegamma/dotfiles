
# Basics

## sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin

## 自動補完　履歴がなかった場合ファイル名で補完する
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

## PROMPT
setopt promptsubst
function set_prompt {
	if $(tmux has-session &> /dev/null); then
		PROMPT="%F{$(tmux display -p '#{?pane_pipe,yellow,cyan}')}[%n@%D{%H:%M}]%f%(3~|.../%2~|%~)$ "
	else
		PROMPT="%F{cyan}[%n@%D{%H:%M}]%f%(3~|.../%2~|%~)$ "
	fi
}
set_prompt
precmd_functions+=(set_prompt)

# arch specific settings
if [ "$OSTYPE" != linux-gnu ]; then  # Is this the macOS system?
	## homebrew
	eval $(/opt/homebrew/bin/brew shellenv)
	## PATH
	PATH=~/Library/Python/3.8/bin:$PATH
else
	PATH=~/.local/lib/python3.8/site-packages:$PATH
	PATH=~/.local/bin:$PATH
fi

## history
export HISTFILE="${HOME}/.cache/shell/zsh_history"
export HISTORY_IGNORE="(ls|cd|pwd|exit)"
export HISTSIZE=1000
export SAVEHIST=100000
setopt share_history
setopt hist_ignore_dups

## cdr
if [ ! -d ~/.cache/shell ]; then
	mkdir -p ~/.cache/shell
fi
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/shell/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true

## git
export GIT_EDITOR='nvim'

# peco
## 過去に実行したコマンドを選択。ctrl-rにバインド
function peco-select-history() {
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

## search a destination from cdr list
function peco-get-destination-from-cdr() {
  cdr -l | \
  sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
  peco --query "$LBUFFER"
}

## 過去に移動したことのあるディレクトリを選択。ctrl-uにバインド
function peco-cdr() {
  local destination="$(peco-get-destination-from-cdr)"
  if [ -n "$destination" ]; then
    BUFFER="cd $destination"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N peco-cdr
bindkey '^u' peco-cdr

# initialize zi
source ~/.zi/bin/zi.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# 構文のハイライト
zi load "zsh-users/zsh-syntax-highlighting"
# コマンド入力途中で上下キー押したときの過去履歴がいい感じに出るようになる
zi load "zsh-users/zsh-history-substring-search"
# 過去に入力したコマンドの履歴が灰色のサジェストで出る
zi load "zsh-users/zsh-autosuggestions"
# 補完強化
zi load "zsh-users/zsh-completions"
# 256色表示にする
zi load "chrissicool/zsh-256color"
# lsに色を付ける
zi load "zpm-zsh/ls"
# abbr
zi load "momo-lab/zsh-abbrev-alias"

## abbr
abbrev-alias -g t="tmux"
abbrev-alias -g v="vim"

abbrev-alias -g C="| <COPYBIN>"
abbrev-alias -g G="| grep"
abbrev-alias -g P="| peco"
abbrev-alias -g H="| head"
abbrev-alias -g T="| tail"
abbrev-alias -g J="| jq"
abbrev-alias -g E="| sed -e 's/\x1b\[[0-9;]*m//g'"
abbrev-alias -g N="&> /dev/null"
abbrev-alias -g B="then echo 'y'; else echo 'n'; fi"

abbrev-alias -g dc="docker-compose"
abbrev-alias -g gcm="git commit -m"

abbrev-alias -g da='docker exec -it $(docker ps | peco | awk "{print \$1}") bash'
abbrev-alias -g ds='docker stop $(docker ps | peco | awk "{print \$1}")'

# alias & functions

alias vim="nvim"
alias reload="source ~/.zshrc"

function startrec() {
	if [ -v TMUX ]; then
		tmux pipe-pane "cat >> ~/.tmux/log/$(date +'%Y%m%d-%H%M%S').log"
	else
		echo "you must on tmux."
	fi
}

function stoprec() {
	if [ -v TMUX ]; then
		tmux pipe-pane
	else
		echo "you must on tmux."
	fi
}



