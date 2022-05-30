#!/bin/bash
# Building a new Linux System from source
unset CFLAGS
export FLOAT="hard"
export FPU="vfp"
export HOST="$(echo ${MACHTYPE} | sed "s/-[^-]*/-cross/")"
export TARGET="arm-linux-musleabi"
export ARCH="arm"
export ARM_ARCH="armv6j"
export PATH=${HOME}/cross-tools/bin:/bin:/usr/bin
export SRCD=${HOME}/sources
export BILD=${HOME}/builds

mkdir -pv ${BILD}
mkdir -p ${HOME}/cross-tools/${TARGET}

ln -sfv . ${HOME}/cross-tools/${TARGET}/usr

if [ ! -d "${HOME}/sources" ]
then
	echo "Sources not provided"
	exit 1
fi
pushd ${BILD}

	tar xvf ${SRCD}/linux*tar* -C .
	tar xvf ${SRCD}/binutils*tar* -C .
	tar xvf ${SRCD}/gcc*tar* -C .
	pushd ${BILD}/gcc-* # Fixing gcc
		tar xvf ${SRCD}/mpfr*tar* -C .
		mv mpfr-* mpfr
		tar xvf ${SRCD}/gmp*tar* -C .
		mv gmp-* gmp
		tar xvf ${SRCD}/mpc*tar* -C .
		mv mpc-* mpc
	popd
	tar xvf ${SRCD}/musl*tar* -C .

	mkdir -p ${BILD}/binutils
	mkdir -p ${BILD}/gcc1
	mkdir -p ${BILD}/musl
	mkdir -p ${BILD}/gcc2
	

	pushd ${BILD}/linux*
		make mrproper
		make ARCH=${ARCH} headers_check
		make ARCH=${ARCH} INSTALL_HDR_PATH=${HOME}/cross-tools/${TARGET} headers_install
	popd

	pushd ${BILD}/binutils
		../binutils-*/configure \
		--prefix=${HOME}/cross-tools \
		--target=${TARGET} \
		--with-sysroot=${HOME}/cross-tools/${TARGET} \
		--disable-nls \
		--disable-multilib
		make configure-host
		make
		make install
	popd

	pushd ${BILD}/gcc1
		../gcc-*/configure \
		--prefix=${HOME}/cross-tools \
		--build=${HOST} \
		--host=${HOST} \
		--target=${TARGET} \
		--with-sysroot=${HOME}/cross-tools/${TARGET} \
		--disable-nls \
		--disable-shared \
		--without-headers \
		--with-newlib \
		--disable-decimal-float \
		--disable-libgomp \
		--disable-libmudflap \
		--disable-libssp \
		--disable-libatomic \
		--disable-libquadmath \
		--disable-threads \
		--enable-languages=c \
		--disable-multilib \
		--with-mpfr-include=$(pwd)/../gcc-*/mpfr/src \
		--with-mpfr-lib=$(pwd)/mpfr/src/.libs \
		--with-arch=${ARM_ARCH} \
		--with-float=${FLOAT} \
		--with-fpu=${FPU}	
		make all-gcc all-target-libgcc
		make install-gcc install-target-libgcc
	popd 
	pushd ${BILD}/musl
		./configure \
		CROSS_COMPILE=${TARGET}- \
		--prefix=/ \
		--target=${TARGET}
		make
		DESTDIR=${HOME}/cross-tools/${TARGET} make install
	popd	
	pushd ${BILD}/gcc2
	../gcc-*/configure \
		--prefix=${HOME}/cross-tools \
		--build=${HOST} \
		--host=${HOST} \
		--target=${TARGET} \
		--with-sysroot=${HOME}/cross-tools/${TARGET} \
		--disable-nls \
		--enable-languages=c \
		--enable-c99 \
		--enable-long-long \
		--disable-libmudflap \
		--disable-multilib \
		--with-mpfr-include=$(pwd)/../gcc-*/mpfr/src \
		--with-mpfr-lib=$(pwd)/mpfr/src/.libs \
		--with-arch=${ARM_ARCH} \
		--with-float=${FLOAT} \
		--with-fpu=${FPU}
	make
	make install
	popd
popd

bash
