#!/bin/bash
set -e

# Patch for GLIBC
sed -e 's/utf8/utf-8/' -i support/dependencies/dependencies.sh

make oldconfig
make --quiet
