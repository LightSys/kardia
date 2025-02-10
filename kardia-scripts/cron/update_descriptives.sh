#!/bin/bash
#
# Update donor descriptives in Kardia
#
# Greg Beeley / LightSys - 13-Sep-2018
#

# Load bashrc
. ~/.bashrc

# Make sure /usr/local binaries are in the $PATH
export PATH=$PATH:/usr/local/sbin:/usr/local/bin

# optional fund and donor
FUND="$1"
DONOR="$2"

if [ "$FUND" != "" ]; then
    FUND="&fund=$FUND"
fi
if [ "$DONOR" != "" ]; then
    DONOR="&donor=$DONOR"
fi

/usr/local/bin/test_obj -q -c /usr/local/etc/centrallix.conf -u kardia -p $(cat /usr/local/etc/centrallix/kardia-auth) -C "csv select * from /apps/kardia/modules/rcpt/update_descriptives_new.qy?lookback=240${FUND}${DONOR}" 

