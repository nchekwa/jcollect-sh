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

# BGP
exe cli -c 'show configuration protocols bgp | no-more'
exe cli -c 'show configuration protocols bgp | display set | no-more'

exe cli -c 'show bgp summary | no-more'
exe cli -c 'show bgp statistics | no-more'
exe cli -c 'show bgp group | no-more'
exe cli -c 'show bgp neighbor | no-more'

exe cli -c 'show route protocol bgp | no-more'
exe cli -c 'show route protocol bgp terse | no-more'
exe cli -c 'show route protocol bgp all extensive | no-more'

peers=$(cli -c "show bgp neighbor | display xml | no-more" | grep peer-address | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | sed -e 's/+[[:digit:]]*$//')
for peer in $peers
do
exe cli -c "show route receive-protocol bgp $peer | no-more"
exe cli -c "show route advertising-protocol bgp $peer | no-more"
done
