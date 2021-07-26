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

# SYSTEM
exe cli -c 'show system commit include-configuration-revision | no-more'
exe cli -c 'show system storage | no-more'
exe cli -c 'show system processes extensive | no-more'
exe cli -c 'show system memory all-members | no-more'
exe cli -c 'show system connections | no-more'
exe cli -c 'show system statistics | no-more'
exe cli -c 'show system errors active | no-more'
exe cli -c 'show system core-dumps | no-more'
exe cli -c 'show system license detail | no-more'