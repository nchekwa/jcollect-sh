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

# CHASSIS
cli -c 'show chassis alarms | no-more'

cli -c 'show chassis hardware detail | no-more'

cli -c 'show chassis fpc | no-more'
cli -c 'show chassis fpc detail | no-more'

cli -c 'show chassis environment | no-more'
cli -c 'show chassis environment fpc | no-more'
cli -c 'show chassis environment pem | no-more'
cli -c 'show chassis environment routing-engine | no-more'
cli -c 'show chassis temperature-thresholds | no-more'
cli -c 'show chassis fan | no-more'

cli -c 'show chassis system-mode | no-more'

cli -c 'show chassis fabric summary | no-more'
cli -c 'show chassis fabric map | no-more'
cli -c 'show chassis fabric fpcs | no-more'
cli -c 'show chassis fabric plane | no-more'
cli -c 'show chassis fabric destinations | no-more'
cli -c 'show chassis fabric reachability | no-more'

## run command 6 times (every 10 secends)   // 60 sec
for i in 1 2 3 4 5 6 
do
cli -c 'show chassis routing-engine | no-more'
sleep 10
done
