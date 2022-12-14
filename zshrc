
# Basics

## sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin

## 自動補完　履歴がなかった場合ファイル名で補完する
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

## PROMPT
setopt promptsubst
function set_prompt {
    retVal=$?
    if [ $retVal -ne 0 ]; then
        echo "Exit status: $retVal"
    fi
	if $(tmux has-session &> /dev/null); then
		PROMPT="%F{$(tmux display -p '#{?pane_pipe,yellow,blue}')}[%n@%D{%H:%M}]%f%(3~|.../%2~|%~)$ "
	else
		PROMPT="%F{blue}[%n@%D{%H:%M}]%f%(3~|.../%2~|%~)$ "
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

# fzf
export FZF_DEFAULT_OPTS='--reverse
                         --border-label-pos=3
                         --header=""
                         --info="inline"
                         --no-separator
                         --padding="1"
                         --color="gutter:black,border:blue,label:bold:blue,pointer:white,info:blue,hl:blue,hl+:cyan"
                         --prompt=" "
                         --pointer=" "'

# history
function fzf-select-history() {
  BUFFER=$(\history -n -r 1 | fzf-tmux -p80% --border-label " history " --query "$LBUFFER")
  CURSOR=$#BUFFER
}
zle -N fzf-select-history
bindkey '^r' fzf-select-history

# cdr
## search a destination from cdr list
function fzf-get-destination-from-cdr() {
  cdr -l | \
  sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
  fzf-tmux -p80% --border-label " cdr " --query "$LBUFFER"
}

function fzf-cdr() {
  local destination="$(fzf-get-destination-from-cdr)"
  if [ -n "$destination" ]; then
    BUFFER="cd $destination"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N fzf-cdr
bindkey '^u' fzf-cdr

# file
function fzf-select-file() {
  BUFFER="$LBUFFER$(fd --type f | fzf-tmux -p80% --border-label ' history ')"
  CURSOR=$#BUFFER
}
zle -N fzf-select-file
bindkey '^y' fzf-select-file

# initialize zi
source ~/.zi/bin/zi.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

## zi packages
zi pack for fzf
zi load "zpm-zsh/ls"
zi load "chrissicool/zsh-256color"
zi load "momo-lab/zsh-abbrev-alias"
zi load "zsh-users/zsh-completions"
zi load "zsh-users/zsh-autosuggestions"
zi load "zsh-users/zsh-syntax-highlighting"
zi load "zsh-users/zsh-history-substring-search"

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

## abbr
abbrev-alias -g t="tmux"
abbrev-alias -g v="vim"

abbrev-alias -g C="| <COPYBIN>"
abbrev-alias -g G="| grep"
abbrev-alias -g H="| head"
abbrev-alias -g T="| tail"
abbrev-alias -g J="| jq"
abbrev-alias -g E="| sed -e 's/\x1b\[[0-9;]*m//g'"
abbrev-alias -g N="&> /dev/null"
abbrev-alias -g B="then echo 'y'; else echo 'n'; fi"

abbrev-alias -g dc="docker-compose"
abbrev-alias -g gcm="git commit -m"

abbrev-alias -g da='docker exec -it $(docker ps | tail -n +2 | fzf-tmux -p80% --border-label " docker exec " | awk "{print \$1}") bash'
abbrev-alias -g ds='docker stop $(docker ps | tail -n +2 | fzf-tmux -p80% --border-label " docker stop " | awk "{print \$1}")'

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

