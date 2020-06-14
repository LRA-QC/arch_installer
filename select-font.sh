#!/bin/sh
# if needed:
#   tput lines = rows count
#   tput cols  = cols count
#
clear
# INSTALL PACKAGE IF NOT ALREADY INSTALLED 
# pacman -Q terminus-font &>/dev/null||pacman -S terminus-font $OPT &>/dev/null 
# YES/NO
while [ "$ask" != "no" ]; do
  ask=$(echo -e "yes\nno"|percol --prompt "change font (y/n)")
  if [ "$ask" == "yes" ]; then
	  fsize=$(pacman -Ql terminus-font|grep "ter-v"|awk -F'[vn]' '/n\.psf\.gz/ {print $6}'|percol --prompt "Select font size (select no to return to previous menu)")
    setfont ter-v${fsize}n
    echo "FONT=ter-v${fsize}n" > /tmp/font.txt
    exit 0
  fi
done
