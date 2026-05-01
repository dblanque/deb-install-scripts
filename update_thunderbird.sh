#!/bin/bash
# Author: Dylan Blanque
# Free to share and modify for anyone
# 2026-04-30
LIGHTGREEN='\033[0;32m'
LIGHTBLUE='\033[0;34m'
LIGHTRED='\033[1;31m'
LIGHTYELLOW='\033[1;33m'
NC='\033[0m'

# vars init
url_thunderbird="https://download.mozilla.org/?product=thunderbird-latest&os=linux64&lang=en-US"
url_launcher_app="https://raw.githubusercontent.com/mozilla/sumo-kb/main/installing-thunderbird-linux/thunderbird.desktop"
tar_name="thunderbird-latest.tar.xz"
tmp_name="/tmp/$tar_name"
orig_pwd="$(pwd)"
install_dir="/opt"
install_target="$install_dir/thunderbird"
install_target_bkp="$install_target.bkp"
bin_target="/usr/local/bin"
share_apps_dir="/usr/local/share/applications"

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

cd "/tmp"
if [ $(pgrep -c -i "^thunderbird") -ge 1 ]; then
    print_warning "Closing Thunderbird process"
    pkill -i "^thunderbird" || {
        print_error "Please close Thunderbird to update it";
        exit 18;
    }
fi

if [ -d "$install_target_bkp" ]; then
    print_info "Previous installation backup detected at $install_target_bkp, removing."
    
    rm -r "$install_target_bkp" || {
        print_error "Could not remove previous installation backup, please do so manually";
        exit 1
    }
fi

if [ -d "$install_target" ]; then
    print_info "Backing up binaries at $install_target_bkp"
    
    mv "$install_target" "$install_target_bkp" || {
        print_error "Could not backup previous installation, please do so manually";
        exit 1
    }
fi

### download thunderbird and install as root for all users
print_info "Downloading latest Thunderbird version..."
if [ ! -f "$tmp_name" ]; then
    wget -O "$tmp_name" "$url_thunderbird" || {
        print_error "Could not download thunderbird-latest tar archive";
        exit 1;
    }
else
    print_warning "$tmp_name file already exists, re-utilizing from supposedly previously failed installation"
fi

print_info "De-compressing Archive into $install_dir"
tar -xvf "$tmp_name" -C "$install_dir" || {
    print_error "Could not de-compress tar archive";
    exit 1;
}

{
    # set correct ownership
    chown -R root:root "$install_target" &&
    print_ok "Done";
} || {
    print_error "Could not set correct ownership to $install_target";
    print_error "Check them manually if you cannot open the program";
    exit 1;
}

if ! [ -h "/usr/local/bin/thunderbird" ]; then
    ln -s "$install_target/thunderbird" "$bin_target/thunderbird" || {
        print_error "Could not set symlink for binary to $bin_target/thunderbird";
        exit 1;
    }
fi

# Add KDE Launcher Application
if [ -d "$share_apps_dir" ]; then
    {
        wget "$url_launcher_app" -P "$share_apps_dir"
        print_info "Installed Thunderbird Launcher Application Template to $share_apps_dir/thunderbird.desktop";
    } || {
        print_error "Could not download Thunderbird Launcher Application Template";
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
