#!/bin/bash
# Author: Dylan Blanque
# Free to share and modify for anyone
# 2025-04-16
LIGHTGREEN='\033[0;32m'
LIGHTBLUE='\033[0;34m'
LIGHTRED='\033[1;31m'
NC='\033[0m'

# vars init
url_bitwarden="https://vault.bitwarden.com/download/?app=desktop&platform=linux"
url_repo="https://raw.githubusercontent.com/dblanque/deb-install-scripts/refs/heads/main"
appimage_name="bitwarden.AppImage"
tmp_name="/tmp/$appimage_name"
bin_target="/usr/bin/bitwarden"

# For KDE Launcher
url_logo="$url_repo/img.d/logo_bitwarden.png"
url_launcher_app="$url_repo/launcher.d/bitwarden.desktop"
share_bw_dir="/usr/share/bitwarden"
share_apps_dir="/usr/share/applications"

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
if [ ! -f "$tmp_name" ]; then
    wget -O "$tmp_name" "$url_bitwarden" || {
        echo -e "${LIGHTRED}Could not download Bitwarden AppImage.${NC}";
        exit 1;
    }
else
    echo -e "${LIGHTYELL}$tmp_name file already exists, re-utilizing from supposedly previously failed installation.${NC}"
fi

echo -e "${LIGHTBLUE}Installing AppImage into $bin_target${NC}"
cp "$tmp_name" "$bin_target" || {
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

# Add KDE Launcher Application
if [ -d "/usr/share/applications" ]; then
    # Download Bitwarden logo
    {
        if [ ! -d "$share_bw_dir" ]; then
            mkdir -p "$share_bw_dir"
        fi
        wget -O "$share_bw_dir/logo.png" "$url_logo" &&
        chmod 444 "$share_bw_dir/logo.png" &&
        echo -e "${LIGHTBLUE}Installed Bitwarden logo to $share_bw_dir/logo.png${NC}";
    } || {
        echo -e "${LIGHTYELL}Could not download Bitwarden Logo${NC}";
        echo -e "${LIGHTYELL}You may download it manually from $url_logo and copy it to $share_bw_dir${NC}";
    }

    {
        wget -O "$share_apps_dir/bitwarden.desktop" "$url_launcher_app" &&
        chmod 444 "$share_apps_dir/bitwarden.desktop" &&
        echo -e "${LIGHTBLUE}Installed Bitwarden Launcher Application Template to $share_apps_dir/bitwarden.desktop${NC}";
    } || {
        echo -e "${LIGHTRED}Could not download Bitwarden Launcher Application Template${NC}";
        echo -e "${LIGHTYELL}You may download it manually from $url_launcher_app and copy it to $share_apps_dir${NC}";
        exit 1
    }
fi

# If all is ok, remove file from /tmp
rm "$tmp_name" || \
    echo -e "${LIGHTYELL}Could not remove $tmp_name, you may do so manually.${NC}"

# Only show this if no errors, otherwise I can't bear the shame.
echo "Please star the repo if it was useful for you!"
