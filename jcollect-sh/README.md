# jcollect-run-script
Juniper Techsupport Collector


![DEMO](img/../jcollect-sh_1.png)


# About script:
Script needs to be run on Juniper device<br>
<ul>
<li>It will collect basic system information to /var/tmp/jcollect folder</li>
<li>It will generate RSI (request support information)</li>
<li>It will archive logs from /var/log folder</li>
<li>It will run additional EXTERNAL scripts which names starts from junos_*.sh|evo_ *.sh and include output in final TAR archive</li>
</ul>
<br>

# How to use:
```cli
{master:0}
root@leaf001-001-1> start shell

root@leaf001-001-1:RE:0% pwd
/var/root

root@leaf001-001-1:RE:0% ls -la j*
-rwxr-xr-x  1 root  wheel  6838 Jul 22 08:47 jcollect-sh-script.sh
-rwxr-xr-x  1 root  wheel  2497 Jul 22 08:47 junos_qfx_PFE_Debug_v1.sh
-rwxr-xr-x  1 root  wheel   478 Jul 22 08:47 junos_qfx_SYSTEM_Logs_v1.sh

root@leaf001-001-1:RE:0% sh jcollect-sh-script.sh
```