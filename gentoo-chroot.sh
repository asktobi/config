#!/bin/bash

cp --dereference /etc/resolv.conf /gentoo-root/etc/

mount --types proc /proc /gentoo-root/proc
mount --rbind /sys /gentoo-root/sys
mount --make-rslave /gentoo-root/sys
mount --rbind /dev /gentoo-root/dev
mount --make-rslave /gentoo-root/dev

chroot /gentoo-root /bin/bash

