#!/bin/bash

NAME=openssl
VERSION=1.1.1h
RELEASE=my

URL_BASE="https://www.openssl.org/source/"
SRC_ZIP="openssl-${VERSION}.tar.gz"
SHA_FILE="${SRC_ZIP}.sha256"
SHA_URL=${URL_BASE}${SHA_FILE}
SRC_URL=${URL_BASE}${SRC_ZIP}
DEB_DIR=../deb


# Try to find and install this package if it already in apt database.
${DEB_DIR}/try.sh --name ${NAME} --version ${VERSION} --release ${RELEASE}
if [ $? -eq 0 ]; then
    # The package is already installed.
    exit 0
fi


# apt package is not found.
echo Buildind from sources ...


#--- CLEAR ---
# TODO: make it a function
if [ -f "${SRC_ZIP}" ]; then
    rm ${SRC_ZIP}
fi

if [ -f "${SHA_FILE}" ]; then
    rm ${SHA_FILE}
fi

rm -rf $(ls -d */)


wget ${SRC_URL}
wget ${SHA_URL}


#--- CHECKSUM ---
SHA_KEY=$(cat ${SHA_FILE})
echo "${SHA_KEY} ${SRC_ZIP}" | sha256sum --check --strict
if [ $? -eq 0 ]; then


    #--- UNZIP ---
    tar zxvf ${SRC_ZIP}
    SRC_DIR=$(ls -d */)
    cd ${SRC_DIR}


    #--- BUILD BIN ---
    ./config \
    --prefix=/usr/local/ssl \
    --openssldir=/usr/local/ssl \
    no-ssl2
    
    make


    #--- BUILD DEB ---
    ../${DEB_DIR}/deb.sh \
        --name ${NAME} \
        --version ${VERSION} \
        --release ${RELEASE}


    #--- UPDATE REPO ---
    mv *.deb ../${DEB_DIR}
    cd ../${DEB_DIR}
    ./upd.sh


    # TODO: Check that we have strictly this version of a package in apt DB.
    sudo aptitude -y install ${NAME}=${VERSION}-${RELEASE}
    # TODO: clear dir
    
    
    echo "/usr/local/ssl/lib" | sudo tee /etc/ld.so.conf.d/openssl.conf
fi
