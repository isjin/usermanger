#!/bin/bash
user=$1
environment=$2
path=~/usermanage

sed "s/{hosts}/$environment/g" $path/playbook/disable-user-win.yml > $path/$environment\-disable-user-win.yml
sed -i "s/{user}/$user/g" $path/$environment\-disable-user-win.yml
ansible-playbook $path/$environment\-disable-user-win.yml
rm -rf $path/$environment\-disable-user-win.yml