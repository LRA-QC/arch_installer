#!/bin/sh

function setlocale
{
  LANG="en_US.UTF-8";

  echo "-[Change locale]---------------------"
  echo "1: English - United States [en_US.UTF-8]"
  echo "2: English - UK            [en_UK.UTF-8]"
  echo "3: English - Canada        [en_CA.UTF-8]"
  echo "4: French  - Canada        [fr_CA.UTF-8]"
  echo "5: French  - France        [fr_fr.UTF-8]"
  echo "C: Custom"
  echo "E: exit                    [en_US.UTF-8]"
  echo "------------------------------------------------"

  while true; do
    read -p "Do you wish to specify locale? [1-5,c,e] : " ans
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
}

function setkblayout
{
    echo "-[Change keyboard layout]---------------------"
    echo "1: United States"
    echo "2: UK"
    echo "3: Français - Canada"
    echo "4: Français - France"
    echo "C: Custom - see list below"
    echo -e "E: exit\nOther valid custom keyboard layouts: "
    #localectl list-x11-keymap-layouts|xargs

    LAYOUT="us"
    while true; do
      read -p "Do you wish to change the keyboard layout? [1-4,C,N] : " ans
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

}


while true; do
  setlocale
  setkblayout
  echo "LANG: $LANG"
  echo "LAYOUT: $LAYOUT"
  read -p "Are theses values settings correct? (Y/N) : " ans
  case $ans in
    [Yy]* ) exit;;
  esac
done


echo '- setting utf8 and keyboard'
echo "LANG=$LANG" >>/etc/locale.conf
echo "$LANG UTF-8" >> /etc/locale.gen
echo "KEYMAP=$LAYOUT"  >/etc/vconsole.conf
echo "setxkbmap $LAYOUT" > /etc/profile.d/layout.sh
cat /scripts/font.txt >>/etc/vconsole.conf
locale-gen &>/dev/null
