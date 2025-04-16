#!/bin/bash
# Author: Dylan Blanque
# Free to share and modify for anyone
# 2025-04-16
LIGHTGREEN='\033[0;32m'
LIGHTBLUE='\033[0;34m'
LIGHTRED='\033[1;31m'
NC='\033[0m'

url_discord="https://discordapp.com/api/download/stable?platform=linux&format=deb"

### ensure script is run as root/sudo
if ! [ $(id -u) = 0 ]; then
    if [ "$1" ]; then
        echo "Error: root privileges required"
        exit 1
    fi
    sudo bash $0
    exit $?
fi


### download and install as root
echo -e "${LIGHTBLUE}Downloading latest Discord version.${NC}"
wget -O /tmp/discord-installer.deb $url_discord

if [ $? -eq 0 ]; then
    echo -e "${LIGHTBLUE}Installing discord.${NC}"
    dpkg -i /tmp/discord-installer.deb
    echo -e "${LIGHTGREEN}Done.${NC}"
else
    echo -e "${LIGHTRED}Could not install discord, script finished with errors."
    exit 1
fi

# Only show this if no errors, otherwise I can't bear the shame.
echo "Please star the repo if it was useful for you!"
