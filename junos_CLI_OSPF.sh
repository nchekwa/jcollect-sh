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

# OSPF
cli -c 'show configuration protocols ospf | no-more'
cli -c 'show configuration protocols ospf | display set | no-more'

cli -c 'show route protocol ospf | no-more'
cli -c 'show route protocol ospf all extensive | no-more'

cli -c 'show ospf overview | no-more'

cli -c 'show ospf database summary | no-more'
cli -c 'show ospf database | no-more'
cli -c 'show ospf database extensive | no-more'

cli -c 'show ospf neighbor detail | no-more'
cli -c 'show ospf route | no-more'
cli -c 'show ospf statistics | no-more'
cli -c 'show ospf interface | no-more'
cli -c 'show ospf log | no-more'