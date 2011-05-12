#!/bin/bash
#
# initkardia.sh - initialize the Kardia/Centrallix VM Image from its
# raw post-CentOS-install state.
#

# Add control groups
groupadd kardia_src
groupadd kardia_ssh
groupadd kardia_root

# Enable sharing of home directories
setsebool -P samba_enable_home_dirs on

# Workaround for selinux bug that forbids sharing /usr/local/src
chcon -t usr_t /usr/local/src

# Install our configuration files
cat /etc/samba/smb.conf.noshares /etc/samba/smb.conf.onerepo > /etc/samba/smb.conf
[ -f /etc/ssh/sshd_config.kardia ] && cat /etc/ssh/sshd_config.kardia > /etc/ssh/sshd_config
[ -f /etc/sudoers.kardia ] && cat /etc/sudoers.kardia > /etc/sudoers
[ -f /etc/pam.d/system-auth.kardia ] && cat /etc/pam.d/system-auth.kardia > /etc/pam.d/system-auth
[ -f /etc/sysconfig/prelink.kardia ] && cat /etc/sysconfig/prelink.kardia > /etc/sysconfig/prelink
cat /etc/issue.kardia-init > /etc/issue
cat /etc/issue.kardia-init > /etc/issue.net

# Enable and start services
service sshd restart
chkconfig smb on
service smb start
chkconfig mysqld on
service mysqld start

# Create the Kardia_DB mysql database
mysql -e "CREATE DATABASE Kardia_DB;"

# Set some basic configuration for root user
echo "set ai
set shiftwidth=4
set cino={1s,:0,t0,f1s
set sts=4" >> /root/.vimrc
echo "alias vi=/usr/bin/vim" >> /root/.bashrc

# Remove SSH host keys, to force them to be re-generated at each Kardia VM
# installation.
/bin/rm -f /etc/ssh/*host*

# Bring up the eth0 network interface (alas, if this script is on the VM, then
# eth0 is probably already configured properly...)
ETH0=/etc/sysconfig/network-scripts/ifcfg-eth0
HASONBOOT=$(grep '^ONBOOT=' $ETH0)
if [ "$HASONBOOT" != "" ]; then
    sed 's/^ONBOOT=.*$/ONBOOT=yes/' < $ETH0 > $ETH0.new
    /bin/mv -f $ETH0.new $ETH0
else
    echo "ONBOOT=yes" >> $ETH0
fi
HASBOOTPROTO=$(grep '^BOOTPROTO=' $ETH0)
if [ "$HASBOOTPROTO" != "" ]; then
    sed 's/^BOOTPROTO=.*$/BOOTPROTO=dhcp/' < $ETH0 > $ETH0.new
    /bin/mv -f $ETH0.new $ETH0
else
    echo "BOOTPROTO=dhcp" >> $ETH0
fi
ifup eth0
