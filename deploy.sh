#!/bin/bash

declare -a targets=(
	"default"
	"acpilight"
	"bash"
	"git"
	"i3"
	"i3blocks"
	"look"
	"rtags"
	"sway"
	"symlinks"
	"vim"
	"X"
)

if [[ $# -eq 0 ]]; then
	echo "Usage: ${0} targets"
	echo "Available targets:"
	for tg in "${targets[@]}"; do
	   echo "    ${tg}"
	done
	echo "default target contains: bash git vim rtags symlinks look acpilight sway i3blocks"
	exit
fi

deploy_acpilight() {
	echo "Deploying acpilight"
	set -x
	sudo cp ./dependencies/acpilight/90-backlight.rules /etc/udev/rules.d/
	sudo cp ./dependencies/acpilight/xbacklight /usr/local/bin/
	sudo udevadm control --reload-rules
	set +x
}

deploy_bash() {
	echo "Deploying bash"
	set -x
	cp bash/.bashrc ~/
	set +x
}

deploy_git() {
	echo "Deploying git"
	set -x
	cp git/.gitconfig ~/
	set +x
}

deploy_i3() {
	echo "Deploying i3"
	set -x
	if ! [[ -d ~/.i3 ]]; then
		mkdir ~/.i3
	fi
	cp i3/config ~/.i3/config
	cp i3/.i3status.conf ~/
	set +x
}

deploy_i3blocks() {
	echo "Deploying i3blocks"
	set -x
	if ! [[ -d ~/.config ]]; then
		mkdir ~/.config
	fi
	cp -r i3blocks ~/.config/
	set +x
}

deploy_look() {
	echo "Deploying look and feel"
	set -x
	cp -r look/Wallpapers ~/
	cp look/.Xresources ~/
	set +x
}

deploy_rtags() {
	echo "Deploying rtags"
	set -x
	if ! [[ -d ~/.config/systemd/user ]]; then
		mkdir -p ~/.config/systemd/user
	fi
	cp rtags/* ~/.config/systemd/user/
	set +x
}

deploy_sway() {
	echo "Deploying sway"
	set -x
	if ! [[ -d ~/.config/sway ]]; then
		mkdir -p ~/.config/sway
	fi
	cp sway/config ~/.config/sway/
	sudo cp sway/sway-launcher /usr/local/bin/
	sudo cp sway/custom-sway.desktop /usr/share/wayland-sessions/
	set +x
}

deploy_symlinks() {
	user_home=~
	set -x
	sudo ln -sf ${user_home}/.bashrc /root/.bashrc
	sudo ln -sf ${user_home}/.vim /root/.vim
	sudo ln -sf ${user_home}/.vimrc /root/.vimrc
	set +x
}

deploy_vim() {
	echo "Deploying vim"
	set -x
	cp -r vim/.vim ~/
	if ! [[ -d ~/.vim/undo ]]; then
		mkdir ~/.vim/undo
	fi
	cp vim/.vimrc ~/
	vim -c ":PlugUpgrade | :PlugInstall | :qa"
	set +x
}

deploy_X() {
	echo "Deploying X"
	set -x
	cp X/.xinitrc ~/
	set +x
}

for option in $@; do
	case ${option} in
	default)
		deploy_bash
		deploy_git
		deploy_vim
		deploy_rtags
		deploy_symlinks
		deploy_look
		deploy_acpilight
		deploy_sway
		deploy_i3blocks
		;;
	acpilight) deploy_acpilight ;;
	bash) deploy_bash ;;
	git) deploy_git ;;
	i3) deploy_i3 ;;
	i3blocks) deploy_i3blocks ;;
	look) deploy_look ;;
	rtags) deploy_rtags ;;
	sway) deploy_sway ;;
	symlinks) deploy_symlinks ;;
	vim) deploy_vim ;;
	[xX]) deploy_X ;;
	*) echo "Unknown target" ;;
	esac
done
