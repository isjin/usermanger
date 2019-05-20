#!/bin/bash
user=$1
date=`date +%Y-%m-%d`
path=~/usermanage

record=`more $usermanager_path/log/user.txt | grep test | tail -n 1 | awk '{print $3}'| wc -l`
if [ $record -gt 0 ];then
	password=`more $usermanager_path/log/user.txt | grep test | tail -n 1 | awk '{print $3}'`
	echo "$password" >passwd_tmp
else
	password=`pwmake 20`
	echo "$date $user $password" >> log/user.txt
	echo "$password" >passwd_tmp
fi