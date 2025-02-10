#!/bin/bash
#
# Update tag implications in Kardia
#
# Greg Beeley / LightSys - 13-Sep-2018
#

# Load bashrc
. ~/.bashrc

# Make sure /usr/local binaries are in the $PATH
export PATH=$PATH:/usr/local/sbin:/usr/local/bin

/usr/local/bin/test_obj -c /usr/local/etc/centrallix.conf -u kardia -p $(cat /usr/local/etc/centrallix/kardia-auth) -C "ls /apps/kardia/modules/crm/update_tag_implications.qy?" >/dev/null 2>/dev/null

