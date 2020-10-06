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


curl -s https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg | sudo apt-key add -

echo "license_key: 447b2924c3d83133c6aff7e11e0e6571f679a2ec" | sudo tee -a /etc/newrelic-infra.yml
printf "deb [arch=amd64] https://download.newrelic.com/infrastructure_agent/linux/apt bionic main" | sudo tee -a /etc/apt/sources.list.d/newrelic-infra.list

apt-get update

apt-get install newrelic-infra -y

cat <<EOF > /etc/newrelic-infra/logging.d/test.sh
logs:
  - name: legacy-logs
    file: /var/www/html/storage/logs/*.log
EOF

systemctl restart newrelic-infra.service
