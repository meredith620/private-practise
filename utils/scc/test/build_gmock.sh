#! /bin/bash

# build gmock
VER=1.6.0
PREFIX=$(pwd)
PKG=gmock-${VER}
FILE=${PKG}.zip
URL=http://googlemock.googlecode.com/files/${FILE}

if [[ ! -e ${FILE} ]];then
    echo -e "\033[1;33m Downloading ${PKG}... \033[m"
    wget ${URL}
fi

if [[ ! -d ${PKG} ]];then
    echo -e "\033[1;33m Unpacking ${PKG}... \033[m"
    unzip -q ${FILE}
fi

echo -e "\033[1;33m Building ${PKG}... \033[m"
cd ${PKG}/make && make
