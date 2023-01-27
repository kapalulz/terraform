#!/bin/bash
sudo apt update -y
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo docker run hello-world

# Linux post-install
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker

# Install Java SDK 11
sudo apt install -y openjdk-11-jdk

# Download and Install Jenkins
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt -y install jenkins

# Stop Jenkins
sudo systemctl stop jenkins

# Installing the unzip utility
sudo apt-get install unzip

#Jenkins CLI
myip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
echo "My WAN/Public IP address: ${myip}"

sudo mkdir /home/ubuntu/JenkinsBackup
sudo chmod 777 /home/ubuntu/JenkinsBackup
cd /home/ubuntu/JenkinsBackup
sudo wget http://$myip:8080/jnlpJars/jenkins-cli.jar

#Download Backup.zip -> Unzip-> Copy to jenkins folder. Delete trash.
wget https://github.com/kapalulz/jenkins_gitPush_addon/archive/refs/heads/main.zip
sudo unzip main.zip
sudo cp -r /home/ubuntu/JenkinsBackup/jenkins_gitPush_addon-main/JenkinsBackup/*  /var/lib/jenkins/

# Start Jenkins
sudo systemctl start jenkins

# Enable Jenkins to run on Boot
sudo systemctl enable jenkins

# AWS CLI
sudo apt-get update && sudo apt-get -y upgrade
sudo apt-get install python-pip
sudo apt-get install awscli

#Cat without login InitialAdminPassword For Jenkins.
echo sudo cat /var/lib/jenkins/secrets/initialAdminPassword >> /home/ubuntu/.bashrc

sudo rm main.zip
sudo rm -r /home/ubuntu/JenkinsBackup