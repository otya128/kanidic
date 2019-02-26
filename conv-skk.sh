#!/bin/bash
# conv-skk.sh - Convert MSIME dictionary to SKK dictionary

set -ue

check_command() {
    if [ ! type "$1" > /dev/null 2>&1 ]; then
        echo "command not found: $1" 1>&2
        exit 1
    fi
}

usage_exit() {
    echo "conv-skk.sh 3.1"
    echo "Usage: $0 [-f utf8] [-t eucjp] [-o output] [-p header] dictionary"  1>&2
    exit 1
}

# Checking arguments
while getopts f:t:o:p:h OPT
do
    case $OPT in
        f)  FROM="$OPTARG"
            ;;
        t)  TO="$OPTARG"
            ;;
        o)  OUTPUT="$OPTARG"
            ;;
        p)  HEADER="$OPTARG"
            ;;
        h)  usage_exit
            ;;
        \?) usage_exit
            ;;
    esac
done

shift $(($OPTIND - 1))

if [ $# -lt 1 ]; then
    usage_exit
fi

# Checking commands
check_command iconv
check_command skkdic-expr2

cat "$1" |
    # Escape slash
    sed 's/\//\\057/g' |
    # Escape semi-colon
    sed 's/;/\\059/g' |
    # Concat escapes with S-expr
    #だれかやって
    # Dict convert
    sed 's/^\([^\t]\+\)\t\([^\t]\+\)\t\(.\+\)$/\1 \/\2;\3\//g' |
    # Dict sort
    skkdic-expr2 |
    # Set header
    cat "${HEADER:-/dev/null}" - |
    # Dict encode
    iconv -f "${FROM:-utf8}" -t "${TO:-eucjp}" > ${OUTPUT:-/dev/stdout}

