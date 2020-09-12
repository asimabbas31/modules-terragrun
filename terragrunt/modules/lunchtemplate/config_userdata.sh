
aws s3 cp s3://api-legacy/api.tar.gz /tmp
cd /tmp
tar xf api.tar.gz
mv /tmp/api/* /var/www/html/

credstash -r eu-west-1 -t  api_stage_credstash_store getall --format dotenv > /var/www/html/.env


systemctl start apache2
cd /var/www/html/

