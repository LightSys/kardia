#!/usr/bin/python3

#
#  validate_setup.py
#
#  Author: Alex Fehr
#  
#  Copyright 2022 LightSys Technology Services
#
#  Last Modified 07/29/22 at 5:00 pm
#
#  Description: Checks router configuration settings to ensure setup
#  was successful
#

import os
import socket

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
#  name: main
#  description: the main body of the script
#  @param none
#  @returns a message with the results of the validation test
#
def main():

	# Validate wpa_supplicant configuration-----------------------------
	
	# Ensure the conf and backup files exist
	if (os.path.exists(r"/etc/wpa_supplicant/wpa_supplicant.conf") == False or 
	os.path.exists(r"/etc/wpa_supplicant/wpa_supplicant.conf.old") == False):
		return "ERROR: wpa_supplicant files not found"
	
	# Open the conf file
	try:
		wpa_supplicant = open(r"/etc/wpa_supplicant/wpa_supplicant.conf", "r")
	except:
		return "ERROR: Could not open wpa_supplicant.conf"
	
	# Read the conf file
	lines = wpa_supplicant.readlines()
	wpa_supplicant.close()
	
	# Check the conf file for validity
	if ("ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev" not in lines[0] or
	"update_config=1" not in lines[1] or
	"country=" not in lines[2] or
	"network={" not in lines[4] or
	"ssid=" not in lines[5] or
	"scan_ssid=1" not in lines[6] or
	"psk=" not in lines[7] or
	"key_mgmt=WPA-PSK" not in lines[8] or
	"priority=1" not in lines[9] or
	"}" not in lines[10]):
		return "ERROR: wpa_supplicant.conf is invalid"
	
	# Verify WiFi connection--------------------------------------------
	
	if is_connected == False:
		return "ERROR: WiFi connection not established"
	
	# Validate dhcpcd configuration-------------------------------------
	
	# Ensure the conf and backup files exist
	if (os.path.exists(r"/etc/dhcpcd.conf") == False or
	os.path.exists(r"/etc/dhcpcd.conf.old") == False):
		return "ERROR: dhcpcd files not found"
	
	# Open the conf file
	try:
		dhcpcd_conf = open(r"/etc/dhcpcd.conf", "r")
	except:
		return "ERROR: Could not open dhcpcd.conf"
	
	# Read the conf file
	lines = dhcpcd_conf.readlines()
	dhcpcd_conf.close()
	
	# Check the conf file for validity
	if ("interface eth0" not in lines[len(lines)-2] or
	"static ip_address=" not in lines[len(lines)-1]):
		return "ERROR: dhcpcd.conf is invalid"
	
	# Validate dnsmasq configuration------------------------------------
	
	# Ensure the conf and backup files exist
	if (os.path.exists(r"/etc/dnsmasq.conf") == False or
	os.path.exists(r"/etc/dnsmasq.conf.old") == False):
		return "ERROR: dnsmasq files not found"
	
	# Open the conf file
	try:
		dnsmasq_conf = open(r"/etc/dnsmasq.conf", "r")
	except:
		return "ERROR: Could not open dnsmasq.conf"
	
	# Read the conf file
	lines = dnsmasq_conf.readlines()
	dnsmasq_conf.close()
	
	# Check the conf file for validity
	if ("interface=eth0" not in lines[0] or
	"dhcp-range=" not in lines[1]):
		return "ERROR: dnsmasq.conf is invalid"
	
	# Validate udhcpd default-------------------------------------------
	
	# Ensure the active and backup files exist
	if (os.path.exists(r"/etc/default/udhcpd") == False or
	os.path.exists(r"/etc/default/udhcpd.old") == False):
		return "ERROR: udhcpd default files not found"
	
	# Open the active file
	try:
		udhcpd_default = open(r"/etc/default/udhcpd", "r")
	except:
		return "ERROR: Could not open udhcpd default file"
	
	# Read the active file
	lines = udhcpd_default.readlines()
	udhcpd_default.close()
	
	# Check the active file for validity
	if "#" not in lines[1]:
		return "ERROR: udhcpd not enabled in default file"
	
	# Validate udhcpd configuration-------------------------------------
	
	# Ensure the conf and backup files exist
	if (os.path.exists(r"/etc/udhcpd.conf") == False or
	os.path.exists(r"/etc/udhcpd.conf.old") == False):
		return "ERROR: udhcpd configuration files not found"
	
	# Open the conf file
	try:
		udhcpd_conf = open(r"/etc/udhcpd.conf", "r")
	except:
		return "ERROR: Could not open udhcpd.conf"
	
	# Read the conf file
	lines = udhcpd_conf.readlines()
	udhcpd_conf.close()
	
	# Check if the conf file was modified correctly
	if ("#default:" in lines[4] or 
	"#default:" in lines[5]):
		return "ERROR: udhcpd.conf is invalid"
	
	# Verify IPv4 routing is enabled------------------------------------
	
	# Ensure the sysctl conf and backup files exist
	if (os.path.exists(r"/etc/sysctl.conf") == False or
	os.path.exists(r"/etc/sysctl.conf.old") == False):
		return "ERROR: sysctl configuration files not found"
	
	# Open the conf file
	try:
		sysctl_conf = open(r"/etc/sysctl.conf", "r")
	except:
		return "ERROR: Could not open sysctl.conf"
	
	# Read the conf file
	lines = sysctl_conf.readlines()
	sysctl_conf.close()
	
	# Check the conf file for IPv4 forwarding
	for line in lines:
		if "net.ipv4.ip_forward=1" in line:
			if "#" in line:
				return "ERROR: IPv4 routing not enabled"
			else:
				break
				
	# Validate routing tables-------------------------------------------
	
	# Ensure the rc.local and backup files exist
	if (os.path.exists(r"/etc/rc.local") == False or
	os.path.exists(r"/etc/rc.local.old") == False):
		return "ERROR: rc.local files not found"
	
	# Open the rc.local file
	try:
		rc_local = open(r"/etc/rc.local", "r")
	except:
		return "ERROR: Could not open rc.local"
	
	# Read the rc.local file
	lines = rc_local.readlines()
	rc_local.close()
	
	# Check the rc.local for the correct routing tables
	if ("sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE" not in lines[len(lines)-5] or
	"sudo iptables -A FORWARD -i wlan0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT" not in lines[len(lines)-4] or
	"sudo iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT" not in lines[len(lines)-3]):
		return "ERROR: Routing tables are invalid"

	# Validate ssh configuration----------------------------------------
	
	# Ensure the conf file exists
	if os.path.exists(r"/root/.ssh/config") == False:
		return "ERROR: ssh config file not found"
	
	# Open the conf file
	try:
		ssh_config = open(r"/root/.ssh/config", "r")
	except:
		return "ERROR: Cannot open ssh config file"
	
	# Read the conf file
	lines = ssh_config.readlines()
	ssh_config.close()
	
	# Check the conf file for valid entry
	if ("Host " not in lines[0] or
	"HostName " not in lines[1] or
	"IdentityFile ~/.ssh/id_rsa" not in lines[2] or
	"User " not in lines[3]):
		return "ERROR: ssh config is invalid"
		
	# Validate RSA keys-------------------------------------------------
	
	# Ensure the private and public key files exist
	if (os.path.exists(r"/root/.ssh/id_rsa") == False or
	os.path.exists(r"/root/.ssh/id_rsa.pub") == False):
		return "ERROR: RSA key files not found"
	
	# Open the key files
	try:
		id_rsa = open(r"/root/.ssh/id_rsa", "r")
		id_rsa_pub = open(r"/root/.ssh/id_rsa.pub", "r")
	except:
		return "ERROR: Cannot open RSA key files"
	
	# Check the key files for the correct headings
	if ("-----BEGIN RSA PRIVATE KEY-----" not in id_rsa.readline() or
	"ssh-rsa" not in id_rsa_pub.readline()):
		return "ERROR: RSA key files are invalid"
		
	id_rsa.close()
	id_rsa_pub.close()
		
	# Valdate autossh service file--------------------------------------
	
	# Ensure the service file exists
	if os.path.exists(r"/etc/systemd/system/check-scanner-autossh.service") == False:
		return "ERROR: check-scanner-autossh.service not found"
	
	# Open the file
	try:
		autossh_service = open(r"/etc/systemd/system/check-scanner-autossh."
		"service", "r")
	except:
		return "ERROR: Cannot open check-scanner-autossh.service"
	
	# Read the file
	lines = autossh_service.readlines()
	autossh_service.close()
	
	# Check the file for accuracy
	if ("[Unit]" not in lines[0] or
	"Wants=network-online.target" not in lines[1] or
	"After=network-online.target" not in lines[2] or
	"Description=Check Scanner AutoSSH Tunnel" not in lines[3] or
	"[Service]" not in lines[5] or
	"Type=simple" not in lines[6] or
	"RemainAfterExit=yes" not in lines[7] or
	'Environment="AUTOSSH_GATETIME=0"' not in lines[8] or
	'Environment="AUTOSSH_POLL=60"' not in lines[9] or
	'ExecStart=/usr/bin/autossh -N -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -R 0:localhost:22' not in lines [10] or
	"Restart=always" not in lines[11] or
	"RestartSec=60" not in lines[12] or
	"[Install]" not in lines[14] or
	"WantedBy=multi-user.target" not in lines[15]):
		return "ERROR: check-scanner-autossh.service is invalid"
		
	# Validate that autossh system process is working-------------------
	
	# Get the service status
	try:
		os.system("sudo systemctl status check-scanner-autossh.service > /tmp/autossh.log")
	except:
		return "ERROR: Cannot get check-scanner-autossh.service status"
	
	# Open the temporary created status file
	try:
		autossh_log = open(r"/tmp/autossh.log", "r")
	except:
		return "ERROR: Failed to open check-scanner-autossh.service status log"
	
	# Read the status file
	lines = autossh_log.readlines()
	autossh_log.close()
	
	# Remove the status file
	try:
		os.remove("/tmp/autossh.log")
	except:
		pass
	
	# Check the file for active/running status
	active = False
	for line in lines:
		if "active (running) since" in line:
			active = True
			break
		
	if active == False:
		return "ERROR: check-scanner-autossh.service is not running"
	
	
	return "All validation checks passsed" # Validation success

if __name__ == '__main__':
	main()
