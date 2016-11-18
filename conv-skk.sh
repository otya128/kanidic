#!/bin/sh
echo "conv-skk.sh 2.2"

#argument check
if [ $# != 3 ]; then
	echo "usage: $0 skk-header.txt msime.dic skk.dic" 1>&2
	exit 0
fi

#nkf check
if type nkf > /dev/null 2>&1; then
	echo "Converting $1+$2 to $3"
else
	echo "nkf not found. conv-skk.sh is need nkf."
	exit 1
fi

#make tempfile
tmpfile=`mktemp`

#set header
cat $1 > $tmpfile

#dict convert
cat $2 | sed "s/^\(.\+\)\t\(.\+\)\t\(.\+\)\t\(.\+\)$/\1 \/\2;\3 \4\//" >> $tmpfile

#UTF-8 to EUC-JP
nkf -e $tmpfile > $3

#delete tempfile
rm $tmpfile

#finished!
echo "finished."
