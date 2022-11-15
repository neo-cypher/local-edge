#!/bin/bash
set -ue
set -o pipefail

trap traperr err

CurrentFolder="notset"
Folders=("storj" "gateway-mt" "private" "common" "uplink")

while getopts "a" arg; do
	case $arg in
		a)
			echo "Deleting all folders"
			Folders+=("${Folders}" "storj")
			;;
	esac
done


traperr() {
	echo "ERROR: ${BASH_SOURCE[1]} near line ${BASH_LINENO[0]} while working with ${CurrentFolder}."
}

for val in "${Folders[@]}"; do
	CurrentFolder=$val
	if [[ -d "./${CurrentFolder}" ]]; then
		echo "Folder Found, cleaning first then deleting ${CurrentFolder}."
		cd "${CurrentFolder}"
		go clean --modcache
		cd ..
		rm -rf $CurrentFolder
	fi
done

if [[ -d ./cockroach-data ]]; then
	echo "Deleting cockroach-data"
	rm -rf cockroach-data
fi
