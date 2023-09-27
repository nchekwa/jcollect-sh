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

# RSVP
cli -c 'show rsvp version | no-more'
cli -c 'show rsvp interface extensive | no-more'
cli -c 'show rsvp neighbor detail | no-more'
cli -c 'show rsvp session extensive | no-more'
cli -c 'show rsvp session ingress | no-more'
