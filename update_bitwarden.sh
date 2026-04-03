#!/bin/bash
# Author: Dylan Blanque
# Free to share and modify for anyone
# 2025-04-16
LIGHTGREEN='\033[0;32m'
LIGHTBLUE='\033[0;34m'
LIGHTRED='\033[1;31m'
NC='\033[0m'

url_bitwarden="https://vault.bitwarden.com/download/?app=desktop&platform=linux"
appimage_name="bitwarden.AppImage"
tmp_name="/tmp/$appimage_name"
bin_target="/usr/bin/bitwarden"

### ensure script is run as root/sudo
if ! [ "$(id -u)" = 0 ]; then
    if [ "$1" ]; then
        echo -e "${LIGHTRED}Error: root privileges required${NC}"
        exit 1
    fi
    sudo bash "$0"
    exit $?
fi

### download bitwarden and install as root for all users
echo -e "${LIGHTBLUE}Downloading latest Bitwarden version...${NC}"
wget -O "$tmp_name" "$url_bitwarden" || {
    echo -e "${LIGHTRED}Could not download Bitwarden AppImage.${NC}";
    exit 1;
}

echo -e "${LIGHTBLUE}Installing AppImage into $bin_target${NC}"
mv "$tmp_name" "$bin_target" || {
    echo -e "${LIGHTRED}Could not install Bitwarden AppImage.${NC}";
    exit 1;
}

{
    # set correct ownership and permissions
    chown root:root "$bin_target" &&
    chmod 755 "$bin_target" &&
    echo -e "${LIGHTGREEN}Done.${NC}";
} || {
    echo -e "${LIGHTRED}Could not set correct permissions to $bin_target${NC}";
    echo -e "${LIGHTRED}Check them manually if you cannot open the program.${NC}";
    exit 1;
}

# Only show this if no errors, otherwise I can't bear the shame.
echo "Please star the repo if it was useful for you!"
