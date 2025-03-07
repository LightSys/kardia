#!/bin/bash
#
# kardia.sh - manage the Kardia / Centrallix VM appliance
# version: 1.0.11
# os: rocky_8

# Some housekeeping stuff.  We may be running under a user account, but
# called by the superuser.  Don't give the user account too much control.
# Main vulnerability here is that the TTY has to be writable by the user
# being switched to, in order for 'screen' to behave itself (bad screen!).
# The countermeasures below are certainly incomplete.
#
# To change this behavior (makes things a little more secure), change the
# FIX_SCREEN_DRAINBAMAGE variable below to no instead of yes, but be
# forewarned, it will break entering a user screen from root.
#
\builtin unalias -a
\builtin export PATH=/usr/lib/ccache:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
\builtin export LD_LIBRARY_PATH=

FIX_SCREEN_DRAINBAMAGE=yes

#CX_GITREPO="git.code.sf.net/p/centrallix/git"
#K_GITREPO="git.code.sf.net/p/kardia/git"
CX_GITREPO="github.com/LightSys/centrallix"
K_GITREPO="github.com/LightSys/kardia"
CKR_GITREPO="https://bitbucket.org/disciplemakers/check-reader.git"

CKR_FROMPIP="pyftpdlib"

# We need to set the umask to 002, so that we give write permission to
# the kardia_src group for the shared repository.  This could be made
# specific to just operations that touch the shared repository, but that
# adds complexity to the code and doesn't really increase security since
# user home dirs are already mode 0700 so other users can't even traverse
# the home dir itself to get at possibly group-writable files inside.
#
\builtin umask 002


# We have the SourceForge.net SSH Git host keys here so that users don't
# have to say 'yes' to the prompt - they are pre-installed.  No longer used
# since we have switched to github.
#
CX_KEY="git.code.sf.net ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAoMesJ60dow5VqNsIqIQMBNmSYz6txSC5YSUXzPNWV4VIWTWdqbQoQuIu+oYGhBMoeaSWWCiVIDTwFDzQXrq8CwmyxWp+2TTuscKiOw830N2ycIVmm3ha0x6VpRGm37yo+z+bkQS3m/sE7bkfTU72GbeKufFHSv1VLnVy9nmJKFOraeKSHP/kjmatj9aC7Q2n8QzFWWjzMxVGg79TUs7sjm5KrtytbxfbLbKtrkn8OXsRy1ib9hKgOwg+8cRjwKbSXVrNw/HM+MJJWp9fHv2yzWmL8B6fKoskslA0EjNxa6d76gvIxwti89/8Y6xlhR0u65u1AiHTX9Q4BVsXcBZUDw=="
K_KEY="kardia.git.sourceforge.net ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAoMesJ60dow5VqNsIqIQMBNmSYz6txSC5YSUXzPNWV4VIWTWdqbQoQuIu+oYGhBMoeaSWWCiVIDTwFDzQXrq8CwmyxWp+2TTuscKiOw830N2ycIVmm3ha0x6VpRGm37yo+z+bkQS3m/sE7bkfTU72GbeKufFHSv1VLnVy9nmJKFOraeKSHP/kjmatj9aC7Q2n8QzFWWjzMxVGg79TUs7sjm5KrtytbxfbLbKtrkn8OXsRy1ib9hKgOwg+8cRjwKbSXVrNw/HM+MJJWp9fHv2yzWmL8B6fKoskslA0EjNxa6d76gvIxwti89/8Y6xlhR0u65u1AiHTX9Q4BVsXcBZUDw=="

# Detect whether firewalld is enabled or not.  If the installation is not
# using firewalld, then firewalling must be done entirely manually instead
# of by this script.
#
USE_FIREWALLD=$(systemctl list-unit-files | sed -n 's/^firewalld.service[      ]*//p' | sed 's/\s//g')

# Boolean detectors
function isYes
    {
    local YESNO="$1"
    YESNO="${YESNO,,}"
    if [ "$YESNO" = "yes" -o "$YESNO" = "y" -o "$YESNO" = "1" -o "$YESNO" = "true" -o "$YESNO" = "on" ]; then
	return 0
    else
	return 1
    fi
    }

function isNo
    {
    local YESNO="$1"
    YESNO="${YESNO,,}"
    if [ "$YESNO" = "no" -o "$YESNO" = "n" -o "$YESNO" = "0" -o "$YESNO" = "false" -o "$YESNO" = "off" -o "$YESNO" = "" ]; then
	return 0
    else
	return 1
    fi
    }

# Are we root?
function Root
    {
    CURUSER=$(/usr/bin/id -un)
    if [ "$CURUSER" == "root" ]; then
	return 0 # success
    else
	return 1 # fail
    fi
    }

function Connected
    {
    #target=$(echo $CX_KEY | sed 's/ .*//')
    target=$( echo $CX_GITREPO | sed 's/\/.*//')
    echo -n "Checking for Internet connectivity to $target: "
    if ping -c1 $target >/dev/null 2>/dev/null; then
	echo Yes
	CONNECTED=TRUE
	return 0 #success
    else
	echo No
	CONNECTED=
	return 1 #failure
    fi
    }

#append a line to a file if that line does not already exist
function insertLine
    {
    if [ $# -lt 2 ]; then
        #We exit the function if we do not have a filename and data
        return
    fi
    filename=$1
    shift
    line="$*"
    if [ -e $filename ]; then
        if grep "^$line$" $filename > /dev/null
        then
            echo found it > /dev/null
        else
            echo "$line" >> $filename
        fi
    else
        #we make a new file with only the one lne in it
        echo "$line" >> $filename
    fi
    }


BASEDIR=/usr/local
USER=$(/usr/bin/id -un)
VERSION="1.5"
YEAR=$(date '+%Y')
sTITLE="Kardia/Centrallix VM Appliance $VERSION (C) 2011-$YEAR LightSys"
Root || TITLE="[$USER]  $sTITLE"
Root && TITLE="** ROOT **  $sTITLE"
export QUICKMODE=no


if Root; then
    #put the centrallix and kardia keys in the root known_hosts file if needed
    if [ ! -f "/root/.ssh/known_hosts" ]; then
	mkdir "/root/.ssh"
	/bin/chmod 700 "/root/.ssh"
	insertLine "/root/.ssh/known_hosts" "$CX_KEY"
	insertLine "/root/.ssh/known_hosts" "$K_KEY"
	/bin/chmod 600 "/root/.ssh/known_hosts"
    fi
    insertLine "/etc/sudoers" "%kardia_root  ALL=(ALL)       ALL"
    echo "
    $sTITLE

    * Please log in using your user account.
    * Then run "kardia.sh" to get started.
    " > /etc/issue.kardia
    echo "
    $sTITLE

    * Please log in as "root"
    * Root password is in the PDF documentation.
    * Then run "kardia.sh" to get started.
    " > /etc/issue.kardia-init

    psp=/usr/local/src/kardia-git/kardia-vm/etc/pam-script/pam_script_passwd
    if [ -f "$psp" ]; then
	psphome=/etc/pam-script/pam_script_passwd
	if [ ! -f "$psphome" ]; then
	    cp "$psp" "$psphome"
	fi
	psphome2=/usr/local/etc/pam-script.d/pam_script_passwd
	if [ ! -f "$psphome2" ]; then
	    ln -s "$psphome" "$psphome" 2>/dev/null
	fi
    fi
fi

# Init stuff
HAS_GRPS=$(grep kardia /etc/group)
if [ "$HAS_GRPS" = "" ]; then
    groupadd kardia_src
    groupadd kardia_ssh
    groupadd kardia_root
    #
    echo "Starting samba"
    systemctl start smb
    echo "Enabling samba at boot"
    systemctl enable smb
    #
    echo "Starting mariadb"
    systemctl start mariadb
    echo "Enabling mariadb at boot"
    systemctl enable mariadb
    #
    mysql -e "CREATE DATABASE Kardia_DB;"
    #
    if rpm -q chrony >/dev/null ; then
	echo "Starting chronyd"
	systemctl start chronyd
	echo "Enabling chronyd at boot"
	systemctl enable chronyd
    fi
    #
    updateVimrc /root/.vimrc
    #done by updateVimrc above
    #insertLine /root/.vimrc "set ai"
    #insertLine /root/.vimrc "set shiftwidth=4"
    #insertLine /root/.vimrc "set cino={1s,:0,t0,f1s"
    #insertLine /root/.vimrc "set sts=4"
    #

    #do gdbinit
    insertLine /root/.gdbinit "set history save on"
    insertLine /root/.gdbinit "set history size 999"
    insertLine /root/.gdbinit "handle SIGHUP noprint nostop"
    insertLine /root/.gdbinit "handle SIG33 noprint nostop"

    insertLine /root/.bashrc "alias vi=/usr/bin/vim"
    setsebool -P samba_enable_home_dirs on
fi


# Can be root?
function Rootable
    {
    USER=$(/usr/bin/id -un)
    if [ "$USER" = root ]; then
	return 0
    fi
    GRPS=$(groups "$USER" | grep ':.* kardia_root')
    if [ "$GRPS" != "" ]; then
	return 0
    fi
    return 1
    }


# Run as root...
function AsRoot
    {
    # User can't become root?
    Rootable || echo "You can't do that.  Sorry!"
    Rootable || return 1

    # If already root, just run the command.  Otherwise, use sudo.
    USER=$(/usr/bin/id -un)
    if [ "$USER" = root ]; then
	"$@"
    else
	echo "Switching to root..."
	sleep 0.4
	if [ "$1" != "" ]; then
	    if [ $(type -t "$1") = "function" ]; then
		/usr/bin/sudo /usr/local/bin/kardia.sh "$@"
	    else
		/usr/bin/sudo "$@"
	    fi
	else
	    /usr/bin/sudo "$@"
	fi
    fi
    }

#determine what OS we have
function GetOSInfo
    {
    #This function is based on multiple sources, but seems to have
    #originated with something Novel once used. Scripts using some
    #of this base code can be found all over the Internet.
    OS=`uname -s`
    REV=`uname -r`
    export OSSTR="Linux" #a default if we cannot figure it out

    if [ "${OS}" = "SunOS" ] ; then
	OS="Solaris"
	OSSTR="${OS} ${REV}"
    elif [ "${OS}" = "AIX" ] ; then
	OSSTR="${OS} `oslevel`"
    elif [ "${OS}" = "Linux" ] ; then
	if [ -f /etc/os-release ] ; then
	    DIST=`cat /etc/os-release | grep "^NAME=" | sed 's/.*=//;s/ .*//'`
	    REV=`cat /etc/os-release | grep VERSION_ID | sed 's/.*=//;s/ .*//'`
	elif [ -f /etc/redhat-release ] ; then
	    DIST=`cat /etc/redhat-release | sed 's/ .*//'`
	    REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
	elif [ -f /etc/SuSE-release ] ; then
	    DIST=`cat /etc/SuSE-release | tr "\n" ' '| sed s/VERSION.*//`
	    REV=`cat /etc/SuSE-release | tr "\n" ' ' | sed s/.*=\ //`
	elif [ -f /etc/mandrake-release ] ; then
	    DIST='Mandrake'
	    REV=`cat /etc/mandrake-release | sed s/.*release\ // | sed s/\ .*//`
	elif [ -f /etc/debian_version ] ; then
	    DIST="Debian `cat /etc/debian_version`"
	    REV=""
	fi
	if [ -f /etc/UnitedLinux-release ] ; then
	    DIST="${DIST}[`cat /etc/UnitedLinux-release | tr "\n" ' ' | sed s/VERSION.*//`]"
	fi
	OSSTR=$(echo "${DIST} ${REV}" | sed 's/\"//g' | tr '[:upper:]' '[:lower:]')
    fi
    }

#Update the Kardia.sh program and run any auto-update scripts we need to run
#
function UpdateMenus
    {
    whereToReturn="$@"
    lookupStatus
    GetOSInfo
    os_string=$(echo $OSSTR | sed 's/ /_/g')
    echo
    echo "Updating the kardia.sh menu system to the latest version in git."

    if [ -d "$BASEDIR/src/kardia-git/kardia-vm" ]; then
	if [ "$WKFMODE" = "individual" ]; then
	    # In 'individual' workflow.  Update the shared repo regardless
	    # of 'Source' update setting.
	    repoPull "$BASEDIR/src/kardia-git"
	fi
	#We want to use an OS Specific kardia.sh if it exists
	filename="$BASEDIR/src/kardia-git/kardia-vm/usr/local/bin/kardia.sh"
	if [ -f "$BASEDIR/src/kardia-git/kardia-vm/usr/local/bin/kardia-${os_string}.sh" ]; then
	    filename="$BASEDIR/src/kardia-git/kardia-vm/usr/local/bin/kardia-${os_string}.sh"
	fi
	#see what we have now & compare to what we have
	this_fn="/usr/local/bin/kardia.sh"
	if [ -f "$filename" ]; then
	    kardiavm_version=$(head $filename | grep version | sed 's/.*://;s/ //g')
	    this_version=$(head $this_fn | grep version | sed 's/.*://;s/ //g')
	    this_os=$(head $this_fn | grep os | sed 's/.*://;s/ //g')
	    todo=0
	    echo "  Installed=$this_version"
	    echo "  Latest=$kardiavm_version"
	    [ "$this_version" != "$kardiavm_version" ] && todo=1
	    [ "$this_os" != $os_string ] && todo=1
	    if [ "$todo" = "1" ]; then
		/bin/mv -f /usr/local/bin/kardia.sh /usr/local/bin/kardia.sh.old
		/bin/cp "$filename" /usr/local/bin/kardia.sh
		chmod 755 /usr/local/bin/kardia.sh
		chown root:root /usr/local/bin/kardia.sh
		if [ -d "$BASEDIR/src/kardia-git/kardia-vm/usr/local/sbin/$os_string" ]; then
		(
		cd "$BASEDIR/src/kardia-git/kardia-vm/usr/local/sbin/$os_string"
		    for UPFILE in ./vmupgrade*.sh; do
			if [ ! -f /usr/local/sbin/"$UPFILE" ]; then
			    if [ -f "$UPFILE" ]; then
				/bin/cp "$UPFILE" /usr/local/sbin/"$UPFILE"
				chmod 755 "$UPFILE"
				chown root:root "$UPFILE"
				/usr/local/sbin/"$UPFILE"
			    fi
			fi
		    done
		    ) 2> /dev/null #the above gives errors if no vmupgrade files exist
		fi
		echo "Successfully updated menu system.  Press [ENTER] to continue..."
		read ANS
		exec /usr/local/bin/kardia.sh $whereToReturn
	    else
		echo "Menus are already up to date.  Press [ENTER] to continue..."
		read ANS
	    fi
	else
	    echo "Failed to update shared repository.  Cannot update menus."
	    echo "Press [ENTER] to continue."
	    read ANS
	fi
    else
	echo "Shared repository does not exist.  Cannot update menus."
	echo "Press [ENTER] to continue."
	read ANS
    fi
    }

# Run a Git command, but also print the command on the screen so that the
# user has a chance to learn Git commands.
function doGit
    {
    echo "Running: git $*"
    git "$@"
    sleep 0.3
    }


# Update the RHEL5 lokkit firewall
function updateFirewall
    {
    if [ "$USE_FIREWALLD" = "enabled" ]; then
	#Centrallix main port
	echo "Opening port for Centrallix"
	firewall-cmd --add-port 800/tcp
	firewall-cmd --perm --add-port 800/tcp
	firewall-cmd --add-port 843/tcp
	firewall-cmd --perm --add-port 843/tcp

	#samba
	echo "Opening port for Samba"
	firewall-cmd --add-service samba
	firewall-cmd --perm --add-service samba

	for USERID in $(grep -- '- Kardia:' /etc/passwd | sed 's/^[^:]*:[^:]*:\([^:]*\):.*/\1/'); do
	    PORT=$((8000 + $USERID))
	    echo "Opening user port $PORT"
	    firewall-cmd --add-port $PORT/tcp
	    firewall-cmd --perm --add-port $PORT/tcp
	    PORT=$((18000 + $USERID))
	    echo "Opening user SSL port $PORT"
	    firewall-cmd --add-port $PORT/tcp
	    firewall-cmd --perm --add-port $PORT/tcp
	done

	sleep 0.5
    fi
    }

function genCertificate
    {
    lookupStatus
    cd $CXETC
    #Generate a passphrase
    export PASSPHRASE=$(head -c 500 /dev/urandom | tr -dc a-z0-9A-Z | head -c 60; echo)
    # Certificate details; replace items in angle brackets with your own info
    subj="
    C=LS
    ST=LightSys
    O=LightSys
    localityName=LightSys
    commonName=$IPADDR
    organizationalUnitName=
    emailAddress=root@$HOST
    "
    echo "generating the private key"
    # Generate the server private key
    openssl genrsa -des3 -out centrallix.key -passout env:PASSPHRASE 2048
     
    echo "generating the CSR"
    # Generate the CSR
    openssl req \
    -new \
    -batch \
    -subj "$(echo -n "$subj" | tr "\n" "/" | sed 's/ *//g')" \
    -key centrallix.key \
    -out centrallix.csr \
    -passin env:PASSPHRASE
    cp centrallix.key centrallix.key.org

    echo "Stripping the password"
    # Strip the password so we don't have to type it every time we restart Apache
    openssl rsa -in centrallix.key.org -out centrallix.key -passin env:PASSPHRASE

    echo "Generating the cert" 
    # Generate the cert (good for 10 years)
    openssl x509 -req -days 3650 -in centrallix.csr -signkey centrallix.key -out centrallix.crt
    }

function checkCert
    {
    lookupStatus
    todo=0
    certfile=$CXETC/centrallix.crt
    keyfile=$CXETC/centrallix.key
    sed -i'' "s#ssl_key =.*#ssl_key = \"$keyfile\";#;s#ssl_cert =.*#ssl_cert = \"$certfile\";#" $CXCONF
    if [ ! -d $CXETC ]; then
	mkdir -p $CXETC
    fi
    if [ ! -f $keyfile ]; then
	echo "No SSL key found. Generating one"
	todo=1
    elif [ ! -f $certfile ]; then
	echo "No SSL certificate found. Generating one"
	todo=1
    else
	certip=$(openssl x509 -in $certfile -subject -noout | sed 's/.*CN=\([^\/]*\).*/\1/')
	#if we have a valid IP address, make sure it is our IP
	if [[ $certip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
	    if [ "$certip" != "$IPADDR" ]; then
		echo "SSL Certificate IP mismatch.  re-generating certificate"
		todo=1
	    fi
	else
	    echo "There is a certificate with a CN of something other than an IP."
	    echo "We are assuming it is a valid FQDN and are going to leave it alone."
	fi
    fi
    if [ "$todo" = "1" ]; then
	genCertificate
    fi
    }


#This should update the contents of the vimrc file.
#It should be called with: updateVimrc [filename]
function updateVimrc
    {
    local N_FILE="$1"
    if [ -f "$N_FILE" ]; then
	#insert some basic items
	insertLine $N_FILE "set ai"
	insertLine $N_FILE "set shiftwidth=4"
	insertLine $N_FILE "set cino={1s,:0,t0,f1s"
	insertLine $N_FILE "set sts=4"

	#now, insert the contents of cx-git/centrallix-dev-tools/.vimrc 
	if [ -f  $CXSRC/centrallix-dev-tools/.vimrc ]; then
	    cat $CXSRC/centrallix-dev-tools/.vimrc |sed 's/vim70/vim??/' | while read line; do
		insertLine "$N_FILE" "$line"
	    done
	fi
    fi
    }


#
# Add a new user:  addUser username realname [nopass|pass] [uid] [gid]
#
function addUser
    {
    local N_USER="$1"
    local N_REALNAME="$2"
    local NOPASS="$3"
    local USE_UID="$4"
    local USE_GID="$5"
    local NEWPASS="newuserpass"
    if [ -f /usr/local/src/kardia-git/kardia-app/data/Kardia_DB ]; then
	# Try to get default password from local configuration
	NEWPASS=$(sed -n 's/.*default_password = "\([^"]*\)";.*/\1/p' < /usr/local/src/kardia-git/kardia-app/data/Kardia_DB)
    fi
    EXISTS=$(grep "^$N_USER:" /etc/passwd)
    if [ "$EXISTS" != "" ]; then
	echo "User already exists."
	sleep 1
	return 1
    fi
    echo "useradd"
    if [ "$USE_UID" != "" ]; then
	if [ "$USE_GID" != "" ]; then
	    /usr/sbin/groupadd -g "$USE_GID" "$N_USER"
	    /usr/sbin/useradd -c "$N_REALNAME - Kardia" -u "$USE_UID" -g "$USE_GID" "$N_USER"
	else
	    /usr/sbin/useradd -c "$N_REALNAME - Kardia" -u "$USE_UID" "$N_USER"
	fi
    else
	/usr/sbin/useradd -c "$N_REALNAME - Kardia" "$N_USER"
    fi
    echo "smbpasswd"
    smbpasswd -a -n "$N_USER"
    echo "smbpasswd done"
    if [ ! -f "/home/$N_USER/.ssh/known_hosts" ]; then
	mkdir "/home/$N_USER/.ssh"
	/bin/chown "$N_USER": "/home/$N_USER/.ssh"
	/bin/chmod 700 "/home/$N_USER/.ssh"
	touch "/home/$N_USER/.ssh/known_hosts"
	/bin/chown "$N_USER": "/home/$N_USER/.ssh/known_hosts"
	/bin/chmod 600 "/home/$N_USER/.ssh/known_hosts"
    fi

    insertLine "/home/$N_USER/.ssh/known_hosts" "$CX_KEY"
    insertLine "/home/$N_USER/.ssh/known_hosts" "$K_KEY"
    echo ""
    echo "Setting an initial database password for $N_USER..."
    echo ""
    mysql -e "CREATE USER '$N_USER'@'%' IDENTIFIED BY '$NEWPASS';"
    mysql -e "CREATE USER '$N_USER'@'localhost' IDENTIFIED BY '$NEWPASS';"
    mysql -e "GRANT ALL ON Kardia_DB.* TO '$N_USER'@'%';"
    mysql -e "GRANT ALL ON Kardia_DB.* TO '$N_USER'@'localhost';"
    mysql -e "GRANT SELECT ON mysql.user TO '$N_USER'@'%';"
    mysql -e "GRANT SELECT ON mysql.user TO '$N_USER'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"

    if [ "$NOPASS" != "nopass" ]; then
	echo "Prompting for password..."
	/usr/bin/passwd "$N_USER" < /dev/tty
    fi

    updateFirewall

    updateVimrc /home/$N_USER/.vimrc
    #done by updateVimrc above
    #insertLine /home/$N_USER/.vimrc "set ai"
    #insertLine /home/$N_USER/.vimrc "set shiftwidth=4"
    #insertLine /home/$N_USER/.vimrc "set cino={1s,:0,t0,f1s"
    #insertLine /home/$N_USER/.vimrc "set sts=4"

    #do gdbinit
    insertLine /home/$N_USER/.gdbinit "set history save on"
    insertLine /home/$N_USER/.gdbinit "set history size 999"
    insertLine /home/$N_USER/.gdbinit "handle SIGHUP noprint nostop"
    insertLine /home/$N_USER/.gdbinit "handle SIG33 noprint nostop"

    insertLine /home/$N_USER/.bashrc "alias vi=/usr/bin/vim"

    mkdir -p "/home/$N_USER/cxinst/etc/centrallix" 2>/dev/null
    sed -n "s/^\($N_USER:[^:]*\):.*/\1/p" < /etc/shadow > "/home/$N_USER/cxinst/etc/centrallix/cxpasswd"
    chown -R "$N_USER": "/home/$N_USER/cxinst/"
    }

#
# modifyUser username realname
#
function modifyUser
    {
    local N_USER="$1"
    local N_REALNAME="$2"
    /usr/sbin/usermod -c "$N_REALNAME - Kardia" "$N_USER"
    }

#
# updateUserPerms username allowssh allowsrc allowroot allowkardiaadmin
#
function updateUserPerms
    {
    local N_USER="$1"
    local N_ALLOW_SSH="$2"
    local N_ALLOW_SRC="$3"
    local N_ALLOW_ROOT="$4"
    local N_ALLOW_KARDIA_SYSADM="$5"

    local GRPS=$(groups "$N_USER" | sed "s/$N_USER : $N_USER *//" | sed 's/kardia_[a-z]*//g' | sed 's/  */ /g' | sed 's/^ //' | sed 's/ $//' | sed 's/ /,/g')

    if [ "$N_ALLOW_SSH" != "$ALLOW_SSH" -o "$N_ALLOW_SRC" != "$ALLOW_SRC" -o "$N_ALLOW_ROOT" != "$ALLOW_ROOT" ]; then
	if [ "$N_ALLOW_SSH" = yes ]; then
	    GRPS="$GRPS,kardia_ssh"
	fi
	if [ "$N_ALLOW_SRC" = yes ]; then
	    GRPS="$GRPS,kardia_src"
	fi
	if [ "$N_ALLOW_ROOT" = yes ]; then
	    GRPS="$GRPS,kardia_root"
	fi
	GRPS="${GRPS##,}"
	/usr/sbin/usermod -G "$GRPS" "$N_USER"
    fi
    if [ "$N_ALLOW_KARDIA_SYSADM" != "no" ]; then
	#Add this user to the file and then give them the privs
	AsRoot sed -i -e "/$N_USER/d" $BASEDIR/src/.cx_kardia_admins 2> /dev/null
	AsRoot echo $N_USER >> $BASEDIR/src/.cx_kardia_admins
	doGiveUserKardiaSysadmin $N_USER
    else
	#make sure we do not have this username in the file
	if [ -f "$BASEDIR/src/.cx_kardia_admins" ]; then
	    AsRoot sed -i -e "/$N_USER/d" $BASEDIR/src/.cx_kardia_admins
	    doRemoveUserKardiaSysadmin $N_USER
	fi
    fi
    }

# Manage or add a user
function manageUser
    {
    local USER="$2"
    local REALNAME=$(sed -n "s/^$USER:[^:]*:[^:]*:[^:]*:\([^:]*\) - Kardia:.*/\1/p" < /etc/passwd)
    if [ "$1" = "existing" ]; then
        local ALLOW_KARDIA_SYSADM=$(grep "$USER" $BASEDIR/src/.cx_kardia_admins 2>/dev/null)
	if [ "$ALLOW_KARDIA_SYSADM" = "" ]; then
	    local ALLOW_KARDIA_SYSADM=no
	else
	    local ALLOW_KARDIA_SYSADM=yes
	fi
	local ALLOW_SSH=$(groups "$USER" | grep ':.* kardia_ssh')
	if [ "$ALLOW_SSH" = "" ]; then
	    ALLOW_SSH=no
	else
	    ALLOW_SSH=yes
	fi
	local ALLOW_SRC=$(groups "$USER" | grep ':.* kardia_src')
	if [ "$ALLOW_SRC" = "" ]; then
	    ALLOW_SRC=no
	else
	    ALLOW_SRC=yes
	fi
	local ALLOW_ROOT=$(groups "$USER" | grep ':.* kardia_root')
	if [ "$ALLOW_ROOT" = "" ]; then
	    ALLOW_ROOT=no
	else
	    ALLOW_ROOT=yes
	fi
    else
        local ALLOW_KARDIA_SYSADM=no
	local ALLOW_SRC=no
	local ALLOW_SSH=no
	local ALLOW_ROOT=no
    fi
    DSTR="dialog --title 'Add/Modify User' --backtitle '$TITLE' --form"
    if [ "$1" = "new" ]; then
	DSTR="$DSTR 'Add New User'"
	DSTR="$DSTR 0 0 0"
	DSTR="$DSTR 'Login:' 1 1 '$USER' 1 36 20 0"
    else
	DSTR="$DSTR 'Modify User $USER'"
	DSTR="$DSTR 0 0 0"
	DSTR="$DSTR 'Login:' 1 1 '$USER' 1 36 0 0"
    fi
    DSTR="$DSTR 'Real Name:' 3 1 '$REALNAME' 3 36 30 0"
    DSTR="$DSTR 'SSH Access (yes/no):' 5 1 '$ALLOW_SSH' 5 36 5 0"
    DSTR="$DSTR 'Repository Access (yes/no):' 7 1 '$ALLOW_SRC' 7 36 5 0"
    DSTR="$DSTR 'OS System Admin Privs (yes/no):' 9 1 '$ALLOW_ROOT' 9 36 5 0"
    DSTR="$DSTR 'Kardia System Admin Privs (yes/no):' 11 1 '$ALLOW_KARDIA_SYSADM' 11 36 5 0"
    DSTR="$DSTR 'Reset Password Now (yes/no):' 13 1 'no' 13 36 5 0"

    eval "$DSTR" 2>&1 >/dev/tty |
	{
	if [ "$1" = "new" ]; then
	    read N_USER
	else
	    N_USER="$USER"
	fi
	read N_REALNAME; read N_ALLOW_SSH; read N_ALLOW_SRC; read N_ALLOW_ROOT; read N_ALLOW_KARDIA_SYSADM; read N_RESET_PASS;
	if [ "$N_REALNAME" = "" -a "$N_ALLOW_SSH" = "" -a "$N_ALLOW_SRC" = "" -a "$N_ALLOW_ROOT" = "" ]; then
	    return 1
	fi
	if [ "$N_USER" = "kardia_ssh" -o "$N_USER" = "kardia_src" -o "$N_USER" = "kardia_root" ]; then
	    echo "Invalid new user name."
	    sleep 1
	    return 1
	fi
	#Do not allow usernames that contain a colon or semicolon 
	if [ "$( echo "$N_USER" | sed 's/[:;]//' )" != "$N_USER" ]; then 
	    echo Invalid character in username.
	    sleep 1
	    return 1
	fi
	if [ "$1" = "new" ]; then
	    addUser "$N_USER" "$N_REALNAME"
	    # Update /etc/issue to instruct user to no longer log in as root
	    cat /etc/issue.kardia > /etc/issue
	    cat /etc/issue.kardia > /etc/issue.net
	elif [ "$REALNAME" != "$N_REALNAME" ]; then
	    modifyUser "$N_USER" "$N_REALNAME"
	fi

	#Create a .tpl file for the user
	if [ ! -f "$KSRC/kardia-app/tpl/$N_USER.tpl" ]; then
	    #Kardia may not yet be downloaded.  If not, this will fail
	    if [ -f "$KSRC/kardia-app/tpl/newuser_default.tpl" ]; then
		cp "$KSRC/kardia-app/tpl/newuser_default.tpl" "$KSRC/kardia-app/tpl/$N_USER.tpl"
	    fi
	fi 

	updateUserPerms "$N_USER" "$N_ALLOW_SSH" "$N_ALLOW_SRC" "$N_ALLOW_ROOT" "$N_ALLOW_KARDIA_SYSADM"

	if [ "$1" = "existing" -a "$N_RESET_PASS" = yes ]; then
	    echo ""
	    echo "Resetting password for $N_USER..."
	    echo ""
	    /usr/bin/passwd "$N_USER" < /dev/tty

	    # Set password in other places...
	    # GRB - pam_script takes care of this now.
	    #sed -n "s/^\($N_USER:[^:]*\):.*/\1/p" < /etc/shadow > "/home/$N_USER/cxinst/etc/centrallix/cxpasswd"
	    #mysql -e "SET PASSWORD FOR '$N_USER'@'localhost' = PASSWORD('newuserpass');"
	fi
	sleep 1
	}
    }

function doGiveUserKardiaSysadmin
    {
	local TUSER=$1;
	if [ -z "$TUSER" ]; then
	    echo "You must specify a user to give permissions to"
	    return
	fi
	echo "insert into s_sec_endorsement (s_endorsement,s_context, s_subject, s_date_created, s_created_by, s_date_modified, s_modified_by) values ('kardia:sys_admin','kardia','u:THEUSER',curdate(),'THEUSER',curdate(),'THEUSER');" | sed "s/THEUSER/$TUSER/g" | mysql -u root Kardia_DB 2> /dev/null
	[ $? -ne 0 ] && logger -t "doGiveUserKardiaSysadmin" "MySQL failed.  Trying to add permissions for the Kardia user. Probably because the kardia tables are not yet loaded.  Ignore for now."
    }

function doGiveAllSysadmsSysadmin
    {
	if [ -e "$BASEDIR/src/.cx_kardia_admins" ]; then
	    local nUSER=""
	    cat $BASEDIR/src/.cx_kardia_admins | while read nUSER; do
		echo "  Adding permissions for $nUSER"
		doGiveUserKardiaSysadmin $nUSER
	    done
	fi
    }

# Delete a user
function deleteUser
    {
    local USER="$1"
    local REALNAME=$(sed -n "s/^$USER:[^:]*:[^:]*:[^:]*:\([^:]*\) - Kardia:.*/\1/p" < /etc/passwd)
    if [ "$USER" = "root" -o "$REALNAME" = "" -o "$USER" = "" ]; then
	return 1
    fi
    /usr/sbin/userdel "$1"

    updateFirewall
    }


# User management
function menuUsers
    {
    local USER=""
    while true; do
	lookupStatus

	DSTR="dialog --backtitle '$TITLE' --title 'User Management' --ok-label 'Modify' --extra-button --extra-label 'Delete' --cancel-label 'Done' --menu 'Users' 20 72 14"
	OLDIFS="$IFS"
	IFS=:
	while read UXUSER X1 X2 X3 USERNAME X4 X5; do
	    REALNAME=${USERNAME// - Kardia/}
	    if [ "$REALNAME" != "$USERNAME" ]; then
		DSTR="$DSTR '$UXUSER' '$REALNAME'"
	    fi
	done < /etc/passwd
	IFS="$OLDIFS"
	DSTR="$DSTR '---' ''"
	DSTR="$DSTR NewUser 'Add a New User'"
	DSTR="$DSTR Switch 'Switch to User...'"
	DSTR="$DSTR Quit 'Exit Kardia / Centrallix Management'"

	SEL=$(eval "$DSTR" 2>&1 >/dev/tty)
	RVAL=$?
	if [ "$RVAL" = "3" ]; then
	    BUTTON=del
	else
	    BUTTON=edit
	fi
	case "$SEL" in
	    Quit)
		exit
		;;
	    NewUser)
		manageUser new
		;;
	    Switch)
		AsUser /usr/local/bin/kardia.sh
		;;
	    '')
		break
		;;
	    '---')
		;;
	    *)
		if [ "$BUTTON" = "edit" ]; then
		    manageUser existing "$SEL"
		else
		    deleteUser "$SEL"
		fi
		;;
	esac
    done
    #create the kardia user if we need to do that
    doCreateKardiaUnixUser
    return 0 #This fixes an error if the burried mysql-function errors out
    }

#Do partition, lvm and filesystem resize
function doResize
    {
	dialog --backtitle "$TITLE" --title "Resize the VM" --yes-label Resize --no-label Skip --yesno "This option will resize the VM image.  Before running this, you should have powered down the VM, added space to the disk image, and then brought the image back up.  Then, running this resize should increase the disk size.\n\nThe easiest way to add space is by using the truncate command.  In Windows, use the Linux subsystem to get a linux prompt where you can use truncate.  A command like this:\n\n  'truncate +500M KardiaVM.hdd'\n\nWhere KardiaVM.hdd is the drive image you are trying to increase and the 500M is the amount we want to increase it by.  Remember, 500MB is lost to other partitions.  7G will only give your machine 6.5G of space." 0 0
	if [ "$?" = 0 ]; then
	    #Do the resize
	    DRIVE=$(pvdisplay | grep dev | sed 's/.* \//\//')
	    NUMBER=$(echo "$DRIVE" | sed 's/\([^0-9]*\)\([0-9]*\)/\2/')
	    DISK=$(echo "$DRIVE" | sed 's/\([^0-9]*\)\([0-9]*\)/\1/')
	    EXTENDED=$(sfdisk -l $DISK | grep -i extended | sed 's/ .*//' | sed 's/[^0-9]*//')
	    logger -t "Kardia.sh-Resize" "Resizing: Drive=$DRIVE Disk=$DISK Number=$NUMBER EXTENDED=$EXTENDED"
	    if [ -n "$EXTENDED" ]; then
		logger -t "Kardia.sh-Resize" "repartitioning extended partition using sfdisk"
		echo ", +" | sfdisk -N $EXTENDED $DISK --force --no-reread
	    fi
	    logger -t "Kardia.sh-Resize" "repartitioning using sfdisk"
	    echo ", +" | sfdisk -N $NUMBER $DISK --force --no-reread
	    partprobe
	    LV=$(lvdisplay | grep Path | sed 's/[^\/]*//')
	    VG=$(dirname $LV)
	    logger -t "Kardia.sh-Resize" "Resizing Physical Volume: $DRIVE"
	    pvresize $DRIVE
	    logger -t "Kardia.sh-Resize" "resizing Logival Volume: $LV"
	    lvextend -l +100%FREE $LV
	    logger -t "Kardia.sh-Resize" "Growing the filesystem"
	    xfs_growfs $LV 2>/dev/null  #xfs
	    resize2fs $LV  2>/dev/null #ext4

	    echo -n "Done.  Press enter to continue > "
	    read line
	fi
    }

# Do updates (yum update)
function doUpdates
    {
    checkAndInstallRequiredPackages
    echo ""
    echo "Running 'yum update'... this may take a while..."
    echo ""
    yum update --skip-broken
    }

function installExtraPackages
    {
    if [ -f /usr/local/src/kardia-git/kardia-vm/extra_rpms.txt ]; then
	echo "Installing unnecessary packages"
	for a in $( cat /usr/local/src/kardia-git/kardia-vm/extra_rpms.txt | grep -v "^#" ); do
		dnf -y install $a
	done
    fi
    }

# Check to see if the required packages are installed
function checkAndInstallRequiredPackages
    {
	#Go through and check to see if every package in the list is installed
	if [ ! -e /usr/local/src/kardia-git/kardia-vm/rpms_needed.txt ]; then
	    exit 2; #The file we need does not exist.  Cannot check
	fi
	if [ -f /usr/local/src/kardia-git/kardia-vm/extra_rpms.txt ]; then
	    echo "Removing unnecessary packages"
	    for a in $( cat /usr/local/src/kardia-git/kardia-vm/extra_rpms.txt | grep -v "^#" ); do
		    dnf -y remove $a
	    done
	fi
	YUMTMPFILE="$$-YUM.tmp"
	rpm -qa > $YUMTMPFILE
	NOTFOUNDLIST=""

	#Auto add repo stuff
	if [ `which dnf 2> /dev/null` ]; then
	     #install epel
	     dnf -y install epel-release
	     #activate powertools
	     dnf config-manager --set-enabled powertools
	fi

	for a in $( cat /usr/local/src/kardia-git/kardia-vm/rpms_needed.txt ); do
	    if [ -z "`grep $a $YUMTMPFILE`" ]; then
		NOTFOUNDLIST="$NOTFOUNDLIST $a" 
		yum -y install $a
	    fi
	done

	#At this point in time, we hopefully have vim installed
	if [ -f /usr/local/src/cx-git/centrallix-dev-tools/cx.vim ]; then
	    cp /usr/local/src/cx-git/centrallix-dev-tools/cx.vim /usr/share/vim/vim??/syntax/ 
	fi

	rm -f $YUMTMPFILE
    }

function installLiquibaseIfNeeded
    {
    todo=0
    [ ! -e "/etc/profile.d/liquibase.sh" ] && todo=1
    [ ! -e "/usr/local/liquibase/liquibase" ] && todo=1
    if [ $todo == 1 ]; then
	echo "Need to install liquibase - downloading"
	#Use the following to grab the latest version possible
	#lbURL=$(wget --quiet -O - https://download.liquibase.org/download/?frm=n | grep bin.tar.gz | sed 's/.*"\([^"]*\)".*/\1/' | grep github | head -1)
	#use the following to grab a specific version
	lbURL="https://github.com/liquibase/liquibase/releases/download/liquibase-parent-3.8.0/liquibase-3.8.0-bin.tar.gz"
	lbBasename=$(basename $lbURL)
	lbFilename="/tmp/$lbBasename"
	wget -O $lbFilename $lbURL
	mkdir -p /usr/local/liquibase
	tar -C /usr/local/liquibase -xzvf $lbFilename
	rm -f $lbFilename
	#Add liquibase to the path
	echo PATH=$PATH:/usr/local/liquibase > /etc/profile.d/liquibase.sh
    fi
    }

# Set the system hostname.  Important because this will show up in
# commits unless the user is working from a per-user repository and
# has set their user.name and user.email.
function setHostname
    {
    HOST=$(/bin/hostname)
    N_HOST=$(dialog --backtitle "$TITLE" --title "Set Hostname" --inputbox "Set System Hostname.  Please enter a fully-qualified host.domain here; this will show up in user commits as user@host.domain." 8 72 "$HOST" 2>&1 >/dev/tty)
    if [ "$N_HOST" != "" -a "$N_HOST" != "$HOST" ]; then
	N_HOSTONLY=${N_HOST%%.*}
	#sed "s/^HOSTNAME=.*/HOSTNAME=$N_HOST/" < /etc/sysconfig/network > /etc/sysconfig/network.new
	#/bin/mv -f /etc/sysconfig/network.new /etc/sysconfig/network
	#sed "s/^127.0.0.1.*/127.0.0.1	localhost.localdomain localhost $N_HOST $N_HOSTONLY/" < /etc/hosts > /etc/hosts.new
	#/bin/mv -f /etc/hosts.new /etc/hosts
	echo "$N_HOST" > /etc/hostname
	/bin/hostname "$N_HOST"
    fi
    }


function setTimezone
    {
    while true; do
	# Find current timezone
	. /etc/sysconfig/clock
	MYZONE="$ZONE"
	#for FILE in $(find /usr/share/zoneinfo/posix -type f); do
	#    if cmp -s /etc/localtime "$FILE"; then
	#	MYZONE="$FILE"
	#	break
	#    fi
	#done
	#MYZONE="${MYZONE##/usr/share/zoneinfo/posix/}"
	DSTR="dialog --backtitle '$TITLE' --title 'Select Time Zone (currently: $MYZONE)' --menu 'Time Zone Areas:' 20 52 14"
	for FILE in $(find /usr/share/zoneinfo/posix/* -maxdepth 0 -type d); do
	    ZONE="${FILE##/usr/share/zoneinfo/posix/}"
	    DSTR="$DSTR '$ZONE' ''"
	done
	SEL=$(eval "$DSTR" 2>&1 >/dev/tty)
	if [ "$SEL" = "" ]; then
	    break
	fi
	ZONEDIR="$SEL"
	DSTR="dialog --backtitle '$TITLE' --title 'Select Time Zone (currently: $MYZONE)' --menu 'Time Zones (for $ZONEDIR):' 20 52 14"
	for FILE in $(find /usr/share/zoneinfo/posix/"$ZONEDIR"/* -type f); do
	    ZONE="${FILE##/usr/share/zoneinfo/posix/}"
	    DSTR="$DSTR '$ZONE' ''"
	done
	SEL=$(eval "$DSTR" 2>&1 >/dev/tty)
	if [ "$SEL" != "" ]; then
	    #echo $SEL
	    timedatectl set-timezone "$SEL"
	    break
	fi
    done
    }


# System administration
function menuSystem
    {
    while true; do
	HOST=$(/bin/hostname)
	DSTR="dialog --backtitle '$TITLE' --title 'Basic System Administration' --menu 'Basic System Administration' 20 72 14"
	DSTR="$DSTR Shutdown 'Shut Down the VM Appliance'"
	DSTR="$DSTR RootShell 'Get a Root Shell'"
	DSTR="$DSTR RootPass 'Change Root Password'"
	DSTR="$DSTR Updates 'Download and Install OS Updates'"
	if [ -f /usr/local/src/kardia-git/kardia-vm/extra_rpms.txt ]; then
	    first=$( cat /usr/local/src/kardia-git/kardia-vm/extra_rpms.txt | grep -v "^#" | head -1)
	    if [ -z "`rpm -q $first | grep -v 'not installed'`"  ]; then
		DSTR="$DSTR Extra 'Install unnecessary packages'"
	    fi
	fi
	DSTR="$DSTR Timezone 'Set the System Time Zone'"
	DSTR="$DSTR Resize 'Resize the Virtual Machine'"
	DSTR="$DSTR Autossh 'Configure Autossh'"
	Rootable && DSTR="$DSTR Cron 'Configure Cron Tasks'"
        Rootable && DSTR="$DSTR Wizard 'Re-Run the Initial Setup Wizard'"
	DSTR="$DSTR Quit 'Exit Kardia / Centrallix Management'"

	SEL=$(eval "$DSTR" 2>&1 >/dev/tty)
	case "$SEL" in
	    Quit)
		exit
		;;
	    '')
		break
		;;
	    Shutdown)
		shutdown -h now
		exit
		;;
	    Resize)
		AsRoot doResize
		;;
	    Autossh)
		 menuAutossh
		;;
	    RootPass)
		passwd
		;;
	    RootShell)
		echo ""
		echo "Here's a root shell, please be careful!"
		echo "Type 'exit' or CTRL-D to return."
		echo ""
		bash
		;;
	    Updates)
		doUpdates
		;;
	    Extra)
		installExtraPackages
		;;
	    Hostname)
		setHostname
		;;
	    Timezone)
		setTimezone
		;;
	    Wizard)
		AsRoot chooseSetupGuide
		;;
	    Cron)
		AsRoot editAllCron
		;;
	esac
    done
    }


# Set repository origin status (anon vs user).  $1 is the repo dir.
function repoSetStatus
    {
    if [ ! -d "$1/cx-git" ]; then
	echo "Please initialize the repositories first."
	sleep 1
	return 1
    fi
    cd "$1/cx-git"
    CXORIGIN=$(cd "$1/cx-git" 2>/dev/null; git config --get remote.origin.url 2>/dev/null)
    CXMETHOD=${CXORIGIN%%:*}
    #if CXORIGIN has a @ in it, then we have a user set.  Pick it out
    if [[ $CXORIGIN =~ "@" ]]; then
	CXUSER=${CXORIGIN##https://}
	CXUSER=${CXUSER%%@*}
    else
	CXUSER=""
    fi
    if [ "$CXMETHOD" != "https" ]; then
	CXUSER=""
    fi
    DSTR="dialog --backtitle '$TITLE' --title 'Remote Username' --inputbox 'Enter Github username (that has read/write repository access) to allow pushes to Github, or Leave Empty to disallow pushes to Github' 8 72 '$CXUSER'"
    N_CXUSER=$(eval "$DSTR" 2>&1 >/dev/tty)
    RVAL=$?
    if [ "$RVAL" = "0" ]; then
	if [ "$N_CXUSER" = "" ]; then
	    doGit config remote.origin.url "https://$CX_GITREPO"
	else
	    doGit config remote.origin.url "https://$N_CXUSER@$CX_GITREPO"
	fi
	cd "$1/kardia-git"
	if [ "$N_CXUSER" = "" ]; then
	    doGit config remote.origin.url "https://$K_GITREPO"
	else
	    doGit config remote.origin.url "https://$N_CXUSER@$K_GITREPO"
	fi
    fi
    }


# Status of uncommitted files.  $1 is the repository dir.
function repoStatus
    {
    cd "$1"
    git status | less
    #dialog --backtitle "$TITLE" --title "Repository Status:" --textbox /dev/stdin 14 72
    }

function repoViewStatus
    {
    (   cd "$1/cx-git"
	echo "*** CENTRALLIX STATUS OVERVIEW ***  (git status)"
	git status
	cd "$1/kardia-git"
	echo ""
	echo ""
	echo "*** KARDIA STATUS OVERVIEW ***  (git status)"
	git status
	cd "$1/cx-git"
	echo ""
	echo ""
	echo "*** CENTRALLIX CHANGE DETAILS ***  (git diff)"
	git diff
	cd "$1/kardia-git"
	echo ""
	echo ""
	echo "*** KARDIA CHANGE DETAILS ***  (git diff)"
	git diff) | less
    }


# Commit.  $1 should be the repository dir that is being committed.
function repoCommit
    {
    cd "$1"
    echo ""
    echo "Committing changes to the local repository..."
    echo ""
    if [ "$USER" = root ]; then
	echo "You cannot commit changes as 'root'.  Switching user..."
	sleep 1
    fi
    #Preserve group ownership of the git directory
    chgrp -R kardia_src .
    #Preserve group write permissions on the git directory
    chmod -R g+w .

    AsUser doGit commit -a
    RVAL=$?
    sleep 1
    return $RVAL
    }


# Commit specific files.  $1 should be the repo dir.
function repoCommitFiles
    {
    REPO="$1"
    TMPNAME="/tmp/commitfiles-$RANDOM-$RANDOM.txt"
    /bin/rm -f "$TMPNAME.added" 2>/dev/null
    /bin/rm -f "$TMPNAME.all" 2>/dev/null
    /bin/rm -f "$TMPNAME" 2>/dev/null
    touch "$TMPNAME"
    cd "$REPO"
    #Preserve group ownership of the git directory
    chgrp -R kardia_src .
    #Preserve group write permissions on the git directory
    chmod -R g+w .

    git status | while read POUND V1 V2 V3; do
	if [ "$POUND" = "#" ]; then
	    FILE=""
	    if [ "$V1" = "modified:" ]; then
		if [ "$V3" != "" ]; then
		    FILE="$V2 $V3"
		else
		    FILE="$V2"
		fi
	    fi
	    if [ "$V1" = "new" -a "$V2" = "file:" ]; then
		FILE="$V3"
	    fi
	    if [ "$FILE" != "" ]; then
		# If it has a double quote in it, it causes us trouble.
		# Just ignore those troublesome files.
		if [ "${FILE%%\"*}" == "$FILE" ]; then
		    echo "\"$FILE\"" "''" off >> $TMPNAME
		    echo "$FILE" >> $TMPNAME.all
		fi
	    fi
	fi
    done
    DSTR="dialog --backtitle '$TITLE' --title 'Commit Specific Files...' --separate-output --checklist 'Select which files to commit:' 20 72 14"
    OPTIONS=$(paste -s -d ' ' < "$TMPNAME")
    DSTR="$DSTR $OPTIONS"
    eval "$DSTR" 2>&1 >/dev/tty | while read FILE; do
	/bin/echo -e -n "$FILE"'\0000' >> "$TMPNAME.added"
    done

    # If at least one file was added, do the commit.
    if [ -f "$TMPNAME.added" ]; then
	cat "$TMPNAME.added" | xargs -0 -x -n 9999 git commit
    fi
    stty sane

    # Clean up...
    /bin/rm -f "$TMPNAME" 2>/dev/null
    /bin/rm -f "$TMPNAME.added" 2>/dev/null
    /bin/rm -f "$TMPNAME.all" 2>/dev/null
    }


# Add a file.  $1 should be the repo dir.  This used to use --fselect in
# dialog, but --fselect is a bear and no one should be asked to use it.
# So we generate a list of untracked files and ask the user to pick
# files to add from that list.
function repoAddFile
    {
    REPO="$1"
    TMPNAME="/tmp/untracked-$RANDOM-$RANDOM.txt"
    /bin/rm -f "$TMPNAME.added" 2>/dev/null
    /bin/rm -f "$TMPNAME.all" 2>/dev/null
    /bin/rm -f "$TMPNAME" 2>/dev/null
    touch "$TMPNAME"
    cd "$REPO"
    UNTRACKED=no
    git status | while read POUND FILE; do
	if [ "$UNTRACKED" = yes -a "$POUND" = "#" -a "$FILE" != "" -a "$FILE" != '(use "git add <file>..." to include in what will be committed)' ]; then
	    # If it has a double quote in it, it causes us trouble.
	    # Just ignore those troublesome files.
	    if [ "${FILE%%\"*}" == "$FILE" ]; then
		echo "\"$FILE\"" "''" off >> $TMPNAME
		echo "$FILE" >> $TMPNAME.all
	    fi
	fi
	if [ "$FILE" = "Untracked files:" ]; then
	    UNTRACKED=yes
	fi
    done
    DSTR="dialog --backtitle '$TITLE' --title 'Add New Files to $2...' --separate-output --checklist 'Select which new files to add to source control:' 20 72 14"
    ADDMSG="Add non-selected new files to .gitignore"
    DSTR="$DSTR '$ADDMSG' '' off"
    OPTIONS=$(paste -s -d ' ' < "$TMPNAME")
    DSTR="$DSTR $OPTIONS"
    eval "$DSTR" 2>&1 >/dev/tty | while read FILE; do
	if [ "$FILE" = "$ADDMSG" ]; then
	    touch "$TMPNAME.added"
	else
	    doGit add "$FILE"
	    if [ -f "$TMPNAME.added" ]; then
		echo "$FILE" >> "$TMPNAME.added"
	    fi
	fi
    done

    # Add files to .gitignore?  uniq -u will give us the files that
    # were *not* added to $TMPNAME.added.  
    if [ -f "$TMPNAME.added" ]; then
	cat "$TMPNAME.all" "$TMPNAME.added" | sort | uniq -u >> "$REPO/.gitignore"
    fi

    # Clean up...
    /bin/rm -f "$TMPNAME" 2>/dev/null
    /bin/rm -f "$TMPNAME.added" 2>/dev/null
    /bin/rm -f "$TMPNAME.all" 2>/dev/null
    }


# Push.  $1 should be the repo dir that is being committed.
function repoPush
    {
    cd "$1"
    #Preserve group ownership of the git directory
    chgrp -R kardia_src .
    #Preserve group write permissions on the git directory
    chmod -R g+w .

    PUSHTO=$(git config --get remote.origin.url 2>/dev/null)

    # Temporarily set origin to the shared repo?  Sometimes we have to
    # do this if the user's IDE pointed the origin to the shared repo
    # via the samba share.
    NEWPUSHTO="$PUSHTO"
    if [ "$WKFMODE" == team -a "${1##/home}" != "$1" ]; then
	if [ "${1%%kardia-git*}" != "$1" ]; then
	    NEWPUSHTO="$BASEDIR/src/kardia-git"
	else
	    NEWPUSHTO="$BASEDIR/src/cx-git"
	fi
	git config remote.origin.url "$NEWPUSHTO"
    fi
    echo ""
    echo "Pushing changes upstream..."
    echo "    FROM: $1"
    echo "    TO:   $NEWPUSHTO"
    echo ""
    doGit push origin
    RVAL=$?
    if [ "$NEWPUSHTO" = "$BASEDIR/src/kardia-git" -o "$NEWPUSHTO" = "$BASEDIR/src/cx-git" ]; then
	# Sync the working tree in the shared repo with the pushed repository
	# copy.  This overwrites anything in the shared repo working tree.
	cd "$NEWPUSHTO"
	doGit reset --hard
	cd -
    fi
    git config remote.origin.url "$PUSHTO"
    sleep 1
    return $RVAL
    }


# Pull.  $1 should be the repo dir that will be updated.
function repoPull
    {
    cd "$1"
    PULLFROM=$(git config --get remote.origin.url 2>/dev/null)

    # Temporarily set origin to the shared repo?  Sometimes we have to
    # do this if the user's IDE pointed the origin to the shared repo
    # via the samba share.
    NEWPULLFROM="$PULLFROM"
    if [ "$WKFMODE" == team -a "${1##/home}" != "$1" ]; then
	if [ "${1%%kardia-git*}" != "$1" ]; then
	    NEWPULLFROM="$BASEDIR/src/kardia-git"
	else
	    NEWPULLFROM="$BASEDIR/src/cx-git"
	fi
	git config remote.origin.url "$NEWPULLFROM"
    fi
    echo ""
    echo "Fetching/Pulling changes from upstream..."
    echo "    FROM: $NEWPULLFROM"
    echo "    TO:   $1"
    echo ""
    doGit pull origin
    #Preserve group ownership of the git directory
    chgrp -R kardia_src .
    #Preserve group write permissions on the git directory
    chmod -R g+w .

    RVAL=$?
    git config remote.origin.url "$PULLFROM"
    echo ""
    echo "If there are merge conflicts, you will need to resolve those manually."
    echo "*** Press ENTER to continue ***"
    read ANS
    return $RVAL
    }


# Set repository origin for user repo.  $1 is username, or blank to use
# the current user.  $2 should be github username, or READONLY, or blank
# (see repoInitUser).
function repoSetOrigin
    {
    RUSER="$1"
    if [ "$1" = "" ]; then
	RUSER=$(id -un)
    fi
    if [ "$2" = "" ]; then
	CXORIGIN="$BASEDIR/src/cx-git"
	KORIGIN="$BASEDIR/src/kardia-git"
    elif [ "$2" = "READONLY" ]; then
	CXORIGIN="https://$CX_GITREPO"
	KORIGIN="https://$K_GITREPO"
    else
	CXORIGIN="https://$2@CX_GITREPO"
	KORIGIN="https://$2@$K_GITREPO"
    fi

    # Set the origin...
    cd "/home/$RUSER/cx-git"
    doGit config remote.origin.url "$CXORIGIN"
    cd "/home/$RUSER/kardia-git"
    doGit config remote.origin.url "$KORIGIN"
    }


# Initialize a user's repository.  $2 can be set to a github username for
# direct github pushing/pulling, or READONLY for anonymous github pulling
# (no pushes), or blank to use the shared repository (i.e., 'team' workflow
# mode.  $1 should be set to the username, or blank to use current user.
function repoInitUser
    {
    RUSER="$1"
    if [ "$1" = "" ]; then
	RUSER=$(id -un)
    fi
    if [ "$2" = "" ]; then
	CXORIGIN="$BASEDIR/src/cx-git"
	KORIGIN="$BASEDIR/src/kardia-git"
    elif [ "$2" = "READONLY" ]; then
	CXORIGIN="https://$CX_GITREPO"
	KORIGIN="https://$K_GITREPO"
    else
	CXORIGIN="https://$2@$CX_GITREPO"
	KORIGIN="https://$2@$K_GITREPO"
    fi

    echo "Cloning new repository for $RUSER..."
    cd "/home/$RUSER" || return 1
    /bin/rm -rf cx-git kardia-git 2>/dev/null
    doGit clone "$CXORIGIN" cx-git
    doGit clone "$KORIGIN" kardia-git
    chown -R "$RUSER": cx-git kardia-git 2>/dev/null
    cd cx-git/centrallix-os/apps
    ln -s ../../../kardia-git/kardia-app kardia

    #mark git directories as trusted
    git config --global --add safe.directory /home/$RUSER/cx-git
    git config --global --add safe.directory /home/$RUSER/kardia-git

    setGitEmail "/home/$RUSER"
    }


# Initialize the shared repository
function repoInitShared
    {
    CXORIGIN=$(cd $BASEDIR/src/cx-git 2>/dev/null; git config --get remote.origin.url 2>/dev/null)
    KORIGIN=$(cd $BASEDIR/src/kardia-git 2>/dev/null; git config --get remote.origin.url 2>/dev/null)
    CXMETHOD=${CXORIGIN%%:*}
    if [ "$CXMETHOD" != "https" ]; then
	CXORIGIN="https://$CX_GITREPO"
	KORIGIN="https://$K_GITREPO"
    fi
    [ -z "$CXORIGIN" ] && repoSetOrigin
    [ -z "$KORIGIN" ] && repoSetOrigin
    cd $BASEDIR/src || return 1
    /bin/rm -rf cx-git 2>/dev/null
    /bin/rm -rf kardia-git 2>/dev/null
    doGit clone "$CXORIGIN" cx-git
    doGit clone "$KORIGIN" kardia-git

    # workaround for undocumented selinux policy problem
    chcon -t usr_t $BASEDIR/src

    # allow it to be shared with selinux enforcing samba
    chcon -R -t samba_share_t cx-git kardia-git

    # correct the user permissions to allow kardia_src users
    /bin/chgrp -R kardia_src cx-git kardia-git
    /bin/chmod -R g+rw cx-git kardia-git
    find cx-git -type d -exec /bin/chmod g+s {} \;
    find kardia-git -type d -exec /bin/chmod g+s {} \;
    cd cx-git/centrallix-os/apps
    ln -s ../../../kardia-git/kardia-app kardia

    # Set repo permissions to allow updates
    cd $BASEDIR/src/cx-git
    doGit config receive.denyCurrentBranch ignore
    cd ../kardia-git
    doGit config receive.denyCurrentBranch ignore
    cd ..

    #mark git directories as trusted
    git config --global --add safe.directory $BASEDIR/src/cx-git
    git config --global --add safe.directory $BASEDIR/src/kardia-git

    #make user tpl files
    doMakeTplFiles
    }

function doGiveKardiaPerms
    {
    perms="kardia:sys_admin kardia:gift kardia:gift_amt kardia:gift_entry kardia:gift_manage kardia:gl_entry kardia:gl_manage kardia:pay_manage"
    thisdate=$(date +"%m-%d-%Y")
    for user in $*; do
	for perm in $perms; do
	    exists=$(mysql -e "select s_endorsement, s_subject from Kardia_DB.s_sec_endorsement where s_subject = 'u:$user' and s_endorsement = '$perm'")
	    if [ -z "$exists" ]; then
		#It is not there yet.  Add it
		mysql -u root -e "INSERT INTO Kardia_DB.s_sec_endorsement 
		      (s_endorsement, s_context, s_subject, s_date_created, s_created_by, s_date_modified, s_modified_by) 
	       VALUES ('$perm',       'kardia', 'u:$user', '$thisdate', '$user', '$thisdate', '$user');"
	    fi
	done
    done
    }


# Shared Repository menu
function menuRepo
    {
    while true; do
	KORIGIN=$(cd $BASEDIR/src/kardia-git 2>/dev/null; git config --get remote.origin.url 2>/dev/null)
	CXORIGIN=$(cd $BASEDIR/src/cx-git 2>/dev/null; git config --get remote.origin.url 2>/dev/null)
	CXMETHOD=${CXORIGIN%%:*}
	CXUSER=${CXORIGIN##https://}
	CXUSER=${CXUSER%%@*}
	if [ "$CXMETHOD" = "git" ]; then
	    REPSTAT="no pushes"
	elif [ "$CXMETHOD" = "https" ]; then
	    REPSTAT="via Github $CXUSER"
	else
	    REPSTAT="no repository"
	fi

	DSTR="dialog --backtitle '$TITLE' --title 'Shared Git Repository' --menu 'Shared Repository Management' 14 72 8"
	DSTR="$DSTR Status 'Shared Repo Push Stat (now: $REPSTAT)'"
	Rootable && DSTR="$DSTR Init 'Initialize Shared Repository (destructive)'"
#	DSTR="$DSTR '   ' '--- Centrallix Codebase ---'"
#	if [ "$CXMETHOD" = ssh ]; then
#	    DSTR="$DSTR PushCX 'Push Centrallix changes upstream'"
#	fi
#	if [ "$CXMETHOD" != "" ]; then
#	    DSTR="$DSTR PullCX 'Pull/Fetch Centrallix changes from upstream'"
#	fi
#	DSTR="$DSTR ChangesCX 'Show Uncommited Files in Shared Repository'"
#	DSTR="$DSTR CommitCX 'Commit Changes in Shared Repository'"
#	DSTR="$DSTR AddCX 'Add a File to Version Control in Shared Repository'"
#	DSTR="$DSTR '   ' '--- Kardia Codebase ---'"
#	if [ "$CXMETHOD" = ssh ]; then
#	    DSTR="$DSTR PushK 'Push Kardia changes upstream'"
#	fi
#	if [ "$CXMETHOD" != "" ]; then
#	    DSTR="$DSTR PullK 'Pull/Fetch Kardia changes from upstream'"
#	fi
#	DSTR="$DSTR ChangesK 'Show Uncommited Files in Shared Repository'"
#	DSTR="$DSTR CommitK 'Commit Changes in Shared Repository'"
#	DSTR="$DSTR AddK 'Add a File to Version Control in Shared Repository'"
	DSTR="$DSTR '   ' ''"
	DSTR="$DSTR Quit 'Exit Kardia / Centrallix Management'"
	SEL=$(eval "$DSTR" 2>&1 >/dev/tty)
	case "$SEL" in
	    Init)
		AsRoot repoInitShared
		;;
	    Status)
		repoSetStatus "$BASEDIR/src"
		;;
	    PushCX)
		repoPush $BASEDIR/src/cx-git
		;;
	    PushK)
		repoPush $BASEDIR/src/kardia-git
		;;
	    PullCX)
		repoPull $BASEDIR/src/cx-git
		;;
	    PullK)
		repoPull $BASEDIR/src/kardia-git
		;;
	    CommitCX)
		repoCommit $BASEDIR/src/cx-git
		;;
	    CommitK)
		repoCommit $BASEDIR/src/kardia-git
		;;
	    AddCX)
		repoAddFile $BASEDIR/src/cx-git Centrallix
		;;
	    AddK)
		repoAddFile $BASEDIR/src/kardia-git Kardia
		;;
	    ChangesCX)
		repoStatus $BASEDIR/src/cx-git
		;;
	    ChangesK)
		repoStatus $BASEDIR/src/kardia-git
		;;
	    '')
		break
		;;
	    '   ')
		;;
	    Quit)
		exit
		;;
	esac
    done
    }


# Individual Repository menu
function menuIndRepo
    {
    while true; do
	lookupStatus

	cd ~

	KORIGIN=$(cd ~/kardia-git 2>/dev/null; git config --get remote.origin.url 2>/dev/null)
	CXORIGIN=$(cd ~/cx-git 2>/dev/null; git config --get remote.origin.url 2>/dev/null)
	CXMETHOD=${CXORIGIN%%:*}
	CXUSER=${CXORIGIN##https://}
	CXUSER=${CXUSER%%@*}
	if [ "$CXMETHOD" = "git" ]; then
	    REPSTAT="no pushes allowed"
	elif [ "$CXMETHOD" = "https" ]; then
	    REPSTAT="$CXUSER"
	else
	    REPSTAT="no repository"
	fi

	if [ "$WKFMODE" == "individual" ]; then
	    UPSTREAM="Github"
	else
	    UPSTREAM="Shared Repo"
	fi

	DSTR="dialog --backtitle '$TITLE' --title 'Git Repository for $USER' --menu 'Repository Options:' 14 72 8"
	if [ "$WKFMODE" == "individual" ]; then
	    DSTR="$DSTR SFUser 'Set SF.net Username (now: $REPSTAT)'"
	fi
	DSTR="$DSTR Init 'Initialize Repository for $USER (destructive)'"
#	DSTR="$DSTR '   ' '--- Centrallix Codebase ---'"
#	if [ "$WKFMODE" == team -o "$CXMETHOD" = ssh ]; then
#	    DSTR="$DSTR PushCX 'Push Centrallix changes to $UPSTREAM'"
#	fi
#	if [ "$WKFMODE" == team -o "$CXMETHOD" != "" ]; then
#	    DSTR="$DSTR PullCX 'Pull/Fetch Centrallix changes from $UPSTREAM'"
#	fi
#	DSTR="$DSTR ChangesCX 'Show Uncommited Files for $USER'"
#	DSTR="$DSTR CommitCX 'Commit Changes for $USER'"
#	DSTR="$DSTR AddCX 'Add a File to Version Control for $USER'"
#	DSTR="$DSTR '   ' '--- Kardia Codebase ---'"
#	if [ "$WKFMODE" == team -o "$CXMETHOD" = ssh ]; then
#	    DSTR="$DSTR PushK 'Push Kardia changes to $UPSTREAM'"
#	fi
#	if [ "$WKFMODE" == team -o "$CXMETHOD" != "" ]; then
#	    DSTR="$DSTR PullK 'Pull/Fetch Kardia changes from $UPSTREAM'"
#	fi
#	DSTR="$DSTR ChangesK 'Show Uncommited Files for $USER'"
#	DSTR="$DSTR CommitK 'Commit Changes for $USER'"
#	DSTR="$DSTR AddK 'Add a File to Version Control for $USER'"
	DSTR="$DSTR '   ' ''"
	DSTR="$DSTR Quit 'Exit Kardia / Centrallix Management'"
	SEL=$(eval "$DSTR" 2>&1 >/dev/tty)
	case "$SEL" in
	    Init)
		repoInitUser
		;;
	    Status)
		repoSetStatus "/home/$USER"
		;;
	    PushCX)
		repoPush "/home/$USER/cx-git"
		;;
	    PushK)
		repoPush "/home/$USER/kardia-git"
		;;
	    PullCX)
		repoPull "/home/$USER/cx-git"
		;;
	    PullK)
		repoPull "/home/$USER/kardia-git"
		;;
	    CommitCX)
		repoCommit "/home/$USER/cx-git"
		;;
	    CommitK)
		repoCommit "/home/$USER/kardia-git"
		;;
	    AddCX)
		repoAddFile "/home/$USER/cx-git" Centrallix
		;;
	    AddK)
		repoAddFile "/home/$USER/kardia-git" Kardia
		;;
	    ChangesCX)
		repoStatus "/home/$USER/cx-git"
		;;
	    ChangesK)
		repoStatus "/home/$USER/kardia-git"
		;;
	    '')
		break
		;;
	    '   ')
		;;
	    Quit)
		exit
		;;
	esac
    done
    }

function verifyLinksigningKey
    {
    lookupStatus
    if [ -z "`grep link_signing_key $CXCONF`" ]; then
	linksigningfile="$(dirname $CXCONF)/linksigningkey.txt"
	if [ -f $linksigningfile ]; then
	    #echo found link signing $linksigningfile
	    lkey=`cat $linksigningfile`
	else
	    #echo Making linksigning key file
	    lkey=$(dd if=/dev/urandom bs=32 count=1 2>/dev/null| sha256sum | cut -c1-32)
	    echo $lkey > $linksigningfile
	    if [ -z "echo $CXCONF | grep home" ]; then
		#We are doing it in the home directory - permissions for user
		chown $USER.$USER $linksigningfile
		chmod 600 $linksigningfile
	    else
		chown root.root $linksigningfile
		#it is going to be /usr/local/etc.  chown to root
		chmod 600 $linksigningfile
	    fi
	fi
	#echo not found
	lineno=$(grep -n "upload_tmpdir" $CXCONF | sed 's/:.*//')
	lineno=$((lineno + 1))

	sed -i "${lineno}i\/\/" $CXCONF
	sed -i "${lineno}ilink_signing_sites = \"http:\/\/localhost:800\/\", \"http:\/\/localhost:1800\/\", \"\/\";" $CXCONF
	sed -i "${lineno}ilink_signing_key = \"$lkey\";" $CXCONF
	sed -i "${lineno}i\/\/ Signed links..." $CXCONF
	sed -i "${lineno}i\/\/" $CXCONF
    fi
    }


# Rebuild / reinstall Centrallix - as user, individual repositories.
function doBuildAsSeparateUser
    {
    if [ ! -d /home/$USER/cx-git/centrallix ]; then
	echo "Please init your individual repository first."
	sleep 1
	return 1
    fi

    # Our install directory
    INSTDIR="/home/$USER/cxinst"
    mkdir -p "$INSTDIR" 2>/dev/null

    # Build Centrallix-lib
    cd "/home/$USER/cx-git/centrallix-lib"
    if [ ! -f Makefile -o Makefile.in -nt Makefile ]; then
	./configure --prefix="$INSTDIR" --with-hardening=low
	if [ "$?" != 0 ]; then
	    echo "Errors configuring centrallix-lib.  Press ENTER to return to the menu."
	    read ANS
	    return 1
	fi
    fi
    CURMD5=$(md5sum libCentrallix* include/*.h 2>/dev/null)
    make
    if [ "$?" != 0 ]; then
	echo "Errors building centrallix-lib.  Press ENTER to return to the menu."
	read ANS
	return 1
    fi
    NEWMD5=$(md5sum libCentrallix* include/*.h 2>/dev/null)
    if [ "$CURMD5" = "$NEWMD5" -a ! libCentrallix.so -nt "$INSTDIR/lib/libCentrallix.so" ]; then
	echo "Skipping centrallix-lib install step; there were no changes."
    else
	make install
	if [ "$?" != 0 ]; then
	    echo "Errors installing centrallix-lib. Press ENTER to return to the menu."
	    read ANS
	    return 1
	fi
    fi

    # Build centrallix
    cd "/home/$USER/cx-git/centrallix"
    if [ ! -f Makefile -o Makefile.in -nt Makefile ]; then
	./configure --prefix="$INSTDIR" --disable-pop3
	if [ "$?" != 0 ]; then
	    echo "Errors configuring centrallix.  Press ENTER to return to the menu."
	    read ANS
	    return 1
	fi
    fi
    make centrallix test_obj modules
    if [ "$?" != 0 ]; then
	echo "Errors building centrallix.  Press ENTER to return to the menu."
	read ANS
	return 1
    fi

    # Is centrallix currently running?
    AUTORESTART=no
    if [ "$CXRUNNING" != "" ]; then
	AUTORESTART=yes
	cxStop
    fi

    # Do the install
    make install modules_install
    if [ "$?" != 0 ]; then
	echo "Errors installing centrallix.  Press ENTER to return to the menu."
	read ANS
	return 1
    fi

    # Fixup config files?
    make config
    sed 's/accept_localhost_only = 1/accept_localhost_only = 0/' < etc/centrallix.conf | sed "s/listen_port = 800/listen_port = $CXPORT/" | sed "s/\/usr\/local\/etc\/centrallix/\/home\/$USER\/cxinst\/etc\/centrallix/" | sed "s/\/usr\/local\/lib\/centrallix/\/home\/$USER\/cxinst\/lib\/centrallix/" | sed 's/auth_method = "system"/\/\/auth_method = "system"/' | sed 's/\/\/auth_method = "altpasswd"/auth_method = "altpasswd"/' | sed 's/\/\/altpasswd_file = /altpasswd_file = /' | sed 's/auth_realm = "Centrallix"/auth_realm = "Centrallix - '$USER'"/' | sed 's/enable_send_credentials = 0/enable_send_credentials = 1/' > "$INSTDIR/etc/centrallix.conf"
    if [ -z "`grep upload_extensions $INSTDIR/etc/centrallix.conf`" ]; then 
	sed -i '/access_log/a\\t\/\/ File upload controls...\n\tupload_extensions = "jpg","jpeg","png","gif","svg","pdf","doc","docx","odt","xls","xlsx","ods","txt";\n\tupload_dirs = "/apps/kardia/files";\n\tupload_tmpdir = "/var/tmp";'  "$INSTDIR/etc/centrallix.conf"
    fi
    if [ -z "`grep doc $INSTDIR/etc/centrallix/types.cfg`" ]; then 
	echo -e "\"application/msword\"\t\t\"Word Doc\"\t\tdoc\t\t\"\"\t\t\"application/octet-stream\"" >> $INSTDIR/etc/centrallix/types.cfg
	echo -e "\"application/vnd.openxmlformats-officedocument.wordprocessingml.document\"\t\t\"Word Doc\"\t\tdocx\t\t\"\"\t\t\"application/octet-stream\"" >> $INSTDIR/etc/centrallix/types.cfg
	echo -e "\"application/vnd.ms-excel\"\t\t\"Excel Spreadsheet\"\t\txls\t\t\"\"\t\t\"application/octet-stream\"" >> $INSTDIR/etc/centrallix/types.cfg
	echo -e "\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\"\t\t\"Excel Spreadsheet\"\t\txlsx\t\t\"\"\t\t\"application/octet-stream\"" >> $INSTDIR/etc/centrallix/types.cfg
	echo -e "\"application/vnd.oasis.opendocument.spreadsheet\"\t\t\"OpenDocument Spreadsheet\"\t\tods\t\t\"\"\t\t\"application/octet-stream\"" >> $INSTDIR/etc/centrallix/types.cfg
	echo -e "\"application/vnd.oasis.opendocument.text\"\t\t\"OpenDocument Text\"\t\todt\t\t\"\"\t\t\"application/octet-stream\"" >> $INSTDIR/etc/centrallix/types.cfg
    fi
    sed "s/\/var\/centrallix\/os/\/home\/$USER\/cx-git\/centrallix-os/" < etc/rootnode > "$INSTDIR/etc/centrallix/rootnode"

    verifyLinksigningKey

    # Create user template for Kardia?
    if [ ! -f "$KSRC/kardia-app/tpl/$USER.tpl" ]; then
	cp "$KSRC/kardia-app/tpl/newuser_default.tpl" "$KSRC/kardia-app/tpl/$USER.tpl"
    fi

    # Auto restart?
    if [ "$AUTORESTART" = yes ]; then
	cxStart
    fi

    lookupStatus

    if [ "$CXRUNNING" != "" ]; then
	dialog --backtitle "$TITLE" --title "Centrallix Started" --msgbox "Centrallix is started and is running on the following port:

Port:  $CXPORT
URL:   http://$IPADDR:$CXPORT/" 0 0
    fi
    }


# Rebuild / reinstall Centrallix - as user, one shared repository.
function doBuildAsUser
    {
    if [ ! -d $BASEDIR/src/cx-git/centrallix ]; then
	echo "Please init the shared repository first."
	sleep 1
	return 1
    fi

    # Build centrallix-lib
    cd $BASEDIR/src/cx-git/centrallix-lib
    if [ ! -f Makefile -o Makefile.in -nt Makefile ]; then
	./configure --prefix=/usr/local --with-hardening=low
	if [ "$?" != 0 ]; then
	    echo "Errors configuring centrallix-lib.  Press ENTER to return to the menu."
	    read ANS
	    return 1
	fi
    fi
    make
    if [ "$?" != 0 ]; then
	echo "Errors building centrallix-lib.  Press ENTER to return to the menu."
	read ANS
	return 1
    fi

    # We manually install, since we can't ./configure the install
    # directory to a user, because the ./configure is system-wide.
    #
    mkdir -p ~/cxinst/lib 2>/dev/null
    /bin/cp -a libCentrallix* libStParse* ~/cxinst/lib/

    # Build centrallix
    cd $BASEDIR/src/cx-git/centrallix
    if [ ! -f Makefile -o Makefile.in -nt Makefile ]; then

	# Grab cxlib from the build directory, since it can't be "installed"
	# We can't set the install dir to our private home dir, since the
	# config is system-wide here.
	#
	cd $BASEDIR/src/cx-git/centrallix-lib/include
	ln -s . cxlib 2>/dev/null

	cd $BASEDIR/src/cx-git/centrallix
	./configure --prefix=/usr/local --disable-pop3 --with-centrallix-inc=$BASEDIR/src/cx-git/centrallix-lib/include --with-centrallix-lib=$BASEDIR/src/cx-git/centrallix-lib
	if [ "$?" != 0 ]; then
	    echo "Errors configuring centrallix.  Press ENTER to return to the menu."
	    read ANS
	    return 1
	fi
    fi
    make centrallix test_obj modules
    if [ "$?" != 0 ]; then
	echo "Errors building centrallix.  Press ENTER to return to the menu."
	read ANS
	return 1
    fi

    # Is centrallix currently running?
    AUTORESTART=no
    if [ "$CXRUNNING" != "" ]; then
	AUTORESTART=yes
	cxStop
    fi

    # Manually install in our home dir, and make edits to centrallix.conf
    # and to rootnode to reflect the runtime location.
    #
    mkdir -p ~/cxinst/lib/centrallix 2>/dev/null
    mkdir -p ~/cxinst/sbin 2>/dev/null
    mkdir -p ~/cxinst/bin 2>/dev/null
    mkdir -p ~/cxinst/etc/centrallix 2>/dev/null
    /bin/cp -a osdrivers/*.so ~/cxinst/lib/centrallix/
    /bin/cp -a centrallix ~/cxinst/sbin/
    /bin/cp -a test_obj ~/cxinst/bin/
    make config
    sed 's/accept_localhost_only = 1/accept_localhost_only = 0/' < etc/centrallix.conf | sed "s/listen_port = 800/listen_port = $CXPORT/" | sed "s/\/usr\/local\/etc\/centrallix/\/home\/$USER\/cxinst\/etc\/centrallix/" | sed "s/\/usr\/local\/lib\/centrallix/\/home\/$USER\/cxinst\/lib\/centrallix/" | sed 's/auth_method = "system"/\/\/auth_method = "system"/' | sed 's/\/\/auth_method = "altpasswd"/auth_method = "altpasswd"/' | sed 's/\/\/altpasswd_file = /altpasswd_file = /' | sed 's/auth_realm = "Centrallix"/auth_realm = "Centrallix - '$USER'"/' | sed 's/enable_send_credentials = 0/enable_send_credentials = 1/' > ~/cxinst/etc/centrallix.conf
    if [ -z "`grep upload_extensions ~/cxinst/etc/centrallix.conf`" ]; then 
	sed -i '/access_log/a\\t\/\/ File upload controls...\n\tupload_extensions = "jpg","jpeg","png","gif","svg","pdf","doc","docx","odt","xls","xlsx","ods","txt";\n\tupload_dirs = "/apps/kardia/files";\n\tupload_tmpdir = "/var/tmp";'  "~/cxinst/etc/centrallix.conf"
    fi
    if [ -z "`grep doc ~/cxinst/etc/centrallix/types.cfg`" ]; then 
	echo -e "\"application/msword\"\t\t\"Word Doc\"\t\tdoc\t\t\"\"\t\t\"application/octet-stream\"" >> ~/cxinst/etc/centrallix/types.cfg
	echo -e "\"application/vnd.openxmlformats-officedocument.wordprocessingml.document\"\t\t\"Word Doc\"\t\tdocx\t\t\"\"\t\t\"application/octet-stream\"" >> ~/cxinst/etc/centrallix/types.cfg
	echo -e "\"application/vnd.ms-excel\"\t\t\"Excel Spreadsheet\"\t\txls\t\t\"\"\t\t\"application/octet-stream\"" >> ~/cxinst/etc/centrallix/types.cfg
	echo -e "\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\"\t\t\"Excel Spreadsheet\"\t\txlsx\t\t\"\"\t\t\"application/octet-stream\"" >> ~/cxinst/etc/centrallix/types.cfg
	echo -e "\"application/vnd.oasis.opendocument.spreadsheet\"\t\t\"OpenDocument Spreadsheet\"\t\tods\t\t\"\"\t\t\"application/octet-stream\"" >> ~/cxinst/etc/centrallix/types.cfg
	echo -e "\"application/vnd.oasis.opendocument.text\"\t\t\"OpenDocument Text\"\t\todt\t\t\"\"\t\t\"application/octet-stream\"" >> ~/cxinst/etc/centrallix/types.cfg
    fi
    sed 's/\/var\/centrallix\/os/\/usr\/local\/src\/cx-git\/centrallix-os/' < etc/rootnode > ~/cxinst/etc/centrallix/rootnode
    /bin/cp -a etc/types.cfg ~/cxinst/etc/centrallix/
    /bin/cp -a etc/useragent.cfg ~/cxinst/etc/centrallix/

    verifyLinksigningKey

    # Create user template for Kardia?
    if [ ! -f "$KSRC/kardia-app/tpl/$USER.tpl" ]; then
	cp "$KSRC/kardia-app/tpl/newuser_default.tpl" "$KSRC/kardia-app/tpl/$USER.tpl"
    fi

    # Auto restart?
    if [ "$AUTORESTART" = yes ]; then
	cxStart
    fi

    lookupStatus

    if [ "$CXRUNNING" != "" ]; then
	dialog --backtitle "$TITLE" --title "Centrallix Started" --msgbox "Centrallix is started and is running on the following port:

Port:  $CXPORT
URL:   http://$IPADDR:$CXPORT/" 0 0
    fi
    }


# Rebuild / reinstall Centrallix
function doBuildAsRoot
    {
    if [ ! -d $BASEDIR/src/cx-git/centrallix ]; then
	echo "Please init the repository first."
	sleep 1
	return 1
    fi

    # Build centrallix-lib
    cd $BASEDIR/src/cx-git/centrallix-lib
    if [ ! -f Makefile -o Makefile.in -nt Makefile ]; then
	./configure --prefix=/usr/local --with-hardening=low
	if [ "$?" != 0 ]; then
	    echo "Errors configuring centrallix-lib.  Press ENTER to return to the menu."
	    read ANS
	    return 1
	fi
    fi
    CURMD5=$(md5sum libCentrallix* include/*.h 2>/dev/null)
    make
    if [ "$?" != 0 ]; then
	echo "Errors building centrallix-lib.  Press ENTER to return to the menu."
	read ANS
	return 1
    fi
    NEWMD5=$(md5sum libCentrallix* include/*.h 2>/dev/null)
    if [ "$CURMD5" = "$NEWMD5" -a ! libCentrallix.so -nt /usr/local/lib/libCentrallix.so -a ! libCentrallix.so.[0-9].[0-9].[0-9].[0-9] -nt /usr/local/lib/libCentrallix.so.[0-9].[0-9].[0-9].[0-9] ]; then
	echo "Skipping centrallix-lib install step; there were no changes."
    else
	make install
	if [ "$?" != 0 ]; then
	    echo "Errors installing centrallix-lib. Press ENTER to return to the menu."
	    read ANS
	    return 1
	fi
    fi

    # Build centrallix
    cd $BASEDIR/src/cx-git/centrallix
    if [ ! -f Makefile -o Makefile.in -nt Makefile ]; then
	./configure --prefix=/usr/local --disable-pop3
	if [ "$?" != 0 ]; then
	    echo "Errors configuring centrallix.  Press ENTER to return to the menu."
	    read ANS
	    return 1
	fi
    fi
    make centrallix test_obj modules
    if [ "$?" != 0 ]; then
	echo "Errors building centrallix.  Press ENTER to return to the menu."
	read ANS
	return 1
    fi

    # Is centrallix currently running?
    AUTORESTART=no
    if [ "$CXRUNNING" != "" ]; then
	AUTORESTART=yes
	cxStop
    fi

    # Do the install
    make install modules_install rhinit_install
    if [ "$?" != 0 ]; then
	echo "Errors installing centrallix.  Press ENTER to return to the menu."
	read ANS
	return 1
    fi
    /bin/cp /usr/local/etc/rc.d/init.d/centrallix /etc/init.d/centrallix 2>/dev/null
    chkconfig --add centrallix 2>/dev/null
    chkconfig centrallix off 2>/dev/null

    # Set allow_localhost_only to 0, so user can access the server.
    sed 's/accept_localhost_only = 1/accept_localhost_only = 0/' < /usr/local/etc/centrallix.conf | sed 's/enable_send_credentials = 0/enable_send_credentials = 1/' > /usr/local/etc/centrallix.conf.new
    /bin/mv -f /usr/local/etc/centrallix.conf.new /usr/local/etc/centrallix.conf
    if [ -z "`grep upload_extensions /usr/local/etc/centrallix.conf`" ]; then 
	sed -i '/access_log/a\\t\/\/ File upload controls...\n\tupload_extensions = "jpg","jpeg","png","gif","svg","pdf","doc","docx","odt","xls","xlsx","ods","txt";\n\tupload_dirs = "/apps/kardia/files";\n\tupload_tmpdir = "/var/tmp";'  "/usr/local/etc/centrallix.conf"
    fi
    if [ -z "`grep doc /usr/local/etc/centrallix/types.cfg`" ]; then 
	echo -e "\"application/msword\"\t\t\"Word Doc\"\t\tdoc\t\t\"\"\t\t\"application/octet-stream\"" >> /usr/local/etc/centrallix/types.cfg
	echo -e "\"application/vnd.openxmlformats-officedocument.wordprocessingml.document\"\t\t\"Word Doc\"\t\tdocx\t\t\"\"\t\t\"application/octet-stream\"" >> /usr/local/etc/centrallix/types.cfg
	echo -e "\"application/vnd.ms-excel\"\t\t\"Excel Spreadsheet\"\t\txls\t\t\"\"\t\t\"application/octet-stream\"" >> /usr/local/etc/centrallix/types.cfg
	echo -e "\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\"\t\t\"Excel Spreadsheet\"\t\txlsx\t\t\"\"\t\t\"application/octet-stream\"" >> /usr/local/etc/centrallix/types.cfg
	echo -e "\"application/vnd.oasis.opendocument.spreadsheet\"\t\t\"OpenDocument Spreadsheet\"\t\tods\t\t\"\"\t\t\"application/octet-stream\"" >> /usr/local/etc/centrallix/types.cfg
	echo -e "\"application/vnd.oasis.opendocument.text\"\t\t\"OpenDocument Text\"\t\todt\t\t\"\"\t\t\"application/octet-stream\"" >> /usr/local/etc/centrallix/types.cfg
    fi

    verifyLinksigningKey

    # Set rootnode
    sed 's/\/var\/centrallix\/os/\/usr\/local\/src\/cx-git\/centrallix-os/' < /usr/local/etc/centrallix/rootnode > /usr/local/etc/centrallix/rootnode.new
    /bin/mv -f /usr/local/etc/centrallix/rootnode.new /usr/local/etc/centrallix/rootnode

    # Create user templates for Kardia?
    doMakeTplFiles

    # Auto restart?
    if [ "$AUTORESTART" = yes ]; then
	cxStart
    fi
    }

function doMakeTplFiles
    {
    # Create user templates for Kardia?
    OLDIFS="$IFS"
    IFS=:
    while read UXUSER X1 X2 X3 UXUSERNAME X4 X5; do
        REALNAME=${UXUSERNAME// - Kardia/}
        if [ "$REALNAME" != "$UXUSERNAME" ]; then
            if [ ! -f "$KSRC/kardia-app/tpl/$UXUSER.tpl" ]; then
                cp "$KSRC/kardia-app/tpl/newuser_default.tpl" "$KSRC/kardia-app/tpl/$UXUSER.tpl"
                chown "$UXUSER": "$KSRC/kardia-app/tpl/$UXUSER.tpl"
            fi
        fi
    done < /etc/passwd
    IFS="$OLDIFS"
    }

function doBuild
    {
    case "$DEVMODE" in
	root)
	    AsRoot doBuildAsRoot
	    ;;
	users)
	    case "$WKFMODE" in
		shared)
		    AsUser doBuildAsUser
		    ;;
		team)
		    AsUser doBuildAsSeparateUser
		    ;;
		individual)
		    AsUser doBuildAsSeparateUser
		    ;;
	    esac
	    ;;
    esac
    }


function lookupStatus
    {
    HOST=$(/bin/hostname)
    USER=$(/usr/bin/id -un)
    GDBRUNNING=$(ps uh -C gdb | grep "^$USER")
    RUNMODE=$(cat $BASEDIR/src/.cx_runmode 2>/dev/null)
    if [ "$RUNMODE" = "" ]; then
	RUNMODE="service"
    fi
    DEVMODE=$(cat $BASEDIR/src/.cx_devmode 2>/dev/null)
    if [ "$DEVMODE" = "" ]; then
	DEVMODE="root"
    fi
    WKFMODE=$(cat $BASEDIR/src/.cx_wkfmode 2>/dev/null)
    if [ "$WKFMODE" = "" ]; then
	WKFMODE="shared"
    fi
    MYSQLMODE=$(cat $BASEDIR/src/.mysqlaccess 2>/dev/null)
    if [ "$MYSQLMODE" = "" ]; then
	MYSQLMODE="local"
    fi
    if [ "$DEVMODE" = root ]; then
	CXRUNNING=$(ps uh -C centrallix)
    else
	CXRUNNING=$(ps uh -C centrallix | grep "^$USER")
    fi
    if [ "$DEVMODE" = "root" ]; then
	CXCONF=/usr/local/etc/centrallix.conf
	CXETC=/usr/local/etc/centrallix
	CXBIN=/usr/local/sbin/centrallix
	CXLOG=/var/log/centrallix-screen.log
    else
	CXCONF="/home/$USER/cxinst/etc/centrallix.conf"
	CXETC="/home/$USER/cxinst/etc/centrallix"
	CXBIN="/home/$USER/cxinst/sbin/centrallix"
	CXLOG="/home/$USER/centrallix-screen.log"
    fi
    if [ "$WKFMODE" = shared -o "$USER" = root ]; then
	CXSRC=$BASEDIR/src/cx-git
	KSRC=$BASEDIR/src/kardia-git
    else
	# For both 'team' and 'individual'
	CXSRC="/home/$USER/cx-git"
	KSRC="/home/$USER/kardia-git"
    fi
    USER_NAME=$(cd $CXSRC 2>/dev/null; git config --get user.name 2>/dev/null)
    if [ "$USER_NAME" = "" ]; then
	USER_NAME=$(sed -n "s/^$USER:[^:]*:[^:]*:[^:]*:\([^:]*\) - Kardia:.*/\1/p" < /etc/passwd)
    fi
    USER_EMAIL=$(cd $CXSRC 2>/dev/null; git config --get user.email 2>/dev/null)
    if [ "$USER_EMAIL" = "" ]; then
	USER_EMAIL="$USER@"$(/bin/hostname)
    fi

    # Figure out our user id
    USERID=$(/usr/bin/id -u)

    # Port number we will listen on
    if [ "$DEVMODE" = root ]; then
	CXPORT=800
	CXSSLPORT=843
    else
	CXPORT=$(($USERID + 8000))
	CXSSLPORT=$(($USERID + 18000))
    fi

    IFDEV=$(ip addr list | grep "^[0-9]" | grep -v lo | sed 's/://g;s/[0-9]* \([^ ]*\).*/\1/' | head -1)
    IPADDR=$(ip addr show dev $IFDEV primary | sed -n 's/    inet \([0-9.]*\).*/\1/p')
    ETCDIR=$( dirname $CXETC )
    export DUPLICITY_CONF=$ETCDIR/duplicity.conf
    if [ -e "$DUPLICITY_CONF" ]; then
	export DUPLICITY_TARGET=$(grep TARGET $DUPLICITY_CONF | sed 's/.*=//')
	export DUPLICITY_CONFIGURED=$(grep CONFIGURED $DUPLICITY_CONF | sed 's/.*=//')
	export DUPLICITY_USER=$(grep USER $DUPLICITY_CONF | sed 's/.*=//')
	export DUPLICITY_HOST=$(grep HOST $DUPLICITY_CONF | sed 's/.*=//')
	export DUPLICITY_PORT=$(grep PORT $DUPLICITY_CONF | sed 's/.*=//')
	export DUPLICITY_PATH=$(grep PATH $DUPLICITY_CONF | sed 's/.*=//')
	export DUPLICITY_UUID=$(grep UUID $DUPLICITY_CONF | sed 's/.*=//')
	export DUPLICITY_KEY=$(grep KEY $DUPLICITY_CONF | sed 's/.*=//')
	export DUPLICITY_OLDEY=$(grep OLDEY $DUPLICITY_CONF | sed 's/.*=//')
	export DUPLICITY_ENABLED=$(grep ENABLED $DUPLICITY_CONF | sed 's/.*=//')
	if [ -z "$DUPLICITY_KEY" ]; then
	    export DUPLICITY_OPT="--no-encryption"
	fi
    fi
    export AUTOSSH_CONF=$ETCDIR/autossh.conf
    if [ -e "$AUTOSSH_CONF" ]; then
	export AUTOSSH_USER=$(grep USER $AUTOSSH_CONF | sed 's/.*=//')
	export AUTOSSH_HOST=$(grep HOST $AUTOSSH_CONF | sed 's/.*=//')
	export AUTOSSH_PORT=$(grep PORT $AUTOSSH_CONF | sed 's/.*=//')
	export AUTOSSH_BASE=$(grep BASE $AUTOSSH_CONF | sed 's/.*=//')
	export AUTOSSH_ENABLED=$(grep ENABLED $AUTOSSH_CONF | sed 's/.*=//')
    fi
    if [ -n "`pgrep autossh`" ]; then
	AUTOSSH_RUNNING=yes
    else
	AUTOSSH_RUNNING=no
    fi
    CKR_INSTALLED=no
    CKR_CONFIGURED=no
    CKR_RUNNING=no
    if [ -d "/usr/local/src/check-reader" ]; then
	CKR_INSTALLED=yes
	if [ -f "/usr/local/src/check-reader/server/config/config.toml" -a -f "/usr/local/src/check-reader/server/config/auth.toml" ]; then
	    CKR_CONFIGURED=yes
	    CKR_PORT=$(sed -n 's/^port[ 	]*=[ 	]*"\?\([0-9a-z_-]*\)"\?[ 	]*$/\1/p' < /usr/local/src/check-reader/server/config/config.toml)
	    CKR_HOST=$(sed -n 's/^host[ 	]*=[ 	]*"\?\([0-9a-z_.-]*\)"\?[ 	]*$/\1/p' < /usr/local/src/check-reader/server/config/config.toml)
	    CKR_KEY=$(sed -n 's/^jwt_key[ 	]*=[ 	]*"\?\([0-9a-z_.-]*\)"\?[ 	]*$/\1/p' < /usr/local/src/check-reader/server/config/auth.toml)
	    if [ "$CKR_PORT" != "" -a "$CKR_HOST" != "" ]; then
		SOCKET=$(ss -Ainet -anp | grep 'tcp.*LISTEN.*:'"$CKR_PORT"'.*:\*.*python3')
		if [ "$SOCKET" != "" ]; then
		    CKR_RUNNING=yes
		fi
	    fi
	fi
    fi
    }


function startStopNotSane
    {
    if [ "$USER" = root -a "$DEVMODE" != root ]; then
	#echo "Devel mode is per-user, you must not be root."
	return 0
    elif [ "$USER" != root -a "$DEVMODE" = root ]; then
	#echo "Devel mode is root, you must be root to do this."
	return 0
    else
	return 1
    fi
    }


function StartStoppable
    {
    if [ "$DEVMODE" = root ]; then
	if Rootable; then
	    return 0
	fi
    else
	return 0
    fi
    return 1
    }


# This function is used when we are running as root and need to run
# an operation as a normal user (such as a commit).  In this event,
# we present a list of users and ask for one to be picked, and we
# run the operation as that user.
function PickUser
    {
    DSTR="dialog --backtitle '$TITLE' --title 'Select User for $1' --menu 'This operation cannot be run as root.  Please select a user:' 20 72 14"
    OLDIFS="$IFS"
    IFS=:
    while read USER X1 X2 X3 USERNAME X4 X5; do
	REALNAME=${USERNAME// - Kardia/}
	if [ "$REALNAME" != "$USERNAME" ]; then
	    DSTR="$DSTR '$USER' '$REALNAME'"
	fi
    done < /etc/passwd
    IFS="$OLDIFS"

    SEL=$(eval "$DSTR" 2>&1 >/dev/tty)

    if [ "$SEL" = "" ]; then
	return 1
    else
	if [ "$FIX_SCREEN_DRAINBAMAGE" = yes ]; then
	    MYTTY=$(/usr/bin/tty)
	    TTYUSER=$(/usr/bin/stat -c "%U" "$MYTTY")
	    /bin/chown "$SEL" "$MYTTY"
	fi
	if [ "$1" != "" -a $(type -t "$1") = "function" ]; then
	    /usr/bin/sudo -u "$SEL" -i /usr/local/bin/kardia.sh "$@"
	else
	    /usr/bin/sudo -u "$SEL" -i "$@"
	fi
	RVAL=$?
	if [ "$FIX_SCREEN_DRAINBAMAGE" = yes ]; then
	    /bin/chown "$TTYUSER" "$MYTTY"
	fi
    fi
    return $RVAL
    }


# Require that an operation be performed as a normal user, and if
# we are root, do a PickUser.
function AsUser
    {
    if [ "$USER" = root ]; then
	PickUser "$@"
    else
	"$@"
    fi
    }


# Require that an operation be performed as a user who has start/stop
# permissions on the current Centrallix instance.  If dev mode is root,
# then we must be root.  If dev mode is users, then we must be a normal
# user.
function AsStartStopUser
    {
    if [ "$DEVMODE" = root ]; then
	AsRoot "$@"
    elif [ "$USER" = root ]; then
	PickUser "$@"
    else
	"$@"
    fi
    }


function initConsole
    {
    SNAME="$1"
    if [ "$SNAME" = "" ]; then
	SNAME=Centrallix
    fi
    if [ "$SNAME" = Centrallix ]; then
	if [ "$USER" = root ]; then
	    screen -S "$SNAME" -p 0 -X stuff "export LD_LIBRARY_PATH=/usr/local/lib"
	else
	    screen -S "$SNAME" -p 0 -X stuff "export LD_LIBRARY_PATH='/home/$USER/cxinst/lib'"
	fi
	sleep 0.1
	screen -S "$SNAME" -p 0 -X logfile "$CXLOG"
	sleep 0.1
	screen -S "$SNAME" -p 0 -X log on
	sleep 0.1
    fi
    screen -S "$SNAME" -p 0 -X stuff "##### $SNAME Console #####"
    }


function screenCheck
    {
    SNAME="$1"
    if [ "$SNAME" = "" ]; then
	SNAME=Centrallix
    fi
    IS_STARTED=$(screen -list | grep "$SNAME")
    if [ "$IS_STARTED" = "" ]; then
	screen -d -m -S "$SNAME"
	# wait for screen to start
	while true; do
	    sleep 0.5
	    IS_STARTED=$(screen -list | grep "$SNAME")
	    if [ "$IS_STARTED" != "" ]; then
		break
	    fi
	done

	initConsole "$SNAME"
    fi
    }


function screenPassCtrlC
    {
    SNAME="$1"
    if [ "$SNAME" = "" ]; then
	SNAME=Centrallix
    fi
    sleep 0.2
    screen -S "$SNAME" -p 0 -X stuff ""
    sleep 0.2
    }

function cxStop
    {
    lookupStatus

    startStopNotSane && return 1

    case "$RUNMODE" in
	service)
	    Root || echo "You must be root to start/stop the service"
	    PIDFILE="/var/run/centrallix.pid"
	    if [ -e $PIDFILE ]; then
		pid=$( cat /var/run/centrallix.pid )
		Root && kill $pid
	    else
		#we are trying to kill it and there is no pid
		echo "No pid found for centrallix - already dead?"
	    fi
	    #Root && service centrallix stop
	    sleep 0.5
	    ;;
	console)
	    screenCheck
	    echo "Stopping Centrallix in a console..."
	    screenPassCtrlC
	    sleep 0.1
	    killall -u "$USER" centrallix 2>/dev/null
	    sleep 0.1
	    killall -u "$USER" -9 centrallix 2>/dev/null
	    ;;
	gdb)
	    screenCheck
	    echo "Stopping Centrallix running under (gdb) in a console..."
	    if [ "$GDBRUNNING" != "" ]; then
		screenPassCtrlC
		screen -S Centrallix -p 0 -X stuff "quit"
		sleep 0.1
		screen -S Centrallix -p 0 -X stuff "y"
		sleep 0.1
		killall -u "$USER" gdb 2>/dev/null
		sleep 0.1
		killall -9 -u "$USER" gdb 2>/dev/null
	    fi
	    sleep 0.1
	    killall -u "$USER" centrallix 2>/dev/null
	    sleep 0.1
	    killall -u "$USER" -9 centrallix 2>/dev/null
	    ;;
    esac
    }


function cxStart
    {
    lookupStatus

    startStopNotSane && return 1

    checkCert #rebuild the SSL certificate if needed

    case "$RUNMODE" in
	service)
	    Root || echo "You must be root to start/stop the service"
	    centrallix=/usr/local/sbin/centrallix
	    cxARGS="-q -d -c /usr/local/etc/centrallix.conf -p /var/run/centrallix.pid"

	    Root && $centrallix $cxARGS
	    sleep 0.5
	    ;;
	console)
	    screenCheck
	    echo "Starting Centrallix in a console..."
	    screenPassCtrlC
	    screen -S Centrallix -p 0 -X stuff "$CXBIN -c $CXCONF"
	    sleep 0.5
	    ;;
	gdb)
	    screenCheck
	    echo "Starting Centrallix under (gdb) in a console..."
	    screenPassCtrlC
	    screen -S Centrallix -p 0 -X stuff "gdb $CXBIN"
	    sleep 0.1
	    screen -S Centrallix -p 0 -X stuff "set pagination off"
	    sleep 0.1
	    screen -S Centrallix -p 0 -X stuff "handle SIGPIPE nostop noprint"
	    sleep 0.1
	    screen -S Centrallix -p 0 -X stuff "handle SIG33 nostop noprint"
	    sleep 0.1
	    screen -S Centrallix -p 0 -X stuff "run -c $CXCONF"
	    sleep 0.5
	    ;;
    esac
    }

#Start Centrallix - used from the commandline: kardia.sh daemonStart
function daemonStart
    {
    AsStartStopUser cxStart
    }

#Stop Centrallix - used from the commandline: kardia.sh daemonStop
function daemonStop
    {
    AsStartStopUser cxStop
    }

#Stop/Start Centrallix - used from the commandline: kardia.sh daemonRestart
function daemonRestart
    {
    AsStartStopUser cxStop
    AsStartStopUser cxStart
    }

function viewLog
    {
    startStopNotSane && return 1
    if [ "$RUNMODE" = service ]; then
	echo "No log when running as a service."
	echo "Press ENTER to continue..."
	read ANS
	return 1
    fi

    screenCheck

    #dialog --textbox "$CXLOG" 20 72
    less "$CXLOG"
    }


function viewConsole
    {
    startStopNotSane && return 1
    if [ "$RUNMODE" = service ]; then
	echo "No console when running as a service."
	echo "Press ENTER to continue..."
	read ANS
	return 1
    fi

    screenCheck
    echo ""
    echo "Once in the console, type CTRL-A and then 'D' to detach from the console"
    echo "Press ENTER to continue..."
    echo ""
    read ANS
    screen -rx -S Centrallix
    }


function menuWorkflowMode
    {
    Root || return 1

    DSTR="dialog --backtitle '$TITLE' --title 'Workflow Mode' --radiolist 'Workflow Mode Options:' 16 72 10"
    if [ "$WKFMODE" = shared ]; then
	DSTR="$DSTR shared 'One shared repository that all users write to' on"
	DSTR="$DSTR team 'Individual repositories, pushing to a shared one' off"
	DSTR="$DSTR individual 'Individual repositories, each pushing to SF.net' off"
    elif [ "$WKFMODE" = team ]; then
	DSTR="$DSTR shared 'One shared repository that all users write to' off"
	DSTR="$DSTR team 'Individual repositories, pushing to a shared one' on"
	DSTR="$DSTR individual 'Individual repositories, each pushing to SF.net' off"
    else
	DSTR="$DSTR shared 'One shared repository that all users write to' off"
	DSTR="$DSTR team 'Individual repositories, pushing to a shared one' off"
	DSTR="$DSTR individual 'Individual repositories, each pushing to SF.net' on"
    fi

    SEL=$(eval "$DSTR" 2>&1 >/dev/tty)

    if [ "$SEL" != "" ]; then
	echo "$SEL" > $BASEDIR/src/.cx_wkfmode
	[ -f /usr/local/src/.initialized ] || touch $BASEDIR/src/.initialized
    else
	return 0
    fi

    # Re-config Samba
    if [ "$SEL" != "$WKFMODE" ]; then
	if [ "$SEL" = "shared" ]; then
	    cat /etc/samba/smb.conf.noshares /etc/samba/smb.conf.onerepo > /etc/samba/smb.conf
	else
	    cat /etc/samba/smb.conf.noshares /etc/samba/smb.conf.userrepo > /etc/samba/smb.conf
	fi
	systemctl restart smb
    fi

    # Switching to 'team' mode?  If so, reset push URL's for users...
    if [ "$SEL" = "team" -a "$WKFMODE" != "team" ]; then
	echo ""
	echo "You are switching to 'team' mode.  All existing user"
	echo "repositories will now push to the shared repository."
	echo ""
	echo "Users without a repostory should initialize theirs"
	echo "using the IInit option on the Config menu."
	echo ""
	for HOMEDIR in /home/*; do
	    if [ -d "$HOMEDIR/cx-git" ]; then
		cd "$HOMEDIR/cx-git"
		doGit config remote.origin.url "$BASEDIR/src/cx-git"
	    fi
	    if [ -d "$HOMEDIR/kardia-git" ]; then
		cd "$HOMEDIR/kardia-git"
		doGit config remote.origin.url "$BASEDIR/src/kardia-git"
	    fi
	done
	echo "Press ENTER to continue..."
	read ANS
    fi

    # Switching to 'individual' mode?  If so, reset push URL's for users...
    if [ "$SEL" = "individual" -a "$WKFMODE" != "individual" ]; then
	echo ""
	echo "You are switching to 'individual' mode.  Initially, all"
	echo "existing user repositories will be set to readonly mode,"
	echo "and users should configure their individual repository"
	echo "user (IUser on the Config menu) as appropriate, so that"
	echo "they can push to their account on Github"
	echo ""
	echo "Users without a repostory should initialize theirs"
	echo "using the IInit option on the Config menu, and then set"
	echo "their remote username using the IUser option on Config."
	echo ""
	for HOMEDIR in /home/*; do
	    if [ -d "$HOMEDIR/cx-git" ]; then
		cd "$HOMEDIR/cx-git"
		doGit config remote.origin.url "https://$CX_GITREPO"
	    fi
	    if [ -d "$HOMEDIR/kardia-git" ]; then
		cd "$HOMEDIR/kardia-git"
		doGit config remote.origin.url "https://$K_GITREPO"
	    fi
	done
	echo "Press ENTER to continue..."
	read ANS
    fi

    # Re-sets $WKFMODE and others...
    lookupStatus
    }


function menuMysqlAccessMode
    {
    Root || return 1

    lookupStatus
    bothmode=off
    localmode=on
    if [ "$MYSQLMODE" == "both" ]; then
	bothmode=on
	localmode=off
    fi
    DSTR="dialog --backtitle '$TITLE' --title 'MySql/MariaDB Access' --radiolist 'Access Options:' 16 72 10"
    DSTR="$DSTR local 'Access MySQL / MariaDB locally only' $localmode"
    DSTR="$DSTR both 'Allow Access to MySQL / MariaDB from outside the VM' $bothmode"

    SEL=$(eval "$DSTR" 2>&1 >/dev/tty)
    
    if [ "$SEL" != "" -a "$MYSQLMODE" != "$SEL" ]; then
	if [ "$SEL" = "local" ]; then
	    #block firewall in
	    if [ "$USE_FIREWALLD" = "enabled" ]; then
		firewall-cmd --perm --remove-service mysql
		firewall-cmd --remove-service mysql
	    fi
	fi
	if [ "$SEL" = "both" ]; then
	    #block firewall in
	    if [ "$USE_FIREWALLD" = "enabled" ]; then
		firewall-cmd --perm --add-service mysql
		firewall-cmd --add-service mysql
	    fi
	fi
    fi
    if [ "$SEL" != "" ]; then
	echo "$SEL" > $BASEDIR/src/.mysqlaccess
    fi

    lookupStatus
    }


function menuDevelMode
    {
    Root || return 1

    DSTR="dialog --backtitle '$TITLE' --title 'Centrallix Development Mode' --radiolist 'Devel Mode Options:' 16 72 11"
    if [ "$DEVMODE" = root ]; then
	DSTR="$DSTR root 'Run Centrallix as root (superuser)' on"
	DSTR="$DSTR users 'Run Centrallix as non-root users' off"
    elif [ "$DEVMODE" = users ]; then
	DSTR="$DSTR root 'Run Centrallix as root (superuser)' off"
	DSTR="$DSTR users 'Run Centrallix as non-root users' on"
    fi

    SEL=$(eval "$DSTR" 2>&1 >/dev/tty)

    AUTORESTART=no

    if [ "$SEL" != "" -a "$DEVMODE" != "$SEL" -a "$CXRUNNING" != "" ]; then
	echo "Stopping Centrallix..."
	cxStop
	AUTORESTART=yes
    fi
    if [ "$DEVMODE" = root -a "$SEL" != "root" -a "$RUNMODE" = service ]; then
	echo "Switching run mode from 'service' to 'console'..."
	chkconfig centrallix off
	echo console > $BASEDIR/src/.cx_runmode
    fi
    if [ "$SEL" != "" ]; then
	echo "$SEL" > $BASEDIR/src/.cx_devmode
    fi

    # If switching from users -> root, we may need to kill off other instances
    # running under other user accounts.
    if [ "$SEL" = root -a "$DEVMODE" = users ]; then
	killall centrallix 2>/dev/null
    fi

    # This updates RUNMODE and DEVMODE variables and other things...
    lookupStatus

    if [ "$AUTORESTART" = yes ]; then
	cxStart
    fi
    }


function menuRunMode
    {
    Root || return 1

    DSTR="dialog --backtitle '$TITLE' --title 'Centrallix Run Mode' --radiolist 'Run Mode Options:' 16 72 10"
    if [ "$RUNMODE" = service ]; then
	DSTR="$DSTR service 'Run as a Background Service' on"
	DSTR="$DSTR console 'Run in a Console' off"
	DSTR="$DSTR gdb 'Run in a Console under the (gdb) debugger' off"
    elif [ "$RUNMODE" = console ]; then
	[ "$DEVMODE" = root ] && DSTR="$DSTR service 'Run as a Background Service' off"
	DSTR="$DSTR console 'Run in a Console' on"
	DSTR="$DSTR gdb 'Run in a Console under the (gdb) debugger' off"
    else
	[ "$DEVMODE" = root ] && DSTR="$DSTR service 'Run as a Background Service' off"
	DSTR="$DSTR console 'Run in a Console' off"
	DSTR="$DSTR gdb 'Run in a Console under the (gdb) debugger' on"
    fi

    AUTORESTART=no

    SEL=$(eval "$DSTR" 2>&1 >/dev/tty)

    if [ "$CXRUNNING" != "" -a "$SEL" != "" -a "$SEL" != "$RUNMODE" ]; then
	cxStop
	AUTORESTART=yes
    fi

    case "$SEL" in
	service)
	    chkconfig centrallix on
	    echo 'service' > $BASEDIR/src/.cx_runmode
	    ;;
	console)
	    chkconfig centrallix off
	    echo 'console' > $BASEDIR/src/.cx_runmode
	    ;;
	gdb)
	    chkconfig centrallix off
	    echo 'gdb' > $BASEDIR/src/.cx_runmode
	    ;;
    esac

    # This updates RUNMODE variable and other things...
    lookupStatus

    if [ "$AUTORESTART" = yes ]; then
	cxStart
    fi
    }


# Set repo names / paths
function setRepoPaths
    {
    WKNAME=""
    WKPATH=""
    UP1NAME=""
    UP1PATH=""
    UP2NAME=""
    UP2PATH=""

    # Where do we start from - working repository.
    if [ "$USER" = root -o "$WKFMODE" = shared ]; then
	WKNAME="Shared Repository"
	WKPATH="$BASEDIR/src"
    else
	WKNAME="$USER-Repository"
	WKPATH="/home/$USER"
    fi

    # Upstream #1...
    if [ "$WKFMODE" = individual -o "$WKNAME" = "Shared Repository" ]; then
	UP1NAME="Github"
	UP1PATH=$(cd "$WKPATH/cx-git" 2>/dev/null; git config --get remote.origin.url 2>/dev/null)
    else
	UP1NAME="Shared Repository"
	UP1PATH="$BASEDIR/src"
    fi

    # Upstream #2...
    if [ "$UP1NAME" = "Shared Repository" ]; then
	UP2NAME="Github"
	UP2PATH=$(cd "$UP1PATH/cx-git" 2>/dev/null; git config --get remote.origin.url 2>/dev/null)
    fi
    }


# Commit and push -- all in one
function commitAndPush
    {
    lookupStatus

    setRepoPaths

    # Build the menu...
    DSTR="dialog --backtitle '$TITLE' --title 'Commit and Push' --checklist 'Select Options to Do:' 20 72 14"
    DSTR="$DSTR Centrallix '*** Work on Centrallix ***' on"
    DSTR="$DSTR Kardia     '*** Work on Kardia     ***' on"
    DSTR="$DSTR Add 'Find New Files in $WKNAME' on"
    DSTR="$DSTR Commit 'Commit All Changes to $WKNAME' on"
    DSTR="$DSTR CmtFiles 'Commit Specific Files in $WKNAME' off"
    DSTR="$DSTR Push1 'Push $WKNAME -> $UP1NAME' on"
    if [ "$UP2NAME" != "" ]; then
	DSTR="$DSTR Push2 'Push $UP1NAME -> $UP2NAME' off"
    fi

    SEL=$(eval "$DSTR" 2>&1 >/dev/tty)
    if [ "$?" != 0 ]; then
	return 1
    fi
    if [ "${SEL%%Centrallix*}" != "$SEL" ]; then DO_CX=yes; else DO_CX=no; fi
    if [ "${SEL%%Kardia*}" != "$SEL" ]; then DO_KARDIA=yes; else DO_KARDIA=no; fi
    if [ "${SEL%%Add*}" != "$SEL" ]; then DO_ADD=yes; else DO_ADD=no; fi
    if [ "${SEL%%Commit*}" != "$SEL" ]; then DO_COMMIT=yes; else DO_COMMIT=no; fi
    if [ "${SEL%%CmtFiles*}" != "$SEL" ]; then DO_CMTFILES=yes; else DO_CMTFILES=no; fi
    if [ "${SEL%%Push1*}" != "$SEL" ]; then DO_PUSH1=yes; else DO_PUSH1=no; fi
    if [ "${SEL%%Push2*}" != "$SEL" ]; then DO_PUSH2=yes; else DO_PUSH2=no; fi

    if [ "$DO_ADD" = yes ]; then
	if [ "$DO_CX" = yes ]; then
	    repoAddFile "$WKPATH/cx-git" Centrallix
	    if [ "$?" != 0 ]; then
		return 1
	    fi
	fi
	if [ "$DO_KARDIA" = yes ]; then
	    repoAddFile "$WKPATH/kardia-git" Kardia
	    if [ "$?" != 0 ]; then
		return 1
	    fi
	fi
    fi
    if [ "$DO_COMMIT" = yes ]; then
	if [ "$DO_CX" = yes ]; then
	    repoCommit "$WKPATH/cx-git" || return 1
	fi
	if [ "$DO_KARDIA" = yes ]; then
	    repoCommit "$WKPATH/kardia-git" || return 1
	fi
    fi
    if [ "$DO_CMTFILES" = yes ]; then
	if [ "$DO_CX" = yes ]; then
	    repoCommitFiles "$WKPATH/cx-git" || return 1
	fi
	if [ "$DO_KARDIA" = yes ]; then
	    repoCommitFiles "$WKPATH/kardia-git" || return 1
	fi
    fi
    if [ "$DO_PUSH1" = yes ]; then
	if [ "$DO_CX" = yes ]; then
	    repoPush "$WKPATH/cx-git" || return 1
	fi
	if [ "$DO_KARDIA" = yes ]; then
	    repoPush "$WKPATH/kardia-git" || return 1
	fi
    fi
    if [ "$DO_PUSH2" = yes ]; then
	if [ "$DO_CX" = yes ]; then
	    repoPush "$UP1PATH/cx-git" || return 1
	fi
	if [ "$DO_KARDIA" = yes ]; then
	    repoPush "$UP1PATH/kardia-git" || return 1
	fi
    fi
    }


# Pull / Update
function quickPullUpdate
    {
    lookupStatus

    setRepoPaths

    # Build the menu...
    DSTR="dialog --backtitle '$TITLE' --title 'Pull / Update' --checklist 'Select Options to Do:' 20 72 14"
    DSTR="$DSTR Centrallix '*** Work on Centrallix ***' on"
    DSTR="$DSTR Kardia     '*** Work on Kardia     ***' on"
    if [ "$UP2NAME" != "" ]; then
	DSTR="$DSTR Pull2 'Update $UP2NAME -> $UP1NAME' off"
    fi
    DSTR="$DSTR Pull1 'Update $UP1NAME -> $WKNAME' on"

    SEL=$(eval "$DSTR" 2>&1 >/dev/tty)
    if [ "$?" != 0 ]; then
	return 1
    fi
    if [ "${SEL%%Centrallix*}" != "$SEL" ]; then DO_CX=yes; else DO_CX=no; fi
    if [ "${SEL%%Kardia*}" != "$SEL" ]; then DO_KARDIA=yes; else DO_KARDIA=no; fi
    if [ "${SEL%%Pull1*}" != "$SEL" ]; then DO_PULL1=yes; else DO_PULL1=no; fi
    if [ "${SEL%%Pull2*}" != "$SEL" ]; then DO_PULL2=yes; else DO_PULL2=no; fi

    if [ "$DO_PULL2" = yes ]; then
	[ "$DO_CX" = yes ] && repoPull "$UP1PATH/cx-git"
	[ "$DO_KARDIA" = yes ] && repoPull "$UP1PATH/kardia-git"
    fi
    if [ "$DO_PULL1" = yes ]; then
	[ "$DO_CX" = yes ] && repoPull "$WKPATH/cx-git"
	[ "$DO_KARDIA" = yes ] && repoPull "$WKPATH/kardia-git"
    fi
    }


# Rebuild the Kardia database.
function doDataBuild
    {
    echo ""
    echo "Building database..."
    echo ""
    echo "(It is sometimes normal for there to be some errors during"
    echo "the database load.  That should not impact usability.)"
    echo ""
    sleep 1
    # First, dump the database to a file so we can save previous data,
    # if there is any.
    DBDUMP="/tmp/dbdump-$RANDOM-$RANDOM.sql"
    /bin/rm -f "$DBDUMP" 2>/dev/null
    if [ -d /var/lib/mysql/Kardia_DB ]; then
	mysqldump -u root -h localhost --databases Kardia_DB --complete-insert --no-create-db --no-create-info > "$DBDUMP"
	cd "$KSRC/kardia-db/ddl-mysql"
	make nodb
    fi

    # If DB perchance is totally missing...
    if [ ! -d /var/lib/mysql/Kardia_DB ]; then
	mysql -u root -h localhost -e "CREATE DATABASE Kardia_DB;"
    fi

    # Load the database schema.
    cd "$KSRC/kardia-db/ddl-mysql"
    make db

    # Re-load the data.
    if [ -f "$DBDUMP" ]; then
	echo ""
	echo "Reloading previous data from $DBDUMP..."
	echo ""
	echo "mysql -f Kardia_DB < $DBDUMP"
	mysql -u root -f -h localhost Kardia_DB < "$DBDUMP"
    fi

    # Load the test data set
    echo ""
    echo "Loading the test data set.  If you are doing a rebuild, this will"
    echo "generate some errors due to the data already existing in the DB."
    echo ""
    mysql -u root -f -h localhost Kardia_DB < "$KSRC/kardia-db/testdata/demo_mysql.sql"
    echo ""
    echo "Adding any system_admin permissions we need to add"
    doGiveAllSysadmsSysadmin
    echo "Press ENTER to continue..."
    read ANS
    }


# Devel menu
function menuDevel
    {
    while true; do
	lookupStatus

	DSTR="dialog --backtitle '$TITLE' --title 'Development Tools' --menu 'Development Tool Options (Workflow:$WKFMODE / Dev:$DEVMODE / Run:$RUNMODE)' 21 76 14"
	DSTR="$DSTR Build '(Re)Compile Centrallix and Centrallix-Lib'"
	DSTR="$DSTR DBBuild '(Re)Build the Kardia Database'"
	DSTR="$DSTR Cert 'Check the SSL certificate and rebuild if needed'"
	if [ "$USER" != root -o "$WKFMODE" = shared ]; then
	    DSTR="$DSTR Status 'Repository Modification Status'"
	else
	    DSTR="$DSTR Status 'Shared Repository Modification Status'"
	fi
	DSTR="$DSTR Commit 'Commit & Push'"
	DSTR="$DSTR Update 'Pull / Update'"
#	DSTR="$DSTR Repo 'Shared Repository Management'"
#	if [ "$WKFMODE" != shared -a "$USER" != root ]; then
#	    DSTR="$DSTR MyRepo 'Individual Repository Management'"
#	fi
	if [ -f "$CXBIN" ]; then #if the centrallix binary exists, then we can start/stop/restart it
	    if [ "$USER" != root -o "$DEVMODE" != users ]; then
		StartStoppable && DSTR="$DSTR '---' ''"
		if [ "$CXRUNNING" = "" ]; then
		    StartStoppable && DSTR="$DSTR Start 'Start Centrallix (ip:$IPADDR port:$CXPORT/$CXSSLPORT)'"
		else
		    StartStoppable && DSTR="$DSTR Restart 'Restart Centrallix'"
		    StartStoppable && DSTR="$DSTR Stop 'Stop Centrallix (ip:$IPADDR port:$CXPORT/$CXSSLPORT)'"
		fi
		StartStoppable && DSTR="$DSTR Console 'View Centrallix Console'"
		StartStoppable && DSTR="$DSTR Log 'View Centrallix Console Log'"
		[ $DEVMODE = "root" ] && ! systemctl is-enabled centrallix >/dev/null && DSTR="$DSTR Enable 'Enable Centrallix start at boot'"
		[ $DEVMODE = "root" ] && systemctl is-enabled centrallix >/dev/null && DSTR="$DSTR Disable 'Disable Centrallix start at boot'"
	    fi
	fi
	DSTR="$DSTR '---' ''"
	DSTR="$DSTR Quit 'Exit Kardia / Centrallix Management'"

	SEL=$(eval "$DSTR" 2>&1 >/dev/tty)
	case "$SEL" in
	    Quit)
		exit
		;;
	    '')
		break
		;;
	    '---')
		;;
	    Commit)
		commitAndPush
		;;
	    Cert)
		#Do we stop and start centrallix?
	        AUTORESTART=no
	        if [ "$CXRUNNING" != "" ]; then
		     AUTORESTART=yes
		     cxStop
	        fi
		checkCert
		# Auto restart?
		if [ "$AUTORESTART" = yes ]; then
		    cxStart
		fi
		;;
	    Disable)
		systemctl disable centrallix;
		;;
	    Enable)
		systemctl enable centrallix;
		;;
	    Status)
		if [ "$WKFMODE" = shared -o "$USER" = root ]; then
		    repoViewStatus "$BASEDIR/src"
		else
		    repoViewStatus "/home/$USER"
		fi
		;;
	    Update)
		quickPullUpdate
		;;
	    Repo)
		menuRepo
		;;
	    MyRepo)
		menuIndRepo
		;;
	    Console)
		AsStartStopUser viewConsole
		;;
	    Log)
		AsStartStopUser viewLog
		;;
	    Start)
		AsStartStopUser cxStart
		;;
	    Restart)
		AsStartStopUser cxStop
		AsStartStopUser cxStart
		;;
	    Stop)
		AsStartStopUser cxStop
		;;
	    Build)
		doBuild
		;;
	    DBBuild)
		AsRoot doDataBuild
		;;
	esac
    done
    }


# Set the user's full name on the given git repository.  This should not
# be done on the shared repository.  $1 is repository.
function setGitName
    {
    N_USER_NAME=$(dialog --backtitle "$TITLE" --title "Set Name" --inputbox "Enter your real name:" 8 72 "$USER_NAME" 2>&1 >/dev/tty)
    if [ "$?" != 0 ]; then
	return 1
    fi
    if [ "$N_USER_NAME" != "$USER_NAME" ]; then
	cd "$1/cx-git" 2>/dev/null
	doGit config user.name "$N_USER_NAME"
	cd "$1/kardia-git" 2>/dev/null
	doGit config user.name "$N_USER_NAME"
    fi
    }


# Set the user's email addr on the given git repository.  This should not
# be done on the shared repository.  $1 is repository.
function setGitEmail
    {
    N_USER_EMAIL=$(dialog --backtitle "$TITLE" --title "Set Email" --inputbox "Enter your email address, typically username@users.sourceforge.net:" 8 72 "$USER_EMAIL" 2>&1 >/dev/tty)
    if [ "$?" != 0 ]; then
	return 1
    fi
    if [ "$N_USER_EMAIL" != "$USER_EMAIL" ]; then
	cd "$1/cx-git" 2>/dev/null
	doGit config user.email "$N_USER_EMAIL"
	cd "$1/kardia-git" 2>/dev/null
	doGit config user.email "$N_USER_EMAIL"
    fi
    }

# Change the git branch we are using.
# We list the main branches from kardia (found in the kardia_vm/kardia_branches file)
# we also add in any extra 'local' branches they may have set up
function chooseKardiaGitBranch
    {
    while true; do
	lookupStatus
	#if we are shared, the files are in $BASEDIR and we must be root to change
	#otherwise, the files are in /home/user
	KBRANCH=""
	export KBRANCH
	srcdir=""
	branch_status=""
	if [ "$WKFMODE" = "shared" ]; then
	    srcdir="$BASEDIR/src/kardia-git"
	    if [ "$USER" = root ]; then
		branch_status="shared-root" 
		#
	    else
		#We have a shared space.  We need root make the change
		branch_status="shared-user" 
	    fi
	fi
	if [ "$WKFMODE" != "shared" ]; then
	    #it is individual or team.  The individual can change his own branch
	    if [ "$USER" = root ]; then
		#Root should not have their own repo
		branch_status="nonshared-root" 
		if [  "$WKFMODE" = "team" ]; then
		    branch_status="team-root" 
		    srcdir="$BASEDIR/src/kardia-git"
		fi
	    else
		srcdir="~/kardia-git"
		branch_status="nonshared-user" 
		#The user can change his own branch.
	    fi
	fi
	if [ -n "$srcdir" ]; then
	    #We can do it.  We have a known source dir
	    KBRANCH=$(cd $srcdir 2>/dev/null; git branch | grep \*| sed 's/.* //')
	    DSTR="dialog --backtitle '$TITLE' --title 'Change Branch' --menu 'Change Kardia Branch from $KBRANCH:' 15 62 14"
	else
	    DSTR="dialog --backtitle '$TITLE' --title 'Change Branch' --menu 'Change Kardia Branch:' 15 62 14"
	fi
	case "$branch_status" in
	    shared-user)
		DSTR="$DSTR --- 'You must be root to change the shared repo'"
		;;
	    shared-root|nonshared-user|team-root)
		#here we list all the items.
		filename=/tmp/branches$$
		( cd $srcdir 2>/dev/null; git branch | sed 's/.* //' > $filename ) # do it in a shell so we do not change current dir
		kbFile="$srcdir/kardia-vm/kardia_branches"
		(cat $kbFile 2> /dev/null |sed 's/ .*//'| egrep -v '#|^$' >> $filename)
		echo master >> $filename #Make sure "master" always shows up, een if kardia_branches is gone

		for line in $(cat $filename | sort -u ); do
		    rest=$(grep $line $kbFile | sed 's/^[^ ]* //' )
		    if [ "$line" = "$KBRANCH" ]; then
			DSTR="$DSTR $line '* $rest'"
		    else
			DSTR="$DSTR $line '$rest'"
		    fi
		done
		rm $filename
		DSTR="$DSTR --- ''"
		;;
	esac
	DSTR="$DSTR Quit 'Exit Kardia / Centrallix Management'"
    

	SEL=$(eval "$DSTR" 2>&1 >/dev/tty)

	case "$SEL" in
	    Quit)
		exit
	    ;;
	    ---)
	    ;;
	    '')
		break
		;;
	    *)
		(cd $srcdir; git checkout $SEL; sleep .3 )
		#echo change to branch $SEL
	    ;;
	esac
    done

    }


# Rewrite check scanner configuration
function writeCheckScannerConfig
    {
    if [ ! -f /usr/local/src/check-reader/server/config/config.toml ]; then
	if [ -f /usr/local/src/check-reader/server/config/config.template ]; then
	    cp -a /usr/local/src/check-reader/server/config/config.template /usr/local/src/check-reader/server/config/config.toml
	else
	    return 1
	fi
    fi
    if [ ! -f /usr/local/src/check-reader/server/config/auth.toml ]; then
	if [ -f /usr/local/src/check-reader/server/config/auth.template ]; then
	    cp -a /usr/local/src/check-reader/server/config/auth.template /usr/local/src/check-reader/server/config/auth.toml
	else
	    return 1
	fi
    fi
    if [ "$CKR_PORT" = "" ]; then
	CKR_PORT=8000
    fi
    if [ "$CKR_HOST" = "" ]; then
	CKR_HOST=0.0.0.0
    fi
    if [ "$CKR_KEY" = "" -o "$CKR_KEY" = "change_this" ]; then
	CKR_KEY=$(dd if=/dev/urandom bs=1 count=16 | md5sum)
    fi
    sed -i 's/^port[ 	]*=[ 	]*"\?\([0-9a-z_-]*\)"\?[ 	]*$/port = '"$CKR_PORT"'/' /usr/local/src/check-reader/server/config/config.toml
    sed -i 's/^host[ 	]*=[ 	]*"\?\([0-9a-z_-]*\)"\?[ 	]*$/host = "'"$CKR_HOST"'"/' /usr/local/src/check-reader/server/config/config.toml
    sed -i 's/^jwt_key[ 	]*=[ 	]*"\?\([0-9a-z_-]*\)"\?[ 	]*$/host = "'"$CKR_KEY"'"/' /usr/local/src/check-reader/server/config/auth.toml
    }


# Set check scanner server host
function setCheckScannerHost
    {
    lookupStatus
    if [ "$1" = "" ]; then
	DSTR="dialog --backtitle '$TITLE' --title 'Check Scanner Host' --inputbox 'Host name or IP for check scanner server:' 8 72 '$CKR_HOST'"
	CKR_HOST=$(eval "$DSTR" 2>&1 >/dev/tty)
	if [ "$?" != 0 ]; then
	    return 1
	fi
    else
	CKR_HOST="$1"
    fi
    writeCheckScannerConfig
    checkRestartScanner
    }


# Set check scanner server port
function setCheckScannerPort
    {
    lookupStatus
    if [ "$1" = "" ]; then
	DSTR="dialog --backtitle '$TITLE' --title 'Check Scanner Port' --inputbox 'Service name or port number for check scanner server:' 8 72 '$CKR_PORT'"
	CKR_PORT=$(eval "$DSTR" 2>&1 >/dev/tty)
	if [ "$?" != 0 ]; then
	    return 1
	fi
    else
	CKR_PORT="$1"
    fi
    writeCheckScannerConfig
    checkRestartScanner
    }


# Check to see if the scanner server is running, and if so, restart it.
function checkRestartScanner
    {
    lookupStatus
    if [ "$CKR_RUNNING" = "yes" ]; then
	stopCheckScanner
	sleep 0.5
	startCheckScanner
    fi
    }


# Start the check scanner server
function startCheckScanner
    {
    screenCheck Scanner
    sleep 0.1
    screen -S Scanner -p 0 -X stuff "cd /usr/local/src/check-reader/server"
    sleep 0.1
    screen -S Scanner -p 0 -X stuff "python3 app.py -c"
    sleep 0.5
    }


# Stop the check scanner server
function stopCheckScanner
    {
    screenCheck Scanner
    screenPassCtrlC Scanner
    sleep 0.1
    lookupStatus
    if [ "$CKR_RUNNING" = "yes" ]; then
	screenPassCtrlC Scanner
	sleep 5
	lookupStatus
    fi
    if [ "$CKR_RUNNING" = "yes" ]; then
	CKR_PID=$(ps auxw | grep 'python3 app.py' | grep -v grep | sed -n 's/^[^ ]\+ \+\([0-9]\+\) \+.*/\1/p')
	if [ "$CKR_PID" != "" ]; then
	    kill $CKR_PID 2>/dev/null
	    sleep 1
	    kill -9 $CKR_PID 2>/dev/null
	fi
    fi
    }


# Install the check scanner server from git
function installCheckScanner
    {
    if [ ! -d "/usr/local/src/check-reader" ]; then
	cd /usr/local/src
	git clone "$CKR_REPO" check-reader
    else
	echo "Error: check-reader server already installed."
	return 1
    fi
    cd /usr/local/src/check-reader/server
    pip3 install $CKR_FROMPIP
    writeCheckScannerConfig

    #TODO# set up check reader server database via curl API calls.
    }


# Update the check scanner server software from git
function updateCheckScanner
    {
    lookupStatus
    cd /usr/local/src/check-reader
    git pull
    pip3 install --upgrade $CKR_FROMPIP
    checkRestartScanner
    }


# Manage check scanners
function menuCheckScanner
    {
    while true; do
	lookupStatus

	if [ "$CKR_INSTALLED" = "no" ]; then
	    CKSCAN="not installed"
	elif [ "$CKR_CONNFIGURED" = "no" ]; then
	    CKSCAN="not configured"
	else
	    CKSCAN="host $CKR_HOST port $CKR_PORT"
	fi

	DSTR="dialog --backtitle '$TITLE' --title 'Check Scanner Server' --menu 'Check Scanner Server Options:' 20 72 14"
	if [ "$CKR_INSTALLED" = "no" ]; then
	    DSTR="$DSTR Install 'Install Check Scanner Server'"
	else
	    DSTR="$DSTR Host    'Set Scanner Host IP    (now: ${CKR_HOST})'"
	    DSTR="$DSTR Port    'Set Scanner TCP Port   (now: ${CKR_PORT})'"
	fi
	DSTR="$DSTR '---'  ''"
	if [ "$CKR_CONFIGURED" = "yes" ]; then
	    DSTR="$DSTR Update  'Update Check Scanner Server'"
	    if [ "$CKR_RUNNING" = "no" ]; then
		DSTR="$DSTR Start   'Start Scanner Server   (now: STOPPED)'"
	    else
		DSTR="$DSTR Stop    'Stop Scanner Server    (now: running)'"
	    fi
	    DSTR="$DSTR '---'  ''"
	fi
	DSTR="$DSTR Quit    'Exit Kardia / Centrallix Management'"

	SEL=$(eval "$DSTR" 2>&1 >/dev/tty)
	case "$SEL" in
	    Quit)
		exit
		;;
	    '---')
		;;
	    '')
		break
		;;
	    Install)
		installCheckScanner
		;;
	    Update)
		updateCheckScanner
		;;
	    Start)
		startCheckScanner
		;;
	    Stop)
		stopCheckScanner
		;;
	    Host)
		setCheckScannerHost
		;;
	    Port)
		setCheckScannerPort
		;;
	esac
    done
    }


# Configure the VM
function menuConfigure
    {
    while true; do
	lookupStatus

	if [ "$CKR_INSTALLED" = "no" ]; then
	    CKSCAN="not installed"
	elif [ "$CKR_CONNFIGURED" = "no" ]; then
	    CKSCAN="not configured"
	else
	    CKSCAN="host $CKR_HOST port $CKR_PORT"
	fi

	CXORIGIN=$(cd $BASEDIR/src/cx-git 2>/dev/null; git config --get remote.origin.url 2>/dev/null)
	CXMETHOD=${CXORIGIN%%:*}
	CXUSER=${CXORIGIN##https://}
	CXUSER=${CXUSER%%@*}
	if [ "$CXMETHOD" = "git" ]; then
	    REPSTAT="no pushes"
	elif [ "$CXMETHOD" = "https" ]; then
	    REPSTAT="via github $CXUSER"
	else
	    REPSTAT="no repository"
	fi

	MCXORIGIN=$(cd ~/cx-git 2>/dev/null; git config --get remote.origin.url 2>/dev/null)
	MCXMETHOD=${MCXORIGIN%%:*}
	MCXUSER=${MCXORIGIN##https://}
	MCXUSER=${MCXUSER%%@*}
	if [ "$MCXMETHOD" = "git" ]; then
	    MREPSTAT="no pushes"
	elif [ "$MCXMETHOD" = "https" ]; then
	    MREPSTAT="via Github $MCXUSER"
	elif [ "$MCXORIGIN" = "$BASEDIR/src/cx-git" -o "$MCXORIGIN" = "$BASEDIR/src/cx-git/.git" ]; then
	    MREPSTAT="via shared repo"
	else
	    MREPSTAT="no repository"
	fi
	DSTR="dialog --backtitle '$TITLE' --title 'Configuration' --menu 'Config Options:' 20 72 14"
	Rootable && DSTR="$DSTR Hostname  'Set the Hostname   (now: $HOST)'"
	Rootable && DSTR="$DSTR RunMode   'Set Run Mode       (now: $RUNMODE)'"
	Rootable && DSTR="$DSTR DevelMode 'Set Devel. Mode    (now: $DEVMODE)'"
	Rootable && DSTR="$DSTR WorkMode  'Set Workflow Mode  (now: $WKFMODE)'"
	Rootable && DSTR="$DSTR MySQLAccess  'Set MySQL Access   (now: $MYSQLMODE)'"
	DSTR="$DSTR SUser                 'Shared Repo Pushes (now: $REPSTAT)'"
	Rootable && DSTR="$DSTR SInit 'Init Shared Repository (destructive)'"
	DSTR="$DSTR CKardiaBranch 'Change git branch for Kardia'"
	if [ "$WKFMODE" != "shared" -a "$USER" != root ]; then
	    DSTR="$DSTR '---'  ''"
	    if [ "$WKFMODE" = individual ]; then
		DSTR="$DSTR IUser         'My Repo Pushes     (now: $MREPSTAT)'"
	    fi
	    DSTR="$DSTR IInit 'Init My ($USER) Repository (destructive)'"
	fi
	DSTR="$DSTR '---'  ''"
	if [ "$USER" != root -a "$WKFMODE" != "shared" ]; then
	    DSTR="$DSTR Name 'Set Name  (now: $USER_NAME)'"
	    DSTR="$DSTR Email 'Set Email (now: $USER_EMAIL)'"
	    DSTR="$DSTR '---' ''"
	fi
	Rootable && DSTR="$DSTR Scanner   'Check Scanner Server (now: $CKSCAN)'"
	Rootable && DSTR="$DSTR '---' ''"
	DSTR="$DSTR Quit 'Exit Kardia / Centrallix Management'"

	SEL=$(eval "$DSTR" 2>&1 >/dev/tty)
	case "$SEL" in
	    Quit)
		exit
		;;
	    '---')
		;;
	    '')
		break
		;;
	    Hostname)
		AsRoot setHostname
		;;
	    IUser)
		repoSetStatus "/home/$USER"
		;;
	    IInit)
		repoInitUser
		;;
	    SUser)
		repoSetStatus "$BASEDIR/src"
		;;
	    SInit)
		AsRoot repoInitShared
		;;
	    CKardiaBranch)
		chooseKardiaGitBranch
		;;
	    Name)
		setGitName "/home/$USER"
		;;
	    Email)
		setGitEmail "/home/$USER"
		;;
	    RunMode)
		AsRoot menuRunMode
		;;
	    MySQLAccess)
		AsRoot menuMysqlAccessMode
		;;
	    DevelMode)
		AsRoot menuDevelMode
		;;
	    WorkMode)
		AsRoot menuWorkflowMode
		;;
	    Scanner)
		AsRoot menuCheckScanner
		;;
	esac
    done
    }


# Update and rebuild Centrallix and Kardia
# $1 is the $SEL variable from doSystemUpdate.
function doCxkUpdates
    {
    CXKSEL="$1"
    if [ "${CXKSEL%%Source*}" != "$SEL" ]; then
	quickPullUpdate
    fi
    if [ "${CXKSEL%%Centrallix*}" != "$SEL" ]; then
	doBuild
    fi
    if [ "${CXKSEL%%Data*}" != "$SEL" ]; then
	AsRoot doDataBuild
    fi
    }


# Completely update the VM...
function doSystemUpdate
    {
    DSTR="dialog --backtitle '$TITLE' --title 'Full System Update' --checklist 'Select Options to Update:' 20 72 14"
    Rootable && DSTR="$DSTR CentOS 'Update Base CentOS Install' on"
    if [ "$USER" != root -o "$WKFMODE" == shared -o "$DEVMODE" == root ]; then
	DSTR="$DSTR Source 'Pull Updates from Sourceforge' on"
	DSTR="$DSTR Centrallix 'Rebuild Centrallix Server' on"
	DSTR="$DSTR Data 'Rebuild Kardia Database' on"
    else
	DSTR="$DSTR Source '(as a user) Pull Updates from Sourceforge' on"
	DSTR="$DSTR Centrallix '(as a user) Rebuild Centrallix Server' on"
	DSTR="$DSTR Data '(as a user) Rebuild Kardia Database' on"
    fi
    Rootable && DSTR="$DSTR Menus 'Update VM Menu Interface (from Shared Repo)' on"

    SEL=$(eval "$DSTR" 2>&1 >/dev/tty)
    if [ "$?" != 0 ]; then
	return 1
    fi

    # Update base install?
    if [ "${SEL%%CentOS*}" != "$SEL" ]; then
	AsRoot doUpdates
    fi

    # Update Kardia and Centrallix?
    if [ "${SEL%%Source*}" != "$SEL" -o "${SEL%%Centrallix*}" != "$SEL" -o "${SEL%%Data*}" != "$SEL" ]; then
	if [ "$USER" != root -o "$WKFMODE" == shared -o "$DEVMODE" == root ]; then
	    doCxkUpdates "$SEL"
	else
	    AsUser doCxkUpdates "$SEL"
	fi
    fi

    # Update menu interface?
    if [ "${SEL%%Menus*}" != "$SEL" ]; then
	AsRoot UpdateMenus
    fi
    }

########################
## Cleanup stuff #################
## Prep the vm for distribution ##
##################################

#########
## VAR ##
function vm_prep_cleanSystemTree
{
	echo "Cleaning /var directory, tmp, and /usr/share"
	echo "  Cleaning mysql/mariadb"
	systemctl stop mariadb
	rm -rf /var/lib/mysql/*
	echo
	echo "  Cleaning logs"
	find /var/log -type f -exec rm {} \;
	echo
	echo "  Cleaning /tmp"
	find /tmp -mtime +5 -exec rm -rf {} \;
	echo
	echo "  Cleaning /usr/share/doc"
	rm -rf /usr/share/doc/* 2>/dev/null
	echo
	echo "  Cleaning mail"
	rm /var/spool/mail/* 2>/dev/null
	echo
	echo "  Cleaning random seed"
	rm /var/lib/systemd/random-seed 2>/dev/null
	echo

}

#########
## YUM ##
function vm_prep_cleanYum
{
	echo "Making sure all critical packages are installed"
	checkAndInstallRequiredPackages
	echo "Install liquibase if needed"
	installLiquibaseIfNeeded
	echo "Cleaning YUM"
	yum clean all
	echo
	echo "Cleaning RPM"
	rpm --rebuilddb
	echo
}

#################
# Etc directory #
function vm_prep_setupEtc
{
	mkdir -p /etc/samba /etc/pam-script /etc/systemd/system
	files="issue.kardia issue.kardia-init pam.d/system-auth.kardia samba/smb.conf.noshares samba/smb.conf.onerepo samba/smb.conf.userrepo ssh/sshd_config.kardia pam-script/pam_script_passwd pam.d/system-auth.kardia systemd/system/kardiaVM-startup.service systemd/system/centrallix.service logrotate.d/centrallix dracut.conf.d/kardia_vm.conf"
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

	####################
	# Set the hostname
	echo "Changing the VM Hostname"
	N_HOST="KardiaVM"
	echo "$N_HOST" > /etc/hostname
	/bin/hostname "$N_HOST"
	echo

	####################
	# make sure the startup service runs
	systemctl enable kardiaVM-startup
}

###########
# SELINUX ##################################################
function vm_prep_setupSelinux
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
function vm_prep_cleanNetwork
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
	if [ "$USE_FIREWALLD" = "enabled" ]; then
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
	fi
	echo
}


###########
# SELINUX ##################################################
#Change the sysconfig file selinux enabled line to "enabled"
function vm_prep_cleanSelinux
{
	echo "Ensuring SELINUX is enabled"
	sed -i -e "s/^SELINUX=.*/SELINUX=enabled/" /etc/sysconfig/selinux
	echo
}

###########
### SSH #######################################################
# Remove the server ssh keys.  They will be regenerated on boot
# also remove the root ssh keys and authorized hosts files
function vm_prep_cleanSSH
{
	echo "Removing ssh keys and ssh info"
	rm -vf /etc/ssh/*key*
	rm -rvf /root/.ssh
	echo
}


###########
## FILES #########################################
# Clean up the contents of history and other files
function vm_prep_cleanFiles
{
    cxfiles="/usr/local/sbin/centrallix /usr/local/sbin/cxpasswd /usr/local/etc/centrallix /usr/local/etc/kardia_pw.txt /usr/local/etc/centrallix/kardia-auth"
    cxlibs="/usr/local/lib/StPar* /usr/local/centrallix/ /usr/local/libCentrallix*"
    cxinc="/usr/local/include/cxlib/"
    cxetc="/etc/init.d/centrallix"
    kardiash="/usr/local/src/.initialized /usr/local/src/.cx* /usr/local/src/.mysqlaccess /usr/local/etc/autossh.conf /usr/local/etc/centrallix.conf /usr/local/etc/linksigningkey.txt /usr/local/etc/cifs.conf /usr/local/etc/duplicity.conf /usr/local/etc/rc.d/"
    gitfiles="/usr/local/src/cx-git /usr/local/src/kardia-git"
	echo "Cleaning up Filesystem"
	echo "  Cleaning up history"
	echo "kardia.sh" > /root/.bash_history
	echo "  Cleaning root git info"
	echo > /root/.gitconfig
	echo "  Cleaning root cxhistory"
	echo > /root/.cxhistory
	echo "  Cleaning root mysql_history"
	echo > /root/.mysql_history
	echo "  Cleaning root less history"
	echo > /root/.lesshst
	echo "  Cleaning root vim history"
	echo > /root/.viminfo

	#clean out all the crontabs we added using kardia
	cleanKardiaCrontabs

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
	echo "Removing old log files"
	find /var/log -name *-$(date +%Y)* -type f -print0 | xargs -0 rm -f --

	echo 
}

function vm_prep_cleanKernel
{
    echo "Uninstalling old kernel versions"
    echo "We will try twice to fix dependancies"
    local LATEST="kernel-3.10.0-123"
    cd /boot
    LATEST=$(ls vmlinuz-* | grep -v rescue | sed 's/vmlinuz-//;s/.el.*//' | sort -n | tail -1)
    rpm -qa kernel* | grep -v $LATEST | while read line; do 
	echo "Removing package: $line"
	rpm -e $line; 
    done
    rpm -qa kernel* | grep -v $LATEST | while read line; do 
	echo "Removing package: $line"
	rpm -e $line; 
    done
}

######################
###  Kardia Users  #######################################
function vm_prep_cleanUsers
{
	#remove users
	echo "Removing any Kardia Users"
	for USERNAME in $(grep -- '- Kardia:' /etc/passwd | sed 's/^\([^:]*\):[^:]*:\([^:]*\):.*/\1/') kardia; do
	    if [ -n "$( grep $USERNAME /etc/passwd )" ]; then
		killall -u $USERNAME 2>/dev/null
		echo "  removing Kardia user $USERNAME from linux"
		userdel -r $USERNAME 2>/dev/null
		echo "  removing Kardia user $USERNAME from samba"
		pdbedit -u $USERNAMR -x 2>/dev/null
		echo "  removing mysql user $USERNAME"
		mysql -e "DROP USER $USERNAME@'localhost';" 2> /dev/null
		mysql -e "DROP USER $USERNAME@'%';" 2> /dev/null
	    fi
	done
	echo "Dropping Kardia_DB"
	mysql -e "DROP DATABASE Kardia_DB;" 2>/dev/null
}

###################
### Empty Space #######################################
# Fill the empty space on the disk for easy compressing 
function vm_prep_cleanEmptySpace
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

function doCleanup
    {
    if [ $# -eq 0 ]; then
	#stop Centrallix
        cxStop
	#make sure things are copied over from the repo
	vm_prep_setupEtc
	#clean out yum cache and clean up RPM database
	vm_prep_cleanYum
	#clean up network settings
	vm_prep_cleanNetwork
	#clean up a number of things on the system
	vm_prep_cleanSystemTree
	#make sure selinux is enabled
	vm_prep_cleanSelinux
	#wipe ssh keys
	vm_prep_cleanSSH
	#clean up .history files and any extra users
	vm_prep_cleanFiles
	#clean up kernel
	vm_prep_cleanKernel
	#remove Kardia users
	vm_prep_cleanUsers
	#zero out empty space so it compresses nicely
	vm_prep_cleanEmptySpace
	#
	echo "Reindexing the server: updatedb"
	updatedb
	#
	version_line=$( sed -n '/VERSION=/=' /usr/local/bin/kardia.sh | head -1 )
	echo "This VM is prepped to be rolled out"
	echo "The version is: $VERSION (update in kardia.sh on line $version_line)"
	echo "Ensure the root password is set to what the PDF says it will be"
    else
	command="$1"
	wholecmd="$@"
	if [ "$command" != "" ]; then
	    if [ "$(type -t $command)" = "function" ]; then
		"$wholecmd"
		exit
	    elif [ "$(type -t vm_prep_$command)" = "function" ]; then
		vm_prep_"$wholecmd"
	    elif [ "$(type -t vm_prep_clean$command)" = "function" ]; then
		vm_prep_clean"$wholecmd"
		exit
	    elif [ "$(type -t vm_prep_setup$command)" = "function" ]; then
		vm_prep_setup"$wholecmd"
		exit
	    fi
	fi
    fi
    }

function doGiveUserKardiaSysadmin
    {
	TUSER=$1;
	if [ -z "$TUSER" ]; then
	    echo "You must specify a user to give permissions to"
	    return
	fi
	echo "INSERT INTO s_sec_endorsement (s_endorsement,s_context, s_subject, s_date_created, s_created_by, s_date_modified, s_modified_by) VALUES ('kardia:sys_admin','kardia','u:THEUSER',curdate(),'THEUSER',curdate(),'THEUSER');" | sed "s/THEUSER/$TUSER/g" | mysql -u root Kardia_DB 2> /dev/null
    }
function doRemoveUserKardiaSysadmin
    {
	TUSER=$1;
	if [ -z "$TUSER" ]; then
	    echo "You must specify a user to take permissions from"
	    return
	fi
	echo "DELETE FROM s_sec_endorsement WHERE s_subject='u:THEUSER';" | sed "s/THEUSER/$TUSER/g" | mysql -u root Kardia_DB 2> /dev/null
    }

#Create a kardia unix user for use with shell scripts
function doCreateKardiaUnixUser
    {
	if [ -z "$( grep kardia /etc/passwd )" ]; then
	    #create a password
	    KARDPW=$(dd if=/dev/random bs=1 count=16 2>/dev/null| md5sum | head -c 30)
	    #store the password
	    echo $KARDPW > /usr/local/etc/kardia_pw.txt
	    chmod 400 /usr/local/etc/kardia_pw.txt
	    ln -s /usr/local/etc/kardia_pw.txt /usr/local/etc/centrallix/kardia-auth
	    #create the kardia user
	    useradd -r kardia
	    #set the password for the kardia user
	    echo kardia:$KARDPW | chpasswd
	    #grant the kardia user sysadmin privs so they can do cron
	    doGiveUserKardiaSysadmin kardia
	fi
    }

#
# addKardiaCrontabs - add the crontabs listed in kardia-git/kardia-scripts/cron 
#
function addKardiaCrontabs
    {
	for onefile in /usr/local/src/kardia-git/kardia-scripts/cron/*; do
	    echo $onefile
	    if [ -f $onefile ]; then
		c_name=$( (grep NAME $onefile || echo $onefile) | sed 's/^#.* //')
		c_minute=$( (grep MINUTE $onefile || echo \* ) | sed 's/^#.* //')
		c_hour=$( (grep HOUR $onefile || echo \* ) | sed 's/^#.* //')
		c_dom=$( (grep DOM $onefile || echo \*) | sed 's/^#.* //')
		c_month=$( (grep MONTH $onefile || echo \* )| sed 's/^#.* //')
		c_day=$( (grep DAY $onefile || echo \*) | sed 's/^#.* //')
		c_who=$( (grep WHO $onefile || echo root) | sed 's/^#.* //')

		#echo "$c_name" "$c_minute" "$c_hour" "$c_dom" "$c_mon" "$c_day" "$c_who" "$onefile"
		addNewCron "$c_name" "$c_minute" "$c_hour" "$c_dom" "$c_month" "$c_day" "$c_who" "$onefile"
	    fi
	done

    }

#
# cleanKardiaCrontabs - remove all the kardia crontabs, most of which call files in kardia-git
#
function cleanKardiaCrontabs
    {
    echo cleaning crontabs
    for onefile in /etc/cron.d/*; do
	if [ -n "`grep -i kardia $onefile`" ]; then
	    echo $onefile is kardia
	    rm $onefile
	else
	    echo $onefile is not kardia
	fi
    done
    }

#
# editAllCron - manage all configured /etc/cron.d scripts, except for 0hourly
#
function editAllCron
    {
    while true; do
	DSTR="dialog --backtitle '$TITLE' --title 'Edit Cron Tasks' --menu 'Edit Cron Tasks' 20 72 14"
	for CRONPATH in /etc/cron.d/*; do
	    CRONFILE=${CRONPATH##*/}
	    CRONCMD=$(cat "$CRONPATH" | sed -n 's/^[^ ]* [^ ]* [^ ]* [^ ]* [^ ]* [^ ]* //p')
	    CRONENABLE=$(grep "^[^#].*$CRONCMD" "$CRONPATH")
	    if [ "$CRONENABLE" != "" ]; then
		DSTR="$DSTR ${CRONFILE} '${CRONCMD}'"
	    else
		DSTR="$DSTR ${CRONFILE} '(disab) ${CRONCMD}'"
	    fi
	done
	DSTR="$DSTR '---' '------'"
	DSTR="$DSTR New 'New Cron Job'"
	DSTR="$DSTR Quit 'Exit Kardia / Centrallix Management'"

	SEL=$(eval "$DSTR" 2>&1 >/dev/tty)
	case "$SEL" in
	    Quit)
		exit
		;;
	    New)
		addNewCron
		;;
	    '')
		break
		;;
	    '---')
		break
		;;
	    *)
		readCron "/etc/cron.d/${SEL}"
		editCronFull "/etc/cron.d/${SEL}" "${cron_command}"
		;;
	esac
    done
    }

#
# addNewCron - create a new cron entry in cron.d
#
function addNewCron
    {
    local CRONNAME="$1"

    if [ "$CRONNAME" != "" ]; then
	export cron_minute="$2"
	export cron_hour="$3"
	export cron_dom="$4"
	export cron_month="$5"
	export cron_day="$6"
	export cron_who="$7"
	local CRONCMD="$8"

	if [ "$CRONNAME" = "" -o "$CRONCMD" = "" ]; then
	    echo "addNewCron: must supply: cronname min hr dom mon day who cmd"
	    return
	fi

	writeCron "/etc/cron.d/${CRONNAME}" "$CRONCMD"
    else
	export cron_minute="*"
	export cron_hour="*"
	export cron_dom="*"
	export cron_month="*"
	export cron_day="*"
	export cron_who="root"
	editCronFull
    fi
    }

#readCron - Pass filename first, followed by the command (in case no such cron exists yet)
# readCron /etc/cron.kardia.d/backup /usr/local/bin/kardia.sh doBackup
function readCron
    {
    #first parameter is the filename
    cronFile="$1"
    shift
    sentCommand="$*"
    if [ -n "$cronFile" -a -e "$cronFile" ]; then
	#We were passed a cron file and it exists
	while read a b c d e f g; do 
	    export cron_minute="$a"
	    export cron_hour="$b" 
	    export cron_dom="$c" 
	    export cron_month="$d" 
	    export cron_day="$e" 
	    export cron_who="$f" 
	    export cron_command="$g" 
	done < $cronFile
	#echo "$cron_hour $cron_minute $cron_day $cron_dom $cron_month $cron_who $cron_command"
    else
	#defaults
	export cron_hour=22
	export cron_minute=15
	export cron_dom="*"
	export cron_month="*"
	export cron_day="Mon,Tue,Wed,Thu,Fri"
	export cron_who=root
	export cron_command=sentCommand
    fi
    export cron_Sun=off
    export cron_Mon=off
    export cron_Tue=off
    export cron_Wed=off
    export cron_Thu=off
    export cron_Fri=off
    export cron_Sat=off
    alldays=$(echo $cron_day | sed 's/,/ /g')
    for oneday in $alldays; do
	case $oneday in
	    0|7|Sun)
		cron_Sun=on
		;;
	    1|Mon)
		cron_Mon=on
		;;
	    2|Tue)
		cron_Tue=on
		;;
	    3|Wed)
		cron_Wed=on
		;;
	    4|Thu)
		cron_Thu=on
		;;
	    5|Fri)
		cron_Fri=on
		;;
	    6|Sat)
		cron_Sat=on
		;;
	esac
		
    done
    }

function writeCron
    {
    #first parameter is the filename
    cronFile="$1"
    shift
    sentCommand="$*"
    #use the command in the cronfile if we did not pass one in
    if [ -z "$sentCommand" ]; then
	sentCommand=$cron_command
    fi

    if [ -n "$cronFile" ]; then
	#make the directory if it does not yet exist
	cronDir=`dirname $cronFile`
	#echo "Making crondir $cronDir for cronfile $cronFile"
	mkdir -p $cronDir

#Make sure we have the paths set up for the cron and other default info
cat > $cronFile << EOF
#A Kardia cron file
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin:/usr/local/sbin
MAILTO=root
EOF
#Now, put the cron command into the file
	echo "$cron_minute $cron_hour $cron_dom $cron_month $cron_day $cron_who $sentCommand" >> $cronFile
	chmod 600 "$cronFile"
    fi
    }

#editCronFull - Pass filename first, followed by the command (in case no such cron exists yet)
# editCronFull /etc/cron.d/backup /usr/local/bin/kardia.sh doAutoBackup
function editCronFull
    {
    #first parameter is the filename
    cronFile="$1"
    shift
    sentCommand="$*"

    #read the cronfile
    if [ "$cronFile" != "" ]; then
	readCron "$cronFile" "$sentCommand"
    fi

    local cronName=${cronFile#/etc/cron.d/}
    cronName=${cronName%.sh}

    local cronEnabled=yes;
    if [ "${cron_minute###}" != "$cron_minute" ]; then
	cronEnabled=no
	cron_minute="${cron_minute###}"
    fi

    DSTR="dialog --title 'Edit Cron $cronFile' --backtitle '$TITLE' --form"
    DSTR="$DSTR 'Edit Cron' 0 0 0"
    DSTR="$DSTR 'Name:' 1 1 '$cronName' 1 20 40 0"
    DSTR="$DSTR 'Command:' 3 1 '$sentCommand' 3 20 40 0"
    DSTR="$DSTR 'Enabled (yes/no):' 5 1 '$cronEnabled' 5 20 5 0"
    DSTR="$DSTR 'Minute(s):' 7 1 '$cron_minute' 7 20 16 0"
    DSTR="$DSTR 'Hour(s):' 9 1 '$cron_hour' 9 20 16 0"
    DSTR="$DSTR 'Day(s) of Month:' 11 1 '$cron_dom' 11 20 16 0"
    DSTR="$DSTR 'Month(s):' 13 1 '$cron_month' 13 20 16 0"
    DSTR="$DSTR 'Day(s) of Week:' 15 1 '$cron_day' 15 20 16 0"

    eval "$DSTR" 2>&1 >/dev/tty |
	{
	read cron_name; read cron_cmd; read cron_ena; read cron_minute; read cron_hour; read cron_dom; read cron_month; read cron_day; 
	if [ -z "$cron_hour" -a -z "$cron_minute" ]; then
	    #they probably canceled
	    return
	fi
	if [ -z "$cron_hour" ]; then
	    echo "Invalid hour."; sleep 2; return
	fi
	if [ -z "$cron_minute" ]; then
	    echo "Invalid minute."; sleep 2; return
	fi
	if [ -z "$cron_day" ]; then
	    echo "Invalid day of week."; sleep 2; return
	fi
	if [ -z "$cron_dom" ]; then
	    echo "Invalid day of month."; sleep 2; return
	fi
	if [ -z "$cron_month" ]; then
	    echo "Invalid month."; sleep 2; return
	fi
	if isNo "$cron_ena"; then
	    cron_minute="#${cron_minute}"
	fi
	if [ "$cron_name" != "$cronName" ]; then
	    if [ "$cronFile" != "" ]; then
		/bin/rm "$cronFile"
	    fi
	    cronFile="/etc/cron.d/${cron_name}"
	fi
	if [ "$cron_cmd" != "" -a "$cron_cmd" != "$sentCommand" ]; then
	    sentCommand="$cron_cmd"
	fi

	# write the new/updated cron file
	if [ "$cronFile" != "" -a "$sentCommand" != "" ]; then
	    writeCron "$cronFile" "$sentCommand"
	fi
	}
    }

#editCronTime - needs to have the cron file read before this is called
function editCronTime
    {
    DSTR="dialog --title 'Edit Cron $cronFile' --backtitle '$TITLE' --form"
    DSTR="$DSTR 'Edit Cron' 0 0 0"
    DSTR="$DSTR 'Hour(s):' 3 1 '$cron_hour' 3 36 30 0"
    DSTR="$DSTR 'Minute(s):' 5 1 '$cron_minute' 5 36 30 0"

    SEL=$(eval "$DSTR" 2>&1 >/dev/tty)
    if [ $? -eq 0 ]; then
	set $SEL
	cron_hour=$1
	cron_minute=$2
    else
	return 1
    fi
    }

#editCronDays - needs to have the cron file read before this is called
function editCronDays
    {

    DSTR="dialog --title 'Edit Cron $cronFile' --backtitle '$TITLE'"
    DSTR="$DSTR --checklist 'Select The Days for the cron job' 0 0 0"
    DSTR="$DSTR Sun Sunday $cron_Sun"
    DSTR="$DSTR Mon Monday $cron_Mon"
    DSTR="$DSTR Tue Tuesday $cron_Tue"
    DSTR="$DSTR Wed Wednesday $cron_Wed"
    DSTR="$DSTR Thu Thursday $cron_Thu"
    DSTR="$DSTR Fri Friday $cron_Fri"
    DSTR="$DSTR Sat Saturday $cron_Sat"

    daystr=""
    Chosen=$(eval "$DSTR" 2>&1 >/dev/tty)
    if [ $? -eq 0 ]; then
	for a in $Chosen; do
	    [ -n "$daystr" ] && daystr="$daystr,"
	    daystr="$daystr$a"
	done
	cron_day=$daystr
    else
	#return an error code so we know it was canceled
	return 1
    fi
    }

function editCron
    {
    cronFile="$1"
    shift
    sentCommand="$*"

    #read the cronfile
    readCron "$cronFile" "$sentCommand"

    editCronTime

    if [ $? -eq 0 ]; then
	editCronDays
	if [ $? -eq 0 ]; then
	    writeCron "$cronFile" "$sentCommand"
	fi
    fi

    }

#Autossh autossh
function menuAutossh
    {
    while true; do
	lookupStatus
	HOST=$(/bin/hostname)
	if [ "$AUTOSSH_ENABLED" = "yes" ]; then
	    status=enabled
	else
	    status=disabled
	fi
	DSTR="dialog --backtitle '$TITLE' --title 'Autossh' --cancel-label 'Back' --menu 'Administrate Autossh' 20 72 14" 
	DSTR="$DSTR Configure 'Configure Autossh'"
	DSTR="$DSTR EnableDisable 'Enable / Disable Autossh($status)'"
	if [ "$AUTOSSH_RUNNING" = "yes" ]; then
	    DSTR="$DSTR Stop 'Stop Autossh (running)'"
	else
	    DSTR="$DSTR Start 'Start Autossh (not running)'"
	fi
	DSTR="$DSTR Status 'Show status of autossh for debugging'"
	DSTR="$DSTR Quit 'Exit Kardia / Centrallix Management'"

	SEL=$(eval "$DSTR" 2>&1 >/dev/tty)
	case "$SEL" in
	    Quit)
		exit
		;;
	    Configure)
		menuConfigureAutossh
		;;
	    Start)
		doStartAutossh
		;;
	    Stop)
		doStopAutossh
		;;
	    Status)
		AsRoot systemctl status kardiaVM-startup
		echo 
		echo -n "Press enter to continue: > "
		read line
		;;
	    EnableDisable)
		menuEnableDisableAutossh
		;;
	    '')
		break
		;;
	esac
    done
    }

function doStartAutossh
    {
    lookupStatus
    if [ "$AUTOSSH_ENABLED" = "yes" ]; then
	autossh=$(which autossh 2>/dev/null)
	if [ -n $autossh ]; then
	    #we are ready to run it
	    LSSH=$(($AUTOSSH_BASE + 22))
	    LWEB=$(($AUTOSSH_BASE + 80))
	    LSSL=$(($AUTOSSH_BASE + 43))
	    cmd="$autossh -f -M 0 -p $AUTOSSH_PORT $AUTOSSH_USER@$AUTOSSH_HOST -N -R $LSSH:localhost:22 -R $LWEB:localhost:843 -R $LSSL:localhost:800"
	    if [ "$AUTOSSH_RUNNING" = "yes" ]; then
		echo "Autossh already running.  Please stop it first"
	    else
		#run it
		$cmd
		logger -t "kardia.sh" "Starting autossh $AUTOSSH_USER@$AUTOSSH_HOST"
		sleep 1
	    fi
	fi
    else
	echo "Autossh is disabled via configuration.  Please enable it and try again"
	sleep 2
    fi
    }

function doStopAutossh
    {
    lookupStatus
    if [ "$AUTOSSH_ENABLED" = "yes" ]; then
	autossh=$(which autossh 2>/dev/null)
	if [ -n $autossh ]; then
	    if [ "$AUTOSSH_RUNNING" = "yes" ]; then
		killall autossh
		logger -t "kardia.sh" "Stopping autossh"
		sleep 1
	    else
		echo "Autossh not yet running. Nothing done."
	    fi
	fi
    else
	echo "Autossh is disabled via configuration.  Please enable it and try again"
	sleep 2
    fi
    }

function menuEnableDisableAutossh
    {
    lookupStatus
    if [ "$AUTOSSH_ENABLED" = "yes" ]; then
	en=on
	ds=off
    else
	en=off
	ds=on
    fi
    DSTR="dialog --backtitle '$TITLE' --title 'Enable/Disable Autossh' --radiolist 'Autossh:' 16 72 10"
    DSTR="$DSTR enabled 'Enable Autossh' $en"
    DSTR="$DSTR disabled 'Disable Autossh' $ds"

    SEL=$(eval "$DSTR" 2>&1 >/dev/tty)
    
    if [ -n "$SEL" ]; then
	#we have chosen one of them
	if [ "$SEL" = "enabled" ]; then
	    export AUTOSSH_ENABLED=yes
	    doWriteAutosshConfiguration
	    #enable it, then start it
	    doStartAutossh
	    echo "Enabled at boot.  Starting autossh now"
	else
	    #stop it while it is enabled, then disable it
	    doStopAutossh
	    #Now, change the configuration
	    export AUTOSSH_ENABLED=no
	    doWriteAutosshConfiguration
	    echo "Disabled at boot.  Stopping autossh now"
	fi
	sleep 2 
    fi
    }

function doWriteAutosshConfiguration
    {
	if [ -n "$AUTOSSH_USER" -a -n "$AUTOSSH_HOST" -a -n "$AUTOSSH_BASE" ]; then
	    echo "USER=$AUTOSSH_USER" >$AUTOSSH_CONF
	    echo "HOST=$AUTOSSH_HOST" >>$AUTOSSH_CONF
	    echo "PORT=$AUTOSSH_PORT" >>$AUTOSSH_CONF
	    echo "BASE=$AUTOSSH_BASE" >>$AUTOSSH_CONF
	    echo "ENABLED=$AUTOSSH_ENABLED" >>$AUTOSSH_CONF
	fi
    }

function menuConfigureAutossh
    {
    while true; do
	lookupStatus
	DSTR="dialog --title 'Configure AutoSSH' --backtitle 'Configure AutoSSH' --form"
	DSTR="$DSTR 'Configure AutoSSH to allow remote connections to this host.' 0 0 0"
	DSTR="$DSTR 'DestUser:' 1 1 '$AUTOSSH_USER' 1 26 30 0"
	DSTR="$DSTR 'DestHost:' 3 1 '$AUTOSSH_HOST' 3 26 30 0"
	DSTR="$DSTR 'DestPort:' 5 1 '$AUTOSSH_PORT' 5 26 5 0"
	DSTR="$DSTR 'DestBasePort:' 7 1 '$AUTOSSH_BASE' 7 26 30 0"

	echo $DSTR
 
	ANS=$(eval "$DSTR" 2>&1 >/dev/tty | 
	    {
	    read N_USER; read N_HOST; read N_PORT; read N_BASE
	    if [ -z "$N_USER" -a -z "$N_HOST" -a -z "$N_BASE" ]; then
		return 0 #We are canceling out, or nothing defined	
	    fi
	    #We need to test before we commit
	    #try a silent ssh that would fail if something wrong to get an error
	    #if the error is such that we need a key, try doing ssh-copy-id
	    #see where we go from that

	    echo Testing settings
	    target="$N_USER@$N_HOST"
	    working=$( ssh -oBatchMode=yes -oStrictHostKeyChecking=no -oConnectTimeout=3 -p $N_PORT $target ls 2>&1 )
	    #track the response
	    response=$?
	    #echo working = $working
	    #echo response = $response
	    #we are looking for "Permission denied (publickey,password)."
	    
	    if [ $response -ne 0 ]; then
		if [ -n "$( echo $working | grep publickey )" ]; then
		    echo ---------------------------------------------------
		    echo Trying to push the id to the server with ssh-copy-id
		    echo Enter the password for $N_USER if prompted for it
		    echo ---------------------------------------------------
		    #create an RSA key if we need one
		    if [ ! -e ~/.ssh/id_rsa ]; then
			# generate a ssh key for this user
			ssh-keygen -q -t rsa -N "" -f ~/.ssh/id_rsa
		    fi
		    #we believe we can fix it by doing ssh-copy-id
		    ssh-copy-id -p $N_PORT $target
		    export hostfile=~/.ssh/known_hosts
		    ( cat $hostfile; ssh-keyscan -p$N_PORT $N_HOST )2>/dev/null|  sort -u > $hostfile
		    echo ---------------------------------------------------
		    echo We will return to the menu and try again now that
		    echo We think it is fixed.
		    AUTOSSH_USER=$N_USER;
		    AUTOSSH_PORT=$N_PORT;
		    AUTOSSH_HOST=$N_HOST;
		    AUTOSSH_PATH=$N_BASE;
		    doWriteAutosshConfiguration
		    set +x
		    sleep 2
		else
		    echo There is an error we cannot fix:
		    echo "ERROR: $working"
		    exit
		fi
	    else
		if [ -n "$N_USER" -a -n "$N_HOST" -a -n "$N_BASE" ]; then
		    AUTOSSH_USER=$N_USER;
		    AUTOSSH_PORT=$N_PORT;
		    AUTOSSH_HOST=$N_HOST;
		    AUTOSSH_PATH=$N_BASE;
		    doWriteAutosshConfiguration
		    return 0
		else
		    echo Missing some settings - not saved 1>&2
		    sleep 2
		    break
		    return 1
		fi

	    fi
	    return 1
	    } 1>&2)
	if [ $? -eq 0 ]; then
	    break	
	fi
    done
    }

#Backup

function menuConfigureBackup
    {
    while true; do
	lookupStatus
	DSTR="dialog --title 'Define Backup' --backtitle 'Define Backup' --form"
	DSTR="$DSTR 'Configure an SSH backup.  Enter a username, host, port, and destination path on the host.' 0 0 0"
	DSTR="$DSTR 'DestUser:' 1 1 '$DUPLICITY_USER' 1 26 30 0"
	DSTR="$DSTR 'DestHost:' 3 1 '$DUPLICITY_HOST' 3 26 30 0"
	DSTR="$DSTR 'DestPort:' 5 1 '$DUPLICITY_PORT' 5 26 5 0"
	DSTR="$DSTR 'DestPath:' 7 1 '$DUPLICITY_PATH' 7 26 30 0"

	echo $DSTR
 
	ANS=$(eval "$DSTR" 2>&1 >/dev/tty | 
	    {
	    read N_USER; read N_HOST; read N_PORT; read N_PATH
	    if [ -z "$N_USER" -a -z "$N_HOST" -a -z "$N_PATH" ]; then
		echo "Missing information. No port, user, or host"
		sleep 1
		return 0 #We are canceling out, or nothing defined	
	    fi
	    #We need to test before we commit
	    #try a silent ssh that would fail if something wrong to get an error
	    #if the error is such that we need a key, try doing ssh-copy-id
	    #see where we go from that
	    echo Testing settings
	    target="$N_USER@$N_HOST"
	    working=$( ssh -oBatchMode=yes -oStrictHostKeyChecking=no -oConnectTimeout=3 -p $N_PORT $target ls 2>&1 )
	    #track the response
	    response=$?
	    #echo working = $working
	    #echo response = $response
	    #we are looking for "Permission denied (publickey,password)."
	    
	    if [ $response -ne 0 ]; then
		if [ -n "$( echo $working | grep publickey )" ]; then
		    echo ---------------------------------------------------
		    echo Trying to push the id to the server with ssh-copy-id
		    echo Enter the password for $N_USER if prompted for it
		    echo ---------------------------------------------------
		    #we believe we can fix it by doing ssh-copy-id
		    ssh-copy-id -p $N_PORT $target
		    export hostfile=~/.ssh/known_hosts
		    ( cat $hostfile; ssh-keyscan -p$N_PORT $N_HOST )2>/dev/null|  sort -u > $hostfile
		    echo ---------------------------------------------------
		    echo We will return to the menu and try again now that
		    echo We think it is fixed.
		    DUPLICITY_USER=$N_USER;
		    DUPLICITY_PORT=$N_PORT;
		    DUPLICITY_HOST=$N_HOST;
		    DUPLICITY_PATH=$N_PATH;
		    DUPLICITY_CONFIGURED=yes
		    doWriteBackupConfiguration
		    sleep 2
		else
		    echo There is an error we cannot fix:
		    echo "ERROR: $working"
		    exit
		fi
	    else
		if [ -n "$N_USER" -a -n "$N_HOST" -a -n "$N_PATH" ]; then
		    DUPLICITY_USER=$N_USER;
		    DUPLICITY_PORT=$N_PORT;
		    DUPLICITY_HOST=$N_HOST;
		    DUPLICITY_PATH=$N_PATH;
		    DUPLICITY_CONFIGURED=yes
		    doWriteBackupConfiguration
		    return 0
		else
		    echo Missing some settings - not saved 1>&2
		    sleep 2
		    break
		    return 1
		fi
	    fi
	    return 1
	    } 1>&2)
	if [ $? -eq 0 ]; then
	    break	
	fi
	done
    }

function menuEnableDisableBackup
    {
    lookupStatus
    if [ "$DUPLICITY_ENABLED" = "yes" ]; then
	en=on
	ds=off
    else
	en=off
	ds=on
    fi
    DSTR="dialog --backtitle '$TITLE' --title 'Enable/Disable Backup' --radiolist 'Backup:' 16 72 10"
    DSTR="$DSTR enabled 'Enable Backup' $en"
    DSTR="$DSTR disabled 'Disable Backup' $ds"

    SEL=$(eval "$DSTR" 2>&1 >/dev/tty)

    if [ -n "$SEL" ]; then
	#we have chosen one of them
	if [ "$SEL" = "enabled" ]; then
	    DUPLICITY_ENABLED=yes
	else
	    DUPLICITY_ENABLED=no
	fi
	doWriteBackupConfiguration
    fi
    }

function menuChooseBackupTarget
    {
    lookupStatus

    ssh=off
    local=off
    cifs=off
    case $DUPLICITY_TARGET in
	SSH)
	    ssh=on
	    ;;
	LOCAL)
	    local=on
	    ;;
	CIFS)
	    cifs=on
	    ;;
    esac
   
    DSTR="dialog --backtitle '$TITLE' --title 'Backup Target' --radiolist 'Duplicity target:' 16 72 10"
    DSTR="$DSTR ssh 'Use duplicity over ssh' $ssh"
    DSTR="$DSTR local 'Use a local (usb or detachable) disk' $local"
    DSTR="$DSTR cifs 'Use a windows file-share ' $cifs"
    
    SEL=$(eval "$DSTR" 2>&1 >/dev/tty)

    if [ -n "$SEL" ]; then
	#we have chosen one of them
	case $SEL in
	    ssh)
		DUPLICITY_TARGET=SSH
		;;
	    local)
		DUPLICITY_TARGET=LOCAL
		;;
	    cifs)
		DUPLICITY_TARGET=CIFS
		;;

	esac
	
	doWriteBackupConfiguration
    fi
    }

function menuSelectTargetDrive
    {
    lookupStatus
    UUIDS=$(lsblk -f | egrep "ext|xfs" | grep -v / | cut -c 32-70)
    

    DSTR="dialog --backtitle '$TITLE' --title 'Backup Drive' --radiolist 'Duplicity drive:' 16 72 10"
    count=0
    for uuid in $UUIDS; do
	disk=$(blkid --uuid $uuid)
	label=$(e2label $disk)
	disk=$(basename $disk)
	onoff=off
	if [ "$uuid" = $DUPLICITY_UUID ]; then
	    onoff=on
	fi
	if [ -n "$disk" ]; then
	    ((count+=1))
	    DSTR="$DSTR $disk '$uuid $label' $onoff"
	fi
    done

    SEL=""
    if [ $count -gt 0 ]; then
	SEL=$(eval "$DSTR" 2>&1 >/dev/tty)
    fi

    if [ -n "$SEL" ]; then
	#SEL should be the disk we want
	#find the UUID that belongs to the disk
	UUID=$(lsblk -f | egrep "ext|xfs" | grep -v / | grep $SEL | cut -c 32-70)

	DUPLICITY_UUID=$UUID
	DUPLICITY_CONFIGURED=yes
	doWriteBackupConfiguration
    fi
    }

function doWriteBackupConfiguration
    {
	echo "TARGET=$DUPLICITY_TARGET" >$DUPLICITY_CONF
	echo "CONFIGURED=$DUPLICITY_CONFIGURED" >>$DUPLICITY_CONF
	echo "USER=$DUPLICITY_USER" >>$DUPLICITY_CONF
	echo "HOST=$DUPLICITY_HOST" >>$DUPLICITY_CONF
	echo "PORT=$DUPLICITY_PORT" >>$DUPLICITY_CONF
	echo "PATH=$DUPLICITY_PATH" >>$DUPLICITY_CONF
	echo "UUID=$DUPLICITY_UUID" >>$DUPLICITY_CONF
	echo "KEY=$DUPLICITY_KEY" >>$DUPLICITY_CONF
	echo "OLDEY=$DUPLICITY_OLDEY" >>$DUPLICITY_CONF
	echo "ENABLED=$DUPLICITY_ENABLED" >>$DUPLICITY_CONF
    }

function menuBackup
    {
    #check to see if we have an ssh key, and if not, create it
    if [ ! -e ~/.ssh/id_rsa ]; then
	# generate a ssh key for this user
	ssh-keygen -q -t rsa -N "" -f ~/.ssh/id_rsa
    fi
    while true; do
	if [ "$DUPLICITY_ENABLED" = "yes" ]; then
	    status="Enabled"
	else
	    status="Disabled"
	fi

	DSTR="dialog --no-cancel --backtitle '$TITLE' --menu 'Backup Menu' 0 0 0"
	DSTR="$DSTR Alter 'Backup ($status)'"
	DSTR="$DSTR Target 'Choose Backup target ($DUPLICITY_TARGET)'"
	DSTR="$DSTR Config 'Configure Backup'"
	DSTR="$DSTR Key 'Encryption Key'"
	DSTR="$DSTR Cron 'Configure automatic backup times'"
	DSTR="$DSTR Do 'Do Backup'"
	DSTR="$DSTR Last 'Find last backup date'"
	DSTR="$DSTR '---' '------'"
	DSTR="$DSTR Restore 'Restore from Backup'"
	NeedsUmount=$( df | grep /mnt/backup )
	if [ -n "$NeedsUmount" ]; then
	    #something was left mounted on /mnt/backup.  Give an option to unmount it
	DSTR="$DSTR '---' '------'"
	DSTR="$DSTR Umount 'Unmount the backup directory'"
	fi
	DSTR="$DSTR Back 'Go back one menu'"

	echo $DSTR
	SEL=$(eval "$DSTR" 2>&1 >/dev/tty)

	if [ "$SEL" = "Config" ]; then 
	    case $DUPLICITY_TARGET in
		SSH)
		    menuConfigureBackup
		;;
		CIFS)
		    menuCIFSCredentials
		;;
		LOCAL)
		    menuSelectTargetDrive
		;;
	    esac
	    continue
	fi
	case $SEL in
	    Key)
	    menuBackupPassphrase
	    continue
	    ;;
	Do)
	    doBackup
	    echo backin up
	    continue
	    ;;
	Target)
	    menuChooseBackupTarget
	    continue
	    ;;
	Restore)
	    menuRestore
	    continue
	    ;;
	Cron)
	    editCron /etc/cron.d/kardia_backup /usr/local/bin/kardia.sh doAutoBackup
	    ;;
	Alter)
	    menuEnableDisableBackup
	    #lookupStatus
	    ;;
	Umount)
	    doBackupPrePost disconnect
	    #lookupStatus
	    ;;
	Last)
	    menuFindLastBackupDate
	    continue
	    ;;
	Back)
	    return
	    ;;
	esac
    done
    }

function menuFindLastBackupDate
    {
    lookupStatus
    if [ -n "DUPLICITY_CONFIGURED" ]; then
	echo "Gathering data: Please Wait"
	DSTR="dialog  --msgbox"

	doBackupPrePost connect
	if [ $? -ne 0 ]; then
	    echo "ERROR connecting to the backup target"
	    sleep 5
	    return
	fi

	dates=$( duplicity collection-status $DUPLICITY_OPT $dup_path/DB  | grep -v Chain | grep -v date | grep 20[0-9][0-9] | sed 's/.*\(....................20[0-9][0-9]\).*/\1/' | { while read one; do date -d"$one"  +%Y-%m-%dT%H:%M:%S; done } | tail -1 )
	echo dates are: $dates;
	if [ -z "$dates" ]; then
	    echo ---------------
	    echo No backups yet.
	    echo ---------------
	    sleep 3
	    return
	fi
	doBackupPrePost disconnect
	DSTR="$DSTR 'Last backup date: $dates' 7 30 ";
	echo $DSTR
	SEL=$(eval "$DSTR" 2>&1 >/dev/tty)
    fi
    }


function menuRestore
    {
    lookupStatus
    if [ -n "DUPLICITY_CONFIGURED" ]; then
	echo "Gathering data: Please Wait"
	DSTR="dialog --backtitle '$TITLE' --menu 'Choose an item to restore' 0 0 0"

	doBackupPrePost connect
	if [ $? -ne 0 ]; then
	    echo "ERROR connecting to the backup target"
	    sleep 5
	    return
	fi

	dates=$( duplicity collection-status $DUPLICITY_OPT $dup_path/DB  | grep -v Chain | grep -v date | grep 20[0-9][0-9] | sed 's/.*\(....................20[0-9][0-9]\).*/\1/' | { while read one; do date -d"$one"  +%Y-%m-%dT%H:%M:%S; done } )
	echo $dates;
	if [ -z "$dates" ]; then
	    echo -----------------------------------
	    echo No backups yet.  Nothing to recover
	    echo -----------------------------------
	    sleep 3
	    return
	fi
	for one in $dates; do
	    DSTR="$DSTR $one $one";
	done
	SEL=$(eval "$DSTR" 2>&1 >/dev/tty)
	echo $SEL
	if [ -n "$SEL" ]; then
	    #We are trying to restore a backup

	    export DBDUMP="/tmp/mysql.tmp"

	    #echo Dumping mysql
	    #mysqldump -u root -h localhost --databases Kardia_DB --complete-insert --skip-extended-insert --add-drop-database > "$DBDUMP"
	    echo recovering mysql sql file from $SEL
	    #duplicity $DBDUMP $dup_path/DB --force $DUPLICITY_OPT --time $SEL
	    restoreOneDir $dup_path/DB $DBDUMP $SEL

	    echo Restoring etc from $SEL
	    #restore the etc directory
	    restoreOneDir $dup_path/etc $ETCDIR $SEL

	    #restore the data directory
	    echo Restoring data from $SEL
	    #duplicity $dup_path/data $KSRC/kardia-app/data --force $DUPLICITY_OPT --time $SEL
	    restoreOneDir $dup_path/data $KSRC/kardia-app/data $SEL

	    #restore the files directory
	    echo Restoring files from $SEL
	    #duplicity $dup_path/files $KSRC/kardia-app/files --force $DUPLICITY_OPT --time $SEL
	    restoreOneDir $dup_path/files $KSRC/kardia-app/files $SEL

	    #restore the tpl directory
	    echo Restoring tpl from $SEL
	    #duplicity $dup_path/tpl $KSRC/kardia-app/tpl --force $DUPLICITY_OPT --time $SEL
	    restoreOneDir $dup_path/tpl $KSRC/kardia-app/tpl $SEL

	    echo restoring MYSQL database from sql file
	    mysql -u root < $DBDUMP

	    echo SUCCESS!
	    echo -n "Press enter to continue"
	    read line
	fi
	doBackupPrePost disconnect
    fi
    }

function restoreOneDir
    {
	source=$1
	dest=$2
	time=$3
	if [ -n "$source" -a -n "$dest" -a -n "$time" ]; then
	    #move the old directory
	    #restore the new dir
	    #if we fail, put the old stuff back
	    rm -rf /tmp/old 2>/dev/null
	    mv $dest /tmp/old
	    duplicity $source $dest $DUPLICITY_OPT --time $time
	    if [ -d "$dest" -o -e "$dest" ]; then
		#success!
		rm -rf /tmp/old
	    else
		#failure!
		mv /tmp/old $dest
		echo "Failed to restore $dest.  Stopping"
		exit
	    fi
	else
	    echo malformed data
	fi
    }

function doAutoBackup
    {
    doBackup quiet
    }

function doBackupPrePost
    {
    Mode=$1
    Testing="$2"
    lookupStatus
    [ -z "$Testing" ] && echo Duplicity Mode: $Mode

    case $Mode in
	connect)
	    #Unmount before backing up if we need to do so, if we were left mounted, we will fail at this point 
	    NeedsDisconnect=$(df | grep /mnt/backup)
	    [ -n "$NeedsDisconnect" ] && doBackupPrePost disconnect quiet

	    #We are connecting.  Set up for the backup
	    case $DUPLICITY_TARGET in
		SSH)
		    target="$DUPLICITY_USER@$DUPLICITY_HOST"
		    err=$(ssh -oBatchMode=yes -oStrictHostKeyChecking=no -p $DUPLICITY_PORT $target ls 2>&1)
		    if [ $? -eq 0 ]; then
			#tested fine
			logger -t doBackupPrePost "SSH test successful.  Continuing to do backup."
		    else
			#failed test
			logger -t doBackupPrePost "SSH test FAILED.  Backup process will end here."
			[ "$Testing" = "testing" ] && echo $err
			return 1
		    fi
		    dup_path="scp://$DUPLICITY_USER@$DUPLICITY_HOST:$DUPLICITY_PORT//$DUPLICITY_PATH"
		;;
		CIFS)
		    #mount the directory
		    dup_path="file:///mnt/backup/kardia-vm"
		    readCIFSCredentials

		    if [ -e "$CIFS_CONF" ]; then
			#the config file exists.

			mkdir -p /mnt/backup
			logger -t doBackupPrePost "Mounting CIFS (windows networking) drive for duplicity"


			err=$(mount -t cifs $DUPLICITY_PATH /mnt/backup -o credentials=$CIFS_CONF 2>&1 )
			if [ $? -gt 0 ]; then
			    logger -t doBackupPrePost "Network mount failed.  The backup stops here. $err"
			    [ "$Testing" = "testing" ] && echo $err
			    return 1
			fi
		    else
			logger -t doBackupPrePost "No CIFS configuration. Cannot continue without authentication"
		    fi
		;;
		LOCAL)
		    #mount the local directory
		    mkdir -p /mnt/backup
		    logger -t doBackupPrePost "Mounting local drive for duplicity"
		    err=$(mount UUID=$DUPLICITY_UUID /mnt/backup 2>&1 )
		    if [ $? -gt 0 ]; then
			logger -t doBackupPrePost "Local mount failed.  The backup stops here."
			[ "$Testing" = "testing" ] && echo $err
			return 1
		    fi
		    dup_path="file:///mnt/backup/kardia-vm"
		;;
	    esac

	    export PASSPHRASE=$DUPLICITY_KEY
	    ;;
	disconnect)
	    #We are connecting.  Set up for the backup
	    case $DUPLICITY_TARGET in
		SSH)
		    [ -z "$Testing" ] && logger -t doBackupPrePost "Duplicity over SSH has completed."
		;;
		CIFS)
		    #umount the directory
		    [ -z "$Testing" ] && logger -t doBackupPrePost "Unmounting network drive for duplicity"
		    umount /mnt/backup
		    if [ $? -gt 0 ]; then
			[ -z "$Testing" ] && logger -t doBackupPrePost "Network unmount failed. Not sure what to do.  Moving on with life"
			return 1
		    fi
		    [ -z "$Testing" ] && logger -t doBackupPrePost "Duplicity backup to windows share completed."
		;;
		LOCAL)
		    #umount the local directory
		    [ -z "$Testing" ] && logger -t doBackupPrePost "Unmounting local drive for duplicity"
		    umount /mnt/backup
		    if [ $? -gt 0 ]; then
			[ -z "$Testing" ] && logger -t doBackupPrePost "Local unmount failed. Not sure what to do.  Moving on with life"
			return 1
		    fi
		    [ -z "$Testing" ] && logger -t doBackupPrePost "Duplicity backup to local drive completed."
		;;
	    esac
	    unset PASSPHRASE
	    ;;
	testing)
	    #set -x
	    echo Connecting
	    c_err=$(doBackupPrePost connect testing)
	    c_erval=$?
	    [ $c_erval -eq 0 ] && echo " Perfect!"
	    [ $c_erval -ne 0 ] && echo " Oops!"
	    echo Disconnecting
	    d_err=$(doBackupPrePost disconnect testing)
	    d_erval=$?
	    [ $d_erval -eq 0 ] && echo " Perfect!"
	    [ $d_erval -ne 0 ] && echo " Oops!"
	    if [ "$c_erval" -ne 0 ]; then
		#there was a connect error.  Return an error code and print the message
		echo "$c_err"
		return 1
	    fi
	    ;;
    esac
    }

function menuBackupPassphrase
    {
    lookupStatus

    edit=false
    if [ -z "$DUPLICITY_KEY" ]; then
	#when we have no key, go straight into edit mode
	edit=true
    fi
    orig_DUPLICITY_KEY="$DUPLICITY_KEY"

    notDone=1
    while [ $notDone -gt 0 ]; do
	if [ "$edit" = "true" ]; then
	    DSTR="dialog --title 'Encryption Key' --extra-button --backtitle 'Key' --extra-label 'Generate Random' --form"
	    DSTR="$DSTR 'Make sure you make a copy of this key and store it elsewhere.  If you need to rebuild the VM,"
	    DSTR="$DSTR you will need this key to restore from backup.' 0 0 0"
	    DSTR="$DSTR 'KEY' 1 1 '$DUPLICITY_KEY' 1 26 30 0"
	else
	    DSTR="dialog --title 'Encryption Key' --extra-button --backtitle 'Key' --extra-label 'Edit' --yesno"
	    DSTR="$DSTR 'Make sure you make a copy of this key and store it elsewhere.  If you need to rebuild the VM,"
	    DSTR="$DSTR you will need this key to restore from backup.  \n\nEncryption Key: $DUPLICITY_KEY' 0 0"
	fi

	SEL=$(eval "$DSTR" 2>&1 >/dev/tty)
	#eval "$DSTR" 2>&1 >/dev/tty
	
	button=$? 
	#button now holds which button was selected.  0=ok, 1=cancel, 3=other
	if [ "$SEL" = "" ]; then
	    #no data passed.
	    echo nothing
	fi
	if [ $button -eq 0 ]; then
	    #OK was chosen
	    if [ "$edit" = "true" ]; then
		#we are editing it, update the value
		if [ "$SEL" != "$orig_DUPLICITY_KEY" ]; then
		    if [ -n "$orig_DUPLICITY_KEY" ]; then
			#There is a pre-existing key we are replacing.  Verify
			
			DSTR="dialog --backtitle '$TITLE' --title 'Replace Key' --radiolist 'Replace Key:\n\n"
			DSTR="$DSTR Never replace your key if you have actual backups that are encrypted with an actual key."
			DSTR="$DSTR If you do, it makes a key-mismatch and all old, and all new backups will fail.  The"
			DSTR="$DSTR only way to recover is by either deleting all backups, or by deleting any new backups done with"
			DSTR="$DSTR the new key, and reverting to the old key.\n\nIf you have no key yet, or have not made any"
			DSTR="$DSTR backups using the old key, you are OK.\n' 18 78 14"
			DSTR="$DSTR keep 'Keep your current key' on"
			DSTR="$DSTR replace 'Replace your key and invalidate ALL previous backups' off"

			AREYOUSURE=$(eval "$DSTR" 2>&1 >/dev/tty)
			worked=$?
			echo $AREYOUSURE
		    else
			#there was no key previously.  Assigning a new one
			worked=0
			AREYOUSURE="replace"
		    fi
		    if [ "$worked" = 0 -a "$AREYOUSURE" = "replace" ]; then
			echo "Key replaced"
			DUPLICITY_OLDEY=$DUPLICITY_KEY
			DUPLICITY_KEY=$SEL
		    else
			echo "Key not changed"
			return 1
		    fi
		fi
	    fi
	    notDone=0 #break out of the loop
	    doWriteBackupConfiguration
	fi
	if [ $button -eq 1 ]; then
	    #cancel was chosen
	    return 1
	fi
	if [ $button -eq 3 ]; then
	    #optional button was chosen
	    #  Either generate a random key (edit=true)
	    #  or go into edit mode (edit=false)
	    if [ "$edit" = "false" ]; then
		#go into edit mode
		edit=true
	    else
		#generate was selected, generate a new key
		DUPLICITY_KEY=$(cat /dev/urandom | tr -dc '[:alpha:]' | fold -w ${1:-30} | head -n 1)
		echo $DUPLICITY_KEY
	    fi
	fi
    done
    }

function readCIFSCredentials
    {
    
    if [ -z "$ETCDIR" ]; then
	lookupStatus
    fi

    export CIFS_CONF=$ETCDIR/cifs.conf
    
    if [ -e "$CIFS_CONF" ]; then
	export CIFS_USER=$(grep username $CIFS_CONF | sed 's/.*=//')
	export CIFS_PASS=$(grep password $CIFS_CONF | sed 's/.*=//')
    fi
    }

function doWriteCIFSCredentials
    {
    if [ -z "$ETCDIR" ]; then
	lookupStatus
    fi

    export CIFS_CONF=$ETCDIR/cifs.conf
    
    echo "username=$CIFS_USER" >$CIFS_CONF
    echo "password=$CIFS_PASS" >>$CIFS_CONF
    chmod 700 $CIFS_CONF
    }

#Get CIFS credentials for mounting a backup file. /usr/local/etc/cifs.conf
function menuCIFSCredentials
    {
    option=$1
    if [ -z "$option" ]; then
	option=menu
    fi

    readCIFSCredentials

    completed=false
    while [ "$completed" = "false" ]; do
	#loop through, giving the various menus	
	case "$option" in
	    menu)
		DSTR="dialog --title 'CIFS Credentials'  --extra-button --extra-label 'Password' --form"
		DSTR="$DSTR 'Configure the network path where the backup will be stored.\n"
		DSTR="$DSTR A valid network path would look like: //server/share\n' 0 0 0"
		DSTR="$DSTR 'Network Path:' 1 1 '$DUPLICITY_PATH' 1 20 40 0"
		DSTR="$DSTR 'Username:' 3 1 '$CIFS_USER' 3 20 40 0"

		SEL=$(eval $DSTR 2>&1 >/dev/tty)
		response=$?
		
		if [ $response = 0 -o $response = 3 ]; then
		    #ok or password was pressed.
		    set $SEL
		    DUPLICITY_PATH=$1
		    CIFS_USER=$2
		fi
		if [ $response = 0 ]; then
		    completed=true #so we exit
		    #write the CIFS credential file
		    doWriteCIFSCredentials
		    DUPLICITY_CONFIGURED=yes
		    #We also changed DUPLICITY variables save that
		    doWriteBackupConfiguration

		    #Now we need to test
		    err=$(doBackupPrePost testing)
		    if [ $? -ne 0 ]; then
			#Somethig did not work
			echo "ERROR: something did not work.  The error was:"
			echo "  $err"
			echo "Please check your path and network credentials and try again"
			echo -n "Press enter to continue: > "
			read line
			completed=false
		    fi
		fi
		if [ $response = 1 ]; then
		    #cancel
		    completed=true #exit
		fi
		if [ $response = 3 ]; then
		    #change password
		    option=password
		fi
	    ;;
	    password)
		DSTR="dialog --title 'Password' --clear --insecure --passwordbox 'Enter Password' 10 30 '$CIFS_PASS'"
		SEL=$(eval $DSTR 2>&1 >/dev/tty)

		if [ $? = 0 ]; then
		    CIFS_PASS=$SEL
		    option=menu
		else
		    echo "Skipping password change"
		fi
	    ;;
	esac
    done
    }


function doBackup
    {
    quiet="$1"

    if Root; then
	#all is right with the world
	echo
    else
	echo -------------------
	echo "Backup must be run as root.  Both for permissions, and for the configuration files"
	echo ------------------
	sleep 5
	return 1
    fi

    lookupStatus

    if [ "$DUPLICITY_ENABLED" = "yes" ]; then
	if [ "$DUPLICITY_CONFIGURED" ]; then

	    doBackupPrePost connect
	    if [ $? -eq 0 ]; then
		export DBDUMP="/tmp/mysql.tmp"

		#Back up the mysql database
		echo Dumping mysql
		logger -t doBackup "Dumping mysql"
		mysqldump -u root -h localhost --databases Kardia_DB --complete-insert --skip-extended-insert --add-drop-database > "$DBDUMP"
		echo Backing up mysql
		logger -t doBackup "Backing up mysql"
		duplicity $DUPLICITY_OPT $DBDUMP $dup_path/DB 

		#backup the etc directory
		echo backing up etc
		logger -t doBackup "backing up etc"
		duplicity $DUPLICITY_OPT $ETCDIR $dup_path/etc

		#backup the data directory
		echo backing up data
		logger -t doBackup "backing up data"
		duplicity $DUPLICITY_OPT $KSRC/kardia-app/data $dup_path/data

		#backup the files directory
		echo backing up files
		logger -t doBackup "backing up files"
		duplicity $DUPLICITY_OPT $KSRC/kardia-app/files $dup_path/files

		#backup the tpl directory
		echo backing up tpl
		logger -t doBackup  "backing up tpl"
		duplicity $DUPLICITY_OPT $KSRC/kardia-app/tpl $dup_path/tpl

		doBackupPrePost disconnect
	    else
		echo --------------------------------
		[ "$DUPLICITY_TARGET" = "SSH" ] && echo "There was an error testing SSH"
		[ "$DUPLICITY_TARGET" = "SSH" ] && echo "Please check your configuration and network connection"
		[ "$DUPLICITY_TARGET" = "LOCAL" ] && echo "There was an error connecting to the local backup drive"
		[ "$DUPLICITY_TARGET" = "LOCAL" ] && echo "Verify it is connected to the machine"
		[ "$DUPLICITY_TARGET" = "CIFS" ] && echo "There was an error connecting to the windows share"
		[ "$DUPLICITY_TARGET" = "CIFS" ] && echo "Please check your configuration and network connection"
		exit
	    fi
	else
	    if [ -z "$quiet" ]; then
		echo "Backup is not yet configured.  Please configure it"
		sleep 5
	    fi
	fi
    else
	if [ -z "$quiet" ]; then
	    echo "Backup is disabled.  Please enable first"
	    sleep 5
	fi
    fi
    }


function displyCentrallixConnectInfo
    {

    lookupStatus
    DispMessage="Centrallix is not currently running."
    if [ "$CXRUNNING" != "" ]; then
	DispMessage="Centrallix is running."
    fi

    dialog --backtitle "$TITLE" --title "Centrallix Connection Info" --msgbox "$DispMessage:

    URL:   http://$IPADDR:$CXPORT/
    URL:   https://$IPADDR:$CXSSLPORT/" 0 0
    }

function doOnBoot
    {
    lookupStatus

    logger -t "kardia.sh" "Running kardia.sh doOnBoot"
    if [ "$AUTOSSH_ENABLED" = "yes" ]; then
	doStartAutossh
    fi
    }

function doSetupGuideUser
    {
    lookupStatus

    if [ "$WKFMODE" = shared ]; then
	dialog --backtitle "$TITLE" --title "Step Ten:  Build and Run Centrallix/Kardia" --yes-label Build --no-label Skip --yesno "Finally, you can build and run Centrallix and Kardia.  This will compile the source code in the shared repository, install Centrallix, build the Kardia database, and start the Centrallix server on port $CXPORT." 0 0
	if [ "$?" = 0 ]; then
	    doBuild
	    AsRoot doDataBuild
	    cxStart
	    lookupStatus
	    dialog --backtitle "$TITLE" --title "Centrallix Started" --msgbox "Centrallix is started and is running on the following port:

Port:  $CXPORT
URL:   http://$IPADDR:$CXPORT/" 0 0
	fi
    else
	dialog --backtitle "$TITLE" --title "Step Ten:  Initialize $USER's repository" --yes-label OK --no-label Back --yesno "Next, you'll initialize $USER's repository, so that $USER has a copy of the source code to build and compile." 0 0
	if [ "$?" != 0 ]; then
	    return 1
	fi
	repoInitUser

	dialog --backtitle "$TITLE" --title "Step Eleven:  Build and Run Centrallix/Kardia" --yes-label Build --no-label Skip --yesno "Finally, you can build and run Centrallix and Kardia.  This will compile the source code in $USER's repository, install Centrallix, build the Kardia database, and start the Centrallix server on port $CXPORT." 0 0
	if [ "$?" = 0 ]; then
	    doBuild
	    AsRoot doDataBuild
	    cxStart
	    lookupStatus
	    dialog --backtitle "$TITLE" --title "Centrallix Started" --msgbox "Centrallix is started and is running on the following port:

Port:  $CXPORT
URL:   http://$IPADDR:$CXPORT/" 0 0
	fi
    fi
    return 0
    }

function chooseSetupGuide
    {
    while true; do
	sg00DevelopOrJustLook
	if [ "$?" = "0" ]; then
	    doQuickSetupGuide
	else
	    doSetupGuide
	fi
	if [ "$?" = "0" ]; then
	    return 0
	fi
    done
    }

# Set it up for kardia testing only
function doQuickSetupGuide
    {
    #if we are resuming, we pass in the number we start at
    if [ $# -lt 1 ]; then
	STEP=1
    else
	echo "Starting back at position $1"
	STEP=$1
    fi
    export SLOWMODDE=yes
    export STEPNUM="One"
    updateFirewall
    while true; do
	if [ "$STEP" = 0 ]; then
	    return 1
	fi
	case $STEP in
	    1)
		STEPNUM=One
		sg01SetRootPassword
		;;
	    2)
		STEPNUM=Two
		sg02SetHostname
		;;
	    3)
		STEPNUM=Three
		sg03SetTimezone
		;;
	    4)
		STEPNUM=Four
		sg04AddUsers
		;;
	    5)
		STEPNUM=Five
		sg08InitRepo
		;;
	    6)
		STEPNUM=Six
		#We add the function we return to if we complete the rebuilding Kardia
		sg10UpdateStuff doQuickSetupGuide 7
		;;
	    7)
		STEPNUM=Seven
		sg11RootBuildRun
		;;
	    8)
		STEPNUM=Eight
		sgYoureDone
		;;
	    9)
		return 0
		;;
	esac
	if [ "$?" = "0" ]; then
	    STEP=$(($STEP + 1))
	else
	    STEP=$(($STEP - 1))
	fi
    done
    }


# Setup Guide (aka "Wizard") for first-time run.
function doSetupGuide
    {
    #if we are resuming, we pass in the number we start at
    if [ $# -lt 1 ]; then
	STEP=1
    else
	STEP=$1
    fi
    updateFirewall
    while true; do
	if [ "$STEP" = 0 ]; then
	    return 1
	fi
	case $STEP in
	    1)
		STEPNUM=One
		sg01SetRootPassword
		;;
	    2)
		STEPNUM=Two
		sg02SetHostname
		;;
	    3)
		STEPNUM=Three
		sg03SetTimezone
		;;
	    4)
		STEPNUM=Four
		sg04AddUsers
		;;
	    5)
		STEPNUM=Five
		sg05SetWorkMode
		;;
	    6)
		STEPNUM=Six
		sg06SetDevMode
		;;
	    7)
		STEPNUM=Seven
		sg07SetRunMode
		;;
	    8)
		STEPNUM=Eight
		sg08InitRepo
		;;
	    9)
		STEPNUM=Nine
		sg09SetSFUser
		;;
	    10)
		STEPNUM=Ten
		#We pass in the place to resume next if we restart kardia.sh
		sg10UpdateStuff doSetupGuide 11
		;;
	    11)
		STEPNUM=Eleven
		if [ "$DEVMODE" = root ]; then
		    sg11RootBuildRun
		else
		    dialog --backtitle "$TITLE" --title "Switching to a user..." --yes-label OK --no-label Back --yesno "The remaining steps need to be done as a normal user, not as root.  On the next screen, you'll pick a user to do the final steps." 0 0
		    if [ "$?" = 0 ]; then
			AsUser doSetupGuideUser
		    fi
		fi
		;;
	    12)
		STEPNUM=Twelve
		sgYoureDone
		;;
	    13)
		return 0
		;;
	esac
	if [ "$?" = "0" ]; then
	    STEP=$(($STEP + 1))
	else
	    STEP=$(($STEP - 1))
	fi
    done
    }

function returnOK
    {
    return 0
    }

function sg00DevelopOrJustLook
    {
    dialog --backtitle "$TITLE" --title "Develop or just Looking?" --yes-label 'Developer' --no-label 'Just Looking' --yesno "Are you a developer, or just looking at Kardia?  Someone who is just viewing Kardia will have a number of default settings chosen for them." 0 0
    if [ $? = 0 ]; then
	export QUICKMODE="no"
	return 1
    else
	export QUICKMODE="yes"
    fi
    return 0
    }

function sg01SetRootPassword
    {
    dialog --backtitle "$TITLE" --title "Step $STEPNUM:  Set Root Password" --yes-label 'OK' --no-label 'Back' --yesno "First, we need to set the root (system administrator) password on the VM Appliance.  This is the password you'll use to log in as 'root' and perform administrative functions.  However, we recommend logging in as a normal user and using 'sudo' instead, or using the administrative functions on the menu, where possible.  Press ENTER to set the root password." 0 0
    if [ "$?" != 0 ]; then
	return 1
    fi
    passwd
    sleep 0.5
    }

function sg02SetHostname
    {  
    if [ "$QUICKMODE" = "no" ]; then
	dialog --backtitle "$TITLE" --title "Step $STEPNUM:  Set the Hostname" --yes-label OK --no-label Back --yesno "Next, we'll set the system hostname.  This is important because it will, by default, show up in commits performed by users on the VM Appliance, and so we need something unique.  You can enter this in 'hostname' or 'hostname.domainname' format." 0 0
    else
	dialog --backtitle "$TITLE" --title "Step $STEPNUM:  Set the Hostname" --yes-label OK --no-label Back --yesno "Next, we'll set the system hostname.  The VM will be active on your network, so choose a name that you will recognize.  You can use either the 'hostname' or 'hostname.domain. format." 0 0
    fi
    if [ "$?" != 0 ]; then
	return 1
    fi
    setHostname
    }

function sg03SetTimezone
    {
    if [ "$QUICKMODE" = "no" ]; then
	dialog --backtitle "$TITLE" --title "Step $STEPNUM:  Set the Timezone" --yes-label OK --no-label Back --yesno "Next, we'll set the timezone.  This is important so that time stamps will show up correctly on files and on commit messages." 0 0
    else
	dialog --backtitle "$TITLE" --title "Step $STEPNUM:  Set the Timezone" --yes-label OK --no-label Back --yesno "Next, we'll set the timezone. Kardia needs the time to be the same on the browser as on the server, and so the timezone needs to be correct. " 0 0
    fi
    if [ "$?" != 0 ]; then
	return 1
    fi
    setTimezone
    }

function sg04AddUsers
    {
    if [ "$QUICKMODE" = "no" ]; then
        dialog --backtitle "$TITLE" --title "Step $STEPNUM:  Add One or More Users" --yes-label OK --no-label Back --yesno "You don't want to be doing work and making commits to the Kardia and Centrallix source code as root.  So, we need to add one or more users.  After you press ENTER here, you'll be presented with a screen where you can add users.  To allow the users to perform administrative functions (i.e., sudo to root), enter 'yes' for 'System Admin Privs'.  To allow users access to the source code repository (via the network shares or locally when logged into the VM Appliance), enter 'yes' for 'Allow Repository Access'.  To allow users to SSH in from outside the VM Appliance, enter 'yes' for 'SSH Access'." 0 0
	if [ "$?" != 0 ]; then
	   return 1
	fi
    fi
    if [ "$QUICKMODE" = "yes" ]; then 
        dialog --backtitle "$TITLE" --title "Step $STEPNUM:  Add One or More Users" --yes-label OK --no-label Back --yesno "You need to add a user for Kardia.  Just specify a username (optional full name) and it will prompt for a password when you hit enter" 0 0
	if [ "$?" != 0 ]; then
	    return 1
	fi
    fi
    menuUsers
    }

function sg05SetWorkMode
    {
    dialog --backtitle "$TITLE" --title "Step $STEPNUM:  Set Workflow Mode" --yes-label OK --no-label Back --yesno "This VM Appliance supports three different workflow modes.  On the next screen you'll select one of these:

Shared:  All users work from a common shared source code repository.  This is simplest, but it also means users can easily get in each others' way.  It is best for just one user, or for two or three users who are working exceptionally closely together in tight coordination.

Team:  Users work from their own private source repositories, but when they commit and push changes, those changes are pushed to a common shared repository.  From there, changes can be pushed to Github  This is ideal for a team of users who want to review their changes as a whole and coordinate the pushing of their modifications to Github

Individual:  Users work strictly from their own private repositories, and commit and push changes directly to Github  A common shared repository still exists, but it pulls changes directly from Github  This is ideal for users who are working largely independently from each other, on separate, distinct, subprojects." 0 0
    if [ "$?" != 0 ]; then
	return 1
    fi
    menuWorkflowMode
    }

function sg06SetDevMode
    {
    dialog --backtitle "$TITLE" --title "Step $STEPNUM:  Set Development Mode" --yes-label OK --no-label Back --yesno "You have a choice of two development modes: 'root' or 'users'.

If you select 'root', then the Centrallix server process will run as root, on port 800, and accept logins from any user on the system.  Only users with 'System Admin Privs' will be able to view the Centrallix console or interact with the debugger.

If you select 'users', then each user will have his/her own Centrallix process, and those processes will run as the user and allow logins only from the user." 0 0
    if [ "$?" != 0 ]; then
	return 1
    fi
    menuDevelMode
    }

function sg07SetRunMode
    {
    dialog --backtitle "$TITLE" --title "Step $STEPNUM:  Set Run Mode" --yes-label OK --no-label Back --yesno "You have a choice of three run modes for Centrallix:

Service:  Run Centrallix as a background service, as root.  This option is only available if you selected 'root' as the development mode.

Console:  Run Centrallix in a console, which you can access to view its output.  (for you Linux folks, this mode runs Centrallix under the 'screen' utility)

GDB:  Run Centrallix in a console, using the GDB debugger.  This allows you to debug the Centrallix server, and generate better bug reports if there is a crash." 0 0
    if [ "$?" != 0 ]; then
	return 1
    fi
    menuRunMode
    }

function sg08InitRepo
    {
    if [ "$QUICKMODE" = "no" ]; then
	dialog --backtitle "$TITLE" --title "Step $STEPNUM:  Initialize the Shared Repository" --ok-label 'OK' --cancel-label 'Back' --extra-button --extra-label 'Skip' --yesno "Next, let's initialize the shared source code repository on the VM Appliance.  This downloads the very latest source code for Kardia and Centrallix from Github  You'll need to separately initialize the per-user repositories if you are using 'team' or 'individual' workflow." 0 0
    else
	dialog --backtitle "$TITLE" --title "Step $STEPNUM:  Initialize the Shared Repository" --ok-label 'OK' --cancel-label 'Back' --extra-button --extra-label 'Skip' --yesno "Next, let's initialize the shared source code repository on the VM Appliance.  This downloads the very latest source code for Kardia and Centrallix from Github" 0 0
    fi
    value=$?
    if [ "$value" == 0 ]; then
	repoInitShared
	#since these crons are in the repo, add them
	addKardiaCrontabs
    fi
    if [ "$value" == 1 ]; then
	return 1
    fi
    if [ "$value" == 3 ]; then
	return #skip.  It looks like we did it
    fi
    }

function sg09SetSFUser
    {
    dialog --backtitle "$TITLE" --title "Step $STEPNUM:  Set Github Username" --yes-label OK --no-label Back --yesno "If you want to be able to commit changes back to Github from the shared common repository, you'll need to supply a Github username that has read/write access to Kardia and/or Centrallix.  Or, if you're just using the VM Appliance to 'try out' Kardia, you can leave the username blank to disallow pushes back to Github from the shared repository." 0 0
    if [ "$?" != 0 ]; then
	return 1
    fi
    repoSetStatus "$BASEDIR/src"
    }

function sg10UpdateStuff
    {
    whereToReturn="$@"
    dialog --backtitle "$TITLE" --title "Step $STEPNUM:  Download OS Updates" --yes-label OK --no-label Skip --yesno "Every OS needs to download updates at some time.  We like to start this VM as fully updated as possible.  Would you like to check to see if we need to download operating system and kardia.sh updates?" 0 0
    if [ "$?" != 0 ]; then
	return 0
    fi
    doUpdates
    UpdateMenus $whereToReturn
    }

function sg11RootBuildRun
    {
    dialog --backtitle "$TITLE" --title "Step $STEPNUM:  Build and Run Centrallix/Kardia" --yes-label Build --no-label Skip --yesno "Finally, you can build and run Centrallix and Kardia.  This will compile the source code, install Centrallix, build the Kardia database, and start the Centrallix server on port 800." 0 0
    if [ "$?" = 0 ]; then
	doBuild
	AsRoot doDataBuild
	cxStart
	lookupStatus
	dialog --backtitle "$TITLE" --title "Centrallix Started" --msgbox "Centrallix is started and is running on the following port:

Port:  $CXPORT
URL:   http://$IPADDR:$CXPORT/" 0 0
    fi
    return 0
    }


function sgYoureDone
    {
    lookupStatus
    dialog --backtitle "$TITLE" --title "You're done!" --yes-label OK --no-label Back --yesno "You will now return to the normal menu, where all of these getting started options (and more) are available as well.
    
If you're developing as users (rather than as root), you will want to quit, logout, and then log back in as your normal user account.

If the menu was updated during the system update, you may want to quit and re-run kardia.sh" 0 0
    if [ "$?" != 0 ]; then
	return 1
    fi
    return 0
    }


# Run one function?
if [ "$1" != "" ]; then
    if [ "$(type -t $1)" = "function" ]; then
	lookupStatus
	"$@"
	exit
    fi
fi


# Run Setup Guide?
lookupStatus
if Rootable; then
    if [ ! -f "$BASEDIR/src/.initialized" ]; then
	if Connected; then
	    dialog --backtitle "$TITLE" --title "Run the Setup Guide?" --yesno "Since this is your first time using the Kardia/Centrallix VM Appliance menus, you can get started quickly by using the Setup Guide.  Would you like to run the Setup Guide now?  If you select NO, you can re-run it later by typing 'kardia.sh doSetupGuide' at the root prompt." 0 0

	    if [ $? = 0 ]; then
		AsRoot chooseSetupGuide
	    fi
	else
	    dialog --backtitle "$TITLE" --title "Internet Required" --msgbox "The Internet is required to do the initial setup of Kardia, and we have been unable to contact the git repository.  We will be downloading centrallix and kardia from the git repository and building it them from the latest stable code.  This means that, without a connection to the Internet, this VM is pretty useless.  Please try to fix the Internet connection for this VM before proceeding.

Please check your Internet connection.
Helpful commands to do so are:
    ip addr
    ip route
    nmcli c
    nmcli d

To run the Kardia Setup Wizard even though it is a bad idea and will not work, run: 
    kardia.sh doSetupGuide
	    " 0 0
	    exit
	fi
	touch "$BASEDIR/src/.initialized"
    fi
fi


# Main menu loop
while true; do
    lookupStatus

    DSTR="dialog --no-cancel --backtitle '$TITLE' --menu 'Main Menu' 0 0 0"
    if [ "$USER" != root -o "$WKFMODE" == shared -o "$DEVMODE" == root ]; then
	DSTR="$DSTR Devel 'Developer Tools'"
    fi
    DSTR="$DSTR Config 'Configuration Options'"
    DSTR="$DSTR Update 'Full Update'"
    #DSTR="$DSTR Repo 'Manage Shared Source Repository'"
    #if [ "$WKFMODE" != "shared" ]; then
#	if [ "$USER" = root ]; then
#	    DSTR="$DSTR IndRepo 'Manage Individual User Repositories'"
#	else
#	    DSTR="$DSTR IndRepo 'Manage My Individual Repository ($USER)'"
#	    Rootable && DSTR="$DSTR IndRepoOth 'Manage Other Individual Repositories'"
#	fi
#    fi
    if [ "$USER" != root ]; then
	DSTR="$DSTR '---' '------'"
	DSTR="$DSTR Password 'Change My Password'"
	DSTR="$DSTR Shell 'Get a Shell'"
    fi
    DSTR="$DSTR '---' '------'"
    Rootable && DSTR="$DSTR System 'Basic System Administration'"
    Rootable && DSTR="$DSTR Users 'Manage Users'"
    Rootable && DSTR="$DSTR Display 'Display Centrallix Connection Information'"
    Rootable && DSTR="$DSTR Backup 'Backup or restore the system'"
    DSTR="$DSTR Quit 'Exit Kardia / Centrallix Management'"

    SEL=$(eval "$DSTR" 2>&1 >/dev/tty)
    if [ "$SEL" = "" ]; then
	continue
    fi
    case "$SEL" in
	Quit)
	    exit
	    ;;
	'---')
	    ;;
	Shell)
	    echo ""
	    echo "Type 'quit' or CTRL-D when finished, to return to menu"
	    echo ""
	    /bin/bash
	    ;;
	System)
	    AsRoot menuSystem
	    ;;
	Users)
	    AsRoot menuUsers
	    ;;
	Repo)
	    menuRepo
	    ;;
	IndRepo)
	    AsUser menuIndRepo
	    ;;
	IndRepoOth)
	    AsRoot AsUser menuIndRepo
	    ;;
	Backup)
	    menuBackup
	    ;;
	Devel)
	    menuDevel
	    ;;
	Config)
	    menuConfigure
	    ;;
	Password)
	    passwd
	    ;;
	Display)
	    displyCentrallixConnectInfo
	    ;;
	Update)
	    doSystemUpdate
	    ;;
    esac
done

#clear the screen. Some terminals do not do this
clear
