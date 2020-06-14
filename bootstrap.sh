#!/bin/sh
DEST=/install
ARCHIVE=woxarch.tar.xz
URL=http://192.168.2.46:8001/${ARCHIVE}

function help
{
    echo -e "\ntype ./install.sh to launch the installer.\n"
    echo -e "\nNOTE: you can prepare your disk(s) and disk partition(s) manually if you want, then launch the installer. If you don't, the installer will give you some choices.\n"
}

rm -Rf ${DEST}      # MAKE SURE PREVIOUS INSTALL IS REMOVED
mkdir -p ${DEST}    # PREPARE EMPTY FOLDER
cd ${DEST} 

clear
echo "WoxArch installer"
echo "- creating install directory"
echo "- downloading install package"
curl -s ${URL} -o ${DEST}/${ARCHIVE} # DOWNLOAD PACKAGE
if [ -e "${DEST}/${ARCHIVE}" ]; then
    echo "- uncompressing"
    tar -xJf "${DEST}/${ARCHIVE}" && rm "${DEST}/${ARCHIVE}" && help  #UNCOMPRESS AND CLEANUP IF SUCCESSFUL
else
    echo "FATAL ERROR: download of the installation package failed"
fi



