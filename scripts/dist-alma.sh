#!/bin/bash

URL="https://mirrors.almalinux.org"
OUTFILE="list.alma"

curl ${URL} | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep -i alma >> ${OUTFILE}