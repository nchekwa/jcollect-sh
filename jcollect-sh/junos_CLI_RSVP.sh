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

# RSVP
exe cli -c 'show rsvp version | no-more'
exe cli -c 'show rsvp interface extensive | no-more'
exe cli -c 'show rsvp neighbor detail | no-more'
exe cli -c 'show rsvp session extensive | no-more'
exe cli -c 'show rsvp session ingress | no-more'
