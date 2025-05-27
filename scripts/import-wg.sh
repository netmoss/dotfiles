#!/bin/bash
set -e

CONF_FILE="$1"

if [ -z "$CONF_FILE" ] || [ ! -f "$CONF_FILE" ]; then
    echo "Usage: $0 /path/to/wireguard.conf"
    exit 1
fi

read -p "Enter desired WireGuard interface/connection name: " WG_NAME

sudo mv "$CONF_FILE" /etc/wireguard/"$WG_NAME".conf
sudo chmod 600 /etc/wireguard/"$WG_NAME".conf
sudo chown root:root /etc/wireguard/"$WG_NAME".conf
sudo nmcli connection import type wireguard file /etc/wireguard/"$WG_NAME".conf
sudo nmcli connection modify "$WG_NAME" connection.autoconnect no

echo "Imported and named connection/interface as '$WG_NAME'"

