switch="on"
[[ $1 == "off" ]] && switch="off"

# find touchpad
# wiki.archlinux.org
declare -i ID
ID=`xinput list | grep -Eo 'ouchPad\s*id\=[0-9]{1,2}' | grep -Eo '[0-9]{1,2}'`

if [[ $switch == "on" ]]
then
	# configure additional screen
	xrandr --output HDMI1 --auto --output LVDS1 --off

	# turn off usb autosuspend
	for f in /sys/bus/usb/drivers/usb/*/power/autosuspend
	do
		sudo su -c "echo '-1' > $f"
	done

	# turn off screen blanking
	xset -dpms

	# turn on ethernet
	sudo ip link set wlan0 down
	sudo netctl start ethernet

	# turn off touchpad
	xinput disable $ID

	# announce completion
	notify-send 'Using docked configuration'
else
	# configure laptop screen
	xrandr --output HDMI1 --off --output LVDS1 --auto

	# turn on usb autosuspend
	for f in /sys/bus/usb/drivers/usb/*/power/autosuspend
	do
		sudo su -c "echo 2 > $f"
	done

	# turn on screen blanking
	xset dpms 0 0 300

	# turn on touchpad
	xinput enable $ID

	# announce completion
	notify-send 'Using mobile configuration'
fi

eval "$(</home/luki/.fehbg)"
