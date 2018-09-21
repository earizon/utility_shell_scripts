#!/bin/bash 

# Example script to launch a remote TigerVNC X Server and the i3 window manager.
# - TigerVNC (http://TigerVNC.org) includes Xrandr extensions for resizing the screen and some other goodies.
# - i3 (https://i3wm.org) is an (excelent) tiling window manager. 
#     Follow i3 manual to configure $HOME/.i3/config keyboard short-cuts

LISTENING_PORT=`cat /etc/assigned_vncserver_ports.conf | grep $USER | cut -d "=" -f 2`
CONST_BASE_PORT=5900
DISPLAY_NUMBER=$(( $LISTENING_PORT - $CONST_BASE_PORT ))
echo DISPLAY_NUMBER:$DISPLAY_NUMBER

LOG="/tmp/vncserver.${USER}.${LISTENING_PORT}.log"

echo "" > $LOG
echo "Logs redirected to $LOG"
# TYPICAL VALUES FOR GEOMETRY: GEOMETRY:=2560x1440 ,  1920x1200, 1920x1080 
GEOMETRY=1920x1080

TIGERVNC_SERVER_OPTS=""
TIGERVNC_SERVER_OPTS="$TIGERVNC_SERVER_OPTS -fg :$DISPLAY_NUMBER"

TIGERVNC_SERVER_OPTS="$TIGERVNC_SERVER_OPTS -name $LISTENING_PORT  "
TIGERVNC_SERVER_OPTS="$TIGERVNC_SERVER_OPTS -depth 24 "
TIGERVNC_SERVER_OPTS="$TIGERVNC_SERVER_OPTS -geometry ${GEOMETRY} "

# TIGERVNC_SERVER_OPTS="$TIGERVNC_SERVER_OPTS -nevershared"
# TIGERVNC_SERVER_OPTS="$TIGERVNC_SERVER_OPTS -ac"      # disable access control restrictions
# TIGERVNC_SERVER_OPTS="$TIGERVNC_SERVER_OPTS -audit 3" # audit level
# TIGERVNC_SERVER_OPTS="$TIGERVNC_SERVER_OPTS -verbose 3"
 
# TODO:
# rm .vnc/li305-230*.log -f

if [ ! -d ${HOME}/.vnc ] ; then mkdir ${HOME}/.vnc ; fi
cat << EOF > ${HOME}/.vnc/xstartup
#/bin/sh
# FIX C&P problems: REF: https://github.com/TigerVNC/tigervnc/issues/269
( sleep 5 ; vncconfig -nowin -poll 250 1>/tmp/vncconfig.log 2>&1 ) &
/usr/bin/i3  1>>${LOG} 2>&1
EOF

chmod a+x ${HOME}/.vnc/xstartup

vncserver ${TIGERVNC_SERVER_OPTS} 1>>${LOG} 2>&1 &


