#!/bin/bash
# UserAdd
# ua [NAME] [HOME]

user=$1
home=$2
group=$3


if [ "$3" == "" ]
then
	group=$user
fi

useradd -m -g ${group} -s /bin/bash -d ${home} ${user}
