# How to set up a Raspberry Pi as a router for a check scanner
## 1. Set up the Raspberry Pi as an Ethernet-to-Wifi router

Taken from these tutorials:
- https://www.elementzonline.com/blog/sharing-or-bridging-internet-to-ethernet-from-wifi-raspberry-pI
- https://www.youtube.com/watch?v=TtLNue7gzZA

### 1. Configure the WiFi:

Open the terminal and enter:\
`sudo -i`\
This will have you running commands as root on the Pi. **Ensure you are running as root on the Pi for this entire setup process.**

Enter this command:\
`raspi-config`\
In the menu, open Localisation Options/WLAN Country and select your country.\
Exit from the menu and reboot when prompted.

Open the terminal again and enter:\
`sudo -i`\
Open the wpa_supplicant.config file with:\
`nano /etc/wpa_supplicant/wpa_supplicant.conf`\
Add this to the file:\
`network={`\
`ssid=*ex_network_name*` # Replace \*ex_network_name\* with the name of your WiFi network\
`scan_ssid=1`\
`psk=*ex_network_password*` # Replace \*ex_network_password\* with the password for your WiFi network\
`key_mgmt=WPA-PSK`\
`priority=1`\
`}`\
This will cause the Raspberry Pi to automatically connect to the WiFi network on startup.\
Save and close the file.

### 2. Install the dnsmasq package with these commands:
`apt update`\
`apt upgrade` # This command will likely take a long time to complete\
`apt install dnsmasq`

### 3. Set up routing:

Open the DHCP configuration file with:\
`nano /etc/dhcpcd.conf`\
Scroll to the bottom and enter these two lines to set up the subnet:\
`interface eth0`\
`static ip_address=*ex_ip_address*` # Example: 192.168.2.1/24\
Save and close the file.

Rename the old DNS config file and create a new one with these commands:\
`mv /etc/dnsmasq.conf /etc/dnsmasq.conf.old`\
`nano /etc/dnsmasq.conf`\
Enter these two lines in the new file:\
`interface=eth0`\
`dhcp-range=*ex_ip_start*, *ex_ip_end*,*ex_subnet_masq*,*ex_dhcp_reservation_duration*` # Example: dhcp-range=192.168.2.15, 192,168.2.15,255.255.255.0,30d\
***Important Note:** You probably want to make sure you have the same IP address for \*ex_ip_start\* and \*ex_ip_end\* to ensure your check scanner is always assigned the same IP address. Otherwise, you will have to look up the IP address and change your AutoSSH script every time the IP address gets renewed.*\
Save and close the file.

Configure the firewall to forward traffic by opening this file:\
`nano /etc/sysctl.conf`\
Uncomment this line:\
`net.ipv4.ip_forward=1`\
Save and close the file.

Configure the routing tables by opening this file:\
`nano /etc/rc.local`\
Find this line at the bottom of the file:\
`exit 0`\
Add these three lines above `exit 0`:\
`sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE`\
`sudo iptables -A FORWARD -i wlan0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT`\
`sudo iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT`\
Save and close the file.

Finally, reboot the Pi, open the terminal, run as root, and run these commands to start dhcp and dnsmasq:\
`systemctl daemon-reload`\
`service dnsmasq start`\
`service dhcpcd start`

## 2. Set up key authentication for SSH on the Raspberry Pi

This page has useful troubleshooting hints: https://superuser.com/questions/1137438/ssh-key-authentication-fails

### 1. Configure the connection:

**Ensure you are still runnning as root on the Pi.**

First, connect to your server manually using ssh from the Pi with this command:\
`ssh *ex_your_username*@*ex_ip_address*` # Replace \*ex_your_username\* with your username on the server and \*ex_ip_address\* with the IP address of the server you are connecting to.\
This will ensure that the ssh service is set up on your Pi. After signing in to the server, go ahead and close the ssh connection.

Create a new config file on the Pi for SSH connections with this command:\
`nano .ssh/config`\
Enter this in the file:\
`Host *ex_host_title*` # For example, you COULD replace \*ex_host_title\* with the IP address of the server you are connecting to\
`HostName *ex_ip_address*` # You MUST replace \*ex_ip_address\* with the IP address of the server you are connecting to\
`IdentityFile ~/.ssh/id_rsa`\
`User *ex_your_username*` # Replace \*ex_your_username\* with your username on the server\
Save and close the file.

### 2. Generate a new public/private key pair:

Enter this command:\
`ssh-keygen -m pem`\
Hit Enter to save the keys in the default location, then hit Enter twice more to ignore the password prompts.\

Check to ensure the keys were generated with this command:\
`ls .ssh`\
You should see these two files listed:\
`id_rsa` and `id_rsa.pub`

### 3. Copy the public key to the server:

Enter this command:\
`ssh-copy-id *ex_ip_address*` # Replace \*ex_ip_address\* with the IP address of the server you are connecting to\
You will be prompted for your password. Make sure the password prompt is for `*ex_your_username*@*ex_ip_address*`.\
Enter your password. This will copy your public key to the authorized_keys file on the server.

Now establish an SSH connection from the Pi to the server with:\
`ssh *ex_ip_address*`\
The Pi should now connect to the server without a password prompt.

### 4. (Troubleshooting Step) If you are still prompted for your password after the last command: 

Enter your password again to sign in to the server. When you are signed in, open the .ssh folder using:\
`cd .ssh`\
Now enter this command:\
`ls -l`\
The entry for authorized_keys should have the these permissions listed in front of it:\
`-rw-r--r--.`\
If it does not, enter the following command:\
`chmod 644 authorized_keys`\
Use `ls -l` again to make sure `authorized_keys` now has the correct permissions.

Now exit the server and reconnect using SSH. You should not be prompted for a password this time.

## 3. Set up an AutoSSH Tunnel from the Pi to the Server

This article has a lot of useful info: https://www.everythingcli.org/ssh-tunnelling-for-fun-and-profit-autossh/

### 1. Setup AutoSSH and Create a systemd Script:

**Ensure you are still runnning as root on the Pi.**

Install AutoSSH using:\
`apt install autossh`

To ensure it is working properly, connect to your server using:\
`autossh *ex_ip_address*`

Create a new file on the Pi using:\
`nano /etc/systemd/system/check-scanner-autossh.service` (The name of the .service file can be different if you would like)\
In the file, enter this:\
`[Unit]`\
`Wants=network-online.target`\
`After=network-online.target`\
`Description=Check Scanner AutoSSH Tunnel` # The Description can be whatever you want

`[Service]`\
`Type=simple`\
`RemainAfterExit=yes`\
`Environment="AUTOSSH_GATETIME=0"`\
`Environment="AUTOSSH_POLL=60"`\
`ExecStart=/usr/bin/autossh -N -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -R 0:localhost:22 -R *ex_port_number*:192.168.2.15:443 *ex_ip_address* -o "ExitOnForwardFailure yes"` # Replace *ex_port_number* with the server port you want to connect the scanner to (like 20443, 21443, etc.). Replace *ex_ip_address* with the address of your server. You may also need to replace 192.168.2.15 with the IP address of your check scanner if it differs from this 192.168.2.15.\
`Restart=always`\
`RestartSec=60`

`[Install]`\
`WantedBy=multi-user.target`\
Save and close the file.

### 2. Run the systemd AutoSSH Service

Enter these commands to enable the service to start at boot and run the service:\
`systemctl daemon-reload`\
`systemctl enable check-scanner-autossh.service`\
`sytemctl start check-scanner-autossh.service`

Check the status of the service with:\
`systemctl status check-scanner-autossh.service`
The output should look something like this:\
`● check-scanner-autossh.service - Check Scanner AutoSSH Tunnel`\
   `Loaded: loaded (/etc/systemd/system/check-scanner-autossh.service; enabled; vendor preset: enabled)`\
   `Active: active (running) since Wed 2022-06-29 14:50:15 MDT; 4min 5s ago`\
 `Main PID: 459 (autossh)`\
    `Tasks: 2 (limit: 1592)`\
   `CGroup: /system.slice/check-scanner-autossh.service`\
           `├─ 459 /usr/lib/autossh/autossh -N -o ServerAliveInterval 30 -o ServerAliveCountMax 3 -R 0:localhost:22 -R 21443:192.168.2.15:443 10.5.128.92 -o ExitOnForwardFailure yes`\
           `└─1022 /usr/bin/ssh -L 45032:127.0.0.1:45032 -R 45032:127.0.0.1:45033 -N -o ServerAliveInterval 30 -o ServerAliveCountMax 3 -R 0:localhost:22 -R 21443:192.168.2.15:443 -o ExitOnForwardFailure yes 10.5.128.92`

`Jun 29 14:50:25 raspberrypi autossh[459]: ssh child pid is 932`\
`Jun 29 14:50:25 raspberrypi autossh[459]: ssh: connect to host 10.5.128.92 port 22: Network is unreachable`\
`Jun 29 14:50:25 raspberrypi autossh[459]: ssh exited with error status 255; restarting ssh`\
`Jun 29 14:50:32 raspberrypi autossh[459]: starting ssh (count 12)`\
`Jun 29 14:50:32 raspberrypi autossh[459]: ssh child pid is 1022`\
`Jun 29 14:50:32 raspberrypi autossh[459]:     Kardia/Centrallix VM Appliance 1.1  (C) LightSys`\
`Jun 29 14:50:32 raspberrypi autossh[459]:     * Please log in using your user account.`\
`Jun 29 14:50:32 raspberrypi autossh[459]:     * Then run kardia.sh to get started.`\
`Jun 29 14:50:32 raspberrypi autossh[459]:`\
`Jun 29 14:50:32 raspberrypi autossh[459]: Allocated port 36562 for remote forward to localhost:22`

Reboot the Pi, open the terminal, and check the status of check-scanner-autossh.service again. If you see the above output again, then the AutoSSH correctly started during boot.

### 3. (Troubleshooting Step) If AutoSSH is failing on boot:

In the terminal, manually run your AutoSSH command on the ExecStart line of your .service systemd script, i.e.:\
`autossh -N -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -R 0:localhost:22 -R *ex_port_number*:192.168.2.15:443 *ex_ip_address* -o "ExitOnForwardFailure yes"` # Make sure you use the settings you put in your systemd script.\
This command may produce an error like this:\
`Error: remote port forwarding failed for listen port *ex_port_number*`

If this happens, simply try changing your port number to a different version of `xx443`.\
Repeat until you no longer get this error.