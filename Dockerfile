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
#COPY etc/php.ini /usr/local/etc/php/php.ini

# PHP base template
COPY . /app
RUN rm -r /var/www/html
RUN ln -s /app /var/www/html
WORKDIR /app

CMD ["apache2-foreground"]
