#!/bin/bash

#created by Soumy

#Shared under GNU v3

clear

	#Cheeck for Sudo
	if [ "$EUID" -ne "0" ]
	then
		echo "Harap Gunakan root"
		exit
	fi

	#Choose External Port
	echo "Port eksternal apa yang ingin Anda buka?"
	read -r "extport"

	#Find vpn address
	echo "ip yang ingin Anda pointing?"
	read "vpnip"

	#Find Internal port
	echo "port internal?"
	read "intport"

	#What protocol

	echo "pake protocol apa? tcp / udp / tcp/udp"
	read protocol
	if [ \( "$protocol" == "tcp" \) -o \( "$protocol" == "udp" \) -o \( "$protocol" == "tcp/udp" \) ]
	then
		echo "Dope"
	else
		echo "Maaf, itu bukan protokol yang ditentukan"
		exit
	fi

	#Double check with user if this is the correct config
	echo "Is this the correct configuration"
	echo "$vpnip:$intport with $protocol $extport as the external port? [y/n]"
	read "confirm"

	#Execution
	if [ "$confirmasi" == "y" ]
	then

		if [ "$protocol" == "tcp" ]
		then
			iptables -A PREROUTING -t nat -i  ens4 -p tcp --dport "$extport" -j DNAT --to "$vpnip":"$intport"
			iptables -A FORWARD -p tcp -d "$vpnip" --dport "$extport" -j ACCEPT
		fi

		if [ "$protocol" == "udp" ]
		then
			iptables -A PREROUTING -t nat -i ens4 -p udp --dport "$extport" -j DNAT --to "$vpnip":"$intport"
			iptables -A FORWARD -p udp -d "$vpnip" --dport "$extport" -j ACCEPT
		fi

		if [ "$protocol" == "tcp/udp" ]
		then
			iptables -A PREROUTING -t nat -i  ens4 -p tcp --dport "$extport" -j DNAT --to "$vpnip":"$intport"
			iptables -A FORWARD -p tcp -d "$vpnip" --dport "$extport" -j ACCEPT
			iptables -A PREROUTING -t nat -i ens4 -p udp --dport "$extport" -j DNAT --to "$vpnip":"$intport"
			iptables -A FORWARD -p udp -d "$vpnip" --dport "$extport" -j ACCEPT
		fi

	else
		echo "Script Terminating"
		exit
	fi

	#Asking To Save rules
	echo "Apakah Anda ingin menyimpan aturan atau menghapusnya saat reboot? [y/n]"
	echo "Harap reboot sebelum menjalankan dan/atau menyimpan skrip atau aturan pointing ini"
	read "save"

	if [ "$save" == "y" ]
	then
		echo "saving"
		iptables-save > /etc/iptables/rules.v4
	fi

	#Reminder to port foward server side
	echo "Selesai! Ingatlah untuk menambahkan aturan pointing $extport$ protocol sisi server"
