# Ragel source code built for Windows
This repository produces a statically linked [Ragel](https://github.com/adrian-thurston/ragel) x64 binary for Windows, using the MSVC compiler.<br>
The source code is taken from the <br>
For detailed information about Ragel itself, please refer to the original repository.

# How to use
Download the [latest release](https://github.com/PolarGoose/Ragel-for-Windows/releases)

# System requirements
Windows 7 x64 or higher

## How to generate files from `patch_files\ragel` folder
These files are generated during the build of the Ragel codebase on Linux.
The instructions below explain how to get these files in case they need to be updated in this repository.
* Use WSL Ubuntu
* Clone the https://github.com/adrian-thurston/ragel
* Checkout the `ragel-6.10` tag
* Install prerequisites: `sudo apt-get install build-essential autoconf ragel kelbt fig2dev`
* cd into the repository folder
* Execute the following commands:
```
./autogen.sh
./configure --disable-manual
make
```

## How to build this repository
* Run `.\build.ps1`
