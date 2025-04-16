#!/bin/bash
# Don't be crazy
# Just use the developer's script

### ensure script is NOT run as root/sudo
if [ $(id -u) = 0 ]; then
	echo "Error: This script should not be run as sudo."
	exit 1
fi

bash <(curl -s https://updates.zen-browser.app/install.sh)
