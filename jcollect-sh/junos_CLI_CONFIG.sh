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

# CONFIG
exe cli -c 'show configuration | display omit | except SECRET-DATA | no-more'
exe cli -c 'show configuration | display omit | except SECRET-DATA | display set | no-more'
exe cli -c 'show configuration | display omit | display inheritance | except SECRET-DATA | no-more'