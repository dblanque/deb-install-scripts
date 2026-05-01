#!/bin/bash
# Author: Dylan Blanque
# Free to share and modify for anyone
# 2026-04-02
LIGHTGREEN='\033[0;32m'
LIGHTBLUE='\033[0;34m'
LIGHTRED='\033[1;31m'
LIGHTYELLOW='\033[1;33m'
NC='\033[0m'

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

# Ensure keyrings directory exists
print_info "Installing APT Keyrings Directory"
install -d -m 0755 /etc/apt/keyrings

# Download Mozilla GPG Key
print_info "Installing Mozilla GPG Key"
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | \
    tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

# Configure APT Sources from Mozilla
print_info "Configuring Mozilla APT Sources"
cat <<EOF | tee /etc/apt/sources.list.d/mozilla.sources
Types: deb
URIs: https://packages.mozilla.org/apt
Suites: mozilla
Components: main
Signed-By: /etc/apt/keyrings/packages.mozilla.org.asc
EOF

print_info "Pinning Mozilla APT Packages"
# Pin Firefox Packages from Mozilla APT Repo
cat <<EOF | tee /etc/apt/preferences.d/mozilla
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
EOF

print_info "Pinning Mozilla APT Packages"
apt update && \
apt install firefox && \
print_ok "Done" && \
# Only show this if no errors, otherwise I can't bear the shame.
echo "Please star the repo if it was useful for you!"
