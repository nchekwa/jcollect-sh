#!/usr/bin/env python3

import argparse
import datetime
import logging
import copy
import os.path
import os
import sys

from pprint import pprint
from contextlib import contextmanager
from pathlib import Path

# pip install junos_eznc
from jnpr.junos import Device
from jnpr.junos.utils.fs import FS
from jnpr.junos.utils.scp import SCP
from jnpr.junos.utils.start_shell import StartShell
from paramiko import ProxyCommand, SFTPClient, SSHClient, SSHConfig, Transport
from scp import SCPClient

# pip instal pythonping
from pythonping import ping

# 
import paramiko
import yaml




#logging.basicConfig(level=logging.INFO)

#logging.getLogger("ncclient.transport").setLevel(logging.WARNING)
#logging.getLogger("ncclient.operations.rpc").setLevel(logging.WARNING)
#logging.getLogger("paramiko").setLevel(logging.WARNING)

utc_date_time = datetime.datetime.utcnow().strftime("%Y-%m-%d_%H-%M")
file_logs_archive   = 'LOGS-' + utc_date_time + '.tgz'
file_rsi_archive    = 'RSI-'  + utc_date_time + '.tgz'

# ---------------------------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------------------------

class Juniper():
    @contextmanager
    def connect(self):
        self.logger.debug('Junos PYEZ - Connecting to device...')
        self.device.open()
        #self.device.open(auto_probe=5)
        #self.device.timeout = 900
        try:
            yield
        finally:
            self.device.close()

    def __init__(self, args):
        self.put_files = []
        self.args = args

        # Logging
        self.logger = logging.getLogger()
        self.logger.setLevel(logging.DEBUG)
        formatter = logging.Formatter('%(asctime)s | %(levelname)s | %(message)s')

        #stdout_handler = logging.StreamHandler(sys.stdout)
        #stdout_handler.setLevel(logging.DEBUG)
        #stdout_handler.setFormatter(formatter)

        file_handler = logging.FileHandler('./logs/'+(self.args['ip'])+'_ooutput.log')
        file_handler.setLevel(logging.DEBUG)
        #file_handler.setFormatter(formatter)

        self.logger.addHandler(file_handler)
        #self.logger.addHandler(stdout_handler)

        # Connect to Device
        self.device = Device(host=args['ip'], user=args['ssh']['username'], passwd=args['ssh']['password'], port=args['ssh']['port'])

    def request_rsi(self):
        with self.connect():
            with StartShell(self.device, timeout=1800) as ss:
                logger.info('Generate RSI. This can take a while... ')
                print('Generate RSI.  This can take a while...')
               # result = ss.run('touch /var/tmp/RSI-' + utc_date_time + '.txt', this='(%|#|\\$)\\s', timeout=600)
                got = ss.run('cli -c "request support information | save /var/tmp/RSI-' + utc_date_time + '.txt"; false')
                #ss.close()
            return(got)

    def compress_rsi(self):
        with self.connect():
            with StartShell(self.device, timeout=1800) as ss:
                self.logger.info('Compress RSI.')
                print('Compress RSI.')
                got = ss.run('cli -c "file archive compress source /var/tmp/RSI-' + utc_date_time + '.txt destination /var/tmp/' + file_rsi_archive + '"; false ')
                #ss.close()
            return(got)

    def compress_logs(self):
        with self.connect():
            with StartShell(self.device, timeout=1800) as ss:
                logger.info('Compress logs')
                print('Compress logs')
                got = ss.run('cli -c "file archive compress source /var/log/* destination /var/tmp/' + file_logs_archive + '"' )
                #ss.close()
            print(got)

    def download(self):
        with self.connect():
            with SCP(self.device) as scp:
                #scp.put('local-file', remote_path='path')
                scp.get('remote-file', local_path='logs/')

                logger.info('Download logs')
                scp.get('/var/tmp/' + file_logs_archive)
                logger.info('Download RSI')
                scp.get('/var/tmp/' + file_rsi_archive)

    def upload(self):
        with self.connect():
            self.logger.debug('Create /var/tmp/j/')
            f = FS(self.device)
            f.rmdir("/var/tmp/j/")
            f.mkdir("/var/tmp/j/")
            with SCP(self.device) as scp:
                scp.put("./"+self.put_files[0], remote_path='/var/tmp/j/')


    def put(self, file_name):
        self.put_files.append(file_name)
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------------------------



# ---------------------------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------------------------

def hidepass(data):
    newdata = copy.deepcopy(data)
    for key in data:
        newdata[key]['password'] = '*'*len(data[key]['password'])
    return newdata

def ping_host(host):
    ping_result = ping(target=host, count=3, timeout=1)
    if ping_result.packet_loss > 0:
        status = "No RESPONDING!"
    else:
        status = "OK"
    return {
        'host': host,
        'avg_latency': ping_result.rtt_avg_ms,
        'min_latency': ping_result.rtt_min_ms,
        'max_latency': ping_result.rtt_max_ms,
        'packet_loss': ping_result.packet_loss,
        'status': status
    }


# ---------------------------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------------------------

def import_config(fname):
    my_variables_file=open(fname, 'r')
    my_variables_in_string=my_variables_file.read()
    my_variables_in_yaml=yaml.safe_load(my_variables_in_string)
    my_variables_file.close()
    return my_variables_in_yaml

# ---------------------------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(prog='jcollect.py')
    parser.add_argument('-c', '--config', help='YAML File with configuration', default='config.yaml')
    args = parser.parse_args()
    kwargs = vars(args)
    print('Running. Press CTRL-C to exit.')

    # ---------------------------------------------------------------------------------------------
    # Check if config exist
    if os.path.isfile(kwargs['config']):
        pass
    else:
        print ("ERROR = Config File not exist")
        exit(1)

    # ---------------------------------------------------------------------------------------------
    # Load config data
    config_data = import_config(kwargs['config'])


    if not os.path.exists('data'):
        os.makedirs('data')
    if not os.path.exists('logs'):
        os.makedirs('logs')
    # ---------------------------------------------------------------------------------------------
    # Parse credentials
    credentials = dict()
    for name in config_data['credentials'][0]:
        credentials[name] = dict()
        credentials[name]['username'] = config_data['credentials'][0][name]['username']
        credentials[name]['password'] = config_data['credentials'][0][name]['password']
    
    #print ("## Variables - Credentials")
    #pprint(hidepass(credentials))
    #print("")

    # ---------------------------------------------------------------------------------------------
    # Parse devices
    devices = dict()
    for d in config_data['devices']:
        ip = d['ip']
        if (d.get('active') != False):
            devices[ip] = dict(d)

    #print ("## Variables - Devices")
    #pprint(devices)
    #print("")
    #print("---------------------")
    for ip in devices:
        credentials_profile = devices[ip]['credentials']
        try:
            devices[ip]['ssh']
        except KeyError:
            devices[ip]['ssh'] = dict()
            devices[ip]['ssh']['username']  = credentials[credentials_profile]['username']
            devices[ip]['ssh']['password']  = credentials[credentials_profile]['password']
            devices[ip]['ssh']['port']  = 22

        if not devices[ip]['ssh'].get('username'):
            devices[ip]['ssh']['username']  = credentials[credentials_profile]['username']
        if not devices[ip]['ssh'].get('password'):
            devices[ip]['ssh']['password']  = credentials[credentials_profile]['password']
        if not devices[ip]['ssh'].get('port'):
            devices[ip]['ssh']['port']  = 22
        
    #pprint(devices)

    # ---------------------------------------------------------------------------------------------
    # Check Connection
    print ("## Check ICMP connectivity")
    for (ip,values) in sorted(devices.items()):
        print(ping_host(ip))
        pass
    print("")

    # ---------------------------------------------------------------------------------------------
    # Check Connection
    print ("## Check SSH connectivity")
    terminator = 0
    for (ip,values) in sorted(devices.items()):
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        client = None
        try:
            client = paramiko.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            client.connect(ip, port=values['ssh']['port'], username=values['ssh']['username'], password=values['ssh']['password'], allow_agent=False, look_for_keys=False)
        except paramiko.ssh_exception.NoValidConnectionsError as e:
            print(ip, "ERROR - SSH Exception - NoValidConnectionsError")
            terminator = 1
            terminator_host = ip
        except paramiko.AuthenticationException as e:
            print(ip, "ERROR - AuthenticationException (passwd not correct?) ")
            terminator = 1
            terminator_host = ip
        except Exception as e:
            print("*** Caught exception: %s: %s" % (e.__class__, e))
            traceback.print_exc()
        else:
            stdin, stdout, stderr=client.exec_command('hostname')
            for line in stdout:
                ret = dict()
                if len(line) > 4:
                    status = "OK"
                else:
                    status = "ERROR - no hostname return"
                    terminator = 1
                    terminator_host = ip
                ret['host'] = ip
                ret['hostname'] = line.rstrip()
                ret['status'] = status
                devices[ip]['hostname'] = line.rstrip()
                if client:
                    client.close()
                pprint(ret)

    if terminator == 1:
        print ("")
        print ("ERROR = checkk connection with "+ terminator_host)
        print ("ERROR = Not able to collect hostname from "+terminator_host)
        exit(1)
    print("")


   
    # ---------------------------------------------------------------------------------------------
    # Collect RSI
    print ("## Collect RSI")
    for (ip,values) in sorted(devices.items()):
        juniper_device = Juniper(values)
        #juniper_device.request_rsi()
        #juniper_device.compress_rsi()
        #juniper_device.compress_logs()
        juniper_device.put("jcollect-sh/junos_CLI_BGP.sh")
        juniper_device.upload()
    exit()
    arg_parser = argparse.ArgumentParser(description=('Generate then download RSI and logs.\
                                                       Optionally upload them to the matching JTAC case.'))
    arg_parser.add_argument('hostname', help='Device to connect to')
    arg_parser.add_argument('--username', help='Juniper device username')
    default_ssh_conf = str(Path.home()) + '/.ssh/config'
    arg_parser.add_argument('--sshconf', help='SSH conf file (default: ' + default_ssh_conf + ')', default=default_ssh_conf)
    arg_parser.add_argument('--case', help='JTAC case (2020-0123-0123)')

    args = arg_parser.parse_args()

    juniper_device = Juniper(args)
    juniper_device.request_rsi()
    juniper_device.compress_logs()

    file_transfer = FileTransfer(args)
    file_transfer.download()
    if 'case' in args:
        file_transfer.upload(args.case)
        logger.info('https://casemanager.juniper.net/casemanager/#/cmdetails/' + args.case)


if __name__ == '__main__':
    main()
