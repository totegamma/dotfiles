#!/bin/zsh

COMMAND=$1
PID=$2
CURRENTDIR=$3

if [[ $1 = "ssh" ]]; then
	pane_pid=$2
	info=$({ pgrep -flaP $pane_pid ; ps -o command -p $pane_pid; } | xargs -I{} echo {} | awk '/ssh/' | sed -E 's/^[0-9]*[[:blank:]]*ssh //')
	port=$(echo $info | grep -Eo '\-p ([0-9]+)'|sed 's/-p //')
	if [ -z $port ]; then
		local port=22
	fi
	info=$(echo $info | sed 's/\-p '"$port"'//g')
	user=$(echo $info | awk '{print $NF}' | cut -f1 -d@)
	host=$(echo $info | awk '{print $NF}' | cut -f2 -d@)

	if [ $user = $host ]; then
		user=$(whoami)
		list=$(awk '
			$1 == "Host" {
				gsub("\\\\.", "\\\\.", $2);
				gsub("\\\\*", ".*", $2);
				host = $2;
				next;
			}
			$1 == "User" {
				$1 = "";
				sub( /^[[:space:]]*/, "" );
				printf "%s|%s\n", host, $0;
			}' ~/.ssh/config
		)
		echo $list | while read line; do
			host_user=${line#*|}
			if [[ "$host" =~ $line ]]; then
				user=$host_user
				break
			fi
		done
	fi
	echo " #[fg=white]REMOTE ssh:$user@$host #[fg=brightblack,bg=default]"
else
	cd $CURRENTDIR && python3 ~/.tmux/powerline-client.py tmux left -p ~/.tmux/powerline
fi


