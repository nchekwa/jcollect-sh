# jcollect-run-script
Juniper Techsupport Collector


![DEMO](../img/jcollect-sh_1.png)


## About script
Script <strong><em>jcollect-sh-script.sh</em></strong> needs to be run on Juniper device.<br>
After startin from shell leve - it will collect basic system information to <strong><em>/var/tmp/jcollect</em></strong> folder.
<ul>
<li>generate <strong>RSI</strong> (request support information).</li>
<li>archive logs from <strong><em>/var/log</em></strong> folder.</li>
<li>run additional <strong>EXTERNAL scripts</strong> which names starts from <strong>junos_|junos-qfx_|evo_</strong> and include output of this scripts in final TAR archive. <strong>You decide</strong> what additional data you whant to collect. Just inclide .sh file in same folder like where is <strong><em>jcollect-sh-script.sh</em></strong></li>
</ul>
<br>

## How to use
```cli
{master:0}
root@Juniper> start shell

root@Juniper:RE:0% pwd
/var/root

root@Juniper:RE:0% ls -la j*
-rwxr-xr-x  1 root  wheel  6838 Jul 22 08:47 jcollect-sh-script.sh
-rwxr-xr-x  1 root  wheel  2497 Jul 22 08:47 junos-qfx_5100_PFE_Debug_v1.sh
-rwxr-xr-x  1 root  wheel   478 Jul 22 08:47 junos-qfx_5100_SYSTEM_Logs_v1.sh

root@Juniper:RE:0% sh jcollect-sh-script.sh
```

## Result
Script will create file in <strong>/var/tmp/</strong> folder.<br>
File name syntax: <strong>\<date-YY-MM-DD\>\_T\<time-HH-MM\>_\<hostname\>_jcollect.tgz</strong> .<br>
It will also create link to latest created file: <strong>/var/tmp/jcollect_latest.tgz</strong>.<br>
![DEMO](../img/jcollect-sh_2.png)<br><br>

Archive folder inside this TGZ will have same naming syntax:<br>
![DEMO](../img/jcollect-sh_3.png)<br><br>

Example of TGZ content:<br>
![DEMO](../img/jcollect-sh_4.png)


## EXTERNAL scripts
<strong>You decide</strong> what additional data you whant to collect.<bt>
You can create your own script and put in same directory where you have jcollect-sh-script.sh.<br>
Your script should have syntax:  <strong>\<junos|junos-qfx|evo\>_\<device-model\>_\<script-name\>.sh</strong><br>
Please include print function <strong>exe</strong> on the top of the script. This function will add additional time stamp and also will include full command inside log file - this will make the file analysis easier.<br>

```bash
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
```

<br>

<span style="color:red"><strong>** IMPORTANT **</strong></span><br>
Please note that maximum time in which EXTERNAL task should be finish is set to 1800 secends.<br>
If your think that your task can take longere - please modyfie <strong>TASKTIMEOUT</strong> value inside jcolector-sh-script or split your EXTERNAL script for several smaller tasks.<br>
On Juniper device you can change this paramter by <strong>sed</strong> command:
```sh
root@Juniper:RE:0% grep "TASKTIMEOUT=" jcollect-sh-script.sh
TASKTIMEOUT=1800
root@Juniper:RE:0% sed -i -e 's/TASKTIMEOUT=1800/TASKTIMEOUT=3600/g' jcollect-sh-script.sh
root@Juniper:RE:0% grep "TASKTIMEOUT=" jcollect-sh-script.sh
TASKTIMEOUT=3600
```

<br>
Example:<br>
Please find below example of EXTERNAL script with name <strong>junos-qfx_5100_SYSTEM_Logs_v1.sh</strong><br>

![EXAMPLE](../img/jcollect-sh_5.png)


## Linux->Juniper
If you using Linux - you can easily  copy selected files to Juniper device by SCP:
```console
# Copy 3 files to Juniper IP: 10.20.30.40
scp jcollect* junos_CLI_ROUTE.sh junos-qfx_QFX5100_SYSTEM_Logs_v1.sh root@10.20.30.40:

# Without asking for password
sshpass -p 'PASSWORD' scp jcollect* junos_CLI_ROUTE.sh junos-qfx_QFX5100_SYSTEM_Logs_v1.sh root@10.20.30.40:
```