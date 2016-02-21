#!/bin/sh
echo "conv-skk.sh 2.0"

if [ $# != 2 ]; then
    echo "usage: $0 msime.dic skk.dic" 1>&2
    exit 0
fi

echo "conv $1 to $2"

cat $1 | sed "s/^かに\t\(.\+\)\t顔文字\(\t\(.\+\)\)\?$/かに \/\1;顔文字 \3\//" > $2
