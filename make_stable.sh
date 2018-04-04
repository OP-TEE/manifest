#!/usr/bin/env bash

VERSION=
OVERWRITE=false

function help() {
	echo "    -r <revision>  new revision for OP-TEE and linaro-swg gits"
	echo "    -o             overwrite existing xml-files"
	echo "    -h             help"
	exit
}

while getopts "or:h" opt; do
	case $opt in
		o)
			OVERWRITE=true
			;;
		r)
			VERSION=${OPTARG}
			;;
		h)
			help
			;;
		\?)
			echo "Invalid option: -${OPTARG}" >&2
			exit 1
			;;
		:)
			echo "Option -${OPTARG} requires an argument." >&2
			exit 1
			;;
	esac
done

if [ -z "${VERSION}" ]; then
	echo "No version provided, not doing any changes!"
	exit
fi

for xml in *.xml
do
	FILE=$xml.${VERSION}
	if [ ${OVERWRITE} == true ]; then
		FILE=$xml
	fi

	cat $xml | 
		sed "s/\(OP-TEE\/.*\)revision.*/\1\/>/" | # Removes old revision
		sed "s/\(OP-TEE.*\"\)/\1 revision=\"refs\/tags\/${VERSION}\" clone-depth=\"1\"/" |
		sed "s/\(OP-TEE\/build.git.*\) \/>/\1>/" | # Strip away a forward slash from build.git only

		sed "s/\(linaro-swg\/optee_examples.git\)revision.*/\1\/>/" | # Removes old revision
		sed "s/\(linaro-swg\/optee_examples.git\"\)/\1 revision=\"refs\/tags\/${VERSION}\" clone-depth=\"1\"/" |
		sed "s/\(linaro-swg\/optee_benchmark.git\)revision.*/\1\/>/" | # Removes old revision
		sed "s/\(linaro-swg\/optee_benchmark.git\"\)/\1 revision=\"refs\/tags\/${VERSION}\" clone-depth=\"1\"/" |
		tee ${FILE} 2>&1 > /dev/null
done
