#!/bin/bash
# Author: Dylan Blanque
# Free to share and modify for anyone
# 2025-08-22
LIGHTGREEN='\033[0;32m'
LIGHTBLUE='\033[0;34m'
LIGHTRED='\033[1;31m'
NC='\033[0m'

url_fwtool="https://github.com/FrameworkComputer/framework-system/releases/latest/download/framework_tool"
bin_name="framework_tool"
bin_target="/usr/bin/framework-tool"

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
echo -e "${LIGHTBLUE}Downloading latest Framework Tool version...${NC}"
wget -O "/tmp/$bin_name" "$url_fwtool"

echo -e "${LIGHTBLUE}Installing Framework Tool into $bin_name${NC}"
mv "/tmp/$bin_name" "$bin_target" || {
    echo -e "${LIGHTRED}Could not download Framework Tool.${NC}";
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
