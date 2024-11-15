#!/bin/bash

URL="https://mirrormanager.fedoraproject.org/mirrors/EPEL"
OUTFILE="list.fedora-epel"

curl ${URL} | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep -i epel >> ${OUTFILE}