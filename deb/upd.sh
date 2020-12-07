#!/bin/bash
# Runs from here.
# Scans this local repo for new *.deb, then updates Packages.gz and aptitude


# Make sure that this is the local apt repo.
./init.sh


dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
sudo aptitude update
