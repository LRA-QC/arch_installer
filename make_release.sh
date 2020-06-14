#!/bin/sh
#
# This script will create an archive of all the files required by the installer.
# To install, untar xJf <filename> and launch install.sh
#
OUTPUT=woxarch.tar.xz
chmod +x *.sh
tar cfJ ${OUTPUT} *.sh *.conf LICENSE *.lst README.md
