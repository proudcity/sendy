FROM php:5.6-apache

# install the PHP extensions we need
RUN apt-get update \
  && apt-get install -y --no-install-recommends vim libpng12-dev libjpeg-dev mysql-client unzip git libcurl4-openssl-dev libmcrypt-dev \
  && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
  && docker-php-ext-install gd mysqli opcache curl mcrypt \
  && a2enmod rewrite expires

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=60'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=1'; \
  } > /usr/local/etc/php/conf.d/opcache-recommended.ini

#COPY etc/apache-vhost.conf /etc/apache2/sites-enabled/000-default.conf
COPY etc/php.ini /usr/local/etc/php/php.ini

# Add cronjob
RUN apt-get update && apt-get -y install cron
COPY etc/crontab /etc/cron.d/sendy-cron
RUN chmod 0644 /etc/cron.d/sendy-cron
RUN touch /var/log/cron.log

# PHP base template
COPY . /var/www/html/
WORKDIR /var/www/html

# @todo: make this a persistent disk?
RUN mkdir -p /var/www/html/uploads
RUN chmod -R 777 /var/www/html/uploads

# Security
RUN chmod -R 000 etc etc-kube

CMD ["apache2-foreground"]
