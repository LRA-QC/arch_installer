#!/bin/bash
# THIS SCRIPT ASSUMES YOU HAVE AN INTERNET CONNECTION ALREADY AVAILABLE

export OPT="--noconfirm --color always -q --noprogressbar --logfile pacman-$0.log"

function cleanup    #CLEANUP FILES
{
    echo "..Cleanup.."
    \rm mirrorlist_* mirrorlist *.temp &>/dev/null
}
export -f cleanup

function validate_target
{
    echo "Validate target"
}
function yesno
{
    echo -e "yes\nno"|percol --prompt "Is everything valid? "
}

#INSTALL PACKAGES REQUIRED FOR INSTALL
./initialize.sh
#read -p "Press ENTER to continue"


P="select which step to complete"
while [ "$item" != "x" ]; 
do
    item=$(cat menu.lst|percol --prompt="$P"|awk -F\) '{print $1}')
    if [ "$item" == 'a' ]; then ./select-font.sh;   fi
    if [ "$item" == 'b' ]; then ./select-mirror.sh; fi
    if [ "$item" == 'c' ]; then ./menu-disk.sh;     fi
    if [ "$item" == 'd' ]; then 
        ./select-target.sh 
        TARGET=$(cat /tmp/target.txt) 
        P="select which step to complete: TARGET [${TARGET}]"
    fi
    if [ "$item" == 'e' ]; then 
	./install-base.sh
        RESULT=$(validate_target ${TARGET})
        if [ "$RESULT" == "OK" ]; then
            echo "Install packages"
        fi
    fi
done
cleanup
