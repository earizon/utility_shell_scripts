Helpers scripts to launch a remote VNC server running a Linux desktop (gnome / i3).

- 'assigned_vncserver_ports.conf' is an example config file indicating how to map users to VNC-Server listening ports.
  It must be placed in /etc

- 'launch_vncserver_i3_desktop.sh' launches a remote i3 desktop using /etc/assigned_vncserver_ports.conf to map current user
   to a tcp port.
- 'launch_vncserver_gnome_desktop.sh' launches a remote lightweight desktop using /etc/assigned_vncserver_ports.conf to map current user
   to a tcp port.

Some default sortcuts used by i3 overlaps those of Window 7/10. Next $HOME/.i3/config is recomended to avoid problems:

    set $mod Mod4                                                                                                                                                                                                                                                                                                                                                                  
    
    font pango:DejaVu Sans Mono 8

    # Use Mouse+$mod to drag floating windows to their wanted position
    floating_modifier $mod

    # start a terminal
     bindsym $mod+t exec "/etc/alternatives/x-terminal-emulator 1>/dev/null 2>&1 &"

    # kill focused window
    bindsym $mod+Shift+q kill

    # start dmenu (a program launcher)
    bindsym $mod+m exec dmenu_run
    # bindsym $mod+d exec --no-startup-id i3-dmenu-desktop

    # change focus
    bindsym $mod+h focus left
    bindsym $mod+j focus down
    bindsym $mod+k focus up
    bindsym $mod+l focus right

    # move focused window
    bindsym $mod+Shift+h move left
    bindsym $mod+Shift+j move down
    bindsym $mod+Shift+k move up
    bindsym $mod+Shift+l move right

    # split in horizontal orientation
    bindsym $mod+Shift+v split h

    # split in vertical orientation
    bindsym $mod+v split v

    # enter fullscreen mode for the focused container
    bindsym $mod+Shift+f exec "/opt/firefox_beta/firefox --display=$DISPLAY 1>/tmp/firefox 2>&1 &"
    bindsym $mod+Shift+i exec "/usr/bin/i3-input --display=$DISPLAY 1>/tmp/i3_input 2>&1 &"
    bindsym $mod+z exec "/usr/bin/ 1>/tmp/xclock 2>&1 &"

    bindsym $mod+d fullscreen

    # change container layout (stacked, tabbed, toggle split)
    bindsym $mod+s layout stacking
    bindsym $mod+9 layout tabbed
    bindsym $mod+0 layout toggle split

    # toggle tiling / floating
    bindsym $mod+Shift+z floating toggle

    # change focus between tiling / floating windows
    bindsym $mod+r focus mode_toggle

    # focus the parent container
    bindsym $mod+p focus parent

    # focus the child container
    #bindsym $mod+d focus child

    # switch to workspace
    bindsym $mod+1 workspace 1
    bindsym $mod+2 workspace 2
    bindsym $mod+3 workspace 3
    bindsym $mod+4 workspace 4

    # move focused container to workspace
    bindsym $mod+5 move container to workspace 1
    bindsym $mod+6 move container to workspace 2
    bindsym $mod+7 move container to workspace 3
    bindsym $mod+8 move container to workspace 4

    # reload the configuration file
    bindsym $mod+shift+r reload

    bar {
            status_command i3status
    }
