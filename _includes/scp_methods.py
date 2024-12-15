import subprocess

# ----------------------- #

def _file_transfer(host, mode, local_path, remote_path):

    #Build args
    args = ['-i', host['key_file'], '-P', host['port']]
    
    if mode.startswith('dir_'):
        args.append('-r') #recursive
        
    remote_str = f'{host["user"]}@{host["ip"]}:{remote_path}'
    if mode.endswith('to_remote'):
        args.extend([local_path, remote_str])
    else:
        args.extend([remote_str, local_path])

    #Run SCP
    process = subprocess.Popen(['scp'] + args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()
    
    #Return output
    if stdout:
        print(stdout.decode())
    if stderr:
        print(stderr.decode())
    
    #Print command
    print("scp " + " ".join(args))
    return process.returncode

# ----------------------- #

def fput(host, local_path, remote_path='.'):
    return _file_transfer(host, 'file_to_remote', local_path, remote_path)

def fget(host, remote_path, local_path='.'):
    return _file_transfer(host, 'file_from_remote', local_path, remote_path)

def dput(host, local_path, remote_path='.'):
    return _file_transfer(host, 'dir_to_remote', local_path, remote_path)

def dget(host, remote_path, local_path='.'):
    return _file_transfer(host, 'dir_from_remote', local_path, remote_path)