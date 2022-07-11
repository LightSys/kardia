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
	
	print("\nResetting files...\n")
	
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
#  @param msg - the error message to print to the console
#  @return none
#  
def exit_with_error(msg):
	sys.exit(print_error(msg))
	
#  
#  name: print_instruction
#  description: prints a blue instruction message
#  @param msg - the message to print
#  @return none
#  
def print_instruction(msg):
	print("\x1b[1;37;44m**" + msg.upper() + "**\x1b[0m")
	
#  
#  name: print_error
#  description: prints a red error message
#  @param msg - the message to print
#  @return none
#  
def print_error(msg):
	print("\x1b[1;37;41m" + msg + "\x1b[0m")
	
#  
#  name: print_success
#  description: prints a green success message
#  @param msg - the message to print
#  @return none
#  
def print_success(msg):
	print("\x1b[1;32;40m" + msg + "\x1b[0m")
	
#  
#  name: color_input
#  description: gets input using an orange colored prompt
#  @param msg - the prompt to print
#  @return the console input from the user
#  
def color_input(msg):
	return input("\x1b[1;33;40m" + msg + "\x1b[0m")

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
#  name: yes_no_prompt
#  description: Performs validation testing on user input until a y or n
#  is received
#  @param msg - the user input prompt
#  @return 'y' or 'n', depending on user input
#  
def yes_no_prompt(msg):
	result = color_input(msg + " (y/n): ")
	while result.lower() != "y" and result.lower() != "n":
		result = color_input("Please enter y or n for your response: ")
	return result.lower();

#  
#  name: get_settings_hash
#  description: gets dictionary of settings read from the USB drive
#  @param lines - the lines read from the USB drive
#  @return dictionary of setting-value pairs
#  
def get_settings_hash(lines):
	
	dictionary = {}
	
	for line in lines:
		dictionary[line[0:line.index('=')].strip()] = line[line.index('=')+1:len(line)].strip()
		
	return dictionary
	
#  
#  name: ssh
#  description: establishes ssh connection to the specified user and ip
#  @param user - the server profile to connect to ("" if not specified)
#  @param ip - the ip address of the server
#  @return none
#  
def ssh(user, ip):
	# Attempt to connect
	try:
		print("\nConnecting to " + user + "@" + ip + "...\n")
		os.system('sudo ssh ' + ip + ' -o ConnectTimeout=5 -t "echo success" -t "exit" > /root/tmp/ssh.log')
	except:
		exit("Failed to establish SSH connection")

	# Determine if connection succeeded
	result = open("ssh.log", "r").read()
	if "success" in result:
		print("Connection succeeded")
	else:
		exit_with_error("SSH connection failed")
	
	# Remove the unneeded log file
	os.remove(r"/root/tmp/ssh.log")

## BEGIN MAIN SCRIPT----------------------------------------------------

# Print header
print()
print("RASPBERRY PI CHECK SCANNER ROUTER SETUP")
print("(c) 2022 LightSys Technology Services")
print("---------------------------------------")

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
		print_error("Failed to get USB devices")
	
	# If there is still no USB detected, wait 10 seconds and repeat
	if len(usbs) == 0:
		print("No USB device found, scanning again in 10 seconds...")
		time.sleep(10)
	
usb_name = usbs[0].get('LABEL')[1:len(usbs[0].get('LABEL'))-1]

print("\nAttempting setup with " + usb_name + "...\n")

# Read configuration settings from the flash drive----------------------

lines = ""

# Try to open the .config file and read the setup info
boot_file = ""
try:
	boot_file = open("/media/pi/" + usb_name + "/check_scanner_router."
	"config", "r")
except:
	exit_with_error("File path /media/pi/" + usb_name + "/"
	"check_scanner_router.config does not exist\nPlease check that the "
	"file is named correctly and loaded on your USB device")

settings = get_settings_hash(boot_file.readlines())

# If the device is already configured
if os.path.exists(r"/etc/systemd/system/check-scanner-autossh.service"):
	if settings["Reconfigure"] == "False":
		print_error("Device is already configured, and Reconfigure is set to \"False\"")
		sys.exit()
	elif settings["Reconfigure"] == "True":
		print("Reconfiguring device...")
		reset_files()
	else:
		exit_with_error("Invalid Reconfigure setting: Must be \"True\" or \"False\"")

# Get WiFi country code
country_code = settings["WLANCountry"]
print("WLAN Country Code: " + country_code)

if len(country_code) != 2: # Ensure there are two characters
	exit_with_error("Invalid country code: Code must be 2 letters")

# Get network SSID
network_name = settings["WiFiNetworkSSID"]
print("Network SSID: " + network_name)

# Get network passcode
network_password = settings["WiFiNetworkPassphrase"]
print("Network Password: " + hide_password(network_password))

# Get static IP address for the check scanner
static_ip_address = settings["CheckScannerStaticIP"]
print("Static IP Address: " + static_ip_address)

if is_ip_address(static_ip_address[0 : static_ip_address.index(
'/')]) == False or static_ip_address[static_ip_address.index(
'/')+1 : len(static_ip_address)].isdigit() == False:
	exit_with_error("Invalid Static IP Address: Format must be "
	"\"###.###.###.###/##\"")

# Get specific IP address for the check scanner
scanner_ip_address = settings["CheckScannerIPAddress"]
print("Scanner IP Address: " + scanner_ip_address)

if is_ip_address(scanner_ip_address) == False:
	exit_with_error("Invalid Scanner IP Address: Format must be "
	"\"###.###.###.###\"")

# Get the username for the server
server_user = settings["ServerUsername"]
print("Server Username read: " + server_user)

# Get the IP address of the server
server_ip = settings["ServerIP"]
print("Server IP Address: " + server_ip)

if is_ip_address(server_ip) == False:
	exit_with_error("Invalid Server IP Address: Format must be "
	"\"###.###.###.###\"")

# Get the listening port on the server
server_port = settings["ServerPortForCheckScanner"]
print("Server Listen Port Number: " + server_port)

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
print("\nSetting WLAN Country...")

wpa_supplicant = open(r"/etc/wpa_supplicant/wpa_supplicant.conf", "r")
lines = wpa_supplicant.readlines()

for i in range(0, len(lines)):
	if "country" in lines[i]:
		lines[i] = "country=" + country_code + "\n"

# Add network supplicant information

print("\nCreating WiFi network configuration...")

# Add configuration info
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

# Restart WiFi and wait for connection
try:
	print("\nConnecting to network...\n")
	os.system('sudo wpa_cli -i wlan0 reconfigure')
	print()
	
	while is_connected() == False:
		print("Waiting for connection...\n")
		time.sleep(5)
		pass
except:
	exit_with_error("Cannot connect to network. "
	"Check SSID and password")

print_success("Connected to " + network_name)

# Configure DHCP and DNSMASQ--------------------------------------------

# Upgrade all packages and install DNSMASQ package
try:
	print("\nUpdating packages...\n")
	os.system('sudo apt update')
	print_success("\nPackages updated")
except:
	print_error("Failed to update packages")
	
try:
	print("\nUpgrading packages (this may take a few minutes)...\n")
	os.system('sudo apt upgrade')
	print_success("\nPackages upgraded")
except:
	print_error("Failed to upgrade packages")
	
try:
	print("\nInstalling dnsmasq...\n")
	os.system('sudo apt install dnsmasq')
	print_success("\ndnsmasq installation complete")
except:
	exit_with_error("Failed to install dnsmasq package")

# DHCP configuration

print("\nConfiguring dhcp service...")

# Copy current dhcpcd.conf to backup file
make_backup(r"/etc/dhcpcd.conf")

# Append to dhcpcd.conf
dhcpcd_conf = open(r"/etc/dhcpcd.conf", "a")
dhcpcd_conf.write("\n\ninterface eth0\n"
"static ip_address=" + static_ip_address)
dhcpcd_conf.close()

# DNSMASQ configuration

print("\nConfiguring dnsmasq service...")

# Copy current dnsmasq.conf to backup file
make_backup(r"/etc/dnsmasq.conf")

# Rewrite dnsmasq.conf
dnsmasq_conf = open(r"/etc/dnsmasq.conf", "w")
dnsmasq_conf.write("interface=eth0\ndhcp-range="+scanner_ip_address+","
+scanner_ip_address+",255.255.255.0,30d")
dnsmasq_conf.close()

# Configure routing-----------------------------------------------------

# IPv4 forwarding configuration

print("\nEnabling IPv4 forwarding...")

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

print("\nAdding routing table info...")

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

# Set up SSH connection/configuration-----------------------------------

# Create SSH config file
print("\nCreating SSH configuration file...")
ssh_config = open(r"/root/.ssh/config", "w")
ssh_config.write("Host " + server_ip + "\nHostName " + server_ip + "\n"
"IdentityFile ~/.ssh/id_rsa\nUser " + server_user + "\n")
ssh_config.close()

# Generate public/private keys

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
	print_success("\nKey generation complete\n")
else:
	exit_with_error("\nKeygen failed: Key files not found after generation")

# Copy public key to server
try:
	os.system('sudo ssh-copy-id ' + server_ip)
	print_success("\nPublic RSA key copied to server")
except:
	exit_with_error("Failed to copy public key to server")
	
# Verify successful SSH connection to the server with key authentication

# Attempt to connect to the server
ssh("", server_ip)

print_success("\nKey authentication succeeded")

# Setup autossh Tunnel--------------------------------------------------

# Install autossh package
try:
	print("\nInstalling autossh...\n")
	os.system('sudo apt install autossh')
	print_success("\nautossh installation complete")
except:
	exit_with_error("Failed to install autossh package")

# Create autossh systemd service
print("\nBuilding autossh systemd process file...")
build_autossh_service()

# Apply all settings----------------------------------------------------

# Enable and start all services
try:
	print("\nEnabling and starting system processes...")
	os.system('sudo systemctl daemon-reload')
	os.system('sudo service dnsmasq start')
	os.system('sudo service dhcpcd start')
	os.system('sudo systemctl enable check-scanner-autossh.service')
	os.system('sudo systemctl start check-scanner-autossh.service')
	print_success("\nSystem processes enabled and started\n")
except:
	print()
	print_error("Failed to start services")

# Reboot
try:
	os.system('sudo shutdown -r +1')
	print()
	print_instruction("Your device will restart in 1 minute to "
	"apply changes. Cancelling the reboot may cause setup to fail")
	time.sleep(57)
	atexit.unregister(reset_files) #Disable file reset before reboot
	print("\nRebooting...\n")
except:
	exit_with_error("Failed to reboot")
