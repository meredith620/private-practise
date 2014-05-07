#!/bin/bash

e_info="$1"

if [ -z $e_info ];then
    echo "need one e_info file..."
    exit 1
fi

source "$e_info"

# --- utils ----
download() {
    local file="$1"
    local url="$2"
    local tmp_file="tmp_${file}"
    if [[ ! -e ${file} ]];then
        wget ${url} -O ${tmp_file}
        mv ${tmp_file} ${file}
    fi
}

unpackage() {
    local pkg="$1"
    local file="$2"
    if [[ ! -d ${pkg} ]];then
        tar xf ${file}
    fi
}

build() {
    local pkg=${PKG}
    cd ${pkg}
    ./configure ${CONFIG}
    make && make install
}

# --- def main ---
main() {
    echo -e "\033[1;33m Downloading ${PKG}... \033[m"
    download ${FILE} ${URL}

    echo -e "\033[1;33m Unpacking ${PKG}... \033[m"
    unpackage ${PKG} ${FILE}

    echo -e "\033[1;33m Building ${PKG}... \033[m"
    build ${PKG}
}

# --- main ---
main
