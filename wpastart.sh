#!/bin/bash

HOME="/etc/wpa_supplicant/master.conf" # Default Accesspoint

E_NOTROOT=87 # notroot exit error

# Run as root.
if [ "$UID" -ne 0 ]
then
  echo "Must be root."
  exit $E_NOTROOT
fi  


if [ -n "$1" ]
then
  accesspoint=$1
else  
  accesspoint=$HOME # Defaults to $HOME
fi  


wpa_supplicant -B -i wlp2s0 -c $accesspoint

