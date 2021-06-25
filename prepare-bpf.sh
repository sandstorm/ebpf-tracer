#!/bin/bash
set -e

echo "Preparing the container for eBPF usage."

echo "trying to mount /sys/kernel/debug"
mount -t debugfs debugfs /sys/kernel/debug || echo "OK"

if [[ $(uname -a | grep linuxkit) ]]; then
    echo "This is Docker for Mac. We don't need to do anything, as the container already contains the Kernel Sources."
    echo ""
    echo "Have fun BPFing :)"
    exit 0
fi


# not docker for mac, but real linux.

if [[ -f "/usr/src/.notmounted" ]]; then
    echo "/usr/src/ is not mounted to the host. trying to copy from the host"
    if [[ ! -d "/proc/1/root/usr/src/" ]]; then
        echo "ERROR: the host system does not have a /usr/src/ directory"
        exit 1
    fi
    
    echo "Copying /usr/src/ from the host to the container"
    cp -Ra /proc/1/root/usr/src/* /usr/src/
fi

if [[ -f "/lib/modules/.notmounted" ]]; then
    echo "/lib/modules/ is not mounted to the host. trying to copy from the host"
    if [[ ! -d "/proc/1/root/lib/modules/" ]]; then
        echo "ERROR: the host system does not have a /lib/modules/ directory"
        exit 1
    fi
    
    echo "Copying /lib/modules/ from the host to the container"
    cp -Ra /proc/1/root/lib/modules/* /lib/modules/
fi

echo "All Done. Have fun BPFing :)"