- 'assigned_vncserver_ports.conf' is an example config file indicating how to map users to VNC-Server listening ports.
  It must be placed in /etc

- 'launch_vncserver_i3_desktop.sh' launches a remote i3 desktop using /etc/assigned_vncserver_ports.conf to map current user
   to a tcp port.
- 'launch_vncserver_gnome_desktop.sh' launches a remote lightweight desktop using /etc/assigned_vncserver_ports.conf to map current user
   to a tcp port.
