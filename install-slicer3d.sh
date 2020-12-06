#!/bin/bash
########################################################################
# 
# Install script for binary version of Slicer 3D v4.11
#
# This script downloads the binary version of Slicer 3D 
# (Version 4.11.20200930), install it and set a symlink to 
# /usr/local/bin.
#
# Default install directory is /opt/Slicer-4.11, the install directory
# should not be exists.
#
# This script needs root privileges!
#
# Written by Tobias Krähling <tobias.kraehling@uni-muenster.de>
# Last Change: 2020-12-06
#
######################################################################## 

INSTALL_DIR=/opt/Slicer-4.11

error() {
  printf '\E[01;31m'; 
  echo -n "[ERROR] ";
  printf '\E[00;31m';
  echo "$@"; 
  printf '\E[0m'
}
imsg() {
  printf '\E[01;32m'; 
  echo -n "[INFO]  ";
  printf '\E[0m'
  echo "$@"; 
}

echo ""
echo "========================================================================"
echo "=             Install Slicer 3D Version 4.11.20200930                  ="
echo "========================================================================"

if [[ $EUID -ne 0 ]] ; then
  error "Need root privileges for installing,"
  error "please run script as root or with sudo. Exiting..."
  exit 1
fi

if [[ -e ${INSTALL_DIR} ]] ; then
  error "Install directory already exists, abort installation..."
  exit 1
else
  imsg "Using install directory ${INSTALL_DIR}"
fi

TMP=`mktemp -d` 
imsg "Using temporary directory ${TMP}"
cd ${TMP}
imsg "Download binary package of Slicer 3D..."
wget -O slicer.tar.gz https://download.slicer.org/bitstream/1341035
if [[ $? -eq 0 ]] ; then
  imsg "Download successfull"
else
  error "Download failed, abort installation..."
  exit 1
fi
imsg "Unpack binary package..."
tar xzf slicer.tar.gz
imsg "Move to install directory ${INSTALL_DIR}..."
mv Slicer-4.11.20200930-linux-amd64 ${INSTALL_DIR}
imsg "Change ownership to root"
chown -R root:root ${INSTALL_DIR}
imsg "Create symlink in /usr/local/bin..."
ln -fs ${INSTALL_DIR}/Slicer /usr/local/bin/Slicer
imsg "Cleanup temporary directory..."
cd /tmp
rm -rf ${TMP}

echo ""
echo "=== Installation of Slicer 3D finished ==="
echo ""
