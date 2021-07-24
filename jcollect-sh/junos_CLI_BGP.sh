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

# BGP
exe cli -c 'show configuration protocols bgp | no-more'
exe cli -c 'show configuration protocols bgp | display set | no-more'

exe cli -c 'show route protocol bgp | no-more'
exe cli -c 'show route protocol bgp terse | no-more'
exe cli -c 'show route protocol bgp all extensive | no-more'
exe cli -c 'show route receive-protocol bgp | no-more'
exe cli -c 'show route advertising-protocol bgp | no-more'

exe cli -c 'show bgp summary | no-more'
exe cli -c 'show bgp statistics | no-more'
exe cli -c 'show bgp group | no-more'
exe cli -c 'show bgp neighbor | no-more'
