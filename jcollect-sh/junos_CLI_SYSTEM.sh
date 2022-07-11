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
exe cli -c 'show system memory all-members | no-more'
exe cli -c 'show system users | no-more'
exe cli -c 'show system connections | no-more'
exe cli -c 'show system statistics | no-more'
exe cli -c 'show system errors active | no-more'
exe cli -c 'show system core-dumps | no-more'
exe cli -c 'show system license detail | no-more'


## run command 6 times (every 10 secends)   // 60 sec
for i in 1 2 3 4 5 6 
do
exe cli -c 'show system processes extensive | no-more'
sleep 10
done