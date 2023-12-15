import os
import sys
import re
import argparse


def slice(jcollect_file, hostname_overwrite):
    time_line_pattern = r'^=== \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \w+ \[\+\d{4}\] \| \d+$'
    print(jcollect_file)

    with open(jcollect_file, 'r', errors='replace') as inflie:
        for line in inflie.readlines():
            
            if line.startswith(">===="):
                new_section = 0
                hostname = None
                command_date = None
                full_line_date = None
                full_line_command = None
                file_name = None
                continue
        
            if line.startswith("=== "):
                if '@' in line:
                    # Find the position of "@" and ":"
                    at_position = line.find("@")
                    colon_position = line.find(":")
                    # Extract the substring between "@" and ":"
                    if at_position != -1 and colon_position != -1 and at_position < colon_position:
                        hostname = line[at_position + 1 : colon_position]
                    else:
                        hostname = "unknown-hostname"
                
                if '# cli -c show ' in line:
                    #f.close()
                    pattern = r'-c\s(.*?)\s\|'
                    match = re.search(pattern, line)
                    extracted_command = match.group(1)
                    file_name = extracted_command.replace(' ', '_')
                    #file_name = '_'.join(line.split('"')[1].split('|')[0].split())
                    #f = open(os.path.join(dev_name, file_name), 'w')

                if '# cprod -A fpc0 -c show' in line:
                    pattern = r"cprod -A (\w+) -c (.*)"
                    match = re.search(pattern, line)
                    fpc = match.group(1)
                    component1 = match.group(2)
                    extracted_command = f"{component1}-{fpc}"
                    file_name = extracted_command.replace(' ', '_')
                    pass
                    
                if '# cprod -A fpc0 -c set' in line:
                    pattern = r"cprod -A (\w+) -c set (.*)"
                    match = re.search(pattern, line)
                    fpc = match.group(1)
                    bcm_command = match.group(2).strip().replace('"', '')
                    extracted_command = f"{bcm_command}-{fpc}"
                    file_name = extracted_command.replace(' ', '_')
                    pass
                     
                if re.match(time_line_pattern, line):
                    full_line_date = line
                    pattern = r'=== (\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})'
                    match = re.search(pattern, line)
                    year, month, day, hour, minute, second = match.groups()
                    command_date = f"{year}{month}{day}-{hour}{minute}{second}-"
                    continue
                
                full_line_command = line
                   
                    
                

            if line.startswith("============================================="):
                if hostname_overwrite is not None:
                    hostname = hostname_overwrite
                directory_path = os.path.join(os.getcwd(), hostname)
                if not os.path.exists(directory_path):
                    os.makedirs(directory_path)
            
                print("hostname:", hostname)
                filename = f"{command_date}{file_name}.log"
                #print(command_date)
                print(filename)
                print(line)
                f = open(os.path.join(directory_path, filename), 'w')
                f.write(line)
                f.write(full_line_command)
                f.write(full_line_date)
                new_section = 1
                pass
                
            if new_section == 1:
                f.write(line)


if __name__ == '__main__':
    # Create the argument parser
    parser = argparse.ArgumentParser(description='JCollect Argument Parser')

    # Add the arguments
    parser.add_argument('-f', '--file', help='File argument', required=True)
    parser.add_argument('-n', '--name', help='Name argument', default=None)


    # Parse the arguments
    args = parser.parse_args()


    slice(args.file, args.name)

