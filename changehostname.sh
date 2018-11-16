#!/bin/bash
# Hostname change script
# Written to change hostnames from Debian 9 VM template
# Coded by Jeremiah Bess because he's lazy
# "Progress is made by lazy men looking for easier ways to do things." - Robert A. Heinlein

# Check if root
if [ "$USERNAME" != "root" ]; then
        echo "Must be run as root"
        exit
fi

# Check for new name
if [ "$1" = "" ]; then
        echo "Usage: changehostname.sh [newname]"
        exit
fi

# Confirm
newhostname=$1
echo Setting hostname from $oldhostname to $newhostname
read -p "Are you sure? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
fi

# Make changes
oldhostname=$(hostname) # Get current hostname
echo Making changes...
# /etc/hostname
echo $newhostname > /etc/hostname
# /etc/hosts
sed -i "s/$oldhostname/$newhostname/" /etc/hosts
# SSH public keys
sed -i "s/$oldhostname/$newhostname/" /etc/ssh/*.pub
# systemd
hostnamectl set-hostname $newhostname

echo Changes complete.
read -p "Reboot now? [y/N] " -n 1 -r
echo
if [[ !$REPLY =~ ^[Yy]$ ]]; then
        exit 0
else
        reboot
fi

