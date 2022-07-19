# LightSys Admin Instructions for Raspberry Pi Check Scanner Router

## OS setup

When the Raspberry Pi first boots up, NOOBS will prompt for an Operating System download. The Raspbian OS from the SD card should be the only option. Install this on the Pi.\
When the OS install finishes, follow the prompts to finish setting up the OS:
1. On the first window, choose the Country, Language, and TimeZone options
2. Leave the second window blank to skip enterring a password
3. Follow the prompt on the next window to fix the black border around screen, if it exists
4. Follow the prompts to connect the Pi to WiFi. This may take a few seconds. Ensure the connection is established before moving on to the nex step
5. Update the system software
6. Reboot

## Configuration script setup

**DO NOT connect a check scanner to the Pi during this setup. It may interfere with the network configuration.**

After the Pi reboots, download admin_setup.py and config_router.py from Github and place them in a folder called "check-scanner-raspi-router" on the Desktop. The full file paths should be:\
`/home/pi/Desktop/check-scanner-raspi-router/admin_setup.py`\
`/home/pi/Desktop/check-scanner-raspi-router/config_router.py`

Open the terminal and run the admin_setup.py script with this command:\
`sudo python3 /home/pi/Desktop/check-scanner-raspi-router/admin_setup.py`

The Pi will reboot if the script runs without errors. When the Pi powers back on, you should see the terminal autostart and display this message:\
`No USB device found. Scanning again in 10 seconds...`

Setup is now complete. You may power off the Pi.