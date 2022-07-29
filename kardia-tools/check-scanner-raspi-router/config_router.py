#!/usr/bin/python3

#
#  config_router.py
#
#  Author: Alex Fehr
#  
#  Copyright 2022 LightSys Technology Services
#
#  Last Modified 07/29/22 at 5:00 pm
#
#  Description: Reads configuration settings from a USB device to set up
#  Raspberry Pi for Ethernet-to-WiFi routing for check scanners. Meant
#  to autostart upon the Pi booting up.
#

import sys
import os
import atexit
import socket
import time
import hashlib
import binascii
import re
import logging
import validate_setup
import RPi.GPIO as GPIO
import threading

usb_log = "" # log file on USB device
pi_log = "" # log file on Raspberry Pi
LED_PIN = 11 # GPIO pin for the LED
led_thread = "" # thread to control the LED

#  
#  name: is_ip_address
#  description: checks to see if string is formatted as IP address
#  @param ip - the IP address to be checked
#  @return - True if input is validly formatted IP address, false if not
#  
def is_ip_address(ip):
	
	# If there are not three dots, fail
	if ip.count('.') != 3:
		return False
	
	# If the value before the first dot is invalid, fail
	first_index = ip.index('.')
	if ip[0 : first_index].isdigit() == False or len(
	ip[0 : first_index]) > 3:
		return False
	
	# If the value before the second dot is invalid, fail
	second_index = ip.index('.', first_index+1)
	if ip[first_index+1 : second_index].isdigit() == False or len(
	ip[first_index+1 : second_index]) > 3:
		return False
	
	# If the value before the third dot is invalid, fail
	third_index = ip.index('.', second_index+1)
	if ip[second_index+1 : third_index].isdigit() == False or len(
	ip[second_index+1 : third_index]) > 3:
		return False
	
	# If the value after the third dot is invalid, fail
	if ip[third_index+1 : len(ip)].isdigit() == False or len(
	ip[third_index+1 : len(ip)]) > 3:
		return False
		
	return True # Valid

#  
#  name: reset_files
#  description: resets all primary files from backups
#  @param none
#  #return none
#  
def reset_files():
	
	print_status("Resetting files...")
	
	# Reset /etc/dhcpcd.conf
	if os.path.exists(r"/etc/dhcpcd.conf.old"):
		file1 = open(r"/etc/dhcpcd.conf.old", "r")
		file2 = open(r"/etc/dhcpcd.conf", "w")
		file2.write(file1.read())
		file1.close();
		file2.close();
		os.remove(r"/etc/dhcpcd.conf.old")
	
	# Reset /etc/udhcpd.conf
	if os.path.exists(r"/etc/udhcpd.conf.old"):
		file1 = open(r"/etc/udhcpd.conf.old", "r")
		file2 = open(r"/etc/udhcpd.conf", "w")
		file2.write(file1.read())
		file1.close();
		file2.close();
		os.remove(r"/etc/udhcpd.conf.old")
	
	# Reset /etc/default/udhcpd
	if os.path.exists(r"/etc/default/udhcpd.old"):
		file1 = open(r"/etc/default/udhcpd.old", "r")
		file2 = open(r"/etc/default/udhcpd", "w")
		file2.write(file1.read())
		file1.close();
		file2.close();
		os.remove(r"/etc/default/udhcpd.old")
		
	# Reset /etc/dnsmasq.conf
	if os.path.exists(r"/etc/dnsmasq.conf.old"):
		file1 = open(r"/etc/dnsmasq.conf.old", "r")
		file2 = open(r"/etc/dnsmasq.conf", "w")
		file2.write(file1.read())
		file1.close();
		file2.close();
		os.remove(r"/etc/dnsmasq.conf.old")
	
	# Reset /etc/rc.local
	if os.path.exists(r"/etc/rc.local.old"):
		file1 = open(r"/etc/rc.local.old", "r")
		file2 = open(r"/etc/rc.local", "w")
		file2.write(file1.read())
		file1.close();
		file2.close();
		os.remove(r"/etc/rc.local.old")
	
	# Reset /etc/sysctl.conf
	if os.path.exists(r"/etc/sysctl.conf.old"):
		file1 = open(r"/etc/sysctl.conf.old", "r")
		file2 = open(r"/etc/sysctl.conf", "w")
		file2.write(file1.read())
		file1.close();
		file2.close();
		os.remove(r"/etc/sysctl.conf.old")
	
	# Reset /etc/wpa_supplicant/wpa_supplicant.conf
	if os.path.exists(
	r"/etc/wpa_supplicant/wpa_supplicant.conf.old"):
		file1 = open(r"/etc/wpa_supplicant/wpa_supplicant.conf."
		"old", "r")
		file2 = open(r"/etc/wpa_supplicant/wpa_supplicant.conf", "w")
		file2.write(file1.read())
		file1.close();
		file2.close();
		os.remove(r"/etc/wpa_supplicant/wpa_supplicant.conf.old")
	
	# Remove created files
	if os.path.exists(r"/etc/systemd/system/check-scanner-autossh."
	"service"):
		os.remove(r"/etc/systemd/system/check-scanner-autossh.service")
		
	if os.path.exists(r"/.ssh/config"):
		os.remove(r"/.ssh/config")
		
	if os.path.exists(r"/.ssh/id_rsa"):
		os.remove(r"/.ssh/id_rsa")
	
	if os.path.exists(r"/.ssh/id_rsa.pub"):
		os.remove(r"/.ssh/id_rsa.pub")

#  
#  name: exit_with_error
#  description: exits with specially formatted error message
#  @param msg - the error message to print to the console and log file
#  @return none
#  
def exit_with_error(msg):
	global stop_led_thread
	
	print_exception(msg)
	
	# Reset and shutdown logging
	reset_files()
	print_status("Shutting down...")
	logging.shutdown()
	
	# Kill the LED thread
	stop_led_thread = True
	led_thread.join()
	GPIO.cleanup()
	
	# Shutdown Pi
	try:
		os.system('sudo shutdown now')
	except:
		sys.exit("Failed to shutdown")
	
#  
#  name: print_exception
#  description: prints an exception messge
#  @param msg - the message to print to the console and log file
#  @return none
#  
def print_exception(msg):
	usb_log.exception(msg)
	print("\x1b[1;37;41m" + msg + "\x1b[0m")
	
#  
#  name: print_success
#  description: prints a success message
#  @param msg - the message to print to the console and log file
#  @return none
#  
def print_success(msg):
	usb_log.info(msg)
	print("\x1b[1;32;40m" + msg + "\x1b[0m")
	
#  
#  name: print_status
#  description: prints a standard message
#  @param - the message to print to the console and log file
#  @return none
#
def print_status(msg):
	usb_log.info(msg)
	print(msg)
	
#  
#  name: print_pi_log
#  description: prints standard message before USB device is inserted
#  @param - the message to print to the console and log file
#  @return none
#  
def print_pi_log(msg):
	pi_log.info(msg)
	print(msg)

#  
#  name: make_backup
#  description: copies the input file to a backup file
#  @param srcfile - the file to be copied
#  @return none
#  
def make_backup(src_file):
	
	# Open the original file
	try:
		file1 = open(src_file, "r")
	except:
		exit_with_error("Failed to read " + src_file)
	
	# Create the backup file
	try:
		file2 = open(src_file + ".old", "w")
	except:
		exit_with_error("Failed to make backup file " + src_file + ".old")
	
	# Copy the original to the backup
	file2.write(file1.read())
	file1.close()
	file2.close()
	
#  
#  name: build_autossh_service
#  description: writes the systemd file for the autossh tunnel
#  @param none
#  @return none
#  
def build_autossh_service():
	autossh_service = open(r"/etc/systemd/system/check-scanner-autossh."
	"service", "w")

	lines = ["[Unit]\n"]
	lines.append("Wants=network-online.target\n")
	lines.append("After=network-online.target\n")
	lines.append("Description=Check Scanner AutoSSH Tunnel\n\n")
	
	lines.append("[Service]\n")
	lines.append("Type=simple\n")
	lines.append("RemainAfterExit=yes\n")
	lines.append("Environment=\"AUTOSSH_GATETIME=0\"\n")
	lines.append("Environment=\"AUTOSSH_POLL=60\"\n")
	lines.append("ExecStart=/usr/bin/autossh -N -o "
	"\"ServerAliveInterval 30\" -o \"ServerAliveCountMax 3\" -R "
	"0:localhost:22 -R " + server_port + ":" + scanner_ip_address + ":"
	"443 " + server_ip + " -o \"ExitOnForwardFailure yes\"\n")
	lines.append("Restart=always\n")
	lines.append("RestartSec=60\n\n")
	
	lines.append("[Install]\n")
	lines.append("WantedBy=multi-user.target")
	
	autossh_service.writelines(lines)
	autossh_service.close()

#  
#  name: hide_password
#  description: returns a password with the characters replaced by '*'
#  @param psswd - the password to be hidden
#  @return - the password represented with '*'
#  
def hide_password(psswd):
	hiddenpsswd = ""
	for i in range(0, len(psswd)):
		hiddenpsswd += "*"
		
	return hiddenpsswd

#  
#  name: is_connected
#  description: determines whether or not a WiFi connection exists
#  @param none
#  @return True if there is a WiFi connection, False otherwise
#  
def is_connected():
	try:
		socket.create_connection(("1.1.1.1", 80))
		return True
	except:
		pass

	return False

#  
#  name: generate_wpa_psk
#  @param ssid - the SSID of the network to generate the PSK for
#  @param password - the plaintext password for the network
#  @return - the WPA PSK to use in place of the password in the
#	wpa_supplicant.conf file
#  
def generate_wpa_psk(ssid, password):
	dk = hashlib.pbkdf2_hmac(
	'sha1', str.encode(password), str.encode(ssid), 4096, 32)
	result = str(binascii.hexlify(dk))
	return result[2 : len(result)-1]

#  
#  name: get_settings_hash
#  description: gets dictionary of settings read from the USB drive
#  @param lines - the lines read from the USB drive
#  @return dictionary of setting-value pairs
#  
def get_settings_hash(lines):		
	dictionary = {}
	for line in lines:
		
		# Make sure the line is divided with a '=' character
		if '=' not in line:
			exit_with_error("Line " + line.strip() + " in config file needs = "
			"between the attribute name and value")
		
		# Get the attribute name
		key = line[0:line.index('=')].strip()
		
		# Make sure the attribute is not duplicated
		if key in dictionary:
			exit_with_error("Attribute \"" + key + "\" in config file has "
			"multiple entries. Please make sure each attribute is only "
			"listed once")
		
		# Write the attribute-value pair to the dictionary
		value = line[line.index('=')+1:len(line)].strip()
		dictionary[key] = value
		
	return dictionary

#  
#  name: ssh
#  description: establishes ssh connection to a server
#  @param ip - the ip address of the server
#  @param password - the password to the server, or "" if none
#  @return none
#  
def ssh(ip, password):
	if password == "": # Attempt to connect with key authentication
		print_status("Connecting to " + ip + " with key...")
		try:
			os.system('sudo ssh ' + ip + ' -o "StrictHostKeyChecking no"'
			' -o ConnectTimeout=5 -t "echo success" -t "exit" > /tmp/ssh.log')
		except:
			exit_with_error("Failed to establish SSH connection with key"
			" authentication: Check server username, IP address, and password")
			
	else: # Attempt to connect with password authentication
		print_status("Connecting to " + ip + " with password...")
		try:
			os.system('sudo sshpass -p ' + password + ' ssh ' + ip + 
			' -o "StrictHostKeyChecking no" -o ConnectTimeout=5 -t "echo '
			'success" -t "exit" > /tmp/ssh.log')
		except:
			exit_with_error("Failed to establish SSH connection with password"
			": Check server username, IP address, and password")

	# Determine if connection succeeded
	try:
		result = open("/tmp/ssh.log", "r").read()
	except:
		pass
		
	if "success" in result:
		print_success("Connection succeeded")
	else:
		exit_with_error("SSH connection failed: Check server username,"
		" IP address, and password")
	
	# Remove the unneeded log file
	try:
		os.remove(r"/tmp/ssh.log")
	except:
		pass

#  
#  name: setup_log
#  description: sets up logging object
#  @param name - the name of the logging object
#  @param log_file - the file to write the log entries to
#  @param file_mode - the file mode for the log file ("w", "a", etc.)
#  @return the created logging object
#  
def setup_log(name, log_file, file_mode):
	formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s')
	handler = logging.FileHandler(log_file, mode=file_mode)
	handler.setFormatter(formatter)
	
	logger = logging.getLogger(name)
	logger.setLevel(logging.DEBUG)
	logger.addHandler(handler)
	
	return logger
	
#  
#  name: control_led
#  description: target method for thread to control LED signals
#  @param led_state - the signal to use for the LED
#  @return none
#  
def control_led(led_state):
	global stop_led_thread
	
	LONG_TIME = 1.25
	SHORT_TIME = 0.2
	
	# If already configured but configuration invalid, use fast blinks
	if led_state == "error":
		while True:
			GPIO.output(LED_PIN, GPIO.HIGH)
			time.sleep(SHORT_TIME)
			GPIO.output(LED_PIN, GPIO.LOW)
			time.sleep(SHORT_TIME)
			if stop_led_thread: # Signal to stop the thread
				GPIO.output(LED_PIN, GPIO.LOW)
				break
	
	# If already configured and configuration is valid, use solid light		
	elif led_state == "operating":
		while True:
			GPIO.output(LED_PIN, GPIO.HIGH)
			time.sleep(LONG_TIME)
			if stop_led_thread: # Signal to stop the thread
				GPIO.output(LED_PIN, GPIO.LOW)
				break
	
	# If waiting for configuration, use slow blinks
	elif led_state == "waiting":
		while True:
			GPIO.output(LED_PIN, GPIO.HIGH)
			time.sleep(LONG_TIME)
			GPIO.output(LED_PIN, GPIO.LOW)
			time.sleep(SHORT_TIME)
			if stop_led_thread: # Signal to stop the thread
				GPIO.output(LED_PIN, GPIO.LOW)
				break
		
	# If being configured, use alternating short and long blinks		
	else:
		while True:
			GPIO.output(LED_PIN, GPIO.HIGH)
			time.sleep(SHORT_TIME)
			GPIO.output(LED_PIN, GPIO.LOW)
			time.sleep(SHORT_TIME)
			GPIO.output(LED_PIN, GPIO.HIGH)
			time.sleep(LONG_TIME)
			GPIO.output(LED_PIN, GPIO.LOW)
			time.sleep(SHORT_TIME)
			if stop_led_thread: # Signal to stop the thread
				GPIO.output(LED_PIN, GPIO.LOW)
				break


########################################################################
# BEGIN MAIN SCRIPT-----------------------------------------------------
########################################################################

# Setup logging and start LED-------------------------------------------

# Setup the log file on the Pi
pi_log = setup_log("usb_setup_log", r"/home/pi/Desktop/"
"check-scanner-raspi-router/boot.log", "w")

pi_log.info("---------BOOT LOG FOR RASPI CHECK SCANNER ROUTER---------")

# Setup GPIO LED pin
print_pi_log("Setting up GPIO...")
GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False)
GPIO.setup(LED_PIN, GPIO.OUT)

# If the device is already configured, validate the configuration
validated = False
if os.path.exists(r"/etc/systemd/system/check-scanner-autossh.service"):
	print_pi_log("Device is already configured. Running validation check...")	
	result = validate_setup.main()
	
	stop_led_thread = False
	
	# If configuration is invalid
	if "ERROR" in result:
		print_pi_log("ERROR IN CURRENT CONFIGURATION: " + result[7:])
		print_pi_log("Starting LED in \"error\" state...")
		led_thread = threading.Thread(target=control_led, args=("error",))
	# Else configuration is valid
	else:
		print_pi_log("Current configuration is valid: " + result)
		print_pi_log("Starting LED in \"operating\" state...")
		led_thread = threading.Thread(target=control_led, args=("operating",))
		validated = True
	
	# Start LED thread
	led_thread.setDaemon(False)
	led_thread.start()

# Else the device is not configured. Start LED thread
else:
	stop_led_thread = False
	print_pi_log("Starting LED in \"waiting\" state...")
	led_thread = threading.Thread(target=control_led, args=("waiting",))	
	led_thread.setDaemon(False)
	led_thread.start()

# Find USB device to use for setup--------------------------------------

usb_name = ""
usbs = []
tries = 0

# While there are no USBs detected
while len(usbs) == 0:
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
		print_pi_log("Failed to retrieve USB device")
	
	# If there is no USB detected, wait 10 seconds and repeat.
	# Wait up to 2 minutes for a USB device, then exit.
	if len(usbs) == 0 and tries <= 11: # Keep scanning
		print_pi_log("No USB device found, scanning again in 10 seconds...")
		tries += 1
		time.sleep(10)
	elif tries > 11: # Timeout
		print_pi_log("Timed out after 2 minutes: No USB device found")
		
		if validated: # If a valid configuration exists, exit the script
			sys.exit()
		else: # Else, shutdown the Pi
			print_pi_log("Shutting down...")
			logging.shutdown()
			
			stop_led_thread = True
			led_thread.join()
			GPIO.cleanup()
			
			try:
				os.system('sudo shutdown now')
			except:
				sys.exit("Failed to shutdown")

# Get the name of the connected USB drive
usb_name = usbs[0].get('LABEL')[1:len(usbs[0].get('LABEL'))-1]

print_pi_log("Found USB device " + usb_name + ". Mounting USB device...")

time.sleep(5) # Wait for the device to finish mounting

# Set up the log file on the USB device
print_pi_log("Switching log file location to " + usb_name + "...")

try:
	usb_log = setup_log("configuration_log", r"/media/pi/" + usb_name + 
	r"/setup.log", "a")
except:
	pi_log.exception("Cannot create log file on USB device. Ensure "
	"device is not read-only")
	sys.exit()

# Copy Pi log onto USB drive
try:
	os.system('sudo cp /home/pi/Desktop/check-scanner-raspi-router/'
	'boot.log /media/pi/' + usb_name + '/boot.log')
except:
	print_exception("Failed to copy boot log to USB device " + usb_name)

# Start USB log entry
usb_log.info("-----------------START OF NEW LOG ENTRY-----------------")
print_status("Setting up with USB device " + usb_name + "...")

# Read configuration settings from the USB drive------------------------

# Open the .config file and read the setup info
print_status("Opening config file...")

try:
	boot_file = open(r"/media/pi/" + usb_name + r"/check_scanner_router."
	"config", "r")
except:
	exit_with_error("File path /media/pi/" + usb_name + "/"
	"check_scanner_router.config does not exist. Check that the "
	"file is named correctly and loaded on your USB device")

settings = get_settings_hash(boot_file.readlines())
print_success("Configuration file read")

# If the device is already configured, check the Reconfigure value
if os.path.exists(r"/etc/systemd/system/check-scanner-autossh.service"):
	# Make sure Reconfigure attribute is set correctly
	try:
		reconfig = settings["Reconfigure"]
	except:
		exit_with_error("Could not find Reconfigure attribute: check "
		"attribute name")
		
	if reconfig == "False": # Do not reconfigure the device
		print_status("Device is already configured, and Reconfigure "
		"is set to \"False\"")
		sys.exit()
	elif reconfig == "True": # Reset files to defaults and reconfigure
		print_status("Reconfiguring Raspberry Pi device...")
		reset_files()
	else: # Invalid value
		exit_with_error("\"" + reconfig + "\" is not a valid Reconfigure "
		"setting: Must be True or False")
		
# Stop current LED code and start "configuring" LED code
stop_led_thread = True
led_thread.join()
print_status("Starting LED in \"configuring\" state...")
stop_led_thread = False
led_thread = threading.Thread(target=control_led, args=("configuring",))	
led_thread.setDaemon(False)
led_thread.start()

# Get WiFi country code
try:
	country_code = settings["WLANCountry"]
except:
	exit_with_error("Could not find WLANCountry attribute: Check "
	"attribute name")
print_status("WLAN Country Code: " + country_code)

if len(country_code) != 2: # Ensure there are two characters
	exit_with_error("\"" + country_code + "\" is an invalid country code:"
	" Code must be 2 letters")

# Get network SSID
try:
	network_name = settings["WiFiNetworkSSID"]
except:
	exit_with_error("Could not find WiFiNetworkSSID attribute: Check "
	"attribute name")
print_status("Network SSID: " + network_name)

# Get network passcode
try:
	network_password = settings["WiFiNetworkPassphrase"]
except:
	exit_with_error("Could not find WiFiNetworkPassphrase attribute: Check "
	"attribute name")
print_status("Network Password: " + hide_password(network_password))

# Get static IP address for the check scanner
try:
	static_ip_address = settings["CheckScannerRouterIP"]
except:
	exit_with_error("Could not find CheckScannerRouterIP attribute: Check "
	"attribute name")
print_status("Router Static IP Address: " + static_ip_address)

# Validate the IP address
if is_ip_address(static_ip_address[0 : static_ip_address.index(
'/')]) == False or static_ip_address[static_ip_address.index(
'/')+1 : len(static_ip_address)].isdigit() == False:
	exit_with_error("\"" + static_ip_address + "\" is an invalid static "
	"IP address: Format must be \"###.###.###.###/##\"")

# Get IP address for the check scanner
try:
	scanner_ip_address = settings["CheckScannerIPAddress"]
except:
	exit_with_error("Could not find CheckScannerIPAddress attribute: Check "
	"attribute name")
print_status("Scanner IP Address: " + scanner_ip_address)

# Validate the IP address
if is_ip_address(scanner_ip_address) == False:
	exit_with_error("\"" + scanner_ip_address + "\" is an invalid IP "
	"address: Format must be \"###.###.###.###\"")

# Get the username for the server
try:
	server_user = settings["ServerUsername"]
except:
	exit_with_error("Could not find ServerUsername attribute: Check "
	"attribute name")
print_status("Server Username: " + server_user)

# Get the password for the server
try:
	server_password = settings["ServerPassword"]
except:
	exit_with_error("Could not find ServerPassword attribute: Check "
	"attribute name")
print_status("Server Password: " + hide_password(server_password))

# Get the IP address of the server
try:
	server_ip = settings["ServerIP"]
except:
	exit_with_error("Could not find ServerIP attribute: Check "
	"attribute name")
print_status("Server IP Address: " + server_ip)

# Validate the IP address
if is_ip_address(server_ip) == False:
	exit_with_error("\"" + server_ip + "\" is an invalid IP address: "
	"Format must be \"###.###.###.###\"")
		
# Get the listening port on the server
try:
	server_port = settings["ServerPortForCheckScanner"]
except:
	exit_with_error("Could not find ServerPortForCheckScanner attribute: Check"
	" attribute name")
print_status("Server Listen Port Number: " + server_port)

# Ensure the port number is a valid integer
if server_port.isdigit() == False or int(server_port) > 65535 or int(
server_port) < 1024:
	exit_with_error("\"" + server_port + "\" is an invalid port number:"
	" Port must be integer between 1024 and 65535")

# Register reset_files to revert changes if error is encountered
atexit.register(reset_files)

# Add network info to wpa_supplicant.conf-------------------------------

# Copy current wpa_supplicant to backup file
make_backup(r"/etc/wpa_supplicant/wpa_supplicant.conf")

# Add country code
print_status("Setting WLAN Country...")

try:
	wpa_supplicant = open(r"/etc/wpa_supplicant/wpa_supplicant.conf", "r")
except:
	exit_with_error("Could not open wpa_supplicant.conf")

lines = wpa_supplicant.readlines()

for i in range(0, len(lines)):
	if "country" in lines[i]:
		lines[i] = "country=" + country_code + "\n"

# Add network supplicant information
print_status("Creating WPA supplicant configuration...")

lines.append("\nnetwork={\n")
lines.append("ssid=\"" + network_name + "\"\n")
lines.append("scan_ssid=1\n")
lines.append("psk=" + generate_wpa_psk(network_name, network_password) + "\n")
lines.append("key_mgmt=WPA-PSK\n")
lines.append("priority=1\n")
lines.append("}")

# Write to the file
wpa_supplicant = open(r"/etc/wpa_supplicant/wpa_supplicant.conf", "w")
wpa_supplicant.writelines(lines)
wpa_supplicant.close()

# Restart WiFi and wait for connection----------------------------------

print_status("Connecting to network...")

try:
	os.system('sudo wpa_cli -i wlan0 reconfigure')
except:
	exit_with_error("WLAN could not be reconfigured")

time.sleep(5)

tries = 0
while is_connected() == False:
	tries += 1
	if tries > 12:
		exit_with_error("Network connection timed out. Check network "
		"SSID and password")
	
	print_status("Waiting for connection...")
	time.sleep(5)
	pass

print_success("Connected to " + network_name)

# Upgrade all packages and install needed packages----------------------

# Update
print_status("Updating packages...")
try:
	os.system("sudo apt update")
except:
	print_error("Failed to update packages")
print_success("Packages updated")

# Upgrade
print_status("Upgrading packages...")
try:
	os.system("sudo apt upgrade -y")
except:
	print_error("Failed to upgrade packages")
print_success("Packages upgraded")

# dnsmasq
print_status("Installing dnsmasq...")
try:
	os.system("sudo apt install dnsmasq -y")
except:
	exit_with_error("Failed to install dnsmasq package")
print_success("dnsmasq installation complete")

# udhcpd
print_status("Installing udhcpd...")
try:
	os.system("sudo apt install udhcpd -y")
except:
	exit_with_error("Failed to install udhcpd package")	
print_success("udhcpd installation complete")

# Configure DHCPCD------------------------------------------------------

print_status("Configuring dhcpcd service...")

# Copy current dhcpcd.conf to backup file
make_backup(r"/etc/dhcpcd.conf")

# Append to dhcpcd.conf
try:
	dhcpcd_conf = open(r"/etc/dhcpcd.conf", "a")
except:
	exit_with_error("Could not open dhcpcd.conf")

dhcpcd_conf.write("\ninterface eth0")
dhcpcd_conf.write("\nstatic ip_address=" + static_ip_address)
dhcpcd_conf.close()

# Configure DNSMASQ-----------------------------------------------------

print_status("Configuring dnsmasq service...")

# Copy current dnsmasq.conf to backup file
make_backup(r"/etc/dnsmasq.conf")

# Rewrite dnsmasq.conf
dnsmasq_conf = open(r"/etc/dnsmasq.conf", "w")
dnsmasq_conf.write("interface=eth0\ndhcp-range=" + scanner_ip_address + ","
+ scanner_ip_address + ",255.255.255.0,10d")
dnsmasq_conf.close()

# Configure UDHCPD------------------------------------------------------

print_status("Configuring udhcpd service...")

# Make backup of udhcpd.conf
make_backup(r"/etc/udhcpd.conf")

# Modify udhcpd.conf
try:
	udhcpd_conf = open(r"/etc/udhcpd.conf", "r")
except:
	exit_with_error("Could not open udhcpd.conf")

lines = udhcpd_conf.readlines()

for i in range(0, len(lines)):
	if "start" in lines[i] and "#default" in lines[i]:
		lines[i] = "start           " + scanner_ip_address + "\n"
	elif "end" in lines[i] and "#default" in lines[i]:
		lines[i] = "end             " + scanner_ip_address + "\n"
		break
		
udhcpd_conf = open(r"/etc/udhcpd.conf", "w")
udhcpd_conf.writelines(lines)
udhcpd_conf.close()

# Make backup of default/udhcpd
make_backup(r"/etc/default/udhcpd")

# Enable udhcpd
try:
	udhcpd_default = open(r"/etc/default/udhcpd", "r")
except:
	exit_with_error("Could not open udhcpd file in default folder")

lines = udhcpd_default.readlines()

for i in range(0, len(lines)):
	if 'DHCPD_ENABLED="no"' in lines[i]:
		lines[i] = '#DHCPD_ENABLED="no"\n'
		break

udhcpd_default = open(r"/etc/default/udhcpd", "w")		
udhcpd_default.writelines(lines)
udhcpd_default.close()

# Configure routing-----------------------------------------------------

# IPv4 forwarding configuration
print_status("Enabling IPv4 forwarding...")

# Copy current sysctl.conf to backup file
make_backup(r"/etc/sysctl.conf")

# Uncomment the setting for IPv4 forwarding
try:
	sysctl_conf = open(r"/etc/sysctl.conf", "r")
except:
	exit_with_error("Could not open sysctl.conf")
lines = sysctl_conf.readlines()

for i in range(0, len(lines)):
	if "#net.ipv4.ip_forward=1" in lines[i]:
		lines[i] = "net.ipv4.ip_forward=1\n"
		break

sysctl_conf = open(r"/etc/sysctl.conf", "w")
sysctl_conf.writelines(lines)
sysctl_conf.close()

# Routing table configuration
print_status("Adding routing table info...")

# Copy current rc.local to backup file
make_backup(r"/etc/rc.local")

# Add routing table info
try:
	rc_local = open(r"/etc/rc.local", "r")
except:
	exit_with_error("Could not open rc.local")

lines = rc_local.readlines()

for i in range(0, len(lines)):
	if lines[i].strip() == "exit 0":
		lines.insert(i, "sudo iptables -t nat -A POSTROUTING -o wlan0 "
		"-j MASQUERADE\n")
		lines.insert(i+1, "sudo iptables -A FORWARD -i wlan0 -o eth0 -m"
		" state --state RELATED,ESTABLISHED -j ACCEPT\n")
		lines.insert(i+2, "sudo iptables -A FORWARD -i eth0 -o wlan0 -j"
		" ACCEPT\n\n")
		break

rc_local = open(r"/etc/rc.local", "w")
rc_local.writelines(lines)
rc_local.close()

# Configure SSH---------------------------------------------------------

print_status("Creating SSH configuration file...")

# Create SSH config file
try:
	os.system("sudo mkdir /root/.ssh")
except:
	exit_with_error("Failed to create .ssh directory")

try:
	ssh_config = open(r"/root/.ssh/config", "w")
	ssh_config.write("Host " + server_ip + "\nHostName " + server_ip + "\n"
	"IdentityFile ~/.ssh/id_rsa\nUser " + server_user + "\n")
	ssh_config.close()
except:
	exit_with_error("Failed to create ssh config file")

# Generate public/private keys------------------------------------------

print_status("Generating public/private RSA key pair...")

# If keys already exist, erase them
if os.path.exists(r"/root/.ssh/id_rsa"):
	os.remove(r"/root/.ssh/id_rsa")

if os.path.exists(r"/root/.ssh/id_rsa.pub"):
	os.remove(r"/root/.ssh/id_rsa.pub")

# Generate the keys
try:
	os.system("sudo ssh-keygen -q -m pem -N '' -f ~/.ssh/id_rsa")
except:
	exit_with_error("Keygen failed: ssh-keygen returned an error")

# Check to ensure keys were successfully generated
if os.path.exists(r"/root/.ssh/id_rsa") and os.path.exists(
r"/root/.ssh/id_rsa.pub"):
	print_success("Key generation complete")
	
	try:
		os.system('service ssh restart')
	except:
		print_exception("Failed to restart ssh service")

else:
	exit_with_error("Keygen failed: Key files not found after generation")

# Copy public key to server or USB device-------------------------------

# If no server password provided in the .config file, copy to USB
if server_password == "":
	print_status("Copying public key to USB device...")
	
	try:
		os.system('sudo cp /root/.ssh/id_rsa.pub /media/pi/'
		 + usb_name + '/id_rsa.pub')
	except:
		print_exception("Failed to copy public key to USB device: Ensure"
		"device is not read-only and remains connected until setup completes")
		
	print_success("Public key copied to USB device")

# Else connect to server and copy public key
else:
	print_status("Copying public key to server...")

	# Install sshpass package
	print_status("Installing sshpass...")
	
	try:
		os.system('sudo apt install sshpass -y')
	except:
		exit_with_error("Failed to install sshpass package")
		
	print_success("sshpass installation complete")

	# Add server to known hosts using password login
	ssh(server_ip, server_password)
	
	# Copy key to server
	print_status("Copying public key to server...")
	try:
		os.system('sudo sshpass -p ' + server_password + ' ssh-copy-id ' 
		+ server_ip)
	except:
		exit_with_error("Failed to copy public key to server: Check"
		"server username, IP address, and password")
		
	print_success("Public RSA key copied to server")
	
	# Uninstall sshpass package; there is no longer any need for it
	print_status("Uninstalling sshpass...")
	
	try:
		os.system('sudo apt remove sshpass -y')
	except:
		print_exception("Failed to uninstall ssh package")
		
	print_success("sshpass uninstalled")
		
	# Verify successful SSH connection to the server with key auth
	ssh(server_ip, "")
	print_success("Key authentication to server succeeded")

# Setup autossh Tunnel--------------------------------------------------

# Install autossh package
print_status("Installing autossh...")

try:
	os.system('sudo apt install autossh -y')
except:
	exit_with_error("Failed to install autossh package")
	
print_success("autossh installation complete")

# Create autossh systemd service
print_status("Building autossh systemd process file...")
build_autossh_service()

# Apply all settings----------------------------------------------------

# Enable and start all services
print_status("Enabling and starting system processes...")

try:
	os.system('sudo systemctl daemon-reload')
	os.system('sudo service udhcpd start')
	os.system('sudo service dhcpcd start')
	os.system('sudo service dnsmasq start')
	os.system('sudo systemctl enable check-scanner-autossh.service')
	os.system('sudo systemctl start check-scanner-autossh.service')
except:
	print_error("Failed to start services")
	
print_success("System processes enabled and started")

# Validate setup--------------------------------------------------------

print_status("Device is configured. Running validation check...")
result = validate_setup.main()

if "ERROR" in result:
	exit_with_error("Error in configuration: " + result[7:])
else:
	print_success("Configuration is valid: " + result)

# SETUP COMPLETE: Shutdown----------------------------------------------

# Shutdown logging
print_success("SETUP COMPLETE")
logging.shutdown()

atexit.unregister(reset_files) # Disable file reset

# Stop LED thread
stop_led_thread = True
led_thread.join()
GPIO.cleanup()

# Shutdown
try:
	os.system('sudo shutdown now')
except:
	sys.exit("Failed to shutdown")
