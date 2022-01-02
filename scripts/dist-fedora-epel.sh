#!/bin/bash

URL="https://admin.fedoraproject.org/mirrormanager/mirrors/EPEL"
OUTFILE="list.fedora-epel"

curl ${URL} | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep -i epel >> ${OUTFILE}