# Raspberry Pi Ethernet-to-WiFi Router for RDM Check Scannners

This software configures a Raspberry Pi 4B to act as a wireless router for the RDM series check scanners. The Pi establishes an AutoSSH connection from the check scanner to a server so that the scanner can be accessed remotely. The configuration settings are loaded via a .config file on a USB drive that is inserted into the Rapsberry Pi.

## Instructions

### 1. Creating the .config file

Download the check_scanner_router.config onto a USB flash drive and open it in a text editor. You should see the following:

`Reconfigure=False`\
`WLANCountry=US`\
`WiFiNetworkSSID=NetworkName`\
`WiFiNetworkPassphrase=network-password`\
`CheckScannerRouterIP=###.###.#.#/##`\
`CheckScannerIPAddress=###.###.#.##`\
`ServerUsername=UserName`\
`ServerPassword=server-password`\
`ServerIP=##.#.###.##`\
`ServerPort=##`\
`ServerPortForCheckScanner=#####`

1. On the Reconfigure line, replace "False" with "True" if you want an already configured Raspberry Pi to repeat setup when the USB drive is inserted
2. On the WLANCountry line, replace "US" with the two-digit country code for your country if it is not the United States
3. On the WiFiNetworkSSID line, replace "NetworkName" with the name of your WiFi network
4. On the WiFiNetworkPassphrase line, replace "network-password" with the password to your WiFi network
5. On the CheckScannerRouterIP line, replace "###.###.#.#/##" with the static IP address you want to assign to the Raspberry Pi's Ethernet interface. Something like "192.168.2.1/24" should work fine
6. On the CheckScannerIPAddress line, replace "###.###.#.##" with the IP address you want the Raspberry Pi DHCP server to assign to the check scanner. Something like "192.168.2.15" should work fine
7. On the ServerUsername line, replace "UserName" with the username of the server profile you want the Pi router to connect to
8. On the ServerPassword line, replace "server-password" with the password to the server profile you want the Pi router to connect to. If you leave the password blank (i.e. `ServerPassword=`), the Pi will copy its SSH RSA public key to the USB device instead of directly to the server
9. On the ServerIP line, replace "##.#.###.##" with the IP address of the server
10. On the ServerPort line, replace "##" with the SSH port of the server (default: 22).  This must be a number between 1 and 65535.
11. On the ServerPortForCheckScanner line, replace "#####" with the port number on the server that you want the check scanner to listen on. This must be a port between 1024 and 65535. It needs to be an unused port; something like "21443" should work fine.

### 2. Hardware Setup

1. Insert the USB drive with the check_scanner_router.config file into one of the USB ports on the Raspberry Pi
2. Connect power to the Raspberry Pi
3. **DO NOT attach the check scanner to the Raspberry Pi yet. This may interfere with the network setup**

### 3. Configuring the Pi

The configuration setup script on the Pi will run automatically when it boots up, using the first available USB flash drive. **In order to ensure your setup is successful, only plug in one USB drive at a time to the Pi.**

When the Raspberry Pi boots up, the LED light will turn on. The LED has 5 different states that show the current operation of the Pi.
1. Off (no light) - the Raspberry Pi is powered off
2. Waiting (Blinking: Long-Long-Long-Long) - the Raspberry Pi is not configured and is waiting for a USB device to be inserted
3. Configuring (Blinking: Long-Short-Long-Short) - the Raspberry Pi is being configured
4. Operating (Solid light, no blinking) - the Raspberry Pi is configured and is operating correctly
5. Error (Blinking: Short-Short-Short-Short) - The Raspberry Pi is configured, but there is an error in the configuration

*Note: If a USB device is not inserted within 2 minutes of the Pi powering on, the Pi will stop scanning for USB drives. Afterward, if the Pi is in a Waiting or Error state, it will immediately shut down. If the Pi is in an Operating state, its function will continue normally.*

Setup can take anywhere from 2 to 30 minutes, depending on your WiFi speed and the number of system updates to perform. At the end of the setup, the Pi will automatically power down, and the LED will turn off. At this point, it is safe to remove the USB drive. Disconnect and reconnect power to the Pi to start it up again.

You can review the setup process via the setup.log file that the Raspberry Pi will generate on the USB flash drive.

*Note: If the LED does not indicate a "Configuring" state upon inserting a USB drive, there is a boot.log file located in the /home/pi/Desktop/check-scanner-raspi-router folder, and it should be copied to the USB device upon insertion. You can check this file as well as setup.log for any errors that may be occuring when trying to begin setup.*

If the setup encounters an error, the setup.log file will end with an error message, and all changes on the Pi will be reverted. Solve any issues with the check_scanner_router.config file indicated by the error message, then reinsert the USB drive to the Pi. Disconnect and reconnect power to restart setup.

If the setup is successful, the setup.log file will end with "SETUP COMPLETE". Upon turning the Pi back on, the LED should indicate an "Operating" state, signified by an unblinking light. Connect the check scanner to the Raspberry Pi via an Ethernet cable and enjoy!
