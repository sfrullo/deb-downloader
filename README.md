# deb-downloader

deb-downloader is a simple tool to download a list of deb packages and their dependencies from the standard Ubuntu repository.
It can be use to download packages for both i386 and amd64 architetures.
If needed, custom file can be loaded for specific APT configuration and to extend the source list.

## Requirements

You need to have Docker installed on your machine.
Then, you can pull a specific version of Ubuntu using

```bash
./setup.sh <version>
```

where:
* version: a valid version as 16.04, 19.10, ...

## Usage

```bash
./download.sh [-c|--clear] ([-v|--ubuntu-version] version) ([-a|--arch] arch) [-h|--help] package-1 ... [package-n] ...
```

where:
* package: one or a list of packages to download
* -c, --clear: clean the archives before starting download (optional, off by default)
* -a, --arch: select which architecture you need packages of (optional, both i386 and amd64 by default)
* -v, --ubuntu-version: which version of Ubuntu must be loaded (optional, 16.04 by default)
* -h, --help: Prints help
