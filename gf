#!/bin/bash
# tjh
# Generate Fenster
# gf [target_dir] [tarball]

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


cp $(dirname $0)/f $target_dir/usr/local/bin/f
cp --dereference /etc/resolv.conf $target_dir/etc/resolv.conf

mount --types proc /proc $target_dir/proc

msg "Enviroment Setup OK"
msg "Chrooting ..."


chmod +x $target_dir/usr/local/bin/f 
chroot $target_dir /usr/local/bin/f

msg "De-escalating Enviroment"

umount -R $target_dir/proc

