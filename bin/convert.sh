#!/bin/bash

if [ "$#" != "1" ]; then
	exit
fi

dir=$1
echo "processing dirctory $1 ..."

function convert {
	local dir=$1
	local from=$2
	local to=$3

	for item in `find $dir -type f`; do
		echo "iconv $item ..."
		iconv -f gbk -t utf8 $item -o ./tmp_convert.tmp && cp ./tmp_convert.tmp $item
	done

	rm ./tmp_convert.tmp
}

convert $dir gbk utf8
