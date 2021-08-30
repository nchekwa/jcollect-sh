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
exe cli -c 'show route all | no-more'
exe cli -c 'show route summary | no-more'

exe cli -c 'show route resolution unresolved | no-more'
exe cli -c 'show route hidden all extensive | no-more'
exe cli -c 'show route damping history | no-more'

# KRT - module within the Routing Process Daemon (RPD) that synchronized the routing tables with the forwarding tables in the kernel.
exe cli -c 'show krt queue | no-more'
exe cli -c 'show krt state | no-more'

# PFE
exe cli -c 'show pfe route ip | no-more'
exe cli -c 'show pfe route mpls | no-more'
exe cli -c 'show pfe route summary | no-more'
exe cli -c 'show pfe statistics traffic | no-more'
exe cli -c 'show pfe statistics notification | no-more'
exe cli -c 'show pfe statistics exceptions | no-more'

# FORWARDING TABLE
exe cli -c 'show route forwarding-table all | no-more'                  #large output   
exe cli -c 'show route forwarding-table all extensive | no-more'        #large output  
exe cli -c 'show route forwarding-table summary | no-more'