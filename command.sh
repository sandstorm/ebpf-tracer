#!/bin/sh
set -e

echo "Starting up Debug Container"

mount -t debugfs debugfs /sys/kernel/debug

export PATH=$PATH:/usr/share/bcc/tools/

# https://stackoverflow.com/questions/31281522/how-to-detect-fully-interactive-shell-in-bash-from-docker
# https://stackoverflow.com/questions/911168/how-to-detect-if-my-shell-script-is-running-through-a-pipe
if [ -t 0 ] ; then
    echo "(interactive mode)"
    exec /bin/bash
else
    echo "(non-interactive mode, waiting forever so you can connect via docker exec / kubectl exec)"
    while [ 1 ]; do
        sleep 2
    done
fi

