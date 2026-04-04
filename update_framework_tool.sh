#!/bin/bash
# Author: Dylan Blanque
# Free to share and modify for anyone
# 2025-08-22
LIGHTGREEN='\033[0;32m'
LIGHTBLUE='\033[0;34m'
LIGHTRED='\033[1;31m'
LIGHTYELLOW='\033[1;33m'
NC='\033[0m'

url_fwtool="https://github.com/FrameworkComputer/framework-system/releases/latest/download/framework_tool"
bin_name="framework_tool"
bin_target="/usr/bin/framework-tool"

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


### download bitwarden and install as root for all users
print_info "Downloading latest Framework Tool version..."
wget -O "/tmp/$bin_name" "$url_fwtool"

print_info "Installing Framework Tool into $bin_name"
mv "/tmp/$bin_name" "$bin_target" || {
    print_error "Could not download Framework Tool";
    exit 1;
}

{
    # set correct ownership and permissions
    chown root:root "$bin_target" &&
    chmod 755 "$bin_target" &&
    print_ok "Done";
} || {
    print_error "Could not set correct permissions to $bin_target";
    print_error "Check them manually if you cannot open the program";
    exit 1;
}

# Only show this if no errors, otherwise I can't bear the shame.
echo "Please star the repo if it was useful for you!"
