#!/bin/bash

if [[ -f badIPs.txt ]]
then

  read -p "The file already exists, would you like to download it again [y|N]?" answer
  case $answer in
    y|Y)
      echo "Creating badIPs.txt"

      wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules

egrep [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1-3}\.0/[0-9]{1-2} /tmp/emerging-drop.suricata.rules | sort -u | tee badIPs.txt
    ;;
    n|N)
      echo "Not redownloading badIPs.txt"
    ;;
    *)
      echo "Invalid value."
      exit 1
    ;;
    esac

else
echo "Creating badIPs.txt"

wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules

egrep [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1-3}\.0/[0-9]{1-2} /tmp/emerging-drop.suricata.rules | sort -u | tee badIPs.txt

fi


while getopts 'icwmp' OPTION ; do

  case "$OPTION" in
    i)
    	for eachip in $(cat badips.txt)
	do
		echo "iptables -a input -s ${eachip} -j drop" | tee -a  badips.iptables
	done
	clear
	echo "Created IPTables firewall drop rules in file \"badips.iptables\""
	
  	exit 0

    ;;
    c)
	egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0' badips.txt | tee badips.nocidr
	for eachip in $(cat badips.nocidr)
	do
		echo "deny ip host ${eachip} any" | tee -a badips.cisco
	done
	rm badips.nocidr
	clear
	echo 'Created IP Tables for firewall drop rules in file "badips.cisco"'
 	exit 0
    ;;
    w)
	egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0' badips.txt | tee badips.windowsform
	for eachip in $(cat badips.windowsform)
	do
		echo "netsh advfirewall firewall add rule name=\"BLOCK IP ADDRESS - ${eachip}\" dir=in action=block remoteip=${eachip}" | tee -a badips.netsh
	done
	rm badips.windowsform
	clear
	echo "Created IPTables for firewall drop rules in file \"badips.netsh\""
 	exit 0
    ;;
    m)
    	echo '
	scrub-anchor "com.apple/*"
	nat-anchor "com.apple/*"
	rdr-anchor "com.apple/*"
	dummynet-anchor "com.apple/*"
	anchor "com.apple/*"
	load anchor "com.apple" from "/etc/pf.anchors/com.apple"

	' | tee pf.conf

	for eachip in $(cat badips.txt)
	do
		echo "block in from ${eachip} to any" | tee -a pf.conf
	done
	clear
	echo "Created IP tables for firewall drop rules in file \"pf.conf\""
 	exit 0
    ;;
    p)
    	
    ;;
    esac
    
done

