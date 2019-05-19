#!/bin/bash
user=$1
date=`date +%Y-%m-%d`
passwd=`pwmake 20`
echo "$date $user $passwd" >> log/user.txt
echo "$passwd" >passwd_tmp
