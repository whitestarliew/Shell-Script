#!/bin/bash
#This script creates an acc on the local system.
#you will be prompted for the acc name and password

#ask for the user name.
read -p "enter the username to create: " USER_NAME

#ask for the real name.
read -p "enter the name of the person who this account is for: " COMMENT

#ask password
read -p "Enter the password for the accont: " PASSWORD

#create user .
useradd -c "${COMMENT}" -m ${USER_NAME}
#setup password for the user
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

#Force password to change at first login
passwd -e ${USER_NAME}

