#!/bin/bash

PATH="/lib64/firmware/ath10k/QCA9377/hw1.0/firmware-6.bin" # Path to problematic firmware

E_NOTROOT=87 # notroot exit error

# Run as root.
if [ "$UID" -ne 0 ]
then
  echo "Must be root."
  exit $E_NOTROOT
fi  

mv -f $PATH $PATH.moved
