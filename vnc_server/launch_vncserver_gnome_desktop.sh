#!/bin/bash 
#
LISTENING_PORT=`cat /etc/assigned_vncserver_ports.conf | grep $USER | cut -d "=" -f 2`
CONST_BASE_PORT=5900
DISPLAY_NUMBER=$(( $LISTENING_PORT - $CONST_BASE_PORT ))
echo DISPLAY_NUMBER:$DISPLAY_NUMBER

rm -rf /tmp/debug*
if [ ! -d ${HOME}/.vnc ] ; then mkdir ${HOME}/.vnc ; fi
cat << EOF > ${HOME}/.vnc/xstartup
#!/bin/sh

exec 1>/tmp/xstartup.${USER}.log 2>&1

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

# bash -x /etc/X11/xinit/xinitrc

sleep 5
gnome-panel &
mutter #
# gnome-shell 1>/tmp/gnome-sheel.${USER}.log

# [ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
# [ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
# xsetroot -solid grey
# vncconfig -iconic &
EOF
chmod a+x ${HOME}/.vnc/xstartup

LOG="/tmp/vncserver.${USER}.${LISTENING_PORT}.log"

echo "" > $LOG
echo "Logs redirected to $LOG"

vncserver -fg :$DISPLAY_NUMBER -name $LISTENING_PORT -depth 16 -geometry 1024x1024 1>${LOG} 2>&1 &

