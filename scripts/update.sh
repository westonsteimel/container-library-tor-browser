#!/bin/bash

set -e

version=`curl -L -s "https://www.torproject.org/download/" | pcregrep -o1 -e "href=\"\/dist\/torbrowser\/(.*)/tor-browser-linux64-.*_ALL.tar.xz\">Download for Linux<\/a>"`
echo "latest stable version: ${version}"

sed -ri \
    -e 's/^(ARG VERSION=).*/\1'"\"${version}\""'/' \
    "stable/Dockerfile"

git add stable/Dockerfile
git diff-index --quiet HEAD || git commit --message "updated stable to version ${version}"


version=`curl -L -s "https://www.torproject.org/download/alpha/" | pcregrep -o1 -e "\/ <a href=\"\/dist\/torbrowser\/(.*)\/tor-browser-linux64-.*_ALL.tar.xz\">64-bit<\/a>"`

echo "latest alpha version: ${version}"

sed -ri \
    -e 's/^(ARG VERSION=).*/\1'"\"${version}\""'/' \
    "alpha/Dockerfile"

git add alpha/Dockerfile
git diff-index --quiet HEAD || git commit --message "updated alpha to version ${version}"

