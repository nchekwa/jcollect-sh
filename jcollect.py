#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# Name: jcollect.py
# Version: 0.1 [2021-12-14]
#
# Copyright 2021 Artur Zdolinski
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


import argparse
import datetime
import time
import copy
import os.path
import os
import sys
import re
import threading
import socket
import traceback
import yaml
import queue

from pythonping import ping
from termcolor import colored
from signal import signal, SIGINT
from pprint import pprint
from contextlib import contextmanager
from boltons.strutils import bytes2human

from jnpr.junos import Device
from jnpr.junos.utils.fs import FS
from jnpr.junos.utils.scp import SCP
from jnpr.junos.utils.start_shell import StartShell

# ---------------------------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------------------------
class Juniper():
    def __init__(self, args):
        self.put_files = []
        self.args = args
        # Define Device
        self.device = Device(host=args['ip'], user=args['ssh']['username'], passwd=args['ssh']['password'], port=args['ssh']['port'], gather_facts=False)
    
    @contextmanager
    def connect(self):
        try:
            self.device.open(auto_probe=2)
            self.device.timeout = 900
        except Exception as err:
            print(f"=>[SSH]      Host: {self.args['ip']} | Exception device connection open: {type(err).__name__} was raised: {err}")
            return(False)
            
        print("[SSH]      Host: "+self.args['ip']+" | Connected to "+self.args['ip'] ,  flush=True)
        try:
            yield
        finally:
            self.disconnect()
    
    @contextmanager
    def disconnect(self):
        self.device.close()
        print("[SSH]      Host: "+self.args['ip']+" | Disconnected from "+self.args['ip'] ,  flush=True)

    def StartShellOutput(self,cmd):
        ind1 = cmd.find('\n')
        ind2 = cmd.rfind('\n')
        return cmd[ind1+1:ind2].rstrip()

    def jcollect(self):
        with self.connect():
            with StartShell(self.device, timeout=1800) as ss:
                startTime_ALL_DONE = time.time()

                # check hostname
                (exit_code, got) = ss.run("hostname -s", timeout=10)
                hostname = str(self.StartShellOutput(got).rstrip())
                print("[SHELL]    Host: "+self.args['ip']+" | Hostname: "+hostname ,  flush=True)

                # Check local data_time
                (exit_code, got) = ss.run("date '+%Y-%m-%d_T%H%M'", timeout=10)
                date_time = str(self.StartShellOutput(got).rstrip())
                print("[SHELL]    Host: "+self.args['ip']+" ["+hostname+"] | Data_Time: "+date_time ,  flush=True)

                path = "/var/tmp/"+date_time+"_"+hostname+"_jcollect/"
  
                print("[SHELL]    Host: "+self.args['ip']+" ["+hostname+"] | mkdir: "+path ,  flush=True)
                (exit_code, got) = ss.run("mkdir "+path, timeout=10)
                (exit_code, got) = ss.run("mkdir "+path+"/xml", timeout=10)

                print("[SHELL]    Host: "+self.args['ip']+" ["+hostname+"] | Collect XML files..." ,  flush=True)
                startTime = time.time()
                (exit_code, got) = ss.run('cli -c "show system information | display xml | no-more" > '+path+'/xml/show_system_information.xml', timeout=20)
                (exit_code, got) = ss.run('cli -c "show system uptime | display xml | no-more" > '+path+'/xml/show_system_uptime.xml', timeout=20)
                (exit_code, got) = ss.run('cli -c "show interfaces extensive | display xml | no-more" > '+path+'/xml/show_interfaces_extensive.xml', timeout=20)
                (exit_code, got) = ss.run('cli -c "show lldp neighbors | display xml | no-more" > '+path+'/xml/show_lldp_neighbors.xml', timeout=20)
                endTime = time.time()
                print("[SHELL]    Host: "+self.args['ip']+" ["+hostname+"] | Collect XML files - DONE: {0:.2f} sec".format(endTime - startTime),  flush=True)

            with SCP(self.device) as scp:
                for file in self.args['files']:
                    print("[SCP]      Host: "+self.args['ip']+" ["+hostname+"] | Upload file: ./jcollect-sh/"+file+" -> remote_path: "+path ,  flush=True)
                    scp.put("./jcollect-sh/"+file, remote_path=path)  

            with StartShell(self.device, timeout=1800) as ss:
                # Run EXTERNAL scripts
                for file in self.args['files']:
                    file_log = os.path.splitext(file)[0]+'.log'
                    print("=>[SHELL]    Host: "+self.args['ip']+" ["+hostname+"] | run EXTERNAL "+file,  flush=True)
                    startTime = time.time()
                    (exit_code, got) = ss.run("sh "+path+"/"+file+" > "+path+"/"+file_log, timeout=1799)
                    endTime = time.time()
                    print("=>[SHELL]    Host: "+self.args['ip']+" ["+hostname+"] | run EXTERNAL "+file+" - DONE: {0:.2f} sec".format(endTime - startTime),  flush=True)

                # Generat RSI
                print('=>[SHELL]    Host: '+self.args['ip']+' ['+hostname+'] | Generate RSI...',  flush=True)
                startTime = time.time()
                (exit_code, got) = ss.run('cli -c \"request support information | save '+path+'/RSI_'+hostname+'_'+date_time+'.txt" ', timeout=900)
                endTime = time.time()
                print('[SHELL]    Host: '+self.args['ip']+' ['+hostname+'] | RSI: '+self.StartShellOutput(got) ,  flush=True)
                print('=>[SHELL]    Host: '+self.args['ip']+' ['+hostname+'] | Generate RSI - DONE: {0:.2f} sec'.format(endTime - startTime) ,  flush=True)

                # Compres LOG folder
                print('=>[SHELL]    Host: '+self.args['ip']+' ['+hostname+'] | Compress LOG folder...' ,  flush=True)
                startTime = time.time()
                (exit_code, got) = ss.run('cd /var/; tar -zcvf '+path+'/LOGS_'+hostname+'_'+date_time+'.tgz log/*', timeout=120)
                endTime = time.time()
                print('[SHELL]    Host: '+self.args['ip']+' ['+hostname+'] | LOG created '+path+'/LOGS_'+hostname+'_'+date_time+'.tgz' ,  flush=True)
                print('=>[SHELL]    Host: '+self.args['ip']+' ['+hostname+'] | Compress LOG folder - DONE: {0:.2f} sec'.format(endTime - startTime) ,  flush=True)

                # Compres ALL Filess
                print('=>[SHELL]    Host: '+self.args['ip']+' ['+hostname+'] | Compress all files to JCOLLECT TGZ...' ,  flush=True)
                (exit_code, got) = ss.run('cd /var/tmp/; tar -zcvf /var/tmp/'+date_time+'_'+hostname+'_jcollect.tgz '+date_time+'_'+hostname+'_jcollect/*', timeout=120)
                print('[SHELL]    Host: '+self.args['ip']+' ['+hostname+'] | Final JCollect TGZ: /var/tmp/'+date_time+'_'+hostname+'_jcollect.tgz' ,  flush=True)

            f = FS(self.device)
            statJCollect = f.stat('/var/tmp/'+date_time+'_'+hostname+'_jcollect.tgz')
            if statJCollect['size'] is not None:
                print('=>[FS]       Host: '+self.args['ip']+' ['+hostname+'] | JCollect TGZ Size: '+(str(bytes2human(statJCollect['size'], 2) )) ,  flush=True)
            else:
                print('=>[FS]       Host: '+self.args['ip']+' ['+hostname+'] | Error: /var/tmp/'+date_time+'_'+hostname+'_jcollect.tgz')
                return(True)

            with SCP(self.device) as scp:
                print('=>[SCP]      Host: '+self.args['ip']+' ['+hostname+'] | JCollect TGZ Download...' ,  flush=True)
                startTime = time.time()
                scp.get('/var/tmp/'+date_time+'_'+hostname+'_jcollect.tgz', local_path=self.args['dst_path'])
                endTime = time.time()
                print('=>[SCP]      Host: '+self.args['ip']+' ['+hostname+'] | JCollect TGZ Download - DONE: {0:.2f} sec'.format(endTime - startTime) ,  flush=True)

            with StartShell(self.device, timeout=20) as ss:
                # Cleanup - Remove from device jcollect.tgz file
                print('[SHELL]    Host: '+self.args['ip']+' ['+hostname+'] | Remove TGZ: /var/tmp/'+date_time+'_'+hostname+'_jcollect.tgz' , flush=True)
                (exit_code, got) = ss.run('rm /var/tmp/'+date_time+'_'+hostname+'_jcollect.tgz', timeout=5)

                print('[SHELL]    Host: '+self.args['ip']+' ['+hostname+'] | Remove Folder: /var/tmp/'+date_time+'_'+hostname+'_jcollect/' , flush=True)
                (exit_code, got) = ss.run('rm -R /var/tmp/'+date_time+'_'+hostname+'_jcollect/', timeout=5)

                endTime = time.time()
                print('=>[SHELL]    Host: '+self.args['ip']+' ['+hostname+'] | ALL DONE: {0:.2f} sec'.format(endTime - startTime_ALL_DONE) ,  flush=True)
            
            return(False)
            
    def StartShell(self,bash_command):
        try:
            with self.connect():
                with StartShell(self.device, timeout=1800) as ss:
                    print("[SSH]      Host: "+self.args['ip']+" | StartShell command: "+bash_command,  flush=True)
                    (exit_code, got) = ss.run(bash_command)
                    #ss.close()
                return(exit_code, self.StartShellOutput(got))
        except:
            return(False,"")

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
def threaded(f, daemon=True):
    def wrapped_f(q, *args, **kwargs):
        ret = f(*args, **kwargs)
        q.put(ret)

    def wrap(*args, **kwargs):
        q = queue.Queue()
        thread = threading.Thread(target=wrapped_f, args=(q,)+args, kwargs=kwargs)
        thread.setDaemon(daemon)
        thread.start()
        thread.result_queue = q        
        return thread

    return wrap

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

def import_config(arg):
    full_config=dict()
    exit_code=0
    config_names = arg['config']
    dst_path = arg['path']
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
    # 3) Check if device has bundle defined
    for device_name, device_parameters in full_config['devices'].items():
        full_config['devices'][device_name]['dst_path'] = dst_path

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

        # 3) Check if device has bundle defined
        if full_config['devices'][device_name].get('bundle'):
            b_name = full_config['devices'][device_name]['bundle']
            if full_config.get('bundle'):
                if full_config['bundle'].get(b_name):
                    full_config['devices'][device_name]['files'] = full_config['bundle'].get(b_name)
                else:
                    print (colored('[error]', 'red') + "    CONFIG -> Bundle: "+ colored(b_name, 'red') + " for device "+device_name+ " dosn't not exist "   )
                    exit_code = 1
            else:
                print (colored('[error]', 'red') + "    CONFIG -> Bundle section not found"   )
                exit_code = 1
        else:
            full_config['devices'][device_name]['files'] = []



    if exit_code != 0:
        print (colored('[error]', 'red') + "    Please fix config file before next start"   )
        exit(exit_code)

    return full_config

@threaded
def check_icmp_device(host_config):
    sys.stdout.register(host_config['dst_path']+'/log-'+str(host_config['ip'])+'.log')
    print("[ICMP]     Host: "+host_config['ip']+" | Start: "+ datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S") )
    icmp = ping_host(host_config['ip'])
    print("[ICMP]     Host: "+host_config['ip']+" | Debug: "+str(icmp), flush=True)
    if icmp['status'] == "OK":
        print("=>[ICMP]     Host: "+host_config['ip']+" | Status: "+colored(icmp['status'], 'green')+" | AVG_Latency: "+str(icmp['avg_latency'])+" ms",  flush=True)
    else:
        print("=>[ICMP]     Host: "+host_config['ip']+" | Status: "+colored(icmp['status'], 'red') ,  flush=True)
    return icmp

@threaded
def check_ssh(host_config):
    ret=dict()
    sys.stdout.register(host_config['dst_path']+'log-'+str(host_config['ip'])+'.log', 'a')
    print("[SHELL]    Host: "+host_config['ip']+" | Start: "+ datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S") )

    juniper_device = Juniper(host_config)
    hostname = juniper_device.StartShell("hostname -s")

    ret['host'] = host_config['ip']
    ret['hostname'] = hostname[1].rstrip()

    if len(hostname[1]) > 4:
        ret['status'] = "OK"
    else:
        ret['status'] = "ERROR - no hostname return"

    if hostname[0] == True:
        ret['status'] = "OK"
    else:
        ret['status'] = "StartShell Failed"

    print("[SHELL]    Host: "+host_config['ip']+" | Debug: "+str(ret), flush=True)
    if ret['status'] == "OK":
        print("=>[SHELL]    Host: "+host_config['ip']+" | Status: "+colored(ret['status'], 'green')+" | Hostname: "+str(ret['hostname']),  flush=True)
    else:
        print("=>[SHELL]    Host: "+host_config['ip']+" | Status: "+colored(ret['status'], 'red') ,  flush=True)

    return(ret)

@threaded
def jcollect(host_config):
    sys.stdout.register(host_config['dst_path']+'log-'+str(host_config['ip'])+'.log', 'a')
    print("[COLLECT]  Host: "+host_config['ip']+" | Start: "+ datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S") )
    juniper_device = Juniper(host_config)
    juniper_device.connect()
    juniper_device.jcollect()
        
    return(False)
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    signal(SIGINT, signal_handler) 
    prog_path = os.path.abspath(os.getcwd())
    parser = argparse.ArgumentParser(prog='jcollect.py')
    parser.add_argument('-c', '--config', help='YAML Files with configuration (multiple names separated by comma)', default=prog_path+'/config.yaml')
    parser.add_argument('-p', '--path', help='Output path where store worker logs and data', )
    parser.add_argument('-i', '--id', help='Worker ID', default=datetime.datetime.now().strftime("%Y%m%d-%H%M%S") )
    parser.add_argument('-a', '--action', help='Action [jcollect|rsi|logs]', default="jcollect")
    parser.add_argument('-H', '--host', help='IP Host', default="False")
    args = parser.parse_args()
    kwargs = vars(args)

    # ---------------------------------------------------------------------------------------------
    # Create Paths

    # If defined path not exist - create this path
    if kwargs['path'] is None:
        # Set default path to ./jcollect-data/ and create this
        kwargs['path'] = prog_path+"/jcollect-data/"
        if not os.path.exists(kwargs['path']):
            os.makedirs(kwargs['path'])
        # Stor data in ./jcollect-data/ID folder
        kwargs['path'] = prog_path+"/jcollect-data/"+kwargs['id']+"/"
        if not os.path.exists(kwargs['path']):
            os.makedirs(kwargs['path'])
    # If path is pass in ARG then create path if not exist
    else:
        if not os.path.exists(kwargs['path']):
            os.makedirs(kwargs['path'])

    # clean up path string
    kwargs['path'] = kwargs['path'].replace("//", "/")

    # ---------------------------------------------------------------------------------------------
    # Set logger file
    main_log_file = (kwargs['path']+'/log-main.log').replace("//", "/")
    sys.stdout = Logger()
    sys.stdout.register(main_log_file)

    # ---------------------------------------------------------------------------------------------
    print(colored('[facts]    ', 'blue') + "Time: " + colored(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), 'blue'))
    print(colored('[facts]    ', 'blue') + "ID: " + colored(kwargs['id'], 'blue'))
    print(colored('[facts]    ', 'blue') + "Action: " + colored(kwargs['action'], 'blue'))
    print(colored('[facts]    ', 'blue') + "Config: " + colored(kwargs['config'], 'blue'))
    print(colored('[facts]    ', 'blue') + "Path: " + colored(kwargs['path'], 'blue'))
    print(colored('[facts]    ', 'blue') + "Log: " + colored(main_log_file, 'blue'))

    # ---------------------------------------------------------------------------------------------
    # Check if config exist
    full_config = import_config(kwargs)
    hosts = []
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

   # pprint(hosts)


    
    # ---------------------------------------------------------------------------------------------
    # Check if host exist in config and ping ICMP
    print("[ICMP]     Start: "+ colored(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), 'blue'))
    threads_icmp = []
    for host in hosts:
        host_config = get_host_configuration(host,full_config)

        if host_config.get("ip"):
            th = check_icmp_device(host_config)
            threads_icmp.append(th)
        else:
            print(colored('[error]    ', 'red') + "Host: " + colored(host, 'red') + " - not found config")
            exit(1)
    
    # Wait for all threads
    for th in threads_icmp:
        th.join()

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

    for th in threads_ssh:
        result = th.result_queue.get()
        if result['status'] != "OK":
            hosts.remove(result['host'])
            print(colored('[warning]  ', 'red') + "Host: " + colored(result['host'], 'red') + " - not respoding on SSH check - remove from next step")

    print("[SSH]      End: " + colored(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), 'blue'))

    # ---------------------------------------------------------------------------------------------
    # JCollect
    print("[COLLECT]  Start: "+ colored(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), 'blue'))
    threads_ssh = []
    for host in hosts:
        host_config = get_host_configuration(host,full_config)
        th = jcollect(host_config)
        threads_ssh.append(th)

    # Wait for all threads
    for th in threads_ssh:
        th.join()

    print("[COLLECT]  End: " + colored(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), 'blue'))
    exit(0)
   
