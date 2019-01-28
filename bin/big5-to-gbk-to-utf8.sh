#!/bin/sh

BUILD=./build

mkdir -p $BUILD

if [ $# -eq 1 ]; then
    iconv -f utf8 -t BIG5 $1 | iconv -f BIG5 -t GB2312 \
        | iconv -f GB2312 -t utf8 -o $BUILD/$1
    exit
fi

for item in $(find . -maxdepth 1 -type f); do
    iconv -f utf8 -t BIG5 $item | iconv -f BIG5 -t GB2312 \
        | iconv -f GB2312 -t utf8 -o $BUILD/$item
done
