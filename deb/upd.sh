#!/bin/bash
#
# Runs from here.
# Scans this repo for *.deb files, then updates Packages.gz and aptitude.


# Make sure that this is the apt repo.
./init.sh

dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
sudo aptitude update
