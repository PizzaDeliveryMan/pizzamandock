FROM php:7-fpm
RUN apt-get update \
    && apt-get install apt-utils git nginx -y \
    &&  curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && composer global require hirak/prestissimo --no-plugins --no-scripts \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs yarn \
    && apt-get install --reinstall zlibc zlib1g zlib1g-dev \
	&& apt-get install -y zip libzip-dev \
    && apt-get install -y libxml2-dev \
	&& docker-php-ext-configure zip --with-libzip \
	&& docker-php-ext-install zip \
	&& docker-php-ext-install exif \
	&& docker-php-ext-install fileinfo \
	&& docker-php-ext-install json \
	&& docker-php-ext-install simplexml \
    && apt-get clean \
    && docker-php-ext-install mbstring zip pdo pdo_mysql\
    && npm install -g bower gulp \
    && rm *.* && git clone -q --recursive https://github.com/phanan/koel . \
    && adduser --gecos '' --disabled-password koel \
    && chown -R koel /var/www/html \
    && su koel -c 'git config --global url."https://".insteadOf git:// \
    && cd /var/www/html/ && composer install' \
	# npm install
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /home/koel/.npm /root/.npm
ADD https://gist.githubusercontent.com/NamPNQ/719f40c58995e76a4388/raw /etc/nginx/sites-available/default
RUN chown -R www-data:www-data /var/www/html
CMD service nginx start && php-fpm