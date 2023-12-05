#!/bin/bash

# Storyline: Menu for admin, VPN, and Security Functions
#Example Code for SYS320

function invalid_opt() {
	echo ""
	echo "Invalid Option"
	echo ""
	sleep 2

}


function menu () {

	# Clears the screen
	clear
	echo "[1] Admin Menu"
	echo "[2] Security Menu"
	echo "[3] Block List Menu"
	echo "[4] Exit"
	read -p "Please enter a choice above: " choice

	case "$choice" in 
		1) admin_menu
		;;
		
		2) security_menu
		;;
		
		3) block_list_menu
		;;
		
		4) exit 0
		;;
		
		*)
			invalid_opt
			
			# Call the Menu
			menu
		;;
		

	esac

}

function admin_menu() {
	clear	
	echo "[L]ist Running Proccesses"
	echo "[N]etwork Sockets"
	echo "[V]PN Menu"
	echo "[4] Exit"
	read -p "Please enter a choice above: " choice

	case "$choice" in
		L|l) ps -ef |less 
		;;
		N|n) netstat -an --inet|less
		;;
		V|v) vpn_menu
		;;
		4) exit 0
		;;
		*)
			invalid_opt
			#call admin menu
			admin_menu
		;;


	esac

admin_menu
}

function vpn_menu() {
	clear
	echo "[A]dd a peer"
	echo "[D]elete a peer"
	echo "[C]heck if a user exists"
	echo "[B]ack to admin menu"
	echo "[M]ain menu"
	echo "[E]xit "
	read -p "Please  enter a choice above:" choice
	case "$choice" in
	A|a)
	  bash peer.bash
	  tail -6 wg0.conf |less
	;;
	D|d) #Create a promtp for the user
		read -p "Please specify a user" user
		# Call the manage-users.bash and pass the proper switches and arguement
		bash manage-users.bash -d -u "$user"
		#  to delete the user
	;;
	C|c) #check if a user exists
		read -p "Which user would you like to check for?" user
		bash manage-users.bash -c -u ${user}
		read -p "Press any button to proceed:" response
	;;
	B|b) admin_menu
	;;
	M|m) menu
	;;
	E|e) exit 0
	;;
	*)
		invalid_opt
		vpn_menu
	;;

	esac

vpn_menu

}

function security_menu() {
	clear
	echo "[C]heck the last 10 logged in users"
	echo "[L]ogged in users"
	echo "[B]ack to main menu"
	echo "[E]xit"
	read -p "Please enter a choice above:" choice
	case "$choice" in
		O|o) netstat -l |less
		;;
		U|u) cat /etc/passwd | grep "x:0" | less
		;;
		C|c) last -n 10 | less
		;;
		L|l) who | less
		;;
		E|e) exit 0
		;;
		B|b) menu
		;;
		*)
			invalid_opt
		;;

	esac


security_menu
}

function block_list_menu {
	clear
	echo "[I]PTables"
	echo "[C]isco"
	echo "[W]indows Firewall"
	echo "[M]ac OS"
	echo "[P]arse Cisco"
	echo "[B]ack to main menu"
	echo "[E]xit"
	read -p "Please enter a choice above:" choice
	case "$choice" in
		E|e) exit 0
		;;
		B|b) menu
		;;
		I|i) bash parse-threat-updated.bash -i
		;;
		C|c) bash parse-threat-updated.bash -c
		;;
		W|w) bash parse-threat-updated.bash -w
		;;
		M|m) bash parse-threat-updated.bash -m
		;;
		P|p) bash parse-threat-updated.bash -p
		;;
		*)
			invalid_opt
		;;

	esac
 	block_list_menu
}

# Call the main function
menu
