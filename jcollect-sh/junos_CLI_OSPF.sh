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

# OSPF
exe cli -c 'show configuration protocols ospf | no-more'
exe cli -c 'show configuration protocols ospf | display set | no-more'

exe cli -c 'show route protocol ospf | no-more'
exe cli -c 'show route protocol ospf all extensive | no-more'

exe cli -c 'show ospf overview | no-more'

exe cli -c 'show ospf database summary | no-more'
exe cli -c 'show ospf database | no-more'
exe cli -c 'show ospf database extensive | no-more'

exe cli -c 'show ospf neighbor detail | no-more'
exe cli -c 'show ospf route | no-more'
exe cli -c 'show ospf statistics | no-more'
exe cli -c 'show ospf interface | no-more'
exe cli -c 'show ospf log | no-more'