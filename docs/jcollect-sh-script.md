# Juniper Technical Support Collector (jcollect-sh-script.sh)

A simple and efficient tool for collecting diagnostics from Juniper devices.

![DEMO](../img/jcollect-sh_1.png)

## What Does This Tool Do?

The `jcollect-sh-script.sh` is a tool that runs directly on your Juniper device. When you run this script:

1. It collects basic system information and stores it in the `/var/tmp/jcollect` folder
2. It creates an **RSI** (Request Support Information) file - a comprehensive diagnostic report
3. It saves all logs from the `/var/log` folder
4. It automatically runs any additional diagnostic scripts that you've placed in the same folder
5. It packages everything into a single compressed file for easy sharing

The beauty of this tool is its flexibility - **you decide** what information to collect by adding your own custom scripts.

## How to Use This Tool - Step by Step

### Step 1: Access Your Juniper Device

```bash
{master:0}
root@Juniper-cli> start shell
```

### Step 2: Check What Scripts You Have Available

```bash
root@Juniper:RE:0% pwd
/var/root

root@Juniper:RE:0% ls -la j*
-rwxr-xr-x  1 root  wheel  6838 Jul 22 08:47 jcollect-sh-script.sh
-rwxr-xr-x  1 root  wheel  2497 Jul 22 08:47 junos-qfx_5100_PFE_Debug_v1.sh
-rwxr-xr-x  1 root  wheel   478 Jul 22 08:47 junos-qfx_5100_SYSTEM_Logs_v1.sh
```

### Step 3: Run the Script

```bash
root@Juniper-cli>  start shell
root@Juniper:RE:0% sh jcollect-sh-script.sh
```

That's it! The script will run automatically and collect all the necessary information.

## Understanding the Results

### Where to Find the Results

The script creates a compressed file (TGZ) in the `/var/tmp/` folder.

File naming format: **`YYYY-MM-DD_THHMM_hostname_jcollect.tgz`**

For easy access, the script also creates a link to the most recent file: `/var/tmp/jcollect_latest.tgz`

![Result Location](../img/jcollect-sh_2.png)

### Inside the Archive

The archive contains a folder with the same name as the TGZ file:

![Archive Structure](../img/jcollect-sh_3.png)

Example of what you'll find inside the archive:

![Archive Contents](../img/jcollect-sh_4.png)

## Customizing Data Collection with Your Own Scripts

You can create your own scripts to collect specific information that matters to you.

### How to Add Your Own Scripts

1. Create a script file following this naming pattern:  
   **`junos_YourScriptName.sh`** or **`junos-qfx_DeviceModel_YourScriptName.sh`** or **`evo_YourScriptName.sh`**

2. Place your script in the same directory as the `jcollect-sh-script.sh` file

3. Make sure your script includes the following function at the top - it helps with organizing the output:

```bash
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
```
*** **IMPORTANT** *** When you developing script, run it manualy to ansure that it will not hang-up (will not ask user for some manual input?). Check if in case of `cli` commands you are using `| no-more` sufix.

### Important Time Limitation

Your custom scripts must complete within 1800 seconds (30 minutes). If your script needs more time:

1. Increase the time limit by changing the `TASKTIMEOUT` value, or
2. Split your script into smaller parts

#### How to Change the Time Limit (inside script)

```sh
# Check the current timeout value
root@Juniper:RE:0% grep "TASKTIMEOUT=" jcollect-sh-script.sh
TASKTIMEOUT=1800

# Change to 3600 seconds (1 hour)
root@Juniper:RE:0% sed -i -e 's/TASKTIMEOUT=1800/TASKTIMEOUT=3600/g' jcollect-sh-script.sh

# Verify the change
root@Juniper:RE:0% grep "TASKTIMEOUT=" jcollect-sh-script.sh
TASKTIMEOUT=3600
```

### Example of a Custom Script

Below is an example of what a custom script looks like:

![Example Script](../img/jcollect-sh_5.png)

## Transferring Files Between Devices

### Copying Scripts to Your Juniper Device

From your Linux machine to the Juniper device:

```bash
# Copy files to Juniper device at IP 10.20.30.40
scp jcollect* junos_CLI_ROUTE.sh junos-qfx_QFX5100_SYSTEM_Logs_v1.sh root@10.20.30.40:

# Copy without entering password (if you need automation)
sshpass -p 'PASSWORD' scp jcollect* junos_CLI_ROUTE.sh junos-qfx_QFX5100_SYSTEM_Logs_v1.sh root@10.20.30.40:
```

### Downloading and Extracting Results

From the Juniper device to your Linux machine:

```bash
# Go to a temporary directory
cd /tmp/

# Download the latest collection
scp root@10.240.40.30:/var/tmp/jcollect_latest.tgz .
--or--
sshpass -p 'root123' scp root@10.240.40.30:/var/tmp/jcollect_latest.tgz .

# Extract the archive
mkdir jcollect
tar zxvf jcollect_latest.tgz -C /tmp/jcollect
cd jcollect
ls
> 2021-07-26_T0033_leaf001-001-1_jcollect
cd 2021-07-26_T0033_leaf001-001-1_jcollect/
ls
> LOGS_20210726T003146_1627259506.tgz  LOGS_command_output_log.log  RSI_20210726T003146_1627259506.txt  RSI_command_output_log.log  junos_CLI_BGP.log  junos_CLI_BGP.sh  xml

# Extract the logs archive if needed
tar zxvf LOGS_20210726T003146_1627259506.tgz 
rm LOGS_*
ls
> RSI_20210726T003146_1627259506.txt  RSI_command_output_log.log  junos_CLI_BGP.log  junos_CLI_BGP.sh  log  xml
