#!/bin/bash
set -e

# Patch for GLIBC
sed -e 's/utf8/utf-8/' -i support/dependencies/dependencies.sh

# Add bash_cv_getcwd_malloc=yes for overlayfs
sed -e '/^BASH_CONF_ENV += \\$/a \	bash_cv_getcwd_malloc=yes \\' -i package/bash/bash.mk

make oldconfig
make --quiet
