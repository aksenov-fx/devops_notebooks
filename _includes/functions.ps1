
# ---------------------------- #

# Function to execute single ssh command
function sh ($command) {
    $command = $command -replace "`r`n", "`n"
    ssh $user@$public_ip -i $key_file $command
}

# ---------------------------- #

# Function to execute single ssh command in terminal - allows to use sudo
function sush ($command) {

$arg = @"
/k ssh -t $user@$public_ip -i $key_file "$command"
"@

Start-Process cmd -A $arg

} #https://stackoverflow.com/questions/74941116/how-to-run-sudo-command-via-ssh-by-powershell-in-cmd-exe

# ---------------------------- #

# Function to copy a file to remote host
function shcp ($file) {
    scp -i $key_file $file $user@${public_ip}: 
}

# ---------------------------- #

# Function to copy a file from remote host
function shget ($file) {
    scp -i $key_file $user@${public_ip}:$file .\
}