#!/bin/bash

if [ ! -e /opt/fsl ] ; then
	mkdir /opt/fsl
fi
python2 fslinstaller.py -d /opt/fsl/fsl-6.0.4 -V 6.0.4
