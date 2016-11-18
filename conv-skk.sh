#!/bin/sh
echo "conv-skk.sh 2.3i"

#argument check
if [ $# -lt 3 ]; then
	echo "usage: $0 skk-header.txt msime.dic skk.dic" 1>&2
	exit 0
fi

#iconv check
if [ ! type iconv > /dev/null 2>&1 ]; then
	echo "iconv not found. conv-skk.sh is need iconv."
	exit 1
fi

#skkdic-expr2 check
if [ ! type skkdic-expr2 > /dev/null 2>&1 ]; then
	echo "skkdic-expr2 not found. conv-skk.sh is need skkdic-expr2."
	exit 1
fi

#make tempfile
tmpfile=`mktemp`

#set header
if [ "$4" = "-n" ]; then
	echo "The dictionary will not include header text"
else
	cat $1 > $tmpfile
fi

#dict convert|dict sort
cat $2 | sed "s/^\(.\+\)\t\(.\+\)\t\(.\+\)\t\(.\+\)$/\1 \/\2;\3 \4\//" |skkdic-expr2 >> $tmpfile

#UTF-8 to EUC-JP
if [ "$5" = "-n" ]; then
	#raw data
	echo "The dictionary will not convert to EUC-JP"
	cp $tmpfile $3
elif [ "$5" = "-c" ]; then
	if type nkf > /dev/null 2>&1; then
		#use nkf
		nkf -e $tmpfile > $3
	else
		echo "nkf not found. conv-skk.sh is need nkf."
		rm $tmpfile
		exit 1
	fi
else
	#use iconv
	iconv -t EUC-JP -f UTF-8 -c $tmpfile -o $3
fi

#delete tempfile
rm $tmpfile

#finished!
echo "finished."
