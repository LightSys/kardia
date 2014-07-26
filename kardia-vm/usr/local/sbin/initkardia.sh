#!/bin/bash
#
# For Centos 7
#
# This routine will prep a Kardia VM so it is ready to be
# zipped up and duplicated.

#########
## YUM ##
function cleanYum
{
	echo "Cleaning YUM"
	yum clean all
	echo
}

function setupEtc
{
	mkdir -p /etc/samba /etc/pam-script
	files="issue.kardia issue.kardia-init pam.d/system-auth.kardia samba/smb.conf.noshares samba/smb.conf.onerepo samba/smb.conf.userrepo ssh/sshd_config.kardia pam-script/pam_script_passwd pam.d/system-auth.kardia"
	directory="/usr/local/src/kardia-git/kardia-vm/etc/"
	echo "Settting Up the ETC directory"
	for file in $files; do
	    if [  ! -e "/etc/$file" ]; then
		echo -n "$file dne "
		if [ -e "$directory$file" ]; then
		    echo "copying from $directory"
		    cp "$directory$file" /etc/$file
		else
		    echo "not in $directory.  Left undone"
		fi
	    fi
	done
	if [ -e /etc/issue.kardia-init ]; then
	    cat /etc/issue.kardia-init > /etc/issue
	else
	    echo "ERROR: issue.kardia-init does not exist!"
	    echo "Either run kardia.sh or download the kardia git repo"
	    echo "This VM will not be ready until that file is in place"
	    exit
	fi
	cat /etc/samba/smb.conf.noshares /etc/samba/smb.conf.onerepo > /etc/samba/smb.conf 2> /dev/null
	[ -f /etc/ssh/sshd_config.kardia ] && cat /etc/ssh/sshd_config.kardia > /etc/ssh/sshd_config
	if [ -n "`grep PRELINKING=yes /etc/sysconfig/prelink 2>/dev/null`" ]; then
	    echo Turning off prelinking
	    sed -ri 's/PRELINKING=yes/PRELINKING=no/' /etc/sysconfig/prelink
	fi
	####################
	# Add control groups
	echo "Adding control groups"
	[ -z "`grep kardia_src /etc/group`" ] && groupadd kardia_src
	[ -z "`grep kardia_ssh /etc/group`" ] && groupadd kardia_ssh
	[ -z "`grep kardia_root /etc/group`" ] && groupadd kardia_root
	echo
}

###########
# SELINUX ##################################################
function setupSelinux
{
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
}



###################
### NETWORKING ##########################
# Set the network files to correct values
function cleanNetwork
{
	echo "Cleaning out the MAC addresses from the config file"
	for addrfile in /etc/sysconfig/network-scripts/ifcfg-e*; do
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

		echo "done"
	done
	echo "Cleaning up firewall"
	for a in `firewall-cmd --list-ser`; do 
		if [ $a != "ssh" -a $a != "dhcpv6-client" ]; then 
			echo "  removing service $a"
			firewall-cmd --remove-service $a
			firewall-cmd --perm --remove-service $a
		fi; 
	done
	for a in `firewall-cmd --list-port`; do 
		echo "  removing port $a"
		firewall-cmd --remove-port $a
		firewall-cmd --perm --remove-port $a
	done
	echo
}


###########
# SELINUX ##################################################
#Change the sysconfig file selinux enabled line to "enabled"
function cleanSelinux
{
	echo "Ensuring SELINUX is enabled"
	sed -i -e "s/^SELINUX=.*/SELINUX=enabled/" /etc/sysconfig/selinux
	echo
}

###########
### SSH #######################################################
# Remove the server ssh keys.  They will be regenerated on boot
# also remove the root ssh keys and authorized hosts files
function cleanSSH
{
	echo "Removing ssh keys and ssh info"
	rm -vf /etc/ssh/*key*
	rm -rvf /root/.ssh
	echo
}


###########
## FILES #########################################
# Clean up the contents of history and other files
function cleanFiles
{
    cxfiles="/usr/local/sbin/centrallix /usr/local/sbin/cxpasswd"
    cxlibs="/usr/local/lib/StPar* /usr/local/centrallix/ /usr/local/libCentrallix*"
    cxinc="/usr/local/include/cxlib/"
    cxetc="/etc/init.d/centrallix"
    kardiash="/usr/local/src/.initialized /usr/local/src/.cx* /usr/local/src/.mysqlaccess"
    gitfiles="/usr/local/src/cx-git /usr/local/src/kardia-git"
	echo "Cleaning up Filesystem"
	echo "  Cleaning up history"
	echo "kardia.sh" > /root/.bash_history

	#remove the file that says Kardia has been initialized
	rm /usr/local/src/.initialized 2> /dev/null

	#remove any entries in the udev rules. This file is auto written
	tfile=/etc/udev/rules.d/70-persistent-net.rules
	if [ -e $tfile ]; then
		echo > $tfile
	fi
	echo "  Cleaning up installed Centrallix files"
	chkconfig centrallix off 2>/dev/null
	for file in $cxfiles $cxlibx $cxinc $cxetc $kardiash $gitfiles; do
	    if [ -f "$file" -o -d "$file" ]; then
		echo "    $file"
		rm -rf "$file"
	    fi
	done
	echo "Uninstalling old kernel versions"
	rpm -qa kernel* | grep -v `uname -r` | while read line; do 
	    echo "Removing package: $line"
	    rpm -e $line; 
	done

	echo 
}

######################
###  Kardia Users  #######################################
function cleanUsers
{
	#remove users
	echo "Removing any Kardia Users"
	for USERNAME in $(grep -- '- Kardia:' /etc/passwd | sed 's/^\([^:]*\):[^:]*:\([^:]*\):.*/\1/'); do
		killall -u $USERNAME
		echo "  removing Kardia user $USERNAME"
		userdel -r $USERNAME
		echo "  removing mysql user $USERNAME"
		mysql -e "DROP USER $USERNAME@'localhost';" 2> /dev/null
		mysql -e "DROP USER $USERNAME@'%';" 2> /dev/null
	done
	echo "Dropping Kardia_DB"
	mysql -e "DROP DATABASE Kardia_DB;" 2>/dev/null
}

###################
### Empty Space #######################################
# Fill the empty space on the disk for easy compressing 
function cleanEmptySpace
{
	echo "Filling remainder of HD with zeroes.  This takes some time"
	partitions=`df | egrep -v "none|Filesystem|tmpfs" | sed 's/.* //'`
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
}

if [ $# -eq 0 ]; then
	#make sure things are copied over from the repo
	setupEtc
	#clean out yum cache
	cleanYum
	#clean up network settings
	cleanNetwork
	#make sure selinux is enabled
	cleanSelinux
	#wipe ssh keys
	cleanSSH
	#clean up .history files and any extra users
	cleanFiles
	#remove Kardia users
	cleanUsers
	#zero out empty space so it compresses nicely
	cleanEmptySpace
	#
	echo "This VM is prepped to be rolled out"
	echo "Ensure the root password is set to what the PDF says it will be"
else
    command="$1"
    wholecmd="$@"
    if [ "$command" != "" ]; then
	if [ "$(type -t $command)" = "function" ]; then
	    "$wholecmd"
	    exit
	elif [ "$(type -t clean$command)" = "function" ]; then
	    clean"$wholecmd"
	    exit
	elif [ "$(type -t setup$command)" = "function" ]; then
	    setup"$wholecmd"
	    exit
	fi
    fi
fi
