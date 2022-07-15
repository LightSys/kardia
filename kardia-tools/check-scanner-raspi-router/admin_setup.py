import sys
import os

# Add router configuration script to autostart process
print("Adding command to autostart...")
autostart = open(r"/etc/xdg/lxsession/LXDE-pi/autostart", "a")
autostart.write("@lxterminal -e sudo python3 /home/pi/Desktop/"
"check-scanner-raspi-router/config_router.py")
autostart.close()
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
	exit("Could not open wpa_supplicant.conf")

print("wpa_supplicant entry removed")

# Reboot to apply changes
print("Setup complete. Rebooting")
try:
	os.system('reboot now')
except:
	exit("Failed to reboot. Please reboot manually")
