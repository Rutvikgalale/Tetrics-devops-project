#!/bin/bash

# Update system
apt update -y

# Install Java 21
apt install -y fontconfig openjdk-21-jre
java -version

# Install Jenkins
mkdir -p /etc/apt/keyrings
wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null


apt update -y
apt install -y jenkins

systemctl enable jenkins
systemctl start jenkins

# Install Docker
apt install -y docker.io

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu
usermod -aG docker jenkins

chmod 666 /var/run/docker.sock
# Run SonarQube Container
#docker run -d \
#--name sonarqube \
#-p 9000:9000 \
#sonarqube:community
# Install Terraform
apt install -y unzip gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
| tee /etc/apt/sources.list.d/hashicorp.list

apt update -y
apt install -y terraform

terraform version

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

kubectl version --client

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip awscliv2.zip

./aws/install

aws --version

# Install Trivy
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | \
gpg --dearmor | \
tee /usr/share/keyrings/trivy.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | \
tee /etc/apt/sources.list.d/trivy.list

apt update -y
apt install -y trivy

trivy --version

echo "Installation completed successfully"
