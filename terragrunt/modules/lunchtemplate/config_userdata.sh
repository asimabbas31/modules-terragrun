#!/bin/bash
rm -rf /var/www/html/*
aws s3 cp s3://api-legacy/api.tar.gz /tmp
cd /tmp
tar xf api.tar.gz
mv /tmp/api/* /var/www/html/
rm -rf /tmp/api.tar.gz
credstash -r eu-west-1 -t  api_${env}_credstash_store getall --format dotenv > /var/www/html/.env
credstash -r eu-west-1 -t  api_${env}_credstash_store getall --format dotenv > /var/www/html/.env.default
systemctl start apache2
chown ubuntu:www-data /var/www/html/ -R
cd /var/www/html/

php artisan queue:work redis --queue=bonus-payment --tries=1&
php artisan queue:work redis --queue=eta --tries=2&
php artisan queue:work redis --queue=food-delivery-order-pm --tries=2&
php artisan queue:work redis --queue=notification --tries=2&
php artisan queue:work redis --queue=order-payments --tries=2&
php artisan queue:work redis --queue=transaction-update --tries=2&
php artisan queue:work interop --queue=sb-api-integration --tries=1&
php artisan queue:work redis --queue=sms --tries=1&
php artisan queue:work redis --queue=modules-terragrun-api-queue --tries=2&
php artisan queue:work redis --queue=async-commands --tries=2&
php artisan queue:work redis --queue=cleanup,device-metadata --tries=2&
php artisan queue:work redis --queue=default --tries=2&
php artisan queue:work redis --queue=high --tries=2&
php artisan queue:work interop --queue=paygate_rmq_callback_q --tries=1&
php artisan queue:work redis --queue=paygate-topup --tries=2&
php artisan queue:work redis --queue=payment --tries=1&
php artisan queue:work redis --queue=place --tries=2&
php artisan queue:work interop --queue=bulk_actions_request_q --tries=1&
php artisan queue:work redis --queue=projections --tries=2&
php artisan queue:work redis --queue=sms --tries=1&


curl -s https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg | sudo apt-key add -

echo "license_key: 447b2924c3d83133c6aff7e11e0e6571f679a2ec" | sudo tee -a /etc/newrelic-infra.yml
printf "deb [arch=amd64] https://download.newrelic.com/infrastructure_agent/linux/apt bionic main" | sudo tee -a /etc/apt/sources.list.d/newrelic-infra.list

apt-get update

apt-get install newrelic-infra -y

cat <<EOF > /etc/newrelic-infra/logging.d/legacy.yml
logs:
  - name: legacy-logs
    file: /var/www/html/storage/logs/io.log
    attributes:
      application: api
      env: ${env}
      logtype: io
EOF


cat <<EOF > /etc/newrelic-infra/logging.d/api.yml
logs:
  - name: legacy-logs
    file: /var/www/html/storage/logs/api.log
    attributes:
      application: api
      env: ${env}
      logtype: api
EOF

systemctl restart newrelic-infra.service
