#!/usr/bin/env bash

# Copyright 2020-2023 The Defold Foundation

set -e

PLATFORM=$1
PREFIX=$2

source ./build_base.sh

build ${PLATFORM} ${PREFIX}
