# Instructions:

    # 1. Enter SSH session in VS Code terminal
    # 2. Select lines or set cursor on a line that you want to execute
    # 3. Click F8 (default key in VS code)

# ----------------------------------------------------------
### Initialize

   ssh dietpi@192.168.0.30

# ----------------------------------------------------------
### SSH Setup

 # Install openssh-server

    sudo apt update
    sudo apt install -y openssh-server
    ufw allow ssh
    sudo systemctl enable ssh --now

 # Generate key
    ssh-keygen

 # Download and run ssh script
    confirm

    wget https://raw.githubusercontent.com/aksenov-fx/bash/main/install_ssh.sh
    chmod +x install_ssh.sh
    ./install_ssh.sh 

 # Copy key - bash
    ssh-copy-id -i ~/.ssh/id_rsa.pub user@host

 # Copy key - Powershell
    type $env:USERPROFILE\.ssh\id_rsa.pub | ssh user@host "cat >> .ssh/authorized_keys"

 # Will add separator line after each bash command for readability
    echo 'PROMPT_COMMAND="echo ----------------------------------------------------------"' >> ~/.bashrc

 # Add confirm commands
    sudo mv confirm.sh /usr/local/bin/confirm
    sudo mv confirm-ml /usr/local/bin/confirm-ml
 
# ----------------------------------------------------------
### Bash

 #### General
    git clone https://github.com/nigelpoulton/TheK8sBook.git

 #### Config
    # Enable time sync
    sudo systemctl enable systemd-timesyncd && sudo systemctl start systemd-timesyncd && timedatectl status

 #### Files
    export remote_path="ansible/webserver/"
    export file="test2.sh"
    export file="install_microk8s_to_custom_path.sh"

    ls -lh
    ls -lh /usr/bin/snap
    ls -lh $remote_path

    mkdir -p $path

    chmod +x $file
    chmod 600 "${remote_path}${$file}"
    chown -R ansible:ansible $remote_path
    sudo chmod -R u+w $remote_path

    ./$file

 #### Packages
    sudo apt-get update
    sudo apt-get upgrade

 #### System info
    cat /etc/os-release
    cat /etc/group

    ip a

    echo $PATH | tr ':' '\n'

    ps -aux --sort=%cpu
    ps -aux --sort=%mem

    df -h
    sudo lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL
    
    free -h

    date

 #### Reboot/Shutdown
    sudo shutdown -h now
    sudo reboot

# ----------------------------------------------------------
### SCP

    # Set vars
    $user="dietpi"; $public_ip="192.168.0.30"
    $file = "test.sh"
    $folder = "_includes"

    # Copy file from remote host
    scp $user@${public_ip}:$file .\

    # Copy file to remote host
    scp $file $user@${public_ip}:

    # Copy folder from remote host
    scp -r $user@${public_ip}:$folder .\

    # Copy folder to remote host
    scp -r $folder $user@${public_ip}:

# ----------------------------------------------------------
### Docker

 #### Setup
    curl https://get.docker.com | bash
    export docker_hub_user="aksenovfx"

 #### Images
    export image="flask_test2"
    export image2="flask_test"
    export image="$$docker_hub_user/maventest"

    docker pull $image

    cd $path
    docker build -t $image .

    docker inspect $image

 #### Containers
    docker run $image
    docker run --rm $image
    docker run --rm -d \
    -p 5432:5432 \
    -e POSTGRES_DB=db \
    -e POSTGRES_USER=user \
    -e POSTGRES_PASSWORD=password \
    $image

    docker run --rm -d \
    -p 8000:3000 \
    -e DATABASE_HOST=host.docker.internal \
    -e DATABASE_USER=user \
    -e DATABASE_PASSWORD=password \
    -e DATABASE_NAME=db \
    $image2

    export path_local="/home/user1/docker-course/workbooks/05-starter-code"
    export path_remote="/src/app/"
    export command="java -cp /src/app/JavaApp.jar JavaApp"
    docker run --rm -v $path_local:$path_remote $image $command

    docker commit existing-container-name new-image-name
    docker run -d -p 8080:80 new-image-name

 #### Container commands
    docker exec ubuntu-c ls -l

 #### Compose
    docker compose up -d
    docker compose stop
    docker compose start
    docker compose down

 #### Info
    docker ps -a
    docker logs 47f4d78a4174 --tail 10

 #### Cleanup
    docker stop 8b565f60649b0aa

    docker ps -q \
    --filter "ancestor=mysql/mysql-server:8.0" \
    xargs docker stop

    docker rm -f 2badb31af83c

    docker rmi $image

 #### Registry
    gpg --gen-key
    pass init <your_generated_gpg-id_public_key>

    docker login -u aksenovfx

    docker push $image

# ----------------------------------------------------------
### kubectl

 #### config
    # install kubectl
    # https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
    curl -LO https://dl.k8s.io/release/v1.32.0/bin/linux/amd64/kubectl
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    snap install kubectl --classic

 #### cluster info

    kubectl version --client
    kubectl config get-contexts
    kubectl cluster-info
    kubectl api-resources
    kubectl get nodes
    kubectl get pods --namespace kube-system
    kubectl get namespaces
    kubectl describe ns default
    kubectl get pods
    kubectl get services
    kubectl get rs

 #### pod info
    export pod="kubia"
    kubectl get pods $pod -o yaml

    # Spec - Desired state is in this block
    # Status - Observed state is in this block
    kubectl describe pod $pod

    # Get the logs from the first container in the Pod
    kubectl logs $pod

 #### Deployment info
    kubectl get deploy hello-deploy
    kubectl describe deploy hello-deploy

 #### Run
    kubectl run kubia --image=luksa/kubia --port=8080
    kubectl expose pod kubia --type=LoadBalancer --port=8080 --name kubia-http
    kubectl exec $pod -- ps
    kubectl exec -it hello-pod -- sh

 #### Apply
    export remote_path="TheK8sBook/deployments"
    cd $remote_path
    ls -lh
    confirm
    kubectl apply -f deploy.yml

 #### remove
    kubectl delete pod $pod
    kubectl delete service kubia-http
    microk8s kubectl delete namespace portainer

# ----------------------------------------------------------
### microk8s

 #### Config
    echo 'export PATH=$PATH:/snap/bin' >> ~/.bashrc
    sudo usermod -a -G microk8s dietpi && sudo chown -R dietpi ~/.kube

    microk8s config > client.config
    microk8s config > ~/.kube/config

 #### Enable Portainer
    sudo apt install -y git
    git config --global --add safe.directory /snap/microk8s/current/addons/community/.git
    microk8s enable community
    microk8s enable portainer

 #### Enable loadbalancer
    microk8s enable metallb:192.168.0.200-192.168.0.240

 #### Start/Stop
    microk8s stop
    microk8s start
    microk8s status

# ----------------------------------------------------------
### Ansible

 #### Info
    ansible -h

 #### Run modules
    ansible all -m ping
    ansible all -a hostname
    ansible all -m shell -a "hostname"
    ansible all -m copy -a "src=file.txt dest=dest.txt"
    ansible all -m service -a "name=httpd state=restarted"

 #### Playbooks
    ansible-playbook webserver-playbook.yml --syntax-check
    ansible-playbook webserver-playbook.yml

# ----------------------------------------------------------
### Temp