#!/bin/bash

if [ "$1" == "" ]; then
    echo "please enter linux-sgx path"
    exit 1
fi

LINUX_SGX_PATH="$1"

CULLENT_PATH=$(pwd)

set -eu

# Install Prerequisites
sudo yum -y groupinstall 'Development Tools'
sudo yum -y install ocaml wget python
sudo yum -y install openssl-devel libcurl-devel protobuf-devel

cd ${LINUX_SGX_PATH}
./download_prebuilt.sh

# Build the Intel(R) SGX SDK and Intel(R) SGX PSW
make -j8

# Build the Intel(R) SGX SDK Installer
make sdk_install_pkg
make psw_install_pkg

./linux/installer/bin/sgx_linux_x64_sdk_2.1.42002.bin # TODO get version
shopt -s expand_aliases # TODO understand this
source ./sgxsdk/environment # TODO dont hard coding

# Install the Intel(R) SGX PSW: Prerequisites
wget "https://drive.google.com/uc?export=download&id=1LuEaM1iFpQJ-Y8jn54y2gdcT4vuBtW9O" -O iclsClient-1.45.449.12-1.x86_64.rpm
# sudo rpm -ivh iclsClient-1.45.449.12-1.x86_64.rpm # TODO 

sudo yum install -y libuuid-devel libxml2-devel cmake pkgconfig

# git clone https://github.com/intel/dynamic-application-loader-host-interface.git # TODO check exsitence  
cd dynamic-application-loader-host-interface
cmake .;make;sudo make install;sudo ldconfig;sudo systemctl enable jhi
cd ../

# Install the Intel(R) SGX PSW
./linux/installer/bin/sgx_linux_x64_psw_2.1.42002.bin # TODO get version
sudo service aesmd start

echo "Complete!!"
