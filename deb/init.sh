#!/bin/bash
# Runs from here.
# Makes current dir the apt local repo.
#TODO: use sources list dir

REPOS=/etc/apt/sources.list
CURR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
CURR_REPO="deb [trusted=yes] file:${CURR_DIR} ./"
CURR_REPO_PATTERN=" file:${CURR_DIR}\s"
if grep -q "${CURR_REPO_PATTERN}" ${REPOS}; then
	echo "Repository already added."
else
	echo ${CURR_REPO} | sudo tee -a ${REPOS}
fi
