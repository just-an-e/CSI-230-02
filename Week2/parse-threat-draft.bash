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

else

echo "Creating badIPs.txt"

wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules

egrep [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1-3}\.0/[0-9]{1-2} /tmp/emerging-drop.suricata.rules | sort -u | tee badIPs.txt

fi

while getopts 'icwmp' OPTION ; do

  case "$OPTION" in
    i)
    	for eachIP in $(cat badIPs.txt)
	do
  		echo "block in from ${eachIP} to any" | tee -a pf.conf
	
 		echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPS.iptables

	done
  	exit 0

    ;;
    c)
	for eachIP in $(cat badIPs.txt)
 	do
  		echo "deny ip host ${eachip} any" | tee -a badips.cisco
	
 		echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPS.cisco

	done
 	exit 0
    ;;
    w)
	for eachIP in $(cat badIPs.txt)
 	do
  		echo "netsh advfirewall firewall add rule name=\"BLOCK IP ADDRESS - ${eachip}\" dir=in action=block remoteip=${eachip}" | tee -a badips.netsh
    		
     	done
 	exit 0
    ;;
    m)
    	for eachIP in $(cat badIPs.txt)
 	do

  		echo '
		scrub-anchor "com.apple/*"
		nat-anchor "com.apple/*"
		rdr-anchor "com.apple/*"
		dummynet-anchor "com.apple/*"
		anchor "com.apple/*"
		load anchor "com.apple" from "/etc/pf.anchors/com.apple" 
  
  		' | tee pf.conf
    	done
 	exit 0
    ;;
    p)
    	
    ;;
    
done

