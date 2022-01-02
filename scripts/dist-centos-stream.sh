#!/bin/bash

URL="https://admin.fedoraproject.org/mirrormanager/mirrors/CentOS"
OUTFILE="list.centos-stream"

curl ${URL} | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep -i centos >> ${OUTFILE}