#!/bin/bash
#
# Runs from anywhere.
# Tries to install the specified apt package if it found.
#
# Return status:
#   0 if package has been installed
#   1 if specified apt package not found
#   2 if internal error
#
# All args are required.
POSITIONAL=()
while [[ $# -gt 0 ]]; do
	key="$1"
	case $key in

		--name)
		NAME="$2"
		shift # past argument
		shift # past value
		;;

		--version)
		VERSION="$2"
		shift # past argument
		shift # past value
		;;
		
		--release)
		RELEASE="$2"
		shift # past argument
		shift # past value
		;;

		*)    # unknown option

		POSITIONAL+=("$1") # save it in an array for later
		shift # past argument
		;;
	esac
done
# restore positional parameters
set -- "${POSITIONAL[@]}"

if [ -z ${NAME} ] || [ -z ${VERSION} ] || [ -z ${RELEASE} ]; then
  # Some required args are empty.
  echo "All args are required: try.sh --name <N> --version <V> --release <R>"
  exit 2
fi



PACKAGE="${NAME}=${VERSION}-${RELEASE}"


# List versions of the given package name, that are in apt database.
# VERSIONS value format:
#   Package openssl: [p]1.0.1t-1+deb8u8 [i]1.0.1t-1+deb8u12 [p]1.0.2l-1~bpo8+1
VERSIONS=$(aptitude versions "^${NAME}$" -F '[%c]%p')
if [ $? -eq 0 ]; then

	
	# Check that package with given version exists.
	# MATCHED_VERSION format:
	#   [<status>]<version>-<release>
	MATCHED_VERSION=$(echo ${VERSIONS} | grep -o "\[.*\]${VERSION}-${RELEASE}\b")
	if [ $? -eq 0 ]; then
		
		
		# Strict matched package found in apt database, so it either 
		# already installed or would be.
		PACKAGE_STATUS=$(echo ${MATCHED_VERSION} | cut -f 2 -d '[' | cut -f 1 -d ']')
		if [ ${PACKAGE_STATUS} == 'i' ]; then
		  echo ${PACKAGE} already installed.
		else
		  echo Trying to install ${PACKAGE} ...
		  sudo aptitude -y install ${PACKAGE}
		  
		fi
		
		
		exit 0
	fi
fi


echo ${PACKAGE} apt package not found.
exit 1