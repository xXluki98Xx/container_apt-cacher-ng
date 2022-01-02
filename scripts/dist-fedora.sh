#!/bin/bash

# assume that the EPEL mirror for all archs are the same
# assume that mirrors for EPEL6 and EPEL7 are the same

URL_BASE="http://mirrors.fedoraproject.org"
INFILE=$(mktemp -t mirror-list-fedora.XXXXXX)

ARCH="aarch64 armhfp i386 ppc64 ppc64le s390 s390x x86_64"
REPO="27 28 29 30 31 32 33 34 35"

for R in ${REPO}; do
	for A in ${ARCH}; do
		wget --no-check-certificate -q -O - "${URL_BASE}/metalink?repo=fedora-${R}&arch=${A}" >> ${INFILE}
	done
done

grep "<url" ${INFILE} | sed -e "s/^.*>\(.*\)<.*>/\1/" | rev | cut -d "/" -f 5- | rev | sort -u > list.fedora
rm -f ${INFILE}