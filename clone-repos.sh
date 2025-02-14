#!/bin/bash
set -u
set -o pipefail

trap traperr err

# export GOBIN=~/go/bin
Environment=Test
Clean=False
Source="Github"
Branded="False"
CurrentRepo="notset"
ProjectRoot="$( cd "$( dirname "${BASH_SOURCE[0]}"   )" >/dev/null 2>&1 && pwd   )"
CloneRepos=("storj" "gateway-mt" "private" "common" "uplink")

while getopts "hecb" arg; do
	case $arg in
		h)
			Help
			;;
		e)
			Source="gerrit"
			;;
		c)
			Clean="True"
			;;
        b)
            Branded="True"
            ;;
	esac
done

Help()
{
	Usage
	# echo "Add description of the script functions here."
	echo
	echo "Syntax: ${0} [-e|c|h|b]"
	echo "options:"
	echo "e		Force environment to dev"
	echo "c     Clean environemnt(delete binaries and remove local dependant packages)."
    echo "b     Installs the OEM Branded Web UI from the tardigrade-satellite-theme repo"
	echo
}

Usage()
{
	echo "usage: ${0}"
}

traperr() {
	echo "ERROR: ${BASH_SOURCE[1]} near line ${BASH_LINENO[0]} while working with ${CurrentRepo}."
}


##### Begin Script #####
echo "Cloning repos in: ${ProjectRoot}."

for val in "${CloneRepos[@]}"; do
	CurrentRepo=$val

	if [[ -d "${ProjectRoot}/${CurrentRepo}" ]]; then
		echo "${CurrentRepo} folder already exists, skipping checkout."
	else
		if [[ "${Source}" == "Github" ]]; then
			echo "Cloning from github..."
			git clone "git@github.com:storj/${CurrentRepo}.git"
		else
			echo "Cloning ${CurrentRepo} using gerrit support scripts"
			curl -sSL storj.io/clone | sh -s "${CurrentRepo}"
		fi
	fi

	echo "Clean the environment: ${Clean}"
	if [[ $Clean == "True" ]]; then
		cd "${ProjectRoot}/${CurrentRepo}"
		go clean --modcache
	fi

	echo	"Installing ${CurrentRepo}..."
	if [[ -e "${ProjectRoot}/${CurrentRepo}/go.mod" ]]; then
		echo "${CurrentRepo} has a go.mod file"
		cd "${ProjectRoot}/${CurrentRepo}/"
		go install -v ./...
	fi
	cd $ProjectRoot

done

    if [[ $Branded == "True" ]]; then
        echo "Cloning tardigrade satellite theme for the branded web ui"
        git clone "git@github.com:storj/tardigrade-satellite-theme.git"
    fi
