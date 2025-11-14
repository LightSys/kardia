#!/bin/bash
#
# Update duplicates scan
#
# Greg Beeley / LightSys - 12-May-2022
#
#NAME duplicates
#HOUR 3
#MINUTE 0

# Load bashrc
. ~/.bashrc

# Make sure /usr/local binaries are in the $PATH
export PATH=$PATH:/usr/local/sbin:/usr/local/bin

# TODO: Greg - We need to update this cron to call the new file.
/usr/local/bin/test_obj -c /usr/local/etc/centrallix.conf -u kardia -p $(cat /usr/local/etc/centrallix/kardia-auth) -q -C 'ls /apps/kardia/modules/base/update_duplicates.qy' 2>/dev/null >/dev/null
