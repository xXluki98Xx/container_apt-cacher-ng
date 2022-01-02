#!/bin/bash

URL="https://mirror-status.centos.org"
OUTFILE="list.centos"

curl ${URL} | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep -i centos >> ${OUTFILE}