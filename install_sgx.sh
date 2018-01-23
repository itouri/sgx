#!/bin/bash

if [ "$1" == "" ]; then
    echo "please enter linux-sgx path"
    exit 1
fi

if [ "$1" == "./" ]; then
    $LINUX_SGX_PATH="."
else
    $LINUX_SGX_PATH=$1
fi

set -eu

# Install Prerequisites
sudo yum -y groupinstall 'Development Tools'
sudo yum -y install ocaml wget python
sudo yum -y install openssl-devel libcurl-devel protobuf-devel

${LINUX_SGX_PATH}/download_prebuilt.sh

# Build the Intel(R) SGX SDK and Intel(R) SGX PSW
make -j8 ${LINUX_SGX_PATH}

# Build the Intel(R) SGX SDK Installer
make ${LINUX_SGX_PATH}/sdk_install_pkg

${LINUX_SGX_PATH}/linux/installer/bin/sgx_linux_x64_sdk_1.9.100.39124.bin # TODO
${LINUX_SGX_PATH}/sgxsdk/environment # 

# Install the Intel(R) SGX PSW: Prerequisites
wget wget "https://drive.google.com/uc?export=download&id=1LuEaM1iFpQJ-Y8jn54y2gdcT4vuBtW9O" -O iclsClient-1.45.449.12-1.x86_64.rpm -P ${LINUX_SGX_PATH}
sudo rpm -ivh ${LINUX_SGX_PATH}/iclsClient-1.45.449.12-1.x86_64.rpm

sudo yum install -y libuuid-devel libxml2-devel cmake pkgconfig
cmake .;make;sudo make install;sudo ldconfig;sudo systemctl enable jhi

# Install the Intel(R) SGX PSW
sudo ${LINUX_SGX_PATH}/linux/installer/bin/sgx_linux_x64_sdk_1.9.100.39124.bin # TODO
sudo service aesmd start

echo "Complete!!"