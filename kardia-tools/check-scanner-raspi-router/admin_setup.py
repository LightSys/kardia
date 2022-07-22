#!/usr/bin/python3

#
#  admin_setup.py
#
#  Author: Alex Fehr
#  
#  Copyright 2022 LightSys Technology Services
#
#  Last Modified 07/22/22 at 2:00 pm
#

import sys
import os
import time

if os.path.exists(
r"/home/pi/Desktop/check-scanner-raspi-router/config_router.py") == False:
	exit("ERROR: config_router.py not found. Please make sure "
	"config_router.py is placed in the file path /home/pi/Desktop/"
	"check-scanner-raspi-router config_router.py")

# Add router configuration script to autostart process
print("Adding command to autostart...")
try:
	autostart = open(r"/etc/xdg/lxsession/LXDE-pi/autostart", "r")
	lines = autostart.readlines()
	already_modified = False
	for line in lines:
		if "@lxterminal -e sudo python3" in line:
			already_modified = True
			break
			
	if already_modified == False:
		autostart = open(r"/etc/xdg/lxsession/LXDE-pi/autostart", "a")
		autostart.write("@lxterminal -e sudo python3 /home/pi/Desktop/"
		"check-scanner-raspi-router/config_router.py &\n")
	
	autostart.close()
	
except:
	exit("ERROR: Could not open autostart")

print("autostart modification complete")

# Remove admin network info from wpa_supplicant
print("Removing wpa_supplicant entry...")
try:
	wpa_supplicant = open(r"/etc/wpa_supplicant/wpa_supplicant.conf", "r")
	read_lines = wpa_supplicant.readlines()
	write_lines = ["", "", ""]
	
	for i in range(0, 3):
		write_lines[i] = read_lines[i]
	
	# Write to the file
	wpa_supplicant = open(r"/etc/wpa_supplicant/wpa_supplicant.conf", "w")
	wpa_supplicant.writelines(write_lines)
	wpa_supplicant.close()

except:
	exit("ERROR: Could not open wpa_supplicant.conf")

print("wpa_supplicant entry removed")

# Reboot to apply changes
print("Setup complete. Rebooting...")

time.sleep(3)

try:
	os.system('reboot now')
except:
	exit("ERROR: Failed to reboot. Please reboot manually")
