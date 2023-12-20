#!/usr/bin/env bash

# Copyright 2020-2023 The Defold Foundation

set -e

PLATFORM=$1

if [ "" == "${CC}" ]; then
    CC=$(which clang)
fi
if [ "" == "${CC}" ]; then
    CC=$(which gcc)
fi
if [ "" == "${AR}" ]; then
    AR=$(which ar)
fi

if [ "" == "${CC}" ]; then
    echo "No compiler set in variable CC!"
    exit 1
fi
if [ "" == "${AR}" ]; then
    echo "No archive tool set in variable AR!"
    exit 1
fi

if [ "" == "${PREFIX}" ]; then
    PREFIX=./install
    mkdir -p ${PREFIX}
fi

if [ "" == "${BUILD_DIR}" ]; then
    BUILD_DIR=./build
    mkdir -p ${BUILD_DIR}
fi

echo "Using PREFIX=${PREFIX}"
echo "Using BUILD_DIR=${BUILD_DIR}"
echo "Using PLATFORM=${PLATFORM}"
echo "Using CC=${CC}"
echo "Using AR=${AR}"

case ${PLATFORM} in
    armv7-android)
        export CFLAGS="-D_ARM_ASSEM_ ${CFLAGS}"
        ;;
    *)
        export CFLAGS="-DONLY_C ${CFLAGS}"
        ;;
esac

export CFLAGS="-D_GNU_SOURCE -funsigned-char -Wall -Werror -Wno-unused-variable -Os ${CFLAGS}"

function run() {
    echo "$*"
    $*
}

function build() {
    local platform=$1
    local prefix=$2

    rm -rf ${BUILD_DIR}
    mkdir -p ${BUILD_DIR}

    mkdir -p ${prefix}/lib/${PLATFORM}
    mkdir -p ${prefix}/bin/${PLATFORM}
    mkdir -p ${prefix}/share/${PLATFORM}
    mkdir -p ${prefix}/include/tremolo


    if [ "${PLATFORM}" == "armv7-android" ]; then
        run ${CC} -c -o ${BUILD_DIR}/bitwiseARM.o Tremolo/bitwiseARM.s
        run ${CC} -c -o ${BUILD_DIR}/dpen.o Tremolo/dpen.s
        run ${CC} -c -o ${BUILD_DIR}/floor1ARM.o Tremolo/floor1ARM.s
        run ${CC} -c -o ${BUILD_DIR}/mdctARM.o Tremolo/mdctARM.s
    fi

    # list taken from "Android.bp"
    run ${CC} -c ${CFLAGS} -o ${BUILD_DIR}/bitwise.o Tremolo/bitwise.c
    run ${CC} -c ${CFLAGS} -o ${BUILD_DIR}/codebook.o Tremolo/codebook.c
    run ${CC} -c ${CFLAGS} -o ${BUILD_DIR}/dsp.o Tremolo/dsp.c
    run ${CC} -c ${CFLAGS} -o ${BUILD_DIR}/floor0.o Tremolo/floor0.c
    run ${CC} -c ${CFLAGS} -o ${BUILD_DIR}/floor1.o Tremolo/floor1.c
    run ${CC} -c ${CFLAGS} -o ${BUILD_DIR}/floor_lookup.o Tremolo/floor_lookup.c
    run ${CC} -c ${CFLAGS} -o ${BUILD_DIR}/framing.o Tremolo/framing.c
    run ${CC} -c ${CFLAGS} -o ${BUILD_DIR}/mapping0.o Tremolo/mapping0.c
    run ${CC} -c ${CFLAGS} -o ${BUILD_DIR}/mdct.o Tremolo/mdct.c
    run ${CC} -c ${CFLAGS} -o ${BUILD_DIR}/misc.o Tremolo/misc.c
    run ${CC} -c ${CFLAGS} -o ${BUILD_DIR}/res012.o Tremolo/res012.c
    run ${CC} -c ${CFLAGS} -o ${BUILD_DIR}/treminfo.o Tremolo/treminfo.c
    run ${CC} -c ${CFLAGS} -o ${BUILD_DIR}/vorbisfile.o Tremolo/vorbisfile.c

    run ${AR} rcs ${prefix}/lib/${PLATFORM}/libtremolo.a ${BUILD_DIR}/*.o

    cp -v Tremolo/*.h ${prefix}/include/tremolo
}

build ${PLATFORM} ${PREFIX}

