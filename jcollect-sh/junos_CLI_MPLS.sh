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

# MPLS
exe cli -c 'show route table mpls.0 | no-more'
exe cli -c 'show route table mpls.0 extensive | no-more'
exe cli -c 'show mpls interface detail  | no-more'
exe cli -c 'show mpls lsp terse | no-more'
exe cli -c 'show mpls lsp | no-more'
exe cli -c 'show mpls lsp extensive | no-more'
exe cli -c 'show mpls lsp ingress | no-more'
exe cli -c 'show mpls lsp transit | no-more'


# Traffic Engineering Database - Display the entries in the Multiprotocol Label Switching (MPLS) traffic engineering database.
exe cli -c 'show ted database | no-more'
exe cli -c 'show ted database extensive | no-more'