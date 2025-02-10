#!/bin/bash
#
# Pull gift import data in Kardia
#
# Greg Beeley / LightSys - 09-Sep-2019
#

# Load bashrc
. ~/.bashrc

# Make sure /usr/local binaries are in the $PATH
export PATH=$PATH:/usr/local/sbin:/usr/local/bin

/usr/local/bin/test_obj -c /usr/local/etc/centrallix.conf -u kardia -p $(cat /usr/local/etc/centrallix/kardia-auth) -C 'ls /apps/kardia/modules/rcpt/update_gift_import.qy?' 2>/dev/null >/dev/null

