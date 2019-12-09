#!/bin/bash

if [ "$UID" -ne 0 ]
then 
	echo "[$0] Must be root !"
	exit $E_NOTROOT
fi

if [ -n $1 ]
then 
	echo "[$0] Need the new root as Argument"
	exit 1
fi

cp --dereference /etc/resolv.conf $1/etc/

mount --types proc /proc $1/proc
mount --rbind /sys $1/sys
mount --make-rslave $1/sys
mount --rbind /dev $1/dev
mount --make-rslave $1/dev

chroot $1 /bin/bash

