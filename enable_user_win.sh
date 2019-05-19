#!/bin/bash
/enable_user_win.sh test bpmuat-win
user=$1
environment=$2
path=~/usermanage

sed "s/{hosts}/$environment/g" $path/playbook/enable-user-win.yml > $path/$environment\-enable-user-win.yml
sed -i "s/{user}/$user/g" $path/$environment\-enable-user-win.yml
ansible-playbook $path/$environment\-enable-user-win.yml
rm -rf $path/$environment\-enable-user-win.yml