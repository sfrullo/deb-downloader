#!/bin/bash

# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_clear="off"
_arg_ubuntu_version="16.04"
_arg_arch=("i386" "amd64")
_arg_package_list="undefined"
_arg_packages=()

print_help()
{
	printf '%s\n' "Scripts to download deb packages and all related dependencies"
	printf 'Usage: %s [-c|--clear] ([-v|--ubuntu-version] version) ([-a|--arch] arch) ([-p|--package-list] packages list file ) [-h|--help] <packages-1> [<packages-2>] ... [<packages-n>] ...\n' "$0"
	printf '\t%s\n' "<packages>: list of packages to download"
	printf '\t%s\n' "-c, --clear: clean archives before starting download (optional, off by default)"
	printf '\t%s\n' "-a, --arch: select which architecture you need packages of (optional, both i386 and amd64 by default)"
	printf '\t%s\n' "-p, --package-list: read list of package from file (optional)"
	printf '\t%s\n' "-v, --ubuntu-version: which version of Ubuntu must be loaded (optional, 16.04 by default)"
	printf '\t%s\n' "-h, --help: Prints help"
}

parse_commandline()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-c|--clear)
				_arg_clear="on"
				;;
			-v|--ubuntu-version)
				_arg_ubuntu_version="$2"
				shift
				;;
			-a|--arch)
				_arg_arch=("$2")
				shift
				;;
			-p|--package-list)
				_arg_package_list="$2"
				shift
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_arg_packages+=("$_key")
				;;
		esac
		shift
	done
}

parse_commandline "$@"

if [ "$_arg_clear" = "on" ]; then
	clean="apt clean;"
fi

if [ "$_arg_package_list" != "undefined" ]; then
	if [ -f "$_arg_package_list" ]; then
		_arg_packages=($(cat "$_arg_package_list" | tr '\n' ' '))
	else
		echo "$_arg_package_list" not found.
		exit 1
	fi
fi


cmd="run-parts --verbose /root/setup.d; ${clean} apt update; apt install --no-install-recommends --reinstall -d -y ${_arg_packages[@]}"

for arch in ${_arg_arch[@]}; do
	sudo docker run -it --rm \
	-v ${PWD}/setup.d:/root/setup.d \
	-v ${PWD}/apt.conf.d:/etc/apt/apt.conf.d \
	-v ${PWD}/trusted.gpg.d:/etc/apt/trusted.gpg.d \
	-v ${PWD}/${arch}-deb:/var/cache/apt/archives \
	-v ${PWD}/${arch}-sources.list.d:/etc/apt/sources.list.d \
	${arch}/ubuntu:${_arg_ubuntu_version} /bin/bash -c "${cmd}"
done

sudo rm -r *-deb/lock *-deb/partial