#!/bin/bash

set -e

version=`curl -L -s "https://www.torproject.org/download/alpha/" | pcregrep -o1 -e "\/ <a href=\"\/dist\/torbrowser\/(.*)\/tor-browser-linux64-.*_en-US.tar.xz\">64-bit<\/a>"`

echo "latest alpha version: ${version}"

sed -ri \
    -e 's/^(ARG VERSION=).*/\1'"\"${version}\""'/' \
    "alpha/Dockerfile"

git add alpha/Dockerfile
git diff-index --quiet HEAD || git commit --message "updated alpha to version ${version}"

