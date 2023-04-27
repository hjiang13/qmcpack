module load gcc/12.1.0

cd build

cmake -G Ninja -DENABLE_OFFLOAD=ON \
        -DENABLE_CUDA=OFF \
        -DCMAKE_CUDA_ARCHITECTURES=70 \
        -DENABLE_OMP_TASKLOOP=OFF \
        -DQMC_OMP=ON    \
        -DCMAKE_C_COMPILER=/home/hailong.jiang/llvm-9-project/llvm-9-install-release/bin/clang \
        -DCMAKE_CXX_COMPILER=/home/hailong.jiang/llvm-9-project/llvm-9-install-release/bin/clang++ \
        -DENABLE_MPI=OFF \
        -DCMAKE_CXX_FLAGS=--gcc-toolchain=/soft/compilers/gcc/9.5.0/x86_64-suse-linux/  \
        -DQMC_MPI=OFF \
        -DUSE_OBJECT_TARGET=ON \
        -DOFFLOAD_ARCH=sm_70 \
        -DOFFLOAD_TARGET=nvptx64-nvidia-cuda \
        -DCMAKE_BUILD_TYPE=Release \
        -DUSE_OBJECT_TARGET=ON \
        -DCMAKE_C_FLAGS=--gcc-toolchain=/soft/compilers/gcc/9.5.0/x86_64-suse-linux/ ../