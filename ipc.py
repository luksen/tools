#!/usr/bin/python

from gi.repository import i3ipc
import subprocess as sp

conn = i3ipc.Connection()

command_area = ["xsetwacom", "set", "Wacom Bamboo Connect Pen stylus", "Area", "0", "0", "14720", "8280"]
command_map = ["xsetwacom", "set", "Wacom Bamboo Connect Pen stylus", "MapToOutput", "HDMI1"]

def on_workspace(self, e):
    if e.current:
        if e.current.get_name() == "5:g":
            command_map[-1] = "LVDS1"
            command_area[-1] = str(int(14720/(1366/768)))
        else:
            command_map[-1] = "HDMI1"
            command_area[-1] = str(int(14720/(1920/1080)))
        sp.check_call(command_map)
        sp.check_call(command_area)

conn.on('workspace', on_workspace)
conn.main()
