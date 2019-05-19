#!/bin/bash
user=$1
behave=$2
date=`date +%Y-%m-%d`
date_base64=`date | md5sum | base64`
passphrase=`echo ${date_base64:0:16}`
ssh_key_path=~/usermanage/ssh_key/$user
user_bastion_key=$ssh_key_path/$user\_bastion.pem
user_key=$ssh_key_path/$user.pem
mkdir -p $ssh_key_path
if [ $behave == 1 ];then
	if [ ! -f $user_key ];then
		ssh-keygen -t rsa -b 2048 -f $user_key -C "$user" -P ""
		echo "$date $user" >> log/ssh_key.txt
	fi
else
	if [ ! -f $user_bastion_key ];then
		echo "111"
		ssh-keygen -t rsa -b 2048 -f $user_bastion_key -C "$user" -P "$passphrase"
		echo "$date $user $passphrase" >> log/bastion_ssh_key.txt
		echo "$user $passphrase" > sshkey_temp
	fi
fi
