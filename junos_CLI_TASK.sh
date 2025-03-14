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

# TASK
cli -c 'show task summary | no-more'
cli -c 'show task io | no-more'
cli -c 'show task memory detail | no-more'
cli -c 'show task memory summary | no-more'
cli -c 'show task replication | no-more'
cli -c 'show task history | no-more'
cli -c 'show task statistics | no-more'
cli -c 'show task job | no-more'
cli -c 'show task jobs | no-more'