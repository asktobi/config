#!/bin/bash
# tjh
# Generate Gentoo
# gg [target_dir] [tarball]

set -eu

msg () {
	echo "[$0] $1"
}
error () {

	2>&1 msg "(E) $1"
	exit 1
}

if [ ! -d "$1" ] ; then error "Target Directory not found"; else target_dir="$1";fi
if [ ! -e "$2" ] ; then error "Tarball not found"; else tarball="$2";fi

msg "Resources OK"
msg "Unrolling Tarball"

tar xpvf $tarball --xattrs-include='*.*' --numeric-owner -C $target_dir

mkdir -p $target_dir/etc/portage/repos.conf
cp $target_dir/usr/share/portage/config/repos.conf $target_dir/etc/portage/repos.conf/gentoo.conf

msg "Default Repository's copied"

msg "Chrooting ..."

chroot $target_dir /bin/bash

msg "De-escalating Enviroment"

