#!/bin/bash

function ussage(){
cat <<EOF
+-------------------------------------------------------------
| Utility script to launch dockerized node instances:
| Ussage:
| * Replace commands like:
|     myHost@myWorkingDir $ npm install
|   by:
|     myHost@myWorkingDir $ ./node_wrapper.sh npm install
| 
|     (myWorkingDir: working directory containing package.json)
|
| * Create an 'EXTRA_DOCKER_OPTS' files to add new DOCKER_OPT 
|   useful parameters or overload the default NODE_VERSION (7.9)
|
|   Example EXTRA_DOCKER_OPTS file:
|   ------------------------------------------
|   NODE_VERSION=8.6.0 
|   DOCKER_OPT="${DOCKER_OPT} -p 8080:80"  
|   DOCKER_OPT="${DOCKER_OPT} -v /tmp:/tmp" 
|   ------------------------------------------
|
| * Replace NODE_VERSION (defaults to 7.9) in node_wrapper.sh
|
|
| WARN!!:global installs to default directory (/usr/local/lib/node/)
|  will be lost after each run. You can use '--prefix=/root/node_lib' like:
|    myHost@myWorkingDir $ ./node_wrapper.sh  npm install -g --prefix=/root/bower_install bower 
|
|  and later use the installed package like:
|    myHost@myWorkingDir $ ./node_wrapper.sh /root/bower_install/bin/bower
|
+-------------------------------------------------------------

EOF
}

if [ $# == 0 ]; then ussage ; exit 1 ; fi

NODE_VERSION=7.9

if [ -f EXTRA_DOCKER_OPTS ]; then . EXTRA_DOCKER_OPTS ; fi

CWD=$(pwd)
ROOT_ON_HOST="${CWD}/.container_root_${NODE_VERSION}"
if [ ! -d  ${ROOT_ON_HOST} ] ; then mkdir ${ROOT_ON_HOST} ; fi

DOCKER_OPT="${DOCKER_OPT} -ti " # Setup Terminal (-t) and interactive input (-i)
DOCKER_OPT="${DOCKER_OPT} --rm " #  Remove after exit
DOCKER_OPT="${DOCKER_OPT} -v ${CWD}:/node_app" # /node_app: arbitrary working directory in container
DOCKER_OPT="${DOCKER_OPT} -v ${ROOT_ON_HOST}:/root" # directory where packages will be installed
DOCKER_OPT="${DOCKER_OPT} " # directory where packages will be installed

# Fix SElinux problems in RedHat/CentOS
[[ -f "/etc/redhat-release" ]] && \
  chcon -Rt svirt_sandbox_file_t ${CWD} && 
  chcon -Rt svirt_sandbox_file_t ${ROOT_ON_HOST}

sudo docker run ${DOCKER_OPT} node:${NODE_VERSION} /bin/bash -c "cd /node_app ; $*"
