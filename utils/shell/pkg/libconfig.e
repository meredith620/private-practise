# libconfig ebuild info
# http://www.hyperrealm.com/libconfig/libconfig-1.4.9.tar.gz

NAME=libconfig
VER=1.4.9
EXTENSION=tar.gz

PKG=${NAME}-${VER}
FILE=${PKG}.${EXTENSION}
URL=http://www.hyperrealm.com/libconfig/${FILE}
PREFIX=$(pwd)/

CONFIG="--prefix=${PREFIX} --with-pic=yes"
