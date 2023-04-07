#/bin/bash

# set some colors
CNT="[\e[1;36mNOTE\e[0m]"
COK="[\e[1;32mOK\e[0m]"
CER="[\e[1;31mERROR\e[0m]"
CAT="[\e[1;37mATTENTION\e[0m]"
CWR="[\e[1;35mWARNING\e[0m]"
CAC="[\e[1;33mACTION\e[0m]"
INSTLOG="install.log"

#clear the screen
clear

# set some expectations for the user
echo -e "$CNT - get fkn ready to install some sweet bspwm action!! :c
\n"

sleep 3

read -n1 -rep $'[\e[1;33mACTION\e[0m] - u ready?? (y,n) ' INST
if [[ $INST == "Y" || $INST == "y" ]]; then
    echo -e "$COK - starting install script"
else
    echo -e "$CNT - kbye"
    exit
fi

sleep3

#### Check for yay ####
ISYAY=/sbin/yay
if [ -f "$ISYAY" ]; then 
    echo -e "$COK - yay was located, yay 4 u!"
else 
    echo -e "$CWR - boooo, no yay 4 u"
    read -n1 -rep $'[\e[1;33mACTION\e[0m] - u wanna install yay? (y,n) ' INSTYAY
    if [[ $INSTYAY == "Y" || $INSTYAY == "y" ]]; then
        git clone https://aur.archlinux.org/yay-git.git &>> $INSTLOG
        cd yay-git
        makepkg -si --noconfirm &>> ../$INSTLOG
        cd ..
        
    else
        echo -e "$CER - yay is required for this script. bye"
        exit
    fi
fi

read -n1 -rep $'[\e[1;33mACTION\e[0m] u wanna install the packages? (y,n) ' INST
if [[ $INST == "Y" || $INST == "y" ]]; then
	# update databse first
	echo -e "$COK - updating yay database..."
	yay -Syu --noconfirm &>> $INSTLOG
	
	# stage 1
	echo -e "\n$CNT - whew, we gunna install some stuff... brb" 
	for SOFTWR in sddm-git xorg xdg-user-dirs nitrogen lxappearance wt5ct intel-ucode xfce4-terminal polybar rofi bspwm sxhkd brightnessctl bluez bluez-utils blueman pcmanfm unzip mpv git vim neofetch htop btop libwnck3 geany gvfs brave-bin cava caffeine-ng arcolinux-logout archlinux-tweak-tool-git catppuccin-gtk-theme-mocha picom-pijulius-git pipewire pipewire-audio pipewire-alsa pipewire-pulse pipe-wire-jack wireplumber pamixer pavucontrol ttf-jetbrains-mono-nerd noto-fonts-emoji noto-fonts-cjk bibata-cursor-theme-bin catppuccin-gtk-theme-mocha papirus-icon-theme
	do
		# check is package exists
		if yay -Qs $SOFTWR > /dev/null ; then
			echo -e "$COK - $SOFTWR is already installed"
		else
			echo -e "CNT - now installing $SOFTWR..."
			yay -S --noconfirm $SOFTWR &>> $INSTLOG
			if yay -Qs $SOFTWR > /dev/null ; then
				echo -e "$COK - $SOFTWR installed successfully"
			else
				echo -e "$CER - $SOFTWR install failed. check install.log"
				exit
			fi
		fi
	done


	# stage 2
	echo -e "\n$CNT - now we doin some other stuff..."
	sudo systemctl enable sddm &>> $INSTLOG
	xdg-user-dirs-update
	sleep 2
fi

### Copy Config Files ###
read -n1 -rep $'[\e[1;33mACTION\e[0m] - we want my sweet configs? (y,n) ' CFG
if [[ $CFG == "Y" || $CFG == "y" ]]; then
    echo -e "$CNT - copying config files..."
    
	cp -r catppuccin-wallpapers ~/Pictures
	
	for DIR in bspwm picom polybar sxhkd 
    do 
        DIRPATH=~/.config/$DIR
        if [ -d "$DIRPATH" ]; then 
            echo -e "$CAT - config for $DIR located, backing up."
            mv $DIRPATH $DIRPATH-back &>> $INSTLOG
            echo -e "$COK - backed up $DIR to $DIRPATH-back."
        fi
        echo -e "$CNT - copying $DIR config to $DIRPATH."  
        cp -R $DIR ~/.config/ &>> $INSTLOG
    done
fi	
### Script is done ###
echo -e "$CNT - yeh yeh we done! don't forget to reboot and catppuccin a bunch of stuff c:"

















