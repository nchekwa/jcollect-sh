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

# PIM
cli -c 'show pim interfaces | no-more'
cli -c 'show pim neighbors detail | no-more'
cli -c 'show pim join summary | no-more'
cli -c 'show pim join extensive | no-more'
cli -c 'show pim statistics | no-more'
cli -c 'show pim rps | no-more'

# IGMP
cli -c 'show igmp group detail | no-more'
cli -c 'show igmp statistics | no-more'

# Multicast
cli -c 'show multicast route extensive | no-more'
cli -c 'show multicast rpf | no-more'
