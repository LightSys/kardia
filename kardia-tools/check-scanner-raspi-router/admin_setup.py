#!/usr/bin/python3

#
#  admin_setup.py
#
#  Author: Alex Fehr
#  
#  Copyright 2022 LightSys Technology Services
#
#  Last Modified 07/26/22 at 11:00 am
#
#  Description: Updates and installs packages, adds the config_router.py
#  script to autostart, and clears WPA supplicant info
#

import sys
import os
import time

# Upgrade all packages and install needed packages----------------------

# Update
print("Updating packages...\n")
try:
	os.system("sudo apt update")
except:
	print("ERROR: Failed to update packages")
print("\nPackages updated\n")

# Upgrade
print("Upgrading packages...\n")
try:
	os.system("sudo apt upgrade -y")
except:
	print("ERROR: Failed to upgrade packages")
print("\nPackages upgraded\n")

# dnsmasq
print("Installing dnsmasq...\n")
try:
	os.system("sudo apt install dnsmasq -y")
except:
	print("ERROR: Failed to install dnsmasq package")
print("\ndnsmasq installation complete\n")

# udhcpd
print("Installing udhcpd...\n")
try:
	os.system("sudo apt install udhcpd -y")
except:
	print("ERROR: Failed to install udhcpd package")	
print("\nudhcpd installation complete\n")

# autossh
print("Installing autossh...\n")
try:
	os.system("sudo apt install autosshautossh -y")
except:
	print("ERROR: Failed to install autossh package")	
print("\nautossh installation complete\n")

# Ensure the config_router script is located in the correct folder------

if os.path.exists(r"/home/pi/Desktop/check-scanner-raspi-router/"
"config_router.py") == False:
	exit("ERROR: config_router.py not found. Please make sure "
	"config_router.py is placed in the file path /home/pi/Desktop/"
	"check-scanner-raspi-router/config_router.py")
	
# Ensure the validate_setup script is located in the correct folder-----

if os.path.exists(r"/home/pi/Desktop/check-scanner-raspi-router/"
"validate_setup.py") == False:
	exit("ERROR: validate_setup.py not found. Please make sure "
	"validate_setup.py is placed in the file path /home/pi/Desktop/"
	"check-scanner-raspi-router/validate_setup.py")

# Add config_router script to autostart process-------------------------

print("Adding command to autostart...\n")

autostart = ""

try:
	autostart = open(r"/etc/xdg/lxsession/LXDE-pi/autostart", "r")	
except:
	exit("ERROR: Could not open autostart")
	
lines = autostart.readlines()

# Check if the command has already been added to autostart
already_modified = False
for line in lines:
	if "@lxterminal -e sudo python3" in line: # If so, skip
		already_modified = True
		break

if already_modified == False: # If not, add the command
	try:
		autostart = open(r"/etc/xdg/lxsession/LXDE-pi/autostart", "a")	
	except:
		exit("ERROR: Could not open autostart")
		
	autostart.write("@lxterminal -e sudo python3 /home/pi/Desktop/"
	"check-scanner-raspi-router/config_router.py &\n")
	
autostart.close()

print("autostart modification complete\n")

# Remove admin network info from wpa_supplicant-------------------------

print("Clearing wpa_supplicant...\n")

wpa_supplicant = ""

try:
	wpa_supplicant = open(r"/etc/wpa_supplicant/wpa_supplicant.conf", "r")
except:
	exit("ERROR: Could not open wpa_supplicant.conf")
	
read_lines = wpa_supplicant.readlines()
write_lines = ["", "", ""]

for i in range(0, 3):
	write_lines[i] = read_lines[i]

# Write to the file
try:
	wpa_supplicant = open(r"/etc/wpa_supplicant/wpa_supplicant.conf", "w")
except:
	exit("ERROR: Could not open wpa_supplicant.conf")

wpa_supplicant.writelines(write_lines)
wpa_supplicant.close()

print("wpa_supplicant cleared\n")

# Reboot to apply changes
print("Setup complete. Rebooting...")

time.sleep(3)

try:
	os.system('reboot now')
except:
	exit("ERROR: Failed to reboot. Please reboot manually")
