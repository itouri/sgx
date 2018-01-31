#!/bin/bash

set -eu

# Build and Install the Intel(R) SGX Driver
# Build the Intel(R) SGX Driver
if [ ! -d linux-sgx-driver ]; then
    git clone https://github.com/01org/linux-sgx-driver.git
fi
cd linux-sgx-driver/
make -j8

# Install the Intel(R) SGX Driver
sudo mkdir -p "/lib/modules/"`uname -r`"/kernel/drivers/intel/sgx"    
sudo cp isgx.ko "/lib/modules/"`uname -r`"/kernel/drivers/intel/sgx"    
sudo sh -c "cat /etc/modules | grep -Fxq isgx || echo isgx >> /etc/modules"    
sudo /sbin/depmod
sudo /sbin/modprobe isgx
cd ../ # ./
