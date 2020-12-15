#!/bin/bash
#
# Runs from here. Deletes deb file and updates apt sources.

FILENAME=$1

if [[ ${FILENAME} == *.deb ]]; then
  rm ${FILENAME}
  if [ $? -eq 0 ]; then
    ./upd.sh
  fi
else
  echo Work with *.deb files only.
fi