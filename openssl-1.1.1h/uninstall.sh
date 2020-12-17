#!/bin/bash
#
# Runs from here.

NAME=openssl
VERSION=1.1.1h
RELEASE=my

DEB_DIR=../deb

sudo aptitude -y purge ${NAME}-${RELEASE}
sudo ldconfig
cd ${DEB_DIR}
./rem.sh ${NAME}-${RELEASE}_${VERSION}-${RELEASE}_i386.deb