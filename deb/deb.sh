#!/bin/bash
#
# Runs from sources root dir.
# Uses checkinstall to build deb package from given sources.
# Uses doc-pak/ or doc/ dir, or --nodoc arg (see checkinstall docs).
# Uses description-pak file or trying to create it based on README.
#
# All args are optional.
POSITIONAL=()
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
    
    # apt package name.
    -n|--name)
    NAME="$2"
    shift  # past argument
    shift  # past value
    ;;
    
    # When there are several packages with the same name in apt database, the 
    # package version helps to specify concrete package.
    #
    # List versions and distributions of a package:
    #	aptitude versions <package>
    #
    # Specify package by version:
    #	aptitude show <package>=<version>
    -v|--version)
    VER="$2"
    shift  # past argument
    shift  # past value
    ;;

    # Other required packages.
    -d|--deps)
    DEPS="$2"
    shift  # past argument
    shift  # past value
    ;;

    # Features, provided by this package.
    -p|--provides)
    PROVIDES="$2"
    shift  # past argument
    shift  # past value
    ;;

    # Do not include docs.
    --nodoc)
    NODOC="$key"
    shift  # past argument
    ;;

    *)  # unknown option

    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
    
    esac
done
# restore positional params
set -- "${POSITIONAL[@]}"


#--- SET CHECKINSTALL ARGS ---
if [ ! -z ${VER} ]; then
    SET_VER="--pkgversion=${VER}"
fi

if [ ! -z ${NAME} ]; then
    SET_NAME="--pkgname=${NAME}"
fi

if [ ! -z ${DEPS} ]; then
    SET_DEPS="--requires=\"${DEPS}\""
fi

if [ ! -z ${PROVIDES} ]; then
    SET_PROVIDES="--provides=${PROVIDES}"
fi


#--- DOC ---
if [ -z ${NODOC} ]; then
    if [ ! -d doc-pak ]; then
        mv doc doc-pak
        if [ $? -ne 0 ]; then
            NODOC=--nodoc
        fi
    fi
fi


#--- DESCRIPTION ---
# TODO: improve it
if [ ! -f description-pak ]; then
    # Try to create description-pak from README
    # TODO: README.txt and README.md
    DESCRIPTION_LINE_NUM=$(grep -n "DESCRIPTION" README | cut -f 1 -d ":")
    if [ $? -eq 0 ]; then
        SECTION_LINE_NUMS=$(grep -n "\s[A-Z]*$" README | cut -f 1 -d ":")
        DESCRIPTION_LINE_NUMS=$(echo ${SECTION_LINE_NUMS} | grep -Po "\b${DESCRIPTION_LINE_NUM}\s\d+")
        if [ $? -eq 0 ]; then
            DESCRIPTION_LINE_RANGE=(${DESCRIPTION_LINE_NUMS})
            let START_LINE_NUM=(${DESCRIPTION_LINE_RANGE[0]} + 3)
            let END_LINE_NUM=(${DESCRIPTION_LINE_RANGE[-1]} - 2)
            sed -n "${START_LINE_NUM},${END_LINE_NUM}p" README > description-pak
        else
            echo "---" > description-pak
        fi
    else
        echo "---" > description-pak
    fi
fi


#--- BUILD DEB ---
# We not installs the package here, because first we need to move it to local
# repo and update apt databse.
# TODO: check that sharing *.so (--addso)
# TODO: check that files are not installed.
sudo checkinstall \
  -Dy \
  --install=no \
  ${SET_VER} ${SET_NAME} ${SET_DEPS} ${SET_PROVIDES} ${NODOC} \
  sudo make install
