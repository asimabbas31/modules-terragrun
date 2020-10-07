#!/bin/bash
rm -rf /var/www/html/*
aws s3 cp s3://api-legacy/api.tar.gz /tmp
cd /tmp
tar xf api.tar.gz
mv /tmp/api/* /var/www/html/

chmod 777 /var/www/html/storage -R
chmod 777 /var/www/html/vendor -R

credstash -r eu-west-1 -t  api_stage_credstash_store getall --format dotenv > /var/www/html/.env


systemctl start apache2
cd /var/www/html/

php artisan queue:work redis --queue=bonus-payment --tries=1&
php artisan queue:work redis --queue=eta --tries=2&
php artisan queue:work redis --queue=food-delivery-order-pm --tries=2&
php artisan queue:work redis --queue=notification --tries=2&
php artisan queue:work redis --queue=order-payments --tries=2&
php artisan queue:work redis --queue=transaction-update --tries=2&
php artisan queue:work interop --queue=sb-api-integration --tries=1&


php artisan queue:work redis --queue=async-commands,bonus-payment,cleanup,device-metadata,default,eta,food-delivery-order-pm,high,notification,order-payments,paygate_rmq_callback_q,paygate-topup,payment,place,projections,safeboda-api-queue,sms,transaction-update,upload-merchants&

curl -s https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg | sudo apt-key add -

echo "license_key: 447b2924c3d83133c6aff7e11e0e6571f679a2ec" | sudo tee -a /etc/newrelic-infra.yml
printf "deb [arch=amd64] https://download.newrelic.com/infrastructure_agent/linux/apt bionic main" | sudo tee -a /etc/apt/sources.list.d/newrelic-infra.list

apt-get update

apt-get install newrelic-infra -y

cat <<EOF > /etc/newrelic-infra/logging.d/legacy.yml
logs:
  - name: legacy-logs
    file: /var/www/html/storage/logs/*.log
  - name: Apache-Logs
    file: /var/log/apache2/*.log
EOF

systemctl restart newrelic-infra.service
