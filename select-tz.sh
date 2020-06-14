#!/bin/sh
set -x
tzl=$(find /usr/share/zoneinfo -maxdepth 1 -type d |tail -n +2|sort|sed 's/\/usr\/share\/zoneinfo\///'|percol --prompt "Select timezone location")
#read -p "- Select time zone location: " tzl
#find /usr/share/zoneinfo/$tzl -maxdepth 1 -type f
tzr=$(ls /usr/share/zoneinfo/$tzl |percol --prompt "Select time zone region")
#read -p "- Select time zone region: " tzr
#full="/usr/share/zoneinfo/$tzl/$tzr"
cp /usr/share/zoneinfo/${tzl}/${tzr} /etc/localtime &>/dev/null
