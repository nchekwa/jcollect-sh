#!/bin/sh
hostname=$(hostname -s)
exe() {
echo ">======================================================================"
echo "=== $USER@$hostname:~# $@"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
echo ""
"$@" 
echo ""; }

alias cli='exe cli'

# CONFIG
cli -c 'show configuration | display omit | except SECRET-DATA | no-more'
cli -c 'show configuration | display omit | except SECRET-DATA | display set | no-more'
cli -c 'show configuration | display omit | display inheritance | except SECRET-DATA | no-more'