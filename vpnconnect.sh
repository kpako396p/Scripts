#!/bin/bash

configs=$(ls /etc/vpnc/)

function connect(){
  num=0
	for config in $configs;
	do
		if [[ $config = *".conf"* ]]; then
			let num=($num + 1)
			array[$num]=$config
		fi
	done
	echo "--------------------------"
	for i in "${!array[@]}";
	do
		echo $i. ${array[$i]}
	done

	echo "----------------------------"
	echo "Please, select the config:"
	echo "----------------------------"
	read -r CONFIG
	pid=$(pidof vpnc)

	if [[ $? -eq 0 ]]; then
		echo "----------WARNING---------"
		CONNECTION=$(cat /proc/$pid/cmdline) &> /dev/null
		echo "You have already established connecton: "
		echo $CONNECTION
		echo -e "Disconnect?"
		read -r DISCONNECT
		case $DISCONNECT in
		  y|Y) 
					sudo vpnc-disconnect
					sudo vpnc ${array[$CONFIG]}
					echo "Connection with ${array[$CONFIG]} is established";;
		  n|N) 
					echo Aborting ;;
		  *) echo dont know ;;
		esac
	else
		echo "Connecting to ${array[$CONFIG]}"
		sudo vpnc "${array[$CONFIG]}"
		echo "Connection with ${array[$CONFIG]} is established"
	fi

}

connect
