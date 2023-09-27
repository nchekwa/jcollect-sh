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

alias cprod='exe cprod'
alias cli='exe cli'

cprod -A fpc0 -c 'set dcbcm bcmshell "techsupport l3uc"'
cprod -A fpc0 -c 'set dcbcm bcmshell "techsupport l3mc"'
cprod -A fpc0 -c 'set dcbcm bcmshell "techsupport mpls"'
cprod -A fpc0 -c 'set dcbcm bcmshell "techsupport vfp"'
cprod -A fpc0 -c 'set dcbcm bcmshell "techsupport vxlan"'
cprod -A fpc0 -c 'set dcbcm bcmshell "techsupport vlan"'
cprod -A fpc0 -c 'set dcbcm bcmshell "techsupport load-balance"'
