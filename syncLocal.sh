#!/bin/bash

# This script, running in background or tmux allows to automatically
# synchronize local work with remote server each minute .
# It can be used "as is" or as reference script for more elaborate setups.

# PRE-SETUP:
# ssh is configured to remote server access without password (priv/pub keys)
# path layout (home user for example) match in local desktop and remote ssh server.
# Script can easely be tunned with minimum scriptin knowledge.

# Example Ussage:
#   cd ~/Documents && syncLocal.sh
#   Now start editing ~/Documents and they will be automatically synchronized
#   each minute with remote.

# Status: Works for me! (most probably will work for you)

while true; do
  find ./ -mmin -1 -type f -exec \
  scp -oConnectTimeout=5 {} ${REMOTE_SSH}:$(pwd)/ 1>/dev/null \;
  echo -n "." 
  sleep 60
done
