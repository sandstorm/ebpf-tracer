#!/bin/sh
set -e

mount -t debugfs debugfs /sys/kernel/debug

chmod +x /usr/share/bpftrace/tools/*

export PATH=$PATH:/usr/share/bpftrace/tools/:/usr/share/bcc/tools/
exec zsh