#!/bin/bash
# Author: Dylan Blanque
# Free to share and modify for anyone
# 2026-04-02
LIGHTGREEN='\033[0;32m'
LIGHTBLUE='\033[0;34m'
LIGHTRED='\033[1;31m'
NC='\033[0m'

### ensure script is run as root/sudo
if ! [ "$(id -u)" = 0 ]; then
    if [ "$1" ]; then
        echo -e "${LIGHTRED}Error: root privileges required${NC}"
        exit 1
    fi
    sudo bash "$0"
    exit $?
fi

# Ensure keyrings directory exists
echo -e "${LIGHTBLUE}Installing APT Keyrings Directory${NC}"
install -d -m 0755 /etc/apt/keyrings

# Download Mozilla GPG Key
echo -e "${LIGHTBLUE}Installing Mozilla GPG Key${NC}"
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | \
    tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

# Configure APT Sources from Mozilla
echo -e "${LIGHTBLUE}Configuring Mozilla APT Sources${NC}"
cat <<EOF | tee /etc/apt/sources.list.d/mozilla.sources
Types: deb
URIs: https://packages.mozilla.org/apt
Suites: mozilla
Components: main
Signed-By: /etc/apt/keyrings/packages.mozilla.org.asc
EOF

echo -e "${LIGHTBLUE}Pinning Mozilla APT Packages${NC}"
# Pin Firefox Packages from Mozilla APT Repo
cat <<EOF | tee /etc/apt/preferences.d/mozilla
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
EOF

echo -e "${LIGHTBLUE}Pinning Mozilla APT Packages${NC}"
apt update && \
apt install firefox && \
echo -e "${LIGHTGREEN}Done${NC}" && \
# Only show this if no errors, otherwise I can't bear the shame.
echo "Please star the repo if it was useful for you!"
