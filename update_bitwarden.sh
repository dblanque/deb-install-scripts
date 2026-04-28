#!/bin/bash
# Author: Dylan Blanque
# Free to share and modify for anyone
# 2025-04-16
LIGHTGREEN='\033[0;32m'
LIGHTBLUE='\033[0;34m'
LIGHTRED='\033[1;31m'
LIGHTYELLOW='\033[1;33m'
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

if [ $(pgrep -c -i "^bitwarden") -ge 1 ]; then
    print_warning "Closing Bitwarden process"
    pkill -i "^bitwarden" || {
        print_error "Please close Bitwarden to update it";
        exit 18;
    }
fi

### download bitwarden and install as root for all users
print_info "Downloading latest Bitwarden version..."
if [ ! -f "$tmp_name" ]; then
    wget -O "$tmp_name" "$url_bitwarden" || {
        print_error "Could not download Bitwarden AppImage";
        exit 1;
    }
else
    print_warning "$tmp_name file already exists, re-utilizing from supposedly previously failed installation"
fi

print_info "Installing AppImage into $bin_target"
cp "$tmp_name" "$bin_target" || {
    print_error "Could not install Bitwarden AppImage";
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

# Add KDE Launcher Application
if [ -d "/usr/share/applications" ]; then
    # Download Bitwarden logo
    {
        if [ ! -d "$share_bw_dir" ]; then
            mkdir -p "$share_bw_dir"
        fi
        wget -O "$share_bw_dir/logo.png" "$url_logo" &&
        chmod 444 "$share_bw_dir/logo.png" &&
        print_info "Installed Bitwarden logo to $share_bw_dir/logo.png";
    } || {
        print_warning "Could not download Bitwarden Logo";
        print_warning "You may download it manually from $url_logo and copy it to $share_bw_dir";
    }

    {
        wget -O "$share_apps_dir/bitwarden.desktop" "$url_launcher_app" &&
        chmod 444 "$share_apps_dir/bitwarden.desktop" &&
        print_info "Installed Bitwarden Launcher Application Template to $share_apps_dir/bitwarden.desktop";
    } || {
        print_error "Could not download Bitwarden Launcher Application Template";
        print_warning "You may download it manually from $url_launcher_app and copy it to $share_apps_dir";
        exit 1
    }
fi

# If all is ok, remove file from /tmp
{
    rm "$tmp_name" &&
    print_info "Removed temporary download file $tmp_name";
} || print_warning "Could not remove $tmp_name, you may do so manually"

# Only show this if no errors, otherwise I can't bear the shame.
print_ok "Please star the repo if it was useful for you!"
