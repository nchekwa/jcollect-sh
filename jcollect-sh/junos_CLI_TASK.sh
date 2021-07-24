#!/bin/sh
hostname=$(hostname -s)
exe() {
echo ">======================================================================"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
echo  "$USER@$hostname:~# $@"
echo ""
"$@" 
echo ""; }

# TASK
exe cli -c 'show task memory detail | no-more'
exe cli -c 'show task memory summary | no-more'
exe cli -c 'show task io | no-more'
exe cli -c 'show task replication | no-more'
exe cli -c 'show task history | no-more'
exe cli -c 'show task statistics | no-more'
exe cli -c 'show task job | no-more'
exe cli -c 'show task jobs | no-more'