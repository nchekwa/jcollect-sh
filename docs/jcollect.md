# Juniper Support Information Collector (jcollect.py)

## What is jcollect.py?

The `jcollect.py` script allows you to remotely collect diagnostic information from multiple Juniper devices simultaneously. Think of it as a remote control for the `jcollect-sh-script.sh` - instead of logging into each device individually, you can gather all the information you need from your central management station.

Key features:
- Collect diagnostic data from multiple Juniper devices at once
- Automatically check if devices are reachable before attempting collection
- Run customized external scripts on remote devices
- Download and organize all collected information automatically
- Save time by automating the collection of technical support information

## Requirements

Before using this tool, you need:
1. Python 3.x installed on your system
2. Network connectivity to your Juniper devices
3. SSH access to the target devices
4. The following Python packages:
   - pythonping
   - termcolor
   - PyYAML
   - junos-eznc

## Getting Started

### Basic Command Syntax

```bash
python jcollect.py [options]
```

### Command Options

| Option | Description |
|--------|-------------|
| `-h, --help` | Show help message and exit |
| `-c CONFIG, --config CONFIG` | YAML file(s) with configuration (multiple files can be separated by comma) |
| `-p PATH, --path PATH` | Output path to store collected data and logs |
| `-i ID, --id ID` | Custom identifier for this collection job |
| `-a ACTION, --action ACTION` | Action to perform: `jcollect`, `rsi`, or `logs` |
| `-H HOST, --host HOST` | Specific IP address to target (overrides config file) |

### Configuration File

The tool uses a YAML configuration file (default: `config.yaml`) to define:
- Target devices (IP addresses or hostnames)
- SSH credentials
- Collection options
- External scripts to run

Example configuration file:
```yaml
hosts:
  - ip: 10.240.40.30
    name: leaf001-001-1
  - ip: 10.240.40.31
    name: leaf001-001-2
  - ip: 10.240.40.51
    name: spine001-001-1

ssh:
  username: root
  password: "password"  # Use environment variables or secure storage in production
  port: 22

action: "jcollect"  # Default action if not specified on command line

# List of external script files to upload and run on each device
files:
  - junos_CLI_BGP.sh
  - junos_CLI_L2.sh
```

## How It Works

When you run the tool, it performs these steps for each target device:

1. **Reachability Check**: Uses ICMP (ping) to verify the device is online
2. **SSH Connectivity**: Tests SSH access with the provided credentials
3. **Data Collection**: For each responding device:
   - Uploads any specified external scripts
   - Runs the scripts on the remote device
   - Gathers Request Support Information (RSI)
   - Compresses log files from `/var/log`
   - Creates a compressed archive of all collected data
4. **Data Download**: Securely copies the archive from each device
5. **Cleanup**: Removes temporary files from the remote devices

All downloaded files are stored in the specified output directory, organized by collection ID and device.

## Example Usage

### Basic Collection
```bash
python jcollect.py
```

This uses the default `config.yaml` file in the current directory and collects information from all configured devices.

### Custom Configuration
```bash
python jcollect.py -c custom_config.yaml
```

Uses a specific configuration file instead of the default.

### Target a Specific Device
```bash
python jcollect.py -H 10.240.40.30
```

Collects data only from the specified IP address.

### Custom Output Location
```bash
python jcollect.py -p /path/to/output/folder
```

Stores all collected data in the specified directory.

## Example Output

When you run the script, you'll see progress information like this:

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

## Understanding the Results

After collection completes, you'll find the following in your output directory:
1. A main log file (`log-main.log`) showing the complete collection process
2. A directory for each successfully contacted device
3. TGZ (compressed) archives containing all collected data for each device

Each archive follows the naming format: `YYYY-MM-DD_THHMM_hostname_jcollect.tgz`

## Troubleshooting

If you encounter issues:

- **Device not responding to ping**: Check network connectivity and firewall rules
- **SSH connection failure**: Verify username, password, and SSH service status
- **Script execution errors**: Check log files for specific error messages
- **Collection timeout**: For large devices, you may need to adjust timeouts in the script

## Using On-Device Collection

For direct collection on Juniper devices without using this remote tool, refer to the [jcollect-sh-script.sh documentation](jcollect-sh-script.md).