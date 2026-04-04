#!/bin/bash
# Author: Dylan Blanque
# Free to share and modify for anyone
# 2025-04-16
LIGHTGREEN='\033[0;32m'
LIGHTBLUE='\033[0;34m'
LIGHTRED='\033[1;31m'
LIGHTYELLOW='\033[1;33m'
NC='\033[0m'

url_discord="https://discordapp.com/api/download/stable?platform=linux&format=deb"
deb_name="/tmp/discord-installer.deb"

function print_info() {
    echo -e "${LIGHTBLUE}$1${NC}"
}
function print_error() {
    echo -e "${LIGHTRED}$1${NC}"
}
function print_ok() {
    echo -e "${LIGHTGREEN}$1${NC}"
}
function print_warning() {
    echo -e "${LIGHTYELLOW}$1${NC}"
}

### ensure script is run as root/sudo
if ! [ "$(id -u)" = 0 ]; then
    if [ "$1" ]; then
        print_error "Error: root privileges required"
        exit 1
    fi
    sudo bash "$0"
    exit $?
fi

if [ $(pgrep -c -i "^discord") -ge 1 ]; then
    print_error "Please close Discord to update it"
    exit 18
fi

### download and install as root
print_info "Downloading latest Discord version"
wget -O "$deb_name" "$url_discord" || {
    print_error "Could not download discord, script finished with errors";
    exit 19;
}

print_info "Installing discord"
dpkg -i "$deb_name" || {
    print_error "Could not install discord, script finished with errors";
    exit 20;
}

print_info "Removing temporary Discord deb package ($deb_name)"
rm $deb_name || print_error "Could not remove tmp package, you may delete it manually"
print_ok "Done"

# Only show this if no errors, otherwise I can't bear the shame.
echo "Please star the repo if it was useful for you!"
