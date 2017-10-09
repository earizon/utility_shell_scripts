#!/bin/bash

# Utility script to launch dockerized node instances.
# This avoid having to install nodeJS locally.
# Ussage:
#  Replace commands like:
#    $ npm install
#  by:
#    $ node_wrapper.sh npm install
#
#  The current working directory will be mounted in node_app "ready to run"


NODE_VERSION=node:7.9

[[ -f "/etc/redhat-release" ]] && chcon -Rt svirt_sandbox_file_t $(pwd) # Fix SElinux problems in RedHat/CentOS
sudo docker run -ti -p 3000:3000 -v $(pwd):/node_app  ${NODE_VERSION} /bin/bash -c "cd /node_app ; $*"
