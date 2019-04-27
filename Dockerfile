FROM php:7.1-fpm-alpine
RUN apk update \
    && apk add git nginx \
    && apk add -U mysql-client ffmpeg nodejs python make gcc g++ \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
#    && composer global require hirak/prestissimo --no-plugins --no-scripts \
#    && curl -sL https://deb.nodesource.com/setup_6.x | bash - \
#    && apk add nodejs \
#    && apk add zlibc zlib1g zlib1g-dev \
#	&& apk add libxml2-dev libmcrypt-dev \
#	&& phpdismod xdebug \
#    && docker-php-ext-install exif iconv json pdo pdo_mysql mbstring zip tokenizer xml mcrypt \
#    && npm install -g bower yarn gulp \
    && cd /var/www/html/ \
    && git clone -q https://github.com/phanan/koel . \
#    && adduser --gecos '' --disabled-password koel \
#    && chown -R koel /var/www/html \
#    && su koel -c 'git config --global url."https://".insteadOf git://' \
#    && cd /var/www/html/ \
#	&& composer global require hirak/prestissimo --no-plugins --no-scripts \
#	&& yarn install && composer install \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /home/koel/.npm /root/.npm
ADD https://gist.githubusercontent.com/NamPNQ/719f40c58995e76a4388/raw /etc/nginx/sites-available/default
RUN chown -R www-data:www-data /var/www/html
CMD service nginx start && php-fpm
