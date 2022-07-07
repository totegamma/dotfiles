#!/bin/zsh

PROG=$1
PID=$2
CURRENTDIR=$3

if [[ $PROG = "ssh" ]]; then

	COMMAND=$(pgrep -aflP $PID | awk '{print substr($0, length($1)+2)}')

	python3 - $COMMAND << EOF
import argparse
import sys

parser = argparse.ArgumentParser()
parser.add_argument('cmd')
parser.add_argument('address')
parser.add_argument('-p', type=int)
args = parser.parse_known_args(sys.argv[1].split())[0]

print(f" #[fg=brightwhite]REMOTE {args.address} #[fg=colour240,bg=default]")
EOF
	exit
fi

if [[ $PROG = "docker" ]]; then

	COMMAND=$(pgrep -aflP $PID | awk '{print substr($0, length($1)+2)}')

	ARGS=(`echo $COMMAND`)
	positional_args=()

	for ELEM in $ARGS; do
		if [[ $ELEM != -* ]]; then
			positional_args+=$ELEM
		fi
	done

	if [[ $positional_args[2] = "exec" ]]; then
		echo " #[fg=white]$(docker ps | awk "/$positional_args[3]/{print \$NF\"  \"\$1}") #[fg=colour240,bg=default]"
		exit
	fi
fi

cd $CURRENTDIR && python3 ~/.tmux/powerline-client.py tmux left -p ~/.tmux/powerline


