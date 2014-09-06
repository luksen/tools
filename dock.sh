switch="on"
[[ $1 == "off" ]] && switch="off"

echo $switch

if [[ $switch == "on" ]]
then
	# configure additional screen
	xrandr --output HDMI1 --auto --output LVDS1 --auto --left-of HDMI1

	# turn off usb autosuspend
	for f in /sys/bus/usb/drivers/usb/*/power/autosuspend
	do
		echo '-1' > $f
	done

	# turn off screen blanking
	xset -dpms

	#turn on ethernet
	ip link set wlan0 down
	netctl start ethernet
else
	# configure laptop screen
	xrandr --output HDMI1 --off --output LVDS1 --auto

	# turn on usb autosuspend
	for f in /sys/bus/usb/drivers/usb/*/power/autosuspend
	do
		echo '2' > $f
	done

	# turn on screen blanking
	xset dpms 0 0 300
fi

eval $(</home/luki/.fehbg)
