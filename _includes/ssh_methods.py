import paramiko
import subprocess

# ----------------------- #

def _execute_ssh_command(host, command, use_sudo=False):

    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(host['ip'], host['port'], host['user'], key_filename=host['key_file'])
    
    if use_sudo:
        password = input("Enter password: ")
        command = f'echo {password} | sudo -S {command}'

    stdin, stdout, stderr = client.exec_command(command)
    result = stdout.read().decode()
    error_result = stderr.read().decode()
    
    client.close()
    
    print(result)
    if error_result: print("Error:", error_result)

# ----------------------- #

def confirm():
    confirmation = input("Are you sure? y/n or 1/0")
    if confirmation.lower() != 'y' and confirmation != '1':
        return False
    else:
        return True

# ----------------------- #

def sh(host, command):
    _execute_ssh_command(host, command)

def shc(host, command):
    if confirm(): _execute_ssh_command(host, command)

def sush(host, command):
    _execute_ssh_command(host, command, use_sudo=True)
    
# ----------------------- #

def ssh(host):
    args = [f'{host["user"]}@{host["ip"]}', '-i', host["key_file"], '-p', host["port"]]
    subprocess.Popen(['ssh'] + args, creationflags=subprocess.CREATE_NEW_CONSOLE)
    print("ssh " + " ".join(args))