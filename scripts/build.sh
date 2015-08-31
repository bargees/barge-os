#!/bin/bash
set -e

# Patch for GLIBC
sed -e 's/utf8/utf-8/' -i support/dependencies/dependencies.sh

# Add bash_cv_getcwd_malloc=yes for overlayfs
sed -e '/^BASH_CONF_ENV += \\$/a \	bash_cv_getcwd_malloc=yes \\' -i package/bash/bash.mk

# Add the basics startup scripts
cp -f ${OVERLAY}/etc/init.d/* package/initscripts/init.d/
install -C -m 0755 package/initscripts/init.d/* ${OVERLAY}/etc/init.d/

make oldconfig
make --quiet
