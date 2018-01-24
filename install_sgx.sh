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

# clone linux-sgx
if [ ! -d linux-sgx ]; then
    git clone https://github.com/01org/linux-sgx.git
fi

# Install Prerequisites
sudo yum -y groupinstall 'Development Tools'
sudo yum -y install ocaml wget python
sudo yum -y install openssl-devel libcurl-devel protobuf-devel

cd linux-sgx # ./linux-sgx/
./download_prebuilt.sh

# Build the Intel(R) SGX SDK and Intel(R) SGX PSW
make -j8

# Build the Intel(R) SGX SDK Installer
make sdk_install_pkg
make psw_install_pkg

./linux/installer/bin/sgx_linux_x64_sdk_2.1.42002.bin # TODO get version
shopt -s expand_aliases # TODO understand this
source ./sgxsdk/environment

# Install the Intel(R) SGX PSW: Prerequisites
wget "https://drive.google.com/uc?export=download&id=1LuEaM1iFpQJ-Y8jn54y2gdcT4vuBtW9O" -O iclsClient-1.45.449.12-1.x86_64.rpm
sudo rpm -ivh iclsClient-1.45.449.12-1.x86_64.rpm # TODO check existence

sudo yum install -y libuuid-devel libxml2-devel cmake pkgconfig

if [ ! -e dynamic-application-loader-host-interface]; then
    git clone https://github.com/intel/dynamic-application-loader-host-interface.git
fi
cd dynamic-application-loader-host-interface # ./linux-sgx/dynamic-application-loader-host-interface/
cmake .;make;sudo make install;sudo ldconfig;sudo systemctl enable jhi
cd ../ # ./linux-sgx/

# Install the Intel(R) SGX PSW
./linux/installer/bin/sgx_linux_x64_psw_2.1.42002.bin # TODO get version
sudo service aesmd start

echo "Complete!!"
