#!/bin/bash
rm -rf /var/www/html/*
aws s3 cp s3://api-legacy/api.tar.gz /tmp
cd /tmp
tar xf api.tar.gz
mv /tmp/api/* /var/www/html/

chown www-data.www-data /var/www/html/storage/ -R
credstash -r eu-west-1 -t  api_stage_credstash_store getall --format dotenv > /var/www/html/.env

chmod 777 /var/www/html/storage/ -R

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
