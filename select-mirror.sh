#!/bin/sh
clear   
echo -e "Downloading new mirrors.. please wait\n..Generating mirrors by country:\n"
curl -s https://www.archlinux.org/mirrorlist/all/ -o /tmp/mirrorlist_download
cat /tmp/mirrorlist_download |tail -n +6|grep -v -e "^$">/tmp/mirrorlist_temp
file="/tmp/mirrorlist_temp"
while IFS= read line
do
    a=${line:0:2}
    if [ "$a" == "##" ]; then
        country=${line:3:100}
        echo -n "."
        code=$(sed 's/\ /\_/g' <<<$country)
        file="/tmp/mirrorlist_$code"
        echo "## $country">$file
    else
        if [ "$a" == "#S" ]; then
            server=${line:1:300}
            echo "$server">>${file}
        fi
    fi
done <"$file"
mv /tmp/mirrorlist_temp /tmp/mirrorlist_all_default
cd /tmp
mirror=`ls -1 mirrorlist_*|percol --prompt="Select a mirror closest to you : "`
cp $mirror /etc/pacman.d/mirrorlist
cd - >/dev/null
pacman -Syy $OPT 1>/dev/null