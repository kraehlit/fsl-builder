#!/bin/bash

TMP=`mktemp -d` 
cd ${TMP}
INSTALL_DIR=/opt/ants/ants-2.3.4

git clone --single-branch -b v2.3.4 https://github.com/ANTsX/ANTs.git
mkdir build
cd build

cmake  \
      -DCMAKE_BUILD_TYPE=Release \
	  -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
	  -DANTS_BUILD_WITH_CCACHE=ON \
	  -DANTS_INSTALL_DEVELOPMENT=ON \
	  -DANTS_INSTALL_LIBS_ONLY=OFF \
	  -DANTS_SUPERBUILD=ON \
	  -DANTS_USE_QT=OFF \
	  -DBUILD_ALL_ANTS_APPS=ON \
	  -DBUILD_SHARED_LIBS=ON \
	  -DBUILD_STYLE_UTILS=OFF \
	  -DBUILD_TESTING=ON \
	  -DUSE_SYSTEM_ITK=OFF \
	  -DUSE_SYSTEM_SlicerExecutionModel=OFF \
	  -DUSE_VTK=ON \
	  -DUSE_SYSTEM_VTK=OFF \
	  ../ANTs 2>&1 | tee cmake.log
	  
make -j 2 2>&1 | tee ../build.log

if [ ! -e CMakeFiles/ANTS-complete ] ; then
  echo "Build not successfull, abort..."
  exit 1
fi

cd ANTS-build
make install 2>&1 | tee ../../install.log

cd ${TMP}
bzip2 cmake.log
bzip2 build.log
bzip2 install.log

cp cmake.log.bz2 build.log.bz2 install.log.bz2 ${INSTALL_DIR}

cd /tmp
rm -rvf ${TMP}



	  
