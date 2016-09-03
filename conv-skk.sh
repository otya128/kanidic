#!/bin/sh
echo "conv-skk.sh 2.1"

#check
if [ $# != 3 ]; then
    echo "usage: $0 skk-header.txt msime.dic skk.dic" 1>&2
    exit 0
fi

#header
cat $1 > $3

#convert
cat $2 | sed "s/^\(.\+\)\t\(.\+\)\t\(.\+\)\t\(.\+\)$/\1 \/\2;\3 \4\//" >> $3
