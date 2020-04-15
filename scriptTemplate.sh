#!/bin/bash
set -e 

OUTPUT="$(basename $0).log"
exec 3>&1   # Copy current STDOUT to &3
exec 4>&2   # Copy current STDERR to &4
echo "Redirecting STDIN/STDOUT to $OUTPUT"
# exec 1>$OUTPUT 2>&1  
# REF: https://unix.stackexchange.com/questions/145651/using-exec-and-tee-to-redirect-logs-to-stdout-and-a-log-file-in-the-same-time
exec &> >(tee -a "$OUTPUT") # Reditect STDOUT/STDERR to file
exec 2>&1  
echo "This will be logged to the file and to the screen"

# Parse arguments
#  $#  number of arguments
while [  $#  -gt 0 ]; do
  echo $1
  case "$1" in
    -l|--list)
      echo "list arg"
      shift 1  # ºconsume arg         ←   $# = $#-1 
      ;;
    -p|--port)
      export PORT="${2}:"
      echo "port: $PORT"
      shift 2  #  consume arg+value   ←   $# = $#-2 
      ;;
    *)
      echo "non-recognised option"
      shift 1  #  consume arg         ←   $# = $#-1 
  esac
done

GLOBAL_EXIT_STATUS=0
WD=$(pwd)

ERROR=""
function funThrow {
    if [[ $STOP_ON_ERROR != false ]] ; then
      echo "ERROR DETECTED: Aborting now due to" 
      echo -e ${ERROR} 
      exit 1;
    else
      echo "ERROR DETECTED: "
      echo -e ${ERROR}
      echo "WARN: CONTINUING WITH ERRORS "
      GLOBAL_EXIT_STATUS=1
    fi
    ERROR=""
}


function funPreChecks {
    if [[ $1 == "A" ]] ; then
       echo "A"
  elif [[ $1 == "B" ]] ; then
       echo "B"
  else 
    ERROR="Ussage: $0 A|B"
    funThrow
  fi     
}

function funSTEP1 {
  echo "STEP 1"
}
function funSTEP2 { # throw error
  ERROR="asdf"
  funThrow
}


cd $WD ; funPreChecks
cd $WD ; funDeployWars
cd $WD ; funUpdateApplication

echo "Exiting with status:$GLOBAL_EXIT_STATUS"
exit $GLOBAL_EXIT_STATUS
