#!/bin/bash
# Author: Dylan Blanque
# Free to share and modify for anyone
# 2025-04-16
LIGHTGREEN='\033[0;32m'
LIGHTBLUE='\033[0;34m'
LIGHTRED='\033[1;31m'
NC='\033[0m'

url_bitwarden="https://vault.bitwarden.com/download/?app=desktop&platform=linux"

### ensure script is run as root/sudo
if ! [ $(id -u) = 0 ]; then
    if [ "$1" ]; then
        echo "Error: root privileges required"
        exit 1
    fi
    sudo bash $0
    exit $?
fi


### download bitwarden and install as root for all users
echo -e "${LIGHTBLUE}Downloading latest Bitwarden version...${NC}"
wget -O /tmp/bitwarden.AppImage $url_bitwarden

echo -e "${LIGHTBLUE}Installing AppImage into /usr/bin${NC}"
if [ $? -eq 0 ]; then
    mv /tmp/bitwarden.AppImage /usr/bin/bitwarden
else
    echo -e "${LIGHTRED}Could not download Bitwarden AppImage.${NC}"
    exit 1
fi

if [ $? -eq 0 ]; then
    # set correct ownership and permissions
    chown root:root /usr/bin/bitwarden
    chmod 755 /usr/bin/bitwarden
    echo "${LIGHTGREEN}Done.${NC}"
else
    echo -e "${LIGHTRED}Could not set correct permissions to /usr/bin/bitwarden${NC}"
    echo -e "${LIGHTRED}Check them manually if you cannot open the program.${NC}"
    exit 1
fi

# Only show this if no errors, otherwise I can't bear the shame.
echo "Please star the repo if it was useful for you!"
