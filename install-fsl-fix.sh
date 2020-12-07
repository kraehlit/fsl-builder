#!/bin/bash
########################################################################
# 
# Install FSL-FIX Version 1.6.15
#
# This script needs root privileges!
#
# Written by Tobias Krähling <tobias.kraehling@uni-muenster.de>
# Last Change: 2020-12-07
#
######################################################################## 
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
echo "= Install script for FSL-FIX                                           ="
echo "========================================================================"

if [[ $EUID -ne 0 ]] ; then
  error "Need root privileges for installing,"
  error "please run script as root or with sudo. Exiting..."
  exit 1
fi

if [[ "x${FSLDIR}" = "x" ]] ; then 
  error "Needed environment variable 'FSLDIR' not set"
  error "Abort installation..."
  exit 1
fi 

. ${FSLDIR}/etc/fslconf/fsl.sh
PATH=${FSLDIR}/bin:${PATH}

FSLBASEDIR=${FSLDIR}/..

TMP=`mktemp -d` 
imsg "Using temporary directory ${TMP}"

cd ${TMP}

wget http://www.fmrib.ox.ac.uk/~steve/ftp/fix.tar.gz
if [[ $? -eq 0 ]] ; then
  imsg "Download successfull"
else
  error "Download failed, abort installation..."
  rm -rf ${TMP}
  exit 1
fi

imsg "Unpack download package..."
tar xzf fix.tar.gz
imsg "Change ownership..."
chown -R root:root fix
imsg "Install into ${FSLBASEDIR}/fix-1.6.15"
mv fix ${FSLBASEDIR}/fix-1.6.15

imsg "Cleanup temporary directory..."
cd /tmp
rm -rf ${TMP}

echo ""
echo "=== Installation finished ==="
echo ""

