#!/bin/bash
#This script creates a new user on the local system
#You will be prompt to enter username(Login),the person name ,and password

#make sure the script is being executed with superuser priviledges
if [[ "${UID}" != 0 ]]
then
  echo "Please run sudo as a root user/admin"
  exit 1
fi

#enter new name
read -p  "enter the username to create: " USER_NAME

#enter the name who's account for
read -p "Please insert your Real Name: " COMMENT

#Enter the password
read -p "Enter the password for the account: " PASSWORD

#create account/user .
useradd -c "${COMMENT}" -m ${USER_NAME}

#Check  to see whether the useradd command is it success or not
#We dont want to tell the user that an account was created when hasn't been.
if [[ "${?}" != 0 ]]
#you can use -ne instead of !=
then
  echo "There is not  been created"
  exit 1
fi


#setup password for the user
echo ${PASSWORD} |passwd --stdin ${USER_NAME}
if [[ "${?}" != 0 ]]
#Do a reminder that MUST have space between "0" 
then
  echo "wrong password,not been set"
  exit 1
fi 

#Force password change on first login
passwd -e ${USER_NAME}
#stdin is standard in that from the username that you created

#display username ,password,and the host where the users was created
#Please pass the "echo" to another line if it is not then will comes out a blank.
echo
echo "username:"
echo "${USER_NAME}"
echo
echo "password:"
echo
echo "host:"
echo "${HOSTNAME}"
exit 0
