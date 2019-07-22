#!/bin/bash 

read -p "Enter user name (press ENTER with empty value to cancel): " USER_NAME
if [ -n "$USER_NAME" ]; then
  read -p "Enter a description: " USER_COMMENT
  useradd -m "$USER_NAME" --comment "$USER_COMMENT" 1>/dev/null
  passwd "$USER_NAME"
  while true; 
  do
    read -p "Do you need sudo privilege (admin) for this users? [y/n] " ans
    case $ans in
      [Yy]* ) echo "$USER_NAME ALL=(ALL) NOPASSWD: ALL">"/etc/sudoers.d/$USER_NAME"; break;;
      [Nn]* ) exit;;
    esac
  done 
fi


