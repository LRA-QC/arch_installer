#!/bin/bash
echo "-[Change locale]---------------------"
echo "1: English - United States"
echo "2: English - UK"
echo "3: English - Canada"
echo "4: French  - Canada"
echo "5: French  - France"
echo "C: Custom"
echo "E: exit"

LANG="en_US.UTF-8";
while true; do
  read -p "Do you wish to install a Desktop environment? [1-5,c,e] : " ans
  case $ans in
     [1]* ) LANG="en_US.UTF-8"; break;;
     [2]* ) LANG="en_UK.UTF-8"; break;;
     [3]* ) LANG="en_CA.UTF-8"; break;;
     [4]* ) LANG="fr_CA.UTF-8"; break;;
     [5]* ) LANG="fr_fr.UTF-8"; break;;
     [Cc]* ) read -p "Enter the custom locale string : " LANG;  break;;
    [Ee]* ) exit;;
  esac
done
echo "------------------------------------------------"


echo "-[Change keyboard layout]---------------------"
echo "1: United States"
echo "2: UK"
echo "3: Français - Canada"
echo "4: Français - France"
echo "Cc: Custom"
echo -e "e: exit\nCustom layouts: "
localectl list-x11-keymap-layouts|xargs

LAYOUT="us"
while true; do
  read -p "Do you wish to install a Desktop environment? [1,n] : " ans
  case $ans in
     [1]* ) LAYOUT="us"; break;;
     [2]* ) LAYOUT="uk"; break;;
     [3]* ) LAYOUT="ca"; break;;
     [4]* ) LAYOUT="fr"; break;;
     [Cc]* ) read -p "Enter the custom locale string : " LAYOUT;  break;;
    [Ee]* ) exit;;
  esac
done
echo "------------------------------------------------"

echo '- setting utf8 and keyboard'
echo "LANG=$LANG" >>/etc/locale.conf
echo "$LANG UTF-8" >> /etc/locale.gen
echo "KEYMAP=$LAYOUT" >/etc/vconsole.conf
locale-gen &>/dev/null
