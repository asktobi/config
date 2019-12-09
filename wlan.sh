#!/bin/bash

WPA_CONFIG="/etc/wpa_supplicant/master.conf" # Default Accesspoint
INTERFACE="wlp2s0" #Default wireless Interface

E_NOTROOT=87 # notroot exit error

# Run as root.
if [ "$UID" -ne 0 ]
then
	echo "[wlan.sh] Must be root!"
	exit $E_NOTROOT
fi  

# Get config if Argument exists
if [ -n "$1" ]
then
	WPA_CONFIG=$1

	# Get interface if Arguments exists
	if [ -n "$2" ]
	then
		INTERFACE=$2
	fi

fi

echo "[wlan.sh] Using $WPA_CONFIG@$INTERFACE."

ip link set $INTERFACE down
macchanger -r $INTERFACE
ip link set $INTERFACE up

wpa_supplicant -B -i $INTERFACE -c $WPA_CONFIG

wpa_cli

dhcpcd $INTERFACE
