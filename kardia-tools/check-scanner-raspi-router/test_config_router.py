########################################################################
#
#  THIS SCRIPT IS IN DEVELOPMENT AND DOES NOT WORK CORRECTLY
#
#  This script is meant to check error results from the config_router.py
#  script by generating various flawed check_scanner_router.config
#  files on a USB drive
#
#  Each test is supposed to follow this process:
#   1. Generate a flawed .config file on the USB drive aimed
#      at producing a specific error in config_router.py
#   2. Run config_router.py and pipe the console output to a temporary
#      file
#   3. Check the file for the presence of the error code
#
#  Current issues:
#   - config_router.py is designed to shut down the Pi upon encountering
#     an error, thus preventing the test from continuing
#   - The .config file is not being generated on the USB drive correctly
#
########################################################################


import os
import re
import time

#
# name: test_configuration
# @param to_change - Integer indicating the configuration file value to be tested
# @param new_val - Invalid string test value to which to_change is changed
# @param expected_msg - the error message (string) that should be thrown due to new_val
#
def test_configuration(to_change, new_val, expected_msg, usb): 
	
	# Open file
	try:
		config_file = open("/media/pi/" + usb + "/check_scanner_router.config", "w")
	except:
		exit("Config file not found\n")
		
	# Set default config file settings
	default_settings = {
	"DEFAULT0" : "Reconfigure=False",
	"DEFAULT1" : "WLANCountry=US",
	"DEFAULT2" : "WiFiNetworkSSID=Network",
	"DEFAULT3" : "WiFiNetworkPassphrase=password",
	"DEFAULT4" : "CheckScannerRouterIP=123.456.789.1/34",
	"DEFAULT5" : "CheckScannerIPAddress=123.456.789.2",
	"DEFAULT6" : "ServerUsername=User",
	"DEFAULT7" : "ServerPassword=password",
	"DEFAULT8" : "ServerIP=123.456.123.456",
	"DEFAULT9" : "ServerPortForCheckScanner=21443"}

	configuration = []
	for setting in default_settings.values():
		configuration.append(setting + "\n")
	config_file.writelines(configuration)

	# Call main script
	os.system('sudo python3 /home/pi/Desktop/check-scanner-raspi-router/config_router.py > /home/pi/Desktop/check-scanner-raspi-router/test_output.txt')
	os.system('shutdown -c')

	# Open output file
	with open("/home/pi/Desktop/check-scanner-raspi-router/test_output.txt", "r", encoding='utf-8') as temp:
		output = temp.readlines()

	if expected_msg in output:
		return "PASS"
	else:
		return "FAIL"

def main():
	cmd = "/home/pi/Desktop/check-scanner-raspi-router/config_router.py"

	usb =""
	usbs = []
		
	try:
		# Get mounted devices
		devices = os.popen('sudo blkid').readlines()
		
		# Pack USB device info into dictionary list
		for device in devices:
			loc = [device.split(':')[0]]
			if '/dev/sd' not in loc[0]:
				continue
			loc += re.findall(r'"[^"]+"',device)
			columns = ['loc'] + re.findall(r'\b(\w+)=',device)
			
			usbs.append(dict(zip(columns,loc)))
	except:
		print("Failed to retrieve USB device")

	if len(usbs) == 0:
		exit("No USB device found: Please insert a USB drive for the test")

	# Get the name of the connected USB drive
	usb = usbs[0].get('LABEL')[1:len(usbs[0].get('LABEL'))-1]
	
	time.sleep(5)

	print(test_configuration(0, "Reconfigure=XYXXY", "Reconfigure", usb))

if __name__ == "__main__":
	main()
