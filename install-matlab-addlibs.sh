#!/bin/bash
########################################################################
# 
# Install GIFTI and CIFTI MATLAB libraries.
#
# This script needs root privileges!
#
# Written by Tobias Krähling <tobias.kraehling@uni-muenster.de>
# Last Change: 2020-12-06
#
######################################################################## 

INSTALL_DIR=/opt/MATLAB/addlibs
ECNT=0

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
echo "=             Install additional MATLAB libraries                      ="
echo "========================================================================"

if [[ $EUID -ne 0 ]] ; then
  error "Need root privileges for installing,"
  error "please run script as root or with sudo. Exiting..."
  exit 1
fi

if [[ ! -e ${INSTALL_DIR} ]] ; then
  imsg "Creating directory ${INSTALL_DIR}..."
	mkdir -p ${INSTALL_DIR}
  if [[ $? -ne 0 ]] ; then 
    error "  Creating directory ${INSTALL_DIR} failed, abort installation..."
    exit 1
  fi
fi
cd ${INSTALL_DIR}
echo ""
imsg "Get GIFTI via git clone..."
git clone https://github.com/gllmflndn/gifti.git
if [[ $? -ne 0 ]] ; then 
  error "  Clone GIFTI failed"
  ECNT=1
else 
  imsg "  Clone GIFTI successfull."
fi 
echo ""
imsg "Get cifti via git clone..."
git clone https://github.com/Washington-University/cifti-matlab.git
if [[ $? -ne 0 ]] ; then 
  error "  Clone CIFTI failed"
  ECNT=1
else 
  imsg "  Clone CIFTI successfull."
fi

if [[ ${ECNT} -ne 0 ]] ; then 
  error "Installation of additional MATLAB libraries failed"
  exit 1
else 
  imsg "Installation of additional MATLAB libraries successfull." 
fi
echo ""

