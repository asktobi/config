#!/bin/bash

# setup-rm.sh [User]

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

echo "WARNING ! DELETE THOSE ? [n]|y ?"
echo "ENV-USER:  ${env_user}"
echo "   -GROUP: ${env_group}"
echo "   -HOME:  ${env_home}"
read response

if [ "y" != "$response" ]
then
	echo "STOPPED DELETION"
	exit 0
fi

if [[ -d ${env_home} && "${env_home}" != "/var/env/"  ]]
then
	rm -rvf ${env_home}
fi

userdel ${env_user}
groupdel ${env_group}
