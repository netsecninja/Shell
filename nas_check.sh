#! /bin/bash
# NAS check script

# Error flag
flag=0

# Time stamp for logs
echo -n "NAS check script "
date

# Check for mount
# Drive A(1)
if ! grep -qs '/media/hd1' /proc/mounts; then
    $flag=1
    echo "Error: Mounting drive A"
    mount /media/hd1
fi
# Drive B(2)
if ! grep -qs '/media/hd2' /proc/mounts; then
    $flag=1
    echo "Error: Mounting drive B"
    mount /media/hd2
fi

# Check for NFS
# portmap not used?
# nfsd
ps cax | grep nfsd > /dev/null
if [ $? -ne 0 ]; then
    $flag=1
    echo "Error: nfsd process not running. Restarting nfs server"
    service nfs-kernel-server stop
    pkill nfsd
    pkill rpc.mountd
    service nfs-kernel-server start
fi
# mountd
ps cax | grep mountd > /dev/null
if [ $? -ne 0 ]; then
    $flag=1
    echo "Error: mountd process not running. Restarting nfs server"
    service nfs-kernel-server stop
    pkill nfsd
    pkill rpc.mountd
    service nfs-kernel-server start
fi

# Check for SAMBA
service samba status > /dev/null
if [ $? -ne 0 ]; then
    $flag=1
    echo "Error: Restarting samba server"
    service samba stop
    pkill smbd
    pkill nmbd
    service samba start
fi

if [ $flag -eq 0 ]; then
    echo "Check complete, no errors found."
fi
