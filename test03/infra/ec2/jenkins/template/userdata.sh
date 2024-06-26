#!/bin/bash

sudo apt update -y
sudo apt install -y docker.io openjdk-17-jdk git ruby wget zip unzip curl

cd /home/ubuntu

# aws cli 설치
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install zip unzip -y
unzip awscliv2.zip
./aws/install

# JAVA_HOME 설정
echo 'export JAVA_HOME="/usr/lib/jvm/java-1.17.0-openjdk-amd64"' >> ./.bashrc
echo "export PATH=$PATH:$JAVA_HOME/bin" >> ./.bashrc
source ./.bashrc


# docker compose Download and install
sudo curl -L "https://github.com/docker/compose/releases/download/v2.1.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# docker 설정
sudo usermod -aG docker ubuntu
sudo systemctl enable docker
sudo systemctl start docker

# 원래 젠킨스에서 하던거
git clone https://github.com/wnsdh0202/aws-project.git
sudo chown -R ubuntu:ubuntu aws-project

cd /home/ubuntu/aws-project

chmod u+x install-docker.sh && sudo ./install-docker.sh
chmod u+x install-docker-compose.sh && sudo ./install-docker-compose.sh

sudo docker-compose up -d --build