#!/usr/bin/env bash

name=$(whoami)
home=$(echo $HOME)
old='.backup_config'
   
   Off='\033[0m'	     # Text Reset

   # Regular Colors
   Black='\033[0;30m'        # Black
   Red='\033[0;31m'          # Red
   Green='\033[0;32m'        # Green
   Yellow='\033[0;33m'       # Yellow
   Blue='\033[0;34m'         # Blue
   Purple='\033[0;35m'       # Purple
   Cyan='\033[0;36m'         # Cyan
   White='\033[0;37m'        # White

   # Bold
   BBlack='\033[1;30m'       # Black
   BRed='\033[1;31m'         # Red
   BGreen='\033[1;32m'       # Green
   BYellow='\033[1;33m'      # Yellow
   BBlue='\033[1;34m'        # Blue
   BPurple='\033[1;35m'      # Purple
   BCyan='\033[1;36m'        # Cyan
   BWhite='\033[1;37m'       # White

   # Underline
   UBlack='\033[4;30m'       # Black
   URed='\033[4;31m'         # Red
   UGreen='\033[4;32m'       # Green
   UYellow='\033[4;33m'      # Yellow
   UBlue='\033[4;34m'        # Blue
   UPurple='\033[4;35m'      # Purple
   UCyan='\033[4;36m'        # Cyan
   UWhite='\033[4;37m'       # White

   # Background
   On_Black='\033[40m'       # Black
   On_Red='\033[41m'         # Red
   On_Green='\033[42m'       # Green
   On_Yellow='\033[43m'      # Yellow
   On_Blue='\033[44m'        # Blue
   On_Purple='\033[45m'      # Purple
   On_Cyan='\033[46m'        # Cyan
   On_White='\033[47m'       # White

   # High Intensity
   IBlack='\033[0;90m'       # Black
   IRed='\033[0;91m'         # Red
   IGreen='\033[0;92m'       # Green
   IYellow='\033[0;93m'      # Yellow
   IBlue='\033[0;94m'        # Blue
   IPurple='\033[0;95m'      # Purple
   ICyan='\033[0;96m'        # Cyan
   IWhite='\033[0;97m'       # White

   # Bold High Intensity
   BIBlack='\033[1;90m'      # Black
   BIRed='\033[1;91m'        # Red
   BIGreen='\033[1;92m'      # Green
   BIYellow='\033[1;93m'     # Yellow
   BIBlue='\033[1;94m'       # Blue
   BIPurple='\033[1;95m'     # Purple
   BICyan='\033[1;96m'       # Cyan
   BIWhite='\033[1;97m'      # White

   # High Intensity backgrounds
   On_IBlack='\033[0;100m'   # Black
   On_IRed='\033[0;101m'     # Red
   On_IGreen='\033[0;102m'   # Green
   On_IYellow='\033[0;103m'  # Yellow
   On_IBlue='\033[0;104m'    # Blue
   On_IPurple='\033[0;105m'  # Purple
   On_ICyan='\033[0;106m'    # Cyan
   On_IWhite='\033[0;107m'   # White

#Black='0;30'	
#Red='0;31'	
#Green='0;32'	
#Orange='0;33'	
#Blue='0;34'     
#Purple='0;35'	
#Cyan='0;36'     
#Light_Gray='0;37'     
#Dark_Gray='1;30'
#Light_Red='1;31'
#Light_Green='1;32'
#Yellow='1;33'
#Light_Blue='1;34'
#Light_Purple='1;35'
#Light_Cyan='1;36'
#White='1;37'

pkgs=(
'picom-git'
'awesome-git'
'alacritty'
'brave-bin'
'acpid'
'git'
'mpd '
'ncmpcpp'
'wmctrl'
'lxappearance'
'gucharmap'
'pcmanfm'
'neovim'
'polkit-gnome'
'xdotool'
'xclip'
'scrot'
'brightnessctl'
'alsa-utils'
'pulseaudio'
'jq'
'acpi'
'rofi'
'inotify-tools'
'zsh'
'mpdris2'
'bluez'
'bluez-utils'
'bluez-plugins'
'acpi'
'acpi_call'
'playerctl'
'redshift'
'cutefish-cursor-themes-git'
'cutefish-icons'
'upower'
'xorg'
'xorg-init'
'tar'
)

install_paru() {
	sudo pacman -S cargo --noconfirm --needed
	cargo install paru
}

backup() {
	if [ ! -d $HOME/$old ]; then
		mkdir $HOME/$old
	else
		echo old backups found please move $HOME/$old directory!
		echo do you want to move old backups in /opt directory?
		read move
		case $move in
			[Yy]|[Yy][Ee][Ss])
				sudo mv $HOME/$old /opt
				;;
			[Nn]|[Nn][Oo])
				echo Abort!! Run the script again after deleting or moving the $old to another directory.
				;;
			*) echo Abort!! cannot proceed invalid input.
				exit
		esac
	fi

	if [ -d $HOME/.config ]; then
		echo Creating backuo in $old
		cp -r ~/.config/* $old/
		cp -r ~/.mpd $old/
		cp -r ~/.ncmpcpp $old/
		cp -r ~/.themes $old/
	fi
}

add_new_configs() {
	if [[ -d $PWD/.config && -d $PWD/extras ]]; then
		cp -rf .config/* ~/.config/
		cp -rf extras/mpd ~/.mpd
		cp -rf extras/ncmpcpp ~/.ncmpcpp
		cp -rf extras/fonts ~/.fonts
		cp -rf extras/scripts ~/.scripts
		cp -rf extras/oh-my-zsh ~/.oh-my-zsh
	else 
		echo "Missing files! Something is wring!! you didn't get the all the files."
	       	echo clone the repo again and then run the script again.
		exit
	fi
}

themes() {
	mkdir -P ~/.vscode/extentions/
	cp extras/vscode-theme/Awesthetic ~/.vscode/extentions/
	mkdir ~/.themes
	cp ./themes/* ~/.themes
	cd ~/.themes
	tar -xf Awesthetic.tar
	tar -xf Cutefish-light-modified.tar
	rm Awesthetic.tar Cutefish-light-modified.tar
	cd ~/.config/awesome/misc
	sudo chmod -R +x *
	systemctl --user enable mpd
	sudo systemctl enable bluetooth
}

install() {
	backup
	install_paru
	for pkg in "{$pkgs[@]}"; do
		echo "Installing: $pkg"
		paru -S $pkg --noconfirm --needed
	done
	add_new_configs
	themes
}




if [ $name = root ]; then
	echo -e "\n    ${BRed}Running this script as ${BRed}$name ${BWhite}is not allowed${off}\n"
else
	echo -e "\n    ${BGreen} $USER ${BWhite}is your username. and ${BGreen}$home ${BWhite}this is your home directory location.${off}\n"
	echo -e "\n    ${BRed}if this correct then type yes then press enter.${off}\n"
	read ans
	case $ans in
		[Yy]|[Yy][Ee][Ss])
			install
			;;
		[Nn]|[Nn][Oo])
			echo -e "\n${BRed}Abort!! Make sure you logged in as your user${off}\n"
			echo -e "\n${BRed}Run the script again without sudo or as root user!${off}\n"
			;;
		*) echo -e "\n    ${BRed}wrong answer! ${BWhite}please type ${BGreen}yes ${BWhite}or ${BGreen}no. then press enter.${off}\n"
	esac
fi
