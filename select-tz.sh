#!/bin/bash
find /usr/share/zoneinfo -maxdepth 1 -type d |tail -n +2|sort|sed 's/\/usr\/share\/zoneinfo\///'
read -p "- Select time zone location: " tzl
#find /usr/share/zoneinfo/$tzl -maxdepth 1 -type f
ls /usr/share/zoneinfo/$tzl 
read -p "- Select time zone region: " tzr
full="/usr/share/zoneinfo/$tzl/$tzr"
cp $full /etc/localtime &>/dev/null
