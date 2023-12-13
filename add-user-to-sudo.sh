#!/bin/bash

# Check if the script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with sudo or as root."
  exit 1
fi

# Define the file containing the list of usernames and passwords
USERLIST_FILE="userlist.txt"

# Check if the userlist file exists
if [ ! -f "$USERLIST_FILE" ]; then
  echo "Error: $USERLIST_FILE not found."
  exit 1
fi

# Read each line from the file, extract the username, and add to sudo group
while read -r line; do
  # Extract username from the line
  username=$(echo "$line" | awk '{print $1}')

  # Check if the user exists
  if id "$username" &>/dev/null; then
    # Add the user to the sudo group
    usermod -aG sudo "$username"
    echo "User $username added to the sudo group."

    # Add entry to sudoers file
    echo "$username   ALL=(ALL:ALL) ALL" >> /etc/sudoers
    echo "User $username added to sudoers file."
  else
    echo "User $username does not exist."
  fi
done < "$USERLIST_FILE"

echo "Script execution completed."



#This script not only adds users to the sudo group but also appends an entry to the sudoers file.
#Please note that modifying the sudoers file should be done with caution, and it's essential to double-check your changes to avoid security issues.
#Always make sure you have a backup before editing critical system files.
