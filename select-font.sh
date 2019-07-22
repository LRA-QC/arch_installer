#!/bin/bash
OPT="--noconfirm --color always -q --noprogressbar --logfile pacman-$0.log"
echo "--[REFRESHING PACKAGES]--"
pacman -Sy $OPT &>/dev/null
echo "--[FONT SIZE]--"
while [ "$ask" != "n" ]; do
  read -p "change font (y/n) ? type 'n' for no change and continue install : " ask

  if [ "$ask" == "y" ]; then
    for a in {12..32..2};do echo -n "$a " ;done
    echo ""
    read -p "Enter the desired font size: " size

    fsize=$(($size+0))

    if [ $fsize -gt 11 ]; then #&& [ $fsize -lt 33]; then
      if [ $fsize -lt 33 ]; then 
        pacman -S terminus-font $OPT &>/dev/null 
        setfont ter-v${fsize}n
        echo "FONT=ter-v${fsize}n" > font.txt
      fi
    fi
  fi
done
