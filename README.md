# jcollect-sh
Juniper Techsupport Collector<br><br>




```bash
root@collector:/opt/jcollect-sh# python jcollect.py --help
usage: jcollect.py [-h] [-c CONFIG] [-p PATH] [-i ID] [-a ACTION] [-H HOST]

optional arguments:
  -h, --help            show this help message and exit
  -c CONFIG, --config CONFIG
                        YAML Files with configuration (multiple names separated by comma)
  -p PATH, --path PATH  Output path where store worker logs
  -i ID, --id ID        Worker ID
  -a ACTION, --action ACTION
                        Action [jcollect|rsi|logs]
  -H HOST, --host HOST  IP Host
```
<br>Example:
```bash
root@collector:/opt/jcollect-sh# python jcollect.py 
[facts]    Time: 2022-01-05 13:16:47
[facts]    ID: 20220105-131647
[facts]    Action: jcollect
[facts]    Config: /mnt/github/jcollect-sh/config.yaml
[facts]    Path: /mnt/github/jcollect-sh/jcollect-data/20220105-131647/
[facts]    Log: /mnt/github/jcollect-sh/jcollect-data/20220105-131647/log-main.log
[facts]    Config: /mnt/github/jcollect-sh/config.yaml
[facts]    Host: 10.240.40.30
[facts]    Host: 10.240.40.31
[facts]    Host: 10.240.40.51
[ICMP]     Start: 2022-01-05 13:16:47
[ICMP]     Host: 10.240.40.30 | Status: OK | AVG_Latency: 2.98 ms
[ICMP]     Host: 10.240.40.31 | Status: OK | AVG_Latency: 1.33 ms
[ICMP]     Host: 10.240.40.51 | Status: No RESPONDING!
[ICMP]     End: 2022-01-05 13:16:49
[SSH]      Start: 2022-01-05 13:16:49
[SSH]      Host: 10.240.40.51 | Exception device connection open: ProbeError was raised: ProbeError(10.240.40.51)
[SHELL]    Host: 10.240.40.51 | Status: StartShell Failed
[SHELL]    Host: 10.240.40.30 | Status: OK | Hostname: leaf001-001-1
[SHELL]    Host: 10.240.40.31 | Status: OK | Hostname: leaf001-001-2
[warning]  Host: 10.240.40.51 - not respoding on SSH check - remove from next step
[SSH]      End: 2022-01-05 13:16:53
[COLLECT]  Start: 2022-01-05 13:16:53
[SHELL]    Host: 10.240.40.30 [leaf001-001-1] | run EXTERNAL junos_CLI_BGP.sh
[SHELL]    Host: 10.240.40.31 [leaf001-001-2] | Generate RSI...
[SHELL]    Host: 10.240.40.30 [leaf001-001-1] | run EXTERNAL junos_CLI_BGP.sh - DONE: 10.45 sec
[SHELL]    Host: 10.240.40.30 [leaf001-001-1] | run EXTERNAL junos_CLI_L2.sh
[SHELL]    Host: 10.240.40.30 [leaf001-001-1] | run EXTERNAL junos_CLI_L2.sh - DONE: 14.86 sec
[SHELL]    Host: 10.240.40.30 [leaf001-001-1] | Generate RSI...
[SHELL]    Host: 10.240.40.31 [leaf001-001-2] | Generate RSI - DONE: 90.49 sec
[SHELL]    Host: 10.240.40.31 [leaf001-001-2] | Compress LOG folder...
[SHELL]    Host: 10.240.40.31 [leaf001-001-2] | Compress LOG folder - DONE: 0.87 sec
[SHELL]    Host: 10.240.40.31 [leaf001-001-2] | Compress all files to JCOLLECT TGZ...
[FS]       Host: 10.240.40.31 [leaf001-001-2] | JCollect TGZ Size: 2.29M
[SCP]      Host: 10.240.40.31 [leaf001-001-2] | JCollect TGZ Download...
[SCP]      Host: 10.240.40.31 [leaf001-001-2] | JCollect TGZ Download - DONE: 0.46 sec
[SHELL]    Host: 10.240.40.31 [leaf001-001-2] | ALL DONE: 101.35 sec
[SHELL]    Host: 10.240.40.30 [leaf001-001-1] | Generate RSI - DONE: 95.36 sec
[SHELL]    Host: 10.240.40.30 [leaf001-001-1] | Compress LOG folder...
[SHELL]    Host: 10.240.40.30 [leaf001-001-1] | Compress LOG folder - DONE: 1.11 sec
[SHELL]    Host: 10.240.40.30 [leaf001-001-1] | Compress all files to JCOLLECT TGZ...
[FS]       Host: 10.240.40.30 [leaf001-001-1] | JCollect TGZ Size: 1.83M
[SCP]      Host: 10.240.40.30 [leaf001-001-1] | JCollect TGZ Download...
[SCP]      Host: 10.240.40.30 [leaf001-001-1] | JCollect TGZ Download - DONE: 0.27 sec
[SHELL]    Host: 10.240.40.30 [leaf001-001-1] | ALL DONE: 138.27 sec
[COLLECT]  End: 2022-01-05 13:19:15
```


<br>
<br>
For SHELL script which can be run directly on JUNOS device - please <br>
check <b>README</b> inside  <a href=https://github.com/nchekwa/jcollect-sh/tree/main/jcollect-sh>jcollect-sh</a> folder