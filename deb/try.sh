#!/bin/bash
#
# Runs from anywhere.
# Tries to install the specified apt package.

# Error status
PACKAGE_NOT_FOUND=1
WRONG_PARAMS=2

# All params are required:
# 	--name
# 	--version
# 	--release
POSITIONAL=()
while [ $# -gt 0 ]; do
	key="$1"
	case $key in

		--name)
		NAME="$2"
		shift # past param
		shift # past value
		;;

		--version)
		VERSION="$2"
		shift # past param
		shift # past value
		;;
		
		--release)
		RELEASE="$2"
		shift # past param
		shift # past value
		;;

		*)    # unknown param

		POSITIONAL+=("$1") # save it in an array for later
		shift # past param
		;;
	esac
done
# restore positional params
set -- "${POSITIONAL[@]}"

if [ -z ${NAME} ] || [ -z ${VERSION} ] || [ -z ${RELEASE} ]; then
  echo 'Required params: try.sh --name <N> --version <V> --release <R>'
  exit ${WRONG_PARAMS}
fi


PACKAGE="${NAME}=${VERSION}-${RELEASE}"

# List versions of the package.
# VERSIONS format:
#   Package openssl:
# 	[p]1.0.1t-1+deb8u8
#	[i]1.0.1t-1+deb8u12
# 	[p]1.0.2l-1~bpo8+1
VERSIONS=$(aptitude versions "~n^${NAME}$" -F '[%c]%p')

if [ ! $? -eq 0 ]; then
	echo "Can not read versions of apt package: ${NAME}"
	exit $?
fi


# Check that the specified version exists.
# SPECIFIED_VERSION format:
#   [<status>]<version>-<release>, e.g. [p]1.0.2l-1~bpo8+1
SPECIFIED_VERSION=$(echo ${VERSIONS} | grep -o "\[.*\]${VERSION}-${RELEASE}\b")

if [ ! $? -eq 0 ]; then
	echo "Can not find specified ${NAME} version: ${VERSION}-${RELEASE}"
	exit ${PACKAGE_NOT_FOUND}
fi


# The package with the strict matched version found in apt database, so it 
# either already installed, or would be.
# PACKAGE_STATUS format:
# 	letter of the apt status, e.g. i or p
PACKAGE_STATUS=$(echo ${MATCHED_VERSION} | cut -f 2 -d '[' | cut -f 1 -d ']')

if [ "${PACKAGE_STATUS}" == 'i' ]; then
	echo "${PACKAGE} already installed."
else
	sudo aptitude -y install ${PACKAGE}
	exit $?
fi
