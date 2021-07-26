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

# PFE / Forwarding Table
exe cli -c 'show pfe route ip | no-more'
exe cli -c 'show pfe statistics traffic | no-more'
exe cli -c 'show pfe statistics notification | no-more'
exe cli -c 'show pfe statistics exceptions | no-more'
exe cli -c 'show route forwarding-table extensive | no-more'                  
exe cli -c 'show route forwarding-table family mpls extensive | no-more'
