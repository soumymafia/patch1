#!/bin/bash

#created by Dominic Kabel
#https://github.com/domkab16

#Shared under GNU v3

clear

	#Cheeck for Sudo
	if [ "$EUID" -ne "0" ]
	then
		echo "Please run as root"
		exit
	fi

	#Choose External Port
	echo "What external port would you like to open?"
	read -r "extport"

	#Find vpn address
	echo "What is the vpn ip you would like to port forward?"
	read "vpnip"

	#Find Internal port
	echo "what is the internal port?"
	read "intport"

	#What protocol

	echo "What protocol? tcp / udp / tcp/udp"
	read protocol
	if [ \( "$protocol" == "tcp" \) -o \( "$protocol" == "udp" \) -o \( "$protocol" == "tcp/udp" \) ]
	then
		echo "Dope"
	else
		echo "Sorry, that wasnt a specified protocol (　☉д⊙)"
		exit
	fi

	#Double check with user if this is the correct config
	echo "Is this the correct configuration"
	echo "$vpnip:$intport with $protocol $extport as the external port? [y/n]"
	read "confirm"

	#Execution
	if [ "$confirm" == "y" ]
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
	echo "Would you like to save rules or remove them at reboot? [y/n]"
	echo "Please reboot before running and/or saving this script or iptables rules"
	read "save"

	if [ "$save" == "y" ]
	then
		echo "saving"
		iptables-save > /etc/iptables/rules.v4
	fi

	#Reminder to port foward server side
	echo "Done! Remember to add a firewall rule for $extport $protocol server side"
