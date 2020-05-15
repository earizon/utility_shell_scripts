#!/bin/bash

OUTPUT="$(basename $0).log"
exec 3>&1   # Copy current STDOUT to &3
exec 4>&2   # Copy current STDERR to &4
echo "Redirecting STDIN/STDOUT to $OUTPUT"
# exec 1>$OUTPUT 2>&1  
# REF: https://unix.stackexchange.com/questions/145651/using-exec-and-tee-to-redirect-logs-to-stdout-and-a-log-file-in-the-same-time
exec &> >(tee -a "$OUTPUT") # Reditect STDOUT/STDERR to file
exec 2>&1  
echo "This will be logged to the file and to the screen"


GLOBAL_EXIT_STATUS=0
WD=$(pwd)

LOCK="/tmp/exampleLock"
function funCleanUp() {
  set +e
  echo "Cleaning resource and exiting"
  rm -f $LOCK  
}
trap funCleanUp EXIT   # <-- Execute funCleanUp when receiving EXIT signal

if [ ! ${STOP_ON_ERR_MSG} ] ; then
  STOP_ON_ERR_MSG=true
fi
ERR_MSG=""
function funThrow {
    if [[ $STOP_ON_ERR_MSG != false ]] ; then
      echo "ERR_MSG DETECTED: Aborting now due to " 
      echo -e ${ERR_MSG} 
      if [[ $1 != "" ]]; then
          GLOBAL_EXIT_STATUS=$1 ; 
      elif [[ $GLOBAL_EXIT_STATUS == 0 ]]; then
          GLOBAL_EXIT_STATUS=1 ;
      fi
      exit $GLOBAL_EXIT_STATUS
    else
      echo "ERR_MSG DETECTED: "
      echo -e ${ERR_MSG}
      echo "WARN: CONTINUING WITH ERR_MSGS "

      GLOBAL_EXIT_STATUS=1 ;
    fi
    ERR_MSG=""
}



while [  $#  -gt 0 ]; do  # $#  number of arguments
  case "$1" in
    -l|--list)
      echo "list arg"
      shift 1  # ºconsume arg         ←   $# = $#-1 
      ;;
    -p|--port)
      export PORT="${2}:"
      shift 2  #  consume arg+value   ←   $# = $#-2 
      ;;
    -h|--host)
      export HOST="${2}:"
      shift 2  #  consume arg+value   ←   $# = $#-2 
      ;;
    *)
      echo "non-recognised option '$1'"
      shift 1  #  consume arg         ←   $# = $#-1 
  esac
done
set -e # exit on ERR_MSG

function preChecks() {
  # Check that ENV.VARs and parsed arguments are in place
  if [[ ! ${HOME} ]] ; then ERR_MSG="${LINENO} HOME ENV.VAR NOT DEFINED" ; funThrow 41 ; fi
  if [[ ! ${PORT} ]] ; then ERR_MSG="${LINENO} PORT ENV.VAR NOT DEFINED" ; funThrow 42 ; fi
  if [[ ! ${HOST} ]] ; then ERR_MSG="${LINENO} HOST ENV.VAR NOT DEFINED" ; funThrow 43 ; fi
  set -u # From here on, ANY UNDEFINED VARIABLE IS CONSIDERED AN ERROR.
}

function funSTEP1 {
  echo "STEP 1: $HOME, PORT:$PORT, HOST: $HOST"
}
function funSTEP2 { # throw ERR_MSG
  ERR_MSG="${LINENO} My favourite ERROR@funSTEP2"
  funThrow 2
}


cd $WD ; preChecks
cd $WD ; funSTEP1
cd $WD ; funSTEP2

echo "Exiting with status:$GLOBAL_EXIT_STATUS"
exit $GLOBAL_EXIT_STATUS
