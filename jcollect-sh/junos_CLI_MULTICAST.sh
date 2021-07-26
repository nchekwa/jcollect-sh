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

# PIM
exe cli -c 'show pim interfaces | no-more'
exe cli -c 'show pim neighbors detail | no-more'
exe cli -c 'show pim join summary | no-more'
exe cli -c 'show pim join extensive | no-more'
exe cli -c 'show pim statistics | no-more'

# IGMP
exe cli -c 'show igmp group detail | no-more'
exe cli -c 'show igmp statistics | no-more'

# Multicast
exe cli -c 'show multicast route extensive | no-more'
exe cli -c 'show multicast rpf | no-more'
