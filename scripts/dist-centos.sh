#!/bin/bash

URL="https://mirrormanager.fedoraproject.org/mirrors/CentOS"
OUTFILE="list.centos"

curl ${URL} | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep -i centos >> ${OUTFILE}