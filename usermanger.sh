#!/bin/bash
user=$1
system=$2
environment=$3
operator=$4
permission=$5
path=~/usermanage

if [ $operator == "add" ];then
	bash $path/sshkey_generate.sh $user 2
	sed "s/{hosts}/local/g" $path/playbook/adduser-linux.yml > $path/local-adduser-linux.yml
	sed -i "s/{user}/$user/g" $path/local-adduser-linux.yml
	sed -i "s/{sshkey}/ssh_key\/$user\/$user\_bastion.pem.pub/g" $path/local-adduser-linux.yml
	ansible-playbook $path/local-adduser-linux.yml
	rm -rf $path/local-adduser-linux.yml
	echo "Bastion ssh key passphrase:" >> $path/ssh_key/$user/$user\.txt
	tail -n 1 log/bastion_ssh_key.txt >> $path/ssh_key/$user/$user\.txt
else
	sed "s/{hosts}/local/g" $path/playbook/deleteuser-linux.yml > $path/local-adduser-linux.yml
	sed -i "s/{user}/$user/g" $path/local-adduser-linux.yml
	ansible-playbook $path/local-adduser-linux.yml
	rm -rf $path/local-adduser-linux.yml
fi

if [ $system == "windows" ];then
##windows##
	if [ $operator == "add" ];then
		bash $path/passwdgenerate.sh $user 2
		password=`more $path/passwd_tmp`
		echo "Windows server login user infomation:" >> $path/ssh_key/$user/$user\.txt
		tail -n 1 log/user.txt >> ssh_key/$user/$user\.txt
		sed "s/{hosts}/$environment/g" $path/playbook/adduser-win.yml > $path/$environment\-adduser-win.yml
		sed -i "s/{user}/$user/g" $path/$environment\-adduser-win.yml
		sed -i "s/{password}/$password/g" $path/$environment\-adduser-win.yml
		sed -i "s/{group1}/$permission/g" $path/$environment\-adduser-win.yml
		ansible-playbook $path/$environment\-adduser-win.yml
		rm -rf $path/$environment\-adduser-win.yml
		zip $path/$user $path/ssh_key/$user/*
	else
		sed "s/{hosts}/$environment/g" $path/playbook/deleteuser-win.yml > $path/$environment\-deleteuser-win.yml
		sed -i "s/{user}/$user/g" $path/$environment\-deleteuser-win.yml
		ansible-playbook $path/$environment\-deleteuser-win.yml
		rm -rf $path/$environment\-deleteuser-win.yml
	fi
else
	if [ $operator == "add" ];then
		bash $path/sshkey_generate.sh $user 1
		sed "s/{hosts}/$environment/g" $path/playbook/adduser-linux.yml > $path/$environment\-adduser-linux.yml
		sed -i "s/{user}/$user/g" $path/$environment\-adduser-linux.yml
		sed -i "s/{sshkey}/ssh_key\/$user\/$user\.pem.pub/g" $path/$environment\-adduser-linux.yml
		ansible-playbook $path/$environment\-adduser-linux.yml
		rm -rf $path/$environment\-adduser-linux.yml
		if [ $permission == "sudo" ];then
			sed "s/{hosts}/$environment/g" $path/playbook/sudoer.yml > $path/$environment\-sudoer.yml
			sed -i "s/{user}/$user/g" $path/$environment\-sudoer.yml
			sed -i "s/{sshkey}/ssh_key\/$user\/$user\.pem.pub/g" $path/$environment\-sudoer.yml
			ansible-playbook $path/$environment\-sudoer.yml
			rm -rf $path/$environment\-sudoer.yml
		fi
		zip $path/$user $path/ssh_key/$user/*
	else
		sed "s/{hosts}/$environment/g" $path/playbook/deleteuser-linux.yml > $path/$environment\-deleteuser-linux.yml
		sed -i "s/{user}/$user/g" $path/$environment\-deleteuser-linux.yml
		ansible-playbook $path/$environment\-deleteuser-linux.yml
		rm -rf $path/$environment\-deleteuser-linux.yml
	fi
fi

