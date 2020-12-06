#!/bin/bash
########################################################################
#
# Install/Update FSLEyes
#
# Written by Tobias Krähling <tobias.kraehling@uni-muenster.de>
# Last Change: 2020-12-06
#
# Requirements: A FSL installation
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
echo "=                    Install/Update FSLEyes                            ="
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
echo ""
imsg "Starting install/update..."
$FSLDIR/fslpython/bin/conda update -n fslpython -c conda-forge --update-deps fsleyes

if [[ $? -ne 0 ]] ; then
  echo ""
  error "Install/update of FSLEyes failed"
  echo ""
  exit 1
else
  echo ""
  imsg "Install/update of FSLEyes successfull"
  echo ""
fi
