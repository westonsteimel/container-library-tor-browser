#!/bin/bash

set -e

version=`curl -L -s "https://www.torproject.org/download/" | pcregrep -o1 -e "href=\"\/dist\/torbrowser\/(.*)/tor-browser-linux64-.*_en-US.tar.xz\">Download for Linux<\/a>"`
echo "latest stable version: ${version}"

sed -ri \
    -e 's/^(ARG VERSION=).*/\1'"\"${version}\""'/' \
    "stable/Dockerfile"

git add stable/Dockerfile
git diff-index --quiet HEAD || git commit --message "updated stable to version ${version}"

