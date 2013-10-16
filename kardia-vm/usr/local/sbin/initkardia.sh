#!/bin/bash
#
#
# initkardia.sh - initialize the Kardia/Centrallix VM Image from its
# raw post-CentOS-install state.
#
# This script will prep a Kardia VM so it is ready to be
# zipped up and duplicated.

if [ ! -f /etc/ssh/sshd_config.kardia ]; then
	echo "At least some of the kardia_vm files have not been"
	echo "copied from git to this computer.  Make sure the /etc"
	echo "and /usr files have been copied over from git and"
	echo "are in the /etc/* and /usr/* files. "
	echo ""
	echo "For example, if your git files are in /tmp/kardia-git"
	echo "  # cp -v /tmp/kardia-git/etc/* /etc"
	echo "  # cp -v /tmp/kardia-git/usr/* /usr"
	exit
fi

#########
## YUM ##
echo "Cleaning yum"
yum clean all
echo


###################
### NETWORKING ##########################
# Set the network files to correct values
echo "Cleaning out the MAC addresses from the config file"
for addrfile in /etc/sysconfig/network-scripts/ifcfg-eth*; do
	eth=${addrfile/*ifcfg-/}
	echo Looking at $eth
	echo -n "cleaning up: $addrfile "
	#remove the MAC address line.  The MAC should be regenerated
	#when the VM is cloned.  If this is left here, the VM will
	#not start the interface
	sed -i -e "/HWADDR/d" $addrfile

	#remove the UUID line.  The UUID is like the MAC in that
	#it will be changed when cloned.  If this is left here, the VM will
	#not start the interface
	sed -i -e "/UUID/d" $addrfile

	#Make sure the interface starts on boot
	sed -i -e "s/ONBOOT=.*/ONBOOT=yes/" $addrfile

	#Make sure the VM is set for dhcp
	sed -i -e "s/BOOTPROTO=.*/BOOTPROTO=dhcp/" $addrfile

	#Turn off NetworkManager controlling this interface
	sed -i -e "s/NM_CONTROLLED=.*/NM_CONTROLLED=no/" $addrfile
	echo "done"

	echo "removing $eth from persistent net rules"
	sed -i -e '/eth/d' /etc/udev/rules.d/70-persistent-net.rules
done
echo


###########
# SELINUX ##################################################
#Change the sysconfig file selinux enabled line to "enabled"
echo "Ensuring SELINUX is enabled"
sed -i -e "s/^SELINUX=.*/SELINUX=enabled/" /etc/sysconfig/selinux
# Enable sharing of home directories
echo "Enable sharing of home directories in selinux (long process)"
setsebool -P samba_enable_home_dirs on
echo "Workaround for selinux bug that forbids sharing /usr/local/src"
# Workaround for selinux bug that forbids sharing /usr/local/src
chcon -t usr_t /usr/local/src
echo


###########
### SSH #######################################################
# Remove the server ssh keys.  They will be regenerated on boot
# also remove the root ssh keys and authorized hosts files
echo "Removing ssh keys and ssh info"
rm -vf /etc/ssh/*key*
rm -rvf /root/.ssh
echo

####################
# Add control groups
echo "Adding control groups"
[ -z "`grep kardia_src /etc/group`" ] && groupadd kardia_src
[ -z "`grep kardia_ssh /etc/group`" ] && groupadd kardia_ssh
[ -z "`grep kardia_root /etc/group`" ] && groupadd kardia_root
echo


###########
## FILES #########################################
# Clean up the contents of history and other files
echo "Cleaning up history and stuff"
echo "kardia.sh" > /root/.bash_history

# Install our configuration files
echo "Installing our configuration files"
cat /etc/samba/smb.conf.noshares /etc/samba/smb.conf.onerepo > /etc/samba/smb.conf
[ -f /etc/ssh/sshd_config.kardia ] && cat /etc/ssh/sshd_config.kardia > /etc/ssh/sshd_config
[ -f /etc/sudoers.kardia ] && cat /etc/sudoers.kardia > /etc/sudoers
[ -f /etc/pam.d/system-auth.kardia ] && cat /etc/pam.d/system-auth.kardia > /etc/pam.d/system-auth
[ -f /etc/sysconfig/prelink.kardia ] && cat /etc/sysconfig/prelink.kardia > /etc/sysconfig/prelink
cat /etc/issue.kardia-init > /etc/issue
cat /etc/issue.kardia-init > /etc/issue.net

###############
### Services ###############
# Enable and start services
echo "Turning on important services"
service sshd restart
chkconfig smb on
service smb start
chkconfig mysqld on
service mysqld start

# Create the Kardia_DB mysql database
if [ ! -d /var/lib/mysql/Kardia_DB ]; then
	echo "Creating Database"
	mysql -e "CREATE DATABASE Kardia_DB;"
fi

##############
# updatedb ###
echo "Running updatedb"
updatedb
echo ""

############################################
# Set some basic configuration for root user
[ ! -f /root/.vimrc ] && touch /root/.vimrc
[ -z "`grep ai /root/.vimrc`" ] && echo "set ai" >> /root/.vimrc
[ -z "`grep shiftwidth /root/.vimrc`" ] && echo "set shiftwidth=4" >> /root/.vimrc
[ -z "`grep cino /root/.vimrc`" ] && echo "set cino={1s,:0,t0,f1s" >> /root/.vimrc
[ -z "`grep sts /root/.vimrc`" ] && echo "set sts=4" >> /root/.vimrc
[ ! -f /root/.bashrc ] && touch /root/.bashrc
[ -z "`grep vi= /root/.bashrc`" ] && echo "alias vi=/usr/bin/vim" >> /root/.bashrc



###################
### Empty Space #######################################
# Fill the empty space on the disk for easy compressing 
echo "Filling remainder of HD with zeroes.  This takes some time"
partitions=`df | egrep -v "none|Filesystem|shm" | sed 's/.* //'`
for a in $partitions; do
	echo "partition $a"
	file="$a/zerofile"
	if [ -f $file ]; then
		echo "Oops.  $file already exists. Delete it or something"
	else
		echo -n "Wait... filling in $file with zeros "
		dd if=/dev/zero of=$file bs=1024 2>/dev/null
		echo -n "done - Deleting $file "
		rm -f $file
		echo "deleted"
	fi
done
echo "This VM should now compress very nicely"
