#!/bin/bash
# Author: Dylan Blanque
# Free to share and modify for anyone
# 2025-04-16
LIGHTGREEN='\033[0;32m'
LIGHTBLUE='\033[0;34m'
LIGHTRED='\033[1;31m'
NC='\033[0m'

url_discord="https://discordapp.com/api/download/stable?platform=linux&format=deb"
deb_name="/tmp/discord-installer.deb"

### ensure script is run as root/sudo
if ! [ "$(id -u)" = 0 ]; then
    if [ "$1" ]; then
        echo -e "${LIGHTRED}Error: root privileges required${NC}"
        exit 1
    fi
    sudo bash "$0"
    exit $?
fi

if pgrep -i "discord" > /dev/null; then
    echo -e "${LIGHTRED}Please close Discord to update it.${NC}"
    exit 1
fi

### download and install as root
echo -e "${LIGHTBLUE}Downloading latest Discord version.${NC}"
wget -O "$deb_name" "$url_discord" || {
    echo -e "${LIGHTRED}Could not download discord, script finished with errors.";
    exit 1;
}

echo -e "${LIGHTBLUE}Installing discord.${NC}"
dpkg -i "$deb_name" || {
    echo -e "${LIGHTRED}Could not install discord, script finished with errors.";
    exit 1;
}

echo -e "${LIGHTBLUE}Removing temporary Discord deb package ($deb_name).${NC}"
rm $deb_name || echo "${LIGHTRED}Could not remove tmp package, you may delete it manually.${NC}"
echo -e "${LIGHTGREEN}Done.${NC}"

# Only show this if no errors, otherwise I can't bear the shame.
echo "Please star the repo if it was useful for you!"
