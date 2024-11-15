#!/bin/bash

URL="https://mirrormanager.fedoraproject.org/mirrors/Fedora"
OUTFILE="list.fedora"

curl ${URL} | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep -i -v centos | grep -v -i epel | grep -v -i stream >> ${OUTFILE}