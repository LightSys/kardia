#
#  config_router.py
#
#  Author: Alex Fehr
#  
#  Copyright 2022 LightSys Technology Services
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

#  
#  name: is_ip_address
#  description: checks to see if string is formatted as IP address
#  @param ip - the IP address to be checked
#  @return - True if input is validly formatted IP address, false if not
#  
def is_ip_address(ip):
	
	if ip.count('.') != 3:
		return False
	
	first_index = ip.index('.')
	if ip[0 : first_index].isdigit() == False or len(
	ip[0 : first_index]) > 3:
		return False
		
	second_index = ip.index('.', first_index+1)
	if ip[first_index+1 : second_index].isdigit() == False or len(
	ip[first_index+1 : second_index]) > 3:
		return False
		
	third_index = ip.index('.', second_index+1)
	if ip[second_index+1 : third_index].isdigit() == False or len(
	ip[second_index+1 : third_index]) > 3:
		return False
		
	if ip[third_index+1 : len(ip)].isdigit() == False or len(
	ip[third_index+1 : len(ip)]) > 3:
		return False
		
	return True

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
	logging.critical(msg)
	sys.exit(msg)
	
#  
#  name: print_exception
#  description: prints an exception messge
#  @param msg - the message to print to the console and log file
#  @return none
#  
def print_exception(msg):
	logging.exception(msg)
	print("\x1b[1;37;41m" + msg + "\x1b[0m")
	
#  
#  name: print_success
#  description: prints a success message
#  @param msg - the message to print to the console and log file
#  @return none
#  
def print_success(msg):
	logging.info(msg)
	print("\x1b[1;32;40m" + msg + "\x1b[0m")
	
#  
#  name: print_status
#  description: prints a standard message
#  @param - the message to pring to the console and log file
#  @return none
#
def print_status(msg):
	logging.info(msg)
	print(msg)

#  
#  name: make_backup
#  description: copies the input file to a backup file
#  @param srcfile - the file to be copied
#  @return none
#  
def make_backup(srcfile):
	file1 = open(srcfile, "r")
	file2 = open(srcfile + ".old", "w")
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
	except OSError:
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
		if '=' not in line:
			exit_with_error("Line " + line.strip() + " in config file needs = "
			"between the attribute name and value")
		dictionary[line[0:line.index('=')].strip()] = line[line.index(
		'=')+1:len(line)].strip()
		
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
		try:
			print_status("Connecting to " + ip + " with key...")
			os.system('sudo ssh ' + ip + ' -o "StrictHostKeyChecking no"'
			' -o ConnectTimeout=5 -t "echo success" -t "exit" > /tmp/ssh.log')
		except:
			exit_with_error("Failed to establish SSH connection with key"
			" authentication")
			
	else: # Attempt to connect with password authentication
		try:
			print_status("Connecting to " + ip + " with password...")
			os.system('sudo sshpass -p ' + password + ' ssh ' + ip + 
			' -o "StrictHostKeyChecking no" -o ConnectTimeout=5 -t "echo '
			'success" -t "exit" > /tmp/ssh.log')
		except:
			exit_with_error("Failed to establish SSH connection with password")

	# Determine if connection succeeded
	result = open("/tmp/ssh.log", "r").read()
	if "success" in result:
		print_success("Connection succeeded")
	else:
		exit_with_error("SSH connection failed")
	
	# Remove the unneeded log file
	os.remove(r"/tmp/ssh.log")

## BEGIN MAIN SCRIPT----------------------------------------------------

# Find USB device to use for setup--------------------------------------

usb_name = ""
usbs = []

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
		print("Failed to get USB devices")
	
	# If there is still no USB detected, wait 10 seconds and repeat
	if len(usbs) == 0:
		print("No USB device found, scanning again in 10 seconds...")
		time.sleep(10)
	
usb_name = usbs[0].get('LABEL')[1:len(usbs[0].get('LABEL'))-1]

logging.basicConfig(filename=r"/media/pi/" + usb_name + r"/setup.log", 
level=logging.DEBUG, format="%(asctime)s %(levelname)s %(message)s", 
filemode="a")

logging.info("START OF NEW LOG ENTRY")
print_status("Setting up with USB device " + usb_name + "...")

# Read configuration settings from the USB drive------------------------

lines = ""

# Try to open the .config file and read the setup info
print_status("Opening config file...")

boot_file = ""
try:
	boot_file = open(r"/media/pi/" + usb_name + r"/check_scanner_router."
	"config", "r")
except:
	exit_with_error("File path /media/pi/" + usb_name + "/"
	"check_scanner_router.config does not exist. Please check that the "
	"file is named correctly and loaded on your USB device")

settings = get_settings_hash(boot_file.readlines())
print_success("Settings read successfully")

# If the device is already configured
if os.path.exists(r"/etc/systemd/system/check-scanner-autossh.service"):
	try:
		reconfig = settings["Reconfigure"]
	except:
		exit_with_error("Could not find Reconfigure attribute: check "
		"attribute name")
		
	if reconfig == "False":
		exit_with_error("Device is already configured, and Reconfigure "
		"is set to \"False\"")
	elif reconfig == "True":
		print_status("Reconfiguring device...")
		reset_files()
	else:
		exit_with_error(reconfig + " is not a valid Reconfigure "
		"setting: Must be True or False")

# Get WiFi country code
try:
	country_code = settings["WLANCountry"]
except:
	exit_with_error("Could not find WLANCountry attribute: check "
	"attribute name")
print_status("WLAN Country Code: " + country_code)

if len(country_code) != 2: # Ensure there are two characters
	exit_with_error("Invalid country code: Code must be 2 letters")

# Get network SSID
try:
	network_name = settings["WiFiNetworkSSID"]
except:
	exit_with_error("Could not find WiFiNetworkSSID attribute: check "
	"attribute name")
print_status("Network SSID: " + network_name)

# Get network passcode
try:
	network_password = settings["WiFiNetworkPassphrase"]
except:
	exit_with_error("Could not find WiFiNetworkPassphrase attribute: check "
	"attribute name")
print_status("Network Password: " + hide_password(network_password))

# Get static IP address for the check scanner
try:
	static_ip_address = settings["CheckScannerRouterIP"]
except:
	exit_with_error("Could not find CheckScannerRouterIP attribute: check "
	"attribute name")
print_status("Router Static IP Address: " + static_ip_address)

if is_ip_address(static_ip_address[0 : static_ip_address.index(
'/')]) == False or static_ip_address[static_ip_address.index(
'/')+1 : len(static_ip_address)].isdigit() == False:
	exit_with_error("Invalid Static IP Address: Format must be "
	"\"###.###.###.###/##\"")

# Get specific IP address for the check scanner
try:
	scanner_ip_address = settings["CheckScannerIPAddress"]
except:
	exit_with_error("Could not find CheckScannerIPAddress attribute: check "
	"attribute name")
print_status("Scanner IP Address: " + scanner_ip_address)

if is_ip_address(scanner_ip_address) == False:
	exit_with_error("Invalid Scanner IP Address: Format must be "
	"\"###.###.###.###\"")

# Get the username for the server
try:
	server_user = settings["ServerUsername"]
except:
	exit_with_error("Could not find ServerUsername attribute: check "
	"attribute name")
print_status("Server Username: " + server_user)

# Get the password for the server
try:
	server_password = settings["ServerPassword"]
except:
	exit_with_error("Could not find ServerPassword attribute: check "
	"attribute name")
print_status("Server Password: " + hide_password(server_password))

# Get the IP address of the server
try:
	server_ip = settings["ServerIP"]
except:
	exit_with_error("Could not find ServerIP attribute: check "
	"attribute name")
print_status("Server IP Address: " + server_ip)

if is_ip_address(server_ip) == False:
	exit_with_error("Invalid Server IP Address: Format must be "
	"\"###.###.###.###\"")
		
# Get the listening port on the server
try:
	server_port = settings["ServerPortForCheckScanner"]
except:
	exit_with_error("Could not find ServerPortForCheckScanner attribute: check"
	" attribute name")
print_status("Server Listen Port Number: " + server_port)

if server_port.isdigit() == False or int(server_port) > 65535 or int(
server_port) <= 1023:
	exit_with_error("Invalid port number : Port must be integer between"
	" 1024 and 65535")

# Register reset_files to revert changes if error is encountered
atexit.register(reset_files)

# Add network info to wpa_supplicant.conf-------------------------------

# Copy current wpa_supplicant to backup file
make_backup(r"/etc/wpa_supplicant/wpa_supplicant.conf")

# Add country code
print_status("Setting WLAN Country...")

wpa_supplicant = open(r"/etc/wpa_supplicant/wpa_supplicant.conf", "r")
lines = wpa_supplicant.readlines()

for i in range(0, len(lines)):
	if "country" in lines[i]:
		lines[i] = "country=" + country_code + "\n"

# Add network supplicant information
print_status("Creating WiFi network configuration...")

lines.append("\nnetwork={\n")
lines.append("ssid=\"" + network_name + "\"\n")
lines.append("scan_ssid=1\n")
lines.append("psk=" + generate_wpa_psk(
network_name, network_password) + "\n")
lines.append("key_mgmt=WPA-PSK\n")
lines.append("priority=1\n")
lines.append("}")

# Write to the file
wpa_supplicant = open(r"/etc/wpa_supplicant/wpa_supplicant.conf", "w")
wpa_supplicant.writelines(lines)
wpa_supplicant.close()

# Restart WiFi and wait for connection----------------------------------

try:
	print_status("Connecting to network...")
	os.system('sudo wpa_cli -i wlan0 reconfigure')
except:
	exit_with_error("WLAN configuration error")
	
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

# Upgrade all packages and install DNSMASQ package----------------------

try:
	print_status("Updating packages...")
	os.system("sudo apt update")
	print_success("Packages updated")
except:
	print_error("Failed to update packages")
	
try:
	print_status("Upgrading packages...")
	os.system("sudo apt upgrade -y")
	print_success("Packages upgraded")
except:
	print_error("Failed to upgrade packages")
	
try:
	print_status("Installing dnsmasq...")
	os.system("sudo apt install dnsmasq -y")
	print_success("dnsmasq installation complete")
except:
	exit_with_error("Failed to install dnsmasq package")

# Configure DHCP--------------------------------------------------------

print_status("Configuring dhcp service...")

# Copy current dhcpcd.conf to backup file
make_backup(r"/etc/dhcpcd.conf")

# Append to dhcpcd.conf
dhcpcd_conf = open(r"/etc/dhcpcd.conf", "a")
dhcpcd_conf.write("interface eth0"
"static ip_address=" + static_ip_address)
dhcpcd_conf.close()

# Configure DNSMASQ-----------------------------------------------------

print_status("Configuring dnsmasq service...")

# Copy current dnsmasq.conf to backup file
make_backup(r"/etc/dnsmasq.conf")

# Rewrite dnsmasq.conf
dnsmasq_conf = open(r"/etc/dnsmasq.conf", "w")
dnsmasq_conf.write("interface=eth0\ndhcp-range="+scanner_ip_address+","
+scanner_ip_address+",255.255.255.0,30d")
dnsmasq_conf.close()

# Configure routing-----------------------------------------------------

# IPv4 forwarding configuration
print_status("Enabling IPv4 forwarding...")

# Copy current sysctl.conf to backup file
make_backup(r"/etc/sysctl.conf")

# Uncomment the setting for IPv4 forwarding
sysctl_conf = open(r"/etc/sysctl.conf", "r")
lines = sysctl_conf.readlines()

for i in range(0, len(lines)):
	if lines[i].strip() == "#net.ipv4.ip_forward=1":
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
rc_local = open(r"/etc/rc.local", "r")
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
	os.system("sudo mkdir .ssh")
except:
	exit_with_error("Failed to create .ssh directory")
	
ssh_config = open(r"/root/.ssh/config", "w")
ssh_config.write("Host " + server_ip + "\nHostName " + server_ip + "\n"
"IdentityFile ~/.ssh/id_rsa\nUser " + server_user + "\n")
ssh_config.close()

# Generate public/private keys------------------------------------------

print_status("Generating public/private RSA key pair...")

# If keys already exist, erase them
if os.path.exists(r"/root/.ssh/id_rsa"):
	os.remove(r"/root/.ssh/id_rsa")
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
	os.system('service ssh restart')
else:
	exit_with_error("Keygen failed: Key files not found after generation")

# Copy public key to server---------------------------------------------

if server_password == "":
	try:
		print_status("Copying public key to USB device...")
		os.system('sudo cp /root/.ssh/id_rsa.pub /media/pi/'
		 + usb_name + '/id_rsa.pub')
		print_success("Public key copied to USB device")
	except:
		print_exception("Failed to copy public key to USB device")

else:
	print_status("Copying public key to server...")
	# Install sshpass package
	try:
		print_status("Installing sshpass...")
		os.system('sudo apt install sshpass -y')
		print_success("sshpass installation complete")
	except:
		exit_with_error("Failed to install sshpass package")

	# Add server to known hosts using password login
	ssh(server_ip, server_password)
	
	# Copy key to server
	try:
		print_status("Copying public key to server...")
		os.system(
		'sudo sshpass -p ' + server_password + ' ssh-copy-id ' + server_ip)
		print_success("Public RSA key copied to server")
	except:
		exit_with_error("Failed to copy public key to server")
	
	# Uninstall sshpass package; there is no longer any need for it
	try:
		print_status("Uninstalling sshpass...")
		os.system('sudo apt remove sshpass -y')
		print_success("sshpass uninstalled")
	except:
		print_exception("Failed to uninstall ssh package")
		
	# Verify successful SSH connection to the server with key auth
	ssh(server_ip, "")
	print_success("Key authentication to server succeeded")

# Setup autossh Tunnel--------------------------------------------------

# Install autossh package
try:
	print_status("Installing autossh...")
	os.system('sudo apt install autossh -y')
	print_success("autossh installation complete")
except:
	exit_with_error("Failed to install autossh package")

# Create autossh systemd service
print_status("Building autossh systemd process file...")
build_autossh_service()

# Apply all settings----------------------------------------------------

# Enable and start all services
try:
	print_status("Enabling and starting system processes...")
	os.system('sudo systemctl daemon-reload')
	os.system('sudo service dnsmasq start')
	os.system('sudo service dhcpcd start')
	os.system('sudo systemctl enable check-scanner-autossh.service')
	os.system('sudo systemctl start check-scanner-autossh.service')
	print_success("System processes enabled and started")
except:
	print_error("Failed to start services")

# Shutdown
try:
	os.system('sudo shutdown +1')
	print_success("Your device will shutdown in 1 minute to "
	"apply changes. Cancelling may cause setup to fail")
	time.sleep(57)
except:
	exit_with_error("Failed to shutdown")

atexit.unregister(reset_files) # Disable file reset before reboot
print_success("SETUP COMPLETE")
logging.shutdown()
