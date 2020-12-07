#!/bin/bash
########################################################################
# 
# Install script for FSL Version 6.0.4
#
# This script downloads the FSL source package, apply several patches
# for building unter Ubuntu 20.04 LTS and build FSL.
#
# This script needs root privileges!
#
# Written by Tobias Krähling <tobias.kraehling@uni-muenster.de>
# Last Change: 2020-12-07
#
########################################################################

FSLBASEDIR=/opt/fsl 
export FSLDIR=${FSLBASEDIR}/fsl-6.0.4
 
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

SCRIPTDIR=`dirname "$(readlink -f "$0")"`
PATCHDIR=${SCRIPTDIR}/patches 

echo ""
echo "========================================================================"
echo "= Install script for FSL 6.0.4                                         ="
echo "========================================================================"

if [[ $EUID -ne 0 ]] ; then
  error "Need root privileges for installing,"
  error "please run script as root or with sudo. Exiting..."
  exit 1
fi

TMP=`mktemp -d` 
imsg "Using temporary directory ${TMP}"
cd ${TMP}
imsg "Download fslinstaller python script..."
wget -O fslinstaller.py https://git.fmrib.ox.ac.uk/fsl/installer/-/raw/master/fslinstaller.py
if [[ $? -ne 0 ]] ; then 
  error "Download fslinstall.py script failed, abort installation..."
  exit 1
fi 

imsg "Download FSL source package..."
python2 fslinstaller.py -s -V 6.0.4
if [[ $? -ne 0 ]] ; then 
  error "Download FSL source package failed, abort installation..."
  cd /tmp
  rm -rf ${TMP}
fi 

imsg "Unpack FSL source package..."
tar xzf fsl-6.0.4-sources.tar.gz
cd fsl 
imsg "Apply patch 'fsl-6.0.4-add-gcc9-cfg'..."
patch -p1 < ${PATCHDIR}/fsl-6.0.4-add-gcc9-cfg.patch
imsg "Apply patch 'fsl-6.0.4-build-console-output'..."
patch -p1 < ${PATCHDIR}/fsl-6.0.4-build-console-output.patch
imsg "Apply patch 'fsl-6.0.4-config-ubuntu-20.04lts'..."
patch -p1 < ${PATCHDIR}/fsl-6.0.4-config-ubuntu-20.04lts.patch
imsg "Apply patch 'fsl-6.0.4-libxmlpp'..."
patch -p1 < ${PATCHDIR}/fsl-6.0.4-libxmlpp.patch
imsg "Apply patch 'fsl-6.0.4-link-order'..."
patch -p1 < ${PATCHDIR}/fsl-6.0.4-link-order.patch
imsg "Apply patch 'fsl-6.0.4-thrust-include'..."
patch -p1 < ${PATCHDIR}/fsl-6.0.4-thrust-include.patch
cd ${TMP}
imsg "Change ownerships"
chown -R root:root fsl 

imsg "Move FSL directory to ${FSLDIR}..."
mv ${TMP}/fsl ${FSLDIR}
. ${FSLDIR}/etc/fslconf/fsl-devel.sh
export MATLABPATH=/opt/MATLAB/addlibs

cd ${FSLDIR}
echo ""
imsg "Start building of FSL, this takes a lot of time..."
echo ""
./build
 
if [[ $? -ne 0 ]] ; then 
  echo ""
  error "Building of FSL failed, see build output..."
  echo ""
  exit 1
fi 
rm -rf ${TMP}
echo ""
imsg "Building of FSL successfull."
echo ""
