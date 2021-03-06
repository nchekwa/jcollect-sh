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

# TASK
show task summary
show task io
exe cli -c 'show task memory detail | no-more'
exe cli -c 'show task memory summary | no-more'
exe cli -c 'show task io | no-more'
exe cli -c 'show task replication | no-more'
exe cli -c 'show task history | no-more'
exe cli -c 'show task statistics | no-more'
exe cli -c 'show task job | no-more'
exe cli -c 'show task jobs | no-more'