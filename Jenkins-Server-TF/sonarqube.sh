#!/bin/bash

apt update -y

apt install -y docker.io

systemctl enable docker
systemctl start docker

docker run -d \
--name sonarqube \
-p 9000:9000 \
sonarqube:lts-community
