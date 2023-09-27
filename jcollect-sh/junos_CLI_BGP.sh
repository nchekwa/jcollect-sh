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

# BGP
cli -c 'show configuration protocols bgp | no-more'
cli -c 'show configuration protocols bgp | display set | no-more'

cli -c 'show bgp summary | no-more'
cli -c 'show bgp statistics | no-more'
cli -c 'show bgp group | no-more'
cli -c 'show bgp neighbor | no-more'

cli -c 'show route protocol bgp | no-more'
cli -c 'show route protocol bgp terse | no-more'
cli -c 'show route protocol bgp all extensive | no-more'

peers=$(/usr/sbin/cli -c "show bgp neighbor | display xml | no-more" | grep peer-address | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | sed -e 's/+[[:digit:]]*$//')
for peer in $peers
do
cli -c "show route receive-protocol bgp $peer | no-more"
cli -c "show route advertising-protocol bgp $peer | no-more"
done
