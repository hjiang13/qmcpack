module load gcc/9.5.0
module use /soft/packaging/spack-builds/modules/linux-opensuse_leap15-x86_64
module use /soft/modulefile
module load cmake/3.23.2 public_mkl/2019 hdf5/1.10.7-gcc-10.2.0-uapcktd
module unload cuda
module load cuda/10.0.130
module load fftw/3.3.8-gcc-10.2.0-v7cos5m
export BOOST_ROOT=/home/hailong.jiang/qmcpack-workspace/boost_1_81_0
#Notice: we are using llvm-16 lib here instead of llvm-9
export LD_LIBRARY_PATH=/soft/packaging/spack-builds/linux-opensuse_leap15-x86_64/gcc-10.2.0/hdf5-1.10.7-uapcktd3szlmtouy63p4o3nofnsj5au6/lib:/soft/compilers/llvm/release-16.0.0/lib:/soft/compilers/gcc/12.2.0/x86_64-suse-linux/lib64:/soft/compilers/cuda/cuda-11.0.2/lib64

export OMP_TARGET_OFFLOAD=mandatory
export LIBOMPTARGET_INFO=1
export LIBOMPTARGET_DEBUG=1

cd build

cmake -G Ninja -DENABLE_OFFLOAD=ON \
        -DENABLE_CUDA=OFF \
        -DCMAKE_CUDA_ARCHITECTURES=70 \
        -DENABLE_OMP_TASKLOOP=OFF \
        -DQMC_OMP=ON    \
        -DCMAKE_C_COMPILER=/home/hailong.jiang/splendid-workspace/llvm-10-install-debug/bin/clang \
        -DCMAKE_CXX_COMPILER=/home/hailong.jiang/splendid-workspace/llvm-10-install-debug/bin/clang++  \
        -DENABLE_MPI=OFF \
        -DCMAKE_CXX_FLAGS=--gcc-toolchain=/soft/compilers/gcc/9.5.0/x86_64-suse-linux/  \
        -DQMC_MPI=OFF \
        -DUSE_OBJECT_TARGET=ON \
        -DOFFLOAD_ARCH=sm_70 \
        -DOFFLOAD_TARGET=nvptx64-nvidia-cuda \
        -DCMAKE_BUILD_TYPE=Release \
        -DUSE_OBJECT_TARGET=ON \
        -DCMAKE_C_FLAGS=--gcc-toolchain=/soft/compilers/gcc/9.5.0/x86_64-suse-linux/ ../
ninja

#optional clang/clang++
#-DCMAKE_C_COMPILER=/soft/compilers/llvm/release-16.0.0/bin/clang \
#-DCMAKE_CXX_COMPILER=/soft/compilers/llvm/release-16.0.0/bin/clang++  \
#
#-DCMAKE_C_COMPILER=/home/hailong.jiang/splendid-workspace/llvm-10-install-debug/bin/clang\
#-DCMAKE_CXX_COMPILER=/home/hailong.jiang/splendid-workspace/llvm-10-install-debug/bin/clang++ \\