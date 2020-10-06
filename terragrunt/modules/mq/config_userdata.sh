#!/bin/bash

apt update && sudo apt install wget -y
apt install apt-transport-https -y
wget -O- https://dl.bintray.com/rabbitmq/Keys/rabbitmq-release-signing-key.asc | sudo apt-key add -
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
echo "deb https://dl.bintray.com/rabbitmq-erlang/debian focal erlang-22.x" | sudo tee /etc/apt/sources.list.d/rabbitmq.list
apt update
apt install rabbitmq-server -y
systemctl is-enabled rabbitmq-server.service
systemctl enable rabbitmq-server
rabbitmq-plugins enable rabbitmq_management
ufw allow proto tcp from any to any port 5672,15672
rabbitmqctl add_user sb-admin hpAFj5JNvMxz9JuApBUz
rabbitmqctl set_user_tags sb-admin administrator
rabbitmqctl delete_user guest
