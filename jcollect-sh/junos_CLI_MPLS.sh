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

# MPLS
cli -c 'show route table mpls.0 | no-more'
cli -c 'show route table mpls.0 extensive | no-more'
cli -c 'show mpls interface detail  | no-more'
cli -c 'show mpls lsp terse | no-more'
cli -c 'show mpls lsp | no-more'
cli -c 'show mpls lsp extensive | no-more'
cli -c 'show mpls lsp ingress | no-more'
cli -c 'show mpls lsp transit | no-more'


# Traffic Engineering Database - Display the entries in the Multiprotocol Label Switching (MPLS) traffic engineering database.
cli -c 'show ted database | no-more'
cli -c 'show ted database extensive | no-more'