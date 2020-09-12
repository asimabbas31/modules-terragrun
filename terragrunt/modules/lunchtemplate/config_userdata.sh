
aws s3 cp s3://${bucket_name}/${app}/api.tar.gz /tmp
cd /tmp
tar xf api.tar.gz
mv /tmp/api/* /var/www/html/

credstash -r eu-west-1 -t  api_stage_credstash_store getall --format dotenv > /var/www/html/.env


systemctl start apache2
cd /var/www/html/

php artisan queue:work redis --queue=async-commands,bonus-payment,cleanup,device-metadata,default,eta,food-delivery-order-pm,high,notification,order-payments,paygate_rmq_callback_q,paygate-topup,payment,place,projections,safeboda-api-queue,sms,transaction-update,upload-merchants
