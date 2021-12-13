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

exe cprod -A fpc0 -c 'set dcbcm bcmshell "techsupport l3uc"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "techsupport l3mc"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "techsupport mpls"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "techsupport vfp"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "techsupport vxlan"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "techsupport vlan"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "techsupport load-balance"'
