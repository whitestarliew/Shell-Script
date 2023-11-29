#!/bin/bash
#This script creates a new user on the local system
#You will be prompt to enter username(Login),the person name ,and password

#make sure the script is being executed with superuser priviledges
if [[ "${UID}" != 0 ]]
then
  echo "Please go to sudo as a root user/admin"
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
----------------------------------------------------------
#!/bin/bash

# Prompt for source repo
read -p "Please fill in the source repo: " source_repo

# Prompt for destination repo
read -p "Please fill in the destination repo: " destination_repo

# Validate source and destination repos
if [ -z "$source_repo" ] || [ -z "$destination_repo" ]; then
    echo "Error: Source and destination repos cannot be empty."
    exit 1
fi

# Set ECR region
ecr_region="us-east-1"

# Docker pull
docker pull $source_repo

# Check if the pull was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to pull the Docker image from $source_repo."
    exit 1
fi

# Authenticate Docker to the ECR registry
aws ecr get-login-password --region $ecr_region | docker login --username AWS --password-stdin $destination_repo

# Check if login was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to authenticate Docker to ECR registry $destination_repo."
    exit 1
fi

# Tag the Docker image
docker tag $source_repo $destination_repo

# Check if tagging was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to tag the Docker image."
    exit 1
fi

# Docker push
docker push $destination_repo

# Check if push was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to push the Docker image to $destination_repo."
    exit 1
fi

echo "Docker image successfully pushed to $destination_repo in $ecr_region."

