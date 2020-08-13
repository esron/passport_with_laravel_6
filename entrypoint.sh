#!/bin/bash

composer install \

php artisan key:g \

chown www-data storage bootstrap/cache -R

update-alternatives --set php /usr/bin/php7.2

a2enmod php7.2

service apache2 restart

ln -sfn /app/public /var/www/dev

service apache2 start

tail -f /tmp/dev.log
