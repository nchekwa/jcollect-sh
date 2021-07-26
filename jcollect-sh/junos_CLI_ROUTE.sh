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

# Route
exe cli -c 'show route table inet.3 | no-more'
exe cli -c 'show route table inet.3 extensive | no-more'
exe cli -c 'show route summary | no-more'
exe cli -c 'show route next-hop database | no-more'
exe cli -c 'show route resolution unresolved | no-more'
exe cli -c 'show route hidden | no-more'
exe cli -c 'show route damping | no-more'

exe cli -c 'show route protocol direct all extensive | no-more'
exe cli -c 'show route protocol local all extensive | no-more'

# KRT - module within the Routing Process Daemon (RPD) that synchronized the routing tables with the forwarding tables in the kernel.
exe cli -c 'show krt queue | no-more'
exe cli -c 'show krt state | no-more'