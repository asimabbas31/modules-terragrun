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
rabbitmqctl add_user ${mquser} ${mqpassword}
rabbitmqctl set_user_tags ${mquser} administrator
rabbitmqctl delete_user guest
rabbitmqctl set_permissions -p / ${mquser} ".*" ".*" ".*"
rabbitmqadmin --host=${env}-mqapi.safeboda.com --port=15672 --username=${mquser} --password=${mqpassword} -V / declare exchange name=paygate_rmq_callback_q type=direct
rabbitmqadmin --host=${env}-mqapi.safeboda.com --port=15672 --username=${mquser} --password=${mqpassword} -V / declare exchange name=portal.bulk_actions_request_q type=topic
rabbitmqadmin --host=${env}-mqapi.safeboda.com --port=15672 --username=${mquser} --password=${mqpassword} -V / declare exchange name=sb-api-exchange type=direct
rabbitmqadmin --host=${env}-mqapi.safeboda.com --port=15672 --username=${mquser} --password=${mqpassword} -V / declare queue name=paygate_rmq_callback_q
rabbitmqadmin --host=${env}-mqapi.safeboda.com --port=15672 --username=${mquser} --password=${mqpassword} -V / declare queue name=sb-api-integration
rabbitmqadmin --host=${env}-mqapi.safeboda.com --port=15672 --username=${mquser} --password=${mqpassword} -V / declare queue name=portal.food_delivery_order
