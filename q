#!/bin/sh 
set -e

if [ $# -eq 0 ] ; then
   echo "Ussage a (file_pattern) grep_pattern" >&2
   exit 1
fi
if [ $# -eq 1 ] ; then
   FILE_NAME="*"
   GREP_PATTERN=$1
fi
if [ $# -eq 2 ] ; then 
   FILE_NAME=$1
   GREP_PATTERN=$2
fi

SELECT_FROM_CWD="/usr/bin/find ./ "
WHERE=""
NAME_EQUALS=" -name "
AND=" -and "
TYPE_EQUALS_FILE=" -type f "
FOREACH_EXECUTE=" -exec "

${SELECT_FROM_CWD} ${WHERE} ${NAME_EQUALS} "${FILE_NAME}" ${AND} ${TYPE_EQUALS_FILE} \
${FOREACH_EXECUTE} egrep -i --with-filename ${GREP_PATTERN} {} \;
