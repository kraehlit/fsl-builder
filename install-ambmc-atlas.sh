#!/bin/bash
###############################################################################
#
# Install script for the FSL Atlas Package 
# from the Australian Mouse Brain Mapping Consortium (AMBMC)
# 
# Written by Tobias Krähling <tobias.kraehling@uni-muenster.de>
# Last Change: 2020-11-28
# 
# For information about the mouse brain atlas see
# https://imaging.org.au/AMBMC/AMBMC
#
# Requirements: A FSL installation
#
###############################################################################

# Name of the group, which should be have write permission to config files
CFGRWGROUP=fsl 

echo "========================================================================"
echo "= Install script for AMBMC FSL atlas package                           ="
echo "========================================================================"
if [ "x${FSLDIR}" = "x" ] ; then 
  echo "[ERROR] Needed environment variable 'FSLDIR' not set"
  echo "[ERROR] Installation not successfull"
fi 

. ${FSLDIR}/etc/fslconf/fsl.sh
PATH=${FSLDIR}/bin:${PATH}

which flirt > /dev/null 2>&1
if [ $? -ne 0 ] ; then
	echo "[ERROR] FSL installation not found, exiting..."
	exit 1
fi

TMP=`mktemp -d` 
echo "[INFO] Using temporary directory ${TMP}"

cd ${TMP}
echo "[INFO] Starting download of the AMBMC FSL atlas package..."
wget https://imaging.org.au/uploads/AMBMC/ambmc-c57bl6-FSL-atlas_v0.8.tar.gz
if [ $? -ne 0 ] ; then
  echo "[ERROR] Download not successfull, exiting..."
  rm -rf ${TMP}
  exit 1
fi
echo "[INFO] Unpack download package..."
tar xzf ambmc-c57bl6-FSL-atlas_v0.8.tar.gz
echo ""
echo "[INFO] Starting installation into FSL (directory ${FSLDIR})" 
if [ ! -e ${FSLDIR}/data/atlases/AMBMC ] ; then
	mkdir -p ${FSLDIR}/data/atlases/AMBMC
	echo "[INFO]  Create directory ${FSLDIR}/data/atlases/AMBMC..."
fi
echo "[INFO]  Copy files to ${FSLDIR}/data/atlases/AMBMC..."
cp ambmc-c57bl6-FSL-atlas_v0.8/AMBMC-c57bl6-basalganglia-labels-15um.nii.gz ${FSLDIR}/data/atlases/AMBMC/
cp ambmc-c57bl6-FSL-atlas_v0.8/AMBMC-c57bl6-cerebellum-labels-15um.nii.gz   ${FSLDIR}/data/atlases/AMBMC/
cp ambmc-c57bl6-FSL-atlas_v0.8/AMBMC-c57bl6-cortex-labels-15um.nii.gz       ${FSLDIR}/data/atlases/AMBMC/
cp ambmc-c57bl6-FSL-atlas_v0.8/AMBMC-c57bl6-hippocampus-labels-15um.nii.gz  ${FSLDIR}/data/atlases/AMBMC/
chmod 644 ${FSLDIR}/data/atlases/AMBMC/AMBMC*.nii.gz

echo "[INFO]  Copy files to ${FSLDIR}/data/atlases..."
cp ambmc-c57bl6-FSL-atlas_v0.8/AMBMC_basalganglia_labels.xml ${FSLDIR}/data/atlases/
cp ambmc-c57bl6-FSL-atlas_v0.8/AMBMC_cerebellum_labels.xml   ${FSLDIR}/data/atlases/
cp ambmc-c57bl6-FSL-atlas_v0.8/AMBMC_cortex_labels.xml       ${FSLDIR}/data/atlases/
cp ambmc-c57bl6-FSL-atlas_v0.8/AMBMC_hippocampus_labels.xml  ${FSLDIR}/data/atlases/
chmod 644 ${FSLDIR}/data/atlases/AMBMC_*.xml

if [ ! -e ${FSLDIR}/etc/luts ] ; then
	mkdir -p ${FSLDIR}/etc/luts
	echo "[INFO]  Create directory ${FSLDIR}/etc/luts..."
fi
echo "[INFO]  Copy files to ${FSLDIR}/etc/luts..."
cp ambmc-c57bl6-FSL-atlas_v0.8/ambmc_cortex_LUT.rgb ${FSLDIR}/etc/luts/
cp ambmc-c57bl6-FSL-atlas_v0.8/ambmc_basal_LUT.rgb  ${FSLDIR}/etc/luts/
cp ambmc-c57bl6-FSL-atlas_v0.8/ambmc_cereb_LUT.rgb  ${FSLDIR}/etc/luts/
chown root:root ${FSLDIR}/etc/luts/ambmc_*_LUT.rgb
chmod 644 ${FSLDIR}/etc/luts/ambmc_*_LUT.rgb

if [ ! -e ${FSLDIR}/etc/flirtsch ] ; then
	mkdir -p ${FSLDIR}/etc/flirtsch
	echo "[INFO]  Create directory ${FSLDIR}/etc/flirtsch..."
fi
echo "[INFO]  Copy files to ${FSLDIR}/etc/flirtsch..."
cp ambmc-c57bl6-FSL-atlas_v0.8/AMBMC_config.cnf     ${FSLDIR}/etc/flirtsch/
chgrp ${CFGRWGROUP} ${FSLDIR}/etc/flirtsch/AMBMC_config.cnf
chmod 664 ${FSLDIR}/etc/flirtsch/AMBMC_config.cnf

if [ ! -e ${FSLDIR}/doc/ambmc ] ; then
	mkdir -p ${FSLDIR}/doc/ambmc
	echo "[INFO]  Create directory ${FSLDIR}/doc/ambmc..."
fi
echo "[INFO]  Copy files to ${FSLDIR}/doc/ambmc..."
cp ambmc-c57bl6-FSL-atlas_v0.8/README.txt  ${FSLDIR}/doc/ambmc/
cp ambmc-c57bl6-FSL-atlas_v0.8/COPYING.txt ${FSLDIR}/doc/ambmc/

cd ~

echo "[INFO] Cleanup..."
rm -rf ${TMP}

echo "========================================================================"
echo "= Installation finished                                                ="
echo "========================================================================"
