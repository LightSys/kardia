# Raspberry Pi Ethernet-to-WiFi Router for RDM Check Scannners

This software configures a Raspberry Pi 4B to act as a wireless router for the RDM series check scanners. The Pi establishes an AutoSSH connection from the check scanner to a server so that the scanner can be accessed remotely. The configuration settings are loaded via a .config file on a USB drive that is inserted into the Rapsberry Pi.

## Instructions

### 1. Creating the .config file

Download the check_scanner_router.config onto a USB flash drive and open it in a text editor. You should see the following:

`Reconfigure=True`\
`WLANCountry=US`\
`WiFiNetworkSSID=NetworkName`\
`WiFiNetworkPassphrase=network-password`\
`CheckScannerRouterIP=###.###.#.#/##`\
`CheckScannerIPAddress=###.###.#.##`\
`ServerUsername=UserName`\
`ServerPassword=server-password`\
`ServerIP=##.#.###.##`\
`ServerPortForCheckScanner=#####`

1. On the Reconfigure line, replace True with False if you do not want an already configured Pi to repeat setup when the USB drive is inserted
2. On the WLANCountry line, replace US with the two-digit country code for your country if it is not the United States
3. On the WiFiNetworkSSID line, Replace NetworkName with the name of your WiFi network
4. On the WiFiNetworkPassphrase line, replace network-password with the password to your WiFi network
5. On the CheckScannerRouterIP line, replace ###.###.#.#/## with the static IP address you want the Rasperry Pi DHCP server to use. Something like 192.168.2.1/24 should work fine
6. On the CheckScannerIPAddress line, replace ###.###.#.## with the IP address you want the Raspberry Pi DHCP server to assign to the check scanner. Something like 192.168.2.15 should work fine
7. On the ServerUsername line, replace UserName with the username of the server profile you want the Pi router to connect to
8. On the ServerPassword line, replace server-password with the password to the server profile you want the Pi router to connect to. If you leave the password blank (i.e. `ServerPassword=`), the Pi will copy its SSH RSA public key to the USB device instead of directly to the server
9. On the ServerIP line, replace ##.#.###.## with the IP address of the server
10. On the ServerPortForCheckScanner line, replace ##### with the server port number you want the check scanner to try to connect to. This must be a port between 1024 and 65535, and preferably it should end in 443. Something like 21443 should work fine

### 2. Hardware Setup

1. Insert the USB drive with the check_scanner_router.config file into one of the USB ports on the Raspberry Pi
2. Connect power to the Raspberry Pi
3. **DO NOT attach the check scanner to the Raspberry Pi yet. This may interfere with the network setup**

### 3. Configuring the Pi

The configuration setup script on the Pi will run automatically when it boots up, using the first available USB flash drive. In order to ensure your setup is successful, only plug in one USB drive at a time to the Pi.

*Note: If the setup will not start upon inserting a USB drive, there is a setup.log file located in the /home/pi/Desktop/check-scanner-raspi-router folder. You can check this file for any errors that may be occuring.*

Setup can take anywhere from 2 to 20 minutes. At the end of the setup, the Pi will automatically power down, and the green power light will turn off. At this point, it is safe to remove the USB drive. Disconnect and reconnect power to the Pi to start it up again.

You can review the setup process via the setup.log file that the Raspberry Pi will generate on the USB flash drive.

If the setup was unsuccessful, the .log file will end with an error message. Solve any issues with the .config file indicated by the error message, then reinsert the flash drive to the Pi and disconnect and reconnect power to reboot the Pi.

If the setup was successful, the .log file will end with "SETUP COMPLETE". Connect the check scanner to the Raspberry Pi via an Ethernet cable and enjoy!
