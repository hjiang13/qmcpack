#!/bin/bash

# Update packages that track main/master
# Currently only llvm
# Intended to be run nightly/weekly etc.
#
# Implicitly assume that cuda version for llvm from spack is compatible with system installed driver

echo --- Update Script START `date`

if [ -e `dirname "$0"`/ornl_versions.sh ]; then
    source `dirname "$0"`/ornl_versions.sh
else
    echo Did not find version numbers script ornl_versions.sh
    exit 1
fi

spack uninstall -y gcc@master
spack install gcc@master

ourhostname=`hostname|sed 's/\..*//g'`
case "$ourhostname" in
    nitrogen )
	echo Skipping llvm@main install on nitrogen/AMD since libomptarget will fail to build
	;;
    * )
	spack uninstall -y llvm@main
	spack install llvm@main +cuda cuda_arch=70
	;;
esac
    
# Old bugfixes/workarounds:
#spack install llvm@main +cuda cuda_arch=70 ^binutils +plugins
#if [ ! -e `spack location -i llvm@main`/lib/libomptarget-nvptx-cuda_112-sm_70.bc ]; then
#    cp `spack location -i llvm@main`/lib/libomptarget-nvptx-cuda_110-sm_70.bc `spack location -i llvm@main`/lib/libomptarget-nvptx-cuda_112-sm_70.bc
#fi

echo --- Update Script END `date`
