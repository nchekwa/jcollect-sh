#!/usr/bin/env python3

import argparse
import datetime
import time
import logging
import copy
import os.path
import os
import sys
import re
import threading
import socket
import traceback

from signal import signal, SIGINT
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
from termcolor import colored
# 
import paramiko
import yaml




#logging.basicConfig(level=logging.INFO)

#logging.getLogger("ncclient.transport").setLevel(logging.WARNING)
#logging.getLogger("ncclient.operations.rpc").setLevel(logging.WARNING)
#logging.getLogger("paramiko").setLevel(logging.WARNING)

utc_date_time =  datetime.datetime.utcnow().strftime("%Y-%m-%d_%H-%M")
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

    def get_hostname(self):
        with self.connect():
            with StartShell(self.device, timeout=10) as ss:
                self.logger.info('Check hostname.')
                print('Check hostname.')
                got = ss.run('hostname -s')
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
class Logger(object):
    def __init__(self):                             # Based on: https://newbedev.com/redirect-stdout-to-a-file-only-for-a-specific-thread
        self.terminal = sys.stdout                  # To continue writing to terminal
        self.log=dict()                             # A dictionary of file pointers for file logging
        self.ansi_escape = re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])')
        self.main_terminal_ident = threading.currentThread().ident

    def register(self,filename="jcollect.log", mode="w"):     # To start redirecting to filename
        ident = threading.currentThread().ident
        if ident in self.log:                       # If already in dictionary :
            self.log[ident].close()                 # Closing current file pointer
        self.log[ident] = open(filename, mode, encoding = 'utf-8')       # Creating a new file pointed associated with thread id

    def write(self, message):
        ident = threading.currentThread().ident         # Get Thread id
        if message.startswith( '=>' ):
            message = message[2:]
            self.terminal.write(message+"\n")

        if ident == self.main_terminal_ident:
            self.terminal.write(message)

        message = self.ansi_escape.sub('', message) # remove ansi collors before write to file
        if ident in self.log:                       # Check if file pointer exists
            self.log[ident].write(message)          # write in file
            self.log[ident].flush()
        else:                                       # if no file pointer 
            for ident in self.log:                  # write in all thread (this can be replaced by a Write in terminal)
                self.log[ident].write(message)  
                self.log[ident].flush()
        self.terminal.flush()
        
    def flush(self):
        #this flush method is needed for python 3 compatibility.
        #this handles the flush command by doing nothing.
        ident = threading.currentThread().ident
        self.log[ident].flush()
        self.terminal.flush()

    def __exit__(self, exc_type, exc_value, tb):
        sys.stdout = self.stdout
        ident = threading.currentThread().ident
        if exc_type is not None:
            self.log[ident].write(traceback.format_exc())
        self.log[ident].close()
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------------------------
def threaded(fn):
    def wrapper(*args, **kwargs):
        thread = threading.Thread(target=fn, args=args, kwargs=kwargs)
        thread.setDaemon(True)
        thread.start()
        return thread
    return wrapper

def signal_handler(signal_received, frame):
    # Handle any cleanup here
    print('SIGINT or CTRL-C detected. Exiting gracefully')
    exit(0)

def hidepass(data):
    newdata = copy.deepcopy(data)
    for key in data:
        newdata[key]['password'] = '*'*len(data[key]['password'])
    return newdata

def validate_ip(s):
    if not isinstance(s, str):
        return False
    a = s.split('.')
    if len(a) != 4:
        return False
    for x in a:
        if not x.isdigit():
            return False
        i = int(x)
        if i < 0 or i > 255:
            return False
    return True

def hostname_resolver(hostname):
    try:
        return socket.gethostbyname(hostname)
    except socket.error:
        return 0

def ping_host(host, count=2, timeout=1):
    ping_result = ping(target=host, count=count, timeout=timeout)
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
def dict_fmerge(base_dct, merge_dct, add_keys=True):
    rtn_dct = base_dct.copy()
    if add_keys is False:
        merge_dct = {key: merge_dct[key] for key in set(rtn_dct).intersection(set(merge_dct))}

    rtn_dct.update({
        key: dict_fmerge(rtn_dct[key], merge_dct[key], add_keys=add_keys)
        if isinstance(rtn_dct.get(key), dict) and isinstance(merge_dct[key], dict)
        else merge_dct[key]
        for key in merge_dct.keys()
    })
    return rtn_dct

def get_host_configuration(host,full_config):
    host_config = dict()
    # Loop via all devices and check if host match name or IP field
    for device_name, device_parameters in full_config['devices'].items():
        if device_name == host:
            host_config = device_parameters
            return host_config
        if device_parameters['ip'] == host:
            host_config = device_parameters
            return host_config
    return dict()

def parse_yaml_config(fname):
    my_config_file=open(fname, 'r')
    my_variables_in_string=my_config_file.read()
    my_config=yaml.safe_load(my_variables_in_string)
    my_config_file.close()
    # If IP is not define for device
    # assign object name to IP variable
    if my_config.get('devices'):
        for device_name, device_parameters in my_config['devices'].items():
            if 'ip' not in device_parameters:
                # Check if device is IP?
                if validate_ip(device_name) == True:
                    my_config['devices'][device_name]['ip'] = device_name
                else:
                    # Try to resolve NAME->IP
                    ip = hostname_resolver(device_name)
                    if validate_ip(ip) == True:
                        my_config['devices'][device_name]['ip'] = ip
                    else:
                        print (colored('[error]', 'red') + "    Cant resolve name "+ colored(device_name, 'red') + " to IP"  )
                        exit(1)
    return my_config

def import_config(config_names):
    full_config=dict()
    exit_code=0
    if "," in config_names:
        fnames = config_names.split(",")
    else:
        fnames = []
        fnames.append(config_names)

    # Marge multple config file in one dict
    for fname in fnames:
        if os.path.isfile(fname):
            print(colored('[facts]    ', 'blue') + "Config: " + colored(fname, 'blue'))
            file_config = dict(parse_yaml_config(fname))
            full_config = dict_fmerge(full_config, file_config)
        else:
            print (colored('[error]', 'red') + "    Config file NOT exist: "+ colored(fname, 'red')   )
            exit(1) # 1 = Generic Exit Code
    
    # Check if Config secions exist
    if 'devices' not in full_config.keys():
        print (colored('[error]', 'red') + "    Config does NOT contain sections "+ colored('devices', 'red')   )
        exit(1)
    if 'credentials' not in full_config.keys():
        print (colored('[error]', 'red') + "    Config does NOT contain sections "+ colored('credentials', 'red')   )
        exit(1)

    # Create Device dict
    # 1) Remove from dict not active devices
    # 2) Assign ssh user and password to devices
    for device_name, device_parameters in full_config['devices'].items():
        # 1) Remove DISABLED devices
        if full_config['devices'][device_name].get('active') == False:
            print (colored('[facts]', 'cyan') + "    CONFIG -> device: "+ colored(device_name, 'cyan') + " -> active: "+ colored("FALSE", 'cyan')   )
            continue
        else:
            full_config['devices'][device_name]['active'] = True
        
        # 2) Create Device SSH atributes if not exist
        if full_config['devices'][device_name].get('ssh') is None:
            full_config['devices'][device_name]['ssh'] = dict()
            full_config['devices'][device_name]['ssh']['port'] = 22
        else:
            if full_config['devices'][device_name]['ssh'].get('port') is None:
                full_config['devices'][device_name]['ssh']['port'] = 22

        # 2) Check if device has credential atribute
        if full_config['devices'][device_name].get('credentials'):
            credential_name = full_config['devices'][device_name].get('credentials')
            # Validate credentials
            if full_config['credentials'][credential_name].get('username') is None:
                print (colored('[error]', 'red') + "    CONFIG -> Credentials: "+ colored(credential_name, 'red') + " dosn't have "+ colored("username", 'red')   )
                exit_code = 1
            else:
                full_config['devices'][device_name]['ssh']['username'] = full_config['credentials'][credential_name].get('username')
            if full_config['credentials'][credential_name].get('password') is None:
                print (colored('[error]', 'red') + "    CONFIG -> Credentials: "+ colored(credential_name, 'red') + " dosn't have "+ colored("password", 'red')   )
                exit_code = 1
            else:
                full_config['devices'][device_name]['ssh']['password'] = full_config['credentials'][credential_name].get('password')

        else:
            # Check if device has ssh username and password / as it dosnt have credentials defined
            if full_config['devices'][device_name].get('ssh'):
                if full_config['devices'][device_name]['ssh'].get('username') is None:
                    print (colored('[error]', 'red') + "    CONFIG -> Device: "+ colored(device_name, 'red') + " dosn't have "+ colored("ssh: username", 'red')   )
                    exit_code = 1
                if full_config['devices'][device_name]['ssh'].get('password') is None:
                    print (colored('[error]', 'red') + "    CONFIG -> Device: "+ colored(device_name, 'red') + " dosn't have "+ colored("ssh: password", 'red')   )
                    exit_code = 1
            else:
                print (colored('[error]', 'red') + "    CONFIG -> Device: "+ colored(device_name, 'red') + " dosn't have SSH credentials "   )
                exit_code = 1

    if exit_code != 0:
        print (colored('[error]', 'red') + "    Please fix config file before next start"   )
        exit(exit_code)

    return full_config

@threaded
def check_device(host_config):
    sys.stdout.register('thread-'+str(host_config['ip'])+'.log')
    print("[ICMP]     Host: "+host_config['ip'])
    icmp = ping_host(host_config['ip'])
    print("[debug]    "+str(icmp), flush=True)
    if icmp['status'] == "OK":
        print("=>[ICMP]     Host: "+host_config['ip']+" | Status: "+colored(icmp['status'], 'green')+" | AVG_Latency: "+str(icmp['avg_latency'])+" ms",  flush=True)
    else:
        print("=>[ICMP]     Host: "+host_config['ip']+" | Status: "+colored(icmp['status'], 'red') ,  flush=True)
    return icmp

@threaded
def check_ssh(host_config):
    sys.stdout.register('thread-'+str(host_config['ip'])+'.log', 'a')
    print("=>[SSH]      Host: "+host_config['ip'])

    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    client = None
    try:
        print("[SSH]      trying... ")
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        client.connect(host_config['ip'], port=int(host_config['ssh']['port']), username=host_config['ssh']['username'], password=host_config['ssh']['password'], allow_agent=False, look_for_keys=False, timeout=10)
        # s.connect(hostname, username=user, key_filename = password, timeout=60)
    except paramiko.ssh_exception.NoValidConnectionsError as e:
        print("=>[SSH]      Host: "+host_config['ip']+" | Status: NoValidConnectionsError")
        return {
            'host': host_config['ip'],
            'reason': "NoValidConnectionsError",
            'status': "Exception"
        }
    except paramiko.AuthenticationException as e:
        print("=>[SSH]      Host: "+host_config['ip']+" | Status: AuthenticationException (passwd not correct?)")
        return {
            'host': host_config['ip'],
            'reason': "AuthenticationException",
            'status': "Exception"
        }
    except Exception as e:
        print("=>[SSH]      Host: "+host_config['ip']+" | Caught exception: %s: %s" % (e.__class__, e))
        return {
            'host': host_config['ip'],
            'reason': e.__class__,
            'status': "Exception"
        }
    else:
        stdin, stdout, stderr=client.exec_command('hostname')
        for line in stdout:
            ret = dict()
            if len(line) > 4:
                status = "OK"
            else:
                status = "ERROR - no hostname return"
                exitcode = 1
            ret['host'] = host_config['ip']
            ret['hostname'] = line.rstrip()
            ret['status'] = status
            if client:
                client.close()
            print("[debug]    "+str(ret), flush=True)
            if ret['status'] == "OK":
                print("=>[SSH]      Host: "+host_config['ip']+" | Status: "+colored(ret['status'], 'green')+" | Hostname: "+str(ret['hostname']),  flush=True)
            else:
                print("=>[SSH]      Host: "+host_config['ip']+" | Status: "+colored(ret['status'], 'red') ,  flush=True)
            return(ret)
    

# ---------------------------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------------------------
def main():
    signal(SIGINT, signal_handler) 
    prog_path = os.path.abspath(os.getcwd())
    parser = argparse.ArgumentParser(prog='jcollect.py')
    parser.add_argument('-c', '--config', help='YAML File with configuration', default=prog_path+'/config.yaml')
    parser.add_argument('-p', '--path', help='Output path where store worker logs', default=prog_path+"/jcollect-data/")
    parser.add_argument('-i', '--id', help='Worker ID', default=datetime.datetime.now().strftime("%Y%m%d-%H%M%S") )
    parser.add_argument('-a', '--action', help='Action [jcollect|rsi|logs]', default="jcollect")
    parser.add_argument('-H', '--host', help='IP Host', default="False")
    args = parser.parse_args()
    kwargs = vars(args)

    # ---------------------------------------------------------------------------------------------
    # Set logger file
    sys.stdout = Logger()
    sys.stdout.register('thread-main.log')



    # ---------------------------------------------------------------------------------------------
    print(colored('[facts]    ', 'blue') + "Time: " + colored(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), 'blue'))
    print(colored('[facts]    ', 'blue') + "ID: " + colored(kwargs['id'], 'blue'))
    print(colored('[facts]    ', 'blue') + "Action: " + colored(kwargs['action'], 'blue'))
    print(colored('[facts]    ', 'blue') + "Config: " + colored(kwargs['config'], 'blue'))
    print(colored('[facts]    ', 'blue') + "Path: " + colored(kwargs['path'], 'blue'))

    # ---------------------------------------------------------------------------------------------
    # Check if config exist
    full_config = import_config(kwargs['config'])
    hosts = []
    #pprint(full_config)
    if kwargs['host'] != "False":
        if "," in kwargs['host']:
            hosts = kwargs['host'].replace(" ", "").split(",")
        else:
            hosts.append(kwargs['host'])

        for host in hosts:
            print(colored('[facts]    ', 'blue') + "Host: " + colored(host, 'blue'))
    else:
        for device_name, device_parameters in full_config['devices'].items():
            if full_config['devices'][device_name].get('active') == True:
                hosts.append(device_parameters['ip'])
                print(colored('[facts]    ', 'blue') + "Host: " + colored(device_parameters['ip'], 'blue'))
    # ---------------------------------------------------------------------------------------------
    # Create Paths
    if not os.path.exists(kwargs['path']):
        os.makedirs(kwargs['path'])
        print(colored('[facts]    ', 'blue') + "Create path: " + colored(kwargs['path'], 'blue'))
    if kwargs['path'] == prog_path+"/jcollect-data/":
        if not os.path.exists(kwargs['path']):
            os.makedirs(kwargs['path'])
            print(colored('[facts]    ', 'blue') + "Create path: " + colored(kwargs['path'], 'blue'))
    if not os.path.exists(kwargs['path']+"/"+kwargs['id']):
        os.makedirs(kwargs['path']+"/"+kwargs['id'])
        print(colored('[facts]    ', 'blue') + "Create path: " + colored(kwargs['path']+"/"+kwargs['id'], 'blue'))
    # ---------------------------------------------------------------------------------------------
    # Check if host exist in config and ping ICMP
    print("[ICMP]     Start: "+ colored(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), 'blue'))
    threads_icmp = []
    for host in hosts:
        host_config = get_host_configuration(host,full_config)

        if host_config.get("ip"):
            th = check_device(host_config)
            threads_icmp.append(th)
        else:
            print(colored('[error]    ', 'red') + "Host: " + colored(host, 'red') + " - not found config")
            exit(1)
    
    # Wait for all threads
    for th in threads_icmp:
        th.join()

    #time.sleep(5)
    print("[ICMP]     End: " + colored(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), 'blue'))

    # ---------------------------------------------------------------------------------------------
    # Check Connection
    print("[SSH]      Start: "+ colored(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), 'blue'))
    threads_ssh = []
    for host in hosts:
        host_config = get_host_configuration(host,full_config)
        th = check_ssh(host_config)
        threads_ssh.append(th)

    # Wait for all threads
    for th in threads_ssh:
        th.join()

    #time.sleep(5)
    print("[SSH]      End: " + colored(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), 'blue'))


    exit(0)
   
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
