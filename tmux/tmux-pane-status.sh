#!/bin/zsh

PROG=$1
PID=$2
CURRENTDIR=$3

if [[ $PROG = "ssh" ]]; then

	COMMAND=$(pgrep -aP $PID | awk '{print substr($0, length($1)+2)}')
	ARGS=(`echo $COMMAND`)
	positional_args=()

	for ELEM in $ARGS; do
		if [[ $ELEM != -* ]]; then
			positional_args+=$ELEM
		fi
	done

	echo " #[fg=brightwhite]REMOTE $positional_args[2] #[fg=colour240,bg=default]"
	exit
fi

if [[ $PROG = "docker" ]]; then

	COMMAND=$(pgrep -aP $PID | awk '{print substr($0, length($1)+2)}')
	ARGS=(`echo $COMMAND`)
	positional_args=()

	for ELEM in $ARGS; do
		if [[ $ELEM != -* ]]; then
			positional_args+=$ELEM
		fi
	done

	if [[ $positional_args[2] = "exec" ]]; then
		echo " #[fg=brightwhite]$(docker ps | awk "/$positional_args[3]/{print \$NF\" [\"\$1\"]\"}") #[fg=colour240,bg=default]"
		exit
	fi
fi

cd $CURRENTDIR && python3 ~/.tmux/powerline-client.py tmux left -p ~/.tmux/powerline


