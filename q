#!/bin/sh 
set -e

if [ $# -eq 0 ] ; then
   echo "Ussage a (file_pattern) grep_pattern" >&2
   exit 1
fi
if [ $# -eq 1 ] ; then
   FILE_NAME="*"
   GREP_PATTERN="$*"
fi
if [ $# -eq 2 ] ; then 
   FILE_NAME=$1
   shift 1
   GREP_PATTERN="$*"
fi

# https://stackoverflow.com/questions/4210042/how-to-exclude-a-directory-in-find-command
find ./ \
    -not \( -path "**/node_modules/*" -prune \) \
    -not \( -path "**/.git/*" -prune \) \
    -not \( -type d \) \
    -iname "${FILE_NAME}" \
    -exec grep --with-filename "${GREP_PATTERN}" {} \;
