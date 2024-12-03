#!/bin/bash
# Setup user. Requires the $USER variable to be defined or as first argument
if [ -z "$USER" ]; then
	if [ -z "$1" ]; then
		echo "Please define a user name"
		exit 1
	else
		USER=$1
	fi
fi

adduser $USER
adduser $USER sudo
su $USER
cd ~

# Install required packages
sudo apt-get update
sudo apt-get install software-properties-common nano vsftpd curl git
sudo apt-get update
sudo apt-get dist-upgrade
