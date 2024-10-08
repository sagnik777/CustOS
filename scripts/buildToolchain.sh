#!/bin/bash

WORKDIR="/home/$USER/Desktop"
TOOL_BUILD="$WORKDIR/tool_build"
TOOL_PATH="$WORKDIR/toolchain"

echo "*** Creating Cross Compiler !!!"
if [ -z "$1" ]; then
	echo "USAGE : ./buildToolchain.sh <system_password> <test_tools>"
	echo " *** Creation FAILED !!! "

else
	echo "*** ConceptOS : Update apt ... "
	echo $1 | sudo -S apt update

	echo "*** ConceptOS : Install libs for building cross compiler ... "
	echo $1 | sudo -S apt install -y build-essential texinfo bison flex libgmp-dev libmpc-dev libmpfr-dev 
	
	if [ "$2" == "test_tools" ]; then
		echo "*** ConceptOS : Install test tools ..."
		echo $1 | sudo -S apt install qemu-system putty
	fi

	echo "*** ConceptOS : Building CrossCompiler ... "
	mkdir $TOOL_BUILD
	cd $TOOL_BUILD

	echo "*** ConceptOS : Create ENV Variables"
	export ConceptOS_PREFIX="$TOOL_PATH"
	export ConceptOS_TARGET=aarch64-none-elf
	export PATH="$ConceptOS_PREFIX/bin:$PATH"
	echo "*** ConceptOS : ENV set : PREFIX : $ConceptOS_PREFIX TARGET : $TARGET PATH : $PATH !!!"

	echo "*** ConceptOS : Make BinUtils ... "
	mkdir binutils
	cd binutils
	# Retrieve and Download latest release of binUtils
	latest_binutils_version=$(curl -sL ftp://ftp.gnu.org/gnu/binutils/ | grep -o 'binutils-[0-9.]*.tar.gz' | sort -V | tail -n 1)
	binutils_download_url="ftp://ftp.gnu.org/gnu/binutils/$latest_binutils_version"
	curl -O $binutils_download_url
	tar xf binutils-*.tar.gz
	mkdir build-binutils
	cd build-binutils
	../binutils-*/configure --target=$ConceptOS_TARGET --enable-interwork --enable-multilib --with-sysroot --disable-nls --disable-werror --prefix=$ConceptOS_PREFIX 2>&1 | tee configure.log
	make all install 2>&1 | tee make.log
	cd $TOOL_BUILD

	echo "*** ConceptOS : Make : GCC ... "
	mkdir gcc
	cd gcc
	# Retrieve latest GCC and Download
	latest_version=$(curl -sL ftp://ftp.gnu.org/gnu/gcc/ | grep -o 'gcc-[0-9.]*.tar.gz' | sort -V | tail -n 1)
	download_url="ftp://ftp.gnu.org/gnu/gcc/$latest_version"
	curl -O $download_url
	tar xf gcc-*.tar.gz
	mkdir build-gcc
	cd build-gcc
	../gcc-*/configure --target=$ConceptOS_TARGET --prefix="$ConceptOS_PREFIX" --disable-nls --disable-libssp --enable-languages=c --without-headers
	make all-gcc
	make all-target-libgcc
	make install-gcc
	make install-target-libgcc
	cd $TOOL_BUILD

	echo "*** ConceptOS : Make GDB ... "
	mkdir gdb
	cd gdb
	# Retrieve latest GDB and download
	latest_gdb_version=$(curl -sL ftp://ftp.gnu.org/gnu/gdb/ | grep -o 'gdb-[0-9.]*.tar.gz' | sort -V | tail -n 1)
	gdb_download_url="ftp://ftp.gnu.org/gnu/gdb/$latest_gdb_version"
	curl -O $gdb_download_url
	tar xf gdb-*.tar.gz
	mkdir build-gdb
	cd build-gdb
	../gdb-*/configure --target="$ConceptOS_TARGET" --prefix="$ConceptOS_PREFIX" --program-prefix=$ConceptOS_TARGET-
	make
	make install

	echo "*** ConceptOS : Removing build directory ..."
	rm -rfv $TOOL_BUILD
	
	echo "*** ConceptOS : Toolchain Creation Success !!!"
fi
