#!/bin/bash

#ARCH INSTALLER BY LUC RAYMOND
#

OPT="--color always -q --noprogressbar --noconfirm --logfile pacman-$0.log"
   
echo "--[MIRROR CONFIGURATION]--"
echo "- Downloading new mirrors"
curl -s https://www.archlinux.org/mirrorlist/all/ -o mirrorlist_download
sed 's/\#S/S/' mirrorlist_download > mirrorlist_temp 
cat mirrorlist |tail -n +6|grep -v -e "^$">mirrorlist_temp
file="mirrorlist_temp"
echo -e "- Generating mirrors by country:"
while IFS= read line
do
        # display $line or do something with $line
    a=${line:0:2}
    if [ "$a" == "##" ]; then
        country=${line:3:100}
        echo -n "."
        code=$(sed 's/\ /\_/g' <<<$country)
        file="mirrorlist_$code"
        echo "## $country">$file
    else
        if [ "$a" == "#S" ]; then
            server=${line:1:300}
            echo "$server">>${file}
        fi
    fi
done <"$file"
echo -e "\n"
mv mirrorlist_temp mirrorlist_all_default
ls mirrorlist_*
echo  ""
read -p "type the full name of the mirror that you want to use: " mirror
cp $mirror /etc/pacman.d/mirrorlist
pacman -Syy $OPT 1>/dev/null
