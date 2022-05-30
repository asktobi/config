#!/bin/bash

# setup.sh [User]

if [ "" == "$1" ]
then 
	env_user=env
	env_group=env
	env_home=/var/env/tmp
else
	env_user=$1
	env_group=$1
	env_home=/var/env/$1
fi


if [ ! -d ${env_home} ]
then
	mkdir -p ${env_home}
fi


# Create clean env
if [ ! -f ${env_home}/.bash_profile ]
then
	cat > ${env_home}/.bash_profile << "EOF"
exec env -i HOME=${HOME} TERM=${TERM} PS1='\u:\w\$ ' /bin/bash
EOF
fi

# Setting important Variables
if [ ! -f ${env_home}/.bashrc ]
then
	echo "\
set +h
unset CFLAGS
umask 022
LC_ALL=POSIX
PATH=/bin:/usr/bin
export LC_ALL PATH" \
	>> ${env_home}/.bashrc
fi

chmod 700 ${env_home}
mkdir -v ${env_home}/sources

groupadd ${env_group}
useradd -s /bin/bash -g ${env_group} -d ${env_home} -m -k /dev/null ${env_user}

echo "Want to create a cross compiler ? [n]|y"
read response
if [ "$response" == "y" ]
then 
	cp --no-preserve=ownership build.sh ${env_home}
fi
chown -Rv ${env_user}:${env_group} ${env_home}

echo "ENV-USER:  ${env_user}"
echo "   -GROUP: ${env_group}"
echo "   -HOME:  ${env_home}"

