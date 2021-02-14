#!/bin/bash
#
# Runs from here. Automatically runs from `upd.sh`.
# Makes current dir the apt local repo.

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
RECORD="deb [trusted=yes] file:${CURRENT_DIR} ./"
RECORDS_DIR=/etc/apt/sources.list.d
RECORD_NAME=my
RECORD_LIST=${RECORDS_DIR}/${RECORD_NAME}.list
if [ ! -f ${RECORD_LIST} ]; then
	echo ${RECORD} | sudo tee ${RECORD_LIST}
fi

